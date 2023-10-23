Code for running metagenomes against Chris Greening Databases.

First you must create diamond database file for all Greening genes:
# creating a diamond-formatted database file
./diamond makedb --in reference.fasta -d reference

Run sequences through prodigal
