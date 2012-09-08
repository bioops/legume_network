# usage: Rscript parse_cel.r <species> <.cel files directory>
# e.g.   Rscript parse_cel.r medicago ../data/medicago/microarray/raw/

# parse command line arguments
args = commandArgs(trailingOnly = TRUE)
args

# load necessary libraries
library("affy")
library("affyPLM")
library("Biobase")
library("Biostrings")
library("BiocGenerics")
library("AnnotationDbi")
library("IRanges")
library("RColorBrewer")
library("lotus1a520343cdf")
library("medicagocdf")
library("soybeancdf")

# go to .cell directory
setwd(args[2])

# load .cell files
raw = ReadAffy()
raw

# remove ".CEL" in sample names
sampleNames(raw) = sub("\\.CEL$", "", sampleNames(raw)) #remove “.CEL”

# RMA normalization
rma = rma(raw)

# output normalized gene expression levels
write.table(exprs(rma), file=paste(args[1], "_rma.tab",sep=""))

# check out the normalization results
cols = brewer.pal(8, "Set1")
png(file=paste(args[1], "_raw.png", sep=""), width=3248, height=432)
boxplot(raw, col=cols)
dev.off()
png(file=paste(args[1], "_rma.png", sep=""), width=3248, height=432)
boxplot(rma, col=cols)
dev.off()

