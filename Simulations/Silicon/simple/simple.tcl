options nm
math diffuse dim=1 umf none col scale

solution add name=Phosphorus solve !negative

line x loc=0.0 spac=0.01 tag=Top
line x loc=40.0 spac=0.01 tag=Bottom
region silicon xlo=Top xhi=Bottom 
init

# sel z=1.0e19*exp(-(x-5)*(x-5)/0.002)+1.0e10 name=Phosphorus
# set fil [open "tmp.txt" "w"]
# puts $fil [print1d]
# close $fil
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
LoadField data/Initial_As_Grown.txt Phosphorus 1+8.37
LoadField data/DD_600C_20s.txt DD_600C_20s 1+3.96
LoadField data/DD_700C_20s.txt DD_700C_20s 1
LoadField data/DD_800C_20s.txt DD_800C_20s 1+0.44


window row=1 col=2
sel z=log10(Phosphorus)
set Initial_as_Grown_peak [lindex [peak Silicon] 3]
plot1d graph=Doping name=Initial_as_Grown
set T 1373.0
set T 1080
pdbSet Si Phosphorus Equation [ficks [arr 0.743 3.56 $T] Phosphorus]
pdbSet Si Phosphorus Equation [ficks [arr 0.743 3.56 $T]*Phosphorus/1e19 Phosphorus]

diffuse time=20 movie = {
    sel z=log10(Phosphorus)
    plot1d graph=Doping name=Initial_as_Grown
    sel z=Time
    set t [interpolate silicon x.val=0.1]
    sel z=Phosphorus-1.0e16
    set v [interpolate silicon val=0.0] 
    chart graph=junc curve=Junction xval=$t yval=$v title= "Junction Depth" ylab = "Depth (um)" xlab = "Time (s)"
}


sel z = Phosphorus-1.0e16
puts [interpolate silicon val=0.0]

sel z=log10(DD_600C_20s)
set DD_600C_20s_peak [lindex [peak Silicon] 3]
plot1d graph=Doping name=DD_600C_20s
sel z=log10(DD_700C_20s)
set DD_700C_20s_peak [lindex [peak Silicon] 3]
plot1d graph=Doping name=DD_700C_20s
sel z=log10(DD_800C_20s)
set DD_800C_20s_peak [lindex [peak Silicon] 3]
plot1d graph=Doping name=DD_800C_20s
puts [peak Silicon]

puts [expr $Initial_as_Grown_peak]
puts [expr 1e7*($Initial_as_Grown_peak-$DD_700C_20s_peak)]
puts [expr 1e7*($DD_600C_20s_peak-$DD_700C_20s_peak)]
puts [expr 1e7*($DD_800C_20s_peak-$DD_700C_20s_peak)]
