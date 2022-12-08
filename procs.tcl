
set origProcs [info procs]
set procs_dir [file dirname [file normalize [info script]]]

source $procs_dir/Models/Silicon/SiProcs.tcl

source $procs_dir/Models/Utilities/ficks.tcl
source $procs_dir/Models/Utilities/arr.tcl

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


