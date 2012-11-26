#!/bin/sh

set -e

CURRENT=$(readlink /home/ryan52/code/civicrm/current)
LATEST=$(curl -s "http://qa.debian.org/watch/sf.php/civicrm/" | grep drupal.tar.gz | head -1 | sed -r 's/^.*>([^<]+)<.*$/\1/' | cut -d "-" -f 2)

CURRENT_D=$(readlink /home/ryan52/code/drupal/current)
LATEST_D=$(curl -s "http://drupal.org/project/drupal" | grep "http://ftp.drupal.org/files/projects/" | head -1 | sed -r 's/^[^"]+href="([^"]*)".*/\1/' | sed -e 's/.*\///' -e 's/drupal-//g' -e 's/.tar.gz$//')

if [ "$CURRENT_D" != "$LATEST_D" ]; then
    echo "Upgrade from drupal $CURRENT_D to $LATEST_D is needed"
    echo " To download run:     $(dirname $0)/download-drupal-version.sh ${LATEST_D}"
    echo " To install run:      rm ~/code/drupal/current; ln -s ${LATEST_D} ~/code/drupal/current"
    echo " To upgrade, go to:   http://civicrm/drupal/update.php"
fi

if [ "$CURRENT" != "$LATEST" ]; then
    echo "Upgrade from civicrm $CURRENT to $LATEST is needed"
    echo " To download run:     $(dirname $0)/download-civicrm-version.sh ${LATEST}"
    echo " To install run:      rm ~/code/civicrm/current; ln -s ${LATEST} ~/code/civicrm/current"
    echo " To upgrade, go to:   http://civicrm/drupal/?q=civicrm/upgrade&reset=1"
fi
