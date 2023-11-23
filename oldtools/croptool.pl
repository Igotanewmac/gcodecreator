#!/usr/local/bin/perl


use strict;
use warnings;



my ( $capturecount , $path ) = @ARGV;



if ( ! $capturecount ) { die( " No Capture Count!\n" ); }
if ( ! $path ) { die( " No Path!\n" ); }




print "Capturing groups of " . $capturecount . "\n";

print "into path: " . $path . "\n";


open( my $dirhandle , "-|" , "ls -l " . $path ) or die( "Could not open " . $path . "\n" );



my $currentfilecounter = 0;
my $currentfoldercounter = 1;

mkdir( $path . "/origonal" );

while (<$dirhandle>) {
	
	#print $_;
	$_ =~ /(IMG_[0-9]{4})\.tif/g;
	
	if ( not $1 ) { next; }
	
	my $currentfilename = $1;
	
	if ( !-f $path . "/" . $currentfilename . ".tif" ) { next; }
	
	print $currentfilecounter . " : " . $currentfilename . "\n";
	
	# copy this file into the current folder
	
	# make sure the folder exists
	if ( !-d $path . "/" . $currentfoldercounter ) {
		print "Creating Folder: " . $currentfoldercounter . "\n";
		`mkdir -p $path/$currentfoldercounter`;
	}
	
	# now do the actual move
	`magick $path/$currentfilename.tif -crop '4520x4020+1360+130' $path/$currentfoldercounter/$currentfilename.tif`;
	`mv $path/$currentfilename.tif $path/origonal/$currentfilename.tif`;
	
	# now increase our file counter
	$currentfilecounter += 1;
	
	# have we moved enough to move on?
	if ( $currentfilecounter == $capturecount ) {
		
		# time for a new folder
		$currentfoldercounter += 1;
		
		# reset the counter
		$currentfilecounter = 0;
		
	}
	
	
}




















