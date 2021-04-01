use strict;
use warnings;

use Test::More import => ['!pass'];

BEGIN { require_ok "CV::Foo" or BAIL_OUT "Can't load CV::Foo. Did you include the '-It/lib in your prove call?'"; }

use CV;
use CV::Foo;

# initialize the PSGI app
my $app = CV->to_app;
is (ref $app, 'CODE', 'Got the test app');

# Can we run the callback routine?
my $e = CV::Foo::echo('test');
is($e,'test','Callback routine worked as expected');


done_testing();
