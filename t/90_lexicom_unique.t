use strict;
use Test::More 'no_plan';

my $file = 'dat/lexicon.yaml';

my %count;
open my $fh, "<", $file or die $!;
while (<$fh>) {
    chomp;
    next unless /"([^"]+)"/;
    $count{$1}++;
}

for my $char (keys %count) {
    is $count{$char}, 1, $char;
}

