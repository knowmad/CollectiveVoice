# Test that the google analytics block is not loaded when `ga3_id` is not defined
use strict;
use warnings;

use Test::More import => ['!pass'];
use Test::WWW::Mechanize::PSGI;

BEGIN {
    $ENV{DANCER_CONFDIR}     = 't/config';
    $ENV{DANCER_ENVDIR}      = 't/config/environments';
    $ENV{DANCER_ENVIRONMENT} = 'testing-2site';
    $ENV{DANCER_VIEWS}       = 't/config/views';
}

use CV;

my $app = CV->to_app;

my $mech = Test::WWW::Mechanize::PSGI->new( app => $app );

$mech->get_ok('/');
$mech->content_lacks('www.googletagmanager.com/gtag', "Google analytics code not found.");

done_testing();
