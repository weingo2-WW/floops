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
region Oxide   xlo=TopOx xhi=TopSi  ylo=Left yhi=Right
region Silicon xlo=TopSi xhi=Bottom ylo=Left yhi=Right
init 

window row=1 col=1 

#halo angle test
implant arsenic dose=1.0e13 energy=65 tilt=30
sel z=Arsenic name=Halo2D0
sel z=1.0e10 name=Arsenic
sel z=log10(Halo2D0)
plot1d name=Halo2D0 yv=0.0 xmax=0.25
sel z=Halo2D0
set Dose2D0 [FindDose2D 0.0 ]

implant arsenic dose=1.0e13 energy=65 tilt=30 rot=90
sel z=Arsenic name=Halo2D90
sel z=1.0e10 name=Arsenic
sel z=log10(Halo2D90)
plot1d name=Halo2D90 yv=0.0 xmax=0.25
sel z=Halo2D90
set Dose2D90 [FindDose2D 0.0 ]

implant arsenic dose=1.0e13 energy=65 tilt=30 rot=180
sel z=Arsenic name=Halo2D180
sel z=1.0e10 name=Arsenic
sel z=log10(Halo2D180)
plot1d name=Halo2D180 yv=0.0 xmax=0.25
sel z=Halo2D180
set Dose2D180 [FindDose2D 0.0 ]

implant arsenic dose=1.0e13 energy=65 tilt=30 rot=270
sel z=Arsenic name=Halo2D270
sel z=1.0e10 name=Arsenic
sel z=log10(Halo2D270)
plot1d name=Halo2D270 yv=0.0 xmax=0.25
sel z=Halo2D270
set Dose2D270 [FindDose2D 0.0 ]

# Horizontal lines
line x loc= $OxThick spac=0.002  tag=TopOx
line x loc=0.00 spac=0.0002   tag=TopSi
line x loc=0.04 spac=0.0002
line x loc=0.25 spac=0.02
line x loc=3.00 spac=0.1   tag=Bottom

# Regions
region Oxide   xlo=TopOx xhi=TopSi  
region Silicon xlo=TopSi xhi=Bottom 
init 

implant arsenic dose=1.0e13 energy=65 tilt=30 rot=270
sel z=log10(Arsenic)
plot1d name=Halo1D xmax=0.25
sel z=Arsenic
set Dose1D [FindDose1D]

puts "Final Doses in 1D and then each rotation"
puts "$Dose1D $Dose2D0 $Dose2D90 $Dose2D180 $Dose2D270"
puts "gold 9955810000000.0 9947460000000.0 9955810000000.0 9947460000000.0 9955810000000.0"

__TestReturn [expr [PCErrorTest val= $Dose1D gold= 9955810000000.0] && [PCErrorTest val= $Dose2D0 gold= 9947460000000.0] && [PCErrorTest val= $Dose2D90 gold= 9955810000000.0] && [PCErrorTest val= $Dose2D180 gold= 9947460000000.0] && [PCErrorTest val= $Dose2D270 gold= 9955810000000.0]]
