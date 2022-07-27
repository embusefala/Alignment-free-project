#!/usr/bin/env python3

import sys
from Bio import SeqIO

#
input=sys.argv[1]
output=sys.argv[2]

#read the fasta file
fasta= open(input,"r")

#create a contig dictionary with seq id as key and seq as value
contig={}

for record in SeqIO.parse(fasta,"fasta"):
  contig[record.id]=record.seq

#write the new fasta file by removing all N characters
with open(output,"w+") as o:
  for id,seq in contig.items():
    if "N" in seq:
      seqCleaner=seq.replace("N","\t").split()
      for i in range(len(seqCleaner)):
        o.write(">" + id + "_" + str(i+1) + "\n" + str(seqCleaner[i]) + "\n")
    else:
      o.write(">" + id + "\n" + str(seq) + "\n")

#Bash commande to run the remove process
"""for i in *.fasta; do  python3 /media/cirm_workspace/embusefala/Torulaspora_delbrueckii/scripts/removeN.py $i NsRemoved/$(basename $i) ; done"""
