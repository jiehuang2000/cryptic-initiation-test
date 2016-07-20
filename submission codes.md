On Killdevil:
1)      Run separate_genes_for_cryptic_calling.R

a.       module load r

                                                               i.      bsub Rscript separate_genes_for_cryptic_calling.R WT_1_named.coord WT_2_named.coord WT_3_named.coord Mut_1_named.coord Mut_2_named.coord Mut_3_named.coord

b.       Make sure to change the directory for determine_cryptic_jumps_and_rates.R

2)      This prints out a ton of *WTavg_MUTavg_out.txt files

a.       When all are done, run cat * WTavg_MUTavg_out.txt > final_matrix_name_of_all_genes.out

