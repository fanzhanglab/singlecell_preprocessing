#@Script: Demulitplexing TEA-seq (Combined GEX/ATAC/HTO&ADT)
#@Author: Sid Gurajala
#@Date: 06/16/2022

#Sourced From: https://github.com/AllenInstitute/aifi-swanson-teaseq/blob/master/teaseq_preprocessing/00_teaseq_bcl2fastq.sh"#

#!/bin/bash

module load bcl2fastq2


FLOWCELL_DIR='/data/srlab/bwh10x/220603_10X_KW10050_bcl_Lanes1-2'
INTEROP_DIR='/data/srlab/bwh10x/220603_10X_KW10050_bcl_Lanes1-2/InterOp'
GEX_SAMPLE_SHEET_PATH='/data/srlab/bwh10x/220603_10X_KW10050_bcl_Lanes1-2/SampleSheetGEX.csv'
OUTPUT_DIR='/data/srlab/bwh10x/220603_10X_KW10050_bcl_Lanes1-2/FASTQS_TEA'

#GEX# 

cmd="bcl2fastq --use-bases-mask=Y28n*,I10,I10n*,Y90n* --create-fastq-for-index-reads --minimum-trimmed-read-length=8 --mask-short-adapter-reads=8 --ignore-missing-positions --ignore-missing-filter --ignore-missing-bcls -r 24 -w 24 -p 80 -R ${FLOWCELL_DIR} --output-dir="${OUTPUT_DIR}/GEX" --interop-dir=${INTEROP_DIR} --sample-sheet=${GEX_SAMPLE_SHEET_PATH}"
bsub -J GEX -e ${FLOWCELL_DIR}/log/GEX.err -o ${FLOWCELL_DIR}/log/GEX.out -M 32000 -n 8 -q big-multi $cmd

#HTO&ADT#

EPITOPE_SAMPLE_SHEET_PATH="/data/srlab/bwh10x/220603_10X_KW10050_bcl_Lanes1-2/SampleSheetEpitope.csv"
cmd="bcl2fastq --use-bases-mask=Y28n*,I8n*,n*,Y90n* --create-fastq-for-index-reads --minimum-trimmed-read-length=8 --mask-short-adapter-reads=8 --ignore-missing-positions --ignore-missing-controls --ignore-missing-filter --ignore-missing-bcls -r 24 -w 24 -p 80 -R ${FLOWCELL_DIR} --output-dir="${OUTPUT_DIR}/EPITOPE" --interop-dir=${INTEROP_DIR} --sample-sheet=${EPITOPE_SAMPLE_SHEET_PATH}"

bsub -J Epitope -e ${FLOWCELL_DIR}/log/Epitope.err -o ${FLOWCELL_DIR}/log/Epitope.out -M 32000 -n 8 -q big-multi $cmd

#ATAC#

FLOWCELL_DIR="/data/srlab/bwh10x/220514_10X_KW10051_bcl/"
INTEROP_DIR="/data/srlab/bwh10x/220514_10X_KW10051_bcl/InterOp"
ATAC_SAMPLE_SHEET_PATH="/data/srlab/bwh10x/220514_10X_KW10051_bcl/SampleSheetATAC.csv"
cmd="bcl2fastq --use-bases-mask=Y50n*,I8n*,n8Y16,Y49 --create-fastq-for-index-reads --minimum-trimmed-read-length=8 --mask-short-adapter-reads=8 --ignore-missing-positions --ignore-missing-filter --ignore-missing-bcls -r 24 -w 24 -p 80 -R ${FLOWCELL_DIR} --output-dir="${OUTPUT_DIR}/ATAC" --interop-dir=${INTEROP_DIR} --sample-sheet=${ATAC_SAMPLE_SHEET_PATH}"

bsub -J ATAC -e ${FLOWCELL_DIR}/log/ATAC.err -o ${FLOWCELL_DIR}/log/ATAC.out -M 32000 -n 8 -q big-multi $cmd
