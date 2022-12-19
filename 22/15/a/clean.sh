#! /bin/bash

#./clean.sh <input >input_clean
sed -e "s/Sensor at//g" -e "s/: closest beacon is at/,/g" -e "s/x=//g" -e "s/y=//g" -e "s/ //g" <&0
