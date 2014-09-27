include <../parameters.scad>
include <../CoinShaker.scad>


// select currency
include <../Currency/EUR.scad>;

//specify part to generate = 0..#cointypes or "all"
part="all";

if (part=="all"){
	tower();
}
else {
	tray(part);
}
