#!/usr/bin/perl
use strict;
################################################################################
# Convert a file format as follows:
#   File1 Left-x Upper-y Width Height
#   File1 Left-x Upper-y Width Height
#   File2 Left-x Upper-y Width Height
#   File2 Left-x Upper-y Width Height
#   File2 Left-x Upper-y Width Height
# to OpenCV haartraining suitable format as follows:
#   File1 2 Left-x Upper-y Width Height Left-x Upper-y Width Height
#   File2 3 Left-x Upper-y Width Height Left-x Upper-y Width Height Left-x Upper-y Width Height
#
# Usage:
#   perl haartrainingformat.pl <input>
#
# Author: Naotoshi Seo
# Date  : 2008/08/28
################################################################################
my @lines = ();
if ($#ARGV >= 0) {
    open(INPUT, $ARGV[0]); @lines = <INPUT>; close(INPUT);
} else {
    @lines = <STDIN>;
}
my %counts = ();
my %coords = ();
foreach my $line (@lines) {
    $line =~ s/\s+$//;
    my @list = split(/ /, $line, 5);
    my $fname = shift(@list);
    my $coord = ' ' . join(' ', @list);
    if (exists($counts{$fname})) {
        $counts{$fname}++;
        $coords{$fname} .= $coord;
    } else {
        $counts{$fname} = 1;
        $coords{$fname} = $coord;
    }
}
foreach my $fname (sort(keys(%counts))) {
    print $fname . ' ' . $counts{$fname} . $coords{$fname} . "\n";
}
