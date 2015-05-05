#!/bin/sh

CONF="/etc/elsa_web.conf"

# Error checking
if [ ! -f $CONF ]; then
	echo "Error: $CONF not found."
	exit 1
fi
if ! grep "\"apikeys\":" $CONF >/dev/null 2>&1; then
	echo "Error: apikeys section not found in $CONF."
	exit 1
fi

# Parse USER and APIKEY out of $CONF
USER=`grep -A1 "\"apikeys\":" $CONF | grep -v apikeys | cut -d\" -f2`
APIKEY=`grep -A1 "\"apikeys\":" $CONF | grep -v apikeys | cut -d\" -f4`

# Required for ELSA API
EPOCH=$(date '+%s')
HASH=$(printf '%s' "$EPOCH$APIKEY" |shasum -a 512)
HEADER=$(echo "Authorization: ApiKey $USER:$EPOCH:$HASH" | sed -e s'/\-//')

# QUERY is passed to this script as an argument
QUERY=$1

# Submit the query
curl -k -XPOST -H "$HEADER" -F "permissions={ \"class_id\": { \"0\": 1 }, \"program_id\": { \"0\": 1 }, \"node_id\": { \"0\": 1 }, \"host_id\": { \"0\": 1 } }" -F "query_string=$QUERY" https://127.0.0.1:3154/API/query 2>/dev/null
