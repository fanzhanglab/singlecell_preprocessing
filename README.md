# singlecell_preprocessing
Single-cell preprocessing pipelines, including:
- 10X Genomics Cellranger 10X data preprocessing work flow, including:
-- Snakemake files to analyze [scRNA-seq](https://github.com/fanzhanglab/singlecell_preprocessing/blob/main/10X_pipelines/Snakefile_rna_fan), [scATAC-seq](https://github.com/fanzhanglab/singlecell_preprocessing/blob/main/10X_pipelines/Snakefile_atac_fan) starting from raw bcl files, make fastqs and then to generate quantified matrix.

- Quantify transcript expression in paired-end scRNA-seq data with kallisto bustools