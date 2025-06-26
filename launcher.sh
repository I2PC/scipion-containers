#!/bin/bash

# Scipion Containers launcher script for end users and system administrators
# Authors:
#   Mikel Iceta @ CNB-CSIC - miceta@cnb.csic.es
#   Lola Sánchez @ CNB-CSIC - md.sanchez@cnb.csic.es
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
PREPARE_SCREEN="xhost +"
CLUSTER_PREP="$PREPARE_ENV $PREPARE_SCREEN"
$CLUSTER_PREP
# CLUSTER END
### END #######################################################################


### CRYOSPARC
# CS will work only if the container has direct access to the cryosparcm binary
# Point the container to the folder that contains the cryosparc_master folder
export CRYOSPARC_HOME=/route/to/cryosparc_folder
export CRYOSPARC_PROJECTS_DIR=/route/to/cs_projects
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
$SCIPPHENIX_FOLDER="/route/to/your/phenix_folder"

# UNCOMMENT THIS LINE WHEN USING PHENIX
#$SCIPPHENIX_CMD=" --bind $SCIPPHENIX_FOLDER --env $PHENIX_HOME=$SCIPPHENIX_FOLDER "
### PHENIX END
### END #######################################################################


### STORAGE DIRECTORIES
# The datadir will be used to input the RAW data used for processing, ie movies/tiltseries
SCIPION_DATADIR=/path/to/your/data/folder
# The projdir will house Scipion's project and all of its intermediate data
SCIPION_PROJDIR=/path/to/your/ScipionUserData
### END STORAGE
### END #######################################################################



### SLURM
# Modify the variables to point to your actual SLURM installation 
# Or just ignore if not using SLURM
SCIPSLURM_HOSTSCONF=/path/to/your/hosts.conf
SCIPSLURM_BIN="/usr/bin"
SCIPSLURM_BASE=/etc/slurm-llnl
SCIPSLURM_LIB=/var/lib/slurm-llnl
SCIPSLURM_PLUGINS=/usr/lib/x86_64-linux-gnu/slurm-wlm/
# Usual locations (check your specific case)
# BIN -> /usr/bin, /opt/slurm/bin, /bin
# BASE -> /etc/slurm-llnl, /etc/slurm
# LIB -> /var/lib/slurm-llnl (ubuntu apt), /var/lib/slurm (ubuntu sources), /usr/lib64/slurm
# PLUGINS -> /usr/lib/x86_64-linux-gnu/slurm-wlm/ (ubuntu apt), /usr/lib64/slurm (CentOS)
###
# DONT TOUCH THESE
SCIPSLURM_JOBS=" --bind $SCIPSLURM_BIN/sbatch --bind $SCIPSLURM_BIN/srun --bind $SCIPSLURM_BIN/scancel --bind $SCIPSLURM_BIN/salloc "
SCIPSLURM_CTRL=" --bind $SCIPSLURM_BIN/squeue --bind $SCIPSLURM_BIN/sinfo \
                 --bind $SCIPSLURM_BIN/scontrol --bind $SCIPSLURM_BIN/sstat --bind $SCIPSLURM_BIN/sacct "
SCIPSLURM_CONF=" --bind $SCIPSLURM_BASE --bind $SCIPSLURM_HOSTSCONF:/scipion/config/hosts.conf "
SCIPSLURM_LIBS=" --bind $SCIPSLURM_LIB --bind $SCIPSLURM_PLUGINS "
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

### Apptainer download location
# You might be interested in downloading the container in a different location
# Or maybe you just don't have enough space in your ~/.apptainer to download the image
# Uncomment these variables to change the location of the container
#export APPTAINER_CACHEDIR=/route/to/FOLDER
#export CONTAINER_LOCATION=/route/to/FOLDER

###
###
#### END OF USER CONFIGURABLE VARIABLES

# Do not touch below here unless you know what you are doing!
echo "Preparing to launch Scipion Container"
echo "Pulling version $CONTAINER_VERSION from branch $CONTAINER_FLAVOUR"
CONTAINER=apptainer-$CONTAINER_FLAVOUR-$CONTAINER_VERSION
CONTAINER_PULL=apptainer-$CONTAINER_FLAVOUR:$CONTAINER_VERSION
apptainer pull $CONTAINER_LOCATION/$CONTAINER.sif oras://rinchen.cnb.csic.es/scipion/$CONTAINER_PULL
LAUNCH_CMD="apptainer exec --nv --containall \
            --env DISPLAY=$DISPLAY --env SCIPION_USER_DATA=$SCIPION_PROJDIR \
            --bind /run --bind /tmp/.X11-unix --bind /etc/resolv.conf \
            --bind $SCIPION_DATADIR:/data --bind $SCIPION_PROJDIR \
            $SCIPCRYOSPARC_CMD $SCIPCRYOASSESS_CMD $SCIPPHENIX_CMD $SCIPSLURM_CMD $SCIPMPI_CMD \
            $CONTAINER_LOCATION/$CONTAINER.sif"

if [ "$#" -gt 0 ]; then
    echo "Launching $CONTAINER_FLAVOUR with parameters..."
    $LAUNCH_CMD /scipion/scipion3 run $@
else
    echo "Launching $CONTAINER_FLAVOUR in standalone mode..."
    echo "Launching Scipion container for $CONTAINER_FLAVOUR"
    $LAUNCH_CMD /scipion/scipion3
fi
