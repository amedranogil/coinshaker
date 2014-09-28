include <CoinShaker.scad>



/*
 * Main parameters
 */
// select currency
include <EUR.scad>;

//specify part to generate = 0..#cointypes or "all"
part="all";

//Internal box dimensions
Bwidth = 100;
Blength = 100;
Bheight = 13;

//lip wall reduction, enhances stackability. adjust accoring to printer
epsilon = 0.1;

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

//ABS-antideformation Ear Radius (0 to deactivate)
earR=0;
//ABS-antideformation Ear Height
earH=1;

if (part=="all"){
	tower();
}
else {
	tray(part);
}
