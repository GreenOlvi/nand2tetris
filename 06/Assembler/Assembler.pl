#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;

use lib 'lib';

use Parser;

use Data::Dumper;

my $parser = Parser->new({ filename => $ARGV[0] });

while ($parser->advance) {
   say $parser->{current};
}

exit 0;
