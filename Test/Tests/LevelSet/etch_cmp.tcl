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


#Define materials (gas is created by default)
mater add name=mat1 blue
mater add name=mat2 green
mater add name=mat3 magenta

#--------------Define the 2d grid of base materials------------------------
#horizontal lines going top to bottom
line x loc=0.000 spac=0.010    tag=T1
line x loc=0.100 spac=0.010    tag=T2
line x loc=0.200 spac=0.010    tag=T3
line x loc=0.600 spac=0.010    tag=T4


#vertical lines going left to right
line y loc=0.000 spac=0.010     tag=S1
line y loc=0.200 spac=0.010     tag=S2
line y loc=0.400 spac=0.010     tag=S3
line y loc=0.600 spac=0.010     tag=S4



#--------------Define the material regions in the 2d grid------------------
#lo is top or right, hi is bottom or left
region gas       xlo=T1  xhi=T2  ylo=S1  yhi=S4
region gas       xlo=T2  xhi=T3  ylo=S1  yhi=S2
region gas       xlo=T2  xhi=T3  ylo=S3  yhi=S4
region mat1      xlo=T2  xhi=T3  ylo=S2  yhi=S3
region mat2      xlo=T3  xhi=T4  ylo=S1  yhi=S4


#--------------Create the grid and visualize-------------------------------
#create
init
#define the plot window, then plot with the gas region
window row=1 col=1 width=600 height=600
plot2d grid gas 

#-------------Deposit a material to polish---------------------------------
deposit mat3 rate=0.1 time=1.5 
plot2d grid gas

#--------------Run the cmp etch command and plot--------------------------------
#polishing mat3
etch mat3 cmp rate=0.1 time=1.3 spacing=0.005
plot2d clear
plot2d grid gas

#notes: Many of the mesh bugs that existed previously with this etch step have been corrected,
# when gmsh is used.





