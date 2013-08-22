use strict;
use warnings;
use v5.10;

use Test::More tests => 3;
use Test::Deep;

use SymbolTable;


subtest 'addEntry' => sub {
   my $symbol = SymbolTable->new;

   $symbol->addEntry('i');
   ok $symbol->contains('i');

   $symbol->addEntry('R4');
   ok $symbol->contains('R4');

   $symbol->addEntry('label', 15);
   ok $symbol->contains('label');
   is $symbol->getAddress('label'), 15;
};

subtest 'contains' => sub {
   my $symbol = SymbolTable->new;

   ok $symbol->contains('THIS');

   ok not $symbol->contains('aaaa');

   $symbol->addEntry('aaaa');
   ok $symbol->contains('aaaa');
};

subtest 'getAddress' => sub {
   my $symbol = SymbolTable->new;

   is $symbol->getAddress('SCREEN'), 0x4000;

   is $symbol->getAddress('aaaa'), undef;

   $symbol->addEntry('aaaa');
   is $symbol->getAddress('aaaa'), 0x0010;
};

done_testing;
