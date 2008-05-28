#!/bin/sh
#Copy contents of createsamples.vcproj, but remaining ProjectGUID, 
#Relaplace the string 'createsamples' with 'mergevec' or 'vec2img'. 
line=`wc -l createsamples.vcproj | cut -f1 -d' '`
head -6 ${1}.vcproj > tmp
tail -`echo "$line - 6" | bc` createsamples.vcproj >> tmp
mv tmp ${1}.vcproj
sed "s!createsamples!${1}!g" ${1}.vcproj > tmp; mv tmp ${1}.vcproj
sed 's!..\\include"!../include,../src,C:/Program Files/OpenCV/cxcore/include,C:/Program Files/OpenCV/cv/include,C:/Program Files/OpenCV/otherlibs/highgui"!g' ${1}.vcproj > tmp; mv tmp ${1}.vcproj

