options nm
math diffuse dim=1 umf none col scale
set A 0.743
set Ea 3.56
set N 1e19 

set A [lindex $argv 0 0]
set Ea [lindex $argv 0 1]
set N [expr 1.*10**([lindex $argv 0 2])]

solution add name=Phosphorus solve !negative

line x loc=0.0 spac=0.01 tag=Top
line x loc=40.0 spac=0.01 tag=Bottom
region silicon xlo=Top xhi=Bottom 
init

proc LoadField { fileName field {offset 0} } {
  set fil [open $fileName "r"]
  set dat [lreplace [split [read $fil] "\n"] 0 0]
  close $fil
  set fil [open tmp.txt "w+"]
  foreach d $dat {
    puts $fil $d
  }
  close $fil
  sel z= 1e18 name= $field
  profile infile= tmp.txt  name= $field linear offset= $offset
  file delete tmp.txt
}
LoadField data/Initial_As_Grown.txt Initial_As_Grown 1+8.37
LoadField data/DD_600C_20s.txt DD_600C_20s 1+3.96
LoadField data/DD_700C_20s.txt DD_700C_20s 1
LoadField data/DD_800C_20s.txt DD_800C_20s 1+0.44

window null row=1 col=2
sel z=Initial_As_Grown name= Phosphorus
sel z=log10(Phosphorus)
set Initial_as_Grown_peak [lindex [peak Silicon] 3]
plot1d graph=Doping name=Initial_as_Grown
set T 600
pdbSet Si Phosphorus Equation [ficks [arr $A $Ea $T] Phosphorus]
pdbSet Si Phosphorus Equation [ficks [arr $A $Ea $T]*Phosphorus/$N Phosphorus]

diffuse time=20 movie = {
    sel z=log10(Phosphorus)
    plot1d graph=Doping name=Initial_as_Grown
    sel z=Time
    set t [interpolate silicon x.val=0.1]
    sel z=Phosphorus-1.0e16
    set v [interpolate silicon val=0.0] 
    chart graph=junc curve=Junction xval=$t yval=$v title= "Junction Depth" ylab = "Depth (um)" xlab = "Time (s)"
}

sel z=log10(Phosphorus)
plot1d graph=Doping name=Initial_as_Grown

sel z= log10(DD_$T\C_20s)
plot1d graph= Doping name= 600C

sel z= (log10(Phosphorus)-log10(DD_$T\C_20s))^2*(log10(DD_$T\C_20s)>19.5)
plot1d graph=Error name= 600C
set L2 [expr [lindex [layers] 1 2] * 1e9]

sel z= log10(Phosphorus)
set p1 [lindex [peak Silicon] 1]
sel z= log10(DD_$T\C_20s)
set p2 [lindex [peak Silicon] 1]
set sup [expr (10*($p2-$p1))**2]

# 700 C run
if { 1 } {
  sel z=Initial_As_Grown name= Phosphorus
  set T 700
  pdbSet Si Phosphorus Equation [ficks [arr $A $Ea $T] Phosphorus]
  pdbSet Si Phosphorus Equation [ficks [arr $A $Ea $T]*Phosphorus/$N Phosphorus]
  
  diffuse time=20 movie = {
      sel z=log10(Phosphorus)
      plot1d graph=Doping name=Initial_as_Grown
      sel z=Time
      set t [interpolate silicon x.val=0.1]
      sel z=Phosphorus-1.0e16
      set v [interpolate silicon val=0.0] 
      chart graph=junc curve=Junction xval=$t yval=$v title= "Junction Depth" ylab = "Depth (um)" xlab = "Time (s)"
  }
  
  
  #sel z= (Phosphorus-DD_$T\C_20s)^2*(log10(DD_$T\C_20s)>19.5)
  sel z= (log10(Phosphorus)-log10(DD_$T\C_20s))^2*(log10(DD_$T\C_20s)>19.5)
  plot1d graph=Error name= 700C
  set L2 [expr $L2 + [lindex [layers] 1 2] * 1e9]
  
  sel z= log10(Phosphorus)
  set p1 [lindex [peak Silicon] 1]
  sel z= log10(DD_$T\C_20s)
  set p2 [lindex [peak Silicon] 1]
  set sup [expr $sup + (10*($p2-$p1))**2]
}

# 800 C run
if { 1 } {
  sel z=Initial_As_Grown name= Phosphorus
  set T 800
  pdbSet Si Phosphorus Equation [ficks [arr $A $Ea $T] Phosphorus]
  pdbSet Si Phosphorus Equation [ficks [arr $A $Ea $T]*Phosphorus/$N Phosphorus]
  
  diffuse time=20 movie = {
      sel z=log10(Phosphorus)
      plot1d graph=Doping name=Initial_as_Grown
      sel z=Time
      set t [interpolate silicon x.val=0.1]
      sel z=Phosphorus-1.0e16
      set v [interpolate silicon val=0.0] 
      chart graph=junc curve=Junction xval=$t yval=$v title= "Junction Depth" ylab = "Depth (um)" xlab = "Time (s)"
  }
  
  
  # sel z= (Phosphorus-DD_$T\C_20s)^2*(log10(DD_$T\C_20s)>19.5)
  sel z= (log10(Phosphorus)-log10(DD_$T\C_20s))^2*(log10(DD_$T\C_20s)>19.5)
  plot1d graph=Error name= 700C
  set L2 [expr $L2 + [lindex [layers] 1 2] * 1e9]
  
  sel z= log10(Phosphorus)
  set p1 [lindex [peak Silicon] 1]
  sel z= log10(DD_$T\C_20s)
  set p2 [lindex [peak Silicon] 1]
  set sup [expr $sup + (10*($p2-$p1))**2]
}

puts [expr $sup+$L2]
