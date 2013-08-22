#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;

use lib 'lib';

use Parser;
use Code;

use Data::Dumper;

my $parser = Parser->new({ filename => $ARGV[0] });
my $code   = Code->new;

while (my $cmd = $parser->advance) {
   if ($cmd->{type} == $Parser::A_COMMAND) {
      die sprintf("Undefined symbol '%s' in line %d", $cmd->{symbol} || '', $cmd->{line}) unless defined($cmd->{const});
      my $const = $code->const($cmd->{const});
      say (0, @$const);
   } elsif ($cmd->{type} == $Parser::C_COMMAND) {
      my $dest = $code->dest($cmd->{dest});
      my $comp = $code->comp($cmd->{comp});
      my $jump = $code->jump($cmd->{jump});
      say (1, 1, 1, @$comp, @$dest, @$jump);
   }
}

exit 0;
