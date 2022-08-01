#!/bin/bash

echo "Comparitive genomic with kSNP3"

#Set up directories
OUTPUT_GENOMES=/media/cirm_workspace/embusefala/Torulaspora_delbrueckii/results/kSNP/Genomes/NewPYCC
mkdir -p $OUTPUT_GENOMES

OUTPUT_RAW=/media/cirm_workspace/embusefala/Torulaspora_delbrueckii/results/kSNP/raw/NewPYCC
mkdir -p $OUTPUT_RAW

OUTPUT_CLEAN=/media/cirm_workspace/embusefala/results/kSNP/clean
mkdir -p $OUTPUT_CLEAN

#Data directories
DATA_DIR_GENOMES=/media/cirm_data/KmerProject/Torulaspora_delbrueckii/Genomes/NsRemoved

DATA_DIR_RAW=/media/cirm_workspace/embusefala/Torulaspora_delbrueckii/data/raw/kSNPdata

DATA_DIR_CLEAN=/media/cirm_workspace/embusefala/data/clean/kSNPdata

#Create a list file of path files and genome ID separated by tab
#For all genomes
for i in "$DATA_DIR_GENOMES"/*.fasta; do echo -e $i"\t"$(basename "$i" .fasta); done > $DATA_DIR_GENOMES/list.txt

#For raw data
for i in "$DATA_DIR_RAW"/*.fasta; do echo -e $i"\t"$(basename "$i" _1.fasta); done > $DATA_DIR_RAW/list.txt

#For clean data
for i in "$DATA_DIR_CLEAN"/*.fasta; do echo -e $i"\t"$(basename "$i" _1.fasta); done > $DATA_DIR_CLEAN/list.txt


#Set up an array for k-mers sizes
kmers=($(seq 11 4 31))

echo -e Run kSNP on genomes"\n"

for k in "${kmers[@]}"
do
        mkdir -p $OUTPUT_GENOMES/K"$k"
        echo -e Running kSNP3 with K$k"\n"
        time /home/embusefala/kSNP3.1_Linux_package/kSNP3/kSNP3 -in $DATA_DIR_GENOMES/list.txt -k $k -outdir $OUTPUT_GENOMES/K"$k" -CPU 12 -NJ -vcf
        echo "K"$k" end"
done

echo -e Run kSNP on raw data"\n"


for k in "${kmers[@]}"
do
	mkdir -p $OUTPUT_RAW/K"$k"
	echo -e Running kSNP3 with K$k"\n"
	time /home/embusefala/kSNP3.1_Linux_package/kSNP3/kSNP3 -in $DATA_DIR_RAW/list.txt -k $k -outdir $OUTPUT_RAW/K"$k" -CPU 16 -NJ -vcf
	echo "K"$k" end"
done


echo -e Run kSNP on clean data"\n"

for k in "${kmers[@]}"
do
	mkdir -p $OUTPUT_CLEAN/K"$k"
	echo -e Running kSNP3 with K$k"\n"
	time /home/embusefala/kSNP3.1_Linux_package/kSNP3/kSNP3 -in $DATA_DIR_CLEAN/list.txt -k $k -outdir $OUTPUT_CLEAN/K"$k" -CPU 16 -NJ -vcf
	echo "K"$k" end"
done
