#!/bin/bash
#SBATCH -J 2_err_cor
#SBATCH -A nesi00458
#SBATCH --time=2-00:00:00
#SBATCH --cpus-per-task=10
#SBATCH --ntasks=5
#SBATCH --mem=340000
#SBATCH --partition=bigmem
#SBATCH --array=1-50
#SBATCH --profile=task

SPA=/nesi/project/nesi00458/Tools/SPAdes-3.13.0-Linux/bin

#File pathways
IN=/nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}/Pre

mkdir /nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}/Assem
OUT=/nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}/Assem

#ERROR CORRECTION by BayesHammer (spades module) for Illumina 2x150bp

$SPA/metaspades.py --only-error-correction -m 340 -k 21,33,55,77 --phred-offset 33 -1 $IN/unmerged_${SLURM_ARRAY_TASK_ID}_R1.fastq.gz -2 $IN/unmerged_${SLURM_ARRAY_TASK_ID}_R2.fastq.gz --merged $IN/merged_${SLURM_ARRAY_TASK_ID}.fastq.gz -o $OUT/bayes_hammer
