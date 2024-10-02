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


proc etchcomp {model} {
    #--------------Define the 2d grid of base materials------------------------
    #horizontal lines going top to bottom
    line x loc=0.000 spac=0.010    tag=T1
    line x loc=0.200 spac=0.010    tag=T2
    line x loc=0.400 spac=0.010    tag=T3

    #vertical lines going left to right
    line y loc=-0.250 spac=0.010     tag=S1
    line y loc=0.250 spac=0.010     tag=S2

    #--------------Define the material regions in the 2d grid------------------
    #lo is top or right, hi is bottom or left
    region oxide        xlo=T1  xhi=T2  ylo=S1  yhi=S2
    region silicon        xlo=T2  xhi=T3  ylo=S1  yhi=S2

    #--------------Create the grid and visulaize-------------------------------
    #create
    init
    #define the plot window, then plot with the gas region
    plot2d grid graph=$model title=$model ymax=0.0 xmax=0.25

    #--------------Run the etch command and plot--------------------------------

    #anisotropic etches with positive and negative masks
    #etch through oxide to form a via with a 20% overetch
    etch oxide aniso ang=$model mask=mask2 rate=0.24 time=1.0
    plot2d grid graph=post$model title=post$model ymax=0.0 xmax=0.25
}

mask name=mask2 negative left=-0.100  right=0.100 thick=0.1

window row=2 col=2 width=600 height=600
etchcomp 5
# struct outfile=aniso_ang.tcl.gold.1.str
set first [CompareStruct filename=aniso_ang.tcl.gold.1.str]

etchcomp 10
# struct outfile=aniso_ang.tcl.gold.2.str
__TestReturn [expr $first&&[CompareStruct filename=aniso_ang.tcl.gold.2.str]]
