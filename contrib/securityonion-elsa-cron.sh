#!/bin/sh

LOG="/nsm/elsa/data/elsa/log/cron.log"

# This cron job runs every minute.
# Under normal circumstances, it will complete in under 10 seconds.
# If it takes longer than 60 seconds, we need to prevent multiple instances.
if ps aux | grep -q "perl /opt/elsa/web/cron.pl -c /etc/elsa_web.con[f]"; then
	echo "/opt/elsa/web/cron.pl is already running:" >> $LOG
	ps aux | grep "perl /opt/elsa/web/cron.pl -c /etc/elsa_web.con[f]" >> $LOG
	exit
fi

eval $(perl -Mlocal::lib=/opt/elsa/perl5)

perl /opt/elsa/web/cron.pl -c /etc/elsa_web.conf
