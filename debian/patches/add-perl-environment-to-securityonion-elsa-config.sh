Description: <short summary of the patch>
 TODO: Put a short summary on the line above and replace this paragraph
 with a longer explanation of this change. Complete the meta-information
 with other relevant fields (see below for details). To make it easier, the
 information below has been extracted from the changelog. Adjust it or drop
 it.
 .
 securityonion-elsa-extras (20151011-1ubuntu1securityonion6) trusty; urgency=medium
 .
   * add perl environment to securityonion-elsa-config.sh
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

--- securityonion-elsa-extras-20151011.orig/bin/securityonion-elsa-config.sh
+++ securityonion-elsa-extras-20151011/bin/securityonion-elsa-config.sh
@@ -7,6 +7,9 @@ LOGGER="tee -a $LOG"
 BASE_DIR="/opt"
 DATA_DIR="/nsm/elsa/data"
 
+# define Perl environment variables so that perl scripts can find our modules in /opt/elsa/perl5
+eval $(perl -Mlocal::lib=/opt/elsa/perl5)
+
 function check_config_perms {
 	GROUP_NAME="securityonion"
 	if [ -d /var/lib/mysql/snorby/ ]; then 
