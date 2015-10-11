Description: <short summary of the patch>
 TODO: Put a short summary on the line above and replace this paragraph
 with a longer explanation of this change. Complete the meta-information
 with other relevant fields (see below for details). To make it easier, the
 information below has been extracted from the changelog. Adjust it or drop
 it.
 .
 securityonion-elsa-extras (20151011-1ubuntu1securityonion5) trusty; urgency=medium
 .
   * add local::lib to elsa_startup.pl
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
@@ -232,6 +232,9 @@ function config_webnode() {
 	ELSA_STARTUP="/etc/apache2/elsa_startup.pl"
 	cat "$BASE_DIR/elsa/web/conf/startup.pl" | sed -e "s|\/usr\/local|$BASE_DIR|g" | sed -e "s|\/data|$DATA_DIR|g" > $ELSA_STARTUP ||
 		echo "Error writing $ELSA_STARTUP."
+	if ! grep "/opt/elsa/perl5" $ELSA_STARTUP >/dev/null 2>&1; then
+		sed -i '/use warnings;/a use local::lib "/opt/elsa/perl5";' $ELSA_STARTUP 
+	fi
 	PERL_CONF="/etc/apache2/mods-available/perl.conf"
 	if [ ! -f $PERL_CONF ]; then
 		echo "PerlPostConfigRequire /etc/apache2/elsa_startup.pl" > $PERL_CONF || echo "Error writing $PERL_CONF."
