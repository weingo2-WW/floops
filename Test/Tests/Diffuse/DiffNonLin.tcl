math diffuse dim=1 umf none col scale

solution add name=Test ifpresent=Test !negative

window row=1 col=1

proc Diff {diffexp Name} {
    line x loc=0.0 spac=0.001 tag=Top
    line x loc=0.7 spac=0.001 
    line x loc=1.0 spac=0.01 tag=Bottom
    region silicon xlo=Top xhi=Bottom 
    init

    sel z=1.0e20*exp(-x*x/0.002)+1.0e10 name=Test
    sel z=log10(Test)
    plot1d graph=Doping name=AsImp
    pdbSetString Si Test Equation "ddt(Test) - ($diffexp) * grad(Test)"

    diffuse time=10 temp=1100 movie = {
	sel z=log10(Test)
	plot1d graph=Doping name=$Name
    }
}

set d [expr 0.743*exp(-3.56/(8.62e-5*1373.0))]

# Diff $d Const

Diff "$d * Test / 1.0e19" Conc
sel z=log10(Test)
set val [interpolate silicon val=16]
puts $val
__TestReturn [PCErrorTest val= $val gold= 2.498466e-01]
