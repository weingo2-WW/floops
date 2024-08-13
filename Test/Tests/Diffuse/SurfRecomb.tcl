pdbSetBoolean LevelSet gmsh 1
pdbSetBoolean LevelSet newGmsh 1
pdbSetBoolean LevelSet gmshParams DebugMesh 0
pdbSetDouble Math iterLimit 15

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

#damage from implants
    sel z=(2.5e13/(3.14*0.01e-4))*exp(-(x-0.05)*(x-0.05)/(2.0*0.01*0.01)) name=Inter

solution name=Temp !negative add const val=600*Time

    set Vt "(8.612e-5*(Temp+273.0))"
    solution name=Inter solve !negative add 
    set cis "(5.0e22*exp(11.2)*exp(-3.7/$Vt))"
    solution name=CIStar add const val = "$cis"
    solution name=TED const silicon val = (Inter/CIStar)
    set Diff "0.138*exp(-1.37/$Vt)"
    pdbSetString Silicon Inter Equation "ddt(Inter) - CIStar * $Diff * grad(Inter/CIStar)"
    #surf diffusion limit - pi * diffusion rate * lattice spacing * kinksite surce density
    set Ksurf "(3.14159 * $Diff * 2.714e-8 * 1.3e15)"
    pdbSetString Oxide_Silicon Inter Silicon Equation "$Ksurf*(Inter(Silicon)-CIStar)"

window row=1 col=2
sel z=log10(Inter+1.0)
plot1d leg.right name=Inter graph=TED log xmin=0.0
rta dwell.temp=1100 dwell.time=5.0 cool=60 ramp=100 start.temp=600 init=1.0e-8 user=0.5 movie= {
    sel z=log10(Inter+1.0)
    plot1d leg.right name=Inter graph=TED log xmin=0.0
    sel z=Temp
    set cur [ interpolate x.v=0.02 silicon ]
    chart graph=Temp curve=Temp xval=$Time yval=$cur xlab = Time(s) 

}

puts $cur
set gold1 600
sel z=Inter
set surf [interpolate x.v=1.0e-9 silicon]
set gold2 2.578800e+06
puts $surf
__TestReturn [expr [PCErrorTest val= $cur gold= $gold1]&&[PCErrorTest val= $surf gold= $gold2]]
