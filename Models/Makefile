all: EUR_CoinSorter.stl USD_CoinSorter.stl GBP_CoinSorter.stl CAD_CoinSorter.stl

%.stl: %.scad
	openscad -m make -d CoinSorter.deps -o $@ $<
