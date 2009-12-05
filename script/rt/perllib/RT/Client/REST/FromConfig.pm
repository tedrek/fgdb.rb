package RT::Client::REST::FromConfig;

use strict;
use Config::RT;

use RT::Client::REST;
use base 'RT::Client::REST';

sub new {
  my $class = shift;
  my $config = Config::RT->new(@_);
  my $rt = RT::Client::REST->new(
                                 server  => $config->server,
                                );
  $rt->login(
             username=> $config->username,
             password=> $config->password
             );
  return $rt;
}

1;
