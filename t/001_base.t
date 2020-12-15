use strict;
use warnings;

use Test::More import => ['!pass'];

use_ok 'CV';

# initialize the PSGI app
my $app = CV->to_app;
is (ref $app, 'CODE', 'Got the test app');


done_testing();
