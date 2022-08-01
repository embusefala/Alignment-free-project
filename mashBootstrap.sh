#!/bin/bash

echo "Comparative Genome using mash"
echo "Testing different mash hashing seeds and sketch to test the robustness of phylogeny"

#Set up directories
OUTPUT_GENOMES=/media/cirm_workspace/embusefala/Torulaspora_delbrueckii/results/mash/Genomes/NsRemoved/NewPYCC/BranchSupport
mkdir -p $OUTPUT_GENOMES

DATA_DIR_GENOMES=/media/cirm_data/KmerProject/Torulaspora_delbrueckii/Genomes/NsRemoved


#Create a file list of files
#For all genomes
for i in  "$DATA_DIR_GENOMES"/*.fasta; do echo $i; done > $DATA_DIR_GENOMES/list.txt

#Set up the seed array (possible seeds for mash sketch)
seeds=($(shuf -i 0-4294967296 -n1000))

#set up the sketch sizes array
sketchs=(1000 5000 10000 20000 100000 200000 500000)

#kmer sizes
kmers=($(seq 11 4 31))


#Run mash to compute main distance matrices : seed = 42 (mash default parameter value)
for s in "${sketchs[@]}"
do
	mkdir -p $OUTPUT_GENOMES/$s/
	for k in "${kmers[@]}"
	do
		mkdir -p $OUTPUT_GENOMES/$s/42
		#Run the mash sketch
                time /opt/mash-Linux64-v2.3/mash sketch -p 12 -l $DATA_DIR_GENOMES/list.txt -k $k -o $OUTPUT_GENOMES/$s/42/Seqsketchs_k"$k" -s $s -S 42
                #Run the mash distance
                time /opt/mash-Linux64-v2.3/mash dist $OUTPUT_GENOMES/$s/42/Seqsketchs_k"$k".msh -l $DATA_DIR_GENOMES/list.txt -t > $OUTPUT_GENOMES/$s/42/pairwisDist_k"$k".tsv -v 0.05 -p 9
	done
done

#Run mash to compute bootstrap distance matrices
for s in "${sketchs[@]}"
do
	mkdir -p $OUTPUT_GENOMES/$s/
	for i in "${seeds[@]}"
	do
		for k in "${kmers[@]}"
		do
			mkdir -p $OUTPUT_GENOMES/$s/$i
			#Run the mash sketch
			time /opt/mash-Linux64-v2.3/mash sketch -p 14 -l $DATA_DIR_GENOMES/list.txt -k $k -o $OUTPUT_GENOMES/$s/$i/Seqsketchs_k"$k" -s $s -S $i
			#Run the mash distance
			time /opt/mash-Linux64-v2.3/mash dist $OUTPUT_GENOMES/$s/$i/Seqsketchs_k"$k".msh -l $DATA_DIR_GENOMES/list.txt -t > $OUTPUT_GENOMES/$s/$i/pairwisDist_k"$k".tsv -v 0.05 -p 14
		done
	done
done

"See the compute_mashNodeSupport.sh script"
