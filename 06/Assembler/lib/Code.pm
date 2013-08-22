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

my $comps = {
   '0'   => [1, 0, 1, 0, 1, 0],
   '1'   => [1, 1, 1, 1, 1, 1],
   '-1'  => [1, 1, 1, 0, 1, 0],
   'D'   => [0, 0, 1, 1, 0, 0],
   'R'   => [1, 1, 0, 0, 0, 0],
   '!D'  => [0, 0, 1, 1, 0, 1],
   '!R'  => [1, 1, 0 ,0 ,0, 1],
   '-D'  => [0, 0, 1, 1, 1, 1],
   '-R'  => [1, 1, 0, 0, 1, 1],
   'D+1' => [0, 1, 1, 1, 1, 1],
   'R+1' => [1, 1, 0, 1, 1, 1],
   'D-1' => [0, 0, 1, 1, 1, 0],
   'R-1' => [1, 1, 0, 0, 1, 0],
   'D+R' => [0, 0, 0, 0, 1, 0],
   'D-R' => [0, 1, 0, 0, 1, 1],
   'R-D' => [0, 0, 0, 1, 1, 1],
   'D&R' => [0, 0, 0, 0, 0, 0],
   'D|R' => [0, 1, 0, 1, 0, 1],
};

sub comp {
   my $self = shift;
   my $comp = shift;

   return unless defined $comp;

   my $a = $comp =~ m/M/ ? 1 : 0;
   $comp =~ s/[AM]/R/g;

   return [$a, @{$comps->{$comp}}];
}

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

sub const {
   my $self = shift;
   my $val  = shift;

   return unless defined $val;
   return unless $val =~ m/^\d+$/;

   my @bin = reverse map { (2**$_ & $val) ? 1 : 0  } (0..14);

   return \@bin;
}

1;
