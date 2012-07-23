#!/bin/sh

BACKUP_DIR=/usr/local/zhora-backup/incoming/

#if ! test -f $BACKUP_DIR/I_AM_THE_BACKUPS; then
#    echo "ERROR: $BACKUP_DIR isn't the backup dir"
#    exit 1
#fi

set -C
set -e
set -u

cd ~/fgdb.rb
git pull
./script/do_i_have_everything_installed_right

CUR=$(cat /var/www/fgdb.rb/.git/HEAD  | sed 's,ref: refs/heads/release_1.0.,,')
NEW=$(( $CUR + 1 ))

cd /var/www/fgdb.rb/
sudo git fetch origin
sudo git checkout db/schema.rb
sudo git checkout -b release_1.0.$NEW origin/release_1.0.$NEW
sudo env RAILS_ENV=production rake db:migrate
sudo git checkout db/schema.rb
pg_dump fgdb_production > $BACKUP_DIR/post-sprint-$NEW.sql.bz2

#sudo invoke-rc.d thin start
sudo rm tmp/release.txt
sudo invoke-rc.d apache2 restart
