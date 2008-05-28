-data/         The downloaded image datasets
-HaarTraining/ HaarTraining from OpenCV
-result/       Results

Below is a note of how I installed HaarTraining. 
I had to modify several files since I did not like to work on the OpenCV installed directory. 
These resulting files are availbe in the HaarTraining directory. 

On Windows
+ Install OpenCV 1.0. Download .exe installer and Install it (C:\Program Files\OpenCV) 
+ Copy C:\Program Files\OpenCV\apps\HaarTraining
+ Copy C:\Program Files\OpenCV\data\haarcascades into data\
+ Copy C:\Program Files\OpenCV\samples\c\{facedetect,convert_cascade}.c into HaarTrainig\src\
+ Modify path in the make\*.vcproj
  $ sh replace_vcproj.sh createsamples
  $ sh replace_vcproj.sh haartraining
  $ sh replace_vcproj.sh performance
  $ sh replace_vcproj.sh cvhaartraining
+ Modify make\haartraining.sln. 
  Replace ..\..\..\ with C:\Program Files\OpenCV\
+ Create mergevec.cpp, and vec2img.cpp into src\
+ Add new VC++ Console application projects, mergevec and vec2img in Visual Studio. 
  Copy {mergevec,vec2img}.vcproj into make\
  Modify *.vcproj
  $ sh new_vcproj.sh mergevec
  $ sh new_vcproj.sh vec2img
  Remove remained files and projects in Visual Stuio. 
  Add existing projects mergevec.vcproj, and vec2img.vcproj. 
+ Copy C:\Program Files\OpenCV\samples\c\{convert_cascade,facedetect}.c into src\
+ Add new VC++ Console ....
  Copy {convert_cascade,facedetect}.vcproj into make\
  Modify *.vcproj
   Copy contents of C:\Program Files\OpenCV\samples\c\cvsample.vcproj, but remaining ProjectGUID. 
   Replace the string 'cvsample' with 'convert_cascade or facedetect
   Replace .\..\..\ with .\../
   Replace ../../ with C:\Program Files\OpenCV\
   Replace OutputFile directory into .\../bin/
   Replace .\squares.c with .\..\src\convert_cascade.c or .\..\src\facedetect.c. 
  Remove remained files and projects in Visual Stuio. 
  Add existing projects ...
+ Build Solution. 
+ Copy C:\Program Files\OpenCV\bin\*.dll into HaarTraining\bin
+ Run. 
+ I got Runtime error R6034 (Visual Studio 8). On Visual Studio, 
  right Click Solution > Properties > Configuration Properties > Change all Configurations to 'Release' from 'Debug'
  Rebuild Solution. It worked.

On Linux
+ Download Open OpenCV-1.0.0.tar.gz, and tar xvzf OpenCV-1.0.0.tar.gz; cd opencv-1.0.0
+ ./configure --prefix=~/opencv-1.0.0; make; make install;
+ export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:~/opencv-1.0.0/{bin,lib}
+ cp -r ~/opencv-1.0.0/apps/HaarTraining .
+ cp -r ~/opencv-1.0.0/data/haarcascades data/
+ cp -r ~/opencv-1.0.0/samples/c/{facedetect,convert_cascade}.c HaarTrainig/src
+ cd HaarTraining; Created a Makefile in HaarTraining/
+ make
+ run