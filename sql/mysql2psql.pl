#!/usr/bin/perl
#
# Convert a mysqldump dump to something postgres can slurp
#
# Created: 2000-11-29 by Zach
#

$/ = ";\n";

# how many inserts/transaction
$tx_size = 100000;

$oldfh = select(STDOUT);
$| = 1;
select($oldfh);

$outputfile = $ARGV[1] || "output.sql";
$dmloutputfile = $ARGV[2] || "dmloutput.sql";

$table_substitutions_re = "";
%table_substitutions = ();

open(IN, "<$ARGV[0]") || die("couldn't open input: $!");

print "Writing ddl.$outputfile ...";
open(DDLOUTPUT, ">ddl.$outputfile") || die("coudn't open: $!");

print "Writing seq.$outputfile ...";
open(SEQOUTPUT, ">seq.$outputfile") || die("coudn't open: $!");

print "Writing trigger.$outputfile ...";
open(TRIGGEROUTPUT, ">trigger.$outputfile") || die("coudn't open: $!");

open(DMLOUTPUT, ">$dmloutputfile") || die("couldn't open dml output: $!");
print DMLOUTPUT "BEGIN TRANSACTION;\n";

$output_count = 0;

$insert_count = 0;
while ($sql = <IN>) {
    if ($output_count++ % 1000 == 0) {
	print ".";
    }

    # Convert '#' comments to '--'
    $sql =~ s/^#/--/mg;
    $sql =~ s/^--.*?\n//mg;
    $sql =~ s/^\s*\n//mg;

    if ($sql =~ /drop table/i) {
        $sql =~ s/DROP TABLE IF EXISTS/DROP TABLE/;
    }

    if ($sql =~ /create table (\S+)/i) {
	$table_name = $1;

	# Special case for xach: i used mysql tables named foo_seq with
	# auto_increment keys for faking sequences. Don't convert those
	# to new tables, convert them to sequences.
#	if ($table_name =~ /seq$/) {
#	    push (@sequences, [$table_name]);
#	}
	

	# Clean up the numeric types
	$sql =~ s/\b(tiny|medium|big|small)?int\(\d+\)/integer/g;
	$sql =~ s/ZEROFILL//;
	$sql =~ s/double[ ]*\((\d+(,[ ]*\d+)?)\)/NUMERIC(\1)/g;

	# Clean up the date types
	#$sql =~ s/\bdate\b/datetime/g;
	#$sql =~ s/\btime\b/datetime/g;
	$sql =~ s/\btimestamp\(\d+\)(\s*NOT NULL)?/timestamp default now()/g;

	$sql =~ s/\bblob\b/text/g;


        $sql =~ s/NOT\s+NULL\s+DEFAULT\s+['"]{2}//gi; #"'

	# Convert auto-increment primary keys to use sequences
	if ($sql =~ /\b(\S+) integer .*auto_increment/) {
	    $column_name = $1;
	    $sequence_name = "${table_name}_${column_name}_seq";
	    $sql =~ s/auto_increment/default nextval('$sequence_name')/;
	    #push(@sequences, [$sequence_name, $table_name, $column_name]);
	    #($seq_name, $tbl_name, $col_name) = @$seqref;
	    print SEQOUTPUT "create sequence $sequence_name;\n";
	    if ($table_name && $column_name) {
		print SEQOUTPUT "select setval('$sequence_name', (select max($column_name) from $table_name));\n";
	    }
	    print SEQOUTPUT "\n";
	}

	# Generate created and modified triggers
	if ($sql =~ /created/i) {
	    print TRIGGEROUTPUT "CREATE TRIGGER ${table_name}_created_trigger BEFORE INSERT ON ${table_name} FOR EACH ROW EXECUTE PROCEDURE created_trigger();\n";
		print TRIGGEROUTPUT "CREATE TRIGGER ${table_name}_modified_trigger BEFORE UPDATE ON ${table_name} FOR EACH ROW EXECUTE PROCEDURE modified_trigger();\n";
	    print TRIGGEROUTPUT "\n";
	}

	# Convert enums
	$sql =~ s/\S+ enum\([^\)]+\)/convert_enums($&)/eg;

	# Mysql dumps have: UNIQUE name (name)
	# postgres expects just UNIQUE (name)
	$sql =~ s/\bUNIQUE .* \(/  UNIQUE \(/ig;

	# FIXME: add a --keys-to-indexes option or something
	

	$sql =~ s/^\s*KEY .*$//mig;
	# $sql =~ s/,\s*\);$/\n\);/;

        $sql =~ s/(\s*PRIMARY\s+KEY.*\)).*/\1/i;

	# Remove bogus default values for timestamps
	$sql =~ s/DEFAULT '0000-00-00( 00:00:00)?'//ig;

	# Convert char to varchar (postgres space-pads chars)
	$sql =~ s/\bchar\(/varchar\(/g;
	
        # Remove table TYPE=MyISAM;
        $sql =~ s/\) TYPE=MyISAM;/\);/g;

    }

    if ($sql =~ /^INSERT/i) {
        if ($insert_count++ % $tx_size == 0) {
            print DMLOUTPUT "COMMIT;BEGIN TRANSACTION;\n";
        }
        #change 0 date values to null
        $sql =~ s/0{14}/null/g;
        # add punctuation to timestamp values
        $sql =~ s/([,\(])(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})(?=[,\)])/\1'\2-\3-\4 \5:\6:\7'/g;
        print DMLOUTPUT $sql;
    } else {

        print DDLOUTPUT $sql;
    }

}

print DMLOUTPUT "COMMIT;\n";

#
# Handle all sequences
#

#foreach $seqref (@sequences) {
#    ($seq_name, $tbl_name, $col_name) = @$seqref;
#    print OUTPUT "create sequence $seq_name;\n";
#    if ($tbl_name && $col_name) {
#	print OUTPUT "select setval('$seq_name', (select max($col_name) from $tbl_name));\n";
#    }
#    print OUTPUT "\n";
#}

print "\nPlease examine ddl output for lines containing 'UNIQUE' and add commas at the end of the previous line\n";
print "done\n";


sub convert_enums {
    my($sql) = @_;
    
    if ($sql =~ /(\S+) enum\(([^\)]+)\)/) {
	$column_name = $1;
	$enum_values_orig = $2;
	$enum_values = $enum_values_orig;
	$enum_values =~ s/^'(.*)'$/$1/;
	@enum_values = split("','", $enum_values);
	$longest_enum = 0;
	map {
	    $longest_enum = length($_) if length($_) > $longest_enum;
	} @enum_values;
	$sql =~ s/$column_name enum\([^\)]+\)/$column_name varchar($longest_enum) check ($column_name in ($enum_values_orig))/;
    }
    
    return $sql;
}
