j = 0.1;
module Toggle(position, holeCutterMode = false)
{
	rBase = 5.7/2;
	r1Knob = 2.5/2;
	r2Knob = 2.9/2;
	hKnob = 10;
	
	angle = [-20 + 40*position, 0, 0];
	
	if (holeCutterMode)
	{
		cylinder(r = rBase, h = 10, center = true);
	} 
	else 
	{
		color("DimGray")
		union()
		{
			// Threaded hub
			difference()
			{
				cylinder(r = rBase, h = 2);
				translate([0, 0, -j]) cylinder(r = rBase-0.5, h = 2+j*2);
			}
			
			// Nut
			difference()
			{
				cylinder(r = rBase*1.5, h = 1, $fn=6);
				translate([0, 0, -j]) cylinder(r = rBase-0.5, h = 2+j*2);
			}	
			
			// Knob
			rotate(angle)
			union()
			{
				cylinder(r1 = r1Knob, r2 = r2Knob, h = hKnob);
				translate([0, 0, hKnob]) sphere(r = r2Knob);
			}
		}
	}
}

module Joystick(holeCutterMode = false)
{	
	rBase = 26.5/2;
	hBase = 7.8;
	
	hKnob = 6.5;
	rKnob = 20/2;
	
	rShaft = 11/2;
	
	if (holeCutterMode)
	{
		cylinder(r = rKnob, h = 10, center = true);
	} 
	else 
	{
		color("DimGray")
		translate([0, 0, -7])
		difference()
		{
			union()
			{
				// Base
				scale([1, 1, hBase/rBase])
				sphere(rBase);

				// Knob
				translate([0, 0, 14.5])
				scale([1, 1, hKnob/rKnob])
				sphere(rKnob);
				
				// Shaft
				cylinder(r = rShaft, h = 10);
			}
			rotate([180, 0, 0])
			cylinder(r = rBase, h = rBase);
		}
	}
}

module RoundButton(colour, holeCutterMode = false)
{
	roundness = 0.5	;
	height = 6.3;
	rThread = 16/2;
	rButton = 13/2;
	r1Bezel = 19/2;
	r2Bezel = (r1Bezel-rButton)/2;

	if (holeCutterMode)
	{
		cylinder(r = rThread, h = 10, center = true);
	} 
	else 
	{
		difference()
		{
			union()
			{
				// Button
				color(colour)
				translate([0, 0, j])
				union()
				{
					cylinder(r = rButton, h = height - roundness);
					cylinder(r = rButton-roundness, h = height);
					translate([0, 0, height-roundness])
					rotate_extrude(convexity = 10)
					translate([rButton - roundness, 0, 0])
					circle(r = roundness);
				}
				
				// Bezel
				color("Silver")
				union()
				{
					rotate_extrude(convexity = 10)
					translate([rButton + r2Bezel - j, 0, 0])
					circle(r = r2Bezel);
				}
			}
			
			color("Silver")
			rotate([180, 0, 0])
			cylinder(r = r1Bezel+r2Bezel, h = r2Bezel);
		}
	}
}
