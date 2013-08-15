use strict;
use warnings;

use Test::More tests => 2;
use Test::Deep;

use Code;

my $code = Code->new;

subtest 'dest' => sub {
   my @tests = (
      [undef, undef],
      [''    => [0, 0, 0]],
      ['A'   => [1, 0, 0]],
      ['MD'  => [0, 1, 1]],
      ['AMD' => [1, 1, 1]],
   );

   foreach my $t (@tests) {
      cmp_deeply $code->dest($t->[0]), $t->[1];
   }
};

subtest 'jump' => sub {
   my @tests = (
      [undef, undef],
      [''    => [0, 0, 0]],
      ['JGT' => [0, 0, 1]],
      ['JEQ' => [0, 1, 0]],
      ['JGE' => [0, 1, 1]],
      ['JLT' => [1, 0, 0]],
      ['JNE' => [1, 0, 1]],
      ['JLE' => [1, 1, 0]],
      ['JMP' => [1, 1, 1]],
   );

   foreach my $t (@tests) {
      cmp_deeply $code->jump($t->[0]), $t->[1];
   }
};

done_testing;
