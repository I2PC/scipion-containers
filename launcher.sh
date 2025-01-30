#!/bin/bash

# Scipion Containers launcher script for end users and system administrators
# Authors:
#   Mikel Iceta @ CNB-CSIC - miceta@cnb.csic.es
#   Lola Sánchez @ CNB-CSIC - md.sanchez@cnb.csic.es
#

#### USER CONFIGURABLE VARIABLES
###
###

# You can check all existing versions of the images in our GitHub page. latest is recommended.
CONTAINER_VERSION="latest"
# Available flavours are: base, spa, tomo, full
CONTAINER_FLAVOUR="spa"

# You will need to fill in CryoAssess form in order to get your personal copy of the models
export CRYOASSESS_MODELS_DIR=/route/to/cryoasses_model_folder

# CS will work only if the container has direct access to the cryosparcm binary
# Point the container to the folder that contains the cryosparc_master folder
export CRYOSPARC_ACCOUNT="mycryosparc@email.com"
export CRYOSPARC_PASSWORD="mypassword"
export CRYOSPARC_HOME="/route/to/cryosparc_master_containing_folder"
export CRYO_PROJECTS_DIR="/route/to/cryosparc_scipion_projects_folder"

# SCIPION project folder configuration
export SCIPION_USER_DATA="/path/to/scipion_project_storage"
export SCIPION_LOGS="$SCIPION_USER_DATA/logs"
export SCIPION_LOG="$SCIPION_LOGS/scipion.log"
export SCIPION_TESTS_OUTPUT="$SCIPION_USER_DATA/Tests"

# The datadir will be used to input the RAW data used for processing, ie movies/tiltseries
RAW_DATADIR=/route/to/your_raw_data_dir

###
###
#### END OF USER CONFIGURABLE VARIABLES

# Do not touch below here unless you know what you are doing!

echo "Preparing to launch Scipion Container"
echo "Pulling version $CONTAINER_VERSION from branch $CONTAINER_FLAVOUR"
apptainer pull oras://rinchen.cnb.csic.es/apptainer/scipion-$CONTAINER_FLAVOUR:$CONTAINER_VERSION

echo "Launching Scipion container for $CONTAINER_FLAVOUR"
apptainer exec --nv \
--bind $CRYOSPARC_HOME \
--bind $CRYO_PROJECTS_DIR \
--bind $SCIPION_USER_DATA \
--bind $RAW_DATADIR \
#--bind $CRYOASSES_MODELS_DIR \
scipion-${CONTAINER_FLAVOUR}_${CONTAINER_VERSION}.sif \
/scipion/scipion3
