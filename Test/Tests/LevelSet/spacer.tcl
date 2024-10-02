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

#choose LevelSet meshing program: Gmsh is used if  Boolean=1. Tri is used if Boolean=0. The default is Tri.
pdbSetBoolean LevelSet gmsh 1


#--------------Define the 2d grid of base materials------------------------
#horizontal lines going top to bottom
line x loc=0.000 spac=0.010    tag=T2
line x loc=0.400 spac=0.50    tag=T3

#vertical lines going left to right
line y loc=-0.50 spac=0.010     tag=S1
line y loc=0.50 spac=0.010     tag=S2

#--------------Define the material regions in the 2d grid------------------
#lo is top or right, hi is bottom or left
region silicon        xlo=T2  xhi=T3  ylo=S1  yhi=S2

#--------------Create the grid and visulaize-------------------------------
#create
init

mask name=PosMask positive left=0.150  right=0.250 thick=0.05
mask name=PosMask positive left=-0.250  right=-0.150 thick=0.05

window row=1 col=2 width=600 height=600

deposit oxide rate=0.005 time=1
Smooth oxide
deposit poly rate=0.075 time=1
Smooth poly

#define the plot window, then plot with the gas region
plot2d grid graph=PosMask title=PosMask xmax=0.1

#--------------Run the etch command and plot--------------------------------
etch poly aniso mask=PosMask rate=0.075 time=1.3 spac=0.005
plot2d grid title=PosMask graph=PosMask xmin=-0.2 xmax=0.1

deposit oxide rate=0.05 time=1.0
plot2d grid title=Spacer graph=Spacer

etch oxide aniso rate=0.05 time=1.2 
plot2d grid title=Spacer graph=Spacer



# struct outfile=spacer.tcl.gold.str
__TestReturn [CompareStruct filename=spacer.tcl.gold.str]
