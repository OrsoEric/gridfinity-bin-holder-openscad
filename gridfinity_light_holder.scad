//-------------------------------------------------------------------------
//  
//-------------------------------------------------------------------------
// It's the complement of the holder
//Simply the walls are contained inside the tile
//And the top is extruded to be stackable


include <gridfinity_modules.scad>
include <light_wall_zround.scad>

//Defines upper and lower hinge that lock with a sphere and an hole
//The upper hinge needs to be on the low edge
//THe lower hinge needs to be on the upper edge
include <libs/hinge-lock.scad>

//It's 5mm plus 0.2mm margin coming from pad_oversize
h_base = 5.2;
//The height at which walls start
h_wall_base = 0;


t_wall = 2.5;

r_rounding = 3.75;

module frame_plain
(
    num_x,
    num_y,
    extra_down=0,
    trim=0.0,
    //Mating margin of the base
    im_mate = 1.0,
	imz_depth = 0.0
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
        pad_oversize
		(
			margins=im_mate,
			imz_depth=imz_depth
		);
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
    rotate_extrude(angle=90, $fa=0.2,$fs=0.2)
    polygon([
        [ir+0,0],
        [ir+0,ih],
        [ir+it,ih],
        [ir+it,0]
    ]);   
}

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

//wall_side(h_wall,t_wall,3.75);

module gridfinity_light_holder
(
	in_w,
	in_h,
	//height of the wall from the floor
	h_wall,
    //??? Does nothing?
	im_mate = 0.0,
    //Extrude more from the female to make male bin mate better with female slot
	imz_female_bottom = 0.2,
	//Each of this height will spawn an additional vertical hole in the wall. Discretized to ODD.
	cz_mm_per_hole = 25,
	//Each of this side length will spawn an horizontal hole. Discretized to ODD.
	cl_mm_per_hole = 15,
	//How much surface voids cover
    in_void = 0.8,
    //Enable spawning of hinge snaps
    ib_hinge_snap = true,
	//Controls how hard are the snap fits
	it_hinge_mate = 0.15,
	it_hinge_interference = 0.225
)
{
	//Turn the number to ODD
	n_z_holes = 1 +2*floor(h_wall/cz_mm_per_hole/2);;
	n_w_holes = 1 +2*floor(in_w*gridfinity_pitch/cl_mm_per_hole/2);
	n_h_holes = 1 +2*floor(in_h*gridfinity_pitch/cl_mm_per_hole/2);
	echo("HOLES | W: ", n_w_holes, " | H: ", n_h_holes, " | Z: ", n_z_holes);

    //Base of the gridfinity plate. Act as lid for the level below
	gridcopy(in_w, in_h)
    pad_oversize
	(
		1,
		1,
		margins=im_mate
	);
    //Put a skinni gridfinity frame above
    translate([0,0,h_base+imz_female_bottom])
    frame_plain
	(
		in_w,
		in_h,
		trim=-0.2,
		//Makes the female bottom deeper to mate better with the male gridfinity on top of it
		imz_depth = imz_female_bottom
	);  
    
    n_translate = +gridfinity_pitch/2+0.2;
    n_side = gridfinity_pitch+0.0;
    
    //There is a non scalable margin that is added only 1X
    n_margin = 0.2;
    
	//-------------------------------------------------------------------------
    //  CORNERS
    //-------------------------------------------------------------------------

    //Put four rounded corner walls 
    //CORNER -W -H, fixed
    translate
	([
		-n_side/2-n_margin+r_rounding,
		-n_side/2-n_margin+r_rounding,
		h_wall_base
	])
    rotate([0,0,180])
    wall_corner
	(
		h_wall,
		t_wall,
		r_rounding
	);
    
    //CORNER +W -H
    translate
	([
		n_side*(in_w-0.5)+n_margin -r_rounding,
		-n_side/2-n_margin + r_rounding,
		h_wall_base
	])
    rotate([0,0,-90])
    wall_corner
	(
		h_wall,
		t_wall,
		r_rounding
	);
    
    //CORNER -W +H
    translate
	([
		-n_side/2+r_rounding-n_margin,
		n_side*(in_h-0.5)-r_rounding+n_margin,
		h_wall_base
	])
    rotate([0,0,90])
    wall_corner
	(
		h_wall,
		t_wall,
		r_rounding
	);
	
	//CORNER +W +H
    translate
	([
		n_side*(in_w-0.5)-r_rounding+n_margin,
		n_side*(in_h-0.5)-r_rounding+n_margin,
		h_wall_base
	])
    rotate([0,0,0])
    wall_corner
	(
		h_wall,
		t_wall,
		r_rounding
	);

	//-------------------------------------------------------------------------
    //  WALLS
    //-------------------------------------------------------------------------
    
    //WALL -W
    translate
	([
		-n_side/2-t_wall/2-n_margin,
		(in_h-1.0)*n_side/2,
		h_wall_base
	])
    rotate([0,0,-90])
    wall_side
	(
		in_h*n_side-2*r_rounding+2*n_margin,
		h_wall,
		t_wall,
		in_w,
		n_h_holes,
		n_z_holes,
		in_void = in_void
	);
    
	//WALL +W
    translate
	([
		(in_w-0.5)*n_side+n_margin+t_wall/2,
		(in_h-1)*n_side/2,
		h_wall_base
	])
    rotate([0,0,-90])
    wall_side
	(
		in_h*n_side-2*r_rounding+2*n_margin,
		h_wall,
		t_wall,
		in_w,
		n_h_holes,
		n_z_holes,
		in_void = in_void
	);
    
    //WALL -H
    translate
	([
		(in_w-1)*n_side/2,
		-n_side/2-t_wall/2-n_margin,
		h_wall_base
	])
    wall_side
	(
		in_w*n_side-2*r_rounding+2*n_margin,
		h_wall,
		t_wall,
		in_w,
		n_w_holes,
		n_z_holes,
		in_void = in_void
	);

	//WALL +H
    translate([
		(in_w-1)*n_side/2,
		(in_h-0.5)*n_side+t_wall/2+n_margin,
		h_wall_base
	])
    wall_side
	(
		in_w*n_side-2*r_rounding+2*n_margin,
		h_wall,
		t_wall,
		in_w,
		n_w_holes,
		n_z_holes,
		in_void = in_void
	);
    
	//-------------------------------------------------------------------------
    //  PILLARS
    //-------------------------------------------------------------------------
	// Vertical structural elements to help integrity of the wall

	//-W
	if (in_h > 0)
	for (n_y=[1:in_h-1])
	translate
	([
		n_side*(-0.5)-n_margin-t_wall*0.6,
		n_side*(n_y-0.5),
		h_wall_base
	])
	color("#440044")
	cylinder
	(
		r=t_wall,
		h=h_wall,
		$fn=30
	);

	//+W
	if (in_h > 0)
	for (n_y=[1:in_h-1])
	translate
	([
		n_side*(in_w-0.5)+n_margin+t_wall*0.6,
		n_side*(n_y-0.5),
		h_wall_base
	])
	color("#440044")
	cylinder
	(
		r=t_wall,
		h=h_wall,
		$fn=30
	);

	//-H
	if (in_w > 0)
	for (n_x=[1:in_w-1])
	translate
	([
		n_side*(n_x-0.5)+0*r_rounding,
		n_side*(-0.5)-n_margin-t_wall*0.6,
		h_wall_base
	])
	color("#440044")
	cylinder
	(
		r=t_wall,
		h=h_wall,
		$fn=30
	);

	//+H
	if (in_w > 0)
	for (n_x=[1:in_w-1])
	translate
	([
		n_side*(n_x-0.5)+0*r_rounding,
		n_side*(in_h-0.5)+n_margin+t_wall*0.6,
		h_wall_base
	])
	color("#440044")
	cylinder
	(
		r=t_wall,
		h=h_wall,
		$fn=30
	);

    //-------------------------------------------------------------------------
    //  HINGE LOCKS
    //-------------------------------------------------------------------------
    //  To allow vertical stacking, I need something to keep them in place
    //  I designed some vertical hinge snap fits that works great
    
    //how tall is the attachment btween the hinge and the wall
    h_attach = 10;
    //Distance between two locks for mating
	t_hinge_mate = it_hinge_mate;
    //Interference between the locking feature and the hinge hole
    t_hinge_interference = it_hinge_interference;
    
	t_hinge_upper = 5;
	t_hinge_lower = 8;

    //-W LOWER HINGE
    if (ib_hinge_snap)
    for (in_y=[0:in_h-1])
    translate
    ([
        n_side*(-0.5)-t_wall-n_margin,
        in_y*n_side,
        h_wall  
    ])
    rotate([0,0,180])
    double_lower_lock
    (
        //Attachment
        ih_attach = h_attach,
        ih_delta = 5,
        //Distance from wall to center hole
        il_hole = 3,
        //Thickness of the hinge
		it_hinge_upper = t_hinge_upper,
        it_hinge_lower = t_hinge_lower,
        //applies a margin to flank an upper inge of the same size
        it_mate = t_hinge_mate,
        //Anchor protudes from the attachment point inside the wall to fill voids
        il_anchor = t_wall 
    );
    
    //-W UPPER HINGE
    if (ib_hinge_snap)
    for (in_y=[0:in_h-1])
    translate
    ([
        n_side*(-0.5)-t_wall-n_margin,
        in_y*n_side,
        h_attach 
    ])
    rotate([0,0,180])
    upper_lock_spring
    (
        //Attachment
        ih_attach = h_attach,
        //BUGGED: to fix
        ih_delta = -5,
        //Distance from wall to center hole
        il_hole = 3,
        //Thickness of the hinge
        it_hinge = 5,
        //Gap of the hinge, meant to allow spring action toward the inside
        ikt_hinge_spring_gap = 0.25,
        //Thickness of the lock feature
        it_lock = t_hinge_mate+t_hinge_interference,
        //Controls how big it's at the start and how narrow it's at the end
        ikr_lock_start = 1.2,
        ikr_lock_end = 0.9,
        //Anchor protudes from the attachment point inside the wall to fill voids
        il_anchor = t_wall 
    );
    
    
    //+W LOWER HINGE
    if (ib_hinge_snap)
    for (in_y=[0:in_h-1])
    translate
    ([
        n_side*(in_w-0.5)+t_wall+n_margin,
        in_y*n_side,
        h_wall  
    ])
    double_lower_lock
    (
        //Attachment
        ih_attach = h_attach,
        ih_delta = 5,
        //Distance from wall to center hole
        il_hole = 3,
        //Thickness of the hinge
        it_hinge_upper = t_hinge_upper,
        it_hinge_lower = t_hinge_lower,
        //applies a margin to flank an upper inge of the same size
        it_mate = t_hinge_mate,
        //Anchor protudes from the attachment point inside the wall to fill voids
        il_anchor = t_wall 
    );
    
    //+W UPPER HINGE
    if (ib_hinge_snap)
    for (in_y=[0:in_h-1])
    translate
    ([
        n_side*(in_w-0.5)+t_wall+n_margin,
        in_y*n_side,
        h_attach 
    ])
    upper_lock_spring
    (
        //Attachment
        ih_attach = h_attach,
        //BUGGED: to fix
        ih_delta = -5,
        //Distance from wall to center hole
        il_hole = 3,
        //Thickness of the hinge
        it_hinge = 5,
        //Gap of the hinge, meant to allow spring action toward the inside
        ikt_hinge_spring_gap = 0.25,
        //Thickness of the lock feature
        it_lock = t_hinge_mate+t_hinge_interference,
        //Controls how big it's at the start and how narrow it's at the end
        ikr_lock_start = 1.2,
        ikr_lock_end = 0.9,
        //Anchor protudes from the attachment point inside the wall to fill voids
        il_anchor = t_wall 
    );
    /*
    //-H LOWER HINGE
    if (ib_hinge_snap)
    for (in_x=[0:in_w-1])
    translate
    ([
        n_side*(in_x+0.0),
        n_side*(-0.5)-t_wall-n_margin,
        h_wall  
    ])
    rotate([0,0,-90])
    double_lower_lock
    (
        //Attachment
        ih_attach = h_attach,
        ih_delta = 5,
        //Distance from wall to center hole
        il_hole = 3,
        //Thickness of the hinge
        it_hinge_upper = t_hinge_upper,
        it_hinge_lower = t_hinge_lower,
        //applies a margin to flank an upper inge of the same size
        it_mate = t_hinge_mate,
        //Anchor protudes from the attachment point inside the wall to fill voids
        il_anchor = t_wall 
    );
    
    //-H UPPER HINGE
    if (ib_hinge_snap)
    for (in_x=[0:in_w-1])
    translate
    ([
        n_side*(in_x+0.0),
        n_side*(-0.5)-t_wall-n_margin,
        h_attach  
    ])
    rotate([0,0,-90])
    upper_lock_spring
    (
        //Attachment
        ih_attach = h_attach,
        //BUGGED: to fix
        ih_delta = -5,
        //Distance from wall to center hole
        il_hole = 3,
        //Thickness of the hinge
        it_hinge = 5,
        //Gap of the hinge, meant to allow spring action toward the inside
        ikt_hinge_spring_gap = 0.25,
        //Thickness of the lock feature
        it_lock = t_hinge_mate+t_hinge_interference,
        //Controls how big it's at the start and how narrow it's at the end
        ikr_lock_start = 1.2,
        ikr_lock_end = 0.9,
        //Anchor protudes from the attachment point inside the wall to fill voids
        il_anchor = t_wall 
    );
    
    //+H LOWER HINGE
    if (ib_hinge_snap)
    for (in_x=[0:in_w-1])
    translate
    ([
        n_side*(in_x+0.0),
        n_side*(in_h-0.5)+t_wall+n_margin,
        h_wall  
    ])
    rotate([0,0,90])
    double_lower_lock
    (
        //Attachment
        ih_attach = h_attach,
        ih_delta = 5,
        //Distance from wall to center hole
        il_hole = 3,
        //Thickness of the hinge
        it_hinge_upper = t_hinge_upper,
        it_hinge_lower = t_hinge_lower,
        //applies a margin to flank an upper inge of the same size
        it_mate = t_hinge_mate,
        //Anchor protudes from the attachment point inside the wall to fill voids
        il_anchor = t_wall 
    );
    
    //+H UPPER HINGE
    if (ib_hinge_snap)
    for (in_x=[0:in_w-1])
    translate
    ([
        n_side*(in_x+0.0),
        n_side*(in_h-0.5)+t_wall+n_margin,
        h_attach  
    ])
    rotate([0,0,90])
    upper_lock_spring
    (
        //Attachment
        ih_attach = h_attach,
        //BUGGED: to fix
        ih_delta = -5,
        //Distance from wall to center hole
        il_hole = 3,
        //Thickness of the hinge
        it_hinge = 5,
        //Gap of the hinge, meant to allow spring action toward the inside
        ikt_hinge_spring_gap = 0.25,
        //Thickness of the lock feature
        it_lock = t_hinge_mate+t_hinge_interference,
        //Controls how big it's at the start and how narrow it's at the end
        ikr_lock_start = 1.2,
        ikr_lock_end = 0.9,
        //Anchor protudes from the attachment point inside the wall to fill voids
        il_anchor = t_wall 
    );
    */
    
}
if(true)
gridfinity_light_holder
(
	in_w = 4,
	in_h = 5,
	//height of the wall from the floor
	h_wall = 7*10,
	im_mate = 0.0,
	imz_female_bottom = 0.0,
	//Area taken by voids
	in_void = 0.6,
	//Each of this height will spawn an additional vertical hole in the wall. Discretized to ODD.
	cz_mm_per_hole = 30,
	//Each of this side length will spawn an horizontal hole. Discretized to ODD.
	cl_mm_per_hole = 25,
    //Enable spawning of hinge snaps
    ib_hinge_snap = true
);