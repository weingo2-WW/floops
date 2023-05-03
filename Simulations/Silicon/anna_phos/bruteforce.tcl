
proc errorFxn { params } {
  set tmp [split [exec flooxs -noplot error_sim.tcl $params 2> /dev/null] "\n" ]
  return [expr [lindex $tmp [expr [llength $tmp]-1] ]]
}


set fil [open brute.txt "w+"]
for { set Dinit [expr 3.54317482163084e-17-5e-18] } { $Dinit < [expr 3.54317482163084e-17+5e-18] } { set Dinit [expr $Dinit+5e-19] } {
  set dat "{$Dinit [errorFxn $Dinit]}"
  puts $dat
  puts $fil $dat
  flush $fil
}
close $fil
