#!/usr/bin/env raku

use lib 'lib';
use Math::Libgsl::Matrix;
use Math::Libgsl::BLAS;

# Create a 10-by-10 matrix
my Math::Libgsl::Matrix $m .= new: 10, 10;
# Initialize the matrix elements
for ^10 X ^10 -> ($i, $j) {
  $m[$i;$j] = sin($i) + cos($j);
}
# Create a Vector::View
my Math::Libgsl::Vector::View $vv .= new;
# Compute the column norms of the matrix
for ^10 -> $j {
  my Math::Libgsl::Vector $v = $m.col-view($vv, $j);
  my $d = dnrm2($v);
  printf("matrix column %d, norm = %g\n", $j, $d);
}
