package Bing::OpenSearch::Result;

use strict;
use warnings;

use Carp qw( croak );

use XML::LibXML;
use Class::Std::Utils;

use Bing::OpenSearch::MediaContent;
use Bing::OpenSearch::MediaThumbnail;

use version; our $VERSION = qv('0.0.2');

# We use inside-out objects.
# See Chapters 15 and 16 of "Perl Best Practices" (O'Reilly, 2005) for details.
# Objects of this class have the following attributes
my %title_of;
my %link_of;
my %guid_of;
my %description_of;
my %pubDate_of;
my %media_content_of;
my %media_thumbnail_of;

sub new
{
    my $class = shift;
    my $node = shift; # XML::LibXML::Element object

    my $result={};
    bless $result, $class;

    # Convert an object reference into a unique ID number
    my $id_num = ident $result;

    if ($node->getElementsByTagName('title')) {
        $title_of{$id_num} = ${$node->getElementsByTagName('title')}[0]->textContent;
    }
    if ($node->getElementsByTagName('link')) {
        $link_of{$id_num} = ${$node->getElementsByTagName('link')}[0]->textContent;
    }
    if ($node->getElementsByTagName('guid')) {
        $guid_of{$id_num} = ${$node->getElementsByTagName('guid')}[0]->textContent;
    }
    if ($node->getElementsByTagName('description')) {
        $description_of{$id_num} = ${$node->getElementsByTagName('description')}[0]->textContent;
    }
    if ($node->getElementsByTagName('pubDate')) {
        $pubDate_of{$id_num} = ${$node->getElementsByTagName('pubDate')}[0]->textContent;
    }

    if ($node->getElementsByTagName('media:content')) {
        my $media_content = ${$node->getElementsByTagName('media:content')}[0];
        $media_content_of{$id_num} = Bing::OpenSearch::MediaContent->new($media_content);
    }
    if ($node->getElementsByTagName('media:thumbnail')) {
        my $media_thumbnail = ${$node->getElementsByTagName('media:thumbnail')}[0];
        $media_thumbnail_of{$id_num} = Bing::OpenSearch::MediaThumbnail->new($media_thumbnail);
    }

    return $result;
}

sub DESTROY {
    my $self = shift;

    my $id_num = ident $self;

    delete $title_of{$id_num};
    delete $link_of{$id_num};
    delete $guid_of{$id_num};
    delete $description_of{$id_num};
    delete $pubDate_of{$id_num};
    delete $media_content_of{$id_num};
    delete $media_thumbnail_of{$id_num};
}

# get title
sub title {
    my $self = shift;
    ref $self or croak "Instance variable needed.\n";
    $title_of{ident $self};
}

# get link
sub link {
    my $self = shift;
    ref $self or croak "Instance variable needed.\n";
    $link_of{ident $self};
}

# get guid
sub guid {
    my $self = shift;
    ref $self or croak "Instance variable needed.\n";
    $guid_of{ident $self};
}

# get description
sub description {
    my $self = shift;
    ref $self or croak "Instance variable needed.\n";
    $description_of{ident $self};
}

# get pubDate
sub pubDate {
    my $self = shift;
    ref $self or croak "Instance variable needed.\n";
    $pubDate_of{ident $self};
}

# get media:content hash
sub media_content {
    my $self = shift;
    ref $self or croak "Instance variable needed.\n";
    $media_content_of{ident $self};
}

# get media:thumbnail hash
sub media_thumbnail {
    my $self = shift;
    ref $self or croak "Instance variable needed.\n";
    $media_thumbnail_of{ident $self};
}

1;
__END__

=head1 NAME

Bing::OpenSearch::Result - Class representing a single result from a Bing OpenSearch query.

=head1 VERSION

Version 0.0.2

=head1 PACKAGE USE

You don't need to C<use> this package directly.

=head1 DESCRIPTION

A Result object is a single result from a Bing OpenSearch query that provides access methods for
all sub-elements of item elements of the RSS response feed.

=head1 CONSTRUCTOR

=head2 new( $item )

Constructs a new instance of Bing::OpenSearch::Response using a XML::LibXML::Element object ($item)
which represents an item element of the RSS response feed. You don't need to use this method.

=head1 METHODS

=head2 title

Returns the title of a result.

=head2 link

Returns the link of a result.

=head2 guid

Returns the guid of a result.

=head2 description

Returns the description of a result.

=head2 pubDate

Returns the pubDate of a result.

=head2 media_content

Returns the media:content of a result as a L<Bing::OpenSearch::MediaContent> object
(only for a result from an image search query).

=head2 media_thumbnail

Returns the media:thumbnail of a result as a L<Bing::OpenSearch::MediaThumbnail> object
(only for a result from an image search query).

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
