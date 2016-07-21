# args[1] == WT_rep1, args[2] == WT_rep2, ..., args[6] == Mut_rep3, args[7] == output_file, args[8] == step_size
args = commandArgs(trailingOnly = TRUE)

#read in matrices
WT_rep1.mat = read.table(args[1], sep="\t", row.names=1, header=T)
WT_rep2.mat = read.table(args[2], sep="\t", row.names=1, header=T)
WT_rep3.mat = read.table(args[3], sep="\t", row.names=1, header=T)
mut_rep1.mat = read.table(args[4], sep="\t", row.names=1, header=T)
mut_rep2.mat = read.table(args[5], sep="\t", row.names=1, header=T)
mut_rep3.mat = read.table(args[6], sep="\t", row.names=1, header=T)

out.mat = c("Gene_Name","notes", "Best_Theta","Best_y","Best_z","Max_minus_Min_of_lossFunction")

for(i in 1:nrow(WT_rep1.mat)){
  #get average of reps
  WT.avg = apply(rbind(WT_rep1.mat[i,(6:ncol(WT_rep1.mat))],WT_rep2.mat[i,(6:ncol(WT_rep2.mat))],WT_rep3.mat[i,(6:ncol(WT_rep3.mat))]),2, mean)
  WT.avg = WT.avg[!is.na(WT.avg)]
  
  mut.avg = apply(rbind(mut_rep1.mat[i,(6:ncol(mut_rep1.mat))],mut_rep2.mat[i,(6:ncol(mut_rep2.mat))],mut_rep3.mat[i,(6:ncol(mut_rep3.mat))]),2, mean)
  mut.avg = mut.avg[!is.na(mut.avg)]
  
  if(mean(WT.avg) <= 5 | mean(mut.avg) <= 5){
    cat(paste0("Gene #", i, " aka ", row.names(WT_rep1.mat)[i], " had too few reads! It has an average of ", mean(WT.avg), " WT reads and ", mean(mut.avg), " mutant reads; it must be at least 5\n"))
    out.mat = rbind(out.mat, c(row.names(WT_rep1.mat)[i],  "reads<=5 ","NA", "NA", "NA", "NA"))
    next
  }
  else if(length(WT.avg) <= 700){
    cat(paste0("Gene #", i, " aka ", row.names(WT_rep1.mat)[i], " was too small! It was ", length(WT.avg), " and it must be at least 700bp\n"))
    out.mat = rbind(out.mat, c(row.names(WT_rep1.mat)[i], "lens<=700 ", "NA", "NA", "NA", "NA"))
    next
  }
  
  write.table(rbind(c(row.names(WT_rep1.mat[i,]), WT_rep1.mat[i,1:6], WT.avg), c(row.names(WT_rep1.mat[i,]), WT_rep1.mat[i,1:6], mut.avg)), file=paste0("gene_",i,"_WTavg_MUTavg.txt"), sep="\t", quote=F, row.names=F, col.names=F)
  
  system(paste0("bsub -M 30 -q week -J gene",i," Rscript /proj/strahllb/users/Jie/Stephen/determine_cryptic_jumps_and_rates.R gene_",i,"_WTavg_MUTavg.txt gene_",i,"_WTavg_MUTavg_out.txt gene_",i,"_WTavg_MUTavg_loss.txt"))
}

write.table(as.matrix(t(out.mat)), file="failed_genes_WTavg_MUTavg_out.txt", quote=F, sep="\t", col.names=F, row.names=F)
