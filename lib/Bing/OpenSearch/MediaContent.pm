package Bing::OpenSearch::MediaContent;

use strict;
use warnings;

use Carp qw( croak );

use XML::LibXML;
use Class::Std::Utils;

use version; our $VERSION = qv('0.0.1');

# We use inside-out objects.
# See Chapters 15 and 16 of "Perl Best Practices" (O'Reilly, 2005) for details.
# Objects of this class have the following attributes
my %url_of;
my %height_of;
my %width_of;
my %fileSize_of;
my %type_of;

sub new
{
    my $class = shift;
    my $node = shift; # XML::LibXML::Element object - media:content sub-element

    my $object={};
    bless $object, $class;

    # Convert an object reference into a unique ID number
    my $id_num = ident $object;

    $url_of{$id_num} = $node->getAttribute('url');
    $height_of{$id_num} = $node->getAttribute('height');
    $width_of{$id_num} = $node->getAttribute('width');
    $type_of{$id_num} = $node->getAttribute('type');
    $fileSize_of{$id_num} = $node->getAttribute('fileSize');

    return $object;
}

sub DESTROY {
    my $self = shift;

    my $id_num = ident $self;

    delete $url_of{$id_num};
    delete $height_of{$id_num};
    delete $width_of{$id_num};
    delete $fileSize_of{$id_num};
    delete $type_of{$id_num};
}

# get url
sub url {
    my $self = shift;
    ref $self or croak "Instance variable needed.\n";
    $url_of{ident $self};
}

# get height
sub height {
    my $self = shift;
    ref $self or croak "Instance variable needed.\n";
    $height_of{ident $self};
}

# get width
sub width {
    my $self = shift;
    ref $self or croak "Instance variable needed.\n";
    $width_of{ident $self};
}

# get fileSize
sub fileSize {
    my $self = shift;
    ref $self or croak "Instance variable needed.\n";
    $fileSize_of{ident $self};
}

# get type
sub type {
    my $self = shift;
    ref $self or croak "Instance variable needed.\n";
    $type_of{ident $self};
}

1;
__END__

=head1 NAME

Bing::OpenSearch::MediaContent - Class representing a media:content sub-element of an item element of the Bing OpenSearch compliant response RSS feed.

=head1 VERSION

Version 0.0.1

=head1 PACKAGE USE

You don't need to C<use> this package directly.

=head1 DESCRIPTION

A MediaContent object represents a media:content sub-element of the response RSS feed and provides access methods for
all its attributes.

=head1 CONSTRUCTOR

=head2 new( $node )

Constructs a new instance of Bing::OpenSearch::MediaContent using $node,
which is a XML::LibXML::Element object which represents a media:content
sub-element of the RSS response feed. You don't need to use this method.

=head1 METHODS

=head2 url

Returns the url attribute of a media:content sub-element.

=head2 height

Returns the height attribute of a media:content sub-element.

=head2 width

Returns the width attribute of a media:content sub-element.

=head2 fileSize

Returns the fileSize attribute of a media:content sub-element.

=head2 type

Returns the type attribute of a media:content sub-element.

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2010, Kostas Ntonas, C<<kntonas@gmail.com>>. All rights reserved.

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
