#!/bin/bash

function do_count()
{
    local library=$1
        local sample=$2
    local transcriptome=$3
        local version=$4
    local genome=$5
    	local image=$6
    local slide=$7
	local area=$8
    
cat << EOF | bsub 

#!/bin/bash
#BSUB -o /data/srlab/bwh10x/${library}/Logs/${sample}.out
#BSUB -e /data/srlab/bwh10x/${library}/Logs/${sample}.err
#BSUB -J ${sample}
#BSUB -q big-multi
#BSUB -M 64000
#BSUB -n 16
#BSUB -R 'select[hname!=cn001]'
#BSUB -R 'select[hname!=cn002]'
#BSUB -R 'select[hname!=cn003]'
#BSUB -R 'select[hname!=cn004]'
#BSUB -R 'select[hname!=cn005]' 

cd /data/srlab/bwh10x/$library/$version/$genome


/data/srlab/cellranger/spaceranger-1.2.1/spaceranger count --id=$sample --fastqs=/data/srlab/bwh10x/$library/FASTQS --sample=$sample --transcriptome=$transcriptome --image=$image --slide=$slide --area=$area --jobmode=local --localcores=16 --localmem=64 --reorient-images

EOF
}

cat lsf_params_space_KW8627_michelle | while read library sample transcriptome version genome image slide area
do
do_count $library $sample $transcriptome $version $genome $image $slide $area
done

