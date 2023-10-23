#!/bin/bash
#SBATCH -J 4_virsorter_Novaseq
#SBATCH -A nesi00458
#SBATCH --time=3-0:00:00
#SBATCH --cpus-per-task=20
#SBATCH --mem=40G
#SBATCH --array=23

#load virsorter
module purge
module load VirSorter/2.2.3-gimkl-2020a-Python-3.8.2
module unload HMMER/3.3-GCC-9.2.0

export PATH/nesi/project/nesi00458/Tools/hmmer_dev/bin:$PATH

#virsorter setup
#mkdir /nesi/nobackup/nesi00458/yugen/tmp_dir
virsorter setup -d /nesi/nobackup/nesi00458/yugen/virsorter_databases

#make directory of output
#mkdir /nesi/nobackup/nesi00458/yugen/MOTS/Novaseq_processing/${SLURM_ARRAY_TASK_ID}/Assem/virsorter

#File Pathways
IN=/nesi/nobackup/nesi00458/yugen/MOTS/Novaseq_processing/23/Assem/spades \

# run virsorter2
virsorter run \
	-i $IN/scaffolds.fasta \
	-d /nesi/nobackup/nesi00458/yugen/virsorter_databases \
	-j $SLURM_CPUS_PER_TASK \
	--include-groups dsDNAphage,NCLDV,RNA,ssDNA,lavidaviridae \
	-w /nesi/nobackup/nesi00458/yugen/MOTS/Novaseq_processing/23/Assem/virsorter \
	--seqname-suffix-off \
	--keep-original-seq \
	--viral-gene-enrich-off \
	--provirus-off \
	--min-length 10000 \
	--min-score 0.5 \
	--rm-tmpdir \
	all \
	--config LOCAL_SCRATCH=${TMPDIR:-/tmp}
