#!/bin/sh

DB="data"
RES="$(curl "http://${DB}/${1}/civicrm_sync/${2}")"

if [ "$RES" = "ok" ]; then
    "$SCRIPT" rm "$@"
else
    "$SCRIPT" take_a_break
fi
