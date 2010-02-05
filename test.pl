#!/usr/local/bin/perl -w
use strict;
## By virtue of being named "test.pl", this program is automatically run
## via "make test".

use Bing::OpenSearch;

my $response = Bing::OpenSearch->Query( 'Larry Wall', {count => 1} );

my @Results = $response->results;

if (@Results == 1 and $Results[0]->link =~ m{^https?://}) {
    print "Bing::OpenSearch test passes!\n";
}
else {
    die "Bing::OpenSearch test failed: $@\n";
}
