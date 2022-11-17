
# Arrhenius equation
proc arr { A Ea T } {
  set k 8.62e-5 ;# eV/K
  return "$A*exp(-$Ea/($k*$T))"
}
