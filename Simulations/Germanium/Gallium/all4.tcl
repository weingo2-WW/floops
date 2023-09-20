
# 75/75 nm

options nm
math diffuse dim=1 umf none col scale

solution add continuous name=Silicon solve !negative
solution add continuous name=Germanium solve !negative
solution add continuous name=Gallium solve !negative
solution add continuous name=Vacancies solve !negative

line x loc=-75 spac=0.1 tag=SiTop
line x loc=0   spac=0.1 tag=GeTop
line x loc= 75 spac=0.1 tag=Bottom
region silicon xlo=SiTop xhi=GeTop
region germanium xlo=GeTop xhi=Bottom 
init

# "Concentration" of Si in Si
set Na 6.022e23 ;# number/mol
set Si_atomic_mass  28.09 ;# g/mol
set Si_density  2.329 ;# g/cm^3
sel z= $Na/$Si_atomic_mass*$Si_density*(x<0) name=Silicon

# "Concentration" of Ge in Si
set Ge_atomic_mass  72.64 ;# g/mol
set Ge_density  5.323 ;# g/cm^3
sel z= $Na/$Ge_atomic_mass*$Ge_density*(x>0) name=Germanium

# initial Gallium concentration
sel z= 1e18*(x>0) name=Gallium

# initial Vacancy concentration
sel z= 1e18*(x>0)+1e19*(x<=0) name=Vacancies

# Set equations for Germanium
set D 3.688e-17
pdbSet Ge Germanium Equation [ficks $D Germanium]
pdbSet Ge Gallium Equation [ficks $D*(Vacancies/1e18) Gallium]
pdbSet Ge Silicon Equation [ficks $D*(Vacancies/1e18) Silicon]
pdbSet Ge Vacancies Equation [ficks $D Vacancies]

# Set equations for Silicon
set D 3.688e-16
# pdbSet Ge Germanium Equation [ficks $D Germanium]
pdbSet Si Gallium Equation [ficks $D*(Vacancies/1e18) Gallium]
pdbSet Si Silicon Equation [ficks $D*(Vacancies/1e18) Silicon]
pdbSet Si Vacancies Equation [ficks $D Vacancies]

window row=2 col=2 width= 500 height= 500

sel z=log10(Silicon+1e14)
plot1d graph= Silicon name= Initial ylab= "Concentration log10(cm#u-3#d)"  title= "Silicon"
sel z=log10(Germanium+1e14)
plot1d graph= Germanium name= Initial ylab= "Concentration log10(cm#u-3#d)"  title= "Germanium"
sel z=log10(Gallium+1e14)
plot1d graph= Gallium name= Initial ylab= "Concentration log10(cm#u-3#d)"  title= "Gallium"
sel z=log10(Vacancies+1e14)
plot1d graph= Vacancies name= Initial ylab= "Concentration log10(cm#u-3#d)"  title= "Vacancies"

# diffuse for 3 min
diffuse time= [expr 60*3]

sel z=log10(Silicon+1e14)
plot1d graph= Silicon name= 3min 
sel z=log10(Germanium+1e14)
plot1d graph= Germanium name= 3min 
sel z=log10(Gallium+1e14)
plot1d graph= Gallium name= 3min 
sel z=log10(Vacancies+1e14)
plot1d graph= Vacancies name= 3min


