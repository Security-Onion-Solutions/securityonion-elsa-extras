Description: <short summary of the patch>
 TODO: Put a short summary on the line above and replace this paragraph
 with a longer explanation of this change. Complete the meta-information
 with other relevant fields (see below for details). To make it easier, the
 information below has been extracted from the changelog. Adjust it or drop
 it.
 .
 securityonion-elsa-extras (20131117-1ubuntu0securityonion83) precise; urgency=low
 .
   * add cli.sh
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
+++ securityonion-elsa-extras-20131117/contrib/cli.sh
@@ -0,0 +1,28 @@
+#!/bin/sh
+
+CONF="/etc/elsa_web.conf"
+
+# Error checking
+if [ ! -f $CONF ]; then
+	echo "Error: $CONF not found."
+	exit 1
+fi
+if ! grep "\"apikeys\":" $CONF >/dev/null 2>&1; then
+	echo "Error: apikeys section not found in $CONF."
+	exit 1
+fi
+
+# Parse USER and APIKEY out of $CONF
+USER=`grep -A1 "\"apikeys\":" $CONF | grep -v apikeys | cut -d\" -f2`
+APIKEY=`grep -A1 "\"apikeys\":" $CONF | grep -v apikeys | cut -d\" -f4`
+
+# Required for ELSA API
+EPOCH=$(date '+%s')
+HASH=$(printf '%s' "$EPOCH$APIKEY" |shasum -a 512)
+HEADER=$(echo "Authorization: ApiKey $USER:$EPOCH:$HASH" | sed -e s'/\-//')
+
+# QUERY is passed to this script as an argument
+QUERY=$1
+
+# Submit the query
+curl -k -XPOST -H "$HEADER" -F "permissions={ \"class_id\": { \"0\": 1 }, \"program_id\": { \"0\": 1 }, \"node_id\": { \"0\": 1 }, \"host_id\": { \"0\": 1 } }" -F "query_string=$QUERY" https://127.0.0.1:3154/API/query 2>/dev/null
