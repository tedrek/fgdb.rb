#!/bin/sh

set -C
set -e
set -u

CUR=$(svn info /var/www/fgdb.rb/current/ | awk -F : '/^URL: /{split($3, a, "/"); sub("release_1.0.", "", a[7]); print a[7]}')
NEW=$(( $CUR + 1 ))

cd /var/www/fgdb.rb/
sudo mv current/public/_release.html current/public/release.html
sudo invoke-rc.d thin stop

pg_dump fgdb_production > ~/pre-sprint-$NEW.sql

echo "Check ~/pre-sprint-$NEW.sql"
