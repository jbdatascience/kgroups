PairOnePass=function(data,level,a=1.0){
  # the number of obs must be even
  Data=as.matrix(data)
  c=length(unique(level))
  clusinf=Clusters(level)
  n=NROW(Data)
  dist=matrix(0,n/2,c)
  level0=level
  newlevel=level
  for (k in 1:(n/2)){
    s1=length(clusinf$clus[[level[2*k-1]]])
    s2=length(clusinf$clus[[level[2*k]]])
    s=min(s1,s2)
    vector=matrix(Data[c(2*k,2*k-1),],2,NCOL(Data))
    if (s==2){
      newlevel[2*k]=level[2*k]
      newlevel[2*k-1]=level[2*k-1]
    }
    if (s<2){
      newlevel[2*k]=level[2*k]
      newlevel[2*k-1]=level[2*k-1]
    }
    if (s>2){
    for (m in 1:c){
      n1=NROW(Data[clusinf$clus[[m]],])
      M=rbind(vector,matrix(Data[clusinf$clus[[m]],],n1,NCOL(Data)))
      size=c(2,n1)
      dist[k,m]=ifelse(isTRUE(all.equal(c(level[2*k-1],level[2*k]),c(m,m))), (n1+2)*edist(M,size,alpha=1)/(2*(n1-2)),edist(M,size,alpha=1)/2)
    }
    newlevel[2*k]=which.min(dist[k,])
    newlevel[2*k-1]=which.min(dist[k,])
   }
   level=newlevel
   clusinf=Clusters(newlevel)
  }
  move=n-sum(as.numeric(newlevel==level0))
  comp=VarComp(Data,newlevel,a)
  clus=Clusters(newlevel)
  return(list(Clus=clus, Level=newlevel,Dist=dist,Move=move,Within=comp$W, Between=comp$B))
}