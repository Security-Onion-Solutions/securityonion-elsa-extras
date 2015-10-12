#!/bin/bash
 
# starman - this script starts and stops the starman daemon
#
# chkconfig:   - 85 15
# description: Starman 
# processname: starman
# pidfile :    /var/run/starman.pid
# www file:    /var/www/myapp
 
 
# Source function library.
# . /etc/rc.d/init.d/functions
 
 
export starman="/usr/bin/starman"
export myapp_path="/opt/elsa/web/lib"
export pidfile="/var/run/starman.pid"
export myapp="Web" 
eval $(perl -Mlocal::lib=/opt/elsa/perl5)
 
start() {
        echo -n $"Starting Starman: "
        $starman -I${myapp_path} --user=www-data --listen :3154  --daemonize --pid ${pidfile} --error-log /var/log/starman.log ${myapp_path}/${myapp}.psgi
        RETVAL=$?
        echo
        [ $RETVAL = 0 ]
        return $RETVAL
}
 
restart() {
        echo -n $"Restarting Starman: "
        export PID=`cat ${pidfile}`
        kill -s USR2 $PID 
        RETVAL=$?
        echo
        [ $RETVAL = 0 ]
        return $RETVAL
}
 
stop() {
        echo -n $"Stopping Starman: "
        export PID=`cat ${pidfile}`
        kill $PID
        RETVAL=$?
        echo
        [ $RETVAL = 0 ] && rm -f ${pidfile}
}
# See how we were called.
case "$1" in
  start)
        start
        ;;
  restart)
        restart
         ;;
  stop)
        stop
        ;;
  *)
        echo $"Usage: starman {start|restart|stop}"
        exit 1
esac
 
exit $RETVAL
