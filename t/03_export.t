use strict;
use warnings;
use Test::More tests => 1;

use Lingua::JA::Gal qw(text2gal);
use utf8;

isnt( text2gal("こんにちは"), "こんにちは" );
