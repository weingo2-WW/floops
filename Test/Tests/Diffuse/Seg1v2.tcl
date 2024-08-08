proc FindDose2D { inp loc } {
    set ll [layers y=$loc]
    set ret 0.0
    foreach line $ll {
        set dose [lindex $line 2]
        set mat [lindex $line 3]
        if {$mat == $inp} {
            if {$dose > 0.0} {set ret [expr $ret + $dose]}
        }
    }
    return $ret
}

math diffuse dim=1 umf none col scal2

pdbSetString Si Imp Equation "ddt(Imp)-6.42e-14*grad(Imp)"
pdbSetString Oxide Imp Equation "ddt(Imp)-6.42e-14*grad(Imp)"

pdbSetString Oxide_Silicon Imp Oxide Equation "3.0*(Imp(Oxide)/4.0-Imp(Silicon))"
pdbSetString Oxide_Silicon Imp Silicon Equation "-3.0*(Imp(Oxide)/4.0-Imp(Silicon))"
solution add name=Imp solve !negative

window row=1 col=2
#put some limits in place
chart graph=Dose curve=Lim xv=0.0 yv=5.5e13
chart graph=Dose curve=Lim xv=0.0 yv=5.7e13

proc Sim2D { cylin } {
    line x loc=-0.1 spac=0.001 tag=Ox
    line x loc=0.0 spac=0.001 tag=Top
    line x loc=0.7 spac=0.001 
    line x loc=1.0 spac=0.01 tag=Bottom
    line y loc=0.0 spac=1.0 tag=Left
    line y loc=1.0 spac=1.0 tag=Right
    region silicon xlo=Top xhi=Bottom ylo=Left yhi=Right
    region oxide xlo=Ox xhi=Top ylo=Left yhi=Right
    init $cylin 

    sel z=1.0e10+1.0e19*exp(-(x-0.4)*(x-0.4)/0.001) name=Imp
    sel z=log10(Imp+1.0)
    plot1d yval=0.9 graph=Conc name=Conc9
    sel z=Imp
    puts [layers y=0.9]
    set dose [expr [FindDose2D Silicon 0.9] + [FindDose2D Oxide 0.9]]
    chart graph=Dose curve=2D9 xv=0.0 yv=$dose
    set dose [expr [FindDose2D Silicon 0.1] + [FindDose2D Oxide 0.1]]
    chart graph=Dose curve=2D1 xv=0.0 yv=$dose

    diffuse time=180 temp=1100 init=1.0e-3 movie = {
	sel z=log10(Imp+1.0)
	plot1d yval=0.9 graph=Conc name=Conc9
	sel z=Time
	set time [interpolate x.v=0.01 y.v=0.01 silicon]
	sel z=Imp
	set dose [expr [FindDose2D Silicon 0.9] + [FindDose2D Oxide 0.9]]
	chart graph=Dose curve=2D9 xv=$time yv=$dose
	set dose [expr [FindDose2D Silicon 0.1] + [FindDose2D Oxide 0.1]]
	chart graph=Dose curve=2D1 xv=$time yv=$dose
    }

    sel z=log10(Imp+1.0)
    plot1d yval=0.9 graph=Conc name=Conc9
    sel z=Imp
    puts [layers y=0.9]
    set dose [expr [FindDose2D Silicon 0.9] + [FindDose2D Oxide 0.9]]
    chart graph=Dose curve=2D9 xv=$time yv=$dose
    set dose [expr [FindDose2D Silicon 0.1] + [FindDose2D Oxide 0.1]]
    chart graph=Dose curve=2D1 xv=$time yv=$dose
}


proc Sim1D {} {
    line x loc=-0.1 spac=0.001 tag=Ox
    line x loc=0.0 spac=0.001 tag=Top
    line x loc=0.7 spac=0.001 
    line x loc=1.0 spac=0.01 tag=Bottom
    region silicon xlo=Top xhi=Bottom 
    region oxide xlo=Ox xhi=Top 
    init 

    sel z=1.0e10+1.0e19*exp(-(x-0.4)*(x-0.4)/0.001) name=Imp
    sel z=log10(Imp)
    plot1d graph=Conc name=Conc1D
    sel z=Imp
    puts [layers y=0.9]
    set dose [expr [FindDose Silicon] + [FindDose Oxide]]
    chart graph=Dose curve=1D xv=0.0 yv=$dose

    diffuse init=1.0e-3 time=180.0 temp=1100 movie = {
	sel z=log10(Imp+1.0)
	plot1d graph=Conc name=Conc1D
	sel z=Time
	set time [interpolate x.v=0.0001 silicon]
	sel z=Imp
	set dose [expr [FindDose Silicon] + [FindDose Oxide]]
	chart graph=Dose curve=1D xv=$time yv=$dose 
    }

    sel z=log10(Imp+1.0)
    plot1d graph=Conc name=Conc1D
    sel z=Imp
    puts [layers y=0.9]
    set dose [expr [FindDose Silicon] + [FindDose Oxide]]
    chart graph=Dose curve=1D xv=[expr 180.0*60.0] yv=$dose
}

Sim1D

Sim2D ""

sel z= Imp
set val [integrate]
set gold 5.6e9
__TestReturn [PCErrorTest val= $val gold= $gold]
