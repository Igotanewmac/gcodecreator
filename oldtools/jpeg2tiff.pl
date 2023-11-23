#!/usr/local/bin/perl

use strict;
use warnings;








my ( $path ) = @ARGV;



if ( ! $path ) { die( " No Path!\n" ); }




open( my $dirhandle , "-|" , "ls -l " . $path ) or die( "Could not open " . $path . "\n" );

mkdir( $path . "/jpeg" );
mkdir( $path . "/tif" );


while (<$dirhandle>) {
	
	#print $_;
	$_ =~ /(IMG_[0-9]{4}).JPG/g;
	
	if ( not $1 ) { next; }
	
	my $currentfilename = $1;
	
	print " : " . $currentfilename . "\n";
	
	# copy this file into the current folder
	if ( !-f "$path/$currentfilename.JPG" ) {
		`magick $path/$currentfilename.JPG $path/$currentfilename.tif`;
		`mv $path/$currentfilename.JPG $path/jpeg/$currentfilename.JPG`;
		`mv $path/$currentfilename.tif $path/tif/$currentfilename.tif`;
		
	}
	
}
























