#!/usr/bin/perl
use File::Basename;
use strict;
#########################################################################
# Create test samples from an image applying distortions repeatedly 
# (create many many test samples from many images applying distortions)
#
#  perl createtestsamples.pl <positives.dat> <negatives.dat> <output_dir>
#  ex) perl createtestsamples.pl positives.dat negatives.dat tests
#
# Author: Naotoshi Seo
# Date  : 06/02/2007
# Date  : 03/12/2006
#########################################################################
my $cmd = './createsamples.exe -w 40 -h 40 -maxxangle 0.6 -maxyangle 0 -maxzangle 0.3 -maxidev 100 -bgcolor 0 -bgthresh 0 ';
my $totalnum = 1000; # 1000(?)
my $tmpfile  = 'tmp';

if ($#ARGV < 2) {
    print "Usage: perl createtestsamples.pl\n";
    print "  <positives_collection_file_name>\n";
    print "  <negatives_collection_file_name>\n";
    print "  <output_dir_name>\n";
    exit;
}
my $positive  = $ARGV[0];
my $negative  = $ARGV[1];
my $outputdir = $ARGV[2];

open(POSITIVE, "< $positive");
my @positives = <POSITIVE>;
close(POSITIVE);

open(NEGATIVE, "< $negative");
my @negatives = <NEGATIVE>;
close(NEGATIVE);

# number of generated images from one image so that total will be $totalnum
my $num = int($totalnum / $#positives + .5);

# Get the directory name of positives
my $first = $positives[0];
my $last  = $positives[$#positives];
while ($first ne $last) {
    $first = dirname($first);
    $last  = dirname($last);
    if ( $first eq "" ) { last; }
}
my $imgdir = $first;
my $imgdirlen = length($first);

foreach my $img (@positives) {
    # Pick up negative images randomly
    my @localnegatives = ();
    for (my $i = 0; $i < $num+1; $i++) {
        my $ind = int(rand($#negatives));
        push(@localnegatives, $negatives[$ind]);
    }
    open(TMP, "> $tmpfile");
    print TMP @localnegatives;
    close(TMP);
    #system("cat $tmpfile");

    !chomp($img);
    my $subbasename = substr($img, $imgdirlen);
    my $info = $outputdir . $subbasename . "/info.dat";
    print "$cmd -img $img -bg $tmpfile -info $info -num $num" . "\n";
    system("$cmd -img $img -bg $tmpfile -info $info -num $num");

    # Modify path in the info.dat
    open(INFO, $info); # or die;
    my @lines = <INFO>;
    close(INFO);
    open(INFO, "> $info");
    foreach my $line (@lines) {
        $line = $outputdir . $subbasename . '/' . $line;
        print INFO $line;
    }
    close(INFO);
}
unlink($tmpfile);

