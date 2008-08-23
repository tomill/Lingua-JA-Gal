use Test::Dependencies
    exclude => [qw( Test::Dependencies Lingua::JA::Gal )],
    style => 'light';

ok_dependencies();
