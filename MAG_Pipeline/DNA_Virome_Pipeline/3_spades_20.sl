#!/bin/bash
#SBATCH -J 3_assem_hiseq
#SBATCH -A nesi00458
#SBATCH --time=3:00:00
#SBATCH --cpus-per-task=20
#SBATCH --mem=300G
#SBATCH --array=14

#load spades
module load SPAdes/3.15.4-gimkl-2022a-Python-3.10.5


#File pathways
IN=/nesi/nobackup/nesi00458/yugen/MOTS/MOTS_viromes_2018/hiseq_processing/${SLURM_ARRAY_TASK_ID}/Assem/bayes_hammer1/corrected
OUT=/nesi/nobackup/nesi00458/yugen/MOTS/MOTS_viromes_2018/hiseq_processing/${SLURM_ARRAY_TASK_ID}/Assem


#ASSEMBLE by metaSPAdes for Illumina 2x150bp
metaspades.py --only-assembler -t 20 -m 290 -k 21,33,55,77 --phred-offset 33 -1 $IN/S${SLURM_ARRAY_TASK_ID}_forward_paired.fq.00.0_0.cor.fastq.gz -2 $IN/S${SLURM_ARRAY_TASK_ID}_reverse_paired.fq.00.0_0.cor.fastq.gz -s $IN/S${SLURM_ARRAY_TASK_ID}_forward_unpaired.fq.00.0_1.cor.fastq.gz -s S${SLURM_ARRAY_TASK_ID}_reverse_unpaired.fq.00.0_2.cor.fastq.gz -o $OUT/spades1
