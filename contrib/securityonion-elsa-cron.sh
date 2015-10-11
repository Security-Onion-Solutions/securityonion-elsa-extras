#!/bin/sh

eval $(perl -Mlocal::lib=/opt/elsa/perl5)

perl /opt/elsa/web/cron.pl -c /etc/elsa_web.conf
