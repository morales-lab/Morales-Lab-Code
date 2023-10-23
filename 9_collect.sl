#!/bin/bash
#SBATCH -J 9_collect
#SBATCH -A nesi00458
#SBATCH --time=1:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --array=1-32,34-50

#File pathways
IN=/nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}

AL=/nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}/Align
BIN=/nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}/Bins
PRE=/nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}/Pre
QUA=/nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}/Qual

AS=/nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}/Assem/spades



mkdir /nesi/nobackup/nesi00458/Soil_MAGS_transfer/${SLURM_ARRAY_TASK_ID}
OUT=/nesi/nobackup/nesi00458/Soil_MAGS_transfer/${SLURM_ARRAY_TASK_ID}





cd $IN

mv $AL $OUT
mv $BIN $OUT
mv $PRE $OUT
mv $QUA $OUT

cd $AS

mv scaffolds.fasta ${SLURM_ARRAY_TASK_ID}_scaffolds.fasta
mv ${SLURM_ARRAY_TASK_ID}_scaffolds.fasta $OUT
