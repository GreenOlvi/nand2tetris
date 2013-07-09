package Parser;

use strict;
use warnings;
use v5.10;

our $A_COMMAND = 0x1;
our $C_COMMAND = 0x2;
our $L_COMMAND = 0x4;

my $is_comment  = qr|//|;
my $is_const    = qr/\d+/;
my $is_symbol   = qr/[A-Za-z_\.\$:][A-Za-z0-9_\.\$:]+/;
my $is_dest     = qr/[ADM]+/;
my $is_comp     = qr/=?.+/;
my $is_jump     = qr/;?.+/;
my $is_acommand = qr/\@($is_const|$is_symbol)/;
my $is_ccommand = qr/($is_jump)?($is_comp)?($is_jump)?/;
my $is_lcommand = qr/\($is_symbol\)/;

sub new {
   my $class = shift;
   my $args  = shift;

   my $self = {
      current => undef,
   };

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
   $self->{current} = $self->{iter}->();
   return defined $self->{current} ? 1 : 0;
}

sub commandType {
   my $self = shift;
   my $cmd = $self->{current};

   if ($cmd =~ m/^$is_acommand$/) {
      return $A_COMMAND;
   } elsif ($cmd =~ m/^$is_ccommand$/) {
      return $C_COMMAND;
   } elsif ($cmd =~ m/^$is_lcommand$/) {
      return $L_COMMAND;
   } else {
      die "Error: unknown command '$cmd'";
   }
}

sub symbol {
   my $self = shift;
}

1;
