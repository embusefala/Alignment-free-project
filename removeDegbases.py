#!/usr/bin/env python3

import sys, random, re
from Bio import SeqIO

input=sys.argv[1]
output=sys.argv[2]

print("Searching and replacing degenerated bases in : " + str(input) + " ...")

# Define a IUPAC nucleotide code  dict with degenerated base values
iupac={'R': ('A','G'),
'W' : ('A','T'),
'S' : ('C','G'),
'Y' : ('C','T'),
'K' : ('G','T'),
'V' : ('A','C','G'),
'M' : ('A','C'),
'B' : ('C','G','T'),
'D' : ('A','G','T'),
'H' : ('A','C','T'),
}

fasta= open(input,"r")

#Create a dict with id sequences as key and sequences as value(contig)
contig={}
for record in SeqIO.parse(fasta,"fasta"):
	contig[record.id]=record.seq


#Create a new sequence file with degenerated bases replaced by their random possible value
with open (output,"+w") as o:
	for id, seq in contig.items():
		seq = list(seq) #convert sequences to lists for replacing and reinserting degenerated bases by their values on specific indexes
		for deg in iupac:
			for i in range(len(seq)):
				if deg == seq[i]:
					seq[i] =  seq[i].replace(deg,random.choice(iupac[deg]))
		o.write(">" + id + "\n" + "".join(seq) + "\n")


print("Done")

"""
To run this script on multiple fasta files :
for i in *fasta; do python3 script.py $i sorted/$i ; done
"""

