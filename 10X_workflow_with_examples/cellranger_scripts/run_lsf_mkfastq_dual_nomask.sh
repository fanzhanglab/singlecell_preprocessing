#!/bin/bash

function do_mkfastq()
{
    local library=$1
    
cat << EOF | bsub 

#!/bin/bash
#BSUB -J ${library}
#BSUB -o /data/srlab/bwh10x/${library}/Logs/fastq_$library.out
#BSUB -e /data/srlab/bwh10x/${library}/Logs/fastq_$library.err
#BSUB -q big-multi
#BSUB -M 64000
#BSUB -n 16
#BSUB -N
#BSUB -R 'select[hname!=cn001]'
#BSUB -R 'select[hname!=cn002]'
#BSUB -R 'select[hname!=cn003]'
#BSUB -R 'select[hname!=cn004]'
#BSUB -R 'select[hname!=cn005]'

module load bcl2fastq2/patchelf-2.20.0
module load casava/1.8.3
cd /data/srlab/bwh10x/$library

TENX_IGNORE_DEPRECATED_OS=1 /data/srlab/cellranger/cellranger-6.1.1/cellranger mkfastq --id=FASTQS --run=/data/srlab/bwh10x/$library --csv=/data/srlab/bwh10x/$library/sample_sheet.csv --barcode-mismatches=0 --jobmode=local --localcores=16 --localmem=64 --filter-dual-index

EOF
}

cat lsf_params_mkfastq_michelle | while read library
do
#echo $library
do_mkfastq $library
done
