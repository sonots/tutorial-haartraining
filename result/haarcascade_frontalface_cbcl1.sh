find ../../data/CBCL/train/face/ -name '*.pgm' > ../../result/cbcl_train_positives.dat
find ../../data/CBCL/test/face/ -name '*.pgm' > ../../result/cbcl_test_positives.dat
find ../../data/negatives/ -name '*.jpg' > ../../result/negatives.dat

perl createtrainsamples.pl ../../result/cbcl_train_positives.dat \
  ../../result/negatives.dat ../../result/cbcl_samples \
  9700 './createsamples -maxxangle 0.05 -maxyangle 0.05 -maxzangle 0.05 -maxidev 10 -bgcolor 0 -bgthresh 0 -w 19 -h 19'
find ../../result/cbcl_samples/ -name '*.vec' > ../../result/cbcl_samples.dat
./mergevec ../../result/cbcl_samples.dat ../../result/cbcl_samples.vec
#./createsamples -vec ../../result/cbcl_samples.vec -w 19 -h 19

perl createtestsamples.pl ../../result/cbcl_test_positives.dat \
  ../../result/negatives.dat ../../result/cbcl_tests \
  1000 './createsamples -maxxangle 0.05 -maxyangle 0.05 -maxzangle 0.05 maxidev 10 -bgcolor 0 -bgthresh 0 '
find ../../result/cbcl_tests/ -name 'info.dat' -exec cat \{\} \; > ../../result/cbcl_tests.dat

cp ../../result/negatives.dat negatives.dat
./haartraining -data ../../result/haarcascade_frontalface_cbcl1 \
  -vec ../../result/cbcl_samples.vec -bg negatives.dat \
  -nstages 20 -nsplits 2 -minhitrate 0.999 -maxfalsealarm 0.5 -npos 9700 \
  -nneg `cat ../../result/negatives.dat | wc -l` -mem 800 -mode ALL \
   -w 19 -h 19 -sym -maxtreesplits 4
cp ../../result/cbcl_tests.dat .
./performance -data ../../result/haarcascade_frontalface_cbcl1.xml \
  -info cbcl_tests.dat -ni >& ../../result/haarcascade_frontalface_cbcl1.performance_cbcl_tests.txt
cp ../../result/cmu_tests.dat .
./performance -data ../../result/haarcascade_frontalface_cbcl1.xml \
  -info cmu_tests.dat -ni >& ../../result/haarcascade_frontalface_cbcl1.performance_cmu_tests.txt

