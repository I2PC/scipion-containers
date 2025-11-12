# scipion-containers
<a href="#"><img src="./icon_box.png" alt="scipion-containers icon" width="300" align="left" style="margin-right: 15px; margin-bottom: 10px;"></a>

## Introduction
In this repository you will find a set of recipes and instructions to build and use containerized Scipion+Xmipp images with **Apptainer/Singularity**, offering a hassle-free and sudo-free experience for CryoEM/ET processing.

Whether you are a cluster or system administrator for a company or institution, or a regular user aiming to do some processing on your own computer, `scipion-containers` can help you.

### Requirements
To use the containerized version of Scipion provided in this repository, you must have [Apptainer](https://apptainer.org/) (formerly known as Singularity) installed on your system.

You can find the official instructions here: [Apptainer Installation Guide](https://apptainer.org/docs/).

To verify that Apptainer is correctly installed and accessible, run: `apptainer --version`

If you want to learn more about using Apptainer and working with container images like ours, please visit the official [Apptainer documentation](https://apptainer.org/docs/user/main/quick_start.html).

## How to use
To get started, first go to the folder where you want to store the Scipion container setup. From there, **clone this repository** to your machine:

```bash
git clone https://github.com/I2PC/scipion-containers.git
cd scipion-containers
```

Once you have the repository locally available, there are two ways of using the Scipion containers:

1. Use the **pre-built and up-to-date Apptainer images**, downloadable from our Harbor server.
2. Alternatively, use the **recipes provided in this repository** to build your own images locally, with full control over the environment.

*Note: SLURM installations require special actions and generating a configuration file (available at /apptainer/hosts.conf) for Scipion to work with it. Please contact your nearest Systems Manager.*

### 1. Easy way - run the pre-built images
The BioComputing Unit hosts an OCI registry (Harbor) with images updated every 3 months, which hosts the pre-built Scipion images and supports ORAS downloads for Apptainer/Docker. We also provide multiple versions (or "flavours") with different subsets of software.

#### What processing programmes are available inside each flavour?
You can check it out in the [versions chart page](./available_images.md). All of the images use *scipion-base* as their foundation and there is no need of downloading it when downloading "add-on" packages such as *apptainer-spa* or *apptainer-tomo*. The image *apptainer-full* contains everything found in the rest of the packages, at once.

#### How to use these images?
The easiest and recommended way to use the Scipion containers is by modifying and running the provided launcher template, which simplifies running Scipion with Apptainer. The way of making an instance of this template would be:

```bash
cp launcher.sh.template launcher.sh
```
*Note: this launcher.sh file will NOT be overwritten by `git pull` commands, so you can update the repository without having to back it up. We do, however, recommend backing this file  up after configuring all the variables. 

In this script, there are several important variables that should be set before running the container:

- `CONTAINER_FLAVOUR`: the name of the image (e.g. `base`, `spa`, `tomo`, `full`)
- `CONTAINER_VERSION`: the tag (e.g. `latest`, `20250318`, etc.). We recommend setting the this variable to `latest` to always use the most up-to-date container image. You can check all the available tags with `bash ./check_tags.sh`. The tags follow the YYMMDD naming scheme.
- `SCIPION_DATADIR`: the directory containing your raw data (e.g. input movies or micrographs). 
- `SCIPION_PROJDIR`: the Scipion projects directory. This should point to a folder named ScipionUserData, which should be created beforehand (e.g. path/to/your/data/ScipionUserData). Scipion stores all of the processing data in this directory.
- `APPTAINER_CACHEDIR`: base directory where Apptainer stores its internal cache folder (e.g., ~/containers). Apptainer will use this directory to store temporary build files and cached images. In shared environments, it is recommended that this is set the same for everyone by the system manager.
- `APPTAINER_TMPDIR`: directory for temporary files created during container builds (e.g. ~/containers/tmp).

To run the launcher, simply execute the following command:
```bash
bash launcher.sh
```

Or, you can make it executable and just run it as follows:

```bash
chmod +x launcher.sh
./launcher.sh
```

If you prefer, you can also create an alias to launch Scipion directly from anywhere in your `.bashrc` file:
```bash
alias scipion3="bash /path/to/launcher.sh"
```

You can use this same command any time you want to start Scipion again.

#### Updating the local copy of the images
Upon launch, the script will check for the existence of an updated version of the requested image. If it is not found locally, it will prompt the user whether they want to download it or not. If the latest image is in the machine, it will just launch it.

#### Externally linked software
Some programs can not be legally bundled with the pre-built images, due to closed licensing schemes.

Thus, th launcher also supports additional environment variables for further customization (e.g. for integrating with ChimeraX, CryoSPARC, Cryoassess, or PHENIX). Be sure to review and adjust them as needed before running the launcher. These variables can be configured at any time — either the first time you run the launcher (when the container is downloaded) or in later runs by modifying your `launcher.sh`.

### 2. Compiling and modifying your own images
All our recipes are included in the `apptainer` subfolder of this GitHub project.

All our recipes (`*.def`) are available in the `apptainer` subfolder of this repository.  
If you prefer or need to build the images yourself — for example, to include custom plugins  — you can use the provided `build.sh.template` template to simplify the process.

This script allows you to define which container flavours you want to build by editing the `CONTAINER_FLAVOURS` variable. You must always include base, as it is the foundation for the rest of the flavours.

#### Configurable variables
The build.sh script has two variables to determine and that should be edited before running it:

- `CONTAINER_FLAVOURS`: this variable defines which container flavours will be built. You can specify a single flavour or a list of multiple flavours, separated by spaces. The base image must always be included, as it serves as the foundation for the rest of the containers. Other flavours (e.g. spa) are built on top of base, so the build process assumes that base already exists or will be created first.

- `APPTAINER_TMPDIR`: directory used for temporary files during image builds. By default, Apptainer uses /tmp or /var/tmp, which may not have enough space. You should point it to a directory on a partition with sufficient space (e.g. APPTAINER_TMPDIR="/data/tmp"). 