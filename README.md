# cs519-final
Reproduction instructions for 519 Final Project - Philip Davis

The files for reproduction are held in a github repo:

https://github.com/philip-davis/cs519-final

This repo contains files necessary for building and running the SST RDMA preload mode. This downloads both production ADIOS2, and the preload branch (lf-push) from my ADIOS2 fork, which I wrote for this project. The preload version is based off commit ff343d72b775008c888daefebcc28d19b41cebff from the main repo. These are pulled into the main repo using submodules.

Prerequisites: MPI compiler wrappers and runner (tested with GNU compiler, ymmv for others) CMake and autotools, git, wget

Steps to Build

1. Clone the cs519-final repo
2. Run the init.sh script to populate the submodules
3. Run the install.sh script to build all packages

Steps to Run:
1. Update the FABRIC_IFACE value
