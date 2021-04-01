use strict;
use warnings;

use Test::More import => ['!pass'];

BEGIN { require_ok "CV::Foo" or BAIL_OUT "Can't load CV::Foo. Did you include the '-It/lib in your prove call?'"; }

use CV;
use CV::Foo;

# initialize the PSGI app
my $app = CV->to_app;
is (ref $app, 'CODE', 'Got the test app');

SKIP: {
    skip 'Need to fix CV::Foo', 1;
# Can we run the callback routine?
my $d = $app->do_something;
}

done_testing();
