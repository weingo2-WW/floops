proc FindDose {} {
    set s Silicon
    set ll [layers ]
    set ret 0.0
    foreach line $ll {
        set dose [lindex $line 2]
        set mat [lindex $line 3]
        if {$mat == $s} {
            if {$dose > 0.0} {set ret [expr $ret + $dose]}
        }
    }
    return $ret
}

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

# Regions
region Oxide   xlo=TopOx xhi=TopSi  
region Silicon xlo=TopSi xhi=Bottom 
init 

window row=1 col=1

#halo angle test
implant arsenic dose=1.0e13 energy=65 tilt=15
sel z=Arsenic name=Tilt15
sel z=1.0e10 name=Arsenic
sel z=log10(Tilt15)
plot1d name=Tilt15 xmax=0.25
sel z=Tilt15
set Dose15 [FindDose ]

implant arsenic dose=1.0e13 energy=65 tilt=30 
sel z=Arsenic name=Tilt30
sel z=1.0e10 name=Arsenic
sel z=log10(Tilt30)
plot1d name=Tilt30 xmax=0.25
sel z=Tilt30
set Dose30 [FindDose ]

implant arsenic dose=1.0e13 energy=65 tilt=45
sel z=Arsenic name=Tilt445
sel z=1.0e10 name=Arsenic
sel z=log10(Tilt445)
plot1d name=Tilt445 xmax=0.25
sel z=Tilt445
set Dose45 [FindDose ]

implant arsenic dose=1.0e13 energy=65 tilt=60 
sel z=Arsenic name=Tilt60
sel z=1.0e10 name=Arsenic
sel z=log10(Tilt60)
plot1d name=Tilt60 xmax=0.25
sel z=Tilt60
set Dose60 [FindDose ]

implant arsenic dose=1.0e13 energy=65 
sel z=Arsenic name=Tilt0
sel z=1.0e10 name=Arsenic
sel z=log10(Tilt0)
plot1d name=Tilt0 xmax=0.25
sel z=Tilt0
set Dose0 [FindDose]

puts "Final Doses in each tilt"
puts "$Dose0 $Dose15 $Dose30 $Dose45 $Dose60"
# 10011200000000.0 9669380000000.0 8667090000000.0 7072650000000.0 4996900000000.0
__TestReturn [expr [PCErrorTest val= $Dose0  gold= 10011200000000.0] && [PCErrorTest val= $Dose15  gold=  9669380000000.0 ] && [PCErrorTest val= $Dose30 gold=  8667090000000.0  ] && [PCErrorTest val=  $Dose45 gold= 7072650000000.0 ] && [PCErrorTest val=  $Dose60 gold= 4996900000000.0]]
