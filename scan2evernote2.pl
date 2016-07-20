#!/usr/bin/env perl

use strict;
use warnings;
use 5.24.0;

use Email::Stuffer;

use autodie qw( system );

use Data::Dumper;

our $VERSION = "0.01";
$VERSION = eval $VERSION;


# TODO
# move settings to a config file

# scan
system("perl","./scanadf.pl","-d","brother4:bus7;dev1",'--source','Automatic Document Feeder(left aligned,Duplex)','--resolution','200');

# trim white and grey space
my @images = glob('image-[0-9][0-9][0-9][0-9]');
system('mogrify','-fuzz','25%', '-trim', '-trim','-bordercolor', 'black', '-border',
       '1', '-fuzz', '95%', '-fill', 'white', '-draw', 'color 0,0 floodfill', '-alpha', 'off',
       '-shave', '1x1', '-format', 'jpg', @images);

# -bordercolor black -border 1 -fuzz 95% -fill white -draw "color 0,0 floodfill" -alpha off -shave 1x1
# see http://www.imagemagick.org/discourse-server/viewtopic.php?t=21442

# mogrify -fuzz 25% -trim -trim -bordercolor black -border 1 -fuzz 95% -fill white -draw "color 0,0 floodfill" -alpha off -shave 1x1 -normalize -level 10%,90% -sharpen 0x1 -format png image-[0-9][0-9][0-9][0-9]
#http://dikant.de/2013/05/01/optimizing-scanned-documents-with-imagemagick/


# delete even numbered blank pages
my @jpgimageseven = glob('*[02468].jpg');
say "deleting blank even numbered pages:";
system('./detectblank.sh',@jpgimageseven);

# add files to an email and send
my @jpgimages = glob('*.jpg');


my $email = Email::Stuffer->from         ('someone@somewhere.com.notreal')
  ->to           ('mysecretevernoteemailaddress@evernote.com')
  ->subject      ('scan2evernote @scanned')
  #->cc          ('someotheraddress@wherever.notreal')
  ;


foreach my $jpgimage (@jpgimages) {
  $email->attach_file($jpgimage);
}

$email->send;
  
  
# delete files
unlink @images;
unlink @jpgimages;


