#!/bin/bash

function do_multi()
{
    local library=$1
        local version=$2
    local genome=$3
        local sample=$4
    local config=$5
    
cat << EOF | bsub 

#!/bin/bash
#BSUB -J run_multi_${sample}
#BSUB -o /data/srlab/bwh10x/${library}/Logs/%J.out
#BSUB -e /data/srlab/bwh10x/${library}/Logs/%J.err
#BSUB -q big-multi
#BSUB -M 64000
#BSUB -n 16
#BSUB -R 'select[hname!=cn001]'
#BSUB -R 'select[hname!=cn002]'
#BSUB -R 'select[hname!=cn003]'
#BSUB -R 'select[hname!=cn004]'
#BSUB -R 'select[hname!=cn005]' 


cd /data/srlab/bwh10x/$library/$version/$genome


TENX_IGNORE_DEPRECATED_OS=1 /data/srlab/cellranger/cellranger-6.1.1/cellranger multi --id=$sample --csv=$config --jobmode=local --localcores=16 --localmem=64

EOF
}

cat lsf_params_multi_KW9767 | while read library version genome sample config
do
do_multi $library $version $genome $sample $config
done
