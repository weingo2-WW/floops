##########################################################################
#
#  This script runs examples of etching a material
#  through virtual masks defined by the user.
#  *uses the anisotropic parameter in the etch command
#  
##########################################################################

#---------------Definitions------------------------------------------------

#choose the units (nm, um, cm). The default is um.
options um


#Define materials (gas is created by default)
mater add name=material1 blue
mater add name=material2 green
pdbSet LevelSet gmshParams DebugMesh 0

#--------------Define the 2d grid of base materials------------------------
#horizontal lines going top to bottom
line x loc=0.000 spac=0.010    tag=T1
line x loc=0.200 spac=0.010    tag=T2
line x loc=0.400 spac=0.010    tag=T3

#vertical lines going left to right
line y loc=0.000 spac=0.010     tag=S1
line y loc=0.500 spac=0.010     tag=S2

#--------------Define the material regions in the 2d grid------------------
#lo is top or right, hi is bottom or left
region material1        xlo=T1  xhi=T2  ylo=S1  yhi=S2
region material2        xlo=T2  xhi=T3  ylo=S1  yhi=S2

#--------------Create the grid and visualize-------------------------------
#create
init

#define the plot window, then plot with the gas region
window row=1 col=1 width=1000 height=1000
plot2d grid gas graph=etch

#--------------Define the mask edges----------------------------------------
#only a single window is allowed in a single command
mask name=mask1 left=0.100  right=0.200 negative
mask name=mask2 negative left=0.300  right=0.400

#--------------Run the etch command and plot--------------------------------


#anisotropic etches with positive and negative masks

#etch through negative mask1, material is removed between mask edges
etch material1 aniso mask=mask2 rate=0.2 time=0.5 internal
plot2d grid gas graph=etch

#etch through positive mask1, material is removed outside of mask edges
etch material1 aniso mask=mask1 rate=0.2 time=0.5 deb=etch internal
plot2d grid gas graph=etch

etch material1 aniso mask=mask1 rate=0.2 time=0.1 deb=etch internal
plot2d grid gas graph=etch

# struct outfile=etch_aniso.tcl.gold.str
__TestReturn [CompareStruct filename=etch_aniso.tcl.gold.str]

