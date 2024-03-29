use strict;
use warnings;
use Modern::Perl;
use Data::Dumper;

use Test::More import => ['!pass'];
use Test::WWW::Mechanize::PSGI;

BEGIN { require_ok "CV::Foo" or BAIL_OUT "Can't load CV::Foo. Did you include the '-It/lib' in your prove call?"; }

use CV;
#use CV::Foo;

BEGIN {
  $ENV{DANCER_CONFDIR}     = 't/config/callback';
  $ENV{DANCER_ENVDIR}      = 't/config/environments';
  $ENV{DANCER_ENVIRONMENT} = 'testing-3site';
  $ENV{DANCER_VIEWS}       = 't/config/views';

  # Don't send emails!
  $ENV{EMAIL_SENDER_TRANSPORT} = 'Test'
}

# initialize the PSGI app
my $app = CV->to_app;
is (ref $app, 'CODE', 'Got the test app');

# Call the echo routine in our callback module
my $e = CV::Foo::echo('test');
is($e,'test','Callback `echo` routine worked as expected');


# TODO: JAC - is there a way to do this???
SKIP: {
  skip "Need way to test that the `before_feedback` and `after_feedback` subroutines have run.", 1;
  # Test the before_feedback subroutine
  # TODO: How are we going to do this? I want to be able to bail out if this callback tells it to.
  #say Dumper(CV->config);
  #diag(CV->can('before_feedback'));
  ok( CV->can('before_feedback'), 'before_feedback sub can be called' );

  # Test the after_feedback subroutine
  # TODO: How are we going to do this? Use an external file?
  ok( CV->can('after_feedback'), 'after_feedback sub can be called' );
}

done_testing();
