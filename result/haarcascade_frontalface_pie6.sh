#-maxtreesplits 4

#find ../../data/negatives/ -name '*.jpg' > negatives.dat
#find ../../data/PIE/ -name '*.bmp' > pie_positives.dat

#perl createtrainsamples.pl pie_positives.dat negatives.dat pie_samples \
#  10000 './createsamples -bgcolor 0 -bgthresh 0 -maxxangle 0.05 -maxyangle 0.05 -maxzangle 0.05 -maxidev 10 -w 18 -h 20'
#find pie_samples/ -name '*.vec' > pie_samples.dat
#./mergevec pie_samples.dat pie_samples.vec
##./createsamples -vec pie_samples.vec -w 18 -h 20

#perl createtestsamples.pl pie_positives.dat negatives.dat pie_tests \
#  1000 './createsamples -bgcolor 0 -bgthresh 0 -maxxangle 0.05 -maxyangle 0.05 -maxzangle 0.05 -maxidev 10'
#find pie_test/ -name 'info.dat' -exe cat \{\} \; > pie_tests.dat

#nohup time ./haartraining -data haarcascade_frontalface_pie6 \
#  -vec samples.vec -bg negatives.dat -nstages 20 -nsplits 2 -minhitrate 0.999 \
#  -maxfalsealarm 0.5 -npos 10000 -nneg `cat negatives.dat | wc -l` \
#  -w 18 -h 20 -mem 500 -mode ALL -maxtreesplits 4 > log &

./performance -data haarcascade_frontalface_pie6.xml -info pie_tests.dat -ni \
  |& tee haarcascade_frontalface_pie6.performance_pie_tests.txt
# cp ../../result/cmu_tests.dat .
./performance -data haarcascade_frontalface_pie6.xml -info cmu_tests.dat -ni \
  |& tee haarcascade_frontalface_pie6.performance_cmu_tests.txt

#took 3 weeks

