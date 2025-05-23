cmake_minimum_required(VERSION 3.10)
project(FLOODS-TestSuite)
include(CTest)
file(COPY test.sh DESTINATION ${PROJECT_BINARY_DIR})
file(COPY Tests DESTINATION ${PROJECT_BINARY_DIR})
set(TEST_DIR_BASE "${PROJECT_BINARY_DIR}/Tests")
set(TEST_SCRIPT "${PROJECT_BINARY_DIR}/test.sh")
#add_test(NAME parallelSystem COMMAND ${TEST_SCRIPT} ${PROJECT_BINARY_DIR}/flooxs parallel.tcl WORKING_DIRECTORY ${TEST_DIR})

if(NOT FLOOXS_BIN)
  set(FLOOXS_BIN flooxs)
endif()

# set(TEST_DIR "${TEST_DIR_BASE}/Unit")
# add_test(NAME Structure-Comparison-Grid2D COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} nodedata.tcl WORKING_DIRECTORY ${TEST_DIR})
# set_tests_properties(Fail PROPERTIES WILL_FAIL TRUE)

set(TEST_DIR "${TEST_DIR_BASE}/LevelSet")
add_test(NAME Level-Set-Isotropic-Deposition COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} dep_grid.tcl WORKING_DIRECTORY ${TEST_DIR})
# add_test(NAME Sputter-Deposition COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} sputter_demo.tcl WORKING_DIRECTORY ${TEST_DIR})
add_test(NAME Level-Set-Isotropic-Under-Gate-Etch COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} etch_iso.tcl WORKING_DIRECTORY ${TEST_DIR})
add_test(NAME Level-Set-Anisotropic-Etch COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} etch_aniso.tcl WORKING_DIRECTORY ${TEST_DIR})
add_test(NAME Level-Set-Anisotropic-Etch-Ang COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} aniso_ang.tcl WORKING_DIRECTORY ${TEST_DIR})
add_test(NAME Level-Set-CMP-Etch COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} etch_cmp.tcl WORKING_DIRECTORY ${TEST_DIR})
add_test(NAME Level-Set-Backend COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} backend.tcl WORKING_DIRECTORY ${TEST_DIR})
add_test(NAME Level-Set-Spacer COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} spacer.tcl WORKING_DIRECTORY ${TEST_DIR})
add_test(NAME Level-Set-Mask-Neg-Pos COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} masknegpos.tcl WORKING_DIRECTORY ${TEST_DIR})
add_test(NAME Level-Set-2-Mask COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} etch_2mask.tcl WORKING_DIRECTORY ${TEST_DIR})
# add_test(NAME Level-Set-Anisotropic-Etch-Machine COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} etch_aniso_machine.tcl WORKING_DIRECTORY ${TEST_DIR})
# add_test(NAME Level-Set-JJ-Full-Flow COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} fullflow_demo_seed.tcl WORKING_DIRECTORY ${TEST_DIR})
# add_test(NAME Level-Set-JJ-Full-Flow-Anodization COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} fullflow_anod.tcl WORKING_DIRECTORY ${TEST_DIR})

set(TEST_DIR "${TEST_DIR_BASE}/LevelSet/3D")
add_test(NAME Level-Set-3D-Isotropic-Deposition COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} dep_contact.tcl WORKING_DIRECTORY ${TEST_DIR})
add_test(NAME Level-Set-3D-Isotropic-Etch COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} etch_via.tcl WORKING_DIRECTORY ${TEST_DIR})

set(TEST_DIR "${TEST_DIR_BASE}/Diffuse")
add_test(NAME Diffusion-Trap COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} Trap.tcl WORKING_DIRECTORY ${TEST_DIR})
add_test(NAME Diffusion-Seg1v2 COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} Seg1v2.tcl WORKING_DIRECTORY ${TEST_DIR})
add_test(NAME Diffusion-SurfRecomb COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} SurfRecomb.tcl WORKING_DIRECTORY ${TEST_DIR})
add_test(NAME Diffusion-DiffComp COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} DiffComp.tcl WORKING_DIRECTORY ${TEST_DIR})
add_test(NAME Diffusion-DiffNonLin COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} DiffNonLin.tcl WORKING_DIRECTORY ${TEST_DIR})

set(TEST_DIR "${TEST_DIR_BASE}/Implant")
add_test(NAME Implant-Halo2D COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} Halo2D.tcl WORKING_DIRECTORY ${TEST_DIR})
add_test(NAME Implant-HaloDim COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} HaloDim.tcl WORKING_DIRECTORY ${TEST_DIR})
add_test(NAME Implant-HaloRot COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} HaloRot.tcl WORKING_DIRECTORY ${TEST_DIR})
add_test(NAME Implant-Tilt1D COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} Tilt1D.tcl WORKING_DIRECTORY ${TEST_DIR})

set(TEST_DIR "${TEST_DIR_BASE}/Stress")
add_test(NAME Stress3d COMMAND ${TEST_SCRIPT} ${FLOOXS_BIN} stress3d.fi WORKING_DIRECTORY ${TEST_DIR})




