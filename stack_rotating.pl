#!/usr/local/bin/perl

use strict;
use warnings;





# the number of steps to take in the R axis (rotation)
my $stepmax_r = 1300;

# the size of each R step
my $stepsize_r = 0.01;



# the number of steps in the Z stack
my $stepmax_z = 1;

# the size of the step in the Z stack
my $stepsize_z = 0.1;





# take an actual picture with the attached camera
sub takeshot {
	
	# delay to settle after movement
	print "G4 P0.25\n";
	
	# half-press
	print "M8\n";
	
	# wait for focus
	print "G4 P0.1\n";
	
	# full-press
	print "M4\n";
	
	# wait for shot to happen
	print "G4 P0.25\n";

	# full-press off
	print "M3\n";
	
	# wait 
	print "G4 P0.1\n";

	# half-press off
	print "M9\n";
	
	# delay for upload
	print "G4 P1.5\n";
	
}


# take a step in the Z direction
sub takestep_z {
	# move in relative positioning
	print "G91\n";
	# the actual move command
	print "G00 Z" . $stepsize_z . "\n";
}



# return to zero after z stack
sub stackreturn_z {
	# move in global positioning
	print "G90\n";
	# the actual move command
	print "G00 Z0\n";
}


# take a step in the R direction
sub takestep_r {
	# move in relative positioning
	print "G91\n";
	# the actual move command
	print "G00 Y" . $stepsize_r . "\n";
}

# return to zero in the R direction
sub stackreturn_r {
	# move in global positioning
	print "G90\n";
	# the actual move command
	print "G00 Y0\n";
}






# do the actual move'n'shoot

# initialise the grbl position

# switch on global coordinates
print "G90\n";
# home to zero and set speed to 1000
print "G00 X0 Y0 Z0 F1000\n";



# for each step in the rotation
my $stepcounter_r = 0;
while ( $stepcounter_r < $stepmax_r ) {
	
	
	
	# take a z-stacked shot
	my $stepcounter_z = 0;
	while ( $stepcounter_z < $stepmax_z ) {
		
		# take a shot
		takeshot();
		
		# take one step in the z stack
		takestep_z();

		# increment the counter
		$stepcounter_z++;
		
	}
	
	# return to z stack top
	stackreturn_z();
	
	# rotate by one step
	takestep_r();
	
	# increment the step counter and move to the next step.
	$stepcounter_r++;
	
}

# when finished, return to zero.
stackreturn_r();
stackreturn_z();





























































