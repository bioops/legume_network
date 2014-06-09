library(glasso)
library(igraph)
library(corrgram)

setwd("~/metagene/legume_network/2014")
load("../data/prepare.RData")

lj_s <- cor(t(ljnod_spec))
mt_s <- cor(t(mtnod_spec))

a<-as.matrix(t(mtnod_spec))
s<-mt_s

###############################
RunSingleGlasso <- function(a, s, rho) {

  library(glasso)
  g <- glasso(s,rho)
  n <- nrow(a)
  p <- nrow(s)
  mat <- g$wi
  diag(mat) <- 0
  edge.num <- sum(mat)/2 
  degree <- colSums(mat)
  ln <- n/2*(2/p*g$loglik+sum(abs(g$wi))*rho)
  BIC <- -2*ln+edge.num*log(n)
  mBIC <- BIC+2*edge.num*log(p)
  
  stats <- list(BIC=BIC, 
                mBIC=mBIC)

  return(stats)
}

RunMultiGlasso <- function(a, s,
                           rholist=seq(from=0.01,to=1,by=0.01)) {
  BIC      <- NULL
  mBIC     <- NULL

  for (rho in rholist) {
    stat.list <- RunSingleGlasso(a, s, rho)
    BIC       <- c(BIC      , stat.list$BIC      )
    mBIC      <- c(mBIC     , stat.list$mBIC     )
  }

  stat.alllist <- list(
                       BIC=BIC, 
                       mBIC=mBIC, 
                       rholist=rholist)

  return(stat.alllist)
}

WGlassoPlot <- function(sim.stat) {
  # given the simulation stats from RunMultiGlasso, and true graph
  # code explains itself
  par(mfrow=c(1,2))
  plot(sim.stat$rholist, sim.stat$BIC,type="l")
  plot(sim.stat$rholist, sim.stat$mBIC,type="l")

}

GetGraph <- function(s, rho){
  library(glasso)
  library(igraph)
  g<-glasso(s,rho)
  mat<-g$wi
  colnames(mat)<-rownames(s)
  rownames(mat)<-rownames(s)
  diag(mat)<-0
  mat[which(mat != 0)] <-1
  expr.graph<-graph.adjacency(mat,mode="undirected")
  return(expr.graph)
}

GlassoCV <- function (a, kf=5, rholist=seq(from=0.1,to=0.9,by=0.1)){
  
  n <- nrow(a)
  p <- ncol(a)
  set.seed(11)
  folds = sample(rep(1:kf, length = n))
  cv.lns <- matrix(NA,kf, length(rholist))
  for (k in 1:kf) {  
    a_train<-a[folds != k, ]
    a_valid<-a[folds ==k, ]

    s_train <- cor(a_train)
    s_valid <- cor(a_valid)
  
    n_train <- nrow(a_train)
    n_valid <- nrow(a_valid) 

    g<-glassopath(s_train, rholist=rholist);
    for (i in 1:(length(rholist))){
      #ln_train <- n_train/2*(log(det(g$wi[,,i]))-sum(diag(s_train%*%g$wi[,,i])))
      ln_valid <- n_valid/2*(log(det(g$wi[,,i]))-sum(diag(s_valid%*%g$wi[,,i])))    
      cv.lns[k, i]<-ln_valid
    }
  }
  ln.cv <- apply(cv.lns, 2, mean)
  return(ln.cv)
}
####################################
rholist<-seq(from=0.1,to=0.7,by=0.1)
sim.stat <- RunMultiGlasso(a, s, rholist=rholist)
WGlassoPlot(sim.stat)

rho<-rholist[which.min(sim.stat$BIC)]
expr.graph<-GetGraph(s, rho)

write.graph(expr.graph, "expr.graph", format="ncol")

#########################################
n <- nrow(a)
p <- ncol(a)
kf <- 5
set.seed(11)
folds = sample(rep(1:kf, length = n))
table(folds)

rholist<-seq(from=0.1,to=0.5,by=0.1)

ln.cv<- GlassoCV(t(a),kf=10, rholist=rholist)
plot(x=rholist, y=ln.cv, pch = 19, type = "b")

rho<-rholist[which.max(ln.cv)]
expr.graph<-GetGraph(cor(t(a)), rho)

write.graph(expr.graph, "expr.graph", format="ncol")


mapping<-read.csv("../data/mapping.csv",header=T)
mappingP1 <- aggregate(. ~ Probeset, data = mapping, min)
mappingP1$Gene<-names(table(mapping$Gene.ID))[mappingP1$Gene.ID]
rownames(mappingP1)<-mappingP1$Probeset
mtnod_spec$Gene<-mappingP1[rownames(mtnod_spec),1]
mtnod<- aggregate(. ~ Probeset, data = mapping, min)


