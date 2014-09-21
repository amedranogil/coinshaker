use <stackable_box.scad>;

// select currency
include <EUR.scad>;
//include <USD.scad>;


// Parameters
Bwidth = 70;
Blength = 70;
Bheight = 15;

//tweak parameters
MinOffset = 1;
// the z height of the stacking frame
stack_z = 5;
// per side gap between the box-bottom and the stacking frame 
stack_gap = 1;

// wall thickness
wall = 2;
// bottom thickness
bottom = 2;

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

module coin_filter(x, y, z, stack_z, gap, wall, bottom, coin_d){
nx = ninl(coin_d,x);
ny = ninl(coin_d,y);
ox = offset(coin_d,x,nx);
oy = offset(coin_d,y,ny);
difference ()
{
	stackable_box(x,y,z,stack_z,gap,wall,bottom,0);
	for ( i = [0:nx-1], j = [0:ny-1] )
	 {
		translate([ i * (ox + coin_d) +wall + coin_d/2 + ox, j * (oy + coin_d) + wall + coin_d/2+ oy, -1])
			cylinder( r = coin_d/2, h = bottom +2);
	 }
}
}

coin_filter(Bwidth,Blength, Bheight, stack_z, stack_gap, wall, bottom,30);