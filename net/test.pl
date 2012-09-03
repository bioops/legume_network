use Set::CrossProduct;

$all_colors=[[1,2 ],[1,1],[1,1]];

my $iterator=Set::CrossProduct->new($all_colors);
my @tuples  =$iterator->combinations;
foreach my $each_tuple (@tuples){
print "@{$each_tuple}\n";
}
