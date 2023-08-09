
##########################################################################
#
#  This script is an example of anodization of surface materials to form an oxide layer.
#  It includes solving the Laplace equation in the material system to  
#  couple potential field values to the levelset procedure. 
#  
##########################################################################

#---------------Definitions------------------------------------------------

#include preset definitions for solution of the electrical behavior.
DevicePackage

# metal, oxide, and gas are predefined materails that we will utilize
# make a new material to couple the electrical and the growth physics 
mater add name=LevelMaterial

#--------------Define the 2d grid of base materials------------------------
set gridspac 0.02

#horixontal lines
line x loc=0.200 spac=$gridspac    tag=T2
line x loc=0.400 spac=$gridspac    tag=T3
line x loc=0.600 spac=$gridspac    tag=T4
line x loc=0.700 spac=$gridspac    tag=T5
line x loc=1.000 spac=$gridspac    tag=T6

#vertical lines
line y loc=0.000 spac=$gridspac     tag=S1
line y loc=0.350 spac=$gridspac     tag=S2
line y loc=0.650 spac=$gridspac     tag=S3
line y loc=1.000 spac=$gridspac     tag=S4

#--------------Define the material regions in the 2d grid------------------
#lo is top or right, hi is bottom or left
region gas      xlo=T2  xhi=T3  ylo=S1  yhi=S4
region metal    xlo=T3  xhi=T4  ylo=S1  yhi=S4
region oxide    xlo=T4  xhi=T5  ylo=S1  yhi=S4
region metal    xlo=T5  xhi=T6  ylo=S1  yhi=S4

#--------------Create the grid and visulaize-------------------------------
#create
init

#define the plot window, then plot the grid
window row=1 col=1 width=600 height=600
plot2d grid gas


#---------------Create mask/s------------------------------------------------
mask name=dummy1    left=0.300  right=0.700


#---------------Etch the top metal layer to create a surface topology---------
# etch using anisotropic parameter option (removes material outside the mask edges
etch metal aniso mask=dummy1 time=2.5
#plot
plot2d grid


#################### Set-up level controller ####################

# use tcl set command to define variables to pass in to Alagator
set T    300
set k    1.38066e-23
set q    1.619e-19
set Vt   [expr $k*$T/$q]

#-----------------------run the anodization-----------------------------
# anodization command (no user parameters are available yet, the default for anodization voltage is 20V)

# rate_function
anodize metal spac= 0.005 time= 10.5 voltage= 15 rate_function= "1e-9*exp(sqrt(abs(dot(DevPsi,DevPsi)))/1e6)" vol_expansion= 2.5

#plot the final structure
plot2d clear
plot2d grid gas 

#Notes: Exporting the mesh after anodization is not currently possible.




