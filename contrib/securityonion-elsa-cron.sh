#!/bin/sh

eval $(perl -Mlocal::lib=/opt/elsa/perl5)

# check to see if we're already running
for pid in $(pidof -x securityonion-elsa-cron.sh); do
    if [ $pid != $$ ]; then
        echo_error_msg 0 "Process is already running with PID $pid"
        exit 1
    fi
done

perl /opt/elsa/web/cron.pl -c /etc/elsa_web.conf
