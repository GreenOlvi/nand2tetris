package SymbolTable;

use strict;
use warnings;
use v5.10;

sub new {
   my $class = shift;

   my $self = {
      next    => 0x0010,
      symbols => {
         SP     => 0x0000,
         LCL    => 0x0001,
         ARG    => 0x0002,
         THIS   => 0x0003,
         THAT   => 0x0004,
         R0     => 0x0000,
         R1     => 0x0001,
         R2     => 0x0002,
         R3     => 0x0003,
         R4     => 0x0004,
         R5     => 0x0005,
         R6     => 0x0006,
         R7     => 0x0007,
         R8     => 0x0008,
         R9     => 0x0009,
         R10    => 0x000A,
         R11    => 0x000B,
         R12    => 0x000C,
         R13    => 0x000D,
         R14    => 0x000E,
         R15    => 0x000F,
         SCREEN => 0x4000,
         KBD    => 0x6000,
      },
   };

   bless $self, $class;
}

sub addEntry {
   my $self    = shift;
   my $symbol  = shift;
   my $address = shift;

   if (not $self->contains($symbol)) {
      if (defined $address) {
         $self->{symbols}->{$symbol} = $address;
      } else {
         $self->{symbols}->{$symbol} = $self->{next};
         $self->{next}++;
      }
   }

   return;
}

sub contains {
   my $self   = shift;
   my $symbol = shift;

   return defined($self->{symbols}->{$symbol}) ? 1 : 0;
}

sub getAddress {
   my $self   = shift;
   my $symbol = shift;

   return $self->{symbols}->{$symbol};
}

1;
