use v6;

unit class Math::Libgsl::Matrix:ver<0.1.3>:auth<cpan:FRITH>;

use Math::Libgsl::Raw::Matrix :ALL;
use Math::Libgsl::Exception;
use Math::Libgsl::Constants;
use Math::Libgsl::Vector;
use NativeCall;

class View {
  has gsl_matrix_view $.view;
  submethod BUILD { $!view = alloc_gsl_matrix_view }
  submethod DESTROY { free_gsl_matrix_view($!view) }
}

has gsl_matrix $.matrix;
has Bool       $.view = False;

multi method new(Int $size1!, Int $size2!)   { self.bless(:$size1, :$size2) }
multi method new(Int :$size1!, Int :$size2!) { self.bless(:$size1, :$size2) }
multi method new(gsl_matrix :$matrix!) { self.bless(:$matrix) }

submethod BUILD(Int :$size1?, Int :$size2?, gsl_matrix :$matrix?) {
  $!matrix = gsl_matrix_calloc($size1, $size2) if $size1.defined && $size2.defined;
  with $matrix {
    $!matrix = $matrix;
    $!view   = True;
  }
}

submethod DESTROY {
  gsl_matrix_free($!matrix) unless $!view;
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
# View
method submatrix(Math::Libgsl::Matrix::View $mv, size_t $k1 where * < $!matrix.size1, size_t $k2 where * < $!matrix.size2, size_t $n1, size_t $n2) {
  fail X::Libgsl.new: errno => GSL_EDOM, error => "Submatrix indices out of bound"
    if $k1 + $n1 > $!matrix.size1 || $k2 + $n2 > $!matrix.size2;
  Math::Libgsl::Matrix.new: matrix => mgsl_matrix_submatrix($mv.view, $!matrix, $k1, $k2, $n1, $n2);
}
sub mat-view-array(Math::Libgsl::Matrix::View $mv, @array where { @array ~~ Array && @array.shape.elems == 2 }) is export(:withsub) {
  my CArray[num64] $a .= new: @array.Array».Num;
  Math::Libgsl::Matrix.new: matrix => mgsl_matrix_view_array($mv.view, $a, @array.shape[0], @array.shape[1]);
}
sub mat-view-array-tda(Math::Libgsl::Matrix::View $mv, @array where { @array ~~ Array && @array.shape.elems == 2 }, size_t $tda) is export(:withsub) {
  fail X::Libgsl.new: errno => GSL_EDOM, error => "tda out of bound" if $tda < @array.shape[1];
  my CArray[num64] $a .= new: @array.Array».Num;
  Math::Libgsl::Matrix.new: matrix => mgsl_matrix_view_array_with_tda($mv.view, $a, @array.shape[0], @array.shape[1], $tda);
}
sub mat-view-vector(Math::Libgsl::Matrix::View $mv, Math::Libgsl::Vector $v, size_t $n1, size_t $n2) is export(:withsub) {
  Math::Libgsl::Matrix.new: matrix => mgsl_matrix_view_vector($mv.view, $v.vector, $n1, $n2);
}
sub mat-view-vector-tda(Math::Libgsl::Matrix::View $mv, Math::Libgsl::Vector $v, size_t $n1, size_t $n2, size_t $tda) is export(:withsub) {
  fail X::Libgsl.new: errno => GSL_EDOM, error => "tda out of bound" if $n2 > $tda ;
  Math::Libgsl::Matrix.new: matrix => mgsl_matrix_view_vector_with_tda($mv.view, $v.vector, $n1, $n2, $tda);
}
method row-view(Math::Libgsl::Vector::View $vv, size_t $i where * < $!matrix.size1) {
  Math::Libgsl::Vector.new: vector => mgsl_matrix_row($vv.view, $!matrix, $i);
}
method col-view(Math::Libgsl::Vector::View $vv, size_t $j where * < $!matrix.size2) {
  Math::Libgsl::Vector.new: vector => mgsl_matrix_column($vv.view, $!matrix, $j);
}
method subrow-view(Math::Libgsl::Vector::View $vv, size_t $i where * < $!matrix.size1, size_t $offset, size_t $n) {
  Math::Libgsl::Vector.new: vector => mgsl_matrix_subrow($vv.view, $!matrix, $i, $offset, $n);
}
method subcol-view(Math::Libgsl::Vector::View $vv, size_t $j where * < $!matrix.size2, size_t $offset, size_t $n) {
  Math::Libgsl::Vector.new: vector => mgsl_matrix_subcolumn($vv.view, $!matrix, $j, $offset, $n);
}
method diagonal-view(Math::Libgsl::Vector::View $vv) {
  Math::Libgsl::Vector.new: vector => mgsl_matrix_diagonal($vv.view, $!matrix);
}
method subdiagonal-view(Math::Libgsl::Vector::View $vv, size_t $k where * < min($!matrix.size1, $!matrix.size2)) {
  Math::Libgsl::Vector.new: vector => mgsl_matrix_subdiagonal($vv.view, $!matrix, $k);
}
method superdiagonal-view(Math::Libgsl::Vector::View $vv, size_t $k where * < min($!matrix.size1, $!matrix.size2)) {
  Math::Libgsl::Vector.new: vector => mgsl_matrix_superdiagonal($vv.view, $!matrix, $k);
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
method tricpy(Math::Libgsl::Matrix $src where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2, Int $Uplo, Int $Diag) {
  my $ret;
  if $gsl-version > 2.5 {
    $ret = gsl_matrix_tricpy($Uplo, $Diag, $!matrix, $src.matrix);
  } else {
    $ret = gsl_matrix_tricpy($Uplo == CblasUpper ?? 'U'.ord !! 'L'.ord, $Diag == CblasUnit ?? 1 !! 0, $!matrix, $src.matrix);
  }
  fail X::Libgsl.new: errno => $ret, error => "Can't triangular-copy the matrix" if $ret ≠ GSL_SUCCESS;
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
method transpose-tricpy(Math::Libgsl::Matrix $src where $!matrix.size1 == .matrix.size2 && $!matrix.size2 == .matrix.size1, Int $Uplo, Int $Diag) {
  fail X::Libgsl.new: errno => GSL_ENOTSQR, error => "Not a square matrix" if $!matrix.size1 ≠ $!matrix.size2;
  my $ret;
  if $gsl-version > 2.5 {
    $ret = gsl_matrix_transpose_tricpy($Uplo, $Diag, $!matrix, $src.matrix);
  } else {
    $ret = gsl_matrix_transpose_tricpy($Uplo == CblasUpper ?? 'U'.ord !! 'L'.ord, $Diag == CblasUnit ?? 1 !! 0, $!matrix, $src.matrix);
  }
  fail X::Libgsl.new: errno => $ret, error => "Can't triangular-copy transpose" if $ret ≠ GSL_SUCCESS;
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

=begin code :lang<perl6>
say $vector[1];
=end code

or even:

=begin code :lang<perl6>
say $vector[^10];
=end code

=head3 set(Int:D $index! where * < $!vector.size, Num(Cool)

This method sets the value of a vector's element.
This method can be chained.
It is possible to address a vector element as a Raku array element:

=begin code :lang<perl6>
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

=head3 subvector(Math::Libgsl::Vector::View $vv, size_t $offset where * < $!vector.size, size_t $n)

Creates a view on a subset of the vector, starting from $offset and of length $n.
This method returns a new Vector object.
Any operation done on this view affects the original vector as well.

Every vector view operation works following this logic:

=begin code :lang<perl6>
use Math::Libgsl::Vector;

my Math::Libgsl::Vector $v1 .= new(:size(10));          # original vector
$v1.setall(1);
my Math::Libgsl::Vector::View $vv .= new;               # view: an object that will contain the view information
my Math::Libgsl::Vector $v2 = $v1.subvector($vv, 0, 3); # $v2 is the vector created from the view
$v2.setall(12);                                         # one can operate on $v2 as it is a normal vector
say $v1[^10]; # output: (12 12 12 1 1 1 1 1 1 1)        # but every operation will affect the original vector as well
=end code

=head3 subvector-stride(Math::Libgsl::Vector::View $vv, size_t $offset where * < $!vector.size, size_t $stride, size_t $n)

Creates a view on a subset of the vector, starting from $offset and of length $n, with stride $stride.
This method returns a new Vector object.
Any operation done on this view affects the original vector as well.

=head3 vec-view-array(Math::Libgsl::Vector::View $vv, @array)

This is not a method, but a sub; it's not imported unless one specifies :witsub.
It creates a Vector object from a Raku array.

=begin code :lang<perl6>
use Math::Libgsl::Vector;

my Math::Libgsl::Vector::View $vv .= new;
my @array = ^10;
my Math::Libgsl::Vector $v = vec-view-array($vv, @array);
say $v[^10]; # output: (0 1 2 3 4 5 6 7 8 9)
=end code

The name of this sub is different according to the data type. For example the sub that builds a Math::Libgsl::Vector::UInt64 is called vec-view-ulong-array().

When using a complex type (Complex64 and Complex32) the array elements are Nums; the real and imaginary part of the complex number are represented by two Nums, so to make a 10-element complex vector one needs a 20-element Num array.

=head3 vec-view-array-stride(Math::Libgsl::Vector::View $vv, @array, size_t $stride)

This is not a method, but a sub; it's not imported unless one specifies :witsub.
It creates a Vector object from a Raku array, with stride $stride.

The name of this sub is different according to the data type. For example the sub that builds a Math::Libgsl::Vector::UInt64 is called vec-view-ulong-array-stride().

When using a complex type (Complex64 and Complex32) the array elements are Nums; the real and imaginary part of the complex number are represented by two Nums, so to make a 10-element complex vector one needs a 20-element Num array.

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

=begin code :lang<perl6>
say $matrix[1;2];
=end code

=head3 set(Int:D $i! where * < $!matrix.size1, Int:D $j! where * < $!matrix.size2, Num(Cool)

This method sets the value of a matrix element.
This method can be chained.
It is possible to address a matrix element as a Raku shaped array element:

=begin code :lang<perl6>
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

=head3 submatrix(Math::Libgsl::Matrix::View $mv, size_t $k1 where * < $!matrix.size1, size_t $k2 where * < $!matrix.size2, size_t $n1, size_t $n2)

Creates a view on a subset of the matrix, starting from coordinates ($k1, $k2) with $n1 rows and $n2 columns.
This method returns a new Matrix object.
Any operation done on this view affects the original matrix as well.

Every matrix view operation works following this logic:

=begin code :lang<perl6>
use Math::Libgsl::Matrix;

my Math::Libgsl::Matrix $m1 .= new(:size1(3), :size2(4));     # original matrix
$m1.setall(1);
my Math::Libgsl::Matrix::View $mv .= new;                     # view: an object that will contain the view information
my Math::Libgsl::Matrix $m2 = $m1.submatrix($mv, 1, 1, 2, 2); # $m2 is the matrix created from the view
$m2.setall(12);                                               # one can operate on $m2 as it is a normal matrix
say ($m1.get-row($_) for ^3); # $m1 affected as well; output: ([1 1 1 1] [1 12 12 1] [1 12 12 1])
=end code

=head3 mat-view-array(Math::Libgsl::Matrix::View $mv, @array where { @array ~~ Array && @array.shape.elems == 2 })

This is not a method, but a sub; it's not imported unless one specifies :witsub.
It creates a Matrix object from the Raku shaped array.
When using a complex type (Complex64 and Complex32) the array elements are Nums; the real and imaginary part of the complex number are represented by two Nums, so the second index of the shaped array must be doubled.
For instance to get a 7x7 complex matrix, declare the array this way:

=begin code
my Num @data[7;14] = (…);
=end code

=head3 mat-view-array-tda(Math::Libgsl::Matrix::View $mv, @array where { @array ~~ Array && @array.shape.elems == 2 }, size_t $tda)

This is not a method, but a sub; it's not imported unless one specifies :witsub.
It creates a Matrix object from the Raku array, with a physical number of columns $tda which may differ from the correspondig dimension of the matrix.
When using a complex type (Complex64 and Complex32) the array elements are Nums; the real and imaginary part of the complex number are represented by two Nums, so the second index of the shaped array must be doubled.

=head3 mat-view-vector(Math::Libgsl::Matrix::View $mv, Math::Libgsl::Vector $v, size_t $n1, size_t $n2)

This is not a method, but a sub; it's not imported unless one specifies :witsub.
It creates a Matrix object from a Vector object. The resultimg matrix will have $n1 rows and $n2 columns.

=head3 mat-view-vector-tda(Math::Libgsl::Matrix::View $mv, Math::Libgsl::Vector $v, size_t $n1, size_t $n2, size_t $tda)

This is not a method, but a sub; it's not imported unless one specifies :witsub.
It creates a Matrix object from a Vector object, with a physical number of columns $tda which may differ from the correspondig dimension of the matrix. The resultimg matrix will have $n1 rows and $n2 columns.

=head3 row-view(Math::Libgsl::Vector::View $vv, size_t $i where * < $!matrix.size1)

This method creates a Vector object from row $i of the matrix.

=head3 col-view(Math::Libgsl::Vector::View $vv, size_t $j where * < $!matrix.size2)

This method creates a Vector object from column $j of the matrix.

=head3 subrow-view(Math::Libgsl::Vector::View $vv, size_t $i where * < $!matrix.size1, size_t $offset, size_t $n)

This method creates a Vector object from row $i of the matrix, starting from $offset and containing $n elements.

=head3 subcol-view(Math::Libgsl::Vector::View $vv, size_t $j where * < $!matrix.size2, size_t $offset, size_t $n)

This method creates a Vector object from column $j of the matrix, starting from $offset and containing $n elements.

=head3 diagonal-view(Math::Libgsl::Vector::View $vv)

This method creates a Vector object from the diagonal of the matrix.

=head3 subdiagonal-view(Math::Libgsl::Vector::View $vv, size_t $k where * < min($!matrix.size1, $!matrix.size2))

This method creates a Vector object from the subdiagonal number $k of the matrix.

=head3 superdiagonal-view(Math::Libgsl::Vector::View $vv, size_t $k where * < min($!matrix.size1, $!matrix.size2))

This method creates a Vector object from the superdiagonal number $k of the matrix.

=head3 copy(Math::Libgsl::Matrix $src where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2)

This method copies the $src matrix into the current one.
This method can be chained.

=head3 swap(Math::Libgsl::Matrix $src where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2)

This method swaps elements of the $src matrix and the current one.
This method can be chained.

=head3 tricpy(Math::Libgsl::Matrix $src where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2, Int $Uplo, Int $Diag)

This method copies the upper or lower trianglular matrix from B<$src> to b<self>.
Use the B<cblas-uplo> enumeration to specify which triangle copy.
Use the B<cblas-diag> enumeration to specify whether to copy the matrix diagonal.
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

=head3 transpose-tricpy(Math::Libgsl::Matrix $src where $!matrix.size1 == .matrix.size2 && $!matrix.size2 == .matrix.size1, Int $Uplo, Int $Diag)

This method copies a triangle from the B<$src> matrix into the current one, while transposing the elements.
Use the B<cblas-uplo> enumeration to specify which triangle copy.
Use the B<cblas-diag> enumeration to specify whether to copy the matrix diagonal.
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
