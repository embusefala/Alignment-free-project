#!/bin/bash

echo "Running Genomic comparative with AAF on raw and clean data"

#Set up directories
OUTPUT_GENOMES=/media/cirm_workspace/embusefala/Torulaspora_delbrueckii/results/AAF/Genomes/NewPYCC
mkdir -p $OUTPUT_GENOMES

#OUTPUT_RAW=/media/cirm_workspace/embusefala/Torulaspora_delbrueckii/results/AAF/raw
#mkdir -p $OUTPUT_RAW

#OUTPUT_CLEAN=/media/cirm_workspace/embusefala/Torulaspora_delbrueckii/results/AAF/clean/n5
#mkdir -p $OUTPUT_CLEAN

##For the data
DATA_DIR_GENOMES=/media/cirm_data/KmerProject/Torulaspora_delbrueckii/Genomes/NsRemoved/AAF/

DATA_DIR_RAW=/media/cirm_data/KmerProject/Torulaspora_delbrueckii/raw/byStrain/AAF/

DATA_DIR_CLEAN=/media/cirm_data/KmerProject/Torulaspora_delbrueckii/clean/AAF/

kmers=($(seq 11 4 31))

#### L'outil cree des sous repertoires pour chaque fastq dans le repertoire ou se trouve tous les fastqs 

echo "Run AAf on genomes"

cd $OUTPUT_GENOMES

#Run the kmers count

for k in "${kmers[@]}"
do
        time python /opt/AAF/AAF20190129/aaf_phylokmer.py -k $k -t 14 -n 2 -o $OUTPUT_GENOMES/phylokmer"$k" -d $DATA_DIR_GENOMES -G 14
done

#Run the aaf distance 
for k in "${kmers[@]}"
do
	time python /opt/AAF/AAF20190129/aaf_distance.py -i $OUTPUT_GENOMES/phylokmer"$k".dat.gz -t 14 -G 14 -o $OUTPUT_GENOMES/dist"$k" -f $OUTPUT_GENOMES/phylokmer"$k".wc
done


cd $OUTPUT_RAW

echo "Run AAF on raw data"

#Run the kmers count

for k in "${kmers[@]}"
do
	time python /opt/AAF/AAF20190129/aaf_phylokmer.py -k $k -t 14 -n 2 -o $OUTPUT_RAW/phylokmer"$k" -d $DATA_DIR_RAW -G 14
done

#Run the aaf distance 
for k in "${kmers[@]}"
do
	time python /opt/AAF/AAF20190129/aaf_distance.py -i $OUTPUT_RAW/phylokmer"$k".dat.gz -t 14 -G 14 -o $OUTPUT_RAW/dist"$k" -f $OUTPUT_RAW/phylokmer"$k".wc
done

#Run the aaf tip correction only for K27

time python /opt/AAF/AAF20190129/aaf_tip.py -i $OUTPUT_RAW/dist27.tre  -k 27 --tip $OUTPUT_RAW/tip_file_test.tsv -n 2 -f $OUTPUT_RAW/phylokmer27.wc


cd $OUTPUT_CLEAN

echo "Run AAF on clean data"

#Run the kmers count
for k in "${kmers[@]}"
do

	time python /opt/AAF/AAF20190129/aaf_phylokmer.py -k $k -t 10 -n 5 -o $OUTPUT_CLEAN/phylokmer"$k" -d $DATA_DIR_CLEAN -G 10
done

#Run the aaf distance
for k in "${kmers[@]}"
do

	time python /opt/AAF/AAF20190129/aaf_distance.py -i $OUTPUT_CLEAN/phylokmer"$k".dat.gz -t 10 -G 10 -o $OUTPUT_CLEAN/dist"$k" -f $OUTPUT_CLEAN/phylokmer"$k".wc
done
