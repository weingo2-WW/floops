options nm
math diffuse dim=1 umf none col scale

solution add name=Phosphorus solve !negative

struct infile= data/grid.str
sel z= AsGrown name= Phosphorus

# window row=1 col=2
window pngcairo file= calibrated.png row=1 col=2
sel z=log10(Phosphorus)
set Initial_as_Grown_peak [lindex [peak Silicon] 3]
plot1d graph=Replicate name=Initial_as_Grown xmax= 200 ylab= "Concentration log10(cm#u-3#d)"  title= "Existing Concentration vs Depth Simulation Fit"
set T [expr 273+900]
set D [arr 0.743 3.80 $T]
set D 3.688e-17
pdbSet Si Phosphorus Equation [ficks $D Phosphorus]

# pdbSet Gas_Silicon Phosphorus Fixed 1
# sel z=Phosphorus
# pdbSet Gas_Silicon Phosphorus Silicon Equation "Phosphorus(Silicon)-[interpolate silicon x.val=35.1] "

if { 0 } {
diffuse time= [expr 60*3] movie = {
    sel z=log10(Phosphorus)
    plot1d graph=Replicate name=Initial_as_Grown
    # sel z=Time
    # set t [interpolate silicon x.val=0.1]
    # sel z=Phosphorus-1.0e16
    # set v [interpolate silicon val=0.0] 
    # chart graph=junc curve=Junction xval=$t yval=$v title= "Junction Depth" ylab = "Depth (um)" xlab = "Time (s)"
}
}
diffuse time= [expr 60*3]
sel z=log10(Phosphorus)
dict set data 3min_sim [print.1d]
plot1d graph=Replicate name=3min_sim
sel z=log10(3min)
dict set data 3min [print.1d]
plot1d graph=Replicate name=3min

diffuse time= [expr 60*3]
sel z=log10(Phosphorus)
dict set data 6min_sim [print.1d]
plot1d graph=Replicate name=6min_sim
sel z=log10(6min)
dict set data 6min [print.1d]
plot1d graph=Replicate name=6min

diffuse time= [expr 60*4]
sel z=log10(Phosphorus)
dict set data 10min_sim [print.1d]
plot1d graph=Replicate name=10min_sim
sel z=log10(10min)
dict set data 10min [print.1d]
plot1d graph=Replicate name=10min

diffuse time= [expr 60*5]
sel z=log10(Phosphorus)
dict set data 15min_sim [print.1d]
plot1d graph=Replicate name=15min_sim
sel z=log10(15min)
dict set data 15min [print.1d]
plot1d graph=Replicate name=15min

sel z=log10(Phosphorus)
plot1d graph=Project name=15min_sim ylab= "Concentration log10(cm#u-3#d)" title= "Projected Concentration vs Depth"
sel z=log10(15min)
plot1d graph=Project name=15min
diffuse time= [expr 60*(50-15)]
sel z=log10(Phosphorus)
dict set data 50min_sim [print.1d]
plot1d graph=Project name=50min_sim

diffuse time= [expr 60*(100-50)]
sel z=log10(Phosphorus)
plot1d graph=Project name=100min_sim
dict set data 100min_sim [print.1d]

diffuse time= [expr 60*(200-100)]
sel z=log10(Phosphorus)
plot1d graph=Project name=200min_sim
dict set data 200min_sim [print.1d]

set fil [open "sim_data/data.dict" "w+"]
puts $fil $data
close $fil

