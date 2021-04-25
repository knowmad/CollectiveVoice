use strict;
use warnings;
use Modern::Perl;

use Test::More import => ['!pass'];
use Test::WWW::Mechanize::PSGI;

BEGIN {
  $ENV{DANCER_CONFDIR}     = 't/config/callback';
  $ENV{DANCER_VIEWS}       = 't/config/views';

  # Don't send emails!
  $ENV{EMAIL_SENDER_TRANSPORT} = 'Test';
}

use CV;
my $app = CV->to_app;
is (ref $app, 'CODE', 'Got the test app');
die "No `feedback` setup in config file" unless (exists (CV->config->{ feedback }) );
my $mech = Test::WWW::Mechanize::PSGI->new( app => $app );


##
## before_feedback test
##
# Submit a form by `Test User` that is redirected by CV::Foo and check the status is '200'
$mech->post_ok( '/feedback', {
        full_name     => 'Test User',
        email_address => 'none@none.com',
        phone_number  => '8005551212',
        feedback      => 'You did well, and I should have given you more stars.',
    });

#say $mech->title;
#say $mech->content;
#say $mech->uri;

# Confirm that we are being redirected from CV::Foo
like  ($mech->uri, qr/.*\?foo=1$/, 'URI has `foo=1` appended to the end by before_feedback subroutine');

# Title of returned page is thank you
$mech->title_like( qr/We Thank You - Acme/ );


##
## after_feedback test
##

# Submit a form by `Test User` that is redirected by CV::Foo and check the status is '200'
$mech->post_ok( '/feedback', {
        full_name     => 'Real User',
        email_address => 'none@none.com',
        phone_number  => '8005551212',
        feedback      => 'You did well, and I should have given you more stars.',
    });
# Confirm that we are NOT being redirected from CV::Foo
unlike  ($mech->uri, qr/.*\?foo=1$/, 'URI does NOT have `foo=1` appended to the end by before_feedback subroutine');
# And that after_feedback was run
like  ($mech->uri, qr/.*\?after_foo=1$/, 'URI has `after_foo=1` appended to the end by after_feedback subroutine');


done_testing();
