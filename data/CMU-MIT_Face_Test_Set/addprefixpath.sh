#!/bin/sh
#ex) sh addprefixpath.sh [prefix such as dirname] tests.dat
prefix=$1
file=$2
yes $prefix | head -`cat $file | wc -l` | paste -d'/' - $file

