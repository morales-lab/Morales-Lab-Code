#!/bin/bash
#SBATCH -J 1_pre_process
#SBATCH -A nesi00458
#SBATCH --time=4:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem=45000
#SBATCH --profile=task

#Load Java
module load Java

#BBTools file pathway
BB=/nesi/project/nesi00458/Tools/bbmap

#HG-19 Pathways
HG19=/nesi/project/nesi00458/Tools/hg19

#File Pathways
IN=/nesi/nobackup/nesi00458/yugen

mkdir /nesi/nobackup/nesi00458/yugen/ben_illumina
mkdir /nesi/nobackup/nesi00458/yugen/ben_illumina/Pre

TASK=/nesi/nobackup/nesi00458/yugen/ben_illumina/Pre


cd $TASK


### Clumpify: Group overlapping reads ###
$BB/clumpify.sh in1=/nesi/nobackup/nesi00458/yugen/ERR4777341_1.fastq.gz in2=/nesi/nobackup/nesi00458/yugen/ERR4777341_2.fastq.gz out1=R1_clust.fastq.gz out2=R2_clust.fastq.gz


### BBDuk: Adapter Trimming ###
$BB/bbduk.sh in1=R1_clust.fastq.gz in2=R2_clust.fastq.gz out1=R1_clean.fastq.gz out2=R2_clean.fastq.gz ref=/nesi/project/nesi00458/Tools/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tpe tbo


### BBDuk: Synthetic DNA Removal ###
#unmatch good, match bad
$BB/bbduk.sh in1=R1_clean.fastq.gz in2=R2_clean.fastq.gz out1=R1_unmatch.fastq.gz out2=R2_unmatch.fastq.gz outm1=R1_match.fastq.gz outm2=R2_match.fastq.gz ref=/nesi/project/nesi00458/Tools/bbmap/resources/phix_adapters.fa.gz k=31 hdist=1 stats=${SLURM_ARRAY_TASK_ID}_stats.txt


### BBMap: Human Contaminant Removal ###
$BB/bbmap.sh minid=0.95 maxindel=3 bwr=0.16 bw=12 quickmatch fast minhits=2 path=$HG19 qtrim=rl trimq=10 untrim -Xmx23g in1=R1_unmatch.fastq.gz in2=R2_unmatch.fastq.gz outu1=R1_merge_me.fastq.gz outu2=R2_merge_me.fastq.gz outm1=R1_human.fastq.gz outm2=R2_human.fastq.gz


### BBMerge: Merge reads by overlap and non-overlap by kmer ###
#kmer length 5 or 6 -- behave same aside from slight speed difference
$BB/bbmerge-auto.sh in1=R1_merge_me.fastq.gz in2=R2_merge_me.fastq.gz out=merged.fastq.gz outu1=unmerged_R1.fastq.gz outu2=unmerged_R2.fastq.gz t=30 prealloc rem k=5 extend2=50 ecct -Xmx38g
