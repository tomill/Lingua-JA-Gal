use inc::Module::Install;
name 'Lingua-JA-Gal';
all_from 'lib/Lingua/JA/Gal.pm';

build_requires 'Test::More';
build_requires 'YAML';

requires 'File::ShareDir';
requires 'Unicode::Japanese';

yaml2pl('dat/lexicon.yaml' => 'share/lexicon.pl');

install_share;
auto_include;

WriteAll;

sub yaml2pl {
    my ($yaml, $pl) = @_;
    
    die "Please install YAML\n" unless eval { require YAML; 1 };
    
    use Data::Dumper;
    local $Data::Dumper::Terse = 1;

    mkdir 'share'; 
    open my $in, '<:encoding(utf-8)', $yaml or die $!;
    open my $out, '>', $pl or die $!;
    print $out Dumper( YAML::LoadFile($in) );
    close $out;
    close $in;
}
