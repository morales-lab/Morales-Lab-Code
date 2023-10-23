#!/bin/bash
#SBATCH -J 5_bin
#SBATCH -A nesi00458
#SBATCH --time=12:00:00
#SBATCH --cpus-per-task=4
#SBATCH --ntasks=8
#SBATCH --mem=48000
#SBATCH --array=1-32,34-50
#SBATCH --profile=task

#load module
module load MetaBAT/2.13-GCC-7.4.0


### File Pathways ###
#Dir with alignment output (.bam)
AL=/nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}/Align

#Dir with 'scaffolds.fasta'
AS=/nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}/Assem/spades

mkdir /nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}/Bins
OUT=/nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}/Bins

#Generate depth file from BAM file (summarive depth of each contig)
#BAMS MUST BE SORTED FIRST!!!!!!!!!!!!!
cd $AL

jgi_summarize_bam_contig_depths --outputDepth ${SLURM_ARRAY_TASK_ID}_depth.txt ${SLURM_ARRAY_TASK_ID}_sorted.bam

#BIN
metabat2 -i $AS/scaffolds.fasta -a ${SLURM_ARRAY_TASK_ID}_depth.txt -o $OUT/bin --unbinned -t 8
