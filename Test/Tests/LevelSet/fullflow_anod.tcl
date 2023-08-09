##########################################################################
#
#  This script simulates a series of processes that model the MITLL JJ.
#  * the anodization step is absent since there is an existing bug with mesh 
#    generation after the level set process is complete.
#  * The mesh and material boundaries are exported to a file for subsequent reading
#    by a 3d meshing tool (e.g., Katana/InductEx and Gmsh).
#  
##########################################################################

#---------------Definitions------------------------------------------------

#choose the units (nm, um, cm). The default is um.
options um
DevicePackage

#pdbSetBoolean LevelSet gmshParams DebugMesh 1  

#Define materials (gas is created by default)
mater add name=oxide green
mater add name=alum grey
mater add name=Niobium blue
mater name=Niobium alias=niob
mater name=Niobium alias=Nb

#--------------Define the 2d grid of base materials------------------------
#grid spacing set to 0.02 microns
set gridspac 0.02

line x loc=-0.200   spac=$gridspac    tag=T2
line x loc=0.400    spac=$gridspac    tag=T3
line x loc=0.600    spac=$gridspac    tag=T4
line x loc=0.800    spac=$gridspac    tag=T5
line x loc=1.000    spac=$gridspac    tag=T6

line y loc=-0.75 spac=$gridspac     tag=S1
line y loc= 0.75 spac=$gridspac     tag=S2

#--------------Define the material regions in the 2d grid------------------
#lo is top or right, hi is bottom or left
#define regions
region gas      xlo=T2  xhi=T3  ylo=S1  yhi=S2
region niob     xlo=T3  xhi=T4  ylo=S1  yhi=S2
region oxide    xlo=T4  xhi=T5  ylo=S1  yhi=S2
region niob     xlo=T5  xhi=T6  ylo=S1  yhi=S2

#--------------Create the mesh grid and visualize-------------------------------
#create
init

window row=1 col=1 width=500 height=500
plot2d grid gas xlab= "" ylab= ""

#--------------Define the mask edges----------------------------------------
#only a single window is allowed in a single command

#define mask for counter electrode etch
mask name=CEmask     left=-0.25  right=0.250

#define mask for contact
mask name=contact    left=-0.45  right=0.450 negative

#----------------Process steps begin-----------------------------------------
# deposition of aluminum; user defined rate (um/min) and time (min)
sputter alum time=0.3 rate=0.1
plot2d grid gas

#oxidation of aluminum to form the barrier following Eley-Wilkinson physics; user defined time (min) only, rate is hard-coded to MITLL process value
oxidize spac=5e-2 time=1.0
plot2d grid gas

#deposit counter electrode; user defined rate (um/min) and time (min)
sputter spac=2e-2 niob time=2.0 MD=1 targetHeight=1 targetDiameter=1
plot2d grid gas

#pattern the counter electrode; user defined rate (um/min) and time (min) and mask
etch niob mask=CEmask time=1.3 aniso rate=0.2 spacing=0.0025
plot2d grid gas
# define the solution variable in the Laplace equation
solution add name=DevPsi level
# define the Laplace equation coupled to the levelset domains using Alagator scripting
set eps         [expr 8.85418e-12]
set eqnPsi "(1e8*$eps*grad(DevPsi))*(LevelOxide>=0) \
+ (10*$eps*grad(DevPsi))*(LevelOxide<=0)*(LevelMetal>=0) \
+ (1e8*$eps*grad(DevPsi))*(LevelMetal<=0)"
# pass the equation into FLOOSS
pdbSetString Level DevPsi Equation $eqnPsi
anodize time=0.01 niob
plot2d grid gas

#deposit oxide; user defined rate (um/min) and time (min)
deposit spac=2e-2 oxide time=4.5 rate=0.1 spacing=0.01
plot2d grid gas

#flatten the oxide for contact; user defined rate (um/min) and time (min)
pdbSet LevelSet cmp sd 0
etch spac=2e-2 oxide cmp time=4.3 rate=0.1 spacing=0.01
plot2d grid gas
# compute statistics on the roughness

#deposit oxide; user defined rate (um/min) and time (min)
deposit spac=2e-2 oxide time=1.0 rate=0.1 spacing=0.01
plot2d grid

#pattern the oxide for contact; user defined rate (um/min) and time (min) and mask
pdbSet LevelSet mesh num 500
machine etch aniso oxide name= ox_etch rate=0.2
machine etch iso   oxide name= ox_etch rate=0.02
machine etch aniso NiobiumOxide name= ox_etch rate=0.2
machine etch iso   NiobiumOxide name= ox_etch rate=0.02
etch oxide machine_name= ox_etch mask=contact time=0.75 spacing=0.005 
plot2d grid gas

#sputter deposit contact; user defined rate (um/min) and time (min), 
sputter spac=2e-2 niob time=2.0 
plot2d clear
plot2d grid gas 


# struct outfile=fullflow_anod.tcl.gold.str
__TestReturn [CompareStruct filename=fullflow_anod.tcl.gold.str]

