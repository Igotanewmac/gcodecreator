#!/usr/local/bin/perl

use strict;
use warnings;





# create a location

# top left
my $xpos = 0;
my $ypos = 0;
my $zpos = 0;

# bottom right
my $xposmax = 35;
my $yposmax = 17.5;
my $zposmax = 8;

# create some lens related details
my $stepsizex = 5;
my $stepsizey = 3.5;
my $stepsizez = 0.25;

# distance to move in backlash compensation
my $backlashz = -10;
my $backlashx = -10;
my $backlashy = -10;




# create some state information
my $xdir = 1;

my $takephotos = 1;




# take a z-stack
sub takeshot {
	
		
	while ( $zpos < $zposmax ) {
		
		print "( Zpos: " . $zpos . " )\n";
		print "G00 Z" . $zpos . "\n";
		
		print "( shutter click! )\n";
		
		if ( $takephotos == 1 ) {
			print "G4 P0.25\n";
			print "M8\n";
			print "G4 P0.1\n";
			print "M4\n";
			print "G4 P0.25\n";
			print "M3\n";
			print "G4 P0.1\n";
			print "M9\n";
			
			# delay for upload
			print "G4 P1.5\n";
		
		}
		else {
			
			print "G4 P1\n";
			
			
			
		}
		
		$zpos += $stepsizez;
		
	}
	
	$zpos = -1;
	#print "( Zpos: " . $backlashz . " )\n";
	#print "G00 Z" . $backlashz . "\n";
	
	$zpos = 0;
	#print "( Zpos: " . $zpos . " )\n";
	#print "G00 Z0\n";
	
	
	
	
}















print "%\n";



print "( ---------- )\n";
print "( Program Settings )\n";
print "( X max: " . $xposmax . ")\n";
print "( X step: " . $stepsizex . ")\n";
print "( -- )\n";
print "( Y max: " . $yposmax . ")\n";
print "( Y step: " . $stepsizey . ")\n";
print "( -- )\n";
print "( Z max: " . $zposmax . ")\n";
print "( Z step: " . $stepsizez . ")\n";
print "( Z backlash: " . $backlashz . ")\n";
print "( ---------- )\n";







print "( Switch to global coordinates. )\n";
print "G90\n";



print "( Move to Zero and reset Feed Rate. )\n";

print "G00 X-10 Y-10 F1000\n";
print "G00 X0 Y0 Z0 F1000\n";
print "G01 X0 Y0 Z0 F1000\n";




print "( Z axis backlash prep )\n";
print "G00 Z" . $backlashz . "\n";
print "G00 Z0\n";


print "( Running Loop. )\n";

# outer loop is the y axis
# for each row...
while ( $ypos <= $yposmax ) {
	
	
	# depeneding upon direction...
	if ( $xdir ) {
		# step right
		while ( $xpos <= $xposmax ) {
			
			# take stack here
			
			print "( position: " . $xpos . "," . $ypos . " )\n";
			
			#print "G00 X" . $xpos . " Y" . $ypos . "\n";
			print "G00 X" . ( $xpos + $backlashx ) . " Y" . ( $ypos + $backlashy ) . " Z" . $backlashz . "\n";
			print "G00 X" . $xpos . " Y" . $ypos . " Z0\n";
			takeshot();
			
			# move to next column
			$xpos += $stepsizex;
			
		}
		$xdir = 0;
		$xpos -= $stepsizex;
	}
	else {
		# step left
		while ( $xpos >= 0 ) {
			
			# take stack here
			print "( position: " . $xpos . "," . $ypos . " )\n";
			#print "G00 X" . $xpos . " Y" . $ypos . "\n";
			print "G00 X" . ( $xpos + $backlashx ) . " Y" . ( $ypos + $backlashy ) . " Z" . $backlashz. "\n";
			print "G00 X" . $xpos . " Y" . $ypos . "Z0\n";
			takeshot();
			
			# move to previous column
			$xpos -= $stepsizex;
			
		}
		$xdir = 1;
		$xpos = 0;
		
	}
	
	
	# step down in ydir
	$ypos += $stepsizey;
	
}

# at the end, return to zero
print "( Return to xyz zero. )\n";
print "G00 X0 Y0 Z0\n";








































































