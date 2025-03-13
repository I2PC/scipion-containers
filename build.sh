#!/bin/bash

# Scipion Containers launcher script for end users and system administrators
# Authors:
#   Mikel Iceta @ CNB-CSIC - miceta@cnb.csic.es
#   Lola Sánchez @ CNB-CSIC - md.sanchez@cnb.csic.es
#

#### USER CONFIGURABLE VARIABLES
###
###

# Available flavours are: base, spa
CONTAINER_FLAVOURS="base"

###
###
#### END OF USER CONFIGURABLE VARIABLES

echo "Preparing to build Scipion Apptainer image locally..." 
echo "Getting latest version from GitHub..."
git pull
echo "System will build $CONTAINER_FLAVOURS"

for F in $CONTAINER_FLAVOURS; do
    TARGET="scipion-$F"
    echo "Compiling $TARGET image..."
    echo "Result will be in $TARGET.sif"
    APPTAINERENV_DISPLAY=$DISPLAY apptainer build --nv --force $TARGET.sif /home/lsanchez/Desktop/scipion_containers/scipion-containers/apptainer/$TARGET.def
done

echo "Finished."