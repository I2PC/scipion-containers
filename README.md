# scipion-containers
## Introduction
<a href="#"><img src="./icon_box.png" alt="scipion-containers icon" width="300" align="left" style="margin-right: 15px; margin-bottom: 10px;"></a>

In this repository you will find a set of recipes and instructions to build and use containerized Scipion+Xmipp images with **Apptainer/Singularity**, offering a hassle-free experience for CryoEM/ET processing.

Whether you are a cluster or system administrator for a company or institution, or a regular user aiming to do some processing on your own computer, `scipion-containers` can help you.

Installing and updating Scipion is as easy as it can be. Problems do come when populating the list of installed plugins: Xmipp, Relion, Sphire... Managing such a big environment can be a hassle.

That is why we offer a collection of pre-built **Apptainer/Singularity** images and recipes to simplify the process.


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

Once you have the repository locally, there are two ways to use Scipion and Xmipp with containers:

1. Use the **pre-built and up-to-date Apptainer images**, downloadable from our Harbor server.
2. Alternatively, use the **recipes provided in this repository** to build your own images locally, with full control over the environment.

*Note: SLURM installations require special actions and generating a configuration file (available at /apptainer/hosts.conf) for Scipion to work with it. Please contact your nearest Systems Manager.*


### 1. Easy way - run the pre-built images
The BioComputing Unit / Instruct I2PC has set up an OCI registry (Harbor) at rinchen.cnb.csic.es, which hosts the pre-built Scipion images and supports ORAS downloads for Apptainer.

#### What are the available packages?
You can check it out in the [versions chart page](./available_images.md). All of the images use *scipion-base* as their foundation and there is no need of downloading it when downloading "add-on" packages such as *scipion-spa* or *scipion-tomo*.

#### How to use these images?

The easiest and recommended way to use the Scipion containers is by running the provided launcher script `launcher.sh`, which simplifies running Scipion with Apptainer.

In this script, there are several important variables to determine and that should be edited before running it:

- `CONTAINER_FLAVOUR`: the name of the image (e.g. `base`, `spa`, `tomo`)
- `CONTAINER_VERSION`: the tag (e.g. `latest`, `20250318`, etc.). We recommend setting the this variable to `latest` to always use the most up-to-date container image
- `SCIPION_DATADIR`: the directory containing your raw data (e.g. input movies or micrographs). 
- `SCIPION_PROJDIR`: the Scipion projects directory. This should point to a folder named ScipionUserData, which should be created beforehand (e.g. path/to/your/data/ScipionUserData).
- `APPTAINER_CACHEDIR`:base directory where Apptainer stores its internal cache folder (e.g., ~/containers). Apptainer will use this directory to store temporary build files and cached images.
- `CONTAINER_LOCATION`: directory where the final container .sif image will be stored (e.g., ~/containers/images).
- `APPTAINER_TMPDIR`: directory for temporary files created during container builds (e.g. ~/containers/tmp).

To run the launcher, simply execute the following command:
```bash
bash launcher.sh
```

You can use this same command any time you want to start Scipion again.

When launched, it will automatically download the corresponding image from our OCI registry (`rinchen.cnb.csic.es`) if the image is not available locally.  
If the image has been downloaded before, it will be reused — avoiding duplication and saving disk space.

*Note: The launcher also supports additional environment variables for further customization (e.g. for integrating with ChimeraX, CryoSPARC, Cryoassess, or Phenix). Be sure to review and adjust them as needed before running the launcher. These variables can be configured at any time — either the first time you run the launcher (when the container is downloaded) or in later runs.

If you prefer, you can also create an alias to launch Scipion directly from anywhere, for example:
```bash
alias scipion3="bash /path/to/launcher.sh"
```

### 2. Compiling and modifying your own images
All our recipes are included in the `apptainer` subfolder of this GitHub project.

All our recipes (`*.def`) are available in the `apptainer` subfolder of this repository.  
If you prefer or need to build the images yourself — for example, to include custom plugins  — you can use the provided `build.sh` script to simplify the process.

This script allows you to define which container flavours you want to build by editing the `CONTAINER_FLAVOURS` variable. You must always include base, as it is the foundation for the rest of the flavours.

*Note: Before running `build.sh`, we recommend reviewing the script so you can customize variables like `CONTAINER_FLAVOURS` to fit your needs.*
