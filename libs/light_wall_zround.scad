//	2025-09-10
//Fix walls with no hole


//Rounded Poly Library
include <polyround.scad>

//precision of the rounding
n_diamond_spline = 25;

//EVEN PATTERN
//quarter, full, half
//ODD PATTERN
//quarter, full, half, 

module diamond_quarter( iw, ih, it, inr_rounding_factor, in_throat=1.0 )
{
    aan_points =
	([
		[0, 0, ih/inr_rounding_factor/4],
		[+iw/2, 0, iw/inr_rounding_factor/4],
		[0, +ih/2, ih/inr_rounding_factor/4],
    ]);

	n_min_scale = in_throat;
    n_max_scale = 1.0;
    n_margin = 0.01;

	linear_extrude(it*1/3+n_margin,scale=n_min_scale)
	polygon(polyRound(aan_points,n_diamond_spline));
    
    translate([0,0,it/3])
    linear_extrude(it*1/3)
    scale([n_min_scale,n_min_scale])
	polygon(polyRound(aan_points,n_diamond_spline));
    
    translate([0,0,it]) 
    mirror([0,0,1])
    linear_extrude(it/3+n_margin,scale=n_min_scale)
	polygon(polyRound(aan_points,n_diamond_spline));
}

module half_w_diamond( iw, ih, it, inr_rounding_factor, in_throat=1.0 )
{
    aan_points =
	([
		[+iw/2, 0, ih/inr_rounding_factor/2],
		[0, +ih/2, iw/inr_rounding_factor],
		[-iw/2, 0, ih/inr_rounding_factor/2],
    ]);

	n_min_scale = in_throat;
    n_max_scale = 1.0;
    n_margin = 0.01;

	linear_extrude(it*1/3+n_margin,scale=n_min_scale)
	polygon(polyRound(aan_points,n_diamond_spline));
    
    translate([0,0,it/3])
    linear_extrude(it*1/3)
    scale([n_min_scale,n_min_scale])
	polygon(polyRound(aan_points,n_diamond_spline));
    
    translate([0,0,it]) 
    mirror([0,0,1])
    linear_extrude(it/3+n_margin,scale=n_min_scale)
	polygon(polyRound(aan_points,n_diamond_spline));
}


module half_h_diamond( iw, ih, it, inr_rounding_factor, in_throat=1.0 )
{
    aan_points =
	([
        [0, -ih/2, iw/inr_rounding_factor/2],
		[+iw/2, 0, ih/inr_rounding_factor],
		[0, +ih/2, iw/inr_rounding_factor/2],
    ]);

    n_min_scale = in_throat;
    n_max_scale = 1.0;
    n_margin = 0.01;

	linear_extrude(it*1/3+n_margin,scale=n_min_scale)
	polygon(polyRound(aan_points,n_diamond_spline));
    
    translate([0,0,it/3])
    linear_extrude(it*1/3)
    scale([n_min_scale,n_min_scale])
	polygon(polyRound(aan_points,n_diamond_spline));
    
    translate([0,0,it]) 
    mirror([0,0,1])
    linear_extrude(it/3+n_margin,scale=n_min_scale)
	polygon(polyRound(aan_points,n_diamond_spline));
}


module diamond_zround( iw, ih, it, inr_rounding_factor, in_throat )
{
    aan_points =
	([
		[0, -ih/2, iw/inr_rounding_factor],
		[+iw/2, 0, ih/inr_rounding_factor],
		[0, +ih/2, iw/inr_rounding_factor],
		[-iw/2, 0, ih/inr_rounding_factor],
    ]);

    n_min_scale = in_throat;
    n_max_scale = 1.0;
    /*
    n_slices = 16;
    
    //hull()
        for (n_cnt_slice = [0 : n_slices-1])
        {
            //Smoothly decrease size
            n_scale = (n_max_scale-n_min_scale)*(0.5+cos(n_cnt_slice/n_slices*180)/2) +n_min_scale;
            
            translate([0,0,n_cnt_slice*it/2/n_slices])
            linear_extrude(0.01)
            scale([n_scale,n_scale])
            polygon(polyRound(aan_points,n_diamond_spline));
        }
    
        translate([0,0,it]) 
        rotate([180,0,00])
        for (n_cnt_slice = [0 : n_slices-1])
        {
            //Smoothly decrease size
            n_scale = (n_max_scale-n_min_scale)*(0.5+cos(n_cnt_slice/n_slices*180)/2) +n_min_scale;
            
            translate([0,0,n_cnt_slice*it/2/n_slices])
            linear_extrude(0.01)
            scale([n_scale,n_scale])
            polygon(polyRound(aan_points,n_diamond_spline));
        }
        
        
    */    
    
    //margin that helps quick refresh but causes slight geometry error. Should be zero for render
    n_margin = 0.01;
    
	linear_extrude(it*1/3+n_margin,scale=n_min_scale)
	polygon(polyRound(aan_points,n_diamond_spline));
    
    translate([0,0,it/3])
    linear_extrude(it*1/3)
    scale([n_min_scale,n_min_scale])
	polygon(polyRound(aan_points,n_diamond_spline));
    
    translate([0,0,it]) 
    mirror([0,0,1])
    linear_extrude(it/3+n_margin,scale=n_min_scale)
	polygon(polyRound(aan_points,n_diamond_spline));
    
}


/**
 * Generates a light wall structure with diamond-shaped cutouts.
 *
 * This function creates a lattice structure with diamond-shaped holes. The size and number of these holes
 * can be adjusted, as well as the fill factor, which determines the density of the structure.
 *
 * @param iw {number} The total width of the structure.
 * @param ih {number} The total height of the structure.
 * @param it {number} The thickness of the wall structure.
 * @param in_w_holes {number} The number of diamond-shaped holes along the width.
 * @param in_h_holes {number} The number of diamond-shaped holes along the height.
 * @param in_void {number} The fill factor (0 to 1), where 0 means all holes and 1 means a solid structure.
 * @param in_padding {number} (Optional) Padding around the structure to compensate for beam sizes. Default is 2.
 *
 * @example
 * // Example usage:
 * light_wall_cut_odd(iw = 100, ih = 100, it = 10, in_w_holes = 5, in_h_holes = 5, in_void = 0.5);
 */

module light_wall_cut_odd
(
    iw,
    ih,
    it,
    in_w_holes,
    in_h_holes,
    in_void,
    //How strong is the rounding, proportional to diamond size
    inr_rounding_factor = 10,
    //I can add or remove material from the sides. With corner and half enabled should be bigger than 0
    in_padding = -2,
    //throat of the hole. 1 means no throat, 0.9 means the center is smaller, 1.1 means the center is bigger
    in_throat = 0.75,
    //Corners can cause issue and rounding can be inconsistent
    ib_corners = false,
    //Top W side can cause hanging in vertical walls, disabled by default
    ib_w_sides = false,
    //Sides shouldn't cause issue since they are pointy
    ib_h_sides = false,
	//Debug console
	ib_debug=false
)
{

	if ((in_w_holes>0) && (in_h_holes>0))
	{
		//fill
		//	0% whould be all holes
		//	100% should be all full
		//	50% should leave half of structure

		//rounding should depend on dimension
		r_corner = 0.0;
		
		//Size of the beams is dependent on fill factor and number of diamonds. One diamond leaves four beams quarter the size of the remaining structure
		//TODO: A beam is diagonal, I have some wiggle room to do a partition of the space vertical and diagonal, but it requires more math
		//BUG: I'm leaving 1 beam lattice above and on the side, and two between diamonds
		w_beam = iw * (1-in_void) / (in_w_holes+1) /2;
		h_beam = ih * (1-in_void) / (in_h_holes+1) /2;
		//Compensate by adding a padding
		w_effective = iw -w_beam * in_padding;
		h_effective = ih -h_beam * in_padding;

		//Compute size of a full diamond
		//I leave quarter of a fill to the right and a quarter of a fill to the left
		//rounding will leave extra space on top of that due to how rounding works
		w_diamond = w_effective * (0.5 + 0.5) * in_void / in_w_holes;
		h_diamond = h_effective * (0.5 + 0.5) * in_void / in_h_holes;
		
		//  QUARTER DIAMONDS
		//With any ODD diamond geometry, I place four corners
		//If I did an even geometry, I would need only two quarters?
		if (ib_corners == true)
		{
			//Bottom Left
			translate([-w_effective/2+w_beam,-h_effective/2+h_beam,0])
			diamond_quarter(w_diamond, h_diamond, it, inr_rounding_factor, in_throat);

			//Bottom Right
			translate([+w_effective/2-w_beam,-h_effective/2+h_beam,0])
			diamond_quarter(-w_diamond, h_diamond, it, inr_rounding_factor, in_throat);
			
			//Top Right
			translate([+w_effective/2-w_beam,+h_effective/2-h_beam,0])
			diamond_quarter(-w_diamond, -h_diamond, it, inr_rounding_factor, in_throat);
			
			//Top Left
			translate([-w_effective/2+w_beam,+h_effective/2-h_beam,0])
			diamond_quarter(+w_diamond, -h_diamond, it, inr_rounding_factor, in_throat);
		}
		in_w_holes_half = floor(in_w_holes/2);
		in_h_holes_half = floor(in_h_holes/2);

		//  INTEGER LATTICE
		//Those are the full diamonds that are placed at integer position in the lattice
		//I place all the full diamonds
		//  W1  -> [0]
		//  W3  -> [-1, 0, +1]
		//  W5  -> [-2, -1, 0, +1, +2]
		for (w_cnt = [-in_w_holes_half : 1 : in_w_holes_half])
		{
			for (h_cnt = [-in_h_holes_half : in_h_holes_half])
			{
				//move by diamond width, plus, beam size
				translate([
					w_cnt * (w_diamond+2*w_beam),
					h_cnt * (h_diamond+2*h_beam),
					0
				])
				diamond_zround(w_diamond, h_diamond, it, inr_rounding_factor, in_throat);
			}
		}	

		//  HALF LATTICE
		//When there are more diamonds, I need an even number of diamonds placed at half integer position within the lattice to fill the gaps
		//  W3  -> [-0.5, +0.5]
		//  W5  -> [-1.5, -0.5, +0.5, +1.5]
		
		if ((in_w_holes > 1) && (in_h_holes > 1))
		{
			in_w_inner_holes_half = ((in_w_holes)/4);
			in_h_inner_holes_half = ((in_h_holes)/4);
			if (ib_debug)
			echo("Inner Diamonds" );
			//I'm better off just doing the math from lattice indexes
			for (w_cnt_inner = [0 : in_w_holes -2] )
			{
				//Turns the integer index into lattice indexes
				w_index = -in_w_holes/2+w_cnt_inner+1;
				for (h_cnt_inner = [0 : in_h_holes -2] )
				{
					h_index = -in_h_holes/2+h_cnt_inner+1;
					if (ib_debug)
					echo("W: ",w_index, " | H: ", h_index );
				  
					//move by diamond width, plus, beam size
					translate([
						w_index * (w_diamond+2*w_beam),
						h_index * (h_diamond+2*h_beam),
						0
					])
					diamond_zround(w_diamond, h_diamond, it, inr_rounding_factor,in_throat);
				}
			}
			
		}
		
		// HALF DIAMONDS HORIZONTAL
		//To complete the pattern now I need the side half diamonds
		
		if ((ib_w_sides == true) && (in_w_holes > 1))
		{
			if (ib_debug)
			echo("W Half Diamonds:" );
			for (w_cnt_half = [0 : in_w_holes -2] )
			{
				w_index = -in_w_holes/2+w_cnt_half+1;
				if (ib_debug)
				echo("W: ", w_index );
				//LOWER HALF DIAMOND
				translate([
					w_index *(2*w_beam +w_diamond),
					-h_effective/2+h_beam,
					0
				])
				half_w_diamond(w_diamond, h_diamond, it, inr_rounding_factor,in_throat);
				//UPPER HALF DIAMOND
				translate([
					w_index *(2*w_beam +w_diamond),
					+h_effective/2-h_beam,
					0
				])
				half_w_diamond(w_diamond, -h_diamond, it, inr_rounding_factor,in_throat);
			}
		} 
		
		// HALF DIAMONDS VERTICAL
		//To complete the pattern now I need the side half diamonds
		
		if ((ib_h_sides == true) && (in_h_holes > 1))
		{
			if (ib_debug)
			echo("H Half Diamonds:" );
			for (h_cnt_half = [0 : in_h_holes -2] )
			{
				h_index = -in_h_holes/2+h_cnt_half+1;
				if (ib_debug)
				echo("H: ", h_index );
				//LEFT HALF DIAMOND
				translate([
					-w_effective/2+w_beam,
					h_index *(2*h_beam +h_diamond),
					0
				])
				half_h_diamond(w_diamond, h_diamond, it, inr_rounding_factor,in_throat);
				//RIGHT HALF DIAMOND
				translate([
					+w_effective/2-w_beam,
					h_index *(2*h_beam +h_diamond),
					0
				])
				half_h_diamond(-w_diamond, h_diamond, it, inr_rounding_factor,in_throat);
			}
		}
    } //If there are holes
}

module light_wall
(   
    iw,
    ih,
    it,
    in_w_holes,
    in_h_holes,
	//How much surface voids cover
    in_void = 0.8,
    //How strong is the rounding, proportional to diamond size
    inr_rounding_factor = 10,
    //I can add or remove material from the sides. With corner and half enabled should be bigger than 0
    in_padding = -2,
    //throat of the hole. 1 means no throat, 0.9 means the center is smaller, 1.1 means the center is bigger
    in_throat = 0.75,
    //Corners can cause issue and rounding can be inconsistent
    ib_corners = false,
    //Top W side can cause hanging in vertical walls, disabled by default
    ib_w_sides = false,
    //Sides shouldn't cause issue since they are pointy
    ib_h_sides = false
)
{
    //Adds height for the extrusion. Works fine at 0, but fast preview won't show a clean cut even if the cutout is clean in rended. By giving some margin, it's easy to see in preview
    z_extra_cutout = 0.01;
	difference()
	{
		//Solid Wall
		union()
		{	
			//Create a vertical wall
			linear_extrude(it)
			square([iw,ih],center=true);	
		}
		//Now I want to remove material to make it light into beams
		union()
		{	
            translate([0,0,-it*z_extra_cutout/2])
			light_wall_cut_odd
            (
                iw = iw,
                ih = ih,
                it = it*(1+z_extra_cutout),
                in_w_holes = in_w_holes,
                in_h_holes = in_h_holes,
                in_void = in_void,
                inr_rounding_factor = inr_rounding_factor,
                in_padding = in_padding,
                ib_corners = ib_corners,
                ib_w_sides = ib_w_sides,
                ib_h_sides = ib_h_sides,
                in_throat = in_throat
            );
		}
	}
}

//--------------------------------------------------------------------------------
//  EXAMPLES
//--------------------------------------------------------------------------------
// change false to true to enable the example of light wall constructions

//DEFAULT wall construction, should be good for printing vertical walls safely
//it disables the difficult to print vertical features
if (false)
{
    //Default construction, without corner and sides and reduced padding
    light_wall
    (
        iw = 30,
        ih = 20,
        it = 3,
        //Cutout, for vertical printing make more W cutouts to make angle sharper and easier to print MUST BE ODD NUMBER
        in_w_holes = 7,
        in_h_holes = 3,
        //Void, 0 mean no void, full. 1 mean all voids. Controls how much materal is removed
        in_void = 0.8
    );   
}

//VERTICAL wall construction with side elements and increased padding
//I thought of adding diamondlets on top and bottom, but I'm not sure it's worth the effort. Might as well do diamonds with less paddings and it works almost the same.
if (false)
{
    //Default construction, without corner and sides and reduced padding
    light_wall
    (
        iw = 30,
        ih = 20,
        it = 3,
        //Cutout, for vertical printing make more W cutouts to make angle sharper
        in_w_holes = 7,
        in_h_holes = 3,
        //Void, 0 mean no void, full. 1 mean all voids. Controls how much materal is removed
        in_void = 0.8,
        in_padding = 1.5,
        ib_h_sides = true
    );   
}

//ADVANCED wall construction, showing sane parameters for horizontal print with reduced padding
if (false)
{
    //Advanced construction, with corner sides and increased padding
    light_wall
    (
        iw = 30,
        ih = 20,
        it = 3,
        //Cutout, for vertical printing make more W cutouts to make angle sharper
        in_w_holes = 7,
        in_h_holes = 3,
        //Bigger means LESS rounded. The closer you go to 1, the more the cutouts become circles. The higher you go 10, 100, 1000, the sharper the corners are
        inr_rounding_factor = 5,
        //Void, 0 mean no void, full. 1 mean all voids. Controls how much materal is removed
        in_void = 0.85,
        in_padding = 1.5,    
        ib_corners = false,
        ib_w_sides = false,
        ib_h_sides = false
    );   
}

//FANCY construction showing what happens with extreme roundings, it's weird circles but still works. may have cosmetic uses
if (false)
{
    //Advanced construction, with corner sides and increased padding
    light_wall
    (
        iw = 30,
        ih = 20,
        it = 3,
        //Cutout, for vertical printing make more W cutouts to make angle sharper
        in_w_holes = 7,
        in_h_holes = 3,
        //Bigger means LESS rounded. The closer you go to 1, the more the cutouts become circles. The higher you go 10, 100, 1000, the sharper the corners are
        inr_rounding_factor = 1.5,
        //Void, 0 mean no void, full. 1 mean all voids. Controls how much materal is removed
        in_void = 0.85,
        in_padding = 1.5,    
        ib_corners = true,
        ib_w_sides = true,
        ib_h_sides = true
    );   
}

//EVEN HOLES (doesnt work)
if (false)
{
    //Default construction, without corner and sides and reduced padding
    light_wall
    (
        iw = 30,
        ih = 20,
        it = 3,
        //Cutout, for vertical printing make more W cutouts to make angle sharper and easier to print MUST BE ODD NUMBER
        in_w_holes = 2,
        in_h_holes = 1,
        //Void, 0 mean no void, full. 1 mean all voids. Controls how much materal is removed
        in_void = 0.8
    );   
}

//NO HOLE
//make a full wall
if (false)
{
    //Default construction, without corner and sides and reduced padding
    light_wall
    (
        iw = 30,
        ih = 20,
        it = 3,
        //Cutout, for vertical printing make more W cutouts to make angle sharper and easier to print MUST BE ODD NUMBER
        in_w_holes = 0,
        in_h_holes = 0,
        //Void, 0 mean no void, full. 1 mean all voids. Controls how much materal is removed
        in_void = 0.8
    );   
}

//DEBUG ONLY the positive of the cutout. It's useful when developing the formulae
if (false)
{
    light_wall_cut_odd
    (
        iw = 30,
        ih = 20,
        it = 3,
        in_w_holes = 2,
        in_h_holes = 1,
        in_void = 0.5,
        //How strong is the rounding, proportional to diamond size
        inr_rounding_factor = 10,
        in_padding = 1,
        ib_corners = true,
        ib_w_sides = true,
        ib_h_sides = true
    );
}
