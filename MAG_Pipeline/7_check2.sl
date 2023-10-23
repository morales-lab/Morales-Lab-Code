#!/bin/bash
#SBATCH -J 7_check2
#SBATCH -A nesi00458
#SBATCH --time=3:00:00
#SBATCH --cpus-per-task=2
#SBATCH --ntasks=16
#SBATCH --mem=48000
#SBATCH --array=1-32,34-50
#SBATCH --profile=task

#load module
module load CheckM/1.0.13-gimkl-2018b-Python-2.7.16
module load HMMER/3.1b2-gimkl-2017a
module load prodigal/2.6.3-GCCcore-7.4.0
module load pplacer/1.1.alpha19
module load SAMtools/1.9-GCC-7.4.0


### File Pathways ###
#directory w/ bins, not files themself
BIN=/nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}/Bins
ALIGN=/nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}/Align/${SLURM_ARRAY_TASK_ID}_sorted.bam
SEQ=/nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}/Assem/spades/scaffolds.fasta
OUT=/nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}/Qual

mkdir /nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}/Qual/ssu_finder
SSU=/nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}/Qual/ssu_finder

#Index BAM files
samtools index $ALIGN


#Bin Coverage in metagenome
checkm coverage -x fa $BIN $OUT/coverage.tsv $ALIGN
checkm profile -f $OUT/${SLURM_ARRAY_TASK_ID}_profile.tsv --tab_table $OUT/coverage.tsv

cd $OUT
cat ${SLURM_ARRAY_TASK_ID}_profile.tsv|tr '\t' ','|sed "s/^/${SLURM_ARRAY_TASK_ID}_/g" > ${SLURM_ARRAY_TASK_ID}_profile.csv


#16S/18S finder
checkm ssu_finder -t 16 -x fa $SEQ $BIN $SSU

cd $SSU
cat ssu_summary.tsv|grep -v 'unbinned'|tr '\t' ','|sed "s/^/${SLURM_ARRAY_TASK_ID}_/g" > ${SLURM_ARRAY_TASK_ID}_ssu_summary.csv

