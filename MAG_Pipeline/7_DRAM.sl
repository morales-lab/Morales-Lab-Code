#!/bin/bash
#SBATCH -J dramv-novaseq
#SBATCH -A nesi00458
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=24
#SBATCH --mem=40G
#SBATCH --hint nomultithread
#SBATCH --array=1

#load spades
module load DRAM/1.3.5-Miniconda3

#File pathways
IN=/nesi/nobackup/nesi00458/yugen/MOTS/MOTS_viromes_2018/hiseq_processing/more_10kbp/virsorter_dvf_viral_combined.fa


OUT=/nesi/nobackup/nesi00458/yugen/MOTS/MOTS_viromes_2018/hiseq_processing/more_10kbp/hiseq_combined_dram_output/


#DRAM-V annotations

DRAM-v.py annotate -i $IN/final-viral-combined-for-dramv.fa -v $IN/viral-affi-contigs-for-dramv.tab -o $OUT

#DRAM-v distillation
DRAM-v.py distill -i $OUT/annotations.tsv -o $OUT/distilled
