#!/bin/bash

function do_count()
{
    local library=$1
        local sample=$2
    local transcriptome=$3
        local libraries=$4
    local version=$5
        local genome=$6

cat << EOF | bsub

#!/bin/bash
#BSUB -J ${sample}
#BSUB -o /data/srlab/bwh10x/$library/Logs/%J.out
#BSUB -e /data/srlab/bwh10x/$library/Logs/%J.err
#BSUB -q big-multi
#BSUB -M 32000
#BSUB -n 8
#BSUB -R 'select[hname!=cn001]'
#BSUB -R 'select[hname!=cn002]'
#BSUB -R 'select[hname!=cn003]'
#BSUB -R 'select[hname!=cn004]'
#BSUB -R 'select[hname!=cn005]' 
#BSUB -R 'select[hname!=cn007]' 

cd /data/srlab/bwh10x/$library/$version/$genome


/data/srlab/cellranger/cellranger-arc-2.0.0/cellranger-arc count --id=$sample --libraries=/data/srlab/bwh10x/$library/$libraries --reference=$transcriptome --jobmode=local --localcores=8 --localmem=32

EOF
}

cat lsf_params_count_arc_michelle | while read library sample transcriptome libraries version genome
do
do_count $library $sample $transcriptome $libraries $version $genome
done

