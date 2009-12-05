package Config::RT;

use strict;
use warnings;

use Env qw/HOME/;
use File::Spec;

sub new {
  my $class = shift;
  my $file = $ENV{RTCONFIG};
  if(!defined($file)) {
    $file = File::Spec->catfile($HOME, ".rtrc");
  }
  my $self = {};
  my $F;
  open $F, "<", $file;
  while(<$F>) {
    $_ =~ s/#.*$//;
    next if $_ =~ /^\s*$/;
    my ($key, $value) = split(" ", $_);
    $self->{$key} = $value;
  }
  close $F;
  bless $self, $class;
  return $self;
}

sub username {
  my $self = shift;
  my $value = $ENV{RTUSER};
  if(!defined($value)) {
    $value = $self->{user};
  }
  return $value;
}

sub password {
  my $self = shift;
  my $value = $ENV{RTPASSWD};
  if(!defined($value)) {
    $value = $self->{passwd};
  }
  return $value;
}

sub server {
  my $self = shift;
  my $value = $ENV{RTSERVER};
  if(!defined($value)) {
    $value = $self->{server};
  }
  return $value;
}

1;
