#!/bin/sh

set -e

die() {
    echo "$@"
    exit 1
}

VERSION=$1
if [ -z "$VERSION" ];then
    die "Please specify a version to download"
fi

cd /home/ryan52/code/civicrm/

if [ -d "$VERSION" ]; then
    die "$VERSION already exists, please remove/displace ~/code/civicrm/$VERSION"
fi

mkdir "$VERSION"
cd "$VERSION"

TAR="civicrm-${VERSION}-drupal.tar.gz"
wget -O $TAR "http://downloads.sourceforge.net/project/civicrm/civicrm-stable/${VERSION}/${TAR}"
tar xzvf $TAR

