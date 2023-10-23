#!/bin/bash
#SBATCH -J 8_tax3
#SBATCH -A nesi00458
#SBATCH --time=1-00:00:00
#SBATCH --cpus-per-task=20
#SBATCH --ntasks=1
#SBATCH --mem=136000 #136Gb
#SBATCH --partition=bigmem
#SBATCH --hint=nomultithread
#SBATCH --profile=task

#load modules
module load GTDB-Tk/0.2.2-gimkl-2018b-Python-2.7.16

TAX=/nesi/nobackup/nesi00458/Soil_MAGS/TAX3
mkdir $TAX/gtdb_tk

gtdbtk classify_wf --cpu 20 --extension fa --genome_dir $TAX --out $TAX/gtdk_tk

cd $TAX/gtdk_tk

cat gtdbtk.ar122.summary.tsv|tr '\t' ',' > ar_summary.csv
cat gtdbtk.bac120.summary.tsv|tr '\t' ',' > ba_summary.csv
