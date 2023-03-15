#!/bin/bash -l

## Modify username and folder names
cd /broad/hptmp/sgurajal/bwh10x
use UGER
for i in KW9276_aferreira KW9276_dfdwyer KW9276_hfaust KW9276_sarah_hill;
do
cmd="tar -zcvf /broad/hptmp/sgurajal/bwh10x/${i}.tar.gz /broad/hptmp/sgurajal/bwh10x/${i}"
qsub -cwd -b y -V -N ${i}.tar -l h_rt=12:00:00 -o /broad/hptmp/sgurajal/bwh10x/logs/${i}.out -e /broad/hptmp/isgurajal/bwh10x/logs/${i}.err -l h_vmem=12G $cmd;
done

