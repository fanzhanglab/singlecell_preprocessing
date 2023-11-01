cd /scratch/alpine/jinamo@xsede.org/HCA/fastq
ls | grep -v "samples.txt" > samples.txt

cd /scratch/alpine/jinamo@xsede.org/HCA/
awk -F "\t" '{print $3 "\t" $7 "\t" $9 "\t" $25 "\t" $28 "\t" $32 "\t" $38 "\t" $44}' AIDA_meta.tsv > AIDA_meta_selected.tsv

#!/bin/bash

cd /scratch/alpine/jinamo@xsede.org/HCA

LIBRARY_COLUMN=25  # library_preparation_protocol.library_construction_approach
UUID_COLUMN=3     # bundle_uuid

# awk で該当する行を特定し、bundle_uuid 列の値を取得
awk -F'\t' -v lib_col="$LIBRARY_COLUMN" -v uuid_col="$UUID_COLUMN" 'NR>1 && ($lib_col == "10x 5'\'' v1" || $lib_col == "10x 5'\'' v2") {print $uuid_col}' AIDA_meta.tsv | sort -u > GEX_list.txt
awk -F'\t' -v lib_col="$LIBRARY_COLUMN" -v uuid_col="$UUID_COLUMN" 'NR>1 && ($lib_col == "BCR 10x 5'\'' v2") {print $uuid_col}' AIDA_meta.tsv | sort -u > BCR_list.txt
awk -F'\t' -v lib_col="$LIBRARY_COLUMN" -v uuid_col="$UUID_COLUMN" 'NR>1 && ($lib_col == "TCR 10x 5'\'' v2") {print $uuid_col}' AIDA_meta.tsv | sort -u > TCR_list.txt

cat GEX_list.txt | wc -l
# 690
cat BCR_list.txt | wc -l
# 41
cat TCR_list.txt | wc -l
# 41

while read -r dir; do
	rm -r /scratch/alpine/jinamo@xsede.org/${dir}
done < /scratch/alpine/jinamo@xsede.org/HCA/GEX_list.txt

while read -r dir; do
	rm -r /scratch/alpine/jinamo@xsede.org/${dir}
done < /scratch/alpine/jinamo@xsede.org/HCA/BCR_list.txt

while read -r dir; do
	rm -r /scratch/alpine/jinamo@xsede.org/${dir}
done < /scratch/alpine/jinamo@xsede.org/HCA/TCR_list.txt

# ファイル名を変更
while read -r dir; do
    # ディレクトリに移動
    cd "/scratch/alpine/jinamo@xsede.org/HCA/fastq/${dir}/"

    # ディレクトリ内のファイルを確認し、該当するファイル名に対してリネームを実行
    for file in *.R1.fastq.gz; do
        # ファイル名から.R1.fastq.gzを削除して、新しい名前を生成
        new_name="${file%.R1.fastq.gz}_S1_L002_R1_001.fastq.gz"
        mv "$file" "$new_name"
    done

    for file in *.R2.fastq.gz; do
        # ファイル名から.R2.fastq.gzを削除して、新しい名前を生成
        new_name="${file%.R2.fastq.gz}_S1_L002_R2_001.fastq.gz"
        mv "$file" "$new_name"
    done

done < GEX_list.txt

while read -r dir; do
    # ディレクトリに移動
    cd "/scratch/alpine/jinamo@xsede.org/HCA/fastq/${dir}/"
	for file in *_R1_001.fastq.gz; do
	    # ファイル名から不要な部分を削除して、新しい名前を生成
	    new_name="${file%_R1_001.fastq.gz}_S1_L001_R1_001.fastq.gz"
	    mv "$file" "$new_name"
	done

	for file in *_R2_001.fastq.gz; do
	    # ファイル名から不要な部分を削除して、新しい名前を生成
	    new_name="${file%_R2_001.fastq.gz}_S1_L001_R2_001.fastq.gz"
	    mv "$file" "$new_name"
	done
done < BCR_list.txt

while read -r dir; do
    # ディレクトリに移動
    cd "/scratch/alpine/jinamo@xsede.org/HCA/fastq/${dir}/"
	for file in *_R1_001.fastq.gz; do
	    # ファイル名から不要な部分を削除して、新しい名前を生成
	    new_name="${file%_R1_001.fastq.gz}_S1_L001_R1_001.fastq.gz"
	    mv "$file" "$new_name"
	done

	for file in *_R2_001.fastq.gz; do
	    # ファイル名から不要な部分を削除して、新しい名前を生成
	    new_name="${file%_R2_001.fastq.gz}_S1_L001_R2_001.fastq.gz"
	    mv "$file" "$new_name"
	done
done < TCR_list.txt

#!/bin/sh
#$ -S /bin/sh
#SBATCH --array=1-690
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=8
#SBATCH --time=24:00:00
##SBATCH --qos=long
#SBATCH --partition=amilan
#SBATCH --output=HCA_cellranger_count_%a.out
##SBATCH --mail-type=ALL
##SBATCH --mail-user=jun.inamo@cuanschutz.edu

export PATH=/pl/active/fanzhanglab/jinamo/tools/cellranger-7.2.0/bin/:$PATH


cd /scratch/alpine/jinamo@xsede.org/HCA

GEXFILE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" GEX_list.txt)

DIR="/pl/active/fanzhanglab/jinamo/scRNAseq/HumanCellAtlas/AIDA/GEX"
mkdir -p ${DIR}

if [ ! -e "${DIR}/${GEXFILE}/outs/possorted_genome_bam.bam" ]; then
cellranger count \
--id=${GEXFILE}_GEX \
--fastqs=/scratch/alpine/jinamo@xsede.org/HCA/fastq/${GEXFILE}/ \
--transcriptome=/pl/active/fanzhanglab/jinamo/tools/refdata-gex-GRCh38-2020-A \
--output-dir=${DIR}/${GEXFILE} \
--localcores=8 --localmem=30
fi

# sbatch scripts/HCA/HCA_cellranger_count.sh


#!/bin/sh
#$ -S /bin/sh
#SBATCH --array=1-41
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=8
#SBATCH --time=24:00:00
##SBATCH --qos=long
#SBATCH --partition=amilan
#SBATCH --output=HCA_cellranger_BCR_%a.out
##SBATCH --mail-type=ALL
##SBATCH --mail-user=jun.inamo@cuanschutz.edu

export PATH=/pl/active/fanzhanglab/jinamo/tools/cellranger-7.2.0/bin/:$PATH

cd /scratch/alpine/jinamo@xsede.org/HCA

## BCR

BCRFILE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" BCR_list.txt)

DIR="/pl/active/fanzhanglab/jinamo/scRNAseq/HumanCellAtlas/AIDA/BCR"
mkdir -p ${DIR}

cellranger vdj \
--id=${BCRFILE}_BCR \
--fastqs=/scratch/alpine/jinamo@xsede.org/HCA/fastq/${BCRFILE} \
--reference=/pl/active/fanzhanglab/jinamo/tools/refdata-cellranger-vdj-GRCh38-alts-ensembl-7.1.0 \
--output-dir=${DIR}/${BCRFILE} \
--localcores=8 --localmem=30

# sbatch scripts/HCA/HCA_cellranger_BCR.sh

#!/bin/sh
#$ -S /bin/sh
#SBATCH --array=1-41
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=8
#SBATCH --time=24:00:00
##SBATCH --qos=long
#SBATCH --partition=amilan
#SBATCH --output=HCA_cellranger_TCR_%a.out
##SBATCH --mail-type=ALL
##SBATCH --mail-user=jun.inamo@cuanschutz.edu

export PATH=/pl/active/fanzhanglab/jinamo/tools/cellranger-7.2.0/bin/:$PATH

cd /scratch/alpine/jinamo@xsede.org/HCA

## TCR

TCRFILE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" TCR_list.txt)

DIR="/pl/active/fanzhanglab/jinamo/scRNAseq/HumanCellAtlas/AIDA/TCR"
mkdir -p ${DIR}

cellranger vdj \
--id=${TCRFILE}_TCR \
--fastqs=/scratch/alpine/jinamo@xsede.org/HCA/fastq/${TCRFILE} \
--reference=/pl/active/fanzhanglab/jinamo/tools/refdata-cellranger-vdj-GRCh38-alts-ensembl-7.1.0 \
--output-dir=${DIR}/${TCRFILE} \
--localcores=8 --localmem=30

# sbatch scripts/HCA/HCA_cellranger_TCR.sh
