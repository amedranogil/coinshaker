/*
 * Main parameters
 */
//Internal box dimensions
Bwidth = 100;
Blength = 100;
Bheight = 13;

//lip wall reduction, enhances stackability. adjust accoring to printer
epsilon = 0.0125;

/*
 * tweakable parameters
 */
//the minimal separation between holes
MinOffset = 1.5;
// the z height of the stacking frame
stack_z = 5;
// per side gap between the box-bottom and the stacking frame 
stack_gap = 1;

// start-height for overhang suport (should be >stack_z )
support_start_height = Bheight - stack_z ;

// wall thickness
wall = 3;
// bottom thickness
bottom = 2;

//ABS-antideformation Ear Radius (0 to deactivate)
earR=0;
//ABS-antideformation Ear Height
earH=1;
