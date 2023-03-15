#!/bin/bash

function do_mkfastq()
{
    local library=$1
    
cat << EOF | bsub 

#!/bin/bash
#BSUB -o /data/srlab/bwh10x/${library}/log/fastq_${library}.out
#BSUB -e /data/srlab/bwh10x/${library}/log/fastq_${library}.err
#BSUB -J $library
#BSUB -q big-multi
#BSUB -M 32000
#BSUB -n 8
#BSUB -N
#BSUB -R 'select[hname!=cn001]'
#BSUB -R 'select[hname!=cn002]'
#BSUB -R 'select[hname!=cn003]'
#BSUB -R 'select[hname!=cn004]'
#BSUB -R 'select[hname!=cn005]' 

module load bcl2fastq2/2.19.1
module load casava/1.8.3
cd /data/srlab/bwh10x/$library

/data/srlab/cellranger/cellranger-atac-2.0.0/cellranger-atac mkfastq --id=FASTQS --run=/data/srlab/bwh10x/$library --csv=/data/srlab/bwh10x/$library/sample_sheet.csv --jobmode=local --localcores=16 --localmem=64

EOF
}

cat lsf_params_mkfastq_arc_sid  | while read library
do
#echo $library
do_mkfastq $library
done
