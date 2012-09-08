# usage: Rscript install_cdf.r <directory of the cdf file> <cdf file name> <species name>
# then go to the directory of the cdf file and run:
# R CMD INSTALL <cdf package name>
# e.g. Rscript install_cdf.r ../data/lotus/microarray/ Lotus1a520343.cdf lotus
#      R CMD INSTALL ../data/lotus/microarray/lotus1a520343cdf
# warnings: even the cdf file name has capital letters, the cdf package name will be change to lower case.
# see makecdfenv package for more details to build custom cdf package

# parse command line arguments
args = commandArgs(trailingOnly = TRUE)
args

# load necessary library
library("makecdfenv")

setwd(args[1])
make.cdf.package(args[2], unlink=TRUE, species=args[3])
