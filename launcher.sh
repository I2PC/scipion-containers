#!/bin/bash

# Scipion Containers launcher script for end users and system administrators
# Authors:
#   Mikel Iceta @ CNB-CSIC - miceta@cnb.csic.es
#   Lola Sánchez @ CNB-CSIC - md.sanchez@cnb.csic.es
#   Irene Sánchez @ CNB-CSIC - isanchez@cnb.csic.es
#

#### USER CONFIGURABLE VARIABLES
###
###

### CONTAINER VERSION AND FLAVOUR
# You can check all existing versions of the images in our GitHub page. 
# "latest" is always the recommended stable image.
CONTAINER_VERSION="latest"
# Available flavours are: base, spa, tomo, full
CONTAINER_FLAVOUR="spa"
### END #######################################################################

### CLUSTER SPECIFIC
# You can add your cluster-specific commands here
#PREPARE_ENV="module load XXX"
$PREPARE_ENV
PREPARE_SCREEN="xhost + "
$PREPARE_SCREEN
# CLUSTER END
### END #######################################################################


### CRYOSPARC
# CS will work only if the container has direct access to the cryosparcm binary
# Point the container to the folder that contains the cryosparc_master folder
export CRYOSPARC_HOME="/route/to/cryosparc_folder"
export CRYOSPARC_PROJECTS_DIR="/route/to/cs_projects"
export CRYOSPARC_USER="email@something.com"
export CRYOSPARC_PASSWORD="password"

# UNCOMMENT THIS LINE WHEN USING CRYOSPARC
#SCIPCRYOSPARC_CMD=" --bind $CRYOSPARC_HOME --bind $CRYOSPARC_PROJECTS_DIR --env CRYOSPARC_HOME=$CRYOSPARC_HOME --env CRYOSPARC_USER=$CRYOSPARC_USER --env CRYOSPARC_PASSWORD=$CRYOSPARC_PASSWORD "
### CRYOSPARC END
### END #######################################################################


### CRYOASSESS
# Point to your CryoAssess models folder 
$SCIPCRYOASSESS_MODELS="/route/to/your/cryoassess_models_folder"

# UNCOMMENT THIS LINE WHEN USING CRYOASSESS
#$SCIPCRYOASSESS_CMD=" --bind $SCIPCRYOASSESS_MODELS:/scipion/software/em/cryoassess_models "
### CRYOASSESS END
### END #######################################################################


### PHENIX
# Point to your PHENIX installation, as Scipion will not download the binaries
SCIPPHENIX_FOLDER="/route/to/your/phenix_folder"

# UNCOMMENT THIS LINE WHEN USING PHENIX
#SCIPPHENIX_CMD=" --bind $SCIPPHENIX_FOLDER --env PHENIX_HOME=$SCIPPHENIX_FOLDER "
### PHENIX END
### END #######################################################################


### STORAGE DIRECTORIES
# The datadir will be used to input the RAW data used for processing, ie movies/tiltseries
SCIPION_DATADIR="/path/to/your/data/folder"
# The projdir will house Scipion's project and all of its intermediate data
SCIPION_PROJDIR="/path/to/your/ScipionUserData"
# Creatings logs directory
mkdir -p $SCIPION_PROJDIR/logs
### END STORAGE
### END #######################################################################



### SLURM
# Modify the variables to point to your actual SLURM installation 
# Or just ignore if not using SLURM
SCIPSLURM_HOSTSCONF="/path/to/your/hosts.conf"
SCIPSLURM_BIN="/usr/bin"
SCIPSLURM_BASE="/etc/slurm-llnl"
SCIPSLURM_LIB="/var/lib/slurm-llnl"
# UNCOMMENT THIS LINE IF YOUR SCIPSLURM_LIB HAS MORE LIBRARIES APPART FROM THE SLURM ONE
#SCIPSLURM_LIB_DEPENDENCIES="--bind /lib/x86_64-linux-gnu/libc.so.* --bind /lib/x86_64-linux-gnu/libm.so.* --bind /lib/x86_64-linux-gnu/libresolv.so.* --bind /lib/x86_64-linux-gnu/ld-linux-x86-64.so.*"
SCIPSLURM_PLUGINS="/usr/lib/x86_64-linux-gnu/slurm-wlm/"
# Usual locations (check your specific case)
# BIN -> /usr/bin, /opt/slurm/bin, /bin
# BASE -> /etc/slurm-llnl, /etc/slurm
# LIB -> /var/lib/slurm-llnl (ubuntu apt), /var/lib/slurm (ubuntu sources), /usr/lib64/slurm
# LIB_DEPENDENCIES -> ubuntu: /lib/x86_64-linux-gnu/libc.so.*, /lib/x86_64-linux-gnu/libm.so.*, /lib/x86_64-linux-gnu/libresolv.so.*, /lib/x86_64-linux-gnu/ld-linux-x86-64.so.* 
#                     CentOS: /lib64/libc.so.*, /lib64/libm.so.*, /lib64/libresolv.so.*, /lib64/ld-linux-x86-64.so.*
# PLUGINS -> /usr/lib/x86_64-linux-gnu/slurm-wlm/ (ubuntu apt), /usr/lib64/slurm (CentOS)
###
# DONT TOUCH THESE
SCIPSLURM_JOBS=" --bind $SCIPSLURM_BIN/sbatch --bind $SCIPSLURM_BIN/srun --bind $SCIPSLURM_BIN/scancel --bind $SCIPSLURM_BIN/salloc "
SCIPSLURM_CTRL=" --bind $SCIPSLURM_BIN/squeue --bind $SCIPSLURM_BIN/sinfo \
                 --bind $SCIPSLURM_BIN/scontrol --bind $SCIPSLURM_BIN/sstat --bind $SCIPSLURM_BIN/sacct "
SCIPSLURM_CONF=" --bind $SCIPSLURM_BASE --bind $SCIPSLURM_HOSTSCONF:/scipion/config/hosts.conf "
SCIPSLURM_LIBS="${SCIPSLURM_LIB:+--bind $SCIPSLURM_LIB} ${SCIPSLURM_LIB_DEPENDENCIES:+--bind $SCIPSLURM_LIB_DEPENDENCIES} ${SCIPSLURM_PLUGINS:+--bind $SCIPSLURM_PLUGINS} "
# UNCOMMENT THIS LINE WHEN USING SLURM
#SCIPSLURM_CMD=" $SCIPSLURM_JOBS $SCIPSLURM_CTRL $SCIPSLURM_CONF $SCIPSLURM_LIBS "
# END OF SLURM CONFIGURATION VARIABLES
### END #######################################################################

### Message Passing Interface (MPI)
# Many programs (such as Relion & Xmipp) require MPI
# Simple tasks such as extract particles will fail if this is not configured
# LIB is usually /usr/lib/x86_64-linux-gnu/openmpi (Ubuntu-APT) or /usr/lib64/openmpi/ (CentOS-YUM)
# Depending on your system, it might also be in /opt or even be mpich instead of openmpi
# If in doubt, check with your nearest IT manager
SCIPMPI_LIB=" /usr/lib/x86_64-linux-gnu/openmpi "
SCIPMPI_CMD=" --bind $SCIPMPI_LIB --bind /tmp "
# END OF MPI CONFIGURATION VARIABLES
### END #######################################################################

### Apptainer directories configuration
# Define where Apptainer stores data:
# - APPTAINER_CACHEDIR: base directory where Apptainer will create its internal cache folder (e.g. ~/containers)
# - CONTAINER_LOCATION: directory where the final .sif image will be stored (e.g. ~/containers/images)
# - APPTAINER_TMPDIR: directory for temporary files created during image builds 
export APPTAINER_CACHEDIR="/path/to/your/apptainer/cache"
export CONTAINER_LOCATION="/path/to/your/containers"
export APPTAINER_TMPDIR="/path/to/your/apptainer/tmp"
# Create directories if they don’t exist
mkdir -p "$APPTAINER_CACHEDIR" "$CONTAINER_LOCATION" "$APPTAINER_TMPDIR"

###
###
#### END OF USER CONFIGURABLE VARIABLES

# Do not touch below here unless you know what you are doing!
echo "Preparing to launch Scipion Container"
CONTAINER="apptainer-$CONTAINER_FLAVOUR:$CONTAINER_VERSION"
SIF_PATH="$CONTAINER_LOCATION/$CONTAINER.sif"
if [ -f "$SIF_PATH" ]; then
    echo "Container already exists at $SIF_PATH"
else
    echo "Pulling version $CONTAINER_VERSION from branch $CONTAINER_FLAVOUR"
    apptainer pull "$SIF_PATH" oras://rinchen.cnb.csic.es/scipion/$CONTAINER

    if [ $? -eq 0 ]; then
        echo "Cleaning Apptainer cache to save space..."
        apptainer cache clean --force
    else
        echo "Error downloading container. Aborting."
        exit 1
    fi
fi


# Launching command
# GUI is not always an option in compute nodes, thus X11 does not need to be there always
LAUNCH_CMD="apptainer exec --nv --containall \
            --env SCIPION_USER_DATA=$SCIPION_PROJDIR \
            --bind $SCIPION_PROJDIR/logs:/logs \
            --bind /run --bind /etc/resolv.conf \
            --bind $SCIPION_DATADIR:/data --bind $SCIPION_PROJDIR \
            $SCIPCRYOSPARC_CMD $SCIPCRYOASSESS_CMD $SCIPPHENIX_CMD $SCIPSLURM_CMD $SCIPMPI_CMD "


# Decide if Scipion is getting launched in GUI mode (master) or in headless execution mode (worker)
if [ "$#" -gt 0 ]; then
    echo "Launching $CONTAINER_FLAVOUR with parameters..."
    $LAUNCH_CMD $SIF_PATH /scipion/scipion3 run $@
else
    echo "Launching $CONTAINER_FLAVOUR in standalone mode..."
    echo "Launching Scipion container for $CONTAINER_FLAVOUR"
    GUI_CMD=" --env DISPLAY=$DISPLAY --bind /tmp/.X11-unix "
    $LAUNCH_CMD $GUI_CMD $SIF_PATH /scipion/scipion3
fi
