#!/bin/bash -l

for folder in 210113_10X_KW8595_bcl 210114_10X_KW8596-3of3_bcl 210115_10X_KW8626_bcl 210119_10X_KW8627_bcl;
do

# remove cellranger folder by hand
echo $folder

err="/data/srlab1/mcurtis/singlecellcore/logs/${folder}.e"
out="/data/srlab1/mcurtis/singlecellcore/logs/${folder}.o"
cmd="tar -zcvf /data/srlab/bwh10x/${folder}.tar.gz /data/srlab/bwh10x/${folder}"

bsub -q normal -J tar_${folder} -e $err -o $out -R select[hname!=cn001] -R select[hname!=cn002] -R select[hname!=cn003] -R select[hname!=cn004] -R select[hname!=cn005] $cmd

done
