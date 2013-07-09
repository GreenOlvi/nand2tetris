use strict;
use warnings;

use Test::More tests => 2;

use Parser;

my $parser = Parser->new({ filename => '..\add\add.asm' });

my $types = {
   $Parser::A_COMMAND => 'A command',
   $Parser::C_COMMAND => 'C command',
   $Parser::L_COMMAND => 'L command',
};

subtest 'commandType' => sub {
   my $tests = {
      $Parser::A_COMMAND => ['@1', '@som.e_varia:ble_na$me123'],
      $Parser::C_COMMAND => ['0', 'D=M', 'D+A', 'D | M', 'M;JEQ'],
      $Parser::L_COMMAND => ['(label)', '(other_label222)'],
   };

   foreach my $type ($Parser::A_COMMAND, $Parser::C_COMMAND, $Parser::L_COMMAND) {
      foreach my $cmd (@{$tests->{$type}}) {
         is $parser->commandType($cmd), $type, "Command '$cmd' is $types->{$type}";
      }
   }
};

subtest 'symbol' => sub {
   my $tests = {
      $Parser::A_COMMAND => [
         ['@1', undef],
         ['@som.e_varia:ble_na$me123', 'som.e_varia:ble_na$me123'],
      ],
      $Parser::C_COMMAND => [
         ['0', undef],
         ['D=M', undef],
         ['M;JEQ', undef],
      ],
      $Parser::L_COMMAND => [
         ['(label)', 'label'],
         ['(other_label222)', 'other_label222'],
      ],
   };

   foreach my $type ($Parser::A_COMMAND, $Parser::C_COMMAND, $Parser::L_COMMAND) {
      foreach my $t (@{$tests->{$type}}) {
         is $parser->symbol($type, $t->[0]), $t->[1],
            sprintf "Symbol from '%s' is %s", $t->[0], defined $t->[1] ? "'$t->[1]'" : 'undef';
      }
   }
};

done_testing;
