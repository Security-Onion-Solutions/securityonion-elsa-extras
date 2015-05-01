Description: <short summary of the patch>
 TODO: Put a short summary on the line above and replace this paragraph
 with a longer explanation of this change. Complete the meta-information
 with other relevant fields (see below for details). To make it easier, the
 information below has been extracted from the changelog. Adjust it or drop
 it.
 .
 securityonion-elsa-extras (20131117-1ubuntu0securityonion71) precise; urgency=low
 .
   * fix database schema for new installs and clean up securityonion-elsa-config.sh
Author: Doug Burks <doug.burks@gmail.com>

---
The information above should follow the Patch Tagging Guidelines, please
checkout http://dep.debian.net/deps/dep3/ to learn about the format. Here
are templates for supplementary fields that you might want to add:

Origin: <vendor|upstream|other>, <url of original patch>
Bug: <url in upstream bugtracker>
Bug-Debian: http://bugs.debian.org/<bugnumber>
Bug-Ubuntu: https://launchpad.net/bugs/<bugnumber>
Forwarded: <no|not-needed|url proving that it has been forwarded>
Reviewed-By: <name and email of someone who approved the patch>
Last-Update: <YYYY-MM-DD>

--- securityonion-elsa-extras-20131117.orig/bin/securityonion-elsa-config.sh
+++ securityonion-elsa-extras-20131117/bin/securityonion-elsa-config.sh
@@ -5,59 +5,58 @@ LOGGER="tee -a $LOG"
 BASE_DIR="/opt"
 DATA_DIR="/nsm/elsa/data"
 
-
 function check_config_perms {
-    GROUP_NAME="securityonion"
-    if [ -d /var/lib/mysql/snorby/ ]; then 
-        SSH_USERS=`grep -l "root@" /home/*/.ssh/authorized_keys |cut -d\/ -f3`
-    fi
+	GROUP_NAME="securityonion"
+	if [ -d /var/lib/mysql/snorby/ ]; then 
+        	SSH_USERS=`grep -l "root@" /home/*/.ssh/authorized_keys |cut -d\/ -f3`
+	fi
     
-    awk -F: -v group="$GROUP_NAME" '{ if ($1 == group) exit 5}' /etc/group
-    if [ $? -eq 5 ]; then
-        echo "Group exists. Checking Membership." | $LOGGER
-        GROUP_MEMBERSHIP=`grep "^$GROUP_NAME:" /etc/group`
-        for word in $SSH_USERS; do
-            echo "Checking for $word in $GROUP_MEMBERSHIP" | $LOGGER
-            if echo $GROUP_MEMBERSHIP | grep $word; then
-                echo "User found in $GROUP_MEMBERSHIP" | $LOGGER
-            else
-                echo "User not found in $GROUP_MEMBERSHIP" | $LOGGER
-                usermod -a -G $GROUP_NAME $word
-            fi
-        done
-    else
-        echo "Group does not exist. Adding the group and populating members." | $LOGGER
-        groupadd $GROUP_NAME
-        for word in $SSH_USERS; do
-            usermod -a -G $GROUP_NAME $word
-        done
-    fi
-
-    # Check the permissions on ELSA's file.
-    ELSA_CONFIGS="elsa_web.conf elsa_node.conf"
-    for conf in $ELSA_CONFIGS; do
-        FPERM=`stat -Lc "%a" /etc/$conf`
-        FGRUP=`stat -Lc "%G" /etc/$conf`
-        FUSER=`stat -Lc "%U" /etc/$conf`
-        if [ $FGRUP = $GROUP_NAME ]; then
-            echo "/etc/$conf has the correct group." | $LOGGER
-        else
-            echo "/etc/$conf has the incorrect group." | $LOGGER
-            chgrp $GROUP_NAME /etc/$conf
-        fi
-        chmod 664 /etc/$conf
-    done
-    ELSA_REG_LOG_DIR="/var/log/nsm/so-elsa"
-    if [ ! -d $ELSA_REG_LOG_DIR ]; then
-        echo "* Adding $ELSA_REG_LOG_DIR" | $LOGGER
-        mkdir -p $ELSA_REG_LOG_DIR;
-    fi
-    chgrp securityonion $ELSA_REG_LOG_DIR
-    chmod -R g+w $ELSA_REG_LOG_DIR
+	awk -F: -v group="$GROUP_NAME" '{ if ($1 == group) exit 5}' /etc/group
+	if [ $? -eq 5 ]; then
+        	echo "Group exists. Checking Membership." | $LOGGER
+        	GROUP_MEMBERSHIP=`grep "^$GROUP_NAME:" /etc/group`
+        	for word in $SSH_USERS; do
+            		echo "Checking for $word in $GROUP_MEMBERSHIP" | $LOGGER
+            		if echo $GROUP_MEMBERSHIP | grep $word; then
+                		echo "User found in $GROUP_MEMBERSHIP" | $LOGGER
+            		else
+                		echo "User not found in $GROUP_MEMBERSHIP" | $LOGGER
+                		usermod -a -G $GROUP_NAME $word
+            		fi
+        	done
+    	else
+        	echo "Group does not exist. Adding the group and populating members." | $LOGGER
+        	groupadd $GROUP_NAME
+        	for word in $SSH_USERS; do
+            		usermod -a -G $GROUP_NAME $word
+        	done
+    	fi
+
+    	# Check the permissions on ELSA's file.
+    	ELSA_CONFIGS="elsa_web.conf elsa_node.conf"
+    	for conf in $ELSA_CONFIGS; do
+        	FPERM=`stat -Lc "%a" /etc/$conf`
+        	FGRUP=`stat -Lc "%G" /etc/$conf`
+        	FUSER=`stat -Lc "%U" /etc/$conf`
+        	if [ $FGRUP = $GROUP_NAME ]; then
+            		echo "/etc/$conf has the correct group." | $LOGGER
+        	else
+            		echo "/etc/$conf has the incorrect group." | $LOGGER
+            		chgrp $GROUP_NAME /etc/$conf
+        	fi
+        	chmod 664 /etc/$conf
+	done
+    	ELSA_REG_LOG_DIR="/var/log/nsm/so-elsa"
+    	if [ ! -d $ELSA_REG_LOG_DIR ]; then
+        	echo "* Adding $ELSA_REG_LOG_DIR" | $LOGGER
+        	mkdir -p $ELSA_REG_LOG_DIR;
+    	fi
+   	chgrp securityonion $ELSA_REG_LOG_DIR
+    	chmod -R g+w $ELSA_REG_LOG_DIR
 }
 
 function config_lognode() {
-	echo "* Placing syslog-ng config"
+	echo "* Placing syslog-ng config" | $LOGGER
 	cp "$BASE_DIR/elsa/contrib/securityonion/contrib/securityonion-syslog-ng.conf" /etc/syslog-ng/syslog-ng.conf
 	echo "* Building elsa directories" | $LOGGER
 	mkdir -p "$DATA_DIR/elsa/log"
@@ -69,95 +68,90 @@ function config_lognode() {
 	sed -i "s|\"pid_file\": \"/var/run/searchd.pid\"|\"pid_file\": \"/var/run/sphinxsearch/searchd.pid\"|" /etc/elsa_node.conf
 	echo "* Beginning node configuration." | $LOGGER
 
-    echo "* Creating /nsm/elsa/data/elsa/mysql" | $LOGGER
-    mkdir -p /nsm/elsa/data/elsa/mysql
-    chown -R mysql /nsm/elsa/data/elsa/mysql
-
-    echo "* Creating locks directory" | $LOGGER
-    mkdir -p /opt/elsa/node/tmp/locks
-    touch /opt/elsa/node/tmp/locks/directory
-    touch /opt/elsa/node/tmp/locks/query
-
-    echo "* Configuring apparmor for ELSA" | $LOGGER
-    if [ -f /etc/apparmor.d/local/usr.sbin.mysqld ]; then
-        grep "/nsm/elsa/data/elsa/mysql/" /etc/apparmor.d/local/usr.sbin.mysqld;
-        if [ $? -ne 0 ]; then
-            echo "  /nsm/elsa/data/elsa/mysql/ r,"  >> /etc/apparmor.d/local/usr.sbin.mysqld;
-            echo "  /nsm/elsa/data/elsa/mysql/** rwk,"  >> /etc/apparmor.d/local/usr.sbin.mysqld;
-            sh /etc/init.d/apparmor reload
-        fi
-    fi
+	echo "* Creating /nsm/elsa/data/elsa/mysql" | $LOGGER
+	mkdir -p /nsm/elsa/data/elsa/mysql
+	chown -R mysql /nsm/elsa/data/elsa/mysql
+
+	echo "* Creating locks directory" | $LOGGER
+	mkdir -p /opt/elsa/node/tmp/locks
+	touch /opt/elsa/node/tmp/locks/directory
+	touch /opt/elsa/node/tmp/locks/query
+
+	echo "* Configuring apparmor for ELSA" | $LOGGER
+	if [ -f /etc/apparmor.d/local/usr.sbin.mysqld ]; then
+        	grep "/nsm/elsa/data/elsa/mysql/" /etc/apparmor.d/local/usr.sbin.mysqld;
+        	if [ $? -ne 0 ]; then
+            		echo "  /nsm/elsa/data/elsa/mysql/ r,"  >> /etc/apparmor.d/local/usr.sbin.mysqld;
+            		echo "  /nsm/elsa/data/elsa/mysql/** rwk,"  >> /etc/apparmor.d/local/usr.sbin.mysqld;
+            		sh /etc/init.d/apparmor reload
+        	fi
+	fi
 
 	touch /etc/sphinxsearch/sphinx_stopwords.txt
+
 	echo "* Adding Sphinx to startup" | $LOGGER
 	update-rc.d sphinxsearch defaults
 
 	echo "* Adding Syslog-ng to startup" | $LOGGER
 	update-rc.d syslog-ng defaults
 
+	echo "* Adding basic ELSA schema" | $LOGGER
 	mysqladmin -uroot $MYSQL_PORT create syslog
 	mysqladmin -uroot $MYSQL_PORT create syslog_data
 	mysql -uroot $MYSQL_PORT -e 'GRANT ALL ON syslog.* TO "elsa"@"localhost" IDENTIFIED BY "biglog"'
 	mysql -uroot $MYSQL_PORT -e 'GRANT ALL ON syslog.* TO "elsa"@"%" IDENTIFIED BY "biglog"'
 	mysql -uroot $MYSQL_PORT -e 'GRANT ALL ON syslog_data.* TO "elsa"@"localhost" IDENTIFIED BY "biglog"' 
 	mysql -uroot $MYSQL_PORT -e 'GRANT ALL ON syslog_data.* TO "elsa"@"%" IDENTIFIED BY "biglog"'
+	mysql -uelsa $MYSQL_PORT -pbiglog syslog -e "source $BASE_DIR/elsa/contrib/securityonion/contrib/sql/elsa_orig.sql"
+
+	echo "* Adding custom parser schema" | $LOGGER
+	sh /opt/elsa/contrib/securityonion/contrib/securityonion_parsers_sql.sh
+
+	echo "* Merging new parsers into patterndb.xml." | $LOGGER
+	PATTERNS_DIR=/etc/elsa/patterns.d/
+	DEST_PATTERN=/opt/elsa/node/conf/patterndb.xml
+	cp $DEST_PATTERN $DEST_PATTERN.bak
+	pdbtool merge -p $DEST_PATTERN --recursive -D $PATTERNS_DIR
 
-	# Above could fail with db already exists, but this is the true test for success
-	mysql -uelsa $MYSQL_PORT -pbiglog syslog -e "source $BASE_DIR/elsa/node/conf/schema.sql"
 	if [ -f /etc/sphinxsearch/sphinx.conf ] ; then
 		echo "* Moving current sphinx.conf file to sphinx.bak" | $LOGGER
 		mv /etc/sphinxsearch/sphinx.conf /etc/sphinxsearch/sphinx.bak
 	fi
 
-    echo "* Adding custom parsers" | $LOGGER
-    sh /opt/elsa/contrib/securityonion/contrib/securityonion_parsers_sql.sh
-
-    echo "* Merging new parsers into patterndb.xml."
-    PATTERNS_DIR=/etc/elsa/patterns.d/
-    DEST_PATTERN=/opt/elsa/node/conf/patterndb.xml
-    cp $DEST_PATTERN $DEST_PATTERN.bak
-    pdbtool merge -p $DEST_PATTERN --recursive -D $PATTERNS_DIR
-
 	echo "* Placing Sphinx Config file." | $LOGGER
-	# Create the initial sphinx.conf file
 	echo "" | perl "$BASE_DIR/elsa/node/elsa.pl" -on -c /etc/elsa_node.conf
 
-    # Ensure the correct pid file
+	# Ensure the correct pid file
 	sed -i "s|pid_file = /var/run/searchd.pid|pid_file = /var/run/sphinxsearch/searchd.pid|" /etc/sphinxsearch/sphinx.conf
-    # Correct the max_matches entry
-    sed -i 's|max_matches = 1000|max_matches = 10000|' /etc/sphinxsearch/sphinx.conf
+	# Correct the max_matches entry
+	sed -i 's|max_matches = 1000|max_matches = 10000|' /etc/sphinxsearch/sphinx.conf
 
 	# Set up directory locks
 	mkdir -p "$BASE_DIR/elsa/node/tmp/locks"
 	touch "$BASE_DIR/elsa/node/tmp/locks/directory"
 
-	# Add logrotate for ELSAs logfiles.
-	echo "* Configuring logrotate for ELSA"
+	echo "* Configuring logrotate for ELSA" | $LOGGER
 	cp /opt/elsa/contrib/securityonion/contrib/elsa.logrotate /etc/logrotate.d/elsa
 	
-	# Initialize empty sphinx indexes
+	echo "* Initializing empty sphinx indexes" | $LOGGER
 	/usr/bin/indexer --config "/etc/sphinxsearch/sphinx.conf" --rotate --all
 
+	echo "* Setting START=yes in /etc/default/sphinxsearch" | $LOGGER
 	sed -i 's|START=no|START=yes|g' /etc/default/sphinxsearch
 	
-	# The next few lines were in the elsa_web section.
-	# When configuring ELSA log node only (no web node),
-	# sphinx would fail to start on boot.
-	# I've moved these lines to the elsa_node section to resolve this.
-	# Doug Burks
-	# Apply correct permissions to /nsm/elsa/data/sphinx
+	echo "* Applying permissions to $DATA_DIR/sphinx" | $LOGGER
 	chown -R sphinxsearch $DATA_DIR/sphinx
-	# Apply corre group permissions to /nsm/elsa/data/elsa/log
+	echo "* Applying permissions to $DATA_DIR/elsa/log/" | $LOGGER
 	chgrp -R sphinxsearch $DATA_DIR/elsa/log/
 	chmod -R g+rwx $DATA_DIR/elsa/log/
 
-    if [ ! -d /var/run/sphinxsearch ]; then 
-        echo "* Creating sphinx PID directory."
-        mkdir -p /var/run/sphinxsearch
-        echo "* Apply correct permissions to PID directory."
-        chown sphinxsearch /var/run/sphinxsearch
-        chgrp sphinxsearch /var/run/sphinxsearch
-    fi
+	if [ ! -d /var/run/sphinxsearch ]; then 
+        	echo "* Creating sphinx PID directory." | $LOGGER
+        	mkdir -p /var/run/sphinxsearch
+        	echo "* Applying permissions to PID directory." | $LOGGER
+        	chown sphinxsearch /var/run/sphinxsearch
+        	chgrp sphinxsearch /var/run/sphinxsearch
+	fi
 
 	echo "* Restarting Sphinx" | $LOGGER
 	service sphinxsearch restart
@@ -166,8 +160,7 @@ function config_lognode() {
 	HTTP_LOGS=""
 	SENSORS=$(grep -v "^#" /etc/nsm/sensortab | cut -f 4)
 	COUNT=0
-	for token in $SENSORS
-	do
+	for token in $SENSORS; do
 		COUNT=$((COUNT+1))
 	done
 	echo $COUNT
@@ -186,8 +179,7 @@ function config_lognode() {
 	
 	if [ $COUNT -gt 1 ]; then
 		echo "* Altering syslog-ng.conf bro_http entries for multiple interfaces" | $LOGGER
-		for i in $SENSORS
-		do
+		for i in $SENSORS; do
 			HTTP_LOGS=$HTTP_LOGS"\tfile(\"/nsm/bro/logs/current/http_$i.log\" flags(no-parse) program_override(\"bro_http\"));\n"
 		done
 		sed -e "s|^\tfile(\"/nsm/bro/logs/current/http.log\".*|$HTTP_LOGS|" /opt/elsa/contrib/securityonion/contrib/securityonion-syslog-ng.conf > /etc/syslog-ng/syslog-ng.conf
@@ -195,43 +187,23 @@ function config_lognode() {
 
 	echo "* Restarting syslog-ng" | $LOGGER
 	service syslog-ng restart
-	# pgrep -f "elsa.pl"
-	
-	# # Sleep to allow ELSA to initialize and validate its directory
-	# echo "* Sleeping for 60 seconds to allow ELSA to init..." | $LOGGER
-	# sleep 60
-
-	# echo "* Sending test log messages..." | $LOGGER
-	# "$BASE_DIR/syslog-ng/bin/loggen" -Di -I 1 127.0.0.1 514
 	
-	
-	# # Sleep to allow ELSA to initialize and validate its directory
-	# echo "* Sleeping for 60 seconds to allow ELSA to load batch..." | $LOGGER
-	# sleep 60
-	
-	# Watch the log file to make sure it's working (after wiping indexes you should see batches processed and rows indexed)
-	# echo "* Checking log file" | $LOGGER
-	# grep "Indexed temp_" "$DATA_DIR/elsa/log/node.log" | tail -1 | perl -e '$l = <>; $l =~ /Indexed temp_\d+ with (\d+)/; if ($1 > 1){ exit 0; } exit 1;'
-	# if [ $? -ne 0 ]
-	# then
-	#	 echo "* Log file not properly reporting." | $LOGGER
-	# fi
-    ELSA_REG_LOG_DIR="/var/log/nsm/so-elsa"
-    if [ ! -d $ELSA_REG_LOG_DIR ]; then
-        echo "* Adding $ELSA_REG_LOG_DIR" | $LOGGER
-        mkdir -p $ELSA_REG_LOG_DIR;
-    fi
+	ELSA_REG_LOG_DIR="/var/log/nsm/so-elsa"
+	if [ ! -d $ELSA_REG_LOG_DIR ]; then
+        	echo "* Adding $ELSA_REG_LOG_DIR" | $LOGGER
+        	mkdir -p $ELSA_REG_LOG_DIR;
+	fi
 }
 
 function config_webnode() {
 	echo "* Placing ELSA Web Config file" | $LOGGER
 	cat "$BASE_DIR/elsa/contrib/securityonion/contrib/securityonion-elsa-web.conf" | sed -e "s|\/data|$DATA_DIR|g" > /etc/elsa_web.conf
-	echo "* Placing pcap_url directive"
-    if grep "pcap_url\": \"http://streamdb" /etc/elsa_web.conf > /dev/null;  then
-    	echo "* Adding pcap_url directive" 
-    	IP=`ifconfig | grep "inet addr" | awk '{print $2}' | cut -d\: -f2 | grep -v "127.0.0.1" | head -1`
-    	sed -i "s/^.*\"pcap_url\": \"http\:\/\/streamdb\",.*$/\t\"pcap_url\": \"https:\/\/$IP\/capme\",/" /etc/elsa_web.conf
-    fi   
+	echo "* Placing pcap_url directive" | $LOGGER
+	if grep "pcap_url\": \"http://streamdb" /etc/elsa_web.conf > /dev/null;  then
+		echo "* Adding pcap_url directive"  | $LOGGER
+		IP=`ifconfig | grep "inet addr" | awk '{print $2}' | cut -d\: -f2 | grep -v "127.0.0.1" | head -1`
+		sed -i "s/^.*\"pcap_url\": \"http\:\/\/streamdb\",.*$/\t\"pcap_url\": \"https:\/\/$IP\/capme\",/" /etc/elsa_web.conf
+	fi   
 	echo "* Beginning Web Install:" | $LOGGER
 	echo "* Configuring mysql schema" | $LOGGER
 	mysqladmin -uroot $MYSQL_PORT create elsa_web 
@@ -249,17 +221,15 @@ function config_webnode() {
 	chown -R www-data $DATA_DIR/elsa/log
 	apache2ctl restart
 
-	# setup cron
 	echo "* Adding cron entry for alerts..." | $LOGGER
 	cp /opt/elsa/contrib/securityonion/contrib/elsa.cron /etc/cron.d/elsa
 
+	echo "* Restarting cron" | $LOGGER
 	service cron restart
 
-	# open up 3154 for the ELSA front end.
 	echo "* Opening 3154/tcp.." | $LOGGER
 	ufw allow 3154/tcp
 
-	# Gather GeoIP Data
 	echo "* Retrieving GeoIP City databases..."	 | $LOGGER
 	mkdir -p /usr/local/share/GeoIP 
 	curl -L "http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz" > /tmp/GeoLiteCity.dat.gz 
@@ -275,45 +245,33 @@ function config_webnode() {
 }
 
 function config_lognode_webapi() {
+
 	echo "* Configuring Web API and Starman." | $LOGGER
-    echo "* Placing starman init file." | $LOGGER
-    cp /opt/elsa/contrib/securityonion/contrib/securityonion_starman_init.sh /etc/init.d/starman
-    chmod 744 /etc/init.d/starman
-    # Set default on
-    echo "* Adding starman to defaults."
-    update-rc.d starman defaults
-    echo "* Placing elsa_web.conf file." | $LOGGER
+	echo "* Placing starman init file." | $LOGGER
+	cp /opt/elsa/contrib/securityonion/contrib/securityonion_starman_init.sh /etc/init.d/starman
+	chmod 744 /etc/init.d/starman
+
+	echo "* Adding starman to defaults." | $LOGGER
+	update-rc.d starman defaults
+
+	echo "* Placing elsa_web.conf file." | $LOGGER
 	cat "$BASE_DIR/elsa/contrib/securityonion/contrib/securityonion-elsa-api.conf" | sed -e "s|\/data|$DATA_DIR|g" > /etc/elsa_web.conf
-	# echo "* Placing pcap_url directive"
-    # if grep "pcap_url\": \"http://streamdb" /etc/elsa_web.conf > /dev/null;  then
-    # 	echo "* Adding pcap_url directive" 
-    # 	IP=`ifconfig | grep "inet addr" | awk '{print $2}' | cut -d\: -f2 | grep -v "127.0.0.1" | head -1`
-    # 	sed -i "s/^.*\"pcap_url\": \"http\:\/\/streamdb\",.*$/\{\n\t\"pcap_url\": \"https:\/\/$IP\/capme\",/" /etc/elsa_web.conf
-    # fi       
+
 	echo "* Configuring mysql schema" | $LOGGER
 	mysqladmin -uroot $MYSQL_PORT create elsa_web 
 	mysql -uroot $MYSQL_PORT -e "GRANT ALL ON elsa_web.* TO \"elsa\"@\"localhost\" IDENTIFIED BY \"biglog\"" 
 	mysql -uroot $MYSQL_PORT -e "GRANT ALL ON elsa_web.* TO \"elsa\"@\"%\" IDENTIFIED BY \"biglog\"" 
 	mysql -uelsa $MYSQL_PORT -pbiglog elsa_web -e "source $BASE_DIR/elsa/web/conf/meta_db_schema.mysql"
-	
     
-	# Activate ELSA and restart starman
-    echo "* Starting starman on port 3154" | $LOGGER
-    touch $DATA_DIR/elsa/log/web.log
+	echo "* Starting starman on port 3154" | $LOGGER
+	touch $DATA_DIR/elsa/log/web.log
 	chown -R www-data $DATA_DIR/elsa/log
 	/etc/init.d/starman start
-
     
-	# setup cron
 	echo "* Adding cron entry for alerts..." | $LOGGER
 	cp /opt/elsa/contrib/securityonion/contrib/elsa.cron /etc/cron.d/elsa
 	service cron restart
 
-	# The ELSA log nodes run on port 3154/tcp
-	# echo "* Opening 3154/tcp.." | $LOGGER
-	# ufw allow 3154/tcp
-
-	# Gather GeoIP Data
 	echo "* Retrieving GeoIP City databases..."	 | $LOGGER
 	mkdir -p /usr/local/share/GeoIP 
 	curl -L "http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz" > /tmp/GeoLiteCity.dat.gz 
@@ -351,6 +309,7 @@ fi
 
 echo "Beginning installation for ELSA $NODE_TYPE node." | $LOGGER
 if [ "$NODE_TYPE" = "LOG" ]; then
+
 	# Reconfigure MYSQL to run on 50000/tcp
 	echo "* Reconfiguring mysql to use port 50000/tcp" | $LOGGER
 	cp /etc/mysql/my.cnf /etc/mysql/my.cnf.bak
@@ -363,17 +322,21 @@ if [ "$NODE_TYPE" = "LOG" ]; then
 	if [ ! -e /var/lib/mysql/snorby ]; then
 		sed -i "s,\"db\": \"syslog\"\,,\"db\": \"syslog\,port=50000\"\,," /etc/elsa_node.conf
 	fi
-    # Configure the Web API features for log nodes.
-    config_lognode_webapi
+	# Configure the Web API features for log nodes.
+	config_lognode_webapi
+
 elif [ "$NODE_TYPE" = "WEB" ]; then
+
 	MYSQL_PORT="-P3306"
 	config_lognode
 	config_webnode
-    check_config_perms
-    # Randomize the API key for master nodes.
-    /usr/bin/securityonion_elsa_register.rb --random-apikey
+	check_config_perms
+	# Randomize the API key for master nodes.
+	/usr/bin/securityonion_elsa_register.rb --random-apikey
+
 elif [ "$NODE_TYPE" = "API" ]; then
-    MYSQL_PORT="-P50000"
-    config_lognode_webapi
+
+	MYSQL_PORT="-P50000"
+	config_lognode_webapi
 fi
 
--- /dev/null
+++ securityonion-elsa-extras-20131117/contrib/sql/elsa_orig.sql
@@ -0,0 +1,689 @@
+CREATE TABLE programs (
+	id INT UNSIGNED NOT NULL PRIMARY KEY,
+	program VARCHAR(255) NOT NULL,
+	pattern VARCHAR(255),
+	UNIQUE KEY (program)
+) ENGINE=InnoDB;
+
+INSERT INTO programs (id, program) VALUES (1, "none");
+
+CREATE TABLE classes (
+	id SMALLINT UNSIGNED NOT NULL PRIMARY KEY,
+	class VARCHAR(255) NOT NULL,
+	parent_id SMALLINT UNSIGNED NOT NULL DEFAULT 0,
+	UNIQUE KEY (class)
+) ENGINE=InnoDB;
+
+INSERT INTO classes (id, class, parent_id) VALUES(0, "ANY", 0);
+INSERT INTO classes (id, class, parent_id) VALUES(1, "NONE", 0);
+INSERT INTO classes (id, class, parent_id) VALUES(2, "FIREWALL_ACCESS_DENY", 0);
+INSERT INTO classes (id, class, parent_id) VALUES(3, "FIREWALL_CONNECTION_END", 0);
+INSERT INTO classes (id, class, parent_id) VALUES(4, "WINDOWS", 0);
+INSERT INTO classes (id, class, parent_id) VALUES(7, "URL", 0);
+INSERT INTO classes (id, class, parent_id) VALUES(8, "SNORT", 0);
+INSERT INTO classes (id, class, parent_id) VALUES(11, "SSH_LOGIN", 0);
+INSERT INTO classes (id, class, parent_id) VALUES(12, "SSH_ACCESS_DENY", 0);
+INSERT INTO classes (id, class, parent_id) VALUES(13, "SSH_LOGOUT", 0);
+INSERT INTO classes (id, class, parent_id) VALUES(14, "BRO_DNS", 0);
+INSERT INTO classes (id, class, parent_id) VALUES(15, "BRO_NOTICE", 0);
+INSERT INTO classes (id, class, parent_id) VALUES(16, "BRO_SMTP", 0);
+INSERT INTO classes (id, class, parent_id) VALUES(17, "BRO_SMTP_ENTITIES", 0);
+INSERT INTO classes (id, class, parent_id) VALUES(18, "BRO_SSL", 0);
+INSERT INTO classes (id, class, parent_id) VALUES(19, "BRO_HTTP", 0);
+INSERT INTO classes (id, class, parent_id) VALUES(20, "BRO_CONN", 0);
+/*INSERT INTO classes (id, class, parent_id) VALUES(21, "FORTINET_URL", 0);*/
+/*INSERT INTO classes (id, class, parent_id) VALUES(22, "FORTINET_TRAFFIC", 0);*/
+/*INSERT INTO classes (id, class, parent_id) VALUES(23, "CHECKPOINT", 0);*/
+/*INSERT INTO classes (id, class, parent_id) VALUES(24, "PALO_ALTO_URL", 0);*/
+/*INSERT INTO classes (id, class, parent_id) VALUES(25, "PALO_ALTO_TRAFFIC", 0);*/
+/*INSERT INTO classes (id, class, parent_id) VALUES(26, "OSSEC", 0);*/
+/*INSERT INTO classes (id, class, parent_id) VALUES(27, "BARRACUDA_SCAN", 0);*/
+/*INSERT INTO classes (id, class, parent_id) VALUES(28, "BARRACUDA_RECV", 0);*/
+/*INSERT INTO classes (id, class, parent_id) VALUES(29, "BARRACUDA_SEND", 0);*/
+/*INSERT INTO classes (id, class, parent_id) VALUES(30, "EXCHANGE", 0);*/
+/*INSERT INTO classes (id, class, parent_id) VALUES(31, "LOG2TIMELINE", 0);*/
+INSERT INTO classes (id, class, parent_id) VALUES(32, "CEF", 0);
+/*INSERT INTO classes (id, class, parent_id) VALUES(33, "WEB_CONTENT_FILTER", 0);*/
+/*INSERT INTO classes (id, class, parent_id) VALUES(34, "NETFLOW", 0);*/
+/*INSERT INTO classes (id, class, parent_id) VALUES(35, "OSSEC_ALERTS", 0);*/
+INSERT INTO classes (id, class, parent_id) VALUES(36, "VPN", 0);
+INSERT INTO classes (id, class, parent_id) VALUES(37, "NAT", 0);
+INSERT INTO classes (id, class, parent_id) VALUES(38, "FTP", 0);
+INSERT INTO classes (id, class, parent_id) VALUES(39, "CISCO_WARN", 0);
+INSERT INTO classes (id, class, parent_id) VALUES(40, "DHCP", 0);
+INSERT INTO classes (id, class, parent_id) VALUES(41, "BRO_FILE", 0);
+INSERT INTO classes (id, class) VALUES(98, "ELSA_UNPARSED");
+INSERT INTO classes (id, class) VALUES(99, "ELSA_OPS");
+
+CREATE TABLE class_program_map (
+	class_id SMALLINT UNSIGNED NOT NULL,
+	program_id INT UNSIGNED NOT NULL,
+	PRIMARY KEY (class_id, program_id),
+	FOREIGN KEY (class_id) REFERENCES classes (id) ON UPDATE CASCADE ON DELETE CASCADE,
+	FOREIGN KEY (program_id) REFERENCES programs (id) ON UPDATE CASCADE ON DELETE CASCADE	
+) ENGINE=InnoDB;
+
+CREATE TABLE fields (
+	id SMALLINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
+	field VARCHAR(255) NOT NULL,
+	field_type ENUM("string", "int") NOT NULL,
+	pattern_type ENUM("NONE", "QSTRING", "ESTRING", "STRING", "DOUBLE", "NUMBER", "IPv4", "PCRE-IPv4") NOT NULL,
+	input_validation VARCHAR(255),
+	UNIQUE KEY (field, field_type)
+) ENGINE=InnoDB;
+
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("timestamp", "int", "NONE");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("minute", "int", "NONE");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("hour", "int", "NONE");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("day", "int", "NONE");
+
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("host_id", "int", "NONE");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("program_id", "int", "NONE");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("class_id", "int", "NONE");
+INSERT INTO fields (field, field_type, pattern_type, input_validation) VALUES ("host", "int", "IPv4", "IPv4");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("program", "int", "number");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("class", "int", "number");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("msg", "string", "NONE");
+
+INSERT INTO fields (field, field_type, pattern_type, input_validation) VALUES ("ip", "int", "PCRE-IPv4", "IPv4");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("proto", "int", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("o_int", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type, input_validation) VALUES ("srcip", "int", "IPv4", "IPv4");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("srcport", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("i_int", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type, input_validation) VALUES ("dstip", "int", "IPv4", "IPv4");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("dstport", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type, input_validation) VALUES ("srcip_nat", "int", "IPv4", "IPv4");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("access_group", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("conn_duration", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("conn_bytes", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("eventid", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("source", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("user", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("field0", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("type", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("hostname", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("category", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("site", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("method", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("uri", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("referer", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("user_agent", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("domains", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("status_code", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("content_length", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("country_code", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("sig_sid", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("sig_msg", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("sig_classification", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("sig_priority", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("authmethod", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("device", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("service", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("port", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("answer", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("notice_type", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("notice_msg", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("server", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("from", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("to", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("subject", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("last_reply", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("path", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("filename", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("content_len", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("mime_type", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("md5", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("extraction_file", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("excerpt", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("expiration", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("group", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("status", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("number", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("interface", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("origin", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("action", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("message_info", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("rule", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("country", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("src_zone", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("dst_zone", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("action_code", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("reason_code", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("reason_extra", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("response", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("hub_server", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("mailbox_server", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("time_taken", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("domain", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("share_name", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("share_path", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("share_target", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("macb", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("sourcetype", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("desc", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("notes", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("version", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("vendor", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("product", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("sig_id", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("name", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("severity", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("extension", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("asn", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("city", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("latitude", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("longitude", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("pkts_in", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("pkts_out", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("bytes_in", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("bytes_out", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("line_number", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("pid", "int", "NUMBER");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("priority", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("file", "string", "QSTRING");
+INSERT INTO fields (field, field_type, pattern_type) VALUES ("mac_address", "string", "QSTRING");
+
+
+CREATE TABLE fields_classes_map (
+	field_id SMALLINT UNSIGNED NOT NULL,
+	class_id SMALLINT UNSIGNED NOT NULL,
+	field_order TINYINT UNSIGNED NOT NULL DEFAULT 0,
+	PRIMARY KEY (field_id, class_id),
+	UNIQUE KEY (class_id, field_order),
+	FOREIGN KEY (field_id) REFERENCES fields (id) ON UPDATE CASCADE ON DELETE CASCADE,
+	FOREIGN KEY (class_id) REFERENCES classes (id) ON UPDATE CASCADE ON DELETE CASCADE
+) ENGINE=InnoDB;
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES (0, (SELECT id FROM fields WHERE field="host"), 1);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES (0, (SELECT id FROM fields WHERE field="program"), 2);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES (0, (SELECT id FROM fields WHERE field="class"), 3);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FIREWALL_ACCESS_DENY"), (SELECT id FROM fields WHERE field="proto"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FIREWALL_ACCESS_DENY"), (SELECT id FROM fields WHERE field="o_int"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FIREWALL_ACCESS_DENY"), (SELECT id FROM fields WHERE field="srcip"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FIREWALL_ACCESS_DENY"), (SELECT id FROM fields WHERE field="srcport"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FIREWALL_ACCESS_DENY"), (SELECT id FROM fields WHERE field="i_int"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FIREWALL_ACCESS_DENY"), (SELECT id FROM fields WHERE field="dstip"), 8);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FIREWALL_ACCESS_DENY"), (SELECT id FROM fields WHERE field="dstport"), 9);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FIREWALL_ACCESS_DENY"), (SELECT id FROM fields WHERE field="access_group"), 13);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FIREWALL_CONNECTION_END"), (SELECT id FROM fields WHERE field="proto"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FIREWALL_CONNECTION_END"), (SELECT id FROM fields WHERE field="o_int"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FIREWALL_CONNECTION_END"), (SELECT id FROM fields WHERE field="srcip"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FIREWALL_CONNECTION_END"), (SELECT id FROM fields WHERE field="srcport"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FIREWALL_CONNECTION_END"), (SELECT id FROM fields WHERE field="i_int"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FIREWALL_CONNECTION_END"), (SELECT id FROM fields WHERE field="dstip"), 8);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FIREWALL_CONNECTION_END"), (SELECT id FROM fields WHERE field="dstport"), 9);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FIREWALL_CONNECTION_END"), (SELECT id FROM fields WHERE field="conn_duration"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FIREWALL_CONNECTION_END"), (SELECT id FROM fields WHERE field="conn_bytes"), 10);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WINDOWS"), (SELECT id FROM fields WHERE field="eventid"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WINDOWS"), (SELECT id FROM fields WHERE field="srcip"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WINDOWS"), (SELECT id FROM fields WHERE field="source"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WINDOWS"), (SELECT id FROM fields WHERE field="user"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WINDOWS"), (SELECT id FROM fields WHERE field="domain"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WINDOWS"), (SELECT id FROM fields WHERE field="share_name"), 14);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WINDOWS"), (SELECT id FROM fields WHERE field="share_path"), 15);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WINDOWS"), (SELECT id FROM fields WHERE field="share_target"), 16);
+
+/*INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WINDOWS"), (SELECT id FROM fields WHERE field="user"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WINDOWS"), (SELECT id FROM fields WHERE field="field0"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WINDOWS"), (SELECT id FROM fields WHERE field="type"), 14);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WINDOWS"), (SELECT id FROM fields WHERE field="hostname"), 15);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WINDOWS"), (SELECT id FROM fields WHERE field="category"), 16);*/
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="URL"), (SELECT id FROM fields WHERE field="srcip"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="URL"), (SELECT id FROM fields WHERE field="dstip"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="URL"), (SELECT id FROM fields WHERE field="status_code"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="URL"), (SELECT id FROM fields WHERE field="content_length"), 8);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="URL"), (SELECT id FROM fields WHERE field="country_code"), 9);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="URL"), (SELECT id FROM fields WHERE field="time_taken"), 10);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="URL"), (SELECT id FROM fields WHERE field="method"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="URL"), (SELECT id FROM fields WHERE field="site"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="URL"), (SELECT id FROM fields WHERE field="uri"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="URL"), (SELECT id FROM fields WHERE field="referer"), 14);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="URL"), (SELECT id FROM fields WHERE field="user_agent"), 15);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="URL"), (SELECT id FROM fields WHERE field="domains"), 16);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SNORT"), (SELECT id FROM fields WHERE field="sig_sid"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SNORT"), (SELECT id FROM fields WHERE field="sig_msg"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SNORT"), (SELECT id FROM fields WHERE field="sig_classification"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SNORT"), (SELECT id FROM fields WHERE field="interface"), 14);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SNORT"), (SELECT id FROM fields WHERE field="sig_priority"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SNORT"), (SELECT id FROM fields WHERE field="proto"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SNORT"), (SELECT id FROM fields WHERE field="srcip"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SNORT"), (SELECT id FROM fields WHERE field="srcport"), 8);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SNORT"), (SELECT id FROM fields WHERE field="dstip"), 9);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SNORT"), (SELECT id FROM fields WHERE field="dstport"), 10);
+
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SSH_LOGIN"), (SELECT id FROM fields WHERE field="authmethod"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SSH_LOGIN"), (SELECT id FROM fields WHERE field="user"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SSH_LOGIN"), (SELECT id FROM fields WHERE field="device"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SSH_LOGIN"), (SELECT id FROM fields WHERE field="port"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SSH_LOGIN"), (SELECT id FROM fields WHERE field="service"), 14);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SSH_ACCESS_DENY"), (SELECT id FROM fields WHERE field="authmethod"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SSH_ACCESS_DENY"), (SELECT id FROM fields WHERE field="user"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SSH_ACCESS_DENY"), (SELECT id FROM fields WHERE field="device"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SSH_ACCESS_DENY"), (SELECT id FROM fields WHERE field="port"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SSH_ACCESS_DENY"), (SELECT id FROM fields WHERE field="service"), 14);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="SSH_LOGOUT"), (SELECT id FROM fields WHERE field="user"), 11);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_DNS"), (SELECT id FROM fields WHERE field="srcip"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_DNS"), (SELECT id FROM fields WHERE field="srcport"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_DNS"), (SELECT id FROM fields WHERE field="dstip"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_DNS"), (SELECT id FROM fields WHERE field="dstport"), 8);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_DNS"), (SELECT id FROM fields WHERE field="proto"), 9);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_DNS"), (SELECT id FROM fields WHERE field="hostname"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_DNS"), (SELECT id FROM fields WHERE field="answer"), 12);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_NOTICE"), (SELECT id FROM fields WHERE field="srcip"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_NOTICE"), (SELECT id FROM fields WHERE field="srcport"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_NOTICE"), (SELECT id FROM fields WHERE field="dstip"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_NOTICE"), (SELECT id FROM fields WHERE field="dstport"), 8);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_NOTICE"), (SELECT id FROM fields WHERE field="notice_type"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_NOTICE"), (SELECT id FROM fields WHERE field="notice_msg"), 12);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_FILE"), (SELECT id FROM fields WHERE field="srcip"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_FILE"), (SELECT id FROM fields WHERE field="srcport"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_FILE"), (SELECT id FROM fields WHERE field="dstip"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_FILE"), (SELECT id FROM fields WHERE field="dstport"), 8);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_FILE"), (SELECT id FROM fields WHERE field="md5"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_FILE"), (SELECT id FROM fields WHERE field="site"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_FILE"), (SELECT id FROM fields WHERE field="uri"), 13);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SMTP"), (SELECT id FROM fields WHERE field="srcip"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SMTP"), (SELECT id FROM fields WHERE field="srcport"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SMTP"), (SELECT id FROM fields WHERE field="dstip"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SMTP"), (SELECT id FROM fields WHERE field="dstport"), 8);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SMTP"), (SELECT id FROM fields WHERE field="server"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SMTP"), (SELECT id FROM fields WHERE field="from"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SMTP"), (SELECT id FROM fields WHERE field="to"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SMTP"), (SELECT id FROM fields WHERE field="subject"), 14);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SMTP"), (SELECT id FROM fields WHERE field="last_reply"), 15);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SMTP"), (SELECT id FROM fields WHERE field="path"), 16);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SMTP_ENTITIES"), (SELECT id FROM fields WHERE field="srcip"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SMTP_ENTITIES"), (SELECT id FROM fields WHERE field="srcport"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SMTP_ENTITIES"), (SELECT id FROM fields WHERE field="dstip"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SMTP_ENTITIES"), (SELECT id FROM fields WHERE field="dstport"), 8);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SMTP_ENTITIES"), (SELECT id FROM fields WHERE field="filename"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SMTP_ENTITIES"), (SELECT id FROM fields WHERE field="content_len"), 9);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SMTP_ENTITIES"), (SELECT id FROM fields WHERE field="mime_type"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SMTP_ENTITIES"), (SELECT id FROM fields WHERE field="md5"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SMTP_ENTITIES"), (SELECT id FROM fields WHERE field="extraction_file"), 14);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SMTP_ENTITIES"), (SELECT id FROM fields WHERE field="excerpt"), 15);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SSL"), (SELECT id FROM fields WHERE field="srcip"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SSL"), (SELECT id FROM fields WHERE field="srcport"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SSL"), (SELECT id FROM fields WHERE field="dstip"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SSL"), (SELECT id FROM fields WHERE field="dstport"), 8);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SSL"), (SELECT id FROM fields WHERE field="hostname"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SSL"), (SELECT id FROM fields WHERE field="subject"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SSL"), (SELECT id FROM fields WHERE field="expiration"), 9);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_HTTP"), (SELECT id FROM fields WHERE field="srcip"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_HTTP"), (SELECT id FROM fields WHERE field="srcport"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_HTTP"), (SELECT id FROM fields WHERE field="dstip"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_HTTP"), (SELECT id FROM fields WHERE field="dstport"), 8);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_HTTP"), (SELECT id FROM fields WHERE field="status_code"), 9);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_HTTP"), (SELECT id FROM fields WHERE field="content_length"), 10);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_HTTP"), (SELECT id FROM fields WHERE field="method"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_HTTP"), (SELECT id FROM fields WHERE field="site"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_HTTP"), (SELECT id FROM fields WHERE field="uri"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_HTTP"), (SELECT id FROM fields WHERE field="referer"), 14);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_HTTP"), (SELECT id FROM fields WHERE field="user_agent"), 15);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_CONN"), (SELECT id FROM fields WHERE field="srcip"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_CONN"), (SELECT id FROM fields WHERE field="srcport"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_CONN"), (SELECT id FROM fields WHERE field="dstip"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_CONN"), (SELECT id FROM fields WHERE field="dstport"), 8);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_CONN"), (SELECT id FROM fields WHERE field="proto"), 9);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_CONN"), (SELECT id FROM fields WHERE field="bytes_in"), 10);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_CONN"), (SELECT id FROM fields WHERE field="service"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_CONN"), (SELECT id FROM fields WHERE field="conn_duration"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_CONN"), (SELECT id FROM fields WHERE field="bytes_out"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_CONN"), (SELECT id FROM fields WHERE field="pkts_out"), 14);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_CONN"), (SELECT id FROM fields WHERE field="pkts_in"), 15);
+
+/*INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FORTINET_URL"), (SELECT id FROM fields WHERE field="srcip"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FORTINET_URL"), (SELECT id FROM fields WHERE field="srcport"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FORTINET_URL"), (SELECT id FROM fields WHERE field="dstip"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FORTINET_URL"), (SELECT id FROM fields WHERE field="dstport"), 8);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FORTINET_URL"), (SELECT id FROM fields WHERE field="user"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FORTINET_URL"), (SELECT id FROM fields WHERE field="group"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FORTINET_URL"), (SELECT id FROM fields WHERE field="service"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FORTINET_URL"), (SELECT id FROM fields WHERE field="site"), 14);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FORTINET_URL"), (SELECT id FROM fields WHERE field="status"), 15);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FORTINET_URL"), (SELECT id FROM fields WHERE field="uri"), 16);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FORTINET_TRAFFIC"), (SELECT id FROM fields WHERE field="srcip"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FORTINET_TRAFFIC"), (SELECT id FROM fields WHERE field="srcport"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FORTINET_TRAFFIC"), (SELECT id FROM fields WHERE field="dstip"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FORTINET_TRAFFIC"), (SELECT id FROM fields WHERE field="dstport"), 8);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FORTINET_TRAFFIC"), (SELECT id FROM fields WHERE field="proto"), 9);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FORTINET_TRAFFIC"), (SELECT id FROM fields WHERE field="conn_duration"), 10);*/
+
+/*INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CHECKPOINT"), (SELECT id FROM fields WHERE field="number"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CHECKPOINT"), (SELECT id FROM fields WHERE field="srcip"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CHECKPOINT"), (SELECT id FROM fields WHERE field="dstip"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CHECKPOINT"), (SELECT id FROM fields WHERE field="proto"), 8);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CHECKPOINT"), (SELECT id FROM fields WHERE field="interface"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CHECKPOINT"), (SELECT id FROM fields WHERE field="origin"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CHECKPOINT"), (SELECT id FROM fields WHERE field="type"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CHECKPOINT"), (SELECT id FROM fields WHERE field="action"), 14);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CHECKPOINT"), (SELECT id FROM fields WHERE field="service"), 15);*/
+
+/*INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="PALO_ALTO_URL"), (SELECT id FROM fields WHERE field="srcip"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="PALO_ALTO_URL"), (SELECT id FROM fields WHERE field="dstip"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="PALO_ALTO_URL"), (SELECT id FROM fields WHERE field="content_length"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="PALO_ALTO_URL"), (SELECT id FROM fields WHERE field="rule"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="PALO_ALTO_URL"), (SELECT id FROM fields WHERE field="user"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="PALO_ALTO_URL"), (SELECT id FROM fields WHERE field="category"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="PALO_ALTO_URL"), (SELECT id FROM fields WHERE field="site"), 14);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="PALO_ALTO_URL"), (SELECT id FROM fields WHERE field="uri"), 15);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="PALO_ALTO_URL"), (SELECT id FROM fields WHERE field="country"), 16);*/
+
+/*INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="PALO_ALTO_TRAFFIC"), (SELECT id FROM fields WHERE field="srcip"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="PALO_ALTO_TRAFFIC"), (SELECT id FROM fields WHERE field="dstip"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="PALO_ALTO_TRAFFIC"), (SELECT id FROM fields WHERE field="srcport"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="PALO_ALTO_TRAFFIC"), (SELECT id FROM fields WHERE field="dstport"), 8);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="PALO_ALTO_TRAFFIC"), (SELECT id FROM fields WHERE field="proto"), 9);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="PALO_ALTO_TRAFFIC"), (SELECT id FROM fields WHERE field="conn_bytes"), 10);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="PALO_ALTO_TRAFFIC"), (SELECT id FROM fields WHERE field="src_zone"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="PALO_ALTO_TRAFFIC"), (SELECT id FROM fields WHERE field="dst_zone"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="PALO_ALTO_TRAFFIC"), (SELECT id FROM fields WHERE field="i_int"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="PALO_ALTO_TRAFFIC"), (SELECT id FROM fields WHERE field="o_int"), 14);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="PALO_ALTO_TRAFFIC"), (SELECT id FROM fields WHERE field="country"), 15);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="PALO_ALTO_TRAFFIC"), (SELECT id FROM fields WHERE field="category"), 16);*/
+
+/*INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BARRACUDA_SCAN"), (SELECT id FROM fields WHERE field="srcip"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BARRACUDA_SCAN"), (SELECT id FROM fields WHERE field="action_code"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BARRACUDA_SCAN"), (SELECT id FROM fields WHERE field="reason_code"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BARRACUDA_SCAN"), (SELECT id FROM fields WHERE field="from"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BARRACUDA_SCAN"), (SELECT id FROM fields WHERE field="to"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BARRACUDA_SCAN"), (SELECT id FROM fields WHERE field="reason_extra"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BARRACUDA_SCAN"), (SELECT id FROM fields WHERE field="subject"), 14);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BARRACUDA_RECV"), (SELECT id FROM fields WHERE field="srcip"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BARRACUDA_RECV"), (SELECT id FROM fields WHERE field="action_code"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BARRACUDA_RECV"), (SELECT id FROM fields WHERE field="reason_code"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BARRACUDA_RECV"), (SELECT id FROM fields WHERE field="from"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BARRACUDA_RECV"), (SELECT id FROM fields WHERE field="to"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BARRACUDA_RECV"), (SELECT id FROM fields WHERE field="reason_extra"), 13);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BARRACUDA_SEND"), (SELECT id FROM fields WHERE field="srcip"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BARRACUDA_SEND"), (SELECT id FROM fields WHERE field="action_code"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BARRACUDA_SEND"), (SELECT id FROM fields WHERE field="response"), 11);*/
+
+/*INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="EXCHANGE"), (SELECT id FROM fields WHERE field="hub_server"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="EXCHANGE"), (SELECT id FROM fields WHERE field="mailbox_server"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="EXCHANGE"), (SELECT id FROM fields WHERE field="from"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="EXCHANGE"), (SELECT id FROM fields WHERE field="to"), 14);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="EXCHANGE"), (SELECT id FROM fields WHERE field="subject"), 15);*/
+
+/*INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="LOG2TIMELINE"), (SELECT id FROM fields WHERE field="macb"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="LOG2TIMELINE"), (SELECT id FROM fields WHERE field="sourcetype"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="LOG2TIMELINE"), (SELECT id FROM fields WHERE field="user"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="LOG2TIMELINE"), (SELECT id FROM fields WHERE field="hostname"), 14);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="LOG2TIMELINE"), (SELECT id FROM fields WHERE field="desc"), 15);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="LOG2TIMELINE"), (SELECT id FROM fields WHERE field="notes"), 16);*/
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CEF"), (SELECT id FROM fields WHERE field="severity"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CEF"), (SELECT id FROM fields WHERE field="vendor"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CEF"), (SELECT id FROM fields WHERE field="product"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CEF"), (SELECT id FROM fields WHERE field="version"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CEF"), (SELECT id FROM fields WHERE field="sig_id"), 14);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CEF"), (SELECT id FROM fields WHERE field="name"), 15);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CEF"), (SELECT id FROM fields WHERE field="extension"), 16);
+
+/*INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WEB_CONTENT_FILTER"), (SELECT id FROM fields WHERE field="srcip"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WEB_CONTENT_FILTER"), (SELECT id FROM fields WHERE field="dstip"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WEB_CONTENT_FILTER"), (SELECT id FROM fields WHERE field="status_code"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WEB_CONTENT_FILTER"), (SELECT id FROM fields WHERE field="user"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WEB_CONTENT_FILTER"), (SELECT id FROM fields WHERE field="site"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WEB_CONTENT_FILTER"), (SELECT id FROM fields WHERE field="uri"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WEB_CONTENT_FILTER"), (SELECT id FROM fields WHERE field="category"), 14);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WEB_CONTENT_FILTER"), (SELECT id FROM fields WHERE field="user_agent"), 15);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="WEB_CONTENT_FILTER"), (SELECT id FROM fields WHERE field="action"), 16);*/
+
+/*INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="NETFLOW"), (SELECT id FROM fields WHERE field="proto"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="NETFLOW"), (SELECT id FROM fields WHERE field="srcip"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="NETFLOW"), (SELECT id FROM fields WHERE field="srcport"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="NETFLOW"), (SELECT id FROM fields WHERE field="dstip"), 8);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="NETFLOW"), (SELECT id FROM fields WHERE field="dstport"), 9);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="NETFLOW"), (SELECT id FROM fields WHERE field="conn_bytes"), 10);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="NETFLOW"), (SELECT id FROM fields WHERE field="asn"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="NETFLOW"), (SELECT id FROM fields WHERE field="country"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="NETFLOW"), (SELECT id FROM fields WHERE field="city"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="NETFLOW"), (SELECT id FROM fields WHERE field="latitude"), 14);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="NETFLOW"), (SELECT id FROM fields WHERE field="longitude"), 15);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="NETFLOW"), (SELECT id FROM fields WHERE field="desc"), 16);*/
+
+/*INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="OSSEC_ALERTS"), (SELECT id FROM fields WHERE field="sig_priority"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="OSSEC_ALERTS"), (SELECT id FROM fields WHERE field="sig_sid"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="OSSEC_ALERTS"), (SELECT id FROM fields WHERE field="sig_msg"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="OSSEC_ALERTS"), (SELECT id FROM fields WHERE field="hostname"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="OSSEC_ALERTS"), (SELECT id FROM fields WHERE field="user"), 13);
+*/
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="VPN"), (SELECT id FROM fields WHERE field="srcip"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="VPN"), (SELECT id FROM fields WHERE field="group"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="VPN"), (SELECT id FROM fields WHERE field="user"), 12);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="ELSA_OPS"), (SELECT id FROM fields WHERE field="line_number"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="ELSA_OPS"), (SELECT id FROM fields WHERE field="pid"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="ELSA_OPS"), (SELECT id FROM fields WHERE field="priority"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="ELSA_OPS"), (SELECT id FROM fields WHERE field="file"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="ELSA_OPS"), (SELECT id FROM fields WHERE field="method"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="ELSA_OPS"), (SELECT id FROM fields WHERE field="hostname"), 14);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="NAT"), (SELECT id FROM fields WHERE field="proto"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="NAT"), (SELECT id FROM fields WHERE field="o_int"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="NAT"), (SELECT id FROM fields WHERE field="srcip"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="NAT"), (SELECT id FROM fields WHERE field="srcport"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="NAT"), (SELECT id FROM fields WHERE field="i_int"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="NAT"), (SELECT id FROM fields WHERE field="dstip"), 8);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="NAT"), (SELECT id FROM fields WHERE field="dstport"), 9);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="NAT"), (SELECT id FROM fields WHERE field="srcip_nat"), 10);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FTP"), (SELECT id FROM fields WHERE field="srcip"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FTP"), (SELECT id FROM fields WHERE field="srcport"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FTP"), (SELECT id FROM fields WHERE field="dstip"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FTP"), (SELECT id FROM fields WHERE field="dstport"), 8);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FTP"), (SELECT id FROM fields WHERE field="i_int"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FTP"), (SELECT id FROM fields WHERE field="o_int"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FTP"), (SELECT id FROM fields WHERE field="user"), 13);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FTP"), (SELECT id FROM fields WHERE field="action"), 14);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="FTP"), (SELECT id FROM fields WHERE field="filename"), 15);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CISCO_WARN"), (SELECT id FROM fields WHERE field="proto"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CISCO_WARN"), (SELECT id FROM fields WHERE field="srcip"), 6);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CISCO_WARN"), (SELECT id FROM fields WHERE field="srcport"), 7);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CISCO_WARN"), (SELECT id FROM fields WHERE field="dstip"), 8);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CISCO_WARN"), (SELECT id FROM fields WHERE field="dstport"), 9);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CISCO_WARN"), (SELECT id FROM fields WHERE field="i_int"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="CISCO_WARN"), (SELECT id FROM fields WHERE field="o_int"), 12);
+
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="DHCP"), (SELECT id FROM fields WHERE field="srcip"), 5);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="DHCP"), (SELECT id FROM fields WHERE field="mac_address"), 11);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="DHCP"), (SELECT id FROM fields WHERE field="domain"), 12);
+INSERT INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="DHCP"), (SELECT id FROM fields WHERE field="hostname"), 13);
+
+CREATE TABLE table_types (
+	id TINYINT UNSIGNED NOT NULL PRIMARY KEY,
+	table_type VARCHAR(255) NOT NULL
+) ENGINE=InnoDB;
+INSERT INTO table_types (id, table_type) VALUES (1, "index");
+INSERT INTO table_types (id, table_type) VALUES (2, "archive");
+INSERT INTO table_types (id, table_type) VALUES (3, "import");
+
+CREATE TABLE tables (
+	id SMALLINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
+	table_name VARCHAR(255) NOT NULL,
+	start TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
+	end TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',
+	min_id BIGINT UNSIGNED NOT NULL DEFAULT 1,
+	max_id BIGINT UNSIGNED NOT NULL DEFAULT 1,
+	table_type_id TINYINT UNSIGNED NOT NULL,
+	table_locked_by INT UNSIGNED,
+	FOREIGN KEY (table_type_id) REFERENCES table_types (id),
+	UNIQUE KEY (table_name),
+	KEY(min_id),
+	KEY(max_id),
+	UNIQUE KEY (min_id, table_type_id),
+	UNIQUE KEY (max_id, table_type_id)
+) ENGINE=InnoDB;
+
+CREATE TABLE indexes (
+	id SMALLINT UNSIGNED NOT NULL,
+	first_id BIGINT UNSIGNED NOT NULL,
+	last_id BIGINT UNSIGNED NOT NULL,
+	start INT UNSIGNED NOT NULL,
+	end INT UNSIGNED NOT NULL,
+	table_id SMALLINT UNSIGNED NOT NULL,
+	type ENUM("temporary", "permanent", "unavailable", "realtime") NOT NULL DEFAULT "temporary",
+	locked_by INT UNSIGNED,
+	index_schema TEXT,
+	PRIMARY KEY (id, type),
+	UNIQUE KEY (first_id, last_id),
+	KEY(start),
+	KEY(end),
+	KEY(type),
+	KEY(locked_by),
+	FOREIGN KEY (table_id) REFERENCES tables (id) ON UPDATE CASCADE ON DELETE CASCADE
+) ENGINE=InnoDB;
+
+CREATE OR REPLACE VIEW v_directory AS
+SELECT indexes.id, tables.start, tables.end, min_id, max_id, first_id, last_id, table_name,
+UNIX_TIMESTAMP(tables.start) AS table_start_int, UNIX_TIMESTAMP(tables.end) AS table_end_int, 
+table_types.table_type, tables.id AS table_id,
+type, locked_by, table_locked_by,
+FROM_UNIXTIME(indexes.start) AS index_start, FROM_UNIXTIME(indexes.end) AS index_end,
+indexes.start AS index_start_int, indexes.end AS index_end_int
+FROM tables
+JOIN table_types ON (tables.table_type_id=table_types.id)
+LEFT JOIN indexes ON (tables.id=indexes.table_id);
+
+CREATE TABLE `syslogs_template` (
+  `id` bigint unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT,
+  `timestamp` INT UNSIGNED NOT NULL DEFAULT 0,
+  `host_id` INT UNSIGNED NOT NULL DEFAULT '1',
+  `program_id` INT UNSIGNED NOT NULL DEFAULT '1',
+  `class_id` SMALLINT unsigned NOT NULL DEFAULT '1',
+  msg TEXT,
+  i0 INT UNSIGNED,
+  i1 INT UNSIGNED,
+  i2 INT UNSIGNED,
+  i3 INT UNSIGNED,
+  i4 INT UNSIGNED,
+  i5 INT UNSIGNED,
+  s0 VARCHAR(255),
+  s1 VARCHAR(255),
+  s2 VARCHAR(255),
+  s3 VARCHAR(255),
+  s4 VARCHAR(255),
+  s5 VARCHAR(255)
+) ENGINE=MyISAM;
+
+CREATE TABLE `init` LIKE `syslogs_template`;
+INSERT INTO init (id, timestamp, host_id, program_id, class_id, msg) VALUES (1, 0, 1, 1, 1, "test");
+
+CREATE TABLE stats (
+	timestamp timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
+	type ENUM("load", "archive", "index") NOT NULL,
+	bytes BIGINT UNSIGNED NOT NULL,
+	count BIGINT UNSIGNED NOT NULL,
+	time FLOAT UNSIGNED NOT NULL,
+	PRIMARY KEY (timestamp, type),
+	KEY (type)
+) ENGINE=InnoDB;
+
+CREATE TABLE IF NOT EXISTS host_stats (
+	host_id INT UNSIGNED NOT NULL,
+	class_id SMALLINT UNSIGNED NOT NULL,
+	count MEDIUMINT UNSIGNED NOT NULL DEFAULT 0,
+	timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
+	PRIMARY KEY (timestamp, host_id, class_id)
+) ENGINE=MyISAM;
+
+CREATE TABLE IF NOT EXISTS buffers (
+	id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
+	filename VARCHAR(255) NOT NULL,
+	pid INT UNSIGNED,
+	timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
+	index_complete BOOLEAN NOT NULL DEFAULT 0,
+	archive_complete BOOLEAN NOT NULL DEFAULT 0,
+	start INT UNSIGNED,
+	end INT UNSIGNED,
+	import_id INT UNSIGNED,
+	UNIQUE KEY (filename)
+) ENGINE=InnoDB;
+
+CREATE TABLE IF NOT EXISTS failed_buffers (
+	hash CHAR(32) NOT NULL PRIMARY KEY,
+	dest VARCHAR(8000) NOT NULL,
+	timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
+	args TEXT,
+	pid INT UNSIGNED
+) ENGINE=InnoDB;
+
+CREATE OR REPLACE VIEW v_indexes AS
+SELECT id, type, FROM_UNIXTIME(start) AS start, FROM_UNIXTIME(end) AS end, last_id-first_id AS records, locked_by
+FROM indexes;
+
+CREATE TABLE IF NOT EXISTS livetail (
+	qid INT UNSIGNED NOT NULL PRIMARY KEY,
+	query BLOB
+) ENGINE=InnoDB;
+
+CREATE TABLE IF NOT EXISTS livetail_results (
+	qid INT UNSIGNED NOT NULL,
+	`id` bigint unsigned NOT NULL PRIMARY KEY AUTO_INCREMENT,
+	`timestamp` INT UNSIGNED NOT NULL DEFAULT 0,
+	`host_id` INT UNSIGNED NOT NULL DEFAULT '1',
+	`program_id` INT UNSIGNED NOT NULL DEFAULT '1',
+	`class_id` SMALLINT unsigned NOT NULL DEFAULT '1',
+	msg TEXT,
+	i0 INT UNSIGNED,
+	i1 INT UNSIGNED,
+	i2 INT UNSIGNED,
+	i3 INT UNSIGNED,
+	i4 INT UNSIGNED,
+	i5 INT UNSIGNED,
+	s0 VARCHAR(255),
+	s1 VARCHAR(255),
+	s2 VARCHAR(255),
+	s3 VARCHAR(255),
+	s4 VARCHAR(255),
+	s5 VARCHAR(255),
+	FOREIGN KEY (qid) REFERENCES livetail (qid) ON DELETE CASCADE ON UPDATE CASCADE,
+	KEY (timestamp)
+) ENGINE=InnoDB;
+
+CREATE TABLE IF NOT EXISTS imports (
+	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
+	name VARCHAR(255) NOT NULL,
+	description VARCHAR(255) NOT NULL,
+	datatype VARCHAR(255) NOT NULL,
+	imported TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
+	first_id BIGINT UNSIGNED,
+	last_id BIGINT UNSIGNED,
+	KEY(first_id),
+	KEY(last_id)
+) ENGINE=InnoDB;
+
+CREATE TABLE IF NOT EXISTS uploads (
+	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
+	timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
+	client_ip INT UNSIGNED NOT NULL,
+	count INT UNSIGNED NOT NULL,
+	size BIGINT UNSIGNED NOT NULL,
+	batch_time SMALLINT UNSIGNED NOT NULL,
+	errors SMALLINT UNSIGNED NOT NULL,
+	start INT UNSIGNED NOT NULL,
+	end INT UNSIGNED NOT NULL,
+	buffers_id INT UNSIGNED NOT NULL
+) ENGINE=InnoDB;
