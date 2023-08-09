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


#Define materials (gas is created by default)

mater add name=oxide green
mater add name=alum grey
mater add name=niob blue

#--------------Define the 2d grid of base materials------------------------
#grid spacing set to 0.02 microns
set gridspac 0.02

line x loc=-0.200   spac=$gridspac    tag=T2
line x loc=0.400    spac=$gridspac    tag=T3
line x loc=0.600    spac=$gridspac    tag=T4
line x loc=0.800    spac=$gridspac    tag=T5
line x loc=1.000    spac=$gridspac    tag=T6

line y loc=0.000 spac=$gridspac     tag=S1
line y loc=1.500 spac=$gridspac     tag=S2

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

window row=1 col=1 width=600 height=600
plot2d grid gas

#--------------Define the mask edges----------------------------------------
#only a single window is allowed in a single command

#define mask for counter electrode etch
mask name=CEmask     left=0.500  right=1.000

#define mask for contact
mask name=contact    left=0.300  right=1.200 negative

#----------------Process steps begin-----------------------------------------
# deposition of aluminum; user defined rate (um/min) and time (min)
deposit alum time=0.3 rate=0.1
plot2d grid

#oxidation of aluminum to form the barrier following Eley-Wilkinson physics; user defined time (min) only, rate is hard-coded to MITLL process value
oxidize time=1.0
plot2d grid

#deposit counter electrode; user defined rate (um/min) and time (min)
sputter niob time=2.0 MD=1 targetHeight=1 targetDiameter=1
plot2d grid

#pattern the counter electrode; user defined rate (um/min) and time (min) and mask
etch niob aniso mask=CEmask time=1.1 rate=0.2 spacing=0.01
plot2d grid

#deposit oxide; user defined rate (um/min) and time (min)
deposit oxide time=4.5 rate=0.1 spacing=0.01
plot2d grid

#flatten the oxide for contact; user defined rate (um/min) and time (min)
etch oxide cmp time=4.2 rate=0.1 spacing=0.01
plot2d grid

#deposit oxide; user defined rate (um/min) and time (min)
deposit oxide time=1.0 rate=0.1 spacing=0.01
plot2d grid

#pattern the oxide for contact; user defined rate (um/min) and time (min) and mask
etch oxide aniso mask=contact time=0.6 spacing=0.01 rate=0.3
plot2d grid

#sputter deposit contact; user defined rate (um/min) and time (min), 
#using MD-based sputter distribution and cylindrical symmetry for semi-3D calculation
sputter niob time=1.7 MD=1 targetHeight=1 targetDiameter=2 3D
plot2d clear
plot2d grid gas 

#-------------------Export the Structure for 3D processing--------------------

#output all the nodes and boundaries in the mesh as Gmsh geometries
struct gmsh_geo_write=full-flow.geo

#output only material boundaries as Gmsh geometries
struct gmsh_geo_contour_write=full-flow-bound.geo

gets stdin
