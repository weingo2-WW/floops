
proc errorFxn { params } {
  set tmp [split [exec flooxs -noplot error_sim.tcl $params 2> /dev/null] "\n" ]
  return [expr [lindex $tmp [expr [llength $tmp]-1] ]]
}

# set T [expr 273+900]
# puts [expr [arr 0.743 3.80 $T]]
set Dinit 3.54317482163084e-17
# puts [errorFxn $Dinit]
set opt_params [optimize errorFxn=errorFxn initial_step= 1e-19 max_iterations= 1000 rel_error= 1e-3 params= $Dinit names= D damp= 1e-18 h= [expr 1e-17*1e-4] ]
puts $opt_params
