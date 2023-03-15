#!/bin/bash -l

for tarball in foldername.tar.gz;
do

echo $tarball

# checksums
md5sum /data/srlab/bwh10x/$tarball >> 03_01_checksum.txt    # change date

cp /data/srlab/bwh10x/$tarball /external/BWH-SCARDATA/bwh10x/$tarball

# mad3 checksums
md5sum /external/BWH-SCARDATA/bwh10x/$tarball >> 03_01_checksum_mad3.txt     # change date

done

