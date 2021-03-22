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

# Test each honeytrap field, and see if we are sent for reeducation.
$mech->get('/');
$mech->field( go => 'spam' );
$mech->click_button( id => 'send_feedback' );
sleep 1;
$mech->base_is( 'https://en.wikipedia.org/wiki/Three_Laws_of_Robotics',
    "Bots falling for the visually hidden field get re-educated" );

$mech->get('/');
$mech->field( away => 'spam' );
$mech->click_button( id => 'send_feedback' );
sleep 1;
$mech->base_is( 'https://en.wikipedia.org/wiki/Three_Laws_of_Robotics',
    "...as do bots filling in the actually hidden field" );

# Send a blank form, check for an error
$mech->get('/');
$mech->post( '/feedback', {} );
is( $mech->status, 400, 'Get a 400 status when posting an empty form. Good.' );


# Do we get 200 OK on success?
$mech->post_ok( '/feedback', {
        full_name     => 'Test User',
        email_address => 'none@none.com',
        phone_number  => '8005551212',
        feedback      => 'You did well, and I should have given you more stars.',
    });

# Can we go to receive thanks if so?
$mech->get_ok( '/thanks', '...and get thanked for doing so!' );


# Can we only go to get thanked once?
$mech->get('http://localhost/thanks'); # Get us back from wikipedia
$mech->base_is( 'http://localhost/', 'You can only be thanked once, going back to /' );

done_testing();
