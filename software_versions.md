# List of software
***Disclaimer**: In order to use CryoSPARC, PHENIX and CryoAssess you will need to provide your own installation. Check the main page of the documentation for more information.*

### scipion-base
- Base image: nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04
- System libraries from apt-get
    - General utils: nano vim less wget curl
    - Compilation utils: gcc-10 g++-10 make cmake scons default-jdk bison flex
    - Libraries: libfftw3-dev libhdf5-dev libopenmpi-dev libsqlite3-dev libtiff5-dev
- ChimeraX 1.6.1 (.deb package)
- Conda: Miniforge3 w/ libmamba solver
- CUDA: 11.8.0 + CuDNN8
- Scipion3 v3.3.0 Eugenius (scipion-app, scipion-em, scipion-pyworkflow)
- Xmipp3 v3.23.11 Nereus (scipion-em-xmipp)

