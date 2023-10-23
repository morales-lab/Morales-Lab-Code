#!/bin/bash
#SBATCH -J 2_err_cor
#SBATCH -A nesi00458
#SBATCH --time=3-00:00:00
#SBATCH --cpus-per-task=40
#SBATCH --mem=600G
#SBATCH --array=19

#load spades
module load SPAdes/3.15.3-gimkl-2020a

#File pathways
IN=/nesi/nobackup/nesi00458/yugen/MOTS/MOTS_viromes_2018/hiseq_processing/19/Pre/trimmomatic


#mkdir /nesi/nobackup/nesi00458/yugen/MOTS/MOTS_viromes_2018/hiseq_processing/${SLURM_ARRAY_TASK_ID}/Assem

OUT=/nesi/nobackup/nesi00458/yugen/MOTS/MOTS_viromes_2018/hiseq_processing/19/Assem

#ERROR CORRECTION by BayesHammer (spades module) for Illumina 2x150bp

spades.py --meta --only-error-correction -m 580 -t $SLURM_CPUS_PER_TASK -k 33,55,77 --phred-offset 33 -1 $IN/S${SLURM_ARRAY_TASK_ID}_R1.qc.fastq.gz -2 $IN/S${SLURM_ARRAY_TASK_ID}_R2.qc.fastq.gz -o $OUT/bayes_hammer
