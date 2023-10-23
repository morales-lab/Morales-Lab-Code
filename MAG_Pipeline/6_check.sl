#!/bin/bash
#SBATCH -J 6_checkm
#SBATCH -A nesi00458
#SBATCH --time=1:00:00
#SBATCH --cpus-per-task=2
#SBATCH --ntasks=16
#SBATCH --mem=48000
#SBATCH --array=1
#SBATCH --profile=task
#SBATCH -o /nesi/nobackup/nesi00458/Soil_MAGS/checkm/checkm_%a.out

#ENSURE THE checkm DIRECTORY FOR SLURM OUTPUT HAS BEEN CREATED

#load module
module load CheckM/1.0.13-gimkl-2018b-Python-2.7.16
module load HMMER/3.1b2-gimkl-2017a
module load prodigal/2.6.3-GCCcore-7.4.0
module load pplacer/1.1.alpha19

### File Pathways ###
#directory w/ bins, not files themself
IN=/nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}/Bins

mkdir /nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}/Qual
OUT=/nesi/nobackup/nesi00458/Soil_MAGS/${SLURM_ARRAY_TASK_ID}/Qual


#Bin Quality Assessment

checkm lineage_wf  -t 16 -x fa $IN $OUT
