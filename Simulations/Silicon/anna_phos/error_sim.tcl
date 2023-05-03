set D [lindex $argv 0 0]

options nm quiet
math diffuse dim=1 umf none col scale
solution add name=Phosphorus solve !negative

struct infile= data/grid_small.str
sel z= AsGrown name= Phosphorus

pdbSet Si Phosphorus Equation [ficks $D Phosphorus]

diffuse time= [expr 60*3] 
sel z=(log10(Phosphorus)-log10(3min))^2*(log10(3min)>17.5)
set L2 [expr [lindex [layers] 1 2] * 1e9]

diffuse time= [expr 60*3]
sel z=(log10(Phosphorus)-log10(6min))^2*(log10(6min)>17.5)
set L2 [expr $L2 + [lindex [layers] 1 2] * 1e9]

diffuse time= [expr 60*4]
sel z=(log10(Phosphorus)-log10(10min))^2*(log10(10min)>17.5)
set L2 [expr $L2 + [lindex [layers] 1 2] * 1e9]

diffuse time= [expr 60*5]
sel z=(log10(Phosphorus)-log10(15min))^2*(log10(15min)>17.5)
set L2 [expr $L2 + [lindex [layers] 1 2] * 1e9]
puts $L2
