#!/usr/bin/perl
# usage for correction of genes of soybean.
# running example:
# perl correct_soybean.pl ../data/soybean/genome/annotation/Gmax_109_peptide.fa ../data/soybean/genome/annotation/Gmax_109_peptide_corr.fa

use strict;
use warnings;
use Bio::SeqIO;
use Bio::Seq;
my ($infile, $outfile)=@ARGV;

my $seqin  = Bio::SeqIO->new(-file => "<$infile",  -format => 'Fasta',);
my $seqout = Bio::SeqIO->new(-file => ">$outfile", -format => 'Fasta',);
  
while (my $inseq = $seqin->next_seq) {
  my $id=$inseq->id;
  if($id=~/\.1\|PACid:\d+/){
    $id=~s/\.1\|PACid:\d+//;
    my $seqobj = Bio::Seq->new( -display_id => $id,
                                -seq => $inseq->seq());
    $seqout->write_seq($seqobj);
  }
}
