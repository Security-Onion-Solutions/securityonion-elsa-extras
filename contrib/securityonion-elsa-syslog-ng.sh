#!/bin/sh

eval $(perl -Mlocal::lib=/opt/elsa/perl5)

perl /opt/elsa/node/elsa.pl -c /etc/elsa_node.conf
