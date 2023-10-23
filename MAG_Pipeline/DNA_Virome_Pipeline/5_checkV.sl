#!/bin/bash
#SBATCH -J checkV_miseq
#SBATCH -A nesi00458
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=30
#SBATCH --mem=40G
#SBATCH --array=20

#load checkV
module load CheckV/0.6.0-gimkl-2020a-Python-3.8.2

#checkV database
checkv download_database /nesi/nobackup/nesi00458/yugen

#File pathways
IN=/nesi/nobackup/nesi00458/yugen/MOTS/MOTS_viromes_2018/hiseq_processing/more_10kbp/${SLURM_ARRAY_TASK_ID}/virsorter


mkdir /nesi/nobackup/nesi00458/yugen/MOTS/MOTS_viromes_2018/hiseq_processing/more_10kbp/${SLURM_ARRAY_TASK_ID}/checkV

OUT=/nesi/nobackup/nesi00458/yugen/MOTS/MOTS_viromes_2018/hiseq_processing/more_10kbp/${SLURM_ARRAY_TASK_ID}/checkV

#checkV error correction

checkv end_to_end $IN/final-viral-combined.fa $OUT -t 28 -d /nesi/nobackup/nesi00458/yugen/checkv-db-v1.2
