

proc errorFxn { params } {
  set tmp [split [exec flooxs -noplot error_800_const_sim.tcl $params 2> /dev/null] "\n" ]
  return [expr [lindex $tmp [expr [llength $tmp]-1] ]]
}

set Ds ""
for {set D 9.1} { $D < 9.15 } { set D [expr $D+0.001] } {
  set err [errorFxn $D]
  puts "$D $err"
  lappend Ds "$D $err"
}
#result best fit 9.12

puts $Ds
