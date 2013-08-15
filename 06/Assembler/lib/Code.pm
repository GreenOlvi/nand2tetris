package Code;

use strict;
use warnings;
use v5.10;

sub new { bless {}, $_[0] };

sub dest {
   my $self = shift;
   my $dest = shift;

   return unless defined $dest;

   my $d1 = $dest =~ m/A/ ? 1 : 0;
   my $d2 = $dest =~ m/D/ ? 1 : 0;
   my $d3 = $dest =~ m/M/ ? 1 : 0;

   return [$d1, $d2, $d3];
}

sub comp {}

my $jumps = {
   ''    => [0, 0, 0],
   'JGT' => [0, 0, 1],
   'JEQ' => [0, 1, 0],
   'JGE' => [0, 1, 1],
   'JLT' => [1, 0, 0],
   'JNE' => [1, 0, 1],
   'JLE' => [1, 1, 0],
   'JMP' => [1, 1, 1],
};

sub jump {
   my $self = shift;
   my $jump = shift;

   return unless defined $jump;

   return $jumps->{$jump};
}

1;
