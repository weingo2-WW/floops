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
line y loc=-0.25 spac=0.010     tag=S1
line y loc=-0.05 spac=0.010     tag=mid1
line y loc=0.050 spac=0.010     tag=mid2
line y loc=0.250 spac=0.010     tag=S2

line z loc= 0    spac=0.1     tag=Z1
line z loc= 0.1  spac=0.1     tag=zmid
line z loc= 0.25 spac=0.1     tag=Z2

#--------------Define the material regions in the 2d grid------------------
#lo is top or right, hi is bottom or left

#choose either region profile by setting if statement true or false, 1 or 0

# define a step to deposit over
region gas         xlo=T0  xhi=T1  ylo=S1  yhi=S2 zlo= Z1 zhi= Z2
region gas         xlo=T1  xhi=T2  ylo=mid1  yhi=S2 zlo= Z1 zhi= Z2
region gas         xlo=T1  xhi=T2  ylo=S1  yhi=mid1  zlo= Z1 zhi= zmid
region mat1        xlo=T1  xhi=T2  ylo=S1  yhi=mid1 zlo= zmid zhi= Z2
region mat2        xlo=T2  xhi=T3  ylo=S1  yhi=S2 zlo= Z1 zhi= Z2

#--------------Create the grid and visualize-------------------------------
#create
init 
#define the plot window, then plot with the gas region
window null

deposit silicon rate=0.12 time=0.5 contact= VSS

# struct outfile=dep_contact.tcl.gold.str
__TestReturn [CompareStruct filename=dep_contact.tcl.gold.str]


