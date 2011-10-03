#!/bin/sh

set -e

CURRENT=$(readlink /home/ryan52/code/civicrm/current)
LATEST=$(curl -s "http://sourceforge.net/projects/civicrm/files/civicrm-stable/" | sed -n '/Looking for the latest version/ {n;p;}' | sed -n -r '/title=/ {s/.*title="([^"]+)"/\1/; p;}' | cut -d / -f 3)

CURRENT_D=$(readlink /home/ryan52/code/drupal/current)
LATEST_D=$(curl -s "http://drupal.org/project/drupal" | grep "http://ftp.drupal.org/files/projects/" | head -1 | sed -r 's/^[^"]+href="([^"]*)".*/\1/' | sed -e 's/.*\///' -e 's/drupal-//g' -e 's/.tar.gz$//')

if [ "$CURRENT_D" != "$LATEST_D" ]; then
    echo "Upgrade from drupal $CURRENT_D to $LATEST_D is needed"
fi

if [ "$CURRENT" != "$LATEST" ]; then
    echo "Upgrade from civicrm $CURRENT to $LATEST is needed"
fi
