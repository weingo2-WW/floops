options um
math diffuse dim=1 umf none col scale

solution add name=Boron solve !negative

line x loc=0.0 spac=0.01 tag=Top
line x loc=3.0 spac=0.01 tag=Bottom
region silicon xlo=Top xhi=Bottom 
init

window row=1 col=1
implant Boron dose= 5e15 energy= 1000
sel z= log10(Boron)
plot1d graph=Doping name=Boron
set T 1373.0
pdbSet Si Boron Equation [ficks [arr 0.743 3.56 $T] Boron]

# Temperature is in Kelvin or Celcius
# Temperature is used to compute ramp and cool rates
# Start and final temp are assumed to be the same
set ramp 100 ;# ramp rate in C/s or K/s
set cool 50 ;# ramp rate in C/s or K/s
rta start.temp= 300 dwell.temp= $T dwell.time= 10 ramp= $ramp cool= $cool

sel z= log10(Boron)
plot1d graph=Doping name=Boron_rta

