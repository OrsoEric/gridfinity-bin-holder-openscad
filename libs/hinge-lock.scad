//Meant to lock or rotate a lid
//
//The upper lock is just a U
//2025-07-31
//3D printed a hinge snap fit that works fine, it works great!


//The same, but spawns balls instead of an hole
//It's meant to mate with the hole of the lower hinge
module upper_lock
(
	//Ring
	id_hinge_outer = 5,
	id_hinge_inner = 3,
	//Attachment
	ih_attach = 10,
	ih_delta = -5,
	//Distance from wall to center hole
	il_hole = 7,
	//Thickness of the hinge
	it_hinge = 5,
    //Anchor protude from the attachment
    il_anchor = 0
)
{

	//Thickness of the hinge
	t_hinge = it_hinge;

	h_attach = ih_attach;
	//Outer diameter of the hinge
	d_hinge_outer = id_hinge_outer;
	d_hinge_inner = id_hinge_inner;
	//Distance from wall to the hinge
	l_hinge = il_hole;

	//how much I ascend
	h_delta = ih_delta;

	//I use a polygon to make the droop

	ann_points = 
	[
		//Base point
		[0, 0],
		//I go down, attachment
		[0, -h_attach],
		//Now I go out and up to make it printable
		[l_hinge+d_hinge_outer/4, h_delta],
		//I go up vertically, this is inside the circle
		[l_hinge, h_delta+d_hinge_outer],
		//I go back to exit from the hinge
		[l_hinge-d_hinge_outer/2, h_delta+d_hinge_outer]
		//I go back down to the origin

	];

	translate([0,t_hinge/2,0])
	rotate([90,0,00])
	union()
	{
		linear_extrude(height=t_hinge)
		polygon(ann_points);

		linear_extrude(height=t_hinge)
		translate([l_hinge,h_delta+d_hinge_outer*0.5])
		circle(d=d_hinge_outer, $fn=40);
		//Spawn two spheres. I should do a proper spring
		translate([l_hinge,h_delta+d_hinge_outer*0.5,0])
		sphere(d=d_hinge_inner,$fn=40);
		translate([l_hinge,h_delta+d_hinge_outer*0.5,t_hinge])
		sphere(d=d_hinge_inner,$fn=40);
	}

}

//Replace the ball with a spring
module upper_lock_spring
(
	//Ring
	id_hinge_outer = 5,
	id_hinge_inner = 3,
	//Attachment
	ih_attach = 10,
	ih_delta = 10,
	//Distance from wall to center hole
	il_hole = 7,
	//Thickness of the hinge
	it_hinge = 5,
    //Gap of the hinge, meant to allow spring action toward the inside
    ikt_hinge_spring_gap = 0.3,
    //Thickness of the lock feature
    it_lock = 0.5,
    //Controls how big it's at the start and how narrow it's at the end
    ikr_lock_start = 1.1,
    ikr_lock_end = 0.9,
    //Anchor protudes from the attachment
    il_anchor = 0
)
{

	//Thickness of the hinge
	t_hinge = it_hinge;

	h_attach = ih_attach;
	//Outer diameter of the hinge
	d_hinge_outer = id_hinge_outer;
	d_hinge_inner = id_hinge_inner;
	//Distance from wall to the hinge
	l_hinge = il_hole;

	//how much I ascend
	h_delta = ih_delta;

	//I use a polygon to make the droop

	ann_points = 
	[
		//Base point
		[0, 0],
		//I go down, attachment
		[0, -h_attach],
		//Now I go out and up to make it printable
		[l_hinge+d_hinge_outer/4, h_delta],
		//I go up vertically, this is inside the circle
		[l_hinge, h_delta+d_hinge_outer],
		//I go back to exit from the hinge
		[l_hinge-d_hinge_outer/2, h_delta+d_hinge_outer]
		//I go back down to the origin

	];

	translate([0,t_hinge/2,0])
	rotate([90,0,00])
	union()
	{
        //Left Hinge
        t_hinge_left = t_hinge*(1-ikt_hinge_spring_gap)*0.5;
        translate([0,0,+t_hinge*(0.5+ikt_hinge_spring_gap/2)])
		linear_extrude(height=t_hinge_left)
        union()
        {
            polygon(ann_points);
            //linear_extrude(height=t_hinge_right)
            translate([l_hinge,h_delta+d_hinge_outer*0.5])
            circle(d=d_hinge_outer, $fn=40);
        }
    
        //Right Hinge
        t_hinge_right = t_hinge*(1-ikt_hinge_spring_gap)*0.5;
		linear_extrude(height=t_hinge_right)
        union()
        {
            polygon(ann_points);
            //linear_extrude(height=t_hinge_right)
            translate([l_hinge,h_delta+d_hinge_outer*0.5])
            circle(d=d_hinge_outer, $fn=40);
        }
        //Feature meant to interfere by a small margin with the lower lock
		//Create a cone
		translate
        ([
            l_hinge,
            h_delta+d_hinge_outer*0.5,
            -t_hinge*0-it_lock*1
        ])
        cylinder
        (
            h=it_lock,
            r2=id_hinge_inner*0.5*ikr_lock_start,
            r1=id_hinge_inner*0.5*ikr_lock_end,
            $fn=40
        );
        //Create a cone
        translate
        ([
            l_hinge,
            h_delta+d_hinge_outer*0.5,
            +t_hinge*1+it_lock*0
        ])
        cylinder
        (
            h=it_lock,
            r1=id_hinge_inner*0.5*ikr_lock_start,
            r2=id_hinge_inner*0.5*ikr_lock_end,
            $fn=40
        );
        //If the user wants an anchor behind the attachment
        if (il_anchor>0)
        translate([-il_anchor,-d_hinge_outer*2,0])
        cube([il_anchor,ih_attach,t_hinge]);
	}

}


//Lower Lock
//It droops upward and is meant to mate with the upper lock
//Ideally I'd make it with a compliant spring to go inside


module lower_lock
(
	//Ring
	id_hinge_outer = 5,
	id_hinge_inner = 3,
	//Attachment
	ih_attach = 10,
	ih_delta = 10,
	//Distance from wall to center hole
	il_hole = 10,
	//Thickness of the hinge
	it_hinge = 5,
    //Anchor protude from the attachment
    il_anchor = 0
)
{

	//Thickness of the hinge
	t_hinge = it_hinge;

	h_attach = ih_attach;
	//Outer diameter of the hinge
	d_hinge_outer = id_hinge_outer;
	d_hinge_inner = id_hinge_inner;
	//Distance from wall to the hinge
	l_hinge = il_hole;

	//how much I ascend
	h_delta = ih_delta;

	//I use a polygon to make the droop

	ann_points = 
	[
		//Base point
		[0, 0],
		//I go down, attachment
		[0, -h_attach],
		//Now I go out and up to make it printable
		[l_hinge+d_hinge_outer/3, h_delta],
		//I go up vertically, this is inside the circle
		[l_hinge, h_delta+d_hinge_outer],
		//I go back to exit from the hinge
		[l_hinge-d_hinge_outer/2, h_delta+d_hinge_outer]
		//I go back down to the origin

	];

	translate([0,t_hinge/2,0])
	rotate([90,0,00])
	difference()
	{
		union()
		{
			linear_extrude(height=t_hinge)
			polygon(ann_points);
	
			linear_extrude(height=t_hinge)
			translate([l_hinge,h_delta+d_hinge_outer*0.5])
			circle(d=d_hinge_outer, $fn=40);
            //If the user wants an anchor behind the attachment
            if (il_anchor>0)
            translate([-il_anchor,-h_delta-d_hinge_outer*1,0])
            cube([il_anchor,ih_attach,t_hinge]);
		}
		union()
		{
			linear_extrude(height=t_hinge)
			translate([l_hinge,h_delta+d_hinge_outer*0.5])
			circle(d=d_hinge_inner, $fn=40);
		}
	}


}


if (false)
upper_lock();

if (false)
lower_lock();

//Show the locks mating side by side
if(false)
{
	t_hinge = 5;
	h_delta = 10.0;
	//Distance between two locks for mating
	t_mate = 0.2;

	//UPPER LOCK
	translate([0,t_hinge/2,0])
	upper_lock
	(
		//Ring
		id_hinge_outer = 5,
		id_hinge_inner = 3,
		//Attachment
		ih_attach = 10,
		ih_delta = -5,
		//Distance from wall to center hole
		il_hole = 0,
		//Thickness of the hinge
		it_hinge = 5,
        //Gap of the hinge, meant to allow spring action toward the inside
        ikt_hinge_spring_gap = 0.3,
        //Thickness of the lock feature
        it_lock = 0.5,
        //Controls how big it's at the start and how narrow it's at the end
        ikr_lock_start = 1.1,
        ikr_lock_end = 0.9
	);

	//LOWER LOCK
	translate([0,-t_hinge/2-0.5,-h_delta])
	lower_lock
	(
		//Ring
		id_hinge_outer = 5,
		id_hinge_inner = 3,
		//Attachment
		ih_attach = 10,
		ih_delta = 5,
		//Distance from wall to center hole
		il_hole = 5,
		//Thickness of the hinge
		it_hinge = 5
	);

	//LOWER LOCK
	translate([0,+t_hinge*1.5+0.5,-h_delta])
	lower_lock
	(
		//Ring
		id_hinge_outer = 5,
		id_hinge_inner = 3,
		//Attachment
		ih_attach = 10,
		ih_delta = 5,
		//Distance from wall to center hole
		il_hole = 5,
		//Thickness of the hinge
		it_hinge = 5
	);

}

module double_lower_lock
(
    //Ring
    id_hinge_outer = 5,
    id_hinge_inner = 3,
    //Attachment
    ih_attach = 10,
    ih_delta = 5,
    //Distance from wall to center hole
    il_hole = 3,
    //Thickness of the hinge
    it_hinge_lower = 5,
	it_hinge_upper = 5,
    //applies a margin to flank an upper inge of the same size
    it_mate = 0.2,
    //Anchor protude from the attachment
    il_anchor = 0,
	
)
{
    translate([0,-it_hinge_upper/2-it_hinge_lower/2-it_mate,0])
    lower_lock
    (
        //Ring
        id_hinge_outer = 5,
        id_hinge_inner = 3,
        //Attachment
        ih_attach = 10,
        ih_delta = 5,
        //Distance from wall to center hole
        il_hole = 3,
        //Thickness of the hinge
        it_hinge = it_hinge_lower,
        //Anchor protude from the attachment
        il_anchor = il_anchor
    );

    translate([0,+it_hinge_upper/2+it_hinge_lower/2+it_mate,0])
    lower_lock
    (
        //Ring
        id_hinge_outer = 5,
        id_hinge_inner = 3,
        //Attachment
        ih_attach = 10,
        ih_delta = 5,
        //Distance from wall to center hole
        il_hole = 3,
        //Thickness of the hinge
        it_hinge = it_hinge_lower,
        //Anchor protude from the attachment
        il_anchor = il_anchor
    );


}

//3D printed structure to test the hinge locking
if (false)
{
	h_structure = 20.0;
	w_structure = 16.0;

	t_hinge = 5;
	h_delta = 10.0;
	//Distance between two locks for mating
	t_mate = 0.15;
    //Interference between the locking feature and the hinge hole
    t_interference = 0.25;
    
	union()
	{
		//Structure
		translate([-3,0,0])
		cube([3,w_structure,h_structure]);
		translate([-3-w_structure/2,w_structure/2,0])
		cube([w_structure/2,3,h_structure]);

		h_attach = 10;

		//UPPER LOCK
		translate([0,w_structure/2,h_attach])
		upper_lock_spring
		(
			//Ring
			id_hinge_outer = 5,
			id_hinge_inner = 3,
			//Attachment
			ih_attach = 10,
			ih_delta = -5,
			//Distance from wall to center hole
			il_hole = 3,
			//Thickness of the hinge
			it_hinge = 5,
            //Gap of the hinge, meant to allow spring action toward the inside
            ikt_hinge_spring_gap = 0.25,
            //Thickness of the lock feature
            it_lock = t_mate+t_interference,
            //Controls how big it's at the start and how narrow it's at the end
            ikr_lock_start = 1.2,
            ikr_lock_end = 0.9,
            //Anchor protude from the attachment
            il_anchor = 3
		);

		//LOWER LOCK
		translate([0,w_structure/2,h_structure])
		double_lower_lock
        (
            //Ring
            id_hinge_outer = 5,
            id_hinge_inner = 3,
            //Attachment
            ih_attach = 10,
            ih_delta = 5,
            //Distance from wall to center hole
            il_hole = 3,
            //Thickness of the hinge
            it_hinge_lower = 10,
			it_hinge_upper = 5,
            //applies a margin to flank an upper inge of the same size
            it_mate = 0.2,
            //Anchor protude from the attachment
            il_anchor = 3
        );
	}
}	





