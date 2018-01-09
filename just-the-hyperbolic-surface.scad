//A hyperbola is the set of all points where the difference 
//in the distance from intstwo fixed po is a constant. 

//What we are after here is the positive half of a hyperbola.
//We then rotate it around its transverse axis in order
//to make a hyperbolic surface.

//This hyperbolic surface is then 3D printed in order to
//provide a prototype subreflector for a microwave cassegrain
//antenna system for radio experimentation. 

//equation for a hyperbola is (x^2)/(a^2)  -  (y^2)/(b^2)   =   1
// x = a sec(angle)
// y = b tan(angle)
// angle varies from 0 to pi/2

//a and b are the dimensions of the box that defines the
//asymptotes of the hyperbolic curve. 
a = 40; //affects height of the vertex above origin and how tall shape ends up.
b = 40; //radius 

//resolution variable in OpenSCAD. Higher numbers mean smoother surface.
$fn = 200;

max_angle = 45; //affects how tall the shape ends up. 
angle_resolution = 0.5;

//granularity should match the length of the polygon vector
//before we add the two finishing points that complete a closed curve.
granularity = max_angle/angle_resolution;


//Depending on the behavior desired, one might want either
//a vertical or a horizontal hyperbolic curve.
//choose which one here.
//set horizontal to true for horizontal (creates the right shape when rotated).
//set horizontal to false for vertical (creates an interesting shape when rotated).
horizontal = true;


//For horizontal case:
//we are defining functions that make a vector of points. 
//each point is a vector in and of itself in the form [x,y]
//the vector of points follows a horizontal hyperbolic curve.
//the independent variable is the angle from 0 to max_angle.
//we use concat() to build the vector of points as long as
//we do not exceed the max_angle. we increment by angle_resolution
//and then calculate a new set of points. 
//secant is the reciprocal of cosine
function horiz_hyper(angle) = angle < max_angle ? concat([[b*tan(angle), a*(1/(cos(angle)))]], horiz_hyper(angle + angle_resolution)) : [];



//For vertical case:
//we are defining functions that make a vector of points. 
//each point is a vector in and of itself in the form [x,y]
//the vector of points follows a vertical hyperbolic curve.
//the independent variable is the angle from 0 to max_angle.
//we use concat() to build the vector of points as long as
//we do not exceed the max_angle. we increment by angle_resolution
//and then calculate a new set of points. 
//secant is the reciprocal of cosine
function vert_hyper(angle) = angle < max_angle ? concat([[ a*(1/(cos(angle))) , b*tan(angle)]], vert_hyper(angle + angle_resolution)) : [];




if (horizontal == true) {
    
//we have a hyperbolic curve, but it needs to be closed so
//that we can turn it into a polygon and then rotate to get a solid.

//uncomment this block for checks
/*
//check the length of the vector
echo(len(horiz_hyper(0)));

//check the last entry
echo(horiz_hyper(0)[granularity - 1]);

//check the y value from the last set of points. 
echo(horiz_hyper(0)[granularity - 1][1]);

//check entire list of points.
echo(horiz_hyper(0));
*/

//get the y value from the last set of points.
replace_horiz = horiz_hyper(0)[granularity - 1][1];

//add two points to the curve to close it, using concat().
//first, stay at current y value, but set x to zero so that
//we come across to the y axis to make the top of the polygon.
//then, drop straight down to where we started. 
full_set_horiz = concat(horiz_hyper(0), [[0, replace_horiz]], [[0,a]]);

//show the polygon we created.
/*
translate([0, 0, 0]) polygon(full_set_horiz);
*/

//use rotate_extrude to rotate the 2d polygon and make it a 3d shape.
//translate moves it to origin. Set -a to 0 if you want it to be at
//its calculated position!
translate([0, 0, -a]) rotate_extrude(angle = 360, convexity = 10) polygon(full_set_horiz);


} else {
    
//we have a hyperbolic curve, but it needs to be closed so
//that we can turn it into a polygon and then rotate to get a solid.

//uncomment this block for checks
/*
//check the length of the vector
echo(len(vert_hyper(0)));

//check the last entry
echo(vert_hyper(0)[granularity - 1]);

//check the x value from the last set of points.
echo(vert_hyper(0)[granularity - 1][0]);
    
//check entire list of points.
echo(vert_hyper(0));
*/
    
//get the x value from the last set of points.
replace_vert = vert_hyper(0)[granularity - 1][0];
    
//add two points to the curve to close it, using concat().
//first, stay at current x value, but set y to zero so that
//we come across to the x axis to make the top of the polygon.
//then, drop straight down to where we started.
full_set_vert = concat(vert_hyper(0), [[replace_vert, 0]], [[a,0]]);

//show the polygon we created.
/*
translate([0, 0, 0]) polygon(full_set_vert);
*/
    
//use rotate_extrude to rotate the 2d polygon and make it a 3d shape.
rotate_extrude(angle = 360, convexity = 10) translate([0, 0, 0]) polygon(full_set_vert);

}


//Next, add a strut to connect to the parabolic reflector.
//W1GHZ says, "If you are using linear polarization, a single strut would
//be worst in the E-plane (horizontal for horizontal polarization)."

//So let's make it adjustable.
