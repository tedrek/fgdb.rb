#!/bin/sh

set -e

CURRENT=$(readlink /home/ryan52/code/latest)
LATEST=$(curl -s "http://sourceforge.net/projects/civicrm/files/civicrm-stable/" | sed -n '/Looking for the latest version/ {n;p;}' | sed -n -r '/title=/ {s/.*title="([^"]+)"/\1/; p;}' | cut -d / -f 3)

if [ "$CURRENT" != "$LATEST" ]; then
    echo "Upgrade from civicrm $CURRENT to $LATEST is needed"
fi
