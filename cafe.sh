#!/bin/bash

echo "Running CAFE with different distance measures"

#Set up directories
OUTPUT_GENOMES=/media/cirm_workspace/embusefala/results/cafe/Genomes/NewPYCC
mkdir -p $OUTPUT_GENOMES

#OUTPUT_RAW=/media/cirm_workspace/embusefala/results/cafe/raw/
#mkdir -p $OUTPUT_RAW

#OUTPUT_CLEAN=/media/cirm_workspace/embusefala/results/cafe/clean/
#mkdir -p $OUTPUT_CLEAN

DATA_DIR_GENOMES=/media/cirm_data/KmerProject/Torulaspora_delbrueckii/Genomes/NsRemoved
#DATA_DIR_RAW=/media/cirm_data/KmerProject/Torulaspora_delbrueckii/raw/byStrain
#DATA_DIR_CLEAN=/media/cirm_data/KmerProject/Torulaspora_delbrueckii/clean

#Run cafe on Genomes
#create a directory to save k-mer binary files
mkdir -p $OUTPUT_GENOMES/binKmers

#K11
time /opt/CAFE-1.0.0/code/cafe -D D2shepp,D2star,Yule -F $DATA_DIR_GENOMES -K 11 -R -S $OUTPUT_GENOMES/binKmers -O $OUTPUT_GENOMES/distK11 -T phylip


#K13
time /opt/CAFE-1.0.0/code/cafe -D D2star,D2shepp,Yule -F $DATA_DIR_GENOMES -K 13 -R -S $OUTPUT_GENOMES/binKmers -O $OUTPUT_GENOMES/distK13 -T phylip


echo "Run cafe on raw data"
#Retrieve files separated with comma
#for i in $DATA_DIR_RAW/*1.fastq.gz; do file1=`echo $file1$i","`; done

#Create a directory to save kmer binary files
#mkdir -p $OUTPUT_RAW/binKmers

#time /opt/CAFE-1.0.0/code/cafe -D D2star,D2shepp,D2,Eu -I $file1 -K 13 -L 2 -R -S $OUTPUT_RAW/binKmers -O $OUTPUT_RAW/distK13 -T phylip

echo "Run cafe on clean data"
#Retrieve files separated with comma
#for i in $DATA_DIR_CLEAN/*1_cleaned.fastq.gz; do file2=`echo $file2$i","`; done

#Create a directory to save kmer binary files
#mkdir -p $OUTPUT_CLEAN/binKmers

#time /opt/CAFE-1.0.0/code/cafe -D D2star,D2shepp,D2,Eu -I $file2 -K 13 -L 2 -R -S $OUTPUT_CLEAN/binKmers -O $OUTPUT_CLEAN/distK13 -T plain,phylip
