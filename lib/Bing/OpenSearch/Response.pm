package Bing::OpenSearch::Response;

use strict;
use warnings;

use Carp qw( croak );

use XML::LibXML;
use Class::Std::Utils;
use Encode;

use Bing::OpenSearch::Result;

use version; our $VERSION = qv('0.0.2');

# We use inside-out objects.
# See Chapters 15 and 16 of "Perl Best Practices" (O'Reilly, 2005) for details.
# Objects of this class have the following attributes
my %totalResults_of;
my %queryURL_of;
my %content_of;
my %results_of;
my %space_of;

sub new
{
    my ($class, $xml, $url, $space) = @_;

    my $response={};
    bless $response, $class;

    # Convert an object reference into a unique ID number
    my $id_num = ident $response;

    $queryURL_of{$id_num} = $url;
    $content_of{$id_num} = $xml;

    my $parser = XML::LibXML->new();

    # turn the parser warnings on and turn the parser's recover mode off
    $parser->recover_silently(0);

    # do not maintain white-space in the document
    $parser->keep_blanks(0);

    my $doc; # XML::LibXML::Document object, which is a DOM object

    eval { $doc = $parser->parse_string($xml) };

    if ($@) {
        croak "XML::LibXML parser error: $@";
    }

    $doc->indexElements(); # This function causes libxml2 to stamp all
    # elements in a document with their document position index which
    # considerably speeds up XPath queries for large documents.

    $totalResults_of{$id_num} = 0;
    if ($doc->getElementsByTagName('os:totalResults')) {
        $totalResults_of{$id_num} = ${$doc->getElementsByTagName('os:totalResults')}[0]->textContent;
    }

    $space_of{$id_num} = $space;

    my $itemList = $doc->getElementsByTagName('item'); # returns a XML::LibXML::NodeList object (SCALAR context)
    my @items;
    if ($itemList) {
        @items = $itemList->get_nodelist;
    }

    my @results;
    for my $item (@items) {
        my $result = Bing::OpenSearch::Result->new($item);
        push @results, $result;
    }

    $results_of{$id_num} = \@results;

    return $response;
}

sub DESTROY {
    my $self = shift;

    my $id_num = ident $self;

    delete $totalResults_of{$id_num};
    delete $queryURL_of{$id_num};
    delete $content_of{$id_num};
    delete $results_of{$id_num};
    delete $space_of{$id_num};
}

# get content
sub content {
    my $self = shift;
    ref $self or croak "Instance variable needed.\n";
    $content_of{ident $self};
}

# get queryURL
sub queryURL {
    my $self = shift;
    ref $self or croak "Instance variable needed.\n";
    $queryURL_of{ident $self};
}

# get totalResults
sub totalResults {
    my $self = shift;
    ref $self or croak "Instance variable needed.\n";
    $totalResults_of{ident $self};
}

# get results
sub results {
    my $self = shift;
    ref $self or croak "Instance variable needed.\n";
    return @{$results_of{ident $self}} if wantarray; # list context - return array of results
    return $results_of{ident $self}; # scalar context - return reference to the array of results
}

# get search space from which the results derived
sub space {
    my $self = shift;
    ref $self or croak "Instance variable needed.\n";
    $space_of{ident $self};
}

# save the response RSS feed to a UTF-8 file
sub save {
    my ($self, $filename) = @_;
    ref $self or croak "Instance variable needed.\n";

    open my $fh, '>:utf8', $filename;
    print $fh decode_utf8($self->content);
    close $fh;
}

1;
__END__

=head1 NAME

Bing::OpenSearch::Response - Container object for the result set of one query to the Bing OpenSearch interface.

=head1 VERSION

Version 0.0.2

=head1 PACKAGE USE

You don't need to C<use> this package directly.

=head1 CONSTRUCTOR

=head2 new( $xml, $url, $space )

Constructs a new instance of Bing::OpenSearch::Response using the RSS response feed
content ($xml), the query URL ($url) built for this particular query and the search
space queried ($space). You don't need to use this method.

=head1 METHODS

=head2 content

Returns the raw content of the RSS response feed.

=head2 queryURL

Returns the query URL built for the given search query.

=head2 results

Returns an array of L<Bing::OpenSearch::Result> objects if called in a list context.
If called in a scalar context, it returns a reference to the array of results.

=head2 totalResults

Returns the number of hits found.

=head2 space

Returns the search space from which the results derived.

=head2 save

Save the response RSS feed to a UTF-8 file.

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
