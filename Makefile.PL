use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Bing::OpenSearch',
    AUTHOR              => 'Kostas Ntonas <kntonas@gmail.com>',
    VERSION_FROM        => 'lib/Bing/OpenSearch.pm',
    ABSTRACT_FROM       => 'lib/Bing/OpenSearch.pm',
    LICENSE             => 'perl',
    PREREQ_PM => {
        'LWP::UserAgent'    => 0,
        'XML::LibXML'       => 0,
        'Class::Std::Utils' => 0,
        'Test::More'        => 0,
        'Test::Exception'   => 0,
        'version'           => 0,
        'Scalar::Util'      => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Bing-OpenSearch-*' },
);
