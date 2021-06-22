# Test setting the `ga3_id` config value
use strict;
use warnings;

use Test::More import => ['!pass'];
use Test::WWW::Mechanize::PSGI;

BEGIN {
    $ENV{DANCER_CONFDIR}     = 't/config/widget-ga3';
    $ENV{DANCER_ENVDIR}      = 't/config/environments';
    $ENV{DANCER_ENVIRONMENT} = 'testing-2site';
    $ENV{DANCER_VIEWS}       = 't/config/views';
}

use CV;

my $app = CV->to_app;

my $mech = Test::WWW::Mechanize::PSGI->new( app => $app );

$mech->get_ok('/');
$mech->content_contains('www.googletagmanager.com/gtag', "Found Google analytics code block.");
$mech->content_contains('UA-145136876-1', "Found the Google analytics measurement id.");

done_testing();
