#!/usr/bin/make -f

# TODO: keep a version number with each branch, so that devel data for older branches can be retrieved easily.
# TODO: try ryan52.info and use that if it has it...if not, fall back to freegeek.org. I intend to set up a nightly rsync.

all: download

download: update_devel_data_version devel_data.sql

devel_data.sql: devel_data.sql.lzma
	lzcat devel_data.sql.lzma > devel_data.sql

devel_data.sql.lzma: devel_data_version
	wget http://dev.freegeek.org/~ryan52/devel_data/$(shell cat devel_data_version)/devel_data.sql.lzma -O devel_data.sql.lzma

update_devel_data_version:
	wget http://dev.freegeek.org/~ryan52/version -O devel_data_version.new
	if [ ! -f devel_data_version ] || ! diff devel_data_version devel_data_version.new; then mv devel_data_version.new devel_data_version; else rm devel_data_version.new; fi

create: create_devel_data
clean: clean_devel_data
create_devel_data: clean_devel_data fgdb-devel-data ohaither

fgdb-devel-data: tmp/devel_data/svn_repo/devel_data.sql.lzma
	ln -s db/tmp/devel_data/svn_repo/ ../fgdb-devel-data

committed: clean_devel_data download

ohaither:
	@echo
	@echo "==========================================================="
	@echo "Done."
	@echo
	@echo "Please commit the result here, and then go into"
	@echo "fgdb-devel-data and commit there as well."
	@echo "Then run 'make -C db committed'"
	@echo "==========================================================="
	@echo

clean_devel_data:
	rm -fr tmp/devel_data fgdb-devel-data

tmp/devel_data/dir:
	mkdir -p $@

tmp/devel_data/database.sql.gz: tmp/devel_data/dir
	scp -i ~/.ssh/scp_key tulip:/usr/local/arik/database.sql.gz ./tmp/devel_data/

tmp/devel_data/database.sql: tmp/devel_data/database.sql.gz
	zcat tmp/devel_data/database.sql.gz > tmp/devel_data/database.sql
	sed -i "s/fgdb_production/fgdb_development/g" tmp/devel_data/database.sql

tmp/devel_data/load_db: tmp/devel_data/database.sql
	-dropdb fgdb_development
	createdb fgdb_development
	psql fgdb_development < tmp/devel_data/database.sql
	touch $@

tmp/devel_data/mutate: tmp/devel_data/load_db
	RAILS_ENV=development ../script/data_mutate
	touch $@

tmp/devel_data/devel_data.sql: tmp/devel_data/mutate
	FGDB_INTERNAL_DUMP_FILE=$(shell readlink -f db/tmp/devel_data/devel_data.sql) RAILS_ENV=development rake db:data:dump

tmp/devel_data/devel_data.sql.lzma: tmp/devel_data/devel_data.sql
	cat tmp/devel_data/devel_data.sql | lzma -9 > tmp/devel_data/devel_data.sql.lzma

tmp/devel_data/svn_repo:
	svn co svn+ssh://devo/svn/fgdb-devel-data/trunk tmp/devel_data/svn_repo

tmp/devel_data/svn_repo/devel_data.sql.lzma: tmp/devel_data/devel_data.sql.lzma tmp/devel_data/svn_repo
	cp tmp/devel_data/devel_data.sql.lzma tmp/devel_data/svn_repo/devel_data.sql.lzma
