#!/usr/local/bin/perl

use strict;
use warnings;

use Data::Dumper qw( Dumper );

# combine all steps into one helicon processing script!


my $heliconexecutable = "/Applications/HeliconFocus.app/Contents/MacOS/HeliconFocus";



my ( $capturecount , $globpath ) = @ARGV;

if ( ! $capturecount ) { die( " No Capture Count!\n" ); }
if ( ! $globpath ) { die( " No Path!\n" ); }

$globpath .= "/\*.JPG";


print "Processing stacks of " . $capturecount . "\n";
print "search path: " . $globpath . "\n";





my @tempfilelist = glob( $globpath );

my @filelist = ();

foreach ( @tempfilelist ) { 
	
	$_ =~ /\/([^\/]+?)$/;
	
	if ( not $1 ) { next; }
	
	push( @filelist , $1 );
	
}

$globpath =~ /(^.*)\//;
my $path = $1;

print "Found " . @filelist . " files\n";

print "Processing in " . $path . "\n";



# make folders
mkdir( $path . "/origonals" );
mkdir( $path . "/temp" );
mkdir( $path . "/stacks" ); 

my $stacknumber = 0;



while ( @filelist > 0 ) {
	
	my @stackfiles = ();
	
	# assemble each stack
	foreach my $filenumber ( 1 .. $capturecount ) {
	
		my $currentfilename = shift( @filelist );
		
		push( @stackfiles , $currentfilename );
	
		print @filelist . " : " . $filenumber . " : " . $currentfilename . "\n";
		
		
		# move to origonals
		print "Moving to origonals.\n";
		`mv $path/$currentfilename $path/origonals/$currentfilename`;
		
		# crop to temp
		print "Cropping to temp folder.\n";
		`magick $path/origonals/$currentfilename -crop '4500x4000+1360+130' $path/temp/$currentfilename`;
	
	}
	
	
	# now we have some nice cropped images in temp, so lets stack them.
	print "Executing Helicon.\n";
	`$heliconexecutable -silent -tif:u -save:$path/temp/$stacknumber-uncropped.tif -mp:1 -rp:8 -sp:4 $path/temp`;
	
	# now recrop the stack
	print "Re-cropping stack output.\n";
	`magick $path/temp/$stacknumber-uncropped.tif -crop '4400x3900+50+50' $path/stacks/$stacknumber.tif`;
	
	# delete temp files
	print "Removing temp files.\n";
	foreach my $unlinkfilename ( @stackfiles ) {
		unlink( $path . "/temp/" . $unlinkfilename );
	}
	unlink( "$path/temp/$stacknumber-uncropped.tif" );
		
		
	# increase out stacknumber
	$stacknumber += 1;
	
	
}



# /Applications/HeliconFocus.app/Contents/MacOS/HeliconFocus -silent -save:./testimg.jpg -mp:1 -rp:8 -sp:4 ./testdir
































































