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
CONTAINER_FLAVOURS="base spa"

###
###
#### END OF USER CONFIGURABLE VARIABLES

echo "Preparing to build Scipion Apptainer image locally..." 
echo "Getting latest version from GitHub..."
git pull
echo "System will build $CONTAINER_FLAVOURS"

DIR="./tests"

for F in $CONTAINER_FLAVOURS; do
    TARGET="scipion-$F"
    echo "Compiling $TARGET image..."
    echo "Result will be in $DIR/$TARGET.sif"
    apptainer build --force $DIR/$TARGET.sif ./apptainer/$TARGET.def
done

echo "Finished."