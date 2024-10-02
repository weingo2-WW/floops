##########################################################################
#
#  This script is an example of etching a material using chemical 
#  mechanical polishing physics.
#  *no masks are supported with this command
#  
##########################################################################

#---------------Definitions------------------------------------------------

#choose the units (nm, um, cm). The default is um.
options um

pdbSet LevelSet debug setSeeds 1

#--------------Define the 2d grid of base materials------------------------
#horizontal lines going top to bottom
line x loc=0.000 spac=0.010    tag=T1
line x loc=0.100 spac=0.010    tag=T2


#vertical lines going left to right
line y loc=0.000 spac=0.010     tag=S1
line y loc=0.600 spac=0.010     tag=S2


#--------------Define the material regions in the 2d grid------------------
#lo is top or right, hi is bottom or left
region metal     xlo=T1  xhi=T2  ylo=S1  yhi=S2

init

#deposit an insulator on top
deposit oxide rate=0.1 time=1

#etch a contact hole
mask negative name=hole left=0.25 right=0.35
etch aniso mask=hole time=1.2 rate=0.1 oxide

#define the plot window, then plot with the gas region
window row=1 col=1 width=600 height=600
plot2d grid gas graph=etch

#fill the hole
deposit metal rate=0.1 time=1
plot2d grid gas graph=etch

#--------------Run the cmp etch command and plot--------------------------------
#polishing mat3
etch metal cmp rate=0.1 time=1.2 debug=etch internal
plot2d grid gas graph=etch

# struct outfile=backend.tcl.gold.str
__TestReturn [CompareStruct filename=backend.tcl.gold.str]
