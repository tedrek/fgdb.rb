#!/bin/sh

echo "$(date -R): Triggering fgdb to sync $1 #$2"

if [ -z "$FGDB" ]; then
    FGDB="data"
fi
RES="$(curl -s "http://${FGDB}/${1}/civicrm_sync/${2}")"

set -e

if [ "$RES" = "ok" ]; then
    "$SCRIPT" rm "$@"
else
    "$SCRIPT" take_a_break
fi
