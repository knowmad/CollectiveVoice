use strict;
use warnings;

#use Test::More tests => 1;
use Test::More import => ['!pass'];
use Test::WWW::Mechanize::PSGI;

BEGIN {
    $ENV{DANCER_CONFDIR}     = '/';
}

use CV;

# initialize the PSGI app
my $app = CV->to_app;
is (ref $app, 'CODE', 'Got the test app');

# test loading a page without config file set
#  (see frontend/001-index.t for how to define path to DANCER_CONFDIR)
my $mech = Test::WWW::Mechanize::PSGI->new( app => $app );
$mech->get('/');
is( $mech->status, '500', 'no review_sites set in config');

done_testing();
