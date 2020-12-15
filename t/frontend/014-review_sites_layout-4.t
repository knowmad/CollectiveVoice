use strict;
use warnings;

use Test::More import => ['!pass'];
use Test::WWW::Mechanize::PSGI;

BEGIN {
    $ENV{DANCER_CONFDIR}     = 't/config';
    $ENV{DANCER_ENVDIR}      = 't/config/environments';
    $ENV{DANCER_ENVIRONMENT} = 'testing-4site';
    $ENV{DANCER_VIEWS}       = 't/config/views';
}

use CV;
my $app = CV->to_app;
is (ref $app, 'CODE', 'Got the test app');
my $mech = Test::WWW::Mechanize::PSGI->new( app => $app );

$mech->get_ok('/');
#diag($mech->content);
$mech->content_contains("4 - Acme Widgets, Inc.", "Company name is loaded from the correct config file");
$mech->content_contains("Google", "Loaded the top review site");

$mech->content_contains("Facebook", "Load review site #1");
$mech->content_contains('<div id="review_site_1" ');

$mech->content_contains("Yelp", "Load review site #2");
$mech->content_contains('<div id="review_site_2" ');

$mech->content_contains("Upcity", "Load review site #4");
$mech->content_contains('<div id="review_site_3" ');

done_testing();
