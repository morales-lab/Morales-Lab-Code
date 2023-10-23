#!/bin/bash
#SBATCH -J 4_vibrant_hiseq
#SBATCH -A nesi00458
#SBATCH --time=2-0:00:00
#SBATCH --cpus-per-task=40
#SBATCH --mem=40G
#SBATCH --array=20-83

#load VIBRANT
module load VIBRANT/1.2.1-gimkl-2020a

#setup VIBRANT
#VIBRANT_setup.py
#download-db.sh

#make directory of output
#mkdir /nesi/nobackup/nesi00458/yugen/MOTS/MOTS_viromes_2018/hiseq_processing/${SLURM_ARRAY_TASK_ID}/Assem/vibrant
#OUT=/nesi/nobackup/nesi00458/yugen/MOTS/MOTS_viromes_2018/hiseq_processing/${SLURM_ARRAY_TASK_ID}/Assem/vibrant
#mkdir /nesi/nobackup/nesi00458/yugen/MOTS/Novaseq_processing/${SLURM_ARRAY_TASK_ID}/Assem/checkV_VIBRANT
OUT=/nesi/nobackup/nesi00458/yugen/MOTS/Novaseq_processing/${SLURM_ARRAY_TASK_ID}

#File Pathways
IN=/nesi/nobackup/nesi00458/yugen/MOTS/Novaseq_processing/${SLURM_ARRAY_TASK_ID}/Assem/spades \

# run VIBRANT
VIBRANT_run.py \
	-i $IN/scaffolds.fasta \
	-t $SLURM_CPUS_PER_TASK \
	-folder $OUT \
	-l 10000 \
	-d /opt/nesi/db/VIBRANT_v1.2.1_databases/databases \
