#!/usr/bin/env perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

use CV;
use Plack::Builder;
use Dancer2::Debugger;

my $debugger = Dancer2::Debugger->new;
my $app      = CV->to_app;

builder {
    if( $ENV{ DANCER_ENVIRONMENT } eq 'debug' ) {
        $debugger->mount;

        mount '/' => builder {
            enable_if { $ENV{DANCER_ENVIRONMENT} eq 'debug' } 'DebugLogging';
            $debugger->enable;
            $app;
        }
    } else {
        mount '/' => builder {
            $app;
        }
    }
}

