all: EUR_CoinSorter.stl USD_CoinSorter.scad GBP_CoinSorter.scad CAD_CoinSorter.scad

%.stl: %.scad
	openscad -m make -d $*.deps -o $@ $<
