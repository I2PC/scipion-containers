#!/bin/bash

# Scipion Containers launcher script for end users and system administrators
# Authors:
#   Mikel Iceta @ CNB-CSIC - miceta@cnb.csic.es
#   Lola Sánchez @ CNB-CSIC - md.sanchez@cnb.csic.es
#

#### USER CONFIGURABLE VARIABLES
###
###

# Available flavours are: base, spa, tomo, full
CONTAINER_FLAVOUR="spa"

###
###
#### END OF USER CONFIGURABLE VARIABLES

echo "Preparing to build Scipion Apptainer image locally..."
echo "Getting latest version from GitHub..."
git pull

echo "Compiling $CONTAINER_FLAVOUR image..."
TARGET="scipion-$CONTAINER_FLAVOUR"
apptainer build $TARGET.sif $TARGET.def

echo "Finished."