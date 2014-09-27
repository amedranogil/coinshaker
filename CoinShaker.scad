use <write/Write.scad>;
use <stackable_box.scad>;

// select currency
include <Currency/EUR.scad>;
//include <Currency/USD.scad>;
//include <Currency/GBP.scad>;
//include <Currency/CAD.scad>;


// Parameters
Bwidth = 100;
Blength = 100;
Bheight = 13;
//specify part to generate = 0..#cointypes or "all"
part="all";

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

//number of diameters in lenght
function ninl(d,l) = floor(l/d) - ( l % d <= MinOffset? 1 : 0);

function offset(d,l,n) = (l-d*n)/(n+1);

module test_func(){
echo("all should be 0");
for (l = [50:5:150], d=[9:3:30]) 
{
	assign (n = ninl(d,l))
	echo(l - n*d - (n+1) * offset(d,l,n));
}
}

module stackable_box_with_name(x,y,z,stack_z,gap,wall,bottom,support_start_height, tag){
	echo(tag);
difference(){
	stackable_box(x,y,z,stack_z,gap,wall,bottom,support_start_height);
	//add tag carving on 2 sides
	translate([x/2,0,z/2])rotate([90,0,0]) write(tag, t=wall, h=z-stack_z *2, center=true);
	translate([x/2,y+wall*2,z/2])rotate([90,0,180])write(tag, t=wall, h=z-stack_z *2, center=true);
	}
}

module coin_filter(x, y, z, stack_z, gap, wall, bottom, coin_d, name){
nx = ninl(coin_d,x);
ny = ninl(coin_d,y);
ox = offset(coin_d,x,nx);
oy = offset(coin_d,y,ny);
difference ()
{
	stackable_box_with_name(x,y,z,stack_z,gap,wall,bottom,support_start_height,name);
	for ( i = [0:nx-1], j = [0:ny-1] )
	 {
		translate([ i * (ox + coin_d) +wall + coin_d/2 + ox, j * (oy + coin_d) + wall + coin_d/2+ oy, -1])
			cylinder( r = coin_d/2, h = bottom +2);
	 }
}
}

/*
 * Building the tower
 */
module tower(){

for (n = [0:len(coins)-1]) 
{
	translate ([0,0,2*Bheight*n])
		tray(n);
}

translate([-wall,-wall,2*Bheight*(len(coins))+ Bheight])
	mirror([0,0,1])
	tray(-1);
}


module tray(n = 0){
if (n == 0) {
// bottom does not have holes, just collects smallest coins.
   stackable_box_with_name(Bwidth, Blength, Bheight, stack_z, stack_gap, wall, bottom, support_start_height, coins[0][0]);
} 
if  (n>0 && n <= len(coins)-1) {
	//Each box will have diameter holes mid-size between "this" and previous.
   //since coins is ordered in ascending order of diameter,
   //coins of "this" are too big to pass, the rest go through.
	assign(d = (coins[n-1][1] + coins[n][1])/2) {
	coin_filter(Bwidth, Blength, Bheight, stack_z, stack_gap, wall, bottom, d, coins[n][0]);
	}
}
if (n <0 || n >= len(coins)){
	//Lid to enable shaking in Z too.
	stackable_box_cover(Bwidth, Blength, 5, stack_z, stack_gap,bottom);
}
}

if (part=="all"){
	tower();
}
else {
	tray(part);
}


