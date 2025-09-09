//-------------------------------------------------------------------------
//  
//-------------------------------------------------------------------------
// It's the complement of the holder
//Simply the walls are contained inside the tile
//And the top is extruded to be stackable


include <libs/gridfinity_modules.scad>
include <libs/light_wall_zround.scad>

module rounded_rectangle
(
	//Number of gridfinity units XY
	in_x,
	in_y,
	in_z,
	//Margin to be eroded from sides
	im_margin=0,
	cp_gridfinity = 42.0,
	ir_rounding = 3.75
	
)
{
	color("#00cccc")
	hull()
	for (n_x=[-0.5,+0.5+(in_x-1)])
	for (n_y=[-0.5,+0.5+(in_y-1)]) 
	{
		translate
		([
			n_x * cp_gridfinity - sign(n_x)*(ir_rounding+im_margin),
			n_y * cp_gridfinity - sign(n_y)*(ir_rounding+im_margin),
			0
		])
		cylinder
		(
			d=ir_rounding,
			h=in_z,
			$fa=1,
			$fs=0.1
		);
	}
}

module base_trimmed
(
	in_w,
	in_h,
	ib_half_pitch = false,
	//Shrinks the sides but NOT the socket, meant for tiling
	im_clearance = 0.5,
	//Curvature radious of the corners
	ir_corners = 3.75,
	//Constant of height from floor to top
	ch_base = 5.2
)
{
	intersection()
	{
		
		// logic for constructing odd-size grids of possibly half-pitch pads
		pad_grid
		(
			in_w,
			in_h,
			ib_half_pitch
		);

		//This builds a smaller block that is intersected to cut the sides for clearance between block, it doesn't alter the male socket
		hull() 
		cornercopy
		(
			gridfinity_pitch/2 - im_clearance/2 - ir_corners,
			in_w,
			in_h
		) 
		cylinder(r=ir_corners, h=ch_base, $fa=0.2,$fs=0.2);
	}

}

module frame_plain
(
    num_x,
    num_y,
    extra_down=0,
    trim=0.0,
    //Mating margin of the base
    im_mate = 1.0
)
{
    corner_radius = 3.75;
    corner_position = gridfinity_pitch/2-corner_radius-trim;
    difference()
    {
        hull()
        cornercopy(corner_position, num_x, num_y) 
        translate([0, 0, -extra_down])
        cylinder(r=corner_radius, h=5.0+extra_down, $fa=0.1, $fs=0.1);
        
        //I'm subtracting a larger bottom to create the socket
        //translate([0, 0, trim ? 0 : -0.01])
        gridcopy(num_x, num_y)
        pad_oversize(margins=im_mate);
    }
}

module wall_corner
(
    //Height of the wall
    ih,
    //Thickness of the wall
    it,
    //Inner curvature radious
    ir
)
{
	color("#cc00aa")
    rotate_extrude(angle=90, $fa=0.2,$fs=0.2)
    polygon([
        [ir+0,0],
        [ir+0,ih],
        [ir+it,ih],
        [ir+it,0]
    ]);   
}

if (false)
wall_corner(100,10,10);

module wall_side
(
    //Width of the wall
    iw,
    //Height of the wall
    ih,
    //Thickness of the wall
    it,
    //Number of gridfinity sides
    in,
	//Number of holes horizontal and vertical, MUST be ODD
	in_w_holes = 1,
	in_h_holes = 1,
	in_void = 0.8,
	in_hole_throat = 0.85
)
{
    //Advanced construction, with corner sides and increased padding
    translate
	([
		0.0,
		it/2,
		ih/2
	])
    rotate([90,0,0])
	color("#ff0000")
    light_wall
    (
        iw = iw,
        ih = ih,
        it = it,
        //Cutout, for vertical printing make more W cutouts to make angle sharper
        in_w_holes = 1+2*in_w_holes,
        in_h_holes = in_h_holes,
        //Bigger means LESS rounded. The closer you go to 1, the more the cutouts become circles. The higher you go 10, 100, 1000, the sharper the corners are
        inr_rounding_factor = 5,
        //Void, 0 mean no void, full. 1 mean all voids. Controls how much materal is removed
        in_void = in_void,
        in_throat = in_hole_throat
    ); 
}

//wall_side(gridfinity_pitch,6,3.75);

module gridfinity_light_bin
(
	in_w,
	in_h,
	//Height of the bin from base to top fo the walls
	iz_top,
	//Thickness of the walls. MUST be smaller than the rounding, it's a different geometry otherwise
	it_wall,
	//Shrinks the sides but NOT the socket, meant for tiling
	im_clearance = 0.5,
	//Curvature radious of the corners
	ir_corners = 3.75,
	//Amount of wall that is void
	in_void = 0.8,
	//Throat of the holes in the wall
	in_hole_throat = 0.8,
	//Constant of height from floor to top of the tile
	h_wall_base = 5.2,
	//How bigger is the female compared to the male for mating, this excrude a socket on the top of the wall for vertical stacking of gridfinity bins
	m_gridfinity_female = 1.0,
	//Each of this height will spawn an additional vertical hole in the wall. Discretized to ODD.
	cz_mm_per_hole = 30,
	//Each of this side length will spawn an horizontal hole. Discretized to ODD.
	cl_mm_per_hole = 15,
	//true: extrude label on the bottom of the bin
	i_x_label = true
)
{
    //Base of the gridfinity plate. Act as lid for the level below
    //pad_oversize(in_w, in_h,margins=0);
    //Put a skinni gridfinity frame above
    //translate([0,0,h_base])
    //frame_plain(in_w, in_h, trim=-0.2);  
    
    n_translate = +gridfinity_pitch/2+0.2;
    n_side = gridfinity_pitch+0.0;
    
	//Margin for  extrusion of the female socket
	czm_female = 0.15;

	//WIP The number of vertical holes scales with height and is then turned into an odd number

	//Turn the number to ODD
	n_z_holes = 1 +2*floor(iz_top/cz_mm_per_hole/2);

	n_w_holes = 1 +2*floor(in_w*gridfinity_pitch/cl_mm_per_hole/2);
	n_h_holes = 1 +2*floor(in_h*gridfinity_pitch/cl_mm_per_hole/2);

	difference()
	{
		union()
		{
			base_trimmed
			(
				//Number of discrete bins
				in_w,
				in_h,
				//???
				ib_half_pitch = false,
				//Shrinks the sides but NOT the socket, meant for tiling
				im_clearance = im_clearance,
				//Curvature radious of the corners
				ir_corners = ir_corners,
				//Constant of height from floor to top of the tile
				ch_base = h_wall_base
			);

			//Make a rounded slab
			translate
			([
				0,
				0,
				5.2
			])
			rounded_rectangle
			(
				in_x = in_w,
				in_y = in_h,
				in_z = 1,
				im_margin = 0.1

			);

			//Put four rounded corner walls 
			//CORNER -W -H, fixed
			translate
			([
				-n_side/2+im_clearance/2 +ir_corners,
				-n_side/2+im_clearance/2 +ir_corners,
				h_wall_base
			])
			rotate([0,0,180])
			wall_corner
			(
				iz_top-h_wall_base,
				it_wall,
				ir_corners -it_wall
			);
			
			//CORNER +W -H
			translate
			([
				n_side*(in_w-0.5)-im_clearance/2 -ir_corners,
				-n_side/2+im_clearance/2 + ir_corners,
				h_wall_base
			])
			rotate([0,0,-90])
			wall_corner
			(
				iz_top-h_wall_base,
				it_wall,
				ir_corners -it_wall
			);
			
			//CORNER -W +H
			translate
			([
				-n_side/2+ir_corners+im_clearance/2,
				n_side*(in_h-0.5)-ir_corners-im_clearance/2,
				h_wall_base
			])
			rotate([0,0,90])
			wall_corner
			(
				iz_top-h_wall_base,
				it_wall,
				ir_corners -it_wall
			);
			
			//CORNER +W +H
			translate
			([
				n_side*(in_w-0.5)-ir_corners-im_clearance/2,
				n_side*(in_h-0.5)-ir_corners-im_clearance/2,
				h_wall_base
			])
			rotate([0,0,0])
			wall_corner
			(
				iz_top-h_wall_base,
				it_wall,
				ir_corners -it_wall
			);
			
			//WALLS
			
			//WALL -W
			translate
			([
				-n_side/2+it_wall/2+im_clearance/2,
				(in_h-1)*n_side/2,
				h_wall_base
			])
			rotate([0,0,-90])
			wall_side
			(
				in_h*n_side-2*ir_corners-im_clearance,
				iz_top-h_wall_base,
				it_wall,
				in_w,
				n_h_holes,
				n_z_holes,
				in_void = in_void,
				in_hole_throat = in_hole_throat
			);
			
			
			//WALL +W
			translate
			([
				(in_w-0.5)*n_side-it_wall/2-im_clearance/2,
				(in_h-1)*n_side/2,
				h_wall_base
			])
			rotate([0,0,90])
			wall_side
			(
				in_h*n_side-2*ir_corners-im_clearance,
				iz_top-h_wall_base,
				it_wall,
				in_w,
				n_h_holes,
				n_z_holes,
				in_void = in_void,
				in_hole_throat = in_hole_throat
				
			);
	
			//WALL -H
			translate([
				(in_w-1.0)*n_side/2-im_clearance*0,
				(-0.5)*n_side+it_wall/2+im_clearance/2,
				h_wall_base
			])
			wall_side
			(
				in_w*n_side-2*ir_corners-im_clearance,
				iz_top-h_wall_base,
				it_wall,
				in_w,
				n_w_holes,
				n_z_holes,
				in_void = in_void,
				in_hole_throat = in_hole_throat
			);
		
			//WALL +H
			translate([
				(in_w-1.0)*n_side/2-im_clearance*0,
				(in_h-0.5)*n_side-it_wall/2-im_clearance/2,
				h_wall_base
			])
			wall_side
			(
				in_w*n_side-2*ir_corners-im_clearance,
				iz_top-h_wall_base,
				it_wall,
				in_w,
				n_w_holes,
				n_z_holes,
				in_void = in_void,
				in_hole_throat = in_hole_throat
			);
			
		} //END UNION POSITIVE
		union()
		{
			translate([
				0,
				0,
				iz_top-h_wall_base+czm_female
			])	
			gridcopy(in_w, in_h)
			//This is the bigger female pad
			pad_oversize(margins=m_gridfinity_female);

			if (i_x_label==true)
			{
				c_h_text = 4;
				c_z_text = 1;
				translate([0,+6+1,0])
				mirror([1,0,0])
				linear_extrude(c_z_text)
				text
				(
					str(in_w, "x", in_h, "x", round(iz_top/7),"U"),
					size=6,
					font = "DejaVu Sans:style=Bold",
					halign = "center",
					valign = "center"
				);
				translate([0,-0,0])
				mirror([1,0,0])
				linear_extrude(c_z_text)
				text
				(
					str("github.com"),
					size=c_h_text,
					font = "DejaVu Sans:style=Bold",
					halign = "center",
					valign = "center"
				);
				translate([0,-c_h_text-1,0])
				mirror([1,0,0])
				linear_extrude(c_z_text)
				text
				(
					str("/OrsoEric"),
					size=c_h_text,
					font = "DejaVu Sans:style=Bold",
					halign = "center",
					valign = "center"
				);
				


			}
		} //END UNION NEGATIVE
	} //END DIFFERENCE
     
}
if (true)
{
	gridfinity_light_bin
	(
		1,
		2,
		//Height of the bin from ground to top of the wall
		7*10,
		//Wall Thickness
		1.5,
		//The base is cut by this amount to allow tiling, doesn't change the shape of the gridfinity mating socket
		im_clearance = 0.75

	);
}