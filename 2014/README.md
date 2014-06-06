# Conserved and specific legume co-expression network

## summary

medicago and lotus

bla bla

## dataset

all data file were stored in ./data directory.


### medicago

*  expression data (microarray)
  *  platform: Affymetrix GeneChip Medicago Genome Array
  *  <http://mtgea.noble.org/v3/> RMA normalized and mean values for replicates
  *  [NetAffx annotation](http://www.affymetrix.com/Auth/analysis/downloads/na32/ivt/Medicago.na32.annot.csv.zip)
*  genome assembly and annotation: [Medicago.org Mt3.0](http://www.medicagohapmap.org/) (Although the current version is 3.5, Affymetrix was using 3.0 version to annotate this microarray platform)

### lotus
*  expression data (microarray)
  *  platform: Affymetrix Custom Array - Lotus1a520343
  *  <http://ljgea.noble.org/v2/> RMA normalized and mean values for replicates
  *  [ArrayDesign XML](http://www.ebi.ac.uk/arrayexpress/files/A-AFFY-90/A-AFFY-90.mageml.tar.gz)
  *  [raw data](http://www.ebi.ac.uk/arrayexpress/experiments/E-MEXP-1726)
  *  paper: NA
  *  samples: 15\*3=45 
*  genome assembly and annotation: [Lotus japonicus genome assembly build 2.5](http://www.kazusa.or.jp/lotus/)

## main workflow

* conserved network identification
  *  method 1: network comparison \( check ./net directory for more details\)
  *  method 2: meta-analysis
* GO enrichment analysis


