# Conserved and specific legume co-expression network

## summary

soybean, medicago and lotus

bla bla

## dataset

all data file were stored in ./data directory.

### soybean (williams 82):

*  expression data (microarray)
  *  platform: Affymetrix GeneChip Soybean Genome Array
  *  [MetAffx annotation](http://www.affymetrix.com/Auth/analysis/downloads/na32/ivt/Soybean.na32.annot.csv.zip)
  *  [raw data 1](http://www.ebi.ac.uk/arrayexpress/experiments/E-GEOD-26198)
  *  [paper 1](http://onlinelibrary.wiley.com/doi/10.1111/j.1365-3040.2011.02347.x/full)
  *  samples 1: 4\*4 leaf
  *  [raw data 2](http://www.ebi.ac.uk/arrayexpress/experiments/E-GEOD-18827)
  *  paper 2: NA
  *  samples 2: 13\*2 seed
* genome assembly and annotation: [December 2008 (JGI Glyma1 v1.01)](http://www.phytozome.net/soybean)

### medicago

*  expression data (microarray)
  *  platform: Affymetrix GeneChip Medicago Genome Array
  *  [NetAffx annotation](http://www.affymetrix.com/Auth/analysis/downloads/na32/ivt/Medicago.na32.annot.csv.zip)
  *  [raw data](http://www.ebi.ac.uk/arrayexpress/experiments/E-MEXP-1097) 
  *  [paper](http://www.ncbi.nlm.nih.gov/pubmed/18410479)
  *  samples: 18\*3=54
*  genome assembly and annotation: [Medicago.org Mt3.0](http://www.medicagohapmap.org/) (Although the current version is 3.5, Affymetrix was using 3.0 version to annotate this microarray platform)

### lotus
*  expression data (microarray)
  *  platform: Affymetrix Custom Array - Lotus1a520343
  *  NetAffx annotation: NA
  *  [ArrayDesign XML](http://www.ebi.ac.uk/arrayexpress/files/A-AFFY-90/A-AFFY-90.mageml.tar.gz)
  *  [raw data](http://www.ebi.ac.uk/arrayexpress/experiments/E-MEXP-1726)
  *  paper: NA
  *  samples: 15\*3=45 
*  genome assembly and annotation: [Lotus japonicus genome assembly build 2.5](http://www.kazusa.or.jp/lotus/)

## main workflow

* data preparation. \(check ./prepare directory for more details\)
* conserved network identification
  *  method 1: network comparison \( check ./net directory for more details\)
  *  method 2: meta-analysis
* GO enrichment analysis


