#!/bin/bash

echo "Comparative Genome using mash"

#Set up directories
OUTPUT_GENOMES=/media/cirm_workspace/embusefala/Torulaspora_delbrueckii/results/mash/Genomes/NsRemoved/NewPYCC/s2_397_650
mkdir -p $OUTPUT_GENOMES

OUTPUT_RAW=/media/cirm_workspace/embusefala/Torulaspora_delbrueckii/results/mash/raw/m3/s20000
mkdir -p $OUTPUT_RAW

OUTPUT_CLEAN=/media/cirm_workspace/embusefala/Torulaspora_delbrueckii/results/mash/clean/m3/s20000
mkdir -p $OUTPUT_CLEAN

DATA_DIR_GENOMES=/media/cirm_data/KmerProject/Torulaspora_delbrueckii/Genomes/NsRemoved
#DATA_DIR_RAW=/media/cirm_data/KmerProject/Torulaspora_delbrueckii/raw/byStrain
#DATA_DIR_CLEAN=/media/cirm_data/KmerProject/Torulaspora_delbrueckii/clean

#Create a file list of files for all genomes
for i in  "$DATA_DIR_GENOMES"/*.fasta; do echo $i; done > $DATA_DIR_GENOMES/list.txt

kmers=($(seq 11 4 31))

echo "RUN mash ON GENOMES"
echo "Run the mash sketch to create sequence reduced representations for fast operations"

for k in "${kmers[@]}"
do 
        time /opt/mash-Linux64-v2.3/mash sketch -p 7 -l $DATA_DIR_GENOMES/list.txt -k "$k" -o $OUTPUT_GENOMES/Seqsketchs_k"$k" -s 2397650
done

echo "Compute the mash distance"
##Run the mash dist on msh files
for k in "${kmers[@]}"
do
	time /opt/mash-Linux64-v2.3/mash dist $OUTPUT_GENOMES/Seqsketchs_k"$k".msh -l $DATA_DIR_GENOMES/list.txt -t > $OUTPUT_GENOMES/pairwisDist_k"$k".tsv -v 0.05 -p 7
done

echo "RUN mash ON FASTQ RAW DATA FILES"

echo "Run the mash sketch to create sequence reduced representations for fast operations"

#for k in "${kmers[@]}"
#do
#	echo "$k"
#	mkdir -p $OUTPUT_RAW/K"$k"
#	for i in $DATA_DIR_RAW/*1.fastq.gz
#	do
#		time /opt/mash-Linux64-v2.3/mash sketch $i -k $k -o $OUTPUT_RAW/K"$k"/"$(basename $i)" -m 3 -s 20000
#	done
#done

#Paste the sketch files with mash paste
#for k in "${kmers[@]}"
#do
#	/opt/mash-Linux64-v2.3/mash paste $OUTPUT_RAW/K"$k"/Readsketchs_k"$k" $OUTPUT_RAW/K"$k"/*.msh
#done

#echo "Compute mash distance"
#Run the mash dist on msh file
#for k in "${kmers[@]}"
#do
#	echo "$k"
#	time /opt/mash-Linux64-v2.3/mash dist $OUTPUT_RAW/K"$k"/Readsketchs_k"$k".msh $OUTPUT_RAW/K"$k"/Readsketchs_k"$k".msh -t > $OUTPUT_RAW/K"$k"/pairwisDist_k"$k".tsv -v 0.05 -p 12
#done

#echo "RUN mash ON FASTQ CLEAN DATA FILES"
##Run the mash sketch to create sequence reduced representations for fast operations
#for k in "${kmers[@]}"
#do
#	echo "$k"
#	mkdir -p $OUTPUT_CLEAN/K"$k"
#	for i in  $DATA_DIR_CLEAN/*1_cleaned.fastq.gz
#	do
#		time /opt/mash-Linux64-v2.3/mash sketch $i -k $k -o $OUTPUT_CLEAN/K"$k"/"$(basename $i)" -m 3 -s 20000
#	done
#done

##Paste the sketch files with mash paste
#for k in "${kmers[@]}"
#do
#	/opt/mash-Linux64-v2.3/mash paste $OUTPUT_CLEAN/K"$k"/Readsketchs_k"$k" $OUTPUT_CLEAN/K"$k"/*.msh
#done

echo "Compute mash distance"
#Run the mash dist on msh file
#for k in "${kmers[@]}"
#do
#	echo "$k"
#	time  /opt/mash-Linux64-v2.3/mash dist $OUTPUT_CLEAN/K"$k"/Readsketchs_k"$k".msh $OUTPUT_CLEAN/K"$k"/Readsketchs_k"$k".msh -t > $OUTPUT_CLEAN/K"$k"/pairwisDist_k"$k".tsv -v 0.05 -p 12
#done
