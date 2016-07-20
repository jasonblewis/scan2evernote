#!/usr/bin/env perl

use 5.24.0;
use strict;
use warnings;

use Image::Magick;

my($image, $x);

$image = Image::Magick->new;
$x = $image->Read('image-0001', 'image-0002','image-0003');
warn "$x" if "$x";

# $x = $image->Deskew("40%");
# warn "$x" if "$x";

$x = $image->Border(height=>10,width=>10,bordercolor=>"white");
warn "$x" if "$x";

# trim to take off white bottom
$x = $image->Trim();
warn "$x" if "$x";

#trim again to take of white strip at bottom
$image->Set(fuzz=>90);

$x = $image->Border(height=>10,width=>10,bordercolor=>"white");
$x = $image->Trim();
warn "$x" if "$x";



# $x = $image->Border(height=>50,width=>50,bordercolor=>"rgb(117,128,132)");
# warn "$x" if "$x";

# $image->Set(fuzz=>80);
# $x = $image->Trim();
# warn "$x" if "$x";


$x = $image->Write('x.png');
warn "$x" if "$x";

