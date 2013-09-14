#!/usr/bin/perl
use strict;
use warnings;

my ($input_mapping,$input_exprs)=@ARGV;
my ($eachline,%gene_to_probe,%probe_exprs);

open(INMAP,"<$input_mapping") or die("no such file!");
while(defined($eachline=<INMAP>)){
  if($eachline=~/\t/){
    $eachline=~s/[\r\n]//g;
    my @eachline=split(/\t/,$eachline);
    my $probe_each=shift(@eachline);
    if(scalar @eachline==1){
      my @gene_each=@eachline;
      push (@{$gene_to_probe{$gene_each[0]}},$probe_each);
    }
  }
}
close INMAP;

open(INEXP,"<$input_exprs") or die("no such file!");
my $i=0;
while(defined($eachline=<INEXP>)){
  $i++;
  if($i>1){
    $eachline=~s/[\r\n]//g;
    my @eachline=split(/ /,$eachline,2);
    $eachline[0]=~s/\"//g;
    $probe_exprs{$eachline[0]}=$eachline[1];
  }
}
close INEXP;

foreach my $gene (keys %gene_to_probe){
  if(scalar @{$gene_to_probe{$gene}}==1){
    my $probe=${$gene_to_probe{$gene}}[0];
    print "$gene\t$probe\t$probe_exprs{$probe}\n";
  }
}

