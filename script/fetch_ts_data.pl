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

my $ticket = RT::Client::REST::Ticket->new( rt => $rt, id => $ARGV[0])->retrieve;
my $it = $ticket->transactions->get_iterator;
my $content = &$it->content;

my %data = ();

$data{"ID"} = $ticket->id;
$data{"Subject"} = $ticket->subject;
$data{"Queue"} = $ticket->queue;
$data{"Created"} = $ticket->created;
$data{"Adopter Name"} = $ticket->cf('AdopterName');
$data{"Adopter ID"} = $ticket->cf('AdopterID');
$data{"Technician ID"} = $ticket->cf('Intake Technician ID');
$data{"Phone"} = $ticket->cf('phone');
$data{"Email"} = $ticket->cf('Email');
$data{"Type of Box"} = $ticket->cf('Type of Box');
$data{"Source"} = $ticket->cf('Box source');
$data{"System ID"} = $ticket->cf('SystemID');
$data{"Warranty"} = $ticket->cf('Warranty');
my $issue = $ticket->cf('Tech Support Issue');
if(ref($issue) =~ /ARRAY/) {
    $data{"Issues"} = join ", ", @{$issue};
} else {
    $data{"Issues"} = $issue;
}
$data{"Initial Content"} = $content;

my $json = JSON->new->allow_nonref;
print $json->encode(\%data) . "\n";

