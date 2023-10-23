#!/bin/bash
#SBATCH -J 3_assem
#SBATCH -A nesi00458
#SBATCH --time=3-00:00:00
#SBATCH --cpus-per-task=15
#SBATCH --ntasks=2
#SBATCH --mem=204000
#SBATCH --partition=bigmem
#SBATCH --array=60
#SBATCH --profile=task

SPA=/nesi/project/nesi00458/Tools/SPAdes-3.13.0-Linux/bin

#File pathways
IN=/nesi/nobackup/nesi00458/MOTS_MAGS/${SLURM_ARRAY_TASK_ID}/Assem/bayes_hammer/corrected
OUT=/nesi/nobackup/nesi00458/MOTS_MAGS/${SLURM_ARRAY_TASK_ID}/Assem


#ASSEMBLE by metaSPAdes for Illumina 2x150bp

$SPA/metaspades.py --only-assembler -m 204 -k 21,33,55,77 --phred-offset 33 -1 $IN/unmerged_${SLURM_ARRAY_TASK_ID}_R1.fastq.00.0_0.cor.fastq.gz -2 $IN/unmerged_${SLURM_ARRAY_TASK_ID}_R2.fastq.00.0_0.cor.fastq.gz --merged $IN/merged_${SLURM_ARRAY_TASK_ID}.fastq.00.0_1.cor.fastq.gz -s $IN/unmerged_${SLURM_ARRAY_TASK_ID}_R_unpaired.00.0_0.cor.fastq.gz -o $OUT/spades
