use strict;
use warnings;

use Test::More skip_all => 'need to rewrite for Email::Sender';



use Test::More import => ['!pass'];
use Test::WWW::Mechanize::PSGI;
BEGIN { $ENV{EMAIL_SENDER_TRANSPORT} = 'Test' } # Don't send emails!

use CV;
my $app = CV->to_app;
is (ref $app, 'CODE', 'Got the test app');

my $mech = Test::WWW::Mechanize::PSGI->new( app => $app );

# Send a blank form, make sure no email was sent
$mech->post( '/feedback', {} );
my @bad_emails = Email::Sender::Simple->default_transport->deliveries;
cmp_ok( scalar @bad_emails, '==', 0, "No emails were sent for an incomplete form. Good news." );

# Do we get 200 OK on success?
$mech->post_ok( '/feedback', {
        full_name     => 'Test User',
        email_address => 'none@none.com',
        phone_number  => '8005551212',
        feedback      => 'You did well, and I should have given you more stars.',
    });

# Check for an email with feedback details
my @good_emails = Email::Sender::Simple->default_transport->deliveries;
cmp_ok( scalar @good_emails, '==', 1, "...and we sent an email when a complete form was received." );

done_testing();
