#!/bin/bash
#SBATCH -J 4_virsorter1
#SBATCH -A nesi00458
#SBATCH --time=3-0:00:00
#SBATCH --mem=40G
#SBATCH --cpus-per-task=30
#SBATCH --array=1

#load virsorter
#module purge
module load VirSorter/2.2.3-gimkl-2020a-Python-3.8.2
#module unload HMMER/3.3-GCC-9.2.0

#export
#PATH/nesi/project/nesi00458/Tools/hmmer_dev/bin:$PATH

#virsorter setup
#mkdir /nesi/nobackup/nesi00458/yugen/tmp_dir
virsorter setup -d /nesi/nobackup/nesi00458/yugen/virsorter_databases

#make directory of output
#mkdir /nesi/nobackup/nesi00458/yugen/MOTS/MOTS_viromes_2018/hiseq_processing/more_10kbp/${SLURM_ARRAY_TASK_ID}/virsorter_dramV

#File Pathways
IN=/nesi/nobackup/nesi00458/yugen/MOTS/MOTS_viromes_2018/hiseq_processing/more_10kbp \

# run virsorter2
virsorter run \
        -i $IN/virsorter_dvf_viral_combined.fa \
        -d /nesi/nobackup/nesi00458/yugen/virsorter_databases \
        -j $SLURM_CPUS_PER_TASK \
        --include-groups dsDNAphage,NCLDV,RNA,ssDNA,lavidaviridae \
        -w /nesi/nobackup/nesi00458/yugen/MOTS/MOTS_viromes_2018/hiseq_processing/more_10kbp/combined_virsorter_dramV \
        --seqname-suffix-off \
        --viral-gene-enrich-off \
        --provirus-off \
        --prep-for-dramv \
        --min-score 0.5 \
        --rm-tmpdir \
        all \
        --config LOCAL_SCRATCH=${TMPDIR:-/tmp}

