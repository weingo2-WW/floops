
set origProcs [info procs]
set ProcsDir [file dirname [file normalize [info script]]]

source $ProcsDir/Models/Silicon/SiProcs.tcl

source $ProcsDir/Models/Utilities/ficks.tcl
source $ProcsDir/Models/Utilities/arr.tcl

puts [ccolor::replace "<cb>Loaded procedures: </>"] 
set procs [info procs]
foreach x $procs {
	set unique 1
	foreach y $origProcs {
		if { $y == $x } { set unique 0 }
	}
	if { $unique } { puts [ccolor::replace "<g>\t$x</>"]  }
}

unset procs


