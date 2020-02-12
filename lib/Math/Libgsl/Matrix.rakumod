use v6;

unit class Math::Libgsl::Matrix:ver<0.0.5>:auth<cpan:FRITH>;

use Math::Libgsl::Raw::Complex :ALL;
use Math::Libgsl::Raw::Matrix :ALL;
use Math::Libgsl::Exception;
use Math::Libgsl::Constants;
use Math::Libgsl::Vector;
use NativeCall;

has gsl_matrix $.matrix;

multi method new(Int $size1!, Int $size2!)   { self.bless(:$size1, :$size2) }
multi method new(Int :$size1!, Int :$size2!) { self.bless(:$size1, :$size2) }
multi method new(gsl_matrix :$matrix!) { self.bless(:$matrix) }

submethod BUILD(Int :$size1?, Int :$size2?, gsl_matrix :$matrix?) {
  $!matrix = gsl_matrix_calloc($size1, $size2) if $size1.defined && $size2.defined;
  $!matrix = $matrix with $matrix;
}

submethod DESTROY {
  gsl_matrix_free($!matrix);
}
# Accessors
method get(Int:D $i! where * < $!matrix.size1, Int:D $j! where * < $!matrix.size2 --> Num) {
  gsl_matrix_get($!matrix, $i, $j)
}
method AT-POS(Math::Libgsl::Matrix:D: Int:D $i! where * < $!matrix.size1, Int:D $j! where * < $!matrix.size2 --> Num) {
  gsl_matrix_get(self.matrix, $i, $j)
}
method set(Int:D $i! where * < $!matrix.size1, Int:D $j! where * < $!matrix.size2, Num(Cool) $x!) {
  gsl_matrix_set($!matrix, $i, $j, $x);
  self
}
method ASSIGN-POS(Math::Libgsl::Matrix:D: Int:D $i! where * < $!matrix.size1, Int:D $j! where * < $!matrix.size2, Num(Cool) $x!) {
  gsl_matrix_set(self.matrix, $i, $j, $x)
}
method setall(Num(Cool) $x!) { gsl_matrix_set_all($!matrix, $x); self }
method zero() { gsl_matrix_set_zero($!matrix); self }
method identity() { gsl_matrix_set_identity($!matrix); self }
# IO
method write(Str $filename!) {
  my $ret = mgsl_matrix_fwrite($filename, $!matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't write the matrix" if $ret ≠ GSL_SUCCESS;
  self
}
method read(Str $filename!) {
  my $ret = mgsl_matrix_fread($filename, $!matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't read the matrix" if $ret ≠ GSL_SUCCESS;
  self
}
method printf(Str $filename!, Str $format!) {
  my $ret = mgsl_matrix_fprintf($filename, $!matrix, $format);
  fail X::Libgsl.new: errno => $ret, error => "Can't print the matrix" if $ret ≠ GSL_SUCCESS;
  self
}
method scanf(Str $filename!) {
  my $ret = mgsl_matrix_fscanf($filename, $!matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't scan the matrix" if $ret ≠ GSL_SUCCESS;
  self
}
# Copying matrices
method copy(Math::Libgsl::Matrix $src where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2) {
  my $ret = gsl_matrix_memcpy($!matrix, $src.matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't copy the matrix" if $ret ≠ GSL_SUCCESS;
  self
}
method swap(Math::Libgsl::Matrix $src where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2) {
  my $ret = gsl_matrix_swap($!matrix, $src.matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't swap the matrices" if $ret ≠ GSL_SUCCESS;
  self
}
# Rows and columns
method get-row(Int:D $i where * < $!matrix.size1) {
  my gsl_vector $v = gsl_vector_calloc($!matrix.size2);
  LEAVE { gsl_vector_free($v) }
  my $ret = gsl_matrix_get_row($v, $!matrix, $i);
  fail X::Libgsl.new: errno => $ret, error => "Can't get row" if $ret ≠ GSL_SUCCESS;
  my @row = gather take gsl_vector_get($v, $_) for ^$!matrix.size2;
}
method get-col(Int:D $j where * < $!matrix.size2) {
  my gsl_vector $v = gsl_vector_calloc($!matrix.size1);
  LEAVE { gsl_vector_free($v) }
  my $ret = gsl_matrix_get_col($v, $!matrix, $j);
  fail X::Libgsl.new: errno => $ret, error => "Can't get col" if $ret ≠ GSL_SUCCESS;
  my @col = gather take gsl_vector_get($v, $_) for ^$!matrix.size1;
}
multi method set-row(Int:D $i where * ≤ $!matrix.size1, @row where *.elems == $!matrix.size2) {
  my gsl_vector $v = gsl_vector_calloc($!matrix.size2);
  LEAVE { gsl_vector_free($v) }
  gsl_vector_set($v, $_, @row[$_].Num) for ^$!matrix.size2;
  my $ret = gsl_matrix_set_row($!matrix, $i, $v);
  fail X::Libgsl.new: errno => $ret, error => "Can't set row" if $ret ≠ GSL_SUCCESS;
  self
}
multi method set-row(Int:D $i where * ≤ $!matrix.size1, Math::Libgsl::Vector $v where .vector.size == $!matrix.size2) {
  my $ret = gsl_matrix_set_row($!matrix, $i, $v.vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't set row" if $ret ≠ GSL_SUCCESS;
  self
}
multi method set-col(Int:D $j where * ≤ $!matrix.size2, @col where *.elems == $!matrix.size1) {
  my gsl_vector $v = gsl_vector_calloc($!matrix.size1);
  LEAVE { gsl_vector_free($v) }
  gsl_vector_set($v, $_, @col[$_].Num) for ^$!matrix.size1;
  my $ret = gsl_matrix_set_col($!matrix, $j, $v);
  fail X::Libgsl.new: errno => $ret, error => "Can't set col" if $ret ≠ GSL_SUCCESS;
  self
}
multi method set-col(Int:D $j where * ≤ $!matrix.size2, Math::Libgsl::Vector $v where .vector.size == $!matrix.size1) {
  my $ret = gsl_matrix_set_col($!matrix, $j, $v.vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't set col" if $ret ≠ GSL_SUCCESS;
  self
}
# Exchanging rows and columns
method swap-rows(Int:D $i where * ≤ $!matrix.size1, Int:D $j where * ≤ $!matrix.size1) {
  my $ret = gsl_matrix_swap_rows($!matrix, $i, $j);
  fail X::Libgsl.new: errno => $ret, error => "Can't swap rows" if $ret ≠ GSL_SUCCESS;
  self
}
method swap-cols(Int:D $i where * ≤ $!matrix.size2, Int:D $j where * ≤ $!matrix.size2) {
  my $ret = gsl_matrix_swap_columns($!matrix, $i, $j);
  fail X::Libgsl.new: errno => $ret, error => "Can't swap columns" if $ret ≠ GSL_SUCCESS;
  self
}
method swap-rowcol(Int:D $i where * ≤ $!matrix.size1, Int:D $j where * ≤ $!matrix.size1) {
  fail X::Libgsl.new: errno => GSL_ENOTSQR, error => "Not a square matrix" if $!matrix.size1 ≠ $!matrix.size2;
  my $ret = gsl_matrix_swap_rowcol($!matrix, $i, $j);
  fail X::Libgsl.new: errno => $ret, error => "Can't swap row & column" if $ret ≠ GSL_SUCCESS;
  self
}
method copy-transpose(Math::Libgsl::Matrix $src where $!matrix.size1 == .matrix.size2 && $!matrix.size2 == .matrix.size1) {
  my $ret = gsl_matrix_transpose_memcpy($!matrix, $src.matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't copy and transpose" if $ret ≠ GSL_SUCCESS;
  self
}
method transpose() {
  fail X::Libgsl.new: errno => GSL_ENOTSQR, error => "Not a square matrix" if $!matrix.size1 ≠ $!matrix.size2;
  my $ret = gsl_matrix_transpose($!matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't transpose" if $ret ≠ GSL_SUCCESS;
  self
}
# Matrix operations
method add(Math::Libgsl::Matrix $b where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2) {
  my $ret = gsl_matrix_add($!matrix, $b.matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't add" if $ret ≠ GSL_SUCCESS;
  self
}
method sub(Math::Libgsl::Matrix $b where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2) {
  my $ret = gsl_matrix_sub($!matrix, $b.matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't sub" if $ret ≠ GSL_SUCCESS;
  self
}
method mul(Math::Libgsl::Matrix $b where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2) {
  my $ret = gsl_matrix_mul_elements($!matrix, $b.matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't mul" if $ret ≠ GSL_SUCCESS;
  self
}
method div(Math::Libgsl::Matrix $b where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2) {
  my $ret = gsl_matrix_div_elements($!matrix, $b.matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't div" if $ret ≠ GSL_SUCCESS;
  self
}
method scale(Num(Cool) $x) {
  my $ret = gsl_matrix_scale($!matrix, $x);
  fail X::Libgsl.new: errno => $ret, error => "Can't scale" if $ret ≠ GSL_SUCCESS;
  self
}
method add-constant(Num(Cool) $x) {
  my $ret = gsl_matrix_add_constant($!matrix, $x);
  fail X::Libgsl.new: errno => $ret, error => "Can't add constant" if $ret ≠ GSL_SUCCESS;
  self
}
# Finding maximum and minimum elements of matrices
method max(--> Num) { gsl_matrix_max($!matrix) }
method min(--> Num) { gsl_matrix_min($!matrix) }
method minmax(--> List) {
  my num64 ($min, $max);
  gsl_matrix_minmax($!matrix, $min, $max);
  return $min, $max;
}
method max-index(--> List) {
  my size_t ($imax, $jmax);
  gsl_matrix_max_index($!matrix, $imax, $jmax);
  return $imax, $jmax;
}
method min-index(--> List) {
  my size_t ($imin, $jmin);
  gsl_matrix_min_index($!matrix, $imin, $jmin);
  return $imin, $jmin;
}
method minmax-index(--> List) {
  my size_t ($imin, $jmin, $imax, $jmax);
  gsl_matrix_minmax_index($!matrix, $imin, $jmin, $imax, $jmax);
  return $imin, $jmin, $imax, $jmax;
}
# Matrix properties
method is-null(--> Bool)   { gsl_matrix_isnull($!matrix)   ?? True !! False }
method is-pos(--> Bool)    { gsl_matrix_ispos($!matrix)    ?? True !! False }
method is-neg(--> Bool)    { gsl_matrix_isneg($!matrix)    ?? True !! False }
method is-nonneg(--> Bool) { gsl_matrix_isnonneg($!matrix) ?? True !! False }
method is-equal(Math::Libgsl::Matrix $b --> Bool) { gsl_matrix_equal($!matrix, $b.matrix) ?? True !! False }

=begin pod

[![Build Status](https://travis-ci.org/frithnanth/raku-Math-Libgsl-Matrix.svg?branch=master)](https://travis-ci.org/frithnanth/raku-Math-Libgsl-Matrix)

=head1 NAME

Math::Libgsl::Matrix
Math::Libgsl::Vector - An interface to libgsl, the Gnu Scientific Library - Vector and matrix algebra.

=head1 SYNOPSIS

=begin code :lang<perl6>

use Math::Libgsl::Raw::Matrix :ALL;

use Math::Libgsl::Vector;
use Math::Libgsl::Matrix;

=end code

=head1 DESCRIPTION

Math::Libgsl::Matrix provides an interface to the vector and matrix algebra functions of libgsl - the GNU Scientific Library.

This package provides both the low-level interface to the C library (Raw) and a more comfortable interface layer for the Raku programmer.

This module comes with two classes, Vector and Matrix, available in 12 data types, so it offers 24 classes:

=item Math::Libgsl::Vector              - default, corresponding to a Math::Libgsl::Vector::Num64
=item Math::Libgsl::Vector::Num32
=item Math::Libgsl::Vector::Int32
=item Math::Libgsl::Vector::UInt32
=item Math::Libgsl::Vector::Int64
=item Math::Libgsl::Vector::UInt64
=item Math::Libgsl::Vector::Int16
=item Math::Libgsl::Vector::UInt16
=item Math::Libgsl::Vector::Int8
=item Math::Libgsl::Vector::UInt8
=item Math::Libgsl::Vector::Complex32
=item Math::Libgsl::Vector::Complex64

=item Math::Libgsl::Matrix              - default, corresponding to a Math::Libgsl::Matrix::Num64
=item Math::Libgsl::Matrix::Num32
=item Math::Libgsl::Matrix::Int32
=item Math::Libgsl::Matrix::UInt32
=item Math::Libgsl::Matrix::Int64
=item Math::Libgsl::Matrix::UInt64
=item Math::Libgsl::Matrix::Int16
=item Math::Libgsl::Matrix::UInt16
=item Math::Libgsl::Matrix::Int8
=item Math::Libgsl::Matrix::UInt8
=item Math::Libgsl::Matrix::Complex32
=item Math::Libgsl::Matrix::Complex64

All the following methods are available for the classes correspondig to each datatype, except where noted.

=head2 Vector

=head3 new(Int $size!) { self.bless(:$size) }
=head3 new(Int :$size!) { self.bless(:$size) }

The constructor accepts one parameter: the vector's size; it can be passed as a Pair or as a single value.

=head3 get(Int:D $index! where * < $!vector.size --> Num)

This method returns the value of a vector's element.
It is possible to address a vector element as a Raku array element:

=begin code
say $vector[1];
=end code

or even:

=begin code
say $vector[^10];
=end code

=head3 set(Int:D $index! where * < $!vector.size, Num(Cool)

This method sets the value of a vector's element.
This method can be chained.
It is possible to address a vector element as a Raku array element:

=begin code
$vector[1] = 3;
=end code

Note that it's not possible to set a range of elements (yet).
When used as a Raku array, this method can't be chained.

=head3 setall(Num(Cool))

Sets all the elements of the vector to the same value.
This method can be chained.

=head3 zero()

Sets all the elements of the vector to zero.
This method can be chained.

=head3 basis(Int:D $index! where * < $!vector.size)

Sets all the elements of the vector to zero except for the element at $index, which is set to one.
This method can be chained.

=head3 write(Str $filename!)

Writes the vector to a file in binary form.
This method can be chained.

=head3 read(Str $filename!)

Reads the vector from a file in binary form.
This method can be chained.

=head3 printf(Str $filename!, Str $format!)

Writes the vector to a file using the specified format.
This method can be chained.

=head3 scanf(Str $filename!)

Reads the vector from a file containing formatted data.
This method can be chained.

=head3 subvector(size_t $offset where * < $!vector.size, size_t $n)

Creates a view on a subset of the vector, starting from $offset and of length $n.
This method returns a new Vector object.
Any operation done on this view affects the original vector as well.

=head3 subvector-stride(size_t $offset where * < $!vector.size, size_t $stride, size_t $n)

Creates a view on a subset of the vector, starting from $offset and of length $n, with stride $stride.
This method returns a new Vector object.
Any operation done on this view affects the original vector as well.

=head3 vec-view-array(@array)

This is not a method, but a sub.
It creates a Vector object from the Raku array.

=head3 vec-view-array-stride(@array, size_t $stride)

This is not a method, but a sub.
It creates a Vector object from the Raku array, with stride $stride.

=head3 copy(Math::Libgsl::Vector $src where $!vector.size == .vector.size)

This method copies the vector $src into the current object.
This method can be chained.

=head3 swap(Math::Libgsl::Vector $w where $!vector.size == .vector.size)

This method exchanges the elements of the current vector with the ones of the vector $w.
This method can be chained.

=head3 swap-elems(Int $i where * < $!vector.size, Int $j where * < $!vector.size)

This method exchanges the $i-th and $j-th elements in place.
This method can be chained.

=head3 reverse()

This method reverses the order of the elements of the vector.
This method can be chained.

=head3 add(Math::Libgsl::Vector $b where $!vector.size == .vector.size)
=head3 sub(Math::Libgsl::Vector $b where $!vector.size == .vector.size)
=head3 mul(Math::Libgsl::Vector $b where $!vector.size == .vector.size)
=head3 div(Math::Libgsl::Vector $b where $!vector.size == .vector.size)

These methods perform operations on the elements of two vectors. The object on which the method is called is the one whose values are changed.
All these methods can be chained.

=head3 scale(Num(Cool) $x)

This method multiplies the elements of the vector by a factor $x.
This method can be chained.

=head3 add-constant(Num(Cool) $x)

This method add a constant to the elements of the vector.
This method can be chained.

=head3 max(--> Num)
=head3 min(--> Num)

These two methods return the min and max value in the vector.
Not available in Math::Libgsl::Vector::Complex32 and Math::Libgsl::Vector::Complex64.

=head3 minmax(--> List)

This method returns a list of two values: the min and max value in the vector.
Not available in Math::Libgsl::Vector::Complex32 and Math::Libgsl::Vector::Complex64.

=head3 max-index(--> Int)
=head3 min-index(--> Int)

These two methods return the index of the min and max value in the vector.
Not available in Math::Libgsl::Vector::Complex32 and Math::Libgsl::Vector::Complex64.

=head3 minmax-index(--> List)

This method returns a list of two values: the indices of the min and max value in the vector.
Not available in Math::Libgsl::Vector::Complex32 and Math::Libgsl::Vector::Complex64.

=head3 is-null(--> Bool)
=head3 is-pos(--> Bool)
=head3 is-neg(--> Bool)
=head3 is-nonneg(--> Bool)

These methods return True if all the elements of the vector are zero, strictly positive, strictly negative, or non-negative.

=head3 is-equal(Math::Libgsl::Vector $b --> Bool)

This method returns True if the two vectors are equal element-wise.

=head2 Matrix

=head3 new(Int $size1!, Int $size2!)
=head3 new(Int :$size1!, Int :$size2!)

The constructor accepts two parameters: the matrix sizes; they can be passed as Pairs or as single values.

=head3 get(Int:D $i! where * < $!matrix.size1, Int:D $j! where * < $!matrix.size2 --> Num)

This method returns the value of a matrix element.
It is possible to address a matrix element as a Raku shaped array element:

=begin code
say $matrix[1;2];
=end code

=head3 set(Int:D $i! where * < $!matrix.size1, Int:D $j! where * < $!matrix.size2, Num(Cool)

This method sets the value of a matrix element.
This method can be chained.
It is possible to address a matrix element as a Raku shaped array element:

=begin code
$matrix[1;3] = 3;
=end code

=head3 setall(Num(Cool))

Sets all the elements of the matrix to the same value.
This method can be chained.

=head3 zero()

Sets all the elements of the matrix to zero.
This method can be chained.

=head3 identity()

Sets all elements of the matrix to the corrisponding elements of the identity matrix.

=head3 write(Str $filename!)

Writes the matrix to a file in binary form.
This method can be chained.

=head3 read(Str $filename!)

Reads the matrix from a file in binary form.
This method can be chained.

=head3 printf(Str $filename!, Str $format!)

Writes the matrix to a file using the specified format.
This method can be chained.

=head3 scanf(Str $filename!)

Reads the matrix from a file containing formatted data.
This method can be chained.

=head3 copy(Math::Libgsl::Matrix $src where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2)

This method copies the $src matrix into the current one.
This method can be chained.

=head3 swap(Math::Libgsl::Matrix $src where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2)

This method swaps elements of the $src matrix and the current one.
This method can be chained.

=head3 get-row(Int:D $i where * < $!matrix.size1)

This method returns an array from row number $i.

=head3 get-col(Int:D $j where * < $!matrix.size2)

This method returns an array from column number $j.

=head3 set-row(Int:D $i where * ≤ $!matrix.size1, @row where *.elems == $!matrix.size2)
=head3 set-row(Int:D $i where * ≤ $!matrix.size1, Math::Libgsl::Vector $v where .vector.size == $!matrix.size2)

These methods set row number $i of the matrix from a Raku array or a Vector object.
This method can be chained.

=head3 set-col(Int:D $j where * ≤ $!matrix.size2, @col where *.elems == $!matrix.size1)
=head3 set-col(Int:D $j where * ≤ $!matrix.size2, Math::Libgsl::Vector $v where .vector.size == $!matrix.size1)

These methods set column number $j of the matrix from a Raku array or a Vector object.
This method can be chained.

=head3 swap-rows(Int:D $i where * ≤ $!matrix.size1, Int:D $j where * ≤ $!matrix.size1)

This method swaps rows $i and $j.
This method can be chained.

=head3 swap-cols(Int:D $i where * ≤ $!matrix.size2, Int:D $j where * ≤ $!matrix.size2)

This method swaps columns $i and $j.
This method can be chained.

=head3 swap-rowcol(Int:D $i where * ≤ $!matrix.size1, Int:D $j where * ≤ $!matrix.size1)

This method exchanges row number $i with column number $j of a square matrix.
This method can be chained.

=head3 copy-transpose(Math::Libgsl::Matrix $src where $!matrix.size1 == .matrix.size2 && $!matrix.size2 == .matrix.size1)

This method copies a matrix into the current one, while transposing the elements.
This method can be chained.

=head3 transpose()

This method transposes the current matrix.
This method can be chained.

=head3 add(Math::Libgsl::Matrix $b where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2)

This method adds a matrix to the current one element-wise.
This method can be chained.

=head3 sub(Math::Libgsl::Matrix $b where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2)

This method subtracts a matrix from the current one element-wise.
This method can be chained.

=head3 mul(Math::Libgsl::Matrix $b where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2)

This method multiplies a matrix to the current one element-wise.
This method can be chained.

=head3 div(Math::Libgsl::Matrix $b where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2)

This method divides the current matrix by another one element-wise.
This method can be chained.

=head3 scale(Num(Cool) $x)

This method multiplies the elements of the current matrix by a constant value.
This method can be chained.

=head3 add-constant(Num(Cool) $x)

This method adds a constant to the elements of the current matrix.
This method can be chained.

=head3 max(--> Num)
=head3 min(--> Num)

These two methods return the min and max value in the matrix.
Not available in Math::Libgsl::Matrix::Complex32 and Math::Libgsl::Matrix::Complex64.

=head3 minmax(--> List)

This method returns a list of two values: the min and max value in the matrix.
Not available in Math::Libgsl::Matrix::Complex32 and Math::Libgsl::Matrix::Complex64.

=head3 max-index(--> Int)
=head3 min-index(--> Int)

These two methods return the index of the min and max value in the matrix.
Not available in Math::Libgsl::Matrix::Complex32 and Math::Libgsl::Matrix::Complex64.

=head3 minmax-index(--> List)

This method returns a list of two values: the indices of the min and max value in the matrix.
Not available in Math::Libgsl::Matrix::Complex32 and Math::Libgsl::Matrix::Complex64.

=head3 is-null(--> Bool)
=head3 is-pos(--> Bool)
=head3 is-neg(--> Bool)
=head3 is-nonneg(--> Bool)

These methods return True if all the elements of the matrix are zero, strictly positive, strictly negative, or non-negative.

=head3 is-equal(Math::Libgsl::Matrix $b --> Bool)

This method returns True if the matrices are equal element-wise.

=head1 C Library Documentation

For more details on libgsl see L<https://www.gnu.org/software/gsl/>.
The excellent C Library manual is available here L<https://www.gnu.org/software/gsl/doc/html/index.html>, or here L<https://www.gnu.org/software/gsl/doc/latex/gsl-ref.pdf> in PDF format.

=head1 Prerequisites

This module requires the libgsl library to be installed. Please follow the instructions below based on your platform:

=head2 Debian Linux

=begin code
sudo apt install libgsl23 libgsl-dev libgslcblas0
=end code

That command will install libgslcblas0 as well, since it's used by the GSL.

=head2 Ubuntu 18.04

libgsl23 and libgslcblas0 have a missing symbol on Ubuntu 18.04.
I solved the issue installing the Debian Buster version of those three libraries:

=item L<http://http.us.debian.org/debian/pool/main/g/gsl/libgslcblas0_2.5+dfsg-6_amd64.deb>
=item L<http://http.us.debian.org/debian/pool/main/g/gsl/libgsl23_2.5+dfsg-6_amd64.deb>
=item L<http://http.us.debian.org/debian/pool/main/g/gsl/libgsl-dev_2.5+dfsg-6_amd64.deb>

=head1 Installation

To install it using zef (a module management tool):

=begin code
$ zef install Math::Libgsl::Matrix
=end code

=head1 AUTHOR

Fernando Santagata <nando.santagata@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2020 Fernando Santagata

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
