#!/usr/bin/perl
use strict;
use warnings;
use Cwd;
use Set::CrossProduct;

my ($in_cluster_soy,$in_cluster_med,$in_cluster_lot,
    $in_node_soy,   $in_node_med,   $in_node_lot, $tempother)=@ARGV;
my $thresh =0.1;
my @species=('soy','med','lot');
my $num_species=scalar @species;
unless ((scalar @ARGV-1)==2*$num_species){
  die ("wrong input files!");
}

my $in_blast_all=pop(@ARGV);
my @in_clusters=@ARGV[0..($num_species-1)];
my @in_nodes   =@ARGV[$num_species..(scalar @ARGV-1)];
my (@cluster,@inter,$all_colors);
for (my $i=0; $i<$num_species;$i++){
  $cluster[$i]=get_clusters($in_clusters[$i]);
  push(@{$all_colors},[keys %{$cluster[$i]}]);
  $inter[$i]  =get_inter($in_nodes[$i]);
}
my %blast_all =get_blast_tab($in_blast_all);

my $iterator=Set::CrossProduct->new($all_colors);
my @tuples  =$iterator->combinations;
my $count=0;
LOOP:foreach my $each_tuple (@tuples){
  my @each_cluster_comb;
  for (my $i=0;$i<$num_species; $i++){
    push (@each_cluster_comb,$cluster[$i]->{$each_tuple->[$i]})
  }
  if(compare_multi_clusters(@each_cluster_comb)){
    $count++;
    print_isorank(@{$each_tuple});
    print "found one!\n";
    last LOOP;
  }
}

sub print_isorank{
  my (@colors)=@_;
  print "@colors\n";
  for (my $i=0;$i<$num_species; $i++){
    print_tab($colors[$i],$i);
  }
  print_set(@colors); 
  print_blast(@colors);
}

sub print_blast{
  my (@colors)=@_;
  for (my $i=0; $i<$num_species; $i++){
    for (my $j=$i; $j<$num_species; $j++){
      my $file='../tmp/'.$species[$i].$colors[$i].'-'.$species[$j].$colors[$j].'.evals';
      open (TEMPOUT,">$file") or die ("no $file !");
      my @genesi=@{$cluster[$i]->{$colors[$i]}};
      my @genesj=@{$cluster[$j]->{$colors[$j]}};
      foreach my $genei (@genesi){
        foreach my $genej (@genesj){
          if(defined($blast_all{$genei}->{$genej})){
            print TEMPOUT "$genei\t$genej\t$blast_all{$genei}->{$genej}\n"; 
          }
        }
      }
      close TEMPOUT;
    }
  }
}


sub print_set{
  my (@colors)=@_;
  my $file='../tmp/'.$count.'.data.inp';
  open (TEMPIN,">$file") or die ("no $file !");
  my $dir = getcwd;
  $dir=~s/\/\w+$/\//g;
  $dir=$dir.'tmp';
  print TEMPIN "$dir\n-\n$num_species\n";
  for (my $i=0;$i<$num_species; $i++){
    print TEMPIN "$species[$i]$colors[$i]\n";
  }
}

sub print_tab{ 
  my ($color,$species_num)=@_;
  my $file='../tmp/'.$species[$species_num].$color.'.tab';
  my (%inter,$cluster);
  my %inter_each=%{$inter[$species_num]};
  my @genes=@{$cluster[$species_num]->{$color}};
  open (TEMPOUT,">$file") or die ("no $file !");
  print TEMPOUT "INTERACTOR_A\tINTERACTOR_B\n";
  for (my $i=0; $i<(scalar @genes)-1;$i++){
    for (my $j=$i+1;$j<scalar @genes;$j++){
      if(defined($inter_each{$genes[$i]}->{$genes[$j]})){
        print TEMPOUT "$genes[$i]\t$genes[$j]\n";
      }
    }
  }
  close TEMPOUT;
}

sub get_clusters{
  my ($input)=@_;
  my ($eachline,$i,%clusters);
  $i=0;
  open(IN,"<$input") or die ("no file $input found!");
  while(defined($eachline=<IN>)){
    $i++;
    if($i>1){
      chomp $eachline;
      my @eachline=split(/ /,$eachline);
      push(@{$clusters{$eachline[2]}},$eachline[0]);
    }
  }
  return \%clusters;
}

sub get_inter{
  my ($input)=@_;
  my ($eachline,$i,%inter);
  $i=0;
  open(IN,"<$input") or die ("no file $input found!");
  while(defined($eachline=<IN>)){
    $i++;
    if($i>1){
      chomp $eachline;
      my @eachline=split(/\t/,$eachline);
      $inter{$eachline[0]}->{$eachline[1]}++;
      $inter{$eachline[1]}->{$eachline[0]}++;
    }
  }
  return \%inter;
}

sub get_blast_tab{
  my ($input)=@_;
  my ($eachline,%blast);
  open(IN,"<$input") or die ("no file $input found!");
  while(defined($eachline=<IN>)){
    chomp $eachline;
    my @eachline=split(/\t/,$eachline);
    $blast{$eachline[0]}->{$eachline[1]}=$eachline[2];
  }
  close IN;
  return %blast;
}

sub compare_multi_clusters{
  my (@clusters)=@_;
  my $num_cluster=scalar @clusters;
  my $flag=0;
  LOOP1:for(my $i=0;$i<$num_cluster-1;$i++){
    for(my $j=$i+1;$j<$num_cluster;$j++){
      $flag=compare_2_clusters($clusters[$i],$clusters[$j]);
      if($flag==0){last LOOP1;}
    }
  }
  return $flag;
}

sub compare_2_clusters{
  my (@clusters2)=@_;
  my $flag   =0;
  my $i      =0;
  my $num_similar_genes=0;
  my $num_bad_genes    =0;
  my (@cluster1,@cluster2);
  if(scalar @{$clusters2[0]} < scalar @{$clusters2[1]}){
    @cluster1 = @{$clusters2[0]};
    @cluster2 = @{$clusters2[1]};
  }else{
    @cluster1 = @{$clusters2[1]};
    @cluster2 = @{$clusters2[0]}; 
  }
  my $min=scalar @cluster1;
  LOOP2:foreach my $gene1 (@cluster1){
    $i++;
    foreach my $gene2 (@cluster2){
      if(defined($blast_all{$gene1}->{$gene2}) or defined($blast_all{$gene2}->{$gene1})){
        $num_similar_genes++;
        #print "$num_similar_genes\t";
        if($num_similar_genes>=$min*$thresh){
          $flag=1;
          last LOOP2;
        }
        next LOOP2;
      }
    }
    if($num_similar_genes+$min-$i<$min*$thresh){
      $flag=0;
      last LOOP2;
    }
  }
  return $flag;
}

