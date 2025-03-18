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
# You can build multiple containers by adding them separated by a space
# For example, CONTAINER_FLAVOURS="base spa"
# Remember that you will need base for any container
CONTAINER_FLAVOURS="base spa"

### CLUSTER SPECIFIC
# You can add your cluster-specific commands here
#PREPARE_ENV="module load XXX"
PREPARE_SCREEN="xhost +"
CLUSTER_PREP="$PREPARE_ENV $PREPARE_SCREEN"
$CLUSTER_PREP

###
###
#### END OF USER CONFIGURABLE VARIABLES

echo "Preparing to build Scipion Apptainer image locally..." 
echo "Getting latest version from GitHub..."
git pull
echo "System will build $CONTAINER_FLAVOURS"

for F in $CONTAINER_FLAVOURS; do
    TARGET="apptainer-$F"
    echo "Compiling $TARGET image..."
    echo "Result will be in ./build/$TARGET.sif"
    APPTAINERENV_DISPLAY=$DISPLAY apptainer build --nv --force ./build/$TARGET.sif ./apptainer/$TARGET.def
done

echo "Finished."