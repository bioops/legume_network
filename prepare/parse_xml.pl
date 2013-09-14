#!/usr/bin/perl
use strict;
use warnings;

use XML::Simple; 

my $xml = new XML::Simple;
my $input=$ARGV[0];
my $data = $xml->XMLin($input);
foreach my $biosequence (@{$data->{"BioSequence_package"}->{"BioSequence_assnlist"}->{"BioSequence"}}){
  print ">",$biosequence->{"identifier"},"\n",
            $biosequence->{"sequence"},"\n";
}

