#!/bin/bash

#script to run floods and floops testsuites localy
# need $FLXSHOME set
BASEDIR=`pwd`
echo "Base $BASEDIR"
# Run floods test suite
cd ../floods/Test
rm -rf build
mkdir build
cd build
cmake .. -DFLOOXS_BIN=$FLXSHOME/release/flooxs
ctest --output-on-failure > output.txt

# Run floops test suite
cd $BASEDIR
cd Test
rm -rf build
mkdir build
cd build
cmake .. -DFLOOXS_BIN=$FLXSHOME/release/flooxs
ctest --output-on-failure > output.txt

cd $BASEDIR
echo "FLOODS Test Suite Summary:"
grep "tests passed" ../floods/Test/build/output.txt
echo "FLOOPS Test Suite Summary:" 
grep "tests passed" Test/build/output.txt

