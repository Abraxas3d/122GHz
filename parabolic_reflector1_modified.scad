/*
parabolic_reflector module
by Kwikius
http://forums.reprap.org/read.php?340,333400,336285#msg-336285
creates a parabolic_reflector with a flat base
centered on its focus
 dia : float //  diameter of the reflector
 f   : float  // focal length
 numx : integer  // the number of points to plot on the parabola
 numr : integer // radial number of segments
 base : float // thickness of the base.
*/
module parabolic_reflector(dia, f, numx, numr, base_thickness)
{
    // from the focus determine the quadratic constant for y = a x^2 + base_thickness;
    a = 1 / (4 * f);
    // from diameter and required curve points determine the xdecrement
    // for each iteration of the parabola_pts function below
    xdecr = dia / (2 * numx);
    /*
     parabola_pts
     recursive function that builds the basic polygon points sequence
     Each iteration adds a point until the terminating condition is reached
     N.B. If you set the initial  point to [0,0]. works ok in draft but CGAL barfs
      x : float // the max x position
    */
    function parabola_pts(x) =
        (x <= 0.001)
        ?[[0.001,-f]] //BUG!x cannot be [[0,0][ for cgal to work ok in rotate_extrude
        :concat(parabola_pts(x-xdecr),[[x,a * x * x - f ]]);

    // create the 3d shape from the polygon we created
    rotate_extrude(convexity = 10, $fn = numr) {
        // before the rotate_extrude add 2 points to the polygon
        // again using the builtin concat function
        // which makes the flat base
        polygon(points =
                    concat([[dia/2,-(f + base_thickness)],[0.001,-(f + base_thickness)]],
                           parabola_pts(dia / 2) )
               ) ;
    }
}

//----------

// use the flag variables to change whats shown to show various features...
// N.B. if you cant see anything on changing parameters try zooming out!

// set show_offset_reflector to false to show the reflector before chopping out only the offset part
// warning set this to true and may take a while to compile!
show_offset_reflector = false;
//show_basic_object (dont care if show_offset_reflector == true)
// otherwise set to true to see just the basic module with the above parameters
show_basic_object = false;

// Use the module to create an object
// fill in some parameters with values dependent on the object
diameter = show_offset_reflector?820:show_basic_object?200:200;  // mm
//diameter = show_basic_object?200:show_offset_reflector?600:100;  // mm
num_x_points = show_offset_reflector?100:200; // more better detail but slower render
num_r_points = show_offset_reflector?100:100; // more better detail but slower render
focal_length = show_offset_reflector?50:show_basic_object?75:60; // mm
base_thickness = 5; // mm
material_thickness = 2; //mm

//-------
rotate([0,0,45])
if (show_offset_reflector == false) {

    if ( show_basic_object == true) {
        parabolic_reflector(diameter,focal_length,num_x_points,num_r_points,base_thickness);
    } else {
        // subtract a nearly similar reflector to give a thin wall reflector
        difference() {
            parabolic_reflector(diameter,focal_length,num_x_points,num_r_points,base_thickness);
            //subtracting a reflector with a very slightly bigger diameter . This prevents very thin walls due to floating point calcs)
            // The material thickness is the difference in focal length
            // between the original and the subtrahend ( because the object is centered on the focus)
            parabolic_reflector(diameter + 0.1,focal_length + material_thickness,num_x_points,num_r_points,base_thickness);
        }
    }
} else
{
// create an offset reflector by intersecting an offset cylinder with the reflector
// (Useful on a small reflector to prevent the antenna or detector from masking the reflector)

    intersection()
    {
        union() {
            difference() {
                parabolic_reflector(diameter,focal_length,num_x_points,num_r_points,base_thickness);
                //subtract a reflector with a very slightly bigger diameter
                // The material thickness is the difference in focal length
                // between the original and the subtrahend
                parabolic_reflector(diameter + 0.1,focal_length + material_thickness,num_x_points,num_r_points,base_thickness);
            }
        }

        translate([0,70,0]) {
           rotate([45,0,0])
            scale([1.25,.75,1]){// elliptical cylinder
            cylinder(d = 125,h = 200,center = true, $fn = 100);
				}
        }
    }
}
// Put a sphere at the focus to show where the focus is
//sphere(d=10,center = true);



//Use WR-7 waveguide flange
// width 1.651mm	height 0.0325 0.8255mm
waveguide_width = 1.651;
waveguide_height = 0.8255;


