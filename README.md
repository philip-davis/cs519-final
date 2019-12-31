# cs519-final
Reproduction instructions for 519 Final Project - Philip Davis

The files for reproduction are held in a github repo:

https://github.com/philip-davis/cs519-final

This repo contains files necessary for building and running the SST RDMA preload mode. This downloads both production ADIOS2, and the preload branch (lf-push) from my ADIOS2 fork, which I wrote for this project. The preload version is based off commit ff343d72b775008c888daefebcc28d19b41cebff from the main repo. These are pulled into the main repo using submodules.

Prerequisites: MPI compiler wrappers and runner (tested with GNU compiler, ymmv for others) CMake and autotools, git, wget

Steps to Build

1. Clone the cs519-final repo
2. Run the `init.sh` script to populate the submodules
3. Run the `install.sh` script to build all packages

Steps to Run:
1. Update the FABRIC_IFACE environment variable. It's difficult to give guidance on what the right value to use here for a given system, but generally trying different likely-looking interfaces found by `ifconfig` should work. If this is being run on a single machine rather than a cluster, then running the following from the repo base directory might give some hints. Picking the wrong value should crash the program in subsequent steps.

`install/libfabric/bin/fi_info -p sockets -t FI_EP_MSG | grep domain`

2. 

