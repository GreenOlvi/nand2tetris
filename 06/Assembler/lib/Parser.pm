package Parser;

use strict;
use warnings;
use v5.10;


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
         return $_ if _is_command($_);
      }
      return;
   };
}

sub _is_command {
   my $line = shift;
   return 0 if $line =~ m|^//|;
   return 0 if $line eq '';
   return 1;
}

sub advance {
   my $self = shift;
   $self->{current} = $self->{iter}->();
   return defined $self->{current} ? 1 : 0;
}

sub commandType {
   my $self = shift;
}

sub symbol {
   my $self = shift;
}

1;
