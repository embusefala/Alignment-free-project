#!/bin/bash

#Set up directories

ref=/media/cirm_data/KmerProject/Torulaspora_delbrueckii/Genomes

OUTPUT=/media/cirm_data/KmerProject/Torulaspora_delbrueckii/clean/decont
mkdir -p $OUTPUT

DATA_DIR=/media/cirm_data/KmerProject/Torulaspora_delbrueckii/clean


#set an array for fastq sequence file in data directory

tab_fwd=($(ls "$DATA_DIR"/NRRL_Y-50541_1_cleaned.fastq.gz))

#Run bwa mem alignement

for i in "${tab_fwd[@]}"
do
        STRAIN=$(echo ${i} | sed "s/_1_cleaned\.fastq\.gz//")
	#Run bwa mem alignment
	bwa index $ref/CBS_1146.fasta
        bwa mem -M -t 16 $ref/CBS_1146.fasta ${STRAIN}_1_cleaned.fastq.gz ${STRAIN}_2_cleaned.fastq.gz > $OUTPUT/$(basename ${STRAIN}_align.pe.sam)
	
	#Convert sam file to bam file and Retrieve reads that mapped on reference and remove secondary alignment
	samtools view -bS -f 1 -F 12 $OUTPUT/$(basename ${STRAIN}_align.pe.sam) > $OUTPUT/$(basename ${STRAIN}_filt_align.pe.bam)

	#Sort bam files by query name
	samtools sort -n -o $OUTPUT/$(basename ${STRAIN}_sort.qr_align.pe.bam) $OUTPUT/$(basename ${STRAIN}_filt_align.pe.bam)
	
	#Convert bam file to fastq files with bedtools
	bedtools bamtofastq -i $OUTPUT/$(basename ${STRAIN}_sort.qr_align.pe.bam) -fq $OUTPUT/$(basename ${STRAIN}_1.decont.fastq) -fq2 $OUTPUT/$(basename ${STRAIN}_2.decont.fastq)
done
