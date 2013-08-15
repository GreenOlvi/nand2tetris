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

sub jump {}

1;
