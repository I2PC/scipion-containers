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
CONTAINER_VERSION="test-250120"
# Available flavours are: base, spa, tomo, full
CONTAINER_FLAVOUR="base"

# You will need to fill in CryoAssess form in order to get your personal copy of the models
# CRYOASSESS_MODELS_DIR=/route/to/cryoasses_model_folder
# CS will work only if the container has direct access to the cryosparcm binary
# Point the container to the folder that contains the cryosparc_master folder
CRYOSPARC_HOME_DIR=/usr/local/cryosparc3
CRYOSPARC_PROJECTS_DIR=/data/lsanchez/ScipionUserData/CS_projects
export CRYOSPARC_ACCOUNT="miceta@cnb.csic.es"
export CRYOSPARC_PASSWORD="1q2w3e4r"

# Point to your CryoAssess models folder 
#$SCIPCRYOASSESS_MODELS="/route/to/your/cryoassess_models_folder"
#$SCIPCRYOASSESS_CMD=" --bind $SCIPCRYOASSESS_MODELS:/scipion/software/em/cryoassess_models "

# Point to your PHENIX installation, as Scipion will not download the binaries
#$SCIPPHENIX_FOLDER="/route/to/your/phenix_folder"
#$SCIPPHENIX_CMD=" --bind $SCIPPHENIX_FOLDER --env $PHENIX_HOME=$SCIPPHENIX_FOLDER "


# The datadir will be used to input the RAW data used for processing, ie movies/tiltseries
SCIPION_DATADIR=/data/lsanchez
# The projdir will house Scipion's project and all of its intermediate data
SCIPION_PROJDIR=/data/lsanchez/ScipionUserData


### SLURM configuration variables
# 
# Uncomment this and modify the variables to point to your actual SLURM installation 
SCIPSLURM_HOSTSCONF=/home/lsanchez/Desktop/scipion_containers/scipion-containers/tests/hosts.conf
SCIPSLURM_BIN="/usr/bin"
SCIPSLURM_BASE=/etc/slurm-llnl
SCIPSLURM_LIB=/var/lib/slurm-llnl
SCIPSLURM_PLUGINS=/usr/lib/x86_64-linux-gnu/slurm-wlm/
# DONT TOUCH THIS!!
SCIPSLURM_JOBS=" --bind $SCIPSLURM_BIN/sbatch --bind $SCIPSLURM_BIN/srun --bind $SCIPSLURM_BIN/scancel --bind $SCIPSLURM_BIN/salloc "
SCIPSLURM_CTRL=" --bind $SCIPSLURM_BIN/squeue --bind $SCIPSLURM_BIN/sinfo --bind $SCIPSLURM_BIN/scontrol --bind $SCIPSLURM_BIN/sstat --bind $SCIPSLURM_BIN/sacct "
SCIPSLURM_CONF=" --bind $SCIPSLURM_BASE --bind $SCIPSLURM_HOSTSCONF:/scipion/config/hosts.conf "
SCIPSLURM_LIBS=" --bind $SCIPSLURM_LIB --bind $SCIPSLURM_PLUGINS "
SCIPSLURM_APPTAINER=" $SCIPSLURM_JOBS $SCIPSLURM_CTRL $SCIPSLURM_CONF $SCIPSLURM_LIBS "
#
# END OF SLURM CONFIGURATION VARIABLES
###

###
###
#### END OF USER CONFIGURABLE VARIABLES

# Do not touch below here unless you know what you are doing!

echo "Preparing to launch Scipion Container"
echo "Pulling version $CONTAINER_VERSION from branch $CONTAINER_FLAVOUR"
#apptainer pull oras://rinchen.cnb.csic.es/apptainer/scipion-$CONTAINER_FLAVOUR:$CONTAINER_VERSION

CONTAINER=/home/lsanchez/Desktop/scipion_containers/scipion-containers/tests/scipion-base.sif
LAUNCH_CMD="apptainer exec --nv --containall --env DISPLAY=$DISPLAY --bind $CRYOSPARC_HOME_DIR --env SCIPION_USER_DATA=$SCIPION_PROJDIR --bind $SCIPION_DATADIR:/data --bind $SCIPION_PROJDIR --bind /run --bind /tmp/.X11-unix --bind /etc/resolv.conf $SCIPCRYOASSESS_CMD $SCIPPHENIX_CMD $SCIPSLURM_APPTAINER $CONTAINER"

if [ "$#" -gt 0 ]; then
    echo "Launching $CONTAINER_FLAVOUR with parameters..."
    $LAUNCH_CMD /scipion/scipion3 run $@
else
    echo "Launching $CONTAINER_FLAVOUR in standalone mode..."
    echo "Launching Scipion container for $CONTAINER_FLAVOUR"
    $LAUNCH_CMD /scipion/scipion3
fi

