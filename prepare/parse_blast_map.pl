#!/usr/bin/perl
use strict;
use warnings;

my ($input_blast,$input_probe)=@ARGV;
my (%probe_map,$eachline);

open(INBLAST,"<$input_blast") or die ("no such file!");
while(defined($eachline=<INBLAST>)){
  my @eachline=split(/\t/, $eachline);
  my @info_each=split(/:/,$eachline[0]);
  my $probe_each=$info_each[-1];
  if ($eachline[2]>90 and $eachline[4]/$eachline[3]>=0.9){
    push(@{$probe_map{$probe_each}},$eachline[1]);
  }
}

open (INPROBE,"<$input_probe") or die ("no such file!");
while(defined($eachline=<INPROBE>)){
  if($eachline=~/^>/){
    $eachline=~s/[\n\r]//g;
    my @info_each=split(/:/,$eachline);
    my $probe_each=$info_each[-1];
    unless($probe_each=~/^AFFX/){
      if (defined($probe_map{$probe_each})){
        print "$probe_each";
        foreach (@{$probe_map{$probe_each}}){print "\t$_";}
        print "\n";
      }else{print "$probe_each\n";}
    }
  }
}

