#!/bin/bash
#SBATCH -J 1_pre_process
#SBATCH -A nesi00458
#SBATCH --time=4:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem=45000
#SBATCH --array=60
#SBATCH --profile=task

#Load Java
module load Java

#BBTools file pathway
BB=/nesi/project/nesi00458/Tools/bbmap

#HG-19 Pathways
HG19=/nesi/project/nesi00458/Tools/hg19

#File Pathways
IN=/nesi/nobackup/nesi00458/MOTS_60

mkdir /nesi/nobackup/nesi00458/MOTS_Nova_Clean/${SLURM_ARRAY_TASK_ID}
mkdir /nesi/nobackup/nesi00458/MOTS_Nova_Clean/${SLURM_ARRAY_TASK_ID}/Pre

TASK=/nesi/nobackup/nesi00458/MOTS_Nova_Clean/${SLURM_ARRAY_TASK_ID}/Pre


### Combine L1 w/ L2 ###
cd $IN
cat RK-2013-*_S${SLURM_ARRAY_TASK_ID}_L001_R1_001.fastq.gz RK-2013-*_S${SLURM_ARRAY_TASK_ID}_L002_R1_001.fastq.gz >> $TASK/R1_${SLURM_ARRAY_TASK_ID}.fastq.gz
cat RK-2013-*_S${SLURM_ARRAY_TASK_ID}_L001_R2_001.fastq.gz RK-2013-*_S${SLURM_ARRAY_TASK_ID}_L002_R2_001.fastq.gz >> $TASK/R2_${SLURM_ARRAY_TASK_ID}.fastq.gz


cd $TASK


### Clumpify: Group overlapping reads ###
$BB/clumpify.sh in1=R1_${SLURM_ARRAY_TASK_ID}.fastq.gz in2=R2_${SLURM_ARRAY_TASK_ID}.fastq.gz out1=R1_clust_${SLURM_ARRAY_TASK_ID}.fastq.gz out2=R2_clust_${SLURM_ARRAY_TASK_ID}.fastq.gz


### BBDuk: Adapter Trimming ###
$BB/bbduk.sh in1=R1_clust_${SLURM_ARRAY_TASK_ID}.fastq.gz in2=R2_clust_${SLURM_ARRAY_TASK_ID}.fastq.gz out1=R1_clean_${SLURM_ARRAY_TASK_ID}.fastq.gz out2=R2_clean_${SLURM_ARRAY_TASK_ID}.fastq.gz ref=/nesi/project/nesi00458/Tools/bbmap/resources/adapters.fa ktrim=r k=23 mink=11 hdist=1 tpe tbo


### BBDuk: Synthetic DNA Removal ###
#unmatch good, match bad
$BB/bbduk.sh in1=R1_clean_${SLURM_ARRAY_TASK_ID}.fastq.gz in2=R2_clean_${SLURM_ARRAY_TASK_ID}.fastq.gz out1=R1_unmatch_${SLURM_ARRAY_TASK_ID}.fastq.gz out2=R2_unmatch_${SLURM_ARRAY_TASK_ID}.fastq.gz outm1=R1_match_${SLURM_ARRAY_TASK_ID}.fastq.gz outm2=R2_match_${SLURM_ARRAY_TASK_ID}.fastq.gz ref=/nesi/project/nesi00458/Tools/bbmap/resources/phix_adapters.fa.gz k=31 hdist=1 stats=${SLURM_ARRAY_TASK_ID}_stats.txt


### BBMap: Human Contaminant Removal ###
$BB/bbmap.sh minid=0.95 maxindel=3 bwr=0.16 bw=12 quickmatch fast minhits=2 path=$HG19 qtrim=rl trimq=10 untrim -Xmx23g in1=R1_unmatch_${SLURM_ARRAY_TASK_ID}.fastq.gz in2=R2_unmatch_${SLURM_ARRAY_TASK_ID}.fastq.gz outu1=R1_merge_me_${SLURM_ARRAY_TASK_ID}.fastq.gz outu2=R2_merge_me_${SLURM_ARRAY_TASK_ID}.fastq.gz outm1=R1_human_${SLURM_ARRAY_TASK_ID}.fastq.gz outm2=R2_human_${SLURM_ARRAY_TASK_ID}.fastq.gz


### BBMerge: Merge reads by overlap and non-overlap by kmer ###
#kmer length 5 or 6 -- behave same aside from slight speed difference
$BB/bbmerge-auto.sh in1=R1_merge_me_${SLURM_ARRAY_TASK_ID}.fastq.gz in2=R2_merge_me_${SLURM_ARRAY_TASK_ID}.fastq.gz out=merged_${SLURM_ARRAY_TASK_ID}.fastq.gz outu1=unmerged_${SLURM_ARRAY_TASK_ID}_R1.fastq.gz outu2=unmerged_${SLURM_ARRAY_TASK_ID}_R2.fastq.gz t=30 prealloc rem k=5 extend2=50 ecct -Xmx38g



#Remove unnecessary files
rm R1_${SLURM_ARRAY_TASK_ID}.fastq.gz R2_${SLURM_ARRAY_TASK_ID}.fastq.gz
rm R1_clust_${SLURM_ARRAY_TASK_ID}.fastq.gz R2_clust_${SLURM_ARRAY_TASK_ID}.fastq.gz
######rm R1_clean_${SLURM_ARRAY_TASK_ID}.fastq.gz R2_clean_${SLURM_ARRAY_TASK_ID}.fastq.gz
rm R1_unmatch_${SLURM_ARRAY_TASK_ID}.fastq.gz R2_unmatch_${SLURM_ARRAY_TASK_ID}.fastq.gz
rm R1_match_${SLURM_ARRAY_TASK_ID}.fastq.gz R2_match_${SLURM_ARRAY_TASK_ID}.fastq.gz
