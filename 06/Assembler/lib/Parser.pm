package Parser;

use strict;
use warnings;
use v5.10;

use autodie;

our $A_COMMAND = 0x1;
our $C_COMMAND = 0x2;
our $L_COMMAND = 0x4;

my $is_comment  = qr|//|;
my $is_const    = qr/\d+/;
my $is_symbol   = qr/[A-Za-z_\.\$:][A-Za-z0-9_\.\$:]+/;
my $is_dest     = qr/[ADM]{1,3}=/;
my $is_comp     = qr/.+/;
my $is_jump     = qr/;J.{2}/;
my $is_acommand = qr/\@($is_const|$is_symbol)/;
my $is_ccommand = qr/($is_dest)?($is_comp)($is_jump)?/;
my $is_lcommand = qr/\(($is_symbol)\)/;


my $get_symbol = {
   DEFAULT    => sub {},
   $A_COMMAND => sub {
      my $cmd = shift;
      my ($s) = $cmd =~ qr/^$is_acommand$/;
      return unless $s =~ m/^$is_symbol$/;
      return $s;
   },
   $L_COMMAND => sub {
      my $cmd = shift;
      my ($s) = $cmd =~ qr/^$is_lcommand$/;
      return $s;
   },
};


sub new {
   my $class = shift;
   my $args  = shift;

   my $self = {};

   if ($args->{filename}) {
      open(my $fh, '<', $args->{filename});
      my @lines = <$fh>;
      chomp @lines;
      $self->{iter} = _make_iterator(@lines);
   }

   bless $self, $class;
}

sub _make_iterator {
   my @lines = @_;
   return sub {
      local $_;
      while (defined($_ = shift @lines)) {
         $_ =~ s/^\s+|\s+$//g;
         return $_ if ($_ && $_ !~ m/^$is_comment/);
      }
      return;
   };
}

sub advance {
   my $self = shift;

   my $cmd    = $self->{iter}->() || return;
   my $type   = $self->commandType($cmd);
   my $symbol = $self->symbol($type, $cmd);
   my $dest   = $self->dest($type, $cmd);
   my $comp   = $self->comp($type, $cmd);
   my $jump   = $self->jump($type, $cmd);

   return {
      cmd    => $cmd,
      type   => $type,
      symbol => $symbol,
      dest   => $dest,
      comp   => $comp,
      jump   => $jump,
   };
}

sub commandType {
   my $self = shift;
   my $cmd  = shift;

   return unless (defined $cmd && $cmd ne '');

   if ($cmd =~ m/^$is_acommand$/) {
      return $A_COMMAND;
   } elsif ($cmd =~ m/^$is_lcommand$/) {
      return $L_COMMAND;
   } elsif ($cmd =~ m/^$is_ccommand$/) {
      return $C_COMMAND;
   } else {
      die "Error: unknown command '$cmd'";
   }
}

sub symbol {
   my $self = shift;
   my $type = shift;
   my $cmd  = shift;

   my $fun = $get_symbol->{$type} || $get_symbol->{DEFAULT};

   return $fun->($cmd);
}

sub dest {
   my $self = shift;
   my $type = shift;
   my $cmd = shift;

   return unless $type == $C_COMMAND;

   my ($d) = $cmd =~ m/^$is_ccommand/;
   $d //= '';
   $d =~ s/=$//;

   return $d;
}

sub comp {
   my $self = shift;
   my $type = shift;
   my $cmd = shift;

   return;
}

sub jump {
   my $self = shift;
   my $type = shift;
   my $cmd  = shift;

   return;
}

1;
