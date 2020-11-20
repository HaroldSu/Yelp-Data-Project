#!/bin/bash

#!/bin/bash

# untar your R installation
tar -xzf R402.tar.gz

# make sure the script will use your R installation, 
# and the working directory as its home location
export PATH=$PWD/R/bin:$PATH
export RHOME=$PWD/R
mkdir packages
export R_LIBS=$PWD/packages

packages="c('sentimentr','tokenizers','tidyverse','readr')"
repository="'http://mirror.las.iastate.edu/CRAN'" # cannot use "https" mirror
Rscript -e "install.packages(pkgs=$packages, repos=$repository)"
tar czf packages.tar.gz packages

# run your script
Rscript sentimentr.R $1 # note: the two actual command-line arguments
                         # are in myscript.sub's "arguments = " line
