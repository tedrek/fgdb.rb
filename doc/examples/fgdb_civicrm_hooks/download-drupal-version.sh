#!/bin/sh

die() {
    echo "$@"
    exit 1
}

VERSION=$1
if [ -z "$VERSION" ];then
    die "Please specify a version to download"
fi

cd /home/ryan52/code/drupal

if [ -d "$VERSION" ]; then
    die "$VERSION already exists, please remove/displace ~/code/drupal/$VERSION"
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
