#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;

use lib 'lib';

use Parser;

use Data::Dumper;

my $parser = Parser->new({ filename => $ARGV[0] });

while (my $cmd = $parser->advance) {
   say Dumper $cmd;
}

exit 0;
