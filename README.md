# cs519-final
Reproduction instructions for 519 Final Project - Philip Davis

The files for reproduction are held in a github repo:

https://github.com/philip-davis/cs519-final

This repo contains files necessary for building and running the SST RDMA preload mode. This downloads both production ADIOS2, and the preload branch (lf-push) from my ADIOS2 fork, which I wrote for this project. The preload version is based off commit ff343d72b775008c888daefebcc28d19b41cebff from the main repo. These are pulled into the main repo using submodules. The repo contains a diff of the work done for the new preload branch, `preload.diff`.

Prerequisites: MPI compiler wrappers and runner (tested with GNU compiler, ymmv for others) CMake and autotools, git, wget

**Steps to Build**

1. Clone the cs519-final repo
2. Run the `init.sh` script to populate the submodules
3. Run the `install.sh` script to build all packages (and libfabric, a depdendency.)

**The Test Workflow**
A simple heat transfer numerical simulation (`writer`) coupled to a trivial analysis routine that calculates the time derivative of the simulation output (`reader`). The workflow iterates an arbitrary number of steps. The simulation domain is a regularly decomposed two-dimensional grid. Crucially, write/read patterns are constant through all timesteps.

**Steps to Run**
There are a couple different scripts that can be used to run the workflow and get timing results. The first is `run.sh`:

1. ./run.sh *<writer_ranks>* *<reader_ranks>* *<writer_data_size>* *<steps>* *<fabric_interface>*

Runs the same workflows using three different coupling methods: stanard SST, SST with a push-based RDMA data plane, and insitu-MPI. Report the total readtime for each method (excluding the first two timesteps.)

writer_ranks - the number of processes doing the simulation/writing data
reader_ranks - the number of processes doing the analysis/reading data
writer_data_size - the size of the data being written by **each** writer rank, in bytes
steps - the number of steps to run (timing will be ignored for the first two)
fabric_interface - the interface that should be used for communication. 

It's difficult to give guidance on what the right value to use here for a given system, but generally trying different likely-looking interfaces found by `ifconfig` should work. If this is being run on a single machine rather than a cluster, then running the following from the repo base directory might give some good hints:

`install/libfabric/bin/fi_info -p sockets -t FI_EP_MSG | grep domain`

Picking a bad value should crash some trials and result in missing SST data ; some trial and error might be necessary, unfortunately.

2. ./evalspan.sh *<infile>* *<trials>* *<fabric_interface*>
  
  Runs a parameter sweep, for different {writer_rank, reader_rank, writer_data_size} tuples. Produces a csv files of the results.
  
  infile - a file containing parameters for the paramter sweep, one per line. For example:
  
  8 8 512
  
  On a line would mean to run each method with 8 writer ranks, 8 reader ranks, and 512B writer data size.
  
  trials - the number of trials (timesteps) for each point in the parameter sweep.
  fabric_interface - as above.
  
A sample input file (`param.in`) is provided with its following output file (`span.csv`) in the repo.

**NOTE** This modification is targeted at RDMA fabrics on large HPC clusters such as Summit, Theta, and Cori. YMWV on a VM, small cluster, laptop, etc., with no expectation of meaningful performance results.

