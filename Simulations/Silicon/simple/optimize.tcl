

proc errorFxn { params } {
  set tmp [split [exec flooxs error_sim.tcl $params 2> /dev/null] "\n" ]
  return [expr [lindex $tmp [expr [llength $tmp]-1] ]]
  #return [expr log10([lindex $tmp [expr [llength $tmp]-1] ])]
}

pdbSet optimize delta 1e-3
pdbSet optimize initialStep 0.01

#set opt_params [optimize errorFxn "40 2.8" 1000 0.20]
#set opt_params [optimize errorFxn "36.9 2.6" 1000 0.20]


# set opt_params [optimize errorFxn "34.67 2.4" 1000 0.20]

#set opt_params [optimize errorFxn "22 2.5" 1000 0.20]

set opt_params [optimize errorFxn "5 2.7 20" 1000 0.20]
#2.4399856767037797 2.6645879295964066 19.9220383233608

puts $opt_params
