set OxThick -0.0012
set LeftDrawn -0.045
set LeftEff -0.030
set RightEff 0.030
set RightDrawn 0.045
set SpacerWidth 0.05
set back 30.0
set HDWidth 0.25
set LeftEdge [expr -2.0*$HDWidth]

proc SkeletalGrid {NoGate} {
    global OxThick back LeftEdge HDWidth LeftDrawn RightDrawn

    if {$NoGate} {
	# Horizontal lines
	line x loc= $OxThick tag=TopOx
	line x loc=0.00 spac=0.05 tag=TopSi
	line x loc=3.0 spac=0.25
	line x loc=$back tag=Bottom

	# Vertical lines
	line y loc=$LeftEdge tag=Left
	line y loc= $LeftDrawn spac=0.03 tag=GateLeft
	line y loc= $RightDrawn spac=0.03 tag=GateRight
	line y loc=$HDWidth tag=Right spac=0.25

	# Regions
	region Oxide   xlo=TopOx xhi=TopSi  ylo=Left yhi=Right
	region Silicon xlo=TopSi xhi=Bottom ylo=Left yhi=Right
	init 
	Smooth Silicon
    } else {
	# Horizontal lines
	line x loc= -0.1 tag=TopPoly
	line x loc= $OxThick tag=TopOx
	line x loc=0.00 spac=0.05 tag=TopSi
	line x loc=3.0 spac=0.25
	line x loc=$back tag=Bottom

	# Vertical lines
	line y loc=$LeftEdge tag=Left
	line y loc= $LeftDrawn spac=0.03 tag=GateLeft
	line y loc= $RightDrawn spac=0.03 tag=GateRight
	line y loc=$HDWidth tag=Right spac=0.25

	# Regions
	region Oxide   xlo=TopOx xhi=TopSi  ylo=Left yhi=Right
	region Silicon xlo=TopSi xhi=Bottom ylo=Left yhi=Right
	region Nitride   xlo=TopPoly xhi=TopOx  ylo=Left yhi=GateLeft
	region Nitride   xlo=TopPoly xhi=TopOx  ylo=GateRight yhi=Right
	region Poly   xlo=TopPoly xhi=TopOx  ylo=GateLeft yhi=GateRight
	init 
	strip nitride
	Smooth Silicon
    } 
}

SkeletalGrid 0
    window row=1 col=1
    plot2d grid xmax=0.7

    #define a spacer, do implants
    deposit oxide rate=0.014 time=1 spac=2.5e-3
    deposit nitride rate=0.034 time=1 spac=2.5e-3
    deposit oxide rate=0.093 time=1 spac=2.5e-3
    plot2d grid xmax=0.7

    machine etch aniso name=spacerOx oxide rate=0.093
    machine etch iso name=spacerOx oxide rate=0.01
    machine etch iso name=spacerOx nitride rate=0.01
    etch oxide aniso time=1.05 machine=spacerOx spacing=1.0e-3 
    plot2d grid xmax=0.7

    machine etch aniso name=spacerNi nitride rate=0.034
    machine etch iso name=spacerNi nitride rate=0.003
    machine etch iso name=spacerNi oxide rate=0.003
    etch oxide aniso time=1.05 machine=spacerNi spacing=1.0e-3 

    plot2d grid xmax=0.7

