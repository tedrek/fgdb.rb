#!/bin/sh

set -C
set -e
set -u

CUR=$(svn info /var/www/fgdb.rb/current/ | awk -F : '/^URL: /{split($3, a, "/"); sub("release_1.0.", "", a[7]); print a[7]}')
NEW=$(( $CUR + 1 ))

cd /var/www/fgdb.rb/
sudo mr -c config update
cd current
sudo env RAILS_ENV=production rake db:migrate
pg_dump fgdb_production > ~/post-sprint-$NEW.sql

sudo a2dissite release
sudo a2ensite data
sudo invoke-rc.d apache2 reload
