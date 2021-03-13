# Test leaving the rating_threshold empty in config.yml
use strict;
use warnings;

use Test::More import => ['!pass'];
use Test::WWW::Mechanize::PSGI;

BEGIN {
    $ENV{DANCER_CONFDIR}     = 't/config';
    $ENV{DANCER_ENVDIR}      = 't/config/environments';
    $ENV{DANCER_ENVIRONMENT} = 'testing-1site';
    $ENV{DANCER_VIEWS}       = 't/config/views';
}

use CV;

my $app = CV->to_app;

my $mech = Test::WWW::Mechanize::PSGI->new( app => $app );

$mech->get_ok('/');
$mech->content_contains('if (rating > 3) {', "Rating threshold was set");

done_testing();
