setwd("~/metagene/legume_network/2014")
ljall<-read.table(file="../data/ljgea_allmean.txt", sep="\t", header=T)
ljnod<-ljall[,grep("Root|Nod|root|nod",names(ljall))]
colnames(ljnod)<-sub(pattern="\\.\\..*",replacement="", perl=T, names(ljnod))
rownames(ljnod)<-ljall$Probeset
ljnod<-ljnod[-grep("^AFFX",rownames(ljnod)),]

mtnod<-read.table(file="../data/mtgea_nodmean.txt", sep="\t", header=T)
colnames(mtnod)<-sub(pattern="\\.\\..*",replacement="", perl=T, names(mtnod))
rownames(mtnod)<-mtnod$Probeset
mtnod<-mtnod[,-1]


filter <- function(expr){
#http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0003911
  rangeall<-median(diff(apply(expr,1,range)))
  meanall<-median(apply(expr,1,mean))
  sdall<-median(apply(expr,1,sd))
  IQRall<-median(apply(expr,1,IQR))
  fcv<-function(x)(sd(x)/abs(mean(x)))
  cvall<-median(apply(expr,1,fcv))
  library(genefilter)
  f1 <- function(x)(diff(range(x))>rangeall)
  f2 <- function(x)(mean(x)>meanall)
  f3 <- function(x)(sd(x)>sdall)
  f4 <- function(x)(IQR(x)>IQRall)
  f5 <- function(x)(sd(x)/abs(mean(x))>cvall)
  ff <- filterfun(f1,f2,f3,f4,f5)
  selected <- genefilter(expr, ff)
  expr_filter <- expr[selected, ]
  return(expr_filter)
}

library(genefilter)
ljnod_filter<-filter(log(ljnod))
mtnod_filter<-filter(log(mtnod))

write.table(ljnod_filter,file="../data/ljnod_filter.tab",sep="\t")
write.table(mtnod_filter,file="../data/mtnod_filter.tab",sep="\t")
