include <Switches.scad>;

$fn=20;
j = 0.1;

difference() 
{	
	Base();
	AllTheButtons(true);
}
AllTheButtons(false);


module Label(label)
{
	color("Orange")
	text(text = label, halign = "center", size=4);
}

module Base()
{
	translate([-100, -90, -1-j])
	cube([200, 150, 1]);
}

module AllTheButtons(hcm)
{
	lineHeight = 5;
	
	translate([-80, 0, 0]) Joystick(hcm); // Thrusters

	translate([50, -50, 0]) 
	union()
	{
		Joystick(hcm); // UI
		translate([-20, 15, 0]) RoundButton("Blue", hcm); // Previous tab
		translate([20, 15, 0]) RoundButton("Blue", hcm); // Next tab
	}

	translate([0, 0, 0])
	union()
	{
		translate([-1.5 * 25, 30, 0]) 
		union() 
		{ 
			translate([0, 2+lineHeight, 0]) Label("Lights");
			Toggle(0, hcm);
		}

		translate([-0.5 * 25, 30, 0])
		union() 
		{ 
			translate([0, 2+lineHeight*2, 0]) Label("Landing");
			translate([0, 2+lineHeight, 0]) Label("Gear");
			Toggle(0, hcm);
		}

		translate([0.5 * 25, 30, 0])
		union() 
		{ 
			translate([0, 2+lineHeight*2, 0]) Label("Fuel");
			translate([0, 2+lineHeight, 0]) Label("Scoop");
			Toggle(0, hcm);
		}

		translate([1.5 * 25, 30, 0])
		union() 
		{ 
			translate([0, 2+lineHeight*2, 0]) Label("Cargo");
			translate([0, 2+lineHeight, 0]) Label("Scoop");
			Toggle(0, hcm);
		}
	}

	translate([0, 0, 0])
	union()
	{
		translate([-1.5 * 25, 0, 0])
		union()
		{
			translate([0, -8-lineHeight, 0]) Label("Frameshift");
			translate([0, -8-lineHeight*2, 0]) Label("Drive");
			RoundButton("Red", hcm); // Frameshift Drive
		}
		
		translate([-0.5 * 25, 0, 0]) 
		union()
		{
			translate([0, -8-lineHeight, 0]) Label("Silent");
			translate([0, -8-lineHeight*2, 0]) Label("Running");
			RoundButton("Red", hcm); // Silent Running
		}
		
		translate([0.5 * 25, 0, 0]) 
		union()
		{
			translate([0, -8-lineHeight, 0]) Label("Dump");
			translate([0, -8-lineHeight*2, 0]) Label("Radiator");
			RoundButton("Red", hcm); // Dump Radiator
		}
		
		translate([1.5 * 25, 0, 0]) 
		union()
		{
			translate([0, -8-lineHeight, 0]) Label("Deploy");
			translate([0, -8-lineHeight*2, 0]) Label("Hardpoints");
			RoundButton("Red", hcm); // Deploy Hardpoints
		}
	}

	translate([-50, -35, 0])
	union()
	{
		RoundButton("Orange", hcm); // Reset power
		translate([0, 25, 0]) translate([0, -50, 0]) RoundButton("Orange", hcm); // Reset power
		translate([0, 25, 0]) rotate([0, 0, -30]) translate([0, -50, 0]) RoundButton("Orange", hcm); // Reset power
		translate([0, 25, 0]) rotate([0, 0, 30]) translate([0, -50, 0]) RoundButton("Orange", hcm); // Reset power
	}
}