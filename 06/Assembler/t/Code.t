use strict;
use warnings;

use Test::More tests => 3;
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

subtest 'comp' => sub {
   my @tests = (
      [undef, undef],
      ['-1'  => [0, 1, 1, 1, 0, 1, 0]],
      ['M'   => [1, 1, 1, 0, 0, 0, 0]],
      ['!A'  => [0, 1, 1, 0 ,0 ,0, 1]],
      ['-D'  => [0, 0, 0, 1, 1, 1, 1]],
      ['M+1' => [1, 1, 1, 0, 1, 1, 1]],
      ['D+A' => [0, 0, 0, 0, 0, 1, 0]],
      ['A-D' => [0, 0, 0, 0, 1, 1, 1]],
      ['D&M' => [1, 0, 0, 0, 0, 0, 0]],
      ['D|A' => [0, 0, 1, 0, 1, 0, 1]],
   );

   foreach my $t (@tests) {
      cmp_deeply $code->comp($t->[0]), $t->[1];
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
