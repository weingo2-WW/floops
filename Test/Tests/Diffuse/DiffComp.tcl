
math diffuse dim=1 umf none col scale
solution add name=Test solve !negative
pdbSetString Si Test Equation "ddt(Test)-0.743*exp(-3.56/(8.62e-5*1373.0))*grad(Test)"
options barf

window row=1 col=1 width=600 height=600

proc Diff1D {Name} {
    line x loc=0.0 spac=0.001 tag=Top
    line x loc=0.7 spac=0.001 
    line x loc=1.0 spac=0.01 tag=Bottom
    region silicon xlo=Top xhi=Bottom 
    init

    sel z=1.0e19*exp(-x*x/0.002)+1.0e10 name=Test

    diffuse time=30 temp=1100 movie = {
	sel z=Test-1.0e16
	set xj [interpolate silicon val=0.0]
	puts "The Time is $Time"
	chart curve = $Name leg.left xv = $Time yv = $xj
    }
}


proc Diff2D {Name flag} {
    line x loc=0.0 spac=0.001 tag=Top
    line x loc=0.7 spac=0.001 
    line x loc=1.0 spac=0.01 tag=Bottom

    line y loc=0.0 spac=0.1 tag=left
    line y loc=1.0 spac=0.1 tag=right
    region silicon xlo=Top xhi=Bottom ylo=left yhi=right
    if {$flag} {
        init quad
    } else {
        init
    }

    sel z=1.0e19*exp(-x*x/0.002)+1.0e10 name=Test

    diffuse time=30 temp=1100 movie = {
	sel z=Test-1.0e16
	set xj [interpolate silicon y.v=0.5 val=0.0]
	puts "The Time is $Time"
	chart curve = $Name leg.left xv = $Time yv = $xj
    }
}

proc Diff3D {Name flag} {
    line x loc=0.0 spac=0.001 tag=Top
    line x loc=0.7 spac=0.001 
    line x loc=1.0 spac=0.01 tag=Bottom

    line y loc=0.0 spac=0.1 tag=left
    line y loc=0.5 spac=0.1 tag=right

    line z loc=0.0 spac=0.1 tag=front
    line z loc=0.5 spac=0.1 tag=back
    region silicon xlo=Top xhi=Bottom ylo=left yhi=right zlo=front zhi=back
    if {$flag} {
        init quad
    } else {
        init
    }

    sel z=1.0e19*exp(-x*x/0.002)+1.0e10 name=Test

    diffuse time=30 temp=1100 movie = {
	sel z=Test-1.0e16
	set xj [interpolate silicon y.v=0.5 z.v=0.5 val=0.0]
	puts "The Time is $Time"
	chart curve = $Name leg.left xv = $Time yv = $xj
    }
}


set 1DTime [time {Diff1D 1D}]
sel z=Test-1.0e16
set err [interpolate silicon val=0.0]

set TriTime [time { Diff2D 2DTri 0 }]
sel z=Test-1.0e16
set err [expr $err-[interpolate silicon y.v=0.5 val=0.0]]
set QuaTime [time { Diff2D 2DQuad 1}]
sel z=Test-1.0e16
set err [expr $err+[interpolate silicon y.v=0.5 val=0.0]]

set TetTime [time { Diff3D 3DTet 0}]
sel z=Test-1.0e16
set err [expr $err-2.*[interpolate silicon y.v=0.5 z.v=0.5 val=0.0]]
set BrickTime [time { Diff3D 3DQuad 1}]
sel z=Test-1.0e16
set err [expr $err+[interpolate silicon y.v=0.5 z.v=0.5 val=0.0]]

puts "1D Time $1DTime"
puts "Tri Time $TriTime"
puts "Quad Time $QuaTime"
puts "Tet Time $TetTime"
puts "Brick Time $BrickTime"

__TestReturn [expr abs($err) < 0.001]
