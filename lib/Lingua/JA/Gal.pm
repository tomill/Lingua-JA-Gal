package Lingua::JA::Gal;
use strict;
use warnings;
our $VERSION = '0.01';

use utf8;
use File::ShareDir 'module_file';
use Unicode::Japanese;

our $Lexicon ||= do {
    my $file = module_file(__PACKAGE__, 'lexicon.pl');
    do $file;
};

sub gal {
    my $class   = shift if $_[0] eq __PACKAGE__; ## no critic
    my $text    = shift || "";
    my $options = shift || {};
    
    $options->{rate} = 100 if not defined $options->{rate};
     
    $text =~ s{(.)}{ gal_char($1, $options) }ge;
    $text;
}

sub gal_char {
    my ($char, $options) = @_;
     
    my $suggestions = do {
        my $normalized = Unicode::Japanese->new($char)->z2h->h2zKana->getu;
        $Lexicon->{ $normalized } || [];
    };
     
    if (my $callback = $options->{callback}) {
        return $callback->($char, $suggestions, $options);
    }

    if (@$suggestions && int(rand 100) < $options->{rate}) {
        return $suggestions->[ int(rand @$suggestions) ];
    } else {
        return $char;
    }
}

1;
__END__

=encoding utf-8

=head1 NAME

Lingua::JA::Gal - Leet speak by Japanese gals

=head1 SYNOPSIS

  use Lingua::JA::Gal;
  use utf8;
   
  $text = Lingua::JA::Gal->gal("こんにちは"); # "⊇ｗ丨ﾆちﾚ￡"
  $text = Lingua::JA::Gal->gal("こんにちは", { rate => 50 }); # "⊇ん(ﾆちは"

=head1 DESCRIPTION

Lingua::JA::Gal converts Japanese text into "ギャル文字" style.
It's a writing style (like L<http://en.wikipedia.org/wiki/Leet>)
on the cellphone mail, made by Japanese teenage girls.

=head1 METHODS

=over 4

=item gal( $text, [ \%options ] )

  Lingua::JA::Gal->gal("こんにちは");

C<\%options> can take

=over 4

=item C<rate>

for converting rate. default is 100.

  Lingua::JA::Gal->gal($text, { rate => 100 }); # full(default)
  Lingua::JA::Gal->gal($text, { rate =>  50 }); # harf
  Lingua::JA::Gal->gal($text, { rate =>   0 }); # nothing

=item C<callback>

if you want to do your own way.

  my $kanjionly = sub {
      my ($char, $suggestions, $options) = @_;
       
      if ($char =~ /p{Han}/) {
          return $suggestions->[ int(rand @$suggestions) ];
      } else {
          return $char;
      }
  };
  
  Lingua::JA::Gal->gal($text, { callback => $kanjionly }); # 漢字のみ

=back

=back

=head1 SEE ALSO

L<http://ja.wikipedia.org/wiki/%E3%82%AE%E3%83%A3%E3%83%AB%E6%96%87%E5%AD%97>

L<http://coderepos.org/share/browser/lang/perl/Lingua-JA-Gal> (repository)

=head1 AUTHOR

Naoki Tomita E<lt>tomita@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
