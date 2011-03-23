#!/bin/sh

echo "$(date -R): Triggering fgdb to sync $1 #$2"

DB="data"
RES="$(curl -s "http://${DB}/${1}/civicrm_sync/${2}")"

set -e

if [ "$RES" = "ok" ]; then
    "$SCRIPT" rm "$@"
else
    "$SCRIPT" take_a_break
fi
