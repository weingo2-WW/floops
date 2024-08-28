#grid section
set OxThick -0.0012
set LeftDrawn -0.045
set LeftEff -0.030
set RightEff 0.030
set RightDrawn 0.045
set SpacerWidth 0.05
set back 30.0

# Horizontal lines
line x loc=-0.15 spac=0.05 tag=TopPoly
line x loc= $OxThick spac=0.002  tag=TopOx
line x loc=0.00 spac=0.0002   tag=TopSi
line x loc=0.04 spac=0.0002
line x loc=0.25 spac=0.02
line x loc=3.00 spac=0.1   tag=Bottom

# Vertical lines
line y loc=-0.5 spac=0.025  tag=Left
line y loc= $LeftDrawn spac=0.002 tag=GateLeft
line y loc=0.0 spac=0.002
line y loc= $RightDrawn spac=0.002 tag=GateRight
line y loc=0.5 spac=0.025  tag=Right
    
# Regions
region Nitride   xlo=TopPoly xhi=TopOx  ylo=Left yhi=GateLeft
region Nitride   xlo=TopPoly xhi=TopOx  ylo=GateRight yhi=Right
region Poly   xlo=TopPoly xhi=TopOx  ylo=GateLeft yhi=GateRight
region Oxide   xlo=TopOx xhi=TopSi  ylo=Left yhi=Right
region Silicon xlo=TopSi xhi=Bottom ylo=Left yhi=Right
init 
strip nitride

proc p1d {arg1 arg2} {
    window row=1 col=1
    sel z=log10(Halo0+1.0e15)
    plot1d $arg1 $arg2 log name=Halo0
    sel z=log10(Halo15+1.0e15)
    plot1d $arg1 $arg2 log name=Halo15
    sel z=log10(Halo30+1.0e15)
    plot1d $arg1 $arg2 log name=Halo30
    sel z=log10(Halo45+1.0e15)
    plot1d $arg1 $arg2 log name=Halo45
    sel z=log10(Halo60+1.0e15)
    plot1d $arg1 $arg2 log name=Halo60
}
proc p2d {name} {
    window row=1 col=1
    sel z=log10($name)
    plot2d levels=100 xmax=0.25
}


#halo angle test
implant arsenic dose=1.0e13 energy=65 tilt=0
sel z=Arsenic name=Halo0
sel z=1.0e10 name=Arsenic
p2d Halo0

implant arsenic dose=1.0e13 energy=65 tilt=15
sel z=Arsenic name=Halo15
sel z=1.0e10 name=Arsenic
p2d Halo15

implant arsenic dose=1.0e13 energy=65 tilt=30
sel z=Arsenic name=Halo30
sel z=1.0e10 name=Arsenic
p2d Halo30

implant arsenic dose=1.0e13 energy=65 tilt=45
sel z=Arsenic name=Halo45
sel z=1.0e10 name=Arsenic
p2d Halo45

implant arsenic dose=1.0e13 energy=65 tilt=60
sel z=Arsenic name=Halo60
sel z=1.0e10 name=Arsenic
p2d Halo60

p1d "yv=0.20" "xmax=0.25"
p1d "xv=0.03" ""

sel z= Halo0+Halo15+Halo30+Halo45+Halo60
__TestReturn [PCErrorTest val= [integrate] gold= 5.01086e+09]
