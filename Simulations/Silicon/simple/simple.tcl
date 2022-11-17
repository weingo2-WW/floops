options nm
math diffuse dim=1 umf none col scale

solution add name=Test solve !negative

line x loc=0.0 spac=0.001 tag=Top
line x loc=10.0 spac=0.001 tag=Bottom
region silicon xlo=Top xhi=Bottom 
init

# sel z=1.0e19*exp(-(x-5)*(x-5)/0.002)+1.0e10 name=Test
# set fil [open "tmp.txt" "w"]
# puts $fil [print1d]
# close $fil
profile infile= tmp.txt name= Test linear

window row=1 col=2
sel z=log10(Test)
plot1d graph=Doping name=AsImp
set T 1373.0
set T 980
pdbSet Si Test Equation [ficks [arr 0.743 3.56 $T] Test]

diffuse time=30 movie = {
    sel z=log10(Test)
    plot1d graph=Doping name=Diff
    sel z=Time
    set t [interpolate silicon x.val=0.1]
    sel z=Test-1.0e16
    set v [interpolate silicon val=0.0] 
    chart graph=junc curve=Junction xval=$t yval=$v title= "Junction Depth" ylab = "Depth (um)" xlab = "Time (s)"
}


sel z=Test
puts [layers]

sel z = Test-1.0e16
puts [interpolate silicon val=0.0]

