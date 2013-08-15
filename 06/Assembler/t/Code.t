use strict;
use warnings;

use Test::More tests => 1;
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

done_testing;
