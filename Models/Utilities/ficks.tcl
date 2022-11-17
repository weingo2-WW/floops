
proc ficks { D Phi } {
  return "ddt($Phi) - ($D)*grad($Phi)"
}
