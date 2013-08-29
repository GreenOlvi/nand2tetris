package Parser;

use strict;
use warnings;
use v5.10;

our $C_ARITHMETIC = 0x1;
our $C_PUSH       = 0x2;
our $C_POP        = 0x4;
our $C_LABEL      = 0x8;
our $C_GOTO       = 0x10;
our $C_IF         = 0x20;
our $C_FUNCTION   = 0x40;
our $C_RETURN     = 0x80;
our $C_CALL       = 0x100;


my $is_comment = qr|\s*(//.*)|;

sub new {
   my $class = shift;
   my $args  = shift;

   my $self = {};

   open(my $fh, '<', $args->{filename});
   my @lines = <$fh>;
   chomp @lines;

   $self->{lines} = [@lines];

   my $obj = bless $self, $class;
   $obj->reset;

   return $obj;
}

sub reset {
   my $self = shift;

   $self->{line} = 0;
   $self->{iter} = _make_iterator($self->{lines});

   return;
}

sub _make_iterator {
   my @lines = @{ shift() };
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

   my $cmd = $self->{iter}->() || return;

   my @parts = split /\s+/, $cmd, 2;
   my $type  = $self->type(@parts);

   $self->{line}++;

   return {
      cmd   => $cmd,
      line  => $self->{line},
      parts => [@parts],
   };
}

sub type {
   my $self = shift;
   my ($arg1, $args2) = @_;
}

1;
