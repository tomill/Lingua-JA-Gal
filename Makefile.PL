use inc::Module::Install;

name 'Lingua-JA-Gal';
all_from 'lib/Lingua/JA/Gal.pm';

requires 'File::ShareDir' => '1.00';
requires 'Unicode::Japanese';

test_requires 'Test::More';

install_share 'share';
auto_include;

WriteAll;
