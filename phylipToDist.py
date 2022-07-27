#!/usr/bin/env python3

import os
from os import sep
import pandas as pd
import subprocess
import csv
import sys

input=sys.argv[1]
print("Converting phylip file (s) to pairwise distance matrix tsv file (s) ...")
print(".......... " + str(input) + " ..........")

# Delete the first line of the phylip file with sed command and redirect the output in temporary file
sed="sed \"1d\" " + input + " > /tmp/tab.tab"
subprocess.call(sed, shell=True)

# Read the temporary file as a pandas 
phylip =pd.read_csv("/tmp/tab.tab", sep='\t', header=None,index_col=0)

# Delete the index name (0)
phylip.index.name=None

# Create the dist matrix and store it in a tsv file
dist=phylip.set_axis(phylip.index, axis=1)
dist.to_csv(os.path.splitext(str(input))[0]+".tsv",sep="\t")

subprocess.call("rm /tmp/tab.tab", shell=True)

print("Done")
