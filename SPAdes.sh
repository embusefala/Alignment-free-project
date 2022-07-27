#!/bin/bash

echo "Genome assembly"

#Set up directories

OUTPUT="/media/cirm_workspace/embusefala/Torulaspora_delbrueckii/results/SPAdes"
mkdir -p "$OUTPUT"

DATA_DIR=/media/cirm_data/KmerProject/Torulaspora_delbrueckii/clean

#Set an array with forward fastq.gz sequence files

tab_fwd=($(ls "$DATA_DIR"/*1_cleaned.fastq.gz))

#Run the assembly with SPAdes

for i in "${tab_fwd[@]}"
do
	STRAIN=$(echo ${i} | sed "s/_1_cleaned\.fastq\.gz//")
	/opt/SPAdes-3.15.3-Linux/bin/spades.py -o $OUTPUT/$(basename "${STRAIN}") --pe-1 1 ${STRAIN}_1_cleaned.fastq.gz --pe-2 1 ${STRAIN}_2_cleaned.fastq.gz
done
