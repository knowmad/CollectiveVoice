use strict;
use warnings;

use Dancer2;
use Test::More import => ['!pass'];
use Test::WWW::Mechanize::PSGI;
BEGIN {
  $ENV{DANCER_CONFDIR}     = 't/config';
  $ENV{DANCER_VIEWS}       = 't/config/views';
  $ENV{EMAIL_SENDER_TRANSPORT} = 'Test' # Don't send emails!
}

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
# TODO: JAC Help Me!!ern  
use Data::Dumper;
print Dumper(config->{'contact_email'});
print Dumper(config->{'appname'});

my @good_emails = Email::Sender::Simple->default_transport->deliveries;
my $recipients  = scalar config->{ contact_email }->@*;
cmp_ok( scalar @good_emails, '==', $recipients,
    "...and we sent an email to each recipient when a complete form was received."
);

done_testing();
