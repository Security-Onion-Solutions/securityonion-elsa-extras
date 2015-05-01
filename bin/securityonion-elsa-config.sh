#!/bin/bash

LOG_DIR="/var/log/nsm"
mkdir -p $LOG_DIR
LOG="$LOG_DIR/securityonion-elsa-config.log"
LOGGER="tee -a $LOG"
BASE_DIR="/opt"
DATA_DIR="/nsm/elsa/data"

function check_config_perms {
	GROUP_NAME="securityonion"
	if [ -d /var/lib/mysql/snorby/ ]; then 
        	SSH_USERS=`grep -l "root@" /home/*/.ssh/authorized_keys |cut -d\/ -f3`
	fi
    
	awk -F: -v group="$GROUP_NAME" '{ if ($1 == group) exit 5}' /etc/group
	if [ $? -eq 5 ]; then
        	echo "Group exists. Checking Membership." | $LOGGER
        	GROUP_MEMBERSHIP=`grep "^$GROUP_NAME:" /etc/group`
        	for word in $SSH_USERS; do
            		echo "Checking for $word in $GROUP_MEMBERSHIP" | $LOGGER
            		if echo $GROUP_MEMBERSHIP | grep $word; then
                		echo "User found in $GROUP_MEMBERSHIP" | $LOGGER
            		else
                		echo "User not found in $GROUP_MEMBERSHIP" | $LOGGER
                		usermod -a -G $GROUP_NAME $word
            		fi
        	done
    	else
        	echo "Group does not exist. Adding the group and populating members." | $LOGGER
        	groupadd $GROUP_NAME
        	for word in $SSH_USERS; do
            		usermod -a -G $GROUP_NAME $word
        	done
    	fi

    	# Check the permissions on ELSA's file.
    	ELSA_CONFIGS="elsa_web.conf elsa_node.conf"
    	for conf in $ELSA_CONFIGS; do
        	FPERM=`stat -Lc "%a" /etc/$conf`
        	FGRUP=`stat -Lc "%G" /etc/$conf`
        	FUSER=`stat -Lc "%U" /etc/$conf`
        	if [ $FGRUP = $GROUP_NAME ]; then
            		echo "/etc/$conf has the correct group." | $LOGGER
        	else
            		echo "/etc/$conf has the incorrect group." | $LOGGER
            		chgrp $GROUP_NAME /etc/$conf
        	fi
        	chmod 664 /etc/$conf
	done
    	ELSA_REG_LOG_DIR="/var/log/nsm/so-elsa"
    	if [ ! -d $ELSA_REG_LOG_DIR ]; then
        	echo "* Adding $ELSA_REG_LOG_DIR" | $LOGGER
        	mkdir -p $ELSA_REG_LOG_DIR;
    	fi
   	chgrp securityonion $ELSA_REG_LOG_DIR
    	chmod -R g+w $ELSA_REG_LOG_DIR
}

function config_lognode() {
	echo "* Placing syslog-ng config" | $LOGGER
	cp "$BASE_DIR/elsa/contrib/securityonion/contrib/securityonion-syslog-ng.conf" /etc/syslog-ng/syslog-ng.conf
	echo "* Building elsa directories" | $LOGGER
	mkdir -p "$DATA_DIR/elsa/log"
	mkdir -p "$DATA_DIR/elsa/tmp/buffers"
	mkdir -p "$DATA_DIR/sphinx/log"
	echo "* Placing ELSA log node config file" | $LOGGER
	cat "$BASE_DIR/elsa/contrib/securityonion/contrib/securityonion-elsa-node.conf" | sed -e "s|\/data|$DATA_DIR|g" > /etc/elsa_node.conf
	# Adjust the pid to the correct location
	sed -i "s|\"pid_file\": \"/var/run/searchd.pid\"|\"pid_file\": \"/var/run/sphinxsearch/searchd.pid\"|" /etc/elsa_node.conf
	echo "* Beginning node configuration." | $LOGGER

	echo "* Creating /nsm/elsa/data/elsa/mysql" | $LOGGER
	mkdir -p /nsm/elsa/data/elsa/mysql
	chown -R mysql /nsm/elsa/data/elsa/mysql

	echo "* Creating locks directory" | $LOGGER
	mkdir -p /opt/elsa/node/tmp/locks
	touch /opt/elsa/node/tmp/locks/directory
	touch /opt/elsa/node/tmp/locks/query

	echo "* Configuring apparmor for ELSA" | $LOGGER
	if [ -f /etc/apparmor.d/local/usr.sbin.mysqld ]; then
        	grep "/nsm/elsa/data/elsa/mysql/" /etc/apparmor.d/local/usr.sbin.mysqld;
        	if [ $? -ne 0 ]; then
            		echo "  /nsm/elsa/data/elsa/mysql/ r,"  >> /etc/apparmor.d/local/usr.sbin.mysqld;
            		echo "  /nsm/elsa/data/elsa/mysql/** rwk,"  >> /etc/apparmor.d/local/usr.sbin.mysqld;
            		sh /etc/init.d/apparmor reload
        	fi
	fi

	touch /etc/sphinxsearch/sphinx_stopwords.txt

	echo "* Adding Sphinx to startup" | $LOGGER
	update-rc.d sphinxsearch defaults

	echo "* Adding Syslog-ng to startup" | $LOGGER
	update-rc.d syslog-ng defaults

	echo "* Adding basic ELSA schema" | $LOGGER
	mysqladmin -uroot $MYSQL_PORT create syslog
	mysqladmin -uroot $MYSQL_PORT create syslog_data
	mysql -uroot $MYSQL_PORT -e 'GRANT ALL ON syslog.* TO "elsa"@"localhost" IDENTIFIED BY "biglog"'
	mysql -uroot $MYSQL_PORT -e 'GRANT ALL ON syslog.* TO "elsa"@"%" IDENTIFIED BY "biglog"'
	mysql -uroot $MYSQL_PORT -e 'GRANT ALL ON syslog_data.* TO "elsa"@"localhost" IDENTIFIED BY "biglog"' 
	mysql -uroot $MYSQL_PORT -e 'GRANT ALL ON syslog_data.* TO "elsa"@"%" IDENTIFIED BY "biglog"'
	mysql -uelsa $MYSQL_PORT -pbiglog syslog -e "source $BASE_DIR/elsa/contrib/securityonion/contrib/securityonion-elsa-schema.sql"

	echo "* Adding custom parser schema" | $LOGGER
	sh /opt/elsa/contrib/securityonion/contrib/securityonion_parsers_sql.sh

	echo "* Merging new parsers into patterndb.xml." | $LOGGER
	PATTERNS_DIR=/etc/elsa/patterns.d/
	DEST_PATTERN=/opt/elsa/node/conf/patterndb.xml
	cp $DEST_PATTERN $DEST_PATTERN.bak
	pdbtool merge -p $DEST_PATTERN --recursive -D $PATTERNS_DIR

	if [ -f /etc/sphinxsearch/sphinx.conf ] ; then
		echo "* Moving current sphinx.conf file to sphinx.bak" | $LOGGER
		mv /etc/sphinxsearch/sphinx.conf /etc/sphinxsearch/sphinx.bak
	fi

	echo "* Placing Sphinx Config file." | $LOGGER
	echo "" | perl "$BASE_DIR/elsa/node/elsa.pl" -on -c /etc/elsa_node.conf

	# Ensure the correct pid file
	sed -i "s|pid_file = /var/run/searchd.pid|pid_file = /var/run/sphinxsearch/searchd.pid|" /etc/sphinxsearch/sphinx.conf
	# Correct the max_matches entry
	sed -i 's|max_matches = 1000|max_matches = 10000|' /etc/sphinxsearch/sphinx.conf

	# Set up directory locks
	mkdir -p "$BASE_DIR/elsa/node/tmp/locks"
	touch "$BASE_DIR/elsa/node/tmp/locks/directory"

	echo "* Configuring logrotate for ELSA" | $LOGGER
	cp /opt/elsa/contrib/securityonion/contrib/elsa.logrotate /etc/logrotate.d/elsa
	
	echo "* Initializing empty sphinx indexes" | $LOGGER
	/usr/bin/indexer --config "/etc/sphinxsearch/sphinx.conf" --rotate --all > $LOG_DIR/sphinx_initialization.log

	echo "* Setting START=yes in /etc/default/sphinxsearch" | $LOGGER
	sed -i 's|START=no|START=yes|g' /etc/default/sphinxsearch
	
	echo "* Applying permissions to $DATA_DIR/sphinx" | $LOGGER
	chown -R sphinxsearch $DATA_DIR/sphinx
	echo "* Applying permissions to $DATA_DIR/elsa/log/" | $LOGGER
	chgrp -R sphinxsearch $DATA_DIR/elsa/log/
	chmod -R g+rwx $DATA_DIR/elsa/log/

	if [ ! -d /var/run/sphinxsearch ]; then 
        	echo "* Creating sphinx PID directory." | $LOGGER
        	mkdir -p /var/run/sphinxsearch
        	echo "* Applying permissions to PID directory." | $LOGGER
        	chown sphinxsearch /var/run/sphinxsearch
        	chgrp sphinxsearch /var/run/sphinxsearch
	fi

	echo "* Restarting Sphinx" | $LOGGER
	service sphinxsearch restart

	# Start syslog-ng using the ELSA config
	HTTP_LOGS=""
	SENSORS=$(grep -v "^#" /etc/nsm/sensortab | cut -f 4)
	COUNT=0
	for token in $SENSORS; do
		COUNT=$((COUNT+1))
	done
	echo $COUNT
	
	if [ $COUNT -eq 1 ]; then
		if grep "type=standalone" /opt/bro/etc/node.cfg > /dev/null; then
			echo "* Leaving syslog-ng.conf bro_http entry unmolested." | $LOGGER
		else
			echo "* Altering syslog-ng.conf bro_http entry for single interface cluster-mode" | $LOGGER
			# Pull the interface bro is listening for from node.cfg
			BRO_IFACE=$(grep "interface=" /opt/bro/etc/node.cfg | cut -d'=' -f2)
			# Alter syslog-ng.conf's entry for http
			sed -e "s|^\tfile(\"/nsm/bro/logs/current/http.log\".*|\tfile(\"/nsm/bro/logs/current/http_$BRO_IFACE.log\" flags(no-parse) program_override(\"bro_http\"));\n|" /opt/elsa/contrib/securityonion/contrib/securityonion-syslog-ng.conf > /etc/syslog-ng/syslog-ng.conf
		fi
	fi
	
	if [ $COUNT -gt 1 ]; then
		echo "* Altering syslog-ng.conf bro_http entries for multiple interfaces" | $LOGGER
		for i in $SENSORS; do
			HTTP_LOGS=$HTTP_LOGS"\tfile(\"/nsm/bro/logs/current/http_$i.log\" flags(no-parse) program_override(\"bro_http\"));\n"
		done
		sed -e "s|^\tfile(\"/nsm/bro/logs/current/http.log\".*|$HTTP_LOGS|" /opt/elsa/contrib/securityonion/contrib/securityonion-syslog-ng.conf > /etc/syslog-ng/syslog-ng.conf
	fi

	echo "* Restarting syslog-ng" | $LOGGER
	service syslog-ng restart
	
	ELSA_REG_LOG_DIR="/var/log/nsm/so-elsa"
	if [ ! -d $ELSA_REG_LOG_DIR ]; then
        	echo "* Adding $ELSA_REG_LOG_DIR" | $LOGGER
        	mkdir -p $ELSA_REG_LOG_DIR;
	fi
}

function config_webnode() {
	echo "* Placing ELSA Web Config file" | $LOGGER
	cat "$BASE_DIR/elsa/contrib/securityonion/contrib/securityonion-elsa-web.conf" | sed -e "s|\/data|$DATA_DIR|g" > /etc/elsa_web.conf
	echo "* Placing pcap_url directive" | $LOGGER
	if grep "pcap_url\": \"http://streamdb" /etc/elsa_web.conf > /dev/null;  then
		echo "* Adding pcap_url directive"  | $LOGGER
		IP=`ifconfig | grep "inet addr" | awk '{print $2}' | cut -d\: -f2 | grep -v "127.0.0.1" | head -1`
		sed -i "s/^.*\"pcap_url\": \"http\:\/\/streamdb\",.*$/\t\"pcap_url\": \"https:\/\/$IP\/capme\",/" /etc/elsa_web.conf
	fi   
	echo "* Beginning Web Install:" | $LOGGER
	echo "* Configuring mysql schema" | $LOGGER
	mysqladmin -uroot $MYSQL_PORT create elsa_web 
	mysql -uroot $MYSQL_PORT -e "GRANT ALL ON elsa_web.* TO \"elsa\"@\"localhost\" IDENTIFIED BY \"biglog\"" 
	mysql -uroot $MYSQL_PORT -e "GRANT ALL ON elsa_web.* TO \"elsa\"@\"%\" IDENTIFIED BY \"biglog\"" 
	mysql -uelsa $MYSQL_PORT -pbiglog elsa_web -e "source $BASE_DIR/elsa/web/conf/meta_db_schema.mysql"

	# Activate ELSA and restart Apache
	cp /opt/elsa/contrib/securityonion/contrib/securityonion_apache_site.conf /etc/apache2/sites-available/elsa	
	echo "* Configuring ELSA with Apache" | $LOGGER
	a2ensite elsa 
	#a2dissite default 
	a2enmod rewrite
	touch $DATA_DIR/elsa/log/web.log
	chown -R www-data $DATA_DIR/elsa/log
	apache2ctl restart

	echo "* Adding cron entry for alerts..." | $LOGGER
	cp /opt/elsa/contrib/securityonion/contrib/elsa.cron /etc/cron.d/elsa

	echo "* Restarting cron" | $LOGGER
	service cron restart

	echo "* Opening 3154/tcp.." | $LOGGER
	ufw allow 3154/tcp

	echo "* Retrieving GeoIP City databases..."	 | $LOGGER
	mkdir -p /usr/local/share/GeoIP 
	curl -L "http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz" > /tmp/GeoLiteCity.dat.gz 
	echo "* Unpacking GeoIP gzip file" | $LOGGER
	gunzip /tmp/GeoLiteCity.dat.gz 
	cp /tmp/GeoLiteCity.dat /usr/local/share/GeoIP/GeoIPCity.dat
	echo "* Retrieving GeoIP Country databases..." | $LOGGER
	curl -L "http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz" > /tmp/GeoIP.dat.gz 
	echo "* Unpacking GeoIP gzip file" | $LOGGER
	gunzip /tmp/GeoIP.dat.gz 
	cp /tmp/GeoIP.dat /usr/local/share/GeoIP/ 
	echo "...done." | $LOGGER
}

function config_lognode_webapi() {

	echo "* Configuring Web API and Starman." | $LOGGER
	echo "* Placing starman init file." | $LOGGER
	cp /opt/elsa/contrib/securityonion/contrib/securityonion_starman_init.sh /etc/init.d/starman
	chmod 744 /etc/init.d/starman

	echo "* Adding starman to defaults." | $LOGGER
	update-rc.d starman defaults

	echo "* Placing elsa_web.conf file." | $LOGGER
	cat "$BASE_DIR/elsa/contrib/securityonion/contrib/securityonion-elsa-api.conf" | sed -e "s|\/data|$DATA_DIR|g" > /etc/elsa_web.conf

	echo "* Configuring mysql schema" | $LOGGER
	mysqladmin -uroot $MYSQL_PORT create elsa_web 
	mysql -uroot $MYSQL_PORT -e "GRANT ALL ON elsa_web.* TO \"elsa\"@\"localhost\" IDENTIFIED BY \"biglog\"" 
	mysql -uroot $MYSQL_PORT -e "GRANT ALL ON elsa_web.* TO \"elsa\"@\"%\" IDENTIFIED BY \"biglog\"" 
	mysql -uelsa $MYSQL_PORT -pbiglog elsa_web -e "source $BASE_DIR/elsa/web/conf/meta_db_schema.mysql"
    
	echo "* Starting starman on port 3154" | $LOGGER
	touch $DATA_DIR/elsa/log/web.log
	chown -R www-data $DATA_DIR/elsa/log
	/etc/init.d/starman start
    
	echo "* Adding cron entry for alerts..." | $LOGGER
	cp /opt/elsa/contrib/securityonion/contrib/elsa.cron /etc/cron.d/elsa
	service cron restart

	echo "* Retrieving GeoIP City databases..."	 | $LOGGER
	mkdir -p /usr/local/share/GeoIP 
	curl -L "http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz" > /tmp/GeoLiteCity.dat.gz 
	echo "* Unpacking GeoIP gzip file" | $LOGGER
	gunzip /tmp/GeoLiteCity.dat.gz 
	cp /tmp/GeoLiteCity.dat /usr/local/share/GeoIP/GeoIPCity.dat
	echo "* Retrieving GeoIP Country databases..." | $LOGGER
	curl -L "http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz" > /tmp/GeoIP.dat.gz 
	echo "* Unpacking GeoIP gzip file" | $LOGGER
	gunzip /tmp/GeoIP.dat.gz 
	cp /tmp/GeoIP.dat /usr/local/share/GeoIP/ 
	echo "...done." | $LOGGER
}


# Parse command line options with getopts
while getopts "ht:" flag
do
    case $flag in
	    t)
	        NODE_TYPE=$OPTARG;;
	    h)
	        SHOW_HELP=1;;
    esac
done

if [[ -n $SHOW_HELP ]]; then
    echo "Usage:"
    echo "-t LOG : Activate ELSA as a Log Node"
    echo "-t WEB : Activate ELSA as a Web Node"
    echo "-t API : Upgrade ELSA to a Web Node"
    echo
    exit 2
fi

echo "Beginning installation for ELSA $NODE_TYPE node." | $LOGGER
if [ "$NODE_TYPE" = "LOG" ]; then

	# Reconfigure MYSQL to run on 50000/tcp
	echo "* Reconfiguring mysql to use port 50000/tcp" | $LOGGER
	cp /etc/mysql/my.cnf /etc/mysql/my.cnf.bak
	sed -i '38,38 s/port\s*\s*= 3306/port \t\t= 50000/' /etc/mysql/my.cnf
	service mysql restart

	MYSQL_PORT="-P50000"
	config_lognode

	if [ ! -e /var/lib/mysql/snorby ]; then
		sed -i "s,\"db\": \"syslog\"\,,\"db\": \"syslog\,port=50000\"\,," /etc/elsa_node.conf
	fi
	# Configure the Web API features for log nodes.
	config_lognode_webapi

elif [ "$NODE_TYPE" = "WEB" ]; then

	MYSQL_PORT="-P3306"
	config_lognode
	config_webnode
	check_config_perms
	# Randomize the API key for master nodes.
	/usr/bin/securityonion_elsa_register.rb --random-apikey

elif [ "$NODE_TYPE" = "API" ]; then

	MYSQL_PORT="-P50000"
	config_lognode_webapi
fi

