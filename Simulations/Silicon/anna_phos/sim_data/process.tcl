
set keys "3min 3min_sim 6min 6min_sim 10min 10min_sim 15min 15min_sim 50min_sim 100min_sim 200min_sim"

set fil [open "data.dict" "r"]
set data [read $fil]
close $fil

set fil [open "data.csv" "w+"]
set x ""
foreach v [dict get $data [lindex $keys 0]] {
 lappend x [lindex $v 0]
}
for { set i 0 } { $i < [llength $x] } { incr i } {
  puts -nonewline $fil "[lindex $x $i],"
  foreach k $keys {
    set v [lindex [dict get $data $k] $i 1]
    if { $v == "Value" } {
      puts -nonewline $fil "$k,"
    } else {
      puts -nonewline $fil "$v,"
    }
  }
  puts $fil ""
}
close $fil
