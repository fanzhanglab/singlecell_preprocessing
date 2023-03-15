#!/bin/bash

function do_count()
{
    local library=$1
	local sample=$2
    local transcriptome=$3
        local version=$4
    local genome=$5
    
cat << EOF | bsub 

#!/bin/bash
#BSUB -J run_vdj_${sample}
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


TENX_IGNORE_DEPRECATED_OS=1 /data/srlab/cellranger/cellranger-6.1.1/cellranger vdj --id=$sample --fastqs=/data/srlab/bwh10x/$library/FASTQS --sample=$sample --reference=$transcriptome --jobmode=local --localcores=16 --localmem=64

EOF
}

cat lsf_params_vdj_KW9861 | while read library sample transcriptome version genome
do
do_count $library $sample $transcriptome $version $genome
done
