#!/bin/sh

DB="data"
RES="$(curl -s "http://${DB}/${1}/civicrm_sync/${2}")"

set -e

if [ "$RES" = "ok" ]; then
    "$SCRIPT" rm "$@"
else
    "$SCRIPT" take_a_break
fi
