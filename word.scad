module letter(l,font="Ubuntu-B.dxf",h=100,i=0) {
    union() {	
	linear_extrude( height=h) import(font, layer=l[i]);
	translate([dxf_dim(file=font, name="advx",layer=l[i]),
		   dxf_dim(file=font, name="advy",layer=l[i]),
		   0])
	children();
    }
}

module word(wrd,font="Ubuntu-B.dxf",h=100,i=0) {
    if(i < len(wrd)) {
	letter(wrd,font,h,i) word(wrd,font,h,i+1);
    } else {
	children();
    }
}

module write(wrd,font="Ubuntu-B.dxf", t=10, h=1, center=true) {
    //TODO adjust to requested size
    scale(0.001) word(wrd,font,h,0);
}
