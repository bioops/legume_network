#!/usr/bin/perl
# usage for correction of genes of medicago.
# running example:
# perl correct_medicago.pl ../data/medicago/genome/annotation/Mt3.0_proteins_20090702_NAMED.fa ../data/medicago/genome/annotation/Mt3.0_proteins_20090702_NAMED_corr.fa  

use strict;
use warnings;
use Bio::SeqIO;
use Bio::Seq;
my ($infile, $outfile)=@ARGV;

my $seqin  = Bio::SeqIO->new(-file => "<$infile",  -format => 'Fasta',);
my $seqout = Bio::SeqIO->new(-file => ">$outfile", -format => 'Fasta',);
  
while (my $inseq = $seqin->next_seq) {
  my $id=$inseq->id;
  if($id=~/\.1$/){
    $id=~s/\.1$//;
    my $seqobj = Bio::Seq->new( -display_id => $id,
                                -seq => $inseq->seq());
    $seqout->write_seq($seqobj);
  }
}
