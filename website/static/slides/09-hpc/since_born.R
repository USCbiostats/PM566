#!/usr/bin/Rscript
args <- tail(commandArgs(), 1)
cat(Sys.Date() - as.Date(args), "days since you were born.\n")

