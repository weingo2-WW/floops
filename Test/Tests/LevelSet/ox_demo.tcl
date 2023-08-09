##########################################################################
#
#  This script is an example of oxide growth on a metal following the
#  Eley-Wilkinson model of self limiting growth.
#  * To show growth on a rough surface, the cmp step was used on the top material.
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
line x loc=-0.200 spac=0.010    tag=T1
line x loc=-0.100 spac=0.010    tag=T2
line x loc= 0.100 spac=0.010    tag=T3
line x loc= 0.500 spac=0.010    tag=T4


#vertical lines going left to right
line y loc=0.000 spac=0.005     tag=S1
line y loc=0.200 spac=0.005     tag=S2
line y loc=0.400 spac=0.005     tag=S3
line y loc=0.600 spac=0.005     tag=S4



#--------------Define the material regions in the 2d grid------------------
#lo is top or right, hi is bottom or left
region gas       xlo=T1  xhi=T2  ylo=S1  yhi=S4
region mat1      xlo=T2  xhi=T3  ylo=S1  yhi=S4
region mat2      xlo=T3  xhi=T4  ylo=S1  yhi=S4


#--------------Create the grid and visualize-------------------------------
#create
init
#define the plot window, then plot with the gas region
window xcairo row=1 col=2 width=600 height=600
plot2d grid gas 


#--------------Run the cmp etch command and plot--------------------------------
#polishing mat1 just to provide some stochastic roughness to the layer
etch mat1 cmp rate=0.1 time=0.1 spacing=0.003

#plot and zoom in to see the thin oxide layer
plot2d clear
plot2d grid gas


#--------------Oxidize top layer using preset specs for Al oxidation---------------------

#run oxidize command; time (min) may be changed by the user, the pressure (10 mTorr) and Temp (300 K) Al oxidation are hard-coded in  
oxidize time=6.0 spacing=0.005

plot2d clear
plot2d grid gas

#plot and zoom in to see the thin oxide layer on another window tile (graph=win1 does this)
plot2d grid gas graph= zoom xmin=-0.1 xmax=-0.075 ymin=0.0 ymax=0.1

#--------------------------------------------------------------------------------------------






gets stdin
