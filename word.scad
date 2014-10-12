function length(l,font="Ubuntu-B.dxf",i=0) =
i==len(l)? 
            0 
         :
            dxf_dim(file=font, name="advx",layer=l[i]) + length(l,font,i+1);

function height(l,font="Ubuntu-B.dxf",i=0) =
i==len(l)? 
            0 
         :
           max (dxf_dim(file=font, name="miny",layer=l[i]), length(l,font,i+1));


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
    ww = length(wrd,font);
    hw = height(wrd,font);
    s = t/(hw/2);
    if (center == true) {
        translate([-s*ww/2, -s*hw/5 ,-h/2])
        scale([s,s,1]) word(wrd,font,h,0);
    }
    else {
        scale([s,s,1]) word(wrd,font,h,0);
    }
}
