Description: <short summary of the patch>
 TODO: Put a short summary on the line above and replace this paragraph
 with a longer explanation of this change. Complete the meta-information
 with other relevant fields (see below for details). To make it easier, the
 information below has been extracted from the changelog. Adjust it or drop
 it.
 .
 securityonion-elsa-extras (20151011-1ubuntu1securityonion3) trusty; urgency=medium
 .
   * fix interface from syslog-ng to elsa.pl
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

--- /dev/null
+++ securityonion-elsa-extras-20151011/contrib/securityonion-elsa-syslog-ng.sh
@@ -0,0 +1,5 @@
+#!/bin/sh
+
+eval $(perl -Mlocal::lib=/opt/elsa/perl5)
+
+perl /opt/elsa/node/elsa.pl -c /etc/elsa_node.conf
--- securityonion-elsa-extras-20151011.orig/contrib/securityonion-syslog-ng.conf
+++ securityonion-elsa-extras-20151011/contrib/securityonion-syslog-ng.conf
@@ -58,7 +58,7 @@ source s_bro_rdp { file("/nsm/bro/logs/c
 source s_bro_pe { file("/nsm/bro/logs/current/pe.log" flags(no-parse) program_override("bro_pe")); };
 source s_bro_sip { file("/nsm/bro/logs/current/sip.log" flags(no-parse) program_override("bro_sip")); };
 
-destination d_elsa { program("perl /opt/elsa/node/elsa.pl -c /etc/elsa_node.conf" template(t_db_parsed)); };
+destination d_elsa { program("sh /opt/elsa/contrib/securityonion/contrib/securityonion-elsa-syslog-ng.sh" template(t_db_parsed)); };
 
 log { 
 	source(s_bro_conn);
