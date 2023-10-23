#!/bin/bash
#SBATCH -J dia_bins
#SBATCH -A nesi00458
#SBATCH --time=4:00:00     
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12

############## USER INPUTS ##############
#Dataset = Soil or MOTS
DATA=MOTS_bins
#Group = Alt_e_acceptor, Alt_e_donor, Carbon_fix, Nitrogen, Phototrophy, Respiration, Sulfur, Trace_Gas
GRP=Phototrophy
#Gene
TAG=RHO


# load in modules
module load DIAMOND/2.0.6-GCC-9.2.0


#Enter the Diamond database pathways (do not include .dmnd)
DB=/nesi/project/nesi00458/DB/Greening/${GRP}/${TAG}


##FILE PATHWAYS
#Input
IN=/nesi/nobackup/nesi00458/yugen/MOTS/Novaseq_processing/bins
#Output
DONE=/nesi/nobackup/nesi00458/yugen/MOTS/Novaseq_processing/bins/output/${DATA}_dia
FIN=/nesi/nobackup/nesi00458/yugen/MOTS/Novaseq_processing/bins/output/${DATA}_dia/${GRP}

mkdir $FIN/${TAG}
OUT=$FIN/${TAG}

#Intermediate blast directory
mkdir $OUT/blast
BLAST=$OUT/blast




####### Diamond BLAST #######

cd $IN

#Perform Diamond BLAST
for f in *.fa
do
a=$(echo $f|awk -F '.' '{print $1"."$2}')
diamond blastp -d $DB -q $f -a $BLAST/${a} -k 1
done

cd $BLAST

#Convert output to m8 file
for f in *.daa
do
a=$(echo $f|awk -F '.' '{print $1"."$2}')
diamond view -a $f -o ${a}.m8
done

#Filter results into a master document
#$3 = % ID, $4 = length
for f in *.m8
do
a=$(echo $f|awk -F '.' '{print $1"."$2}'|awk -F '_' '{print $2}')
b=$(echo $f|awk -F '_' '{print $1}')
cat $f | awk '{if ($3 >= 50 && $4 >= 40) print $0}'|sed "s/^/${b}_${a},${b},${a},/g"|tr '\t' ',' >> $DONE/${GRP}_${TAG}_${DATA}_bins.csv
done












