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

# flag to get gmsh debug meshes
pdbSetBoolean LevelSet gmshParams DebugMesh 0  

#Define materials (gas is created by default)
mater add name=Niobium blue
mater add name=Oxide green

#--------------Define the 2d grid of base materials------------------------
#horizontal lines going top to bottom
line x loc=0.000 spac=0.010    tag=T1
line x loc=0.100 spac=0.010    tag=T2
line x loc=0.200 spac=0.010    tag=T3
line x loc=0.400 spac=0.010    tag=T4

#vertical lines going left to right
line y loc=-0.25 spac=0.1     tag=S1
line y loc= 0.25 spac=0.1     tag=S2

line z loc=-0.25 spac=0.1     tag=Z1
line z loc= 0.25 spac=0.1     tag=Z2

#--------------Define the material regions in the 2d grid------------------
#lo is top or right, hi is bottom or left

#choose either region profile by setting if statement true or false, 1 or 0

# define a step to deposit over
region gas       xlo=T1  xhi=T2  ylo=S1  yhi=S2 zlo= Z1 zhi= Z2
region Oxide     xlo=T2  xhi=T4  ylo=S1  yhi=S2 zlo= Z1 zhi= Z2

#--------------Create the grid and visualize-------------------------------
#create
init 
#define the plot window, then plot with the gas region
window null
struct gmsh_write= tmp.msh

#mask negative name=mask1 left=-0.15  right=-0.05 front= 0 back= 0.1
mask negative name=mask1 r= 0.1

machine aniso Oxide name= m1 rate=0.2
machine iso Oxide name= m1 rate=0.01

mask negative name=mask2 left=-1  right= 1 front= -0.1 back= 0.1
# etch the hole for the metal line
etch machine_name= m1 Oxide aniso mask=mask2 rate=0.1 time= 0.2 spac= 0.02

# etch the circular hole for the via
etch machine_name= m1 Oxide aniso mask=mask1 rate=0.1 time= 0.5 spac= 0.02

deposit Niobium rate=0.1 time=1.0 spac= 0.02

# write to gmsh file for visualization
struct gmsh_write= etch_via.msh

