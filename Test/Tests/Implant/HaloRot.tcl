source FindDose.tcl

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
line y loc=-0.25 spac=0.015  tag=Left
line y loc= $LeftDrawn spac=0.002 tag=GateLeft
line y loc=0.0 spac=0.002
line y loc= $RightDrawn spac=0.002 tag=GateRight
line y loc=0.25 spac=0.015  tag=Right
    
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
    sel z=log10(Halo30.0+1.0e15)
    plot1d $arg1 $arg2 log name=Halo30
    sel z=log10(Halo30.90+1.0e15)
    plot1d $arg1 $arg2 log name=Halo30.90
    sel z=log10(Halo30.180+1.0e15)
    plot1d $arg1 $arg2 log name=Halo30.180
    sel z=log10(Halo30.270+1.0e15)
    plot1d $arg1 $arg2 log name=Halo30.270
}
proc p2d {name} {
    window row=1 col=1
    sel z=log10($name)
    plot2d levels=100 xmax=0.25
}

implant arsenic dose=1.0e13 energy=65 tilt=30 rot=0.0
sel z=Arsenic name=Halo30.0
set D0 [FindDose2D 0.249]
sel z=1.0e10 name=Arsenic
p2d Halo30.0

implant arsenic dose=1.0e13 energy=65 tilt=30 rot=90.0
sel z=Arsenic name=Halo30.90
set D90 [FindDose2D 0.249]
sel z=1.0e10 name=Arsenic
p2d Halo30.90

implant arsenic dose=1.0e13 energy=65 tilt=30 rot=180.0
sel z=Arsenic name=Halo30.180
set D180 [FindDose2D 0.249]
sel z=1.0e10 name=Arsenic
p2d Halo30.180

implant arsenic dose=1.0e13 energy=65 tilt=30 rot=270.0
sel z=Arsenic name=Halo30.270
set D270 [FindDose2D 0.249]
sel z=1.0e10 name=Arsenic
p2d Halo30.270

p1d "yv=0.20" "xmax=0.25"
p1d "xv=0.03" ""

puts "Doses at 0 90 180 270"
puts "$D0 $D90 $D180 $D270"
puts "gold 9946460000000.0 9955800000000.0 9947460000000.0 9955800000000.0"
__TestReturn [expr [PCErrorTest val= $D0 gold= 9946460000000.0] && [PCErrorTest val= $D90 gold= 9955800000000.0 ] && [PCErrorTest val= $D180 gold= 9947460000000.0 ] && [PCErrorTest val= $D270 gold= 9955800000000.0]]
