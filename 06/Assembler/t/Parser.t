use strict;
use warnings;

use Test::More tests => 3;

use Parser;

my $parser = Parser->new({ filename => '..\add\add.asm' });

my $types = {
   $Parser::A_COMMAND => 'A command',
   $Parser::C_COMMAND => 'C command',
   $Parser::L_COMMAND => 'L command',
};

my $typeval = {
   'a' => $Parser::A_COMMAND,
   'c' => $Parser::C_COMMAND,
   'l' => $Parser::L_COMMAND,
};

subtest 'commandType' => sub {
   my $tests = {
      $typeval->{a} => ['@1', '@som.e_varia:ble_na$me123'],
      $typeval->{c} => ['0', 'D=M', 'D+A', 'D | M', 'M;JEQ'],
      $typeval->{l} => ['(label)', '(other_label222)'],
   };

   foreach my $type ( @{$typeval}{ qw(a c l) } ) {
      foreach my $cmd (@{$tests->{$type}}) {
         is $parser->commandType($cmd), $type, "Command '$cmd' is $types->{$type}";
      }
   }
};

subtest 'symbol' => sub {
   my $tests = {
      $typeval->{a} => [
         ['@1', undef], ['@som.e_varia:ble_na$me123', 'som.e_varia:ble_na$me123'],
      ],
      $typeval->{c} => [
         ['0', undef], ['D=M', undef], ['M;JEQ', undef],
      ],
      $typeval->{l} => [
         ['(label)', 'label'], ['(other_label222)', 'other_label222'],
      ],
   };

   foreach my $type ( @{$typeval}{ qw(a c l) } ) {
      foreach my $t (@{$tests->{$type}}) {
         is $parser->symbol($type, $t->[0]), $t->[1],
            sprintf "Symbol from '%s' is %s", $t->[0], defined $t->[1] ? "'$t->[1]'" : 'undef';
      }
   }
};

subtest 'dest' => sub {
   my $tests = {
      $typeval->{a} => [
         ['@1', undef], ['@som.e_varia:ble_na$me123', undef],
      ],
      $typeval->{c} => [
         ['0', ''], ['D=M', 'D'], ['M;JEQ', ''], ['AMD=0', 'AMD'], ['M=!D'], ['A=D&A'],
      ],
      $typeval->{l} => [
         ['(label)', undef], ['(other_label222)', undef],
      ],
   };

   foreach my $type ( @{$typeval}{ qw(a c l) } ) {
      foreach my $t (@{$tests->{$type}}) {
         is $parser->dest($type, $t->[0]), $t->[1],
            sprintf "Dest from '%s' is %s", $t->[0], defined $t->[1] ? "'$t->[1]'" : 'undef';
      }
   }
};

done_testing;
