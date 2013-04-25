#!/bin/sh

CODE_DIR=/home/ryan52/code
DRUPAL_DIR=$CODE_DIR/drupal

set -e

die() {
    echo "$@"
    exit 1
}

VERSION=$1
if [ -z "$VERSION" ];then
    die "Please specify a version to download"
fi

cd $DRUPAL_DIR

if [ -d "$VERSION" ]; then
    die "$VERSION already exists, please remove/displace $DRUPAL_DIR/$VERSION"
fi

mkdir "$VERSION"
cd "$VERSION"

DIR="drupal-${VERSION}"
TAR="${DIR}.tar.gz"
wget -O $TAR "http://ftp.drupal.org/files/projects/${TAR}"
tar xzvf $TAR
mv $DIR drupal
rm -fr drupal/sites
ln -sf ../../../sites drupal/sites
