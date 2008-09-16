#-sym for experiment3
#find ../../data/negatives/ -name '*.jpg' > negatives.dat
#find ../../data/PIE/ -name '*.bmp' > pie_positives.dat

#perl createtrainsamples.pl pie_positives.dat negatives.dat pie_samples \
#    10000 './createsamples -bgcolor 0 -bgthresh 0 -maxxangle 0.05 -maxyangle 0.05 -maxzangle 0.05 -maxidev 10 -w 18 -h 20'
#find pie_samples/ -name '*.vec' > pie_samples.dat
#./mergevec pie_samples.dat pie_samples.vec
#./createsamples -vec pie_samples.vec -w 18 -h 20

#perl createtestsamples.pl pie_positives.dat negatives.dat pie_tests \
#    1000 './createsamples -bgcolor 0 -bgthresh 0 -maxxangle 0.05 -maxyangle 0.05 -maxzangle 0.05 -maxidev 10'
#find pie_tests/ -name 'info.dat' -exec cat \{\} \; > pie_tests.dat

./haartraining -data haarcascade_frontalface_pie5 -vec pie_samples.vec -bg negatives.dat -nstages 20 -nsplits 2 -minhitrate 0.999 -maxfalsealarm 0.5 -npos 10000 -nneg `cat negatives.dat | wc -l` -w 18 -h 20 -mem 800 -mode ALL -sym
./performance -data haarcascade_frontalface_pie5.xml -info pie_tests.dat -ni
