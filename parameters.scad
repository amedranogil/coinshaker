/*
 * Main parameters
 */
Bwidth = 100;
Blength = 100;
Bheight = 13;

/*
 * tweakable parameters
 */
//the minimal separation between holes
MinOffset = 1;
// the z height of the stacking frame
stack_z = 5;
// per side gap between the box-bottom and the stacking frame 
stack_gap = 1;

// start-height for overhang suport (should be >stack_z )
support_start_height = Bheight - stack_z ;

// wall thickness
wall = 2.5;
// bottom thickness
bottom = 1;
