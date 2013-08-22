use strict;
use warnings;

use Test::More tests => 6;

use Parser;

my $parser = Parser->new({ filename => '../add/Add.asm' });

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
      ''            => ['// comment', ''],
      $typeval->{a} => ['@1', '@som.e_varia:ble_na$me123', '@a_variable    // declared a'],
      $typeval->{c} => ['0', 'D=M', 'D+A', 'D | M', 'M;JEQ', 'D=M       // comment'],
      $typeval->{l} => ['(label)', '(other_label222)', '(exit)     // exit label'],
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
         ['@1', undef],
         ['@som.e_varia:ble_na$me123', 'som.e_varia:ble_na$me123'],
         ['@a_variable    // declared a', 'a_variable'],
      ],
      $typeval->{c} => [
         ['0', undef], ['D=M', undef], ['M;JEQ', undef],
      ],
      $typeval->{l} => [
         ['(label)', 'label'],
         ['(other_label222)', 'other_label222'],
         ['(exit)     // exit label', 'exit'],
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
         ['0', ''], ['D=M', 'D'], ['M;JEQ', ''], ['AMD=0', 'AMD'],
         ['M=!D', 'M'], ['A=D&A', 'A'], ['D=M       // comment', 'D'],
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

subtest 'comp' => sub {
   my $tests = {
      $typeval->{a} => [
         ['@1', undef], ['@som.e_varia:ble_na$me123', undef],
      ],
      $typeval->{c} => [
         ['0', '0'], ['D=M', 'M'], ['M;JEQ', 'M'], ['AMD=0', '0'],
         ['M=!D', '!D'], ['A=D&A', 'D&A'], ['0;JMP', '0'],
         ['D=M       // comment', 'M'],
      ],
      $typeval->{l} => [
         ['(label)', undef], ['(other_label222)', undef],
      ],
   };

   foreach my $type ( @{$typeval}{ qw(a c l) } ) {
      foreach my $t (@{$tests->{$type}}) {
         is $parser->comp($type, $t->[0]), $t->[1],
            sprintf "Comp from '%s' is %s", $t->[0], defined $t->[1] ? "'$t->[1]'" : 'undef';
      }
   }
};

subtest 'jump' => sub {
   my $tests = {
      $typeval->{a} => [
         ['@1', undef], ['@som.e_varia:ble_na$me123', undef],
      ],
      $typeval->{c} => [
         ['0', ''], ['D=M', ''], ['M;JEQ', 'JEQ'], ['AMD=0', ''], ['M=!D', ''],
         ['A=D&A', ''], ['0;JMP', 'JMP'], ['D=M       // comment', ''],
      ],
      $typeval->{l} => [
         ['(label)', undef], ['(other_label222)', undef],
      ],
   };

   foreach my $type ( @{$typeval}{ qw(a c l) } ) {
      foreach my $t (@{$tests->{$type}}) {
         is $parser->jump($type, $t->[0]), $t->[1],
            sprintf "Jump from '%s' is %s", $t->[0], defined $t->[1] ? "'$t->[1]'" : 'undef';
      }
   }
};

subtest 'const' => sub {
   my $tests = {
      $typeval->{a} => [
         ['@1', '1'],
         ['@21314       // value', '21314'],
         ['@som.e_varia:ble_na$me123', undef],
         ['@a_variable    // declared a', undef],
      ],
      $typeval->{c} => [
         ['0', undef], ['D=M', undef], ['M;JEQ', undef],
      ],
      $typeval->{l} => [
         ['(label)', undef],
         ['(other_label222)', undef],
         ['(exit)     // exit label', undef],
      ],
   };

   foreach my $type ( @{$typeval}{ qw(a c l) } ) {
      foreach my $t (@{$tests->{$type}}) {
         is $parser->const($type, $t->[0]), $t->[1],
            sprintf "Const from '%s' is %s", $t->[0], defined $t->[1] ? "'$t->[1]'" : 'undef';
      }
   }
};


done_testing;
