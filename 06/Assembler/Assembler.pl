#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;

use lib 'lib';

use Parser;
use Code;
use SymbolTable;


my $parser = Parser->new({ filename => $ARGV[0] });
my $code   = Code->new;
my $symbol = SymbolTable->new;

while (my $cmd = $parser->advance) {
   if ($cmd->{type} == $Parser::L_COMMAND && defined $cmd->{symbol}) {
      $symbol->addEntry($cmd->{symbol}, $cmd->{pc});
   }
}

$parser->reset;

while (my $cmd = $parser->advance) {
   if ($cmd->{type} == $Parser::A_COMMAND) {
      my $val;
      if (defined $cmd->{const}) {
         $val = $code->const($cmd->{const});
      } elsif ($symbol->contains($cmd->{symbol})) {
         $val = $code->const($symbol->getAddress($cmd->{symbol}));
      } else {
         $symbol->addEntry($cmd->{symbol});
         $val = $code->const($symbol->getAddress($cmd->{symbol}));
      }
      say (0, @$val);
   } elsif ($cmd->{type} == $Parser::C_COMMAND) {
      my $dest = $code->dest($cmd->{dest});
      my $comp = $code->comp($cmd->{comp});
      my $jump = $code->jump($cmd->{jump});
      say (1, 1, 1, @$comp, @$dest, @$jump);
   }
}

exit 0;
