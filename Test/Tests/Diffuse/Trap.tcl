math diffuse dim=1 umf none col scale

solution add name=Imp solve !negative

line x loc=-0.1 spac=0.01 tag=Ox
line x loc=0.0 spac=0.001 tag=Top
line x loc=0.7 spac=0.001 
line x loc=1.0 spac=0.01 tag=Bottom
region silicon xlo=Top xhi=Bottom 
region oxide xlo=Ox xhi=Top
init

window row=1 col=2

sel z=1.0e10+1.0e19*exp(-(x-0.4)*(x-0.4)/0.001) name=Imp
sel z=log10(Imp)
plot1d graph=Conc name=AsGrown

sel z=Imp
puts [layers]

pdbSetString Si Imp Equation "ddt(Imp)-6.42e-14*grad(Imp)"
pdbSetString Oxide Imp Equation "ddt(Imp)-6.42e-14*grad(Imp)"

pdbSetString Oxide_Silicon Imp Equation "ddt(Imp) - 6.42e-14*3.0e-8*(1.0e14-Imp)*Imp(Silicon)"
pdbSetString Oxide_Silicon Imp Silicon Equation "6.42e-14*3.0e-8*(1.0e14-Imp)*Imp(Silicon)"
pdbSetString Oxide_Silicon Imp Oxide Equation "-3.0e-6*(Imp)"

diffuse time=180.0 temp=1100 movie = {
    sel z=Time
    set t [interface oxide /silicon val]
    sel z=Imp
    set v [interface oxide /silicon val]
    puts "Interface Trapped Charge $t $v"
    chart graph=Win curve=Trap xval=$t yval=$v
}

sel z=log10(Imp+1.0)
plot1d graph=Conc name=Final
sel z=Imp
puts [layers]

sel z= Imp
set val [integrate]
set gold 4.05e13
__TestReturn [PCErrorTest val= $val gold= $gold]
