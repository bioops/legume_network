# scripts for data preparation

## correct gene names of in fasta file

*  discard alternative splicing. e.g. for gene "Glyma0021s00410", only keep "Glyma0021s00410.1" and remove "Glyma0021s00410.n" (n>1)
*  change the fasta head. e.g. for gene "Glyma0021s00410", the kept gene ">Glyma0021s00410.1|PACid:16242639" was change to ">Glyma0021s00410"
*  correction is needed for soybean and medicago, not lotus.

run:

	perl correct_soybean.pl ../data/soybean/genome/annotation/Gmax_109_peptide.fa \
	../data/soybean/genome/annotation/Gmax_109_peptide_corr.fa

	perl correct_medicago.pl ../data/medicago/genome/annotation/Mt3.0_proteins_20090702_NAMED.fa \
	../data/medicago/genome/annotation/Mt3.0_proteins_20090702_NAMED_corr.fa


## all-against-all BLASTP

run:

	# merge all peptide fasta files into one
	cat ../data/soybean/genome/annotation/Gmax_109_peptide_corr.fa \
	../data/medicago/genome/annotation/Mt3.0_proteins_20090702_NAMED_corr.fa \
	../data/lotus/genome/annotation/lotus_2.5_protein.fa \
	>../data/blast/3legume_peptide_corr.fa
	
	# go to blast directory
	cd ../data/blast/
	
	# create the blast database
	makeblastdb -in 3legume_peptide_corr.fa -out 3legume -title 3legume -dbtype prot
	
	# runing blastp using BLAST 2.2.25+. (this will run a long time, use 'screen' command if necessory)
	blastp \
	-query 3legume_peptide_corr.fa \
	-db 3legume \
	-out 3legume_blast.tab \
	-evalue 1e-20 \
	-num_threads 10 \
	-outfmt '6 qseqid sseqid pident qlen length mismatch gapopen qstart qend sstart send evalue bitscore' \
	-max_target_seqs 10

## parse microarray .cel files and output the normalized gene \(probe\) expression levels

* using affy bioconductor package to parse .cel files
* RMA normalization
* output the normalized expression values

Since lotus microarray is custom designed, the bioconductor doesn't have lotus cdf package. We built our own cdf package using makecdfenv package from the microarray design cdf file, which is availble on [ArrayExpress](http://www.ebi.ac.uk/arrayexpress/files/A-AFFY-90/A-AFFY-90.cdf.zip).

run \(Check out the R scipt for details, and make sure all settings are correct. It might be better to interactively run the script step by step\):

	Rscript install_cdf.r ../data/lotus/microarray/ Lotus1a520343.cdf lotus
	R CMD INSTALL ../data/lotus/microarray/lotus1a520343.cdf
        Rscript parse_cel.r lotus ../data/lotus/microarray/raw/
	Rscript parse_cel.r medicago ../data/medicago/microarray/raw/
        Rscript parse_cel.r soybean ../data/soybean/microarray/raw/

## associate microarray probe with annotated genes in reference genomes


