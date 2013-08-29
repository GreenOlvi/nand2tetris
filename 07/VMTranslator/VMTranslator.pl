#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;

use lib 'lib';

use Parser;
use Code;

use Data::Dumper;

my $parser = Parser->new({ filename => $ARGV[0] });
say Dumper $parser;

while (my $cmd = $parser->advance) {
   say Dumper $cmd;
}

exit 0;
