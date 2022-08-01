import os, subprocess, glob, json
from collections import defaultdict

#Retrieve the kmer frequency cutoffs from the kat json files
#Load all of the files
jFiles = glob.iglob("/media/cirm_workspace/embusefala/results/kat/raw/K27/*.json")

#Create a dict that will contain strain names and their cutoff false kmer frequencies
dfalseKmers = defaultdict(int)


for jsonfi in jFiles:
    strain=os.path.basename(jsonfi).split(".")[0]
    file=open(jsonfi)
    jFi=json.load(file)
    dfalseKmers[strain]=jFi['global_minima']['freq']

#Set up directories
fastqFiles = glob.iglob("/media/cirm_data/KmerProject/Torulaspora_delbrueckii/raw/byStrain/*_1.fastq.gz")

output = "/media/cirm_workspace/embusefala/results/mash/raw/falseKmerFilt/K27/freq_1/" 

for fileJ in fastqFiles:
	fiName = os.path.basename(fileJ).split(".")[0]
	for strain, freq in dfalseKmers.items():
		if strain + "_1" == fiName:
			#mash = "mash sketch " + file + " -k 19 -o " + output + dStrain + " -m " + str(freq) + " -s 20000"
			mashSketch = "time parallel \'/opt/mash-Linux64-v2.3/mash sketch {} -k 27 -o " + output + strain + " -m " + str(freq) + " -s 20000\' ::: " + fileJ
			subprocess.call("mkdir -p " + output, shell=True)
			subprocess.call(mashSketch, shell=True)

# Paste the mash files in one file
mashPaste = "time /opt/mash-Linux64-v2.3/mash paste " + output + "Readsketchs " + output + "*.msh"
subprocess.call(mashPaste,shell=True)

# Run the mash distance
mashDist = "time /opt/mash-Linux64-v2.3/mash dist " + output + "Readsketchs.msh " + output + "Readsketchs.msh -t > " + output + "pairwisDist.tsv"
subprocess.call(mashDist, shell=True)
