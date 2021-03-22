use strict;
use warnings;

use Test::More import => ['!pass'];
use Test::WWW::Mechanize::PSGI;

BEGIN {
  $ENV{DANCER_CONFDIR}     = 't/config';
  $ENV{DANCER_ENVDIR}      = 't/config/environments';
  $ENV{DANCER_ENVIRONMENT} = 'testing-3site';
  $ENV{DANCER_VIEWS}       = 't/config/views';

  # Don't send emails!
  $ENV{EMAIL_SENDER_TRANSPORT} = 'Test'
}

use CV;
my $app = CV->to_app;
is (ref $app, 'CODE', 'Got the test app');

my $mech = Test::WWW::Mechanize::PSGI->new( app => $app );

# Submit a form
$mech->post_ok( '/feedback', {
        full_name     => 'Test User',
        email_address => 'none@none.com',
        phone_number  => '8005551212',
        feedback      => 'You did well, and I should have given you more stars.',
    });


# Test the callback


done_testing();
