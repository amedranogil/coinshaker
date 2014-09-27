include <../parameters.scad>
include <../CoinShaker.scad>


// select currency
include <../Currency/GBP.scad>;

//specify part to generate = 0..#cointypes or "all"
part="all";

if (part=="all"){
	tower();
}
else {
	tray(part);
}
