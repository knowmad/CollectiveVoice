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
is (ref $app, 'CODE', 'Got the test app');
my $mech = Test::WWW::Mechanize::PSGI->new( app => $app );

$mech->get_ok('/');
$mech->content_contains("1 - Acme Widgets, Inc.", "Company name is loaded from the correct config file");
$mech->content_contains("Google", "Loaded the top review site");
$mech->content_lacks("Facebook", "Did not load review site");
$mech->content_lacks("Yelp", "Did not load review site");
$mech->content_lacks("Upcity", "Did not load review site");

done_testing();
