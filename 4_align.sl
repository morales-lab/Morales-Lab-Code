#!/bin/bash
#SBATCH -J 4_bwa
#SBATCH -A nesi00458
#SBATCH --time=1-00:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=28000
#SBATCH --ntasks=1
#SBATCH --array=60
#SBATCH --profile=task

#Load tools
module load BWA/0.7.17-gimkl-2017a
module load SAMtools/1.9-GCC-7.4.0


### File pathways ###
#Location of 'final.contigs.fa'
IN=/nesi/nobackup/nesi00458/MOTS_MAGS/${SLURM_ARRAY_TASK_ID}/Assem/spades

#Create alignment dir
mkdir /nesi/nobackup/nesi00458/MOTS_MAGS/${SLURM_ARRAY_TASK_ID}/Align
OUT=/nesi/nobackup/nesi00458/MOTS_MAGS/${SLURM_ARRAY_TASK_ID}/Align

#Cleaned reads (Pre Output)
FA=/nesi/nobackup/nesi00458/MOTS_MAGS/${SLURM_ARRAY_TASK_ID}/Pre

#Index assembly
cd $IN
bwa index scaffolds.fasta

#Align assembled contigs to original clean reads
bwa mem scaffolds.fasta $FA/R1_merge_me_${SLURM_ARRAY_TASK_ID}.fastq.gz $FA/R2_merge_me_${SLURM_ARRAY_TASK_ID}.fastq.gz > $OUT/${SLURM_ARRAY_TASK_ID}_align.sam

#Sort & convert SAM to BAM
cd $OUT

samtools sort ${SLURM_ARRAY_TASK_ID}_align.sam -O bam -o ${SLURM_ARRAY_TASK_ID}_sorted.bam

rm ${SLURM_ARRAY_TASK_ID}_align.sam
