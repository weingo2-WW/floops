proc FindDose1D {} {
    set s Silicon
    set ll [layers ]
    set ret 0.0
    foreach line $ll {
        set dose [lindex $line 2]
        set mat [lindex $line 3]
        if {$mat == $s} {
            if {$dose > 0.0} {set ret [expr $ret + $dose]}
        }
    }
    return $ret
}

proc FindDose2D {yv} {
    set s Silicon
    set ll [layers yv=$yv]
    set ret 0.0
    foreach line $ll {
        set dose [lindex $line 2]
        set mat [lindex $line 3]
        if {$mat == $s} {
            if {$dose > 0.0} {set ret [expr $ret + $dose]}
        }
    }
    return $ret
}

