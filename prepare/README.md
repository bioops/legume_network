# Scripts for prepare the data files for analysis

## Correct genes in fasta file of peptides or cds

*  discard alternative splicing. e.g. for gene "Glyma0021s00410", only keep "Glyma0021s00410.1" and remove "Glyma0021s00410.n" (n>1)
*  change the fasta head. e.g. for gene "Glyma0021s00410", the kept gene ">Glyma0021s00410.1|PACid:16242639" was change to ">Glyma0021s00410"
*  correction is needed for soybean and medicago, not lotus.

Workflow:

`perl correct_soybean.pl ../data/soybean/genome/annotation/Gmax_109_peptide.fa ../data/soybean/genome/annotation/Gmax_109_peptide_corr.fa`
`perl correct_medicago.pl ../data/medicago/genome/annotation/Mt3.0_proteins_20090702_NAMED.fa ../data/medicago/genome/annotation/Mt3.0_proteins_20090702_NAMED_corr.fa`


