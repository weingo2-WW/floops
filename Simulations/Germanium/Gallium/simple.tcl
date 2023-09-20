
# 75/75 nm

options nm
math diffuse dim=1 umf none col scale

solution add name=Gallium solve !negative
solution add name=Vacancies solve !negative

line x loc=-75 spac=0.1 tag=SiTop
line x loc=0   spac=0.1 tag=GeTop
line x loc= 75 spac=0.1 tag=Bottom
region silicon xlo=SiTop xhi=GeTop
region germanium xlo=GeTop xhi=Bottom 
init

# initial Gallium concentration
sel z= 1e18*(x>0) name=Gallium

# initial Vacancy concentration
sel z= 1e18*(x>0)+1e19*(x<=0) name=Vacancies

# Set equations for Germanium
set D 3.688e-17
pdbSet Ge Gallium Equation [ficks $D*(Vacancies/1e18) Gallium]
pdbSet Ge Vacancies Equation [ficks $D Vacancies]

# Set equations for Silicon
set D 3.688e-16
pdbSet Si Gallium Equation [ficks $D*(Vacancies/1e18) Gallium]
pdbSet Si Vacancies Equation [ficks $D Vacancies]

# interface BCs
pdbSet Germanium_Silicon Gallium Fixed 0
pdbSet Germanium_Silicon Gallium Silicon Equation "Gallium(Silicon)-Gallium(Germanium)"
pdbSet Germanium_Silicon Gallium Germanium Equation "Gallium(Germanium)-Gallium(Silicon)"

window row=1 col=2 width= 500 height= 500

sel z=log10(Gallium+1e14)
plot1d graph= Gallium name= Initial ylab= "Concentration log10(cm#u-3#d)"  title= "Gallium"
sel z=log10(Vacancies+1e14)
plot1d graph= Vacancies name= Initial ylab= "Concentration log10(cm#u-3#d)"  title= "Vacancies"

# diffuse for 3 min
diffuse time= [expr 60*3]

sel z=log10(Gallium+1e14)
plot1d graph= Gallium name= 3min 
sel z=log10(Vacancies+1e14)
plot1d graph= Vacancies name= 3min


