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
CRYOASSESS_MODELS_DIR=/route/to/cryoasses_model_folder
# CS will work only if the container has direct access to the cryosparcm binary
# Point the container to the folder that contains the cryosparc_master folder
CRYOSPARC_HOME_DIR=/route/to/cryosparc_master_containing_folder
export CRYOSPARC_ACCOUNT="mycryosparc@email.com"
export CRYOSPARC_PASSWORD="mypassword"

# The datadir will be used to input the RAW data used for processing, ie movies/tiltseries
SCIPION_DATADIR=/route/to/your_raw_data_dir
# The projdir will house Scipion's project and all of its intermediate data
SCIPION_PROJDIR=/route/to/your_big_storage_for_projects

###
###
#### END OF USER CONFIGURABLE VARIABLES

# Do not touch below here unless you know what you are doing!

echo "Preparing to launch Scipion Container"
echo "Pulling version $CONTAINER_VERSION from branch $CONTAINER_FLAVOUR"
apptainer pull oras://rinchen.cnb.csic.es/apptainer/scipion-$CONTAINER_FLAVOUR:$CONTAINER_VERSION

echo "Launching Scipion container for $CONTAINER_FLAVOUR"
apptainer exec --nv scipion-$CONTAINER_FLAVOUR:$CONTAINER_VERSION \
--bind $CRYOSPARC_HOME_DIR:/cryosparc \
--bind $CRYOASSES_MODELS_DIR:/scipion/software/em/cryoassess_models \
--bind $SCIPION_DATADIR:/data \
--bind $SCIPION_PROJDIR:/scipion/ScipionUserData /scipion/scipion3
