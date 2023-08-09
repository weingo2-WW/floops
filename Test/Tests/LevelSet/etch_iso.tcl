##########################################################################
#
#  This script runs an example of etching of a material
#  through a physical barrier made via the region command.
#  *uses the isotropic parameter in etch command
#  
##########################################################################

#---------------Definitions------------------------------------------------

#choose the units (nm, um, cm). The default is um.
options um

pdbSetBoolean LevelSet gmshParams DebugMesh 0 

#Define materials (gas is created by default)
mater add name=mat1 blue
mater add name=mat2 green
mater add name=mat3 yellow

#--------------Define the 2d grid of base materials------------------------
#horizontal lines going top to bottom
line x loc=0.000 spac=0.020    tag=T1
line x loc=0.100 spac=0.020    tag=T2
line x loc=0.300 spac=0.020    tag=T3
line x loc=0.800 spac=0.020    tag=T4
line x loc=1.000 spac=0.020    tag=T5

#vertical lines going left to right
line y loc=0.000 spac=0.020     tag=S1
line y loc=0.200 spac=0.020     tag=S2
line y loc=0.400 spac=0.020     tag=S3
line y loc=0.600 spac=0.020     tag=S4
line y loc=0.800 spac=0.020     tag=S5
line y loc=1.000 spac=0.020     tag=S6

#--------------Define the material regions in the 2d grid------------------
#lo is top or right, hi is bottom or left
region gas       xlo=T1  xhi=T2  ylo=S1  yhi=S6
region gas       xlo=T2  xhi=T3  ylo=S3  yhi=S4
region mat1      xlo=T2  xhi=T3  ylo=S1  yhi=S3
region mat1      xlo=T2  xhi=T3  ylo=S4  yhi=S6
region mat2      xlo=T3  xhi=T4  ylo=S1  yhi=S6
region mat3      xlo=T4  xhi=T5  ylo=S1  yhi=S6


#--------------Create the grid and visualize-------------------------------
#create
init
#define the plot window, then plot with the gas region
window row=1 col=1 width=600 height=600
plot2d grid gas 


#--------------Run the etch command and plot--------------------------------
#isotropic etch, only interesting with a physical mask made by mat1
machine iso mat2 rate= 0.2 name= m1
machine iso mat1 rate= 0.005 name= m1
etch mat2 machine_name= m1 time=0.5
plot2d clear
plot2d grid gas 




gets stdin
