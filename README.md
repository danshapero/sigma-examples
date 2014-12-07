
Overview
========

This repository consists of example code for the Sparse Graph and Matrix Algebra library, or [SiGMA](http://github.com/danshapero/sigma). The code demonstrates, through various small examples, how to:

* use SiGMA from a variety of languages, including Fortran, C and Python
* how to solve simple linear and not-so-simple nonlinear steady-state PDE with SiGMA
* how to solve time-dependent PDE like the heat equation
* how to use SiGMA for the analysis of graphs and networks
* how to plot the answers from all of the above

If there's a use case for SiGMA that you'd like to see demonstrated, but it's not up here, email me and I'll write it!


Installation
============

You will need to have built the [SiGMA](http://github.com/danshapero/sigma) library. See SiGMA's github repository and readme for how to install it, which should be a straightforward `mkdir build && cd build && cmake .. && make`-style CMake build.

Dependencies:
* SiGMA
* a Fortran 2003-compliant compiler; SiGMA and the examples are routinely tested on gfortran-4.7, gfortran-4.7 and ifort.
* [Triangle](http://www.cs.cmu.edu/~quake/triangle.html), a 2D triangular mesh generator
* numpy
* cython-0.19 or above
* matplotlib-1.4.2 or above
* any other dependencies for the SiGMA library code

Compiling and linking against SiGMA requires that you have the environment variable `SIGMA_DIR` set to the directory in which SiGMA was built, for example

    /home/your_name/sigma/build

if that's the directory where you built SiGMA. You may also need to set `LD_LIBRARY_PATH` to contain the directory containing `libsigma.so`, for example

    /home/your_name/sigma/build/lib.

On Macs it'll be `DYLD_LIBRARY_PATH` or some such.

To build the example code in any sub-directory, `cd` into that directory and type `make all`. Each example should be fairly self-contained.
