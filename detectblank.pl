#!/usr/bin/env perl

use strict;
use warnings;
use 5.24.0;

use Email::Stuffer;

use autodie qw( system );

use Data::Dumper;

our $VERSION = "0.01";
$VERSION = eval $VERSION;

use Image::Magick;

my($image, $x);

$image = Image::Magick->new;
$x = $image->Read('image-0001', 'image-0002','image-0003','image-0004');
warn "$x" if "$x";

$x = $image->Threshold("50%");
my @histogram = $image->[0]->Histogram();
say Dumper @histogram;
