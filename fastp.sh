#!/bin/bash

echo 'Trimming'

#Set up directories

OUTPUT=/media/cirm_data/KmerProject/Torulaspora_delbrueckii/clean/
mkdir -p "$OUTPUT"

DATA_DIR=/media/cirm_data/KmerProject/Torulaspora_delbrueckii/raw/byStrain/

#Set up a array with forward fastq.gz sequence files

tab_fwd=($(ls "$DATA_DIR"/*_1.fastq.gz))


#Run the trimming with fastp tool
for i in "${tab_fwd[@]}"
do
	STRAIN=$(echo ${i} | sed "s/_1\.fastq\.gz//")
	fastp -i ${STRAIN}_1.fastq.gz -I ${STRAIN}_2.fastq.gz -o $OUTPUT/$(basename "${STRAIN}_1.fastq.gz" .fastq.gz)_cleaned.fastq.gz -O $OUTPUT/$(basename "${STRAIN}_2.fastq.gz" .fastq.gz)_cleaned.fastq.gz -w 20 -l 50 -h $OUTPUT/$(basename "${STRAIN}_1.fastq.gz" _1.fastq.gz).html -j $OUTPUT/$(basename "${STRAIN}_1.fastq.gz" _1.fastq.gz).json
done
