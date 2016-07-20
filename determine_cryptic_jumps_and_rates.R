library(lpSolve)

linProg = function(d0){
  len = length(d0)
  read_length = 50
  band.mat = matrix(0, len, len+read_length-1)
  
  for(j in 1:nrow(band.mat)){
    band.mat[j,(j:(j+read_length-1))] = 1
  }
  
  objective.in = rep.int(1, len+read_length-1)
  const.mat = rbind(band.mat, diag(rep.int(1, len+read_length-1)))
  const.dir = rep.int(">=", 2*len+read_length-1)
  const.rhs = c(d0, rep.int(0, len+read_length-1))
  
  return(list("band" = band.mat, "lp" = lp("min",objective.in,const.mat,const.dir,const.rhs)))
}

# args[1] == inputfile args[2] == outfile
args = commandArgs(trailingOnly = TRUE)

avgs = read.table(args[1], sep="\t")
genename = as.character(avgs[1,1])
WT.avg = as.numeric(avgs[1,7:(ncol(avgs))])
mut.avg = as.numeric(avgs[2,7:(ncol(avgs))])

#out.mat = c("Gene_Name","Best_Theta","Best_y","Best_z","Max_minus_Min_of_lossFunction")
read_length = 50
  
gene.len = length(WT.avg)

thetas = 151:(gene.len-150)
thetas = c(thetas,gene.len)

par = matrix(0,length(thetas),2)
lf = matrix(0,length(thetas),1)

mut.middle = mut.avg
mut.middle[1:100] = 0
mut.middle[(gene.len-99):gene.len] = 0

linProglist = linProg(WT.avg)
band.mat = linProglist$band
l = linProglist$lp

Xy = band.mat
Xz = band.mat

Xy[1:100,] = 0
Xy[(gene.len-99):gene.len,] = 0
Xz[1:100,] = 0
Xz[(gene.len-99):gene.len,] = 0

a11 = 2*t(l$solution) %*% t(Xy) %*% Xy %*% l$solution
b1 = 2*t(l$solution) %*% t(Xy) %*% mut.middle

out.mat = c()
continue = 1
for(p in 1:(length(thetas)-1)){
  Xz[,1:(thetas[p]+read_length-2)] = 0
  a12 = t(l$solution) %*% (t(Xy) %*% Xz + t(Xz) %*% Xy) %*% l$solution
  a22 = 2*t(l$solution) %*% t(Xz) %*% Xz %*% l$solution
  b2 = 2*t(l$solution) %*% t(Xz) %*% mut.middle
  
  A = rbind(c(a11,a12), c(a12,a22))
  rhs = c(b1,b2)
  
  solve.ans = try(solve(A,rhs), silent = TRUE)
  if(class(solve.ans) == "try-error"){
    continue=0
    break
  }
  
  par[p,] = solve.ans
  
  if(par[p,2] < 0){
    par[p,2] = 0
    par[p,1] = b1/a11
  }
  
  y = par[p,1]
  z = par[p,2]
  X = y*Xy + z*Xz
  lf[p] = sqrt((t(mut.middle)%*%mut.middle - 2*t(l$solution)%*%t(X)%*%mut.middle + t(l$solution)%*%t(X)%*%X%*%l$solution)/(gene.len-200))
}

if(continue==1){
  par[length(thetas),1] = b1/a11
  X = par[length(thetas),1]*Xy
  lf[length(thetas)] = sqrt((t(mut.middle)%*%mut.middle - 2*t(l$solution)%*%t(X)%*%mut.middle + t(l$solution)%*%t(X)%*%X%*%l$solution)/(gene.len-200))
  
  best.theta.ind = which.min(lf)
  best.theta = thetas[best.theta.ind]
  best.y = par[best.theta.ind,1]
  best.z = par[best.theta.ind,2]

  out.mat = c(genename, best.theta, best.y, best.z, max(lf)-min(lf))  
}else{
  out.mat = c(genename, "NA", "NA", "NA", "NA")
}

write.table(as.matrix(t(out.mat)), file=args[2], sep="\t", col.names=F, row.names=F, quote=F)