#!/usr/bin/perl

use strict;
use warnings;

my $config =  "/etc/svn/rtrc";

use RT::Client::REST;    
use RT::Client::REST::Ticket;    

use JSON;

my $F;
open $F, $config;
my %conf = ();
foreach(<$F>) {
    my @a = split /\s+/, $_;
    $conf{$a[0]} = $a[1];
}

my $rt = RT::Client::REST->new(server => $conf{server});
$rt->login(username => $conf{user}, password => $conf{passwd});

my $json = JSON->new->allow_nonref;

my $f = $ARGV[0];
open my $FH, '<', $f;
my @a = <$FH>;
my $json_s = join '', @a;

my $data = $json->decode($json_s);

#print "HERES YOUR INFORMATION\n";
#use Data::Dumper;
#print Dumper($data) . "\n";

$data{}; # to be pushed into fields

exit;

my $subject = $ARGV[0];
my $requestor = 'ryan@freegeek.org'; # FIXME pull from JSON

my $ticket = RT::Client::REST::Ticket->new(
    rt  => $rt,
    priority => 50,
    requestors => [$requestor],
    queue => 'TechSupport',
    subject => $subject,
    cf => {
      'field one' => 'a',
      'field two' => 'b',
    },
    )->store;
print $ticket->id . "\n";

