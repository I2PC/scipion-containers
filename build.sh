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
DIR=""
if [ "$#" -gt 1 ]; then
    if [ -d "${1}" ]; then
        DIR="${1}"
    else
        echo "${1} does not exist".
        DIR="."
    fi
else
    DIR="."
fi

echo "OUTPUT DIR IS $DIR"

###
###
#### END OF USER CONFIGURABLE VARIABLES

echo "Preparing to build Scipion Apptainer image locally..."
echo "Getting latest version from GitHub..."
git pull

TARGET="scipion-$CONTAINER_FLAVOUR"

export APPTAINERENV_DISPLAY=$DISPLAY

echo "Compiling $CONTAINER_FLAVOUR image..."
echo "Result will be in $DIR/$TARGET.sif"
apptainer build ./tests/scipion-base.sif ./apptainer/scipion-base.def

echo "Finished."