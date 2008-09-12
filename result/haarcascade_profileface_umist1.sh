find ../../data/negatives/ -name '*.jpg' > negatives.dat
find ../../data/umist_cropped/ -name '*.bgm' > umist_positives.dat

# 0.78 == 45 degree, 0.39 == 45/2 degree, 0 digree for y because UMIST database is already varied in the direction
perl createtrainsamples.pl umist_positives.dat negatives.dat umist_samples \
  10000 './createsamples -bgcolor 0 -bgthresh 0 -maxxangle 0.39 -maxyangle 0 -maxzangle 0.78 -maxidev 40 -w 18 -h 22'
find umist_samples/ -name '*.vec' > umist_samples.dat
./mergevec umist_samples.dat umist_samples.vec

perl createtestsamples.pl umist_positives.dat negatives.dat umist_tests \
  1000 './createsamples -bgcolor 0 -bgthresh 0 -maxxangle 0.39 -maxyangle 0 -maxzangle 0.78 -maxidev 40'
find umist_tests/ -name 'info.dat' -exec cat \{\} \; > umist_tests.dat

# -sym generate flipped images in left-right, thus, -sym helps for profile face too
./haartraining -data haarcascade_profileface_umist1 -vec umist_samples.vec \
  -bg negatives.dat -nstages 20 -nsplits 2 -minhitrate 0.999 -maxfalsealarm 0.5 \
  -npos 10000 -nneg `cat negatives.dat | wc -l` -mem 800 -mode ALL \
  -w 18 -h 22 -sym
./performance -data haarcascade_profileface_umist1.xml -info umist_tests.dat -ni
# took 5 days
