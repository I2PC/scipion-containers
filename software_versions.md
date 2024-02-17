# List of software
***Disclaimer**: As of today there is no support for CryoSPARC software inside Scipion Containers.*

### scipion-base
- Base image: nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04
- System libraries from apt-get
    - General utils: nano vim less wget curl
    - Compilation utils: gcc-10 g++-10 make cmake scons default-jdk
    - Libraries: libfftw3-dev libhdf5-dev libopenmpi-dev libsqlite3-dev libtiff5-dev
- ChimeraX 1.6 (.deb package)
- Conda: Miniforge3 w/ libmamba solver
- CUDA: 11.8.0 + CuDNN8
- Scipion3 v3.3.0 Eugenius (scipion-app, scipion-em, scipion-pyworkflow)
- Xmipp3 v3.23.11 Nereus (scipion-em-xmipp)

### scipion-spa
- Base image: scipion-base:latest
- Binaries:
    - CisTEM 1.0.0-beta
    - CTFFind 4.1.14
    - Maxit 10.1
    - Sphire 1.9.7
### scipion-flex
- Base image: scipion-base:latest
### scipion-tomo
- Base image: scipion-base:latest
