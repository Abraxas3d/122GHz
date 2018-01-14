//122GHz feedhorn
//based on W1GHZ's Feeds for Parabolic Dish Antennas, Chapter 6
//This is a version of the W2IMU Dual-Mode Feed
//flare half angle recommendation from W1GHZ

a = 3.22; //mm
b = 3.66; //mm
c = 4.44; //mm
half_angle = 30; //degrees
waveguide_length = 5; //mm
flare_length = ((b/2 - a/2)/tan(half_angle)); //mm
outer_diameter = b; //mm
over_there = 3*b; //mm

$fn = 100;





difference()
{
//outer cylinder to subtract from
cylinder(h= (waveguide_length + flare_length + c), r1=outer_diameter, r2=outer_diameter, center=false);

//inner radius of input waveguide
cylinder(h= waveguide_length, r1=a/2, r2=a/2, center=false);

//inner radius of flare
translate([0,0,waveguide_length]) cylinder(h=flare_length, r1=a/2, r2=b/2, center=false);

//inner radius of output waveguide
translate([0,0,waveguide_length + flare_length]) cylinder(h= c, r1=b/2, r2=b/2, center=false);
}


//make a drawing of what the interior radii look like

//inner radius of input waveguide
translate([over_there, 0, 0]) cylinder(h= waveguide_length, r1=a/2, r2=a/2, center=false);

//inner radius of flare
translate([over_there,0,waveguide_length]) cylinder(h=flare_length, r1=a/2, r2=b/2, center=false);

//inner radius of output waveguide
translate([over_there,0,waveguide_length + flare_length]) cylinder(h= c, r1=b/2, r2=b/2, center=false);