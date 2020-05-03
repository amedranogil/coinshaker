/*
 * Main parameters
 */

//specify part to generate
part="all"; // ["all", "tray", "lid"]
// If part is tray, select the number of the tray
part_tray= 1;

//select currentcy
currency = "EUR"; // ["CAD","EUR","GBP","SGD","USD", "CUSTOM"]

/* [Box dimensions] */
// Internal Box width
Bwidth = 100; 
// Internal Box length
Blength = 100; 
// Internal Box height
Bheight = 13; 
// wall thickness
wall = 2.5;
// bottom thickness
bottom = 1;
// the z height of the stacking frame
stack_z = 5;
//Text size modifier
text_size_modifyer=1.0; //[0.1:0.1:2]
//Text Font
text_font = "Liberation Sans";
//lip wall reduction, enhances stackability. adjust accoring to printer
epsilon = 0.1;


/* [Hole parameters] */
//the minimal separation between holes
MinOffset = 1;
// per side gap between the box-bottom and the stacking frame 
stack_gap = 1;

// start-height for overhang suport (should be >stack_z )
support_start_height = Bheight - stack_z ;

/* [Custom Currency]*/
// coins matrix each coin a row (denomination, diameter) IMPORTANT: must be sorted by increasing diameter
coinsCustom= [["C1",10],["C2",20],["C3",30]];
/* [ABS printing Options] */
//ABS-antideformation Ear Radius (0 to deactivate)
earR=0;
//ABS-antideformation Ear Height
earH=1;

/*
 * Stackable box
 */
module stackable_box_cover(x, y,stack_z, gap, w,c) {
	cube([x + w*4 + gap*2, y + w*4 + gap*2, c]);
	translate([w+gap, w+gap, 0])
		cube([x + w*2, y + w*2, stack_z+c]);
}


module stackable_box(x, y, z,stack_z, gap, w, b, supheight, epsilon=0.1) {
	box(x, y, z, w, b);
	translate([-wall-gap , -wall-gap , z+b])
		box(x + wall*2 + gap*2 +2*epsilon, y + wall*2 + gap*2+2*epsilon, stack_z, w-epsilon, 0);

	difference() {
		hull() {
			translate([-wall-gap, -wall-gap, z+b]) 
				box(x + wall*2 + gap*2 +2*epsilon, y + wall*2 + gap*2 +2*epsilon, 0.1,  w-epsilon, 0);
			translate([0, 0, supheight]) 
				box(x, y, 0.1, w, b);
		}
		translate([w,w, 0]) 
			cube([x, y, z*2]);
	}
}

module box(x, y, z, w,b) {
	difference() {
		cube([(x + (2 * w)), (y + (2 * w)), (z + b)]);
		translate([w, w, b==0?-0.1:b ]) 
			cube([x, y, (z * 2)]);
	}
}

module ears(xmin, ymin, xmax, ymax, ear_radius, ear_height) {
	translate([xmin, ymin, 0]) cylinder(r = ear_radius, h = ear_height);
	translate([xmin, ymax, 0]) cylinder(r = ear_radius, h = ear_height);
	translate([xmax, ymin, 0]) cylinder(r = ear_radius, h = ear_height);
	translate([xmax, ymax, 0]) cylinder(r = ear_radius, h = ear_height);
}

/*
 * Coinshaker
 */
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
difference(){
	stackable_box(x,y,z,stack_z,gap,wall,bottom,support_start_height,epsilon);
	//add tag carving on 2 sides
    translate([x/2,0,support_start_height/2+bottom])rotate([90,0,0]) 
    linear_extrude(height=wall*4)
     text(text = tag,
            font = text_font, 
            size = text_size_modifyer*(support_start_height-bottom), 
            valign = "center",
            halign = "center");
    translate([x/2,y+wall*2,support_start_height/2+bottom])rotate([90,0,180])
    linear_extrude(height=wall*4)
     text(text = tag,
            font = text_font, 
            size = text_size_modifyer*(support_start_height-bottom), 
            valign = "center",
            halign = "center");
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

module tower(coins){

for (n = [0:len(coins)-1]) 
{
	translate ([0,0,2*Bheight*n])
		tray(n,coins);
}

translate([-wall*2-stack_gap,-wall*2-stack_gap,2*Bheight*(len(coins))+ Bheight])
	mirror([0,0,1])
	tray(-1,coins);
}


module tray(n = 0,coins){
if (earR <= 0) {
   justTray(n,coins);
} else {
   union(){
     justTray(n,coins);
     ears(0,0,Bwidth, Blength,earR,earH);
   }
}

}

module justTray(n,coins){
if (n == 0) {
   // bottom does not have holes, just collects smallest coins.
   stackable_box_with_name(Bwidth, Blength, Bheight, stack_z, stack_gap, wall, bottom, support_start_height, coins[0][0]);
} 
if  (n>0 && n < len(coins)) {
   //Each box will have diameter holes mid-size between "this" and previous.
   //since coins is ordered in ascending order of diameter,
   //coins of "this" are too big to pass, the rest go through.
	let(d = (coins[n-1][1] + coins[n][1])/2) {
	echo( coins[n][0]);
   echo(d);
	coin_filter(Bwidth, Blength, Bheight, stack_z, stack_gap, wall, bottom, d, coins[n][0]);
	}
}
if (n <0 || n >= len(coins)){
   //Lid to enable shaking in Z too.
   stackable_box_cover(Bwidth, Blength, 5, stack_z, stack_gap,bottom);
}
}

module main(coins){
    if (part=="all"){
	tower(coins);
    }
    else if (part == "lid"){
        tray(-1,coins);
    }
    else {
        tray(part_tray,coins);
    }
}

/*
 * Coin selectors
 */
if (currency == "CAD"){
   coins = [
//Denomination , 	Diameter,	Thickness,	Weight
["$0.10", 			18.03,		1.22,			1.75],
["$0.01", 			19.05,		1.45,			2.35],
["$0.05", 			21.20,		1.76,			3.95],
["$0.25", 			23.88,		1.58,			4.40],
["$1.00", 			26.50,		1.75,			7.00],
["$0.50", 			27.13,		1.95,			6.90],
["$2.00", 			28.00,		1.80,			7.30]
];
    main(coins);
}

if (currency == "EUR"){
    coins = [
//Denomination , 	Diameter,	Thickness,	Weight
["€0.01", 			16.25,		1.67,			2.30],
["€0.02", 			18.75,		1.67,			3.06],
["€0.10",			19.75,		1.93,			4.10],
["€0.05", 			21.25,		1.67,			3.92],
["€0.20", 			22.25,		2.14,			5.74],
["€1.00", 			23.25,		2.33,			7.50],
["€0.50", 			24.25,		2.38,			7.80],
["€2.00", 			25.75,	    2.20,			8.50]
];
    main(coins);
}

if (currency == "GBP"){
coins = [
//Denomination , 	Diameter,	Thickness,	Weight
["£0.05",		18.0,		1.70,		3.25],
["£0.01",		20.3,		1.65,		3.56],
["£0.20",		21.4,		1.70,		5.00],
["£1.00",		22.5,		3.15,		9.50],
["£0.10",		24.5,		1.85,		6.50],
["£0.02",		25.9,		2.03,		7.12],
["£0.50",		27.3,		1.78,		8.00],
["£2.00",		28.4,		2.50,		12.0],
["£5.00",		38.61,		2.89,		28.28],
];
    main(coins);
}

if (currency == "SGD"){
coins = [
//Denomination , 	Diameter,	Thickness,	Weight
["$0.01 (old)",  15.90,		1.10,			1.24],
["$0.05 (old)",  16.75,		1.22,			1.56],
["$0.05",        16.75,		1.22,			1.70],
["$0.10",        18.50,		1.38,			2.36],
["$0.10 (old)",  18.50,		1.38,			2.60],
["$0.20",        21.00,		1.72,			3.85],
["$0.20 (old)",  21.36,		1.72,			4.50],
["$1.00 (old)",  22.40,		2.40,			6.30],
["$0.50",        23.00,		2.45,			6.56],
["$1.00",        24.65,		2.50,			7.62],
["$0.50 (old)",  24.66,		2.06,			7.29],
];
    main(coins);
}

if (currency == "USD"){
coins = [
//Denomination , 	Diameter,	Thickness,	Weight
["$0.10", 			17.91,		1.35,			2.268],
["$0.01", 			19.05,		1.52,			2.500],
["$0.05", 			21.21,		1.95,			5.000],
["$0.25", 			24.26,		1.75,			5.670],
["$1.00", 			26.49,		2.00,			8.100],
["$0.50", 			30.61,		2.15,			11.34]
];
    main(coins);
}

if (currency == "CUSTOM"){
    main(coinsCustom);
}


