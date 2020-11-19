#!/usr/bin/env raku

use Math::Libgsl::Vector;

# Create a 30-element vector
my Math::Libgsl::Vector $v .= new(30);
# Create a Vector View
my Math::Libgsl::Vector::View $vv .= new;
# Get a subvector view with stride
my Math::Libgsl::Vector $v1 = $vv.subvector-stride($v, 0, 3, 10);
# Set all elements of the subvector view to 42
$v1.setall(42);
# Print the original vector
say $v[^30]; # output: (42 0 0 42 0 0 42 0 0 42 0 0 42 0 0 42 0 0 42 0 0 42 0 0 42 0 0 42 0 0)
