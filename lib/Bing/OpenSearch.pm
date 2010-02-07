package Bing::OpenSearch;

use strict;
use warnings;

use Carp qw( croak );
use Scalar::Util qw( looks_like_number );

use LWP::UserAgent;
use XML::LibXML;

use Bing::OpenSearch::Response;

use version; our $VERSION = qv('0.0.2');

our $agent;

sub Query {
    my ($self, $searchTerms, $params_ref) = @_;

    if ( ! $searchTerms ) {
        croak "A search query must be provided.";
    }

    $searchTerms =~s#\s*\++\s*#\+#g;
    $searchTerms =~s#\s+#%20#g;  # replace white space characters with %20

    my $sourceType = $$params_ref{sourceType} || 'Web';
    if ($sourceType ne 'Web' and $sourceType ne 'Image') {
        croak "The supported search spaces are Web and Image. Please enter a valid sourceType parameter.";
    }

    my $count = $$params_ref{count} || 10;
    if (! looks_like_number $count) {
        croak "The count parameter should be a positive integer.";
    }
    elsif ($count <= 0) {
        croak "The count parameter should be a positive integer.";
    }

    my $startIndex = $$params_ref{offset} || 0;
    if (! looks_like_number $startIndex) {
        croak "The offset parameter should be an integer (>=0).";
    }
    elsif ($startIndex < 0) {
        croak "The offset parameter should be >= 0.";
    }

    my $language = $$params_ref{market};

    my $url = "http://api.bing.com/rss.aspx?source=$sourceType&query=$searchTerms&$sourceType.count=$count&".
              "$sourceType.offset=$startIndex&FORM=MO0000&version=2.0";

    if ($language) {
        $url .= "&market=$language";
    }

    $agent ||= LWP::UserAgent->new(agent => "Bing::OpenSearch ($Bing::OpenSearch::VERSION)", env_proxy  => 1);

    my $response = $agent->get($url);
    unless ($response->is_success) { croak "Failed to fetch $url"; }

    return Bing::OpenSearch::Response->new($response->content, $url, $sourceType);
}

1;
__END__

=head1 NAME

Bing::OpenSearch - Access the OpenSearch compliant RSS interface of the Bing API version 2.0.

=head1 VERSION

Version 0.0.2

=head1 SYNOPSIS

 use strict;
 use warnings;

 use Bing::OpenSearch;

 # Query Bing Image search space for 'Greece'
 my $response = Bing::OpenSearch->Query( 'Greece', { sourceType => 'Image',
                                                     offset => 0,
                                                     count => 10,
                                                     market => 'en-us'
                                                   }
                                       );

 print "Query URL: ", $response->queryURL,"\n";
 print "Number of Results: ", $response->totalResults,"\n";

 for my $item ($response->results) { # parse results and print data
    print "title: ", $item->title,"\n";
    print "link : ", $item->link,"\n";
    print "guid : ", $item->guid,"\n";
    if ($item->description) {
        print "description: ", $item->description,"\n";
    }
    if ($item->pubDate) {
        print "pubDate: ", $item->pubDate,"\n";
    }

    if ($response->space eq 'Image') { # ONLY for Image search space:
        print "media-content-url     : ", $item->media_content->url,"\n";
        print "media-content-height  : ", $item->media_content->height,"\n";
        print "media-content-width   : ", $item->media_content->width,"\n";
        print "media-content-fileSize: ", $item->media_content->fileSize,"\n";
        print "media-content-type    : ", $item->media_content->type,"\n";
        print "media-thumbnail-url   : ", $item->media_thumbnail->url,"\n";
        print "media-thumbnail-height: ", $item->media_thumbnail->height,"\n";
        print "media-thumbnail-width : ", $item->media_thumbnail->width,"\n";
    }
    print "\n";
 }

 # save the response feed to an RSS UTF-8 file
 $response->save('bing_response.rss');

=head1 DESCRIPTION

Bing::OpenSearch facilitates searching Bing through its API Version 2.0 via the OpenSearch compliant RSS interface.
The RSS endpoint is anonymous; it doesn't require an AppID.

The following search spaces (sourceTypes) are supported:

=over

=item * I<Web> - searches for web content.

=item * I<Image> - searches for images on the web.

=back

=head1 INTERFACE

=head2 Query( $searchTerms [, \%params] )

Searches Bing for the given query ($searchTerms) using the given search parameters and
returns a L<Bing::OpenSearch::Response> object.

Valid search parameters include:

=over

=item * I<sourceType> - search space, default is Web.

=item * I<offset> - startIndex, default is 0. Indicates how far into the result set
you are currently processing.

=item * I<count> - number of results requested, default is 10. The maximum number of results returned
from Bing API version 2.0 is 50. However, if you want more results, you can submit multiple queries
and utilize the offset parameter.

=item * I<market> - language code such as en-us (English), el-gr (Greek), es-es (Spanish), etc.
If provided, attempts to restrict the results to those in the given language.

=back

Note that all of these parameters are optional.

=head1 DEPENDENCIES

=over

=item * XML::LibXML

=item * LWP::UserAgent

=item * Scalar::Util

=item * Class::Std::Utils

=item * Encode

=item * version

=item * Test::More

=item * Test::Exception

=back

=head1 Terms of Use

The results returned may not be used, reproduced or transmitted in any manner or for any purpose other
than rendering Bing results within an RSS aggregator for your personal, non-commercial use. Any other use
requires written permission from Microsoft Corporation. By using these results in any manner whatsoever, you
agree to be bound by the foregoing restrictions.

=head1 BUGS AND SUGGESTIONS

Any feedback is very welcome. Please contact me for any bugs, comments or suggestions.

=head1 ACKNOWLEDGEMENTS

Special thanks to Petr Pajas, Damian Conway, Gisle Aas, Andy Lester, Jeffrey Friedl, Michael G Schwern,
Dan Kogai, Adrian Howard, John Peacock, David A P Mitchell and Graham Barr for their great modules and
their huge contribution to the Perl community. And most of all to Larry Wall, the man who started it all.

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2010, Kostas Ntonas, C<<kntonas at gmail.com>>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
