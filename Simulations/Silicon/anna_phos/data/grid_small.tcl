options nm

line x loc=35.0 spac=0.10 tag=Top
line x loc=150. spac=0.10 tag=Bottom
region silicon xlo=Top xhi=Bottom 
init

proc SortXY { l } {
  set out ""
  set indicies ""
  for { set i 0 } { $i < [llength $l] } { incr i } {
    lappend indicies $i
  }
  while { [llength $out] != [llength $l] } {
    set min [lindex $indicies 0]
    foreach i $indicies {
      lassign [lindex $l $i] xi y
      lassign [lindex $l $min] xmin y
      if { $xi < $xmin } { set min $i }
    }
    set remove 0
    for { set i 0 } { $i < [llength $indicies] } { incr i } {
      if { $min == [lindex $indicies $i] } {
        set remove $i
        break
      }
    }
    
    set indicies [lreplace $indicies $remove $remove]
    lappend out [lindex $l $min]
  }
  return $out
}

set fil [open "wpd_datasets.csv" "r"]
set dat [split [read $fil] "\n"]
close $fil
set lag ""
set l3 ""
set l6 ""
set l10 ""
for { set i 2 } { $i < [llength $dat]-1 } { incr i } {
  set tmp [split [lindex $dat $i] ","]
  lassign $tmp xag yag x3 y3 x6 y6 x10 y10 x15 y15
  if { $xag != "" } { lappend lag "$xag $yag" }
  if { $x3  != "" } { lappend l3 "$x3 $y3" }
  if { $x6  != "" } { lappend l6 "$x6 $y6" }
  if { $x10 != "" } { lappend l10 "$x10 $y10" }
  if { $x15 != "" } { lappend l15 "$x15 $y15" }
}
set lag [SortXY $lag]
set l3 [SortXY $l3]
set l6 [SortXY $l6]
set l10 [SortXY $l10]
set l15 [SortXY $l15]
set ag [open "ag.txt" "w+"]
foreach v $lag { puts $ag $v }
close $ag 
set f3 [open "3.txt" "w+"]
foreach v $l3 { puts $f3 $v }
close $f3 
set f6 [open "6.txt" "w+"]
foreach v $l6 { puts $f6 $v }
close $f6 
set f10 [open "10.txt" "w+"]
foreach v $l10 { puts $f10 $v }
close $f10
set f15 [open "15.txt" "w+"]
foreach v $l15 { puts $f15 $v }
close $f15
profile infile= ag.txt  name= ag linear offset= 0
profile infile= 3.txt  name= 3min linear offset= 0
profile infile= 6.txt  name= 6min linear offset= 0
profile infile= 10.txt  name= 10min linear offset= 0
profile infile= 15.txt  name= 15min linear offset= 0
file delete ag.txt 3.txt 6.txt 10.txt 15.txt
sel z= 1e16+(ag) name= AsGrown
sel z= 1e16+(3min) name= 3min
sel z= 1e16+(6min) name= 6min
sel z= 1e16+(10min) name= 10min
sel z= 1e16+(15min) name= 15min

window
sel z= log10(AsGrown)
plot1d
sel z= log10(3min)
plot1d
sel z= log10(6min)
plot1d
sel z= log10(10min)
plot1d
sel z= log10(15min)
plot1d

struct outfile= grid_small.str
