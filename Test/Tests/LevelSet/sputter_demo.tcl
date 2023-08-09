pdbSetBoolean LevelSet gmsh 0
##########################################################################
#
#  This script is an example of sputter deposition of a material
#  1) over a step feature, or 2) over a pit feature. 
#  * the user may choose, 2D or 2D axisymmetric (cylindrical symmetry)
#  Note: the feature must be centered in the grid for 2D axisymetric.
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
line x loc=-0.100 spac=0.010    tag=T0
line x loc=0.000 spac=0.010    tag=T1
line x loc=0.100 spac=0.010    tag=T2
line x loc=0.400 spac=0.010    tag=T3

#vertical lines going left to right
line y loc=0.000 spac=0.010     tag=S1
line y loc=0.200 spac=0.010     tag=mid1
line y loc=0.300 spac=0.010     tag=mid2
line y loc=0.500 spac=0.010     tag=S2

#--------------Define the material regions in the 2d grid------------------
#lo is top or right, hi is bottom or left

#choose either region profile by setting if statement true or false, 1 or 0

# define a step to deposit over
if {1} {
region gas         xlo=T0  xhi=T1  ylo=S1  yhi=S2
region gas         xlo=T1  xhi=T2  ylo=S1  yhi=mid1
region gas         xlo=T1  xhi=T2  ylo=mid2  yhi=S2
region mat1        xlo=T1  xhi=T2  ylo=mid1  yhi=mid2
region mat2        xlo=T2  xhi=T3  ylo=S1  yhi=S2
}

#define a pit to fill
if {0} {
region gas         xlo=T0  xhi=T1  ylo=S1  yhi=S2
region gas         xlo=T1  xhi=T2  ylo=mid1  yhi=mid2
region mat1        xlo=T1  xhi=T2  ylo=S1  yhi=mid1
region mat1        xlo=T1  xhi=T2  ylo=mid2  yhi=S2
region mat2        xlo=T2  xhi=T3  ylo=S1  yhi=S2
}

#--------------Create the grid and visualize-------------------------------
#create
init
#define the plot window, then plot with the gas region
window row=1 col=1 width=600 height=600
plot2d clear
plot2d grid gas xmin= -0.1



#--------------Run the sputter command and plot--------------------------------
#sputter deposition option: rate (um/min) time (min), targetHeight (cm) defaults to 1,
# targetDiameter (cm) defaults to 1, 
# MD=0 or 1 (default 1), uses either a molecular dynamics-based or cosine-based distribution of ejected atoms 

# choose one the of the procedures to run by making the if statements true or false 
# (2D) assumes that the direction orthogonal to the 2D surface is infinite
# (2D axisymmetric) assumes that half of the structure is rotated about the origin. 

#2D 
if {0} {
sputter mat3 rate=0.12 time=0.5 targetHeight=1 targetDiameter=1 MD=0
plot2d clear
plot2d grid gas 
}

#2D axisymmetric
if {1} {
sputter mat3 rate=0.12 time=0.5 targetHeight=1 targetDiameter=1 3D
plot2d clear
plot2d grid gas
sputter mat3 rate=0.12 time=0.5
plot2d clear
plot2d grid gas
sputter mat3 rate=0.12 time=0.5
plot2d clear
plot2d grid gas
}





gets stdin
