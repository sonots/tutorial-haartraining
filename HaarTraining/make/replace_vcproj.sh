#!/bin/sh
file=$1.vcproj
sed 's!../../../bin!../bin!g' $file > tmp; mv tmp $file # escape . as \. if it does not work well because of them. 
sed 's!../../../_temp!../_temp!g' $file > tmp; mv tmp $file
sed 's!../../../lib/cvhaartraining!../lib/cvhaartraining!g' $file > tmp; mv tmp $file
sed 's!../../../lib!../lib,C:/Program Files/OpenCV/lib!g' $file > tmp; mv tmp $file
sed 's!../../../!C:/Program Files/OpenCV/!g' $file > tmp; mv tmp $file
sed "s!${1}d!${1}!g" $file > tmp; mv tmp $file # Why did they add 'd'?
sed 's!cvhaartrainingd!cvhaartraining!g' $file > tmp; mv tmp $file
