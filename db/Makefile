#!/usr/bin/make -f

all: update_devel_data_version devel_data.sql

devel_data.sql: devel_data.sql.lzma
	lzcat devel_data.sql.lzma > devel_data.sql

devel_data.sql.lzma: devel_data_version
	wget http://dev.freegeek.org/~ryan52/devel_data.sql.lzma -O devel_data.sql.lzma

update_devel_data_version:
	wget http://dev.freegeek.org/~ryan52/version -O devel_data_version.new
	if [ ! -f devel_data_version ] || [ -n \"$(shell diff devel_data_version devel_data_version.new)\" ]; then mv devel_data_version.new devel_data_version; else rm devel_data_version.new; fi
