#!/bin/bash
$1 -noplot $2 > output 2>&1
if cat output | grep -q ^Passed 
then
  echo -n "Passed "
else 
  tail -n 100 output
  # cat output
  exit 1
fi	      
