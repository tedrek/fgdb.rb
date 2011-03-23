#!/bin/sh

# the civicrm post hook needs to do this:
# * processor-daemon.sh add donations ID
# * processor-daemon.sh add contacts ID

RES="$(curl "http://data/$1/civicrm_sync/$2")"

if [ "$RES" = "ok" ]; then
    "$SCRIPT" rm "$@"
fi
