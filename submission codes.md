From Austin:

On Killdevil:
1)      Run separate_genes_for_cryptic_calling.R

a.       module load r

  bsub Rscript separate_genes_for_cryptic_calling.R WT_1_named.coord WT_2_named.coord WT_3_named.coord Mut_1_named.coord Mut_2_named.coord Mut_3_named.coord

b.       Make sure to change the directory for determine_cryptic_jumps_and_rates.R

2)      This prints out a ton of *WTavg_MUTavg_out.txt files

a.       When all are done, run cat * WTavg_MUTavg_out.txt > final_matrix_name_of_all_genes.out

My submission:

#60min:
cd /proj/strahllb/users/Jie/Stephen/yeast_60min_senseStrand_full_genes_filledNAs_named.coord

bsub Rscript /proj/strahllb/users/Jie/Stephen/separate_genes_for_cryptic_calling.R /proj/strahllb/users/Jie/Stephen/yeast_60min_senseStrand_full_genes_filledNAs_named.coord/yeast_WT_60min_Rep1_senseStrand_full_genes_filledNAs_named.coord /proj/strahllb/users/Jie/Stephen/yeast_60min_senseStrand_full_genes_filledNAs_named.coord/yeast_WT_60min_Rep2_senseStrand_full_genes_filledNAs_named.coord /proj/strahllb/users/Jie/Stephen/yeast_60min_senseStrand_full_genes_filledNAs_named.coord/yeast_WT_60min_Rep3_senseStrand_full_genes_filledNAs_named.coord /proj/strahllb/users/Jie/Stephen/yeast_60min_senseStrand_full_genes_filledNAs_named.coord/yeast_SET2del_60min_Rep1_senseStrand_full_genes_filledNAs_named.coord /proj/strahllb/users/Jie/Stephen/yeast_60min_senseStrand_full_genes_filledNAs_named.coord/yeast_SET2del_60min_Rep2_senseStrand_full_genes_filledNAs_named.coord /proj/strahllb/users/Jie/Stephen/yeast_60min_senseStrand_full_genes_filledNAs_named.coord/yeast_SET2del_60min_Rep3_senseStrand_full_genes_filledNAs_named.coord


#0min: WT rep 3 4 5 6, SET2del rep 2 3 4 5

cd /proj/strahllb/users/Jie/Stephen/yeast_0min_senseStrand_full_genes_filledNAs_named.coord
bsub -M 8 -q week Rscript /proj/strahllb/users/Jie/Stephen/separate_genes_for_cryptic_calling.R  /proj/strahllb/users/Jie/Stephen/yeast_0min_senseStrand_full_genes_filledNAs_named.coord/yeast_WT_0min_Rep3_senseStrand_full_genes_filledNAs_named.coord  /proj/strahllb/users/Jie/Stephen/yeast_0min_senseStrand_full_genes_filledNAs_named.coord/yeast_WT_0min_Rep4_senseStrand_full_genes_filledNAs_named.coord  /proj/strahllb/users/Jie/Stephen/yeast_0min_senseStrand_full_genes_filledNAs_named.coord/yeast_WT_0min_Rep5_senseStrand_full_genes_filledNAs_named.coord  /proj/strahllb/users/Jie/Stephen/yeast_0min_senseStrand_full_genes_filledNAs_named.coord/yeast_WT_0min_Rep6_senseStrand_full_genes_filledNAs_named.coord  /proj/strahllb/users/Jie/Stephen/yeast_0min_senseStrand_full_genes_filledNAs_named.coord/yeast_SET2del_0min_Rep2_senseStrand_full_genes_filledNAs_named.coord  /proj/strahllb/users/Jie/Stephen/yeast_0min_senseStrand_full_genes_filledNAs_named.coord/yeast_SET2del_0min_Rep3_senseStrand_full_genes_filledNAs_named.coord  /proj/strahllb/users/Jie/Stephen/yeast_0min_senseStrand_full_genes_filledNAs_named.coord/yeast_SET2del_0min_Rep4_senseStrand_full_genes_filledNAs_named.coord /proj/strahllb/users/Jie/Stephen/yeast_0min_senseStrand_full_genes_filledNAs_named.coord/yeast_SET2del_0min_Rep5_senseStrand_full_genes_filledNAs_named.coord 

