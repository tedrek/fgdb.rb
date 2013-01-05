#!/bin/sh

sudo ssh -i /root/.ssh/wasp_key root@art /root/fgdb.rb/script/generate_rt_metadata.sh > /var/www/fgdb.rb/config/rt_metadata.txt

