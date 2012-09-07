#!/bin/bash
perl split_cluster.pl ../data/soybean_CytoscapeInput-nodes-all.txt ../data/medicago_CytoscapeInput-nodes-all.txt ../data/lotus_CytoscapeInput-nodes-all.txt ../data/soybean.tab ../data/medicago.tab ../data/lotus.tab ../data/3legume.evals 1>log 2>err
wc -l log | mail -s "[lab] clusters were splited" liyupeng111@gmail.com
