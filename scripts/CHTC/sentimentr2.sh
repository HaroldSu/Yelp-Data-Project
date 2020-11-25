#!/bin/bash

# untar your R installation
tar -xzf R402.tar.gz
tar -xvf packages.tar.gz

# make sure the script will use your R installation, 
# and the working directory as its home location
export PATH=$PWD/R/bin:$PATH
export RHOME=$PWD/R
export R_LIBS=$PWD/packages

# run your script
Rscript sentimentr2.R $1 # note: the two actual command-line arguments
                         # are in myscript.sub's "arguments = " line
