use v6;

unit class Math::Libgsl::Matrix::UInt8:ver<0.0.4>:auth<cpan:FRITH>;

use Math::Libgsl::Raw::Complex :ALL;
use Math::Libgsl::Raw::Matrix::UInt8 :ALL;
use Math::Libgsl::Exception;
use Math::Libgsl::Constants;
use Math::Libgsl::Vector::UInt8;
use NativeCall;

has gsl_matrix_uchar $.matrix;

multi method new(Int $size1!, Int $size2!)   { self.bless(:$size1, :$size2) }
multi method new(Int :$size1!, Int :$size2!) { self.bless(:$size1, :$size2) }
multi method new(gsl_matrix_uchar :$matrix!) { self.bless(:$matrix) }

submethod BUILD(Int :$size1?, Int :$size2?, gsl_matrix_uchar :$matrix?) {
  $!matrix = gsl_matrix_uchar_calloc($size1, $size2) if $size1.defined && $size2.defined;
  $!matrix = $matrix with $matrix;
}

submethod DESTROY {
  gsl_matrix_uchar_free($!matrix);
}
# Accessors
method get(Int:D $i! where * < $!matrix.size1, Int:D $j! where * < $!matrix.size2 --> Num) {
  gsl_matrix_uchar_get($!matrix, $i, $j)
}
method AT-POS(Math::Libgsl::Matrix::UInt8:D: Int:D $i! where * < $!matrix.size1, Int:D $j! where * < $!matrix.size2 --> Num) {
  gsl_matrix_uchar_get(self.matrix, $i, $j)
}
method set(Int:D $i! where * < $!matrix.size1, Int:D $j! where * < $!matrix.size2, Num(Cool) $x!) {
  gsl_matrix_uchar_set($!matrix, $i, $j, $x); self
}
method ASSIGN-POS(Math::Libgsl::Matrix::UInt8:D: Int:D $i! where * < $!matrix.size1, Int:D $j! where * < $!matrix.size2, Num(Cool) $x!) {
  gsl_matrix_uchar_set(self.matrix, $i, $j, $x)
}
method setall(Num(Cool) $x!) { gsl_matrix_uchar_set_all($!matrix, $x); self }
method zero() { gsl_matrix_uchar_set_zero($!matrix); self }
method identity() { gsl_matrix_uchar_set_identity($!matrix); self }
# IO
method write(Str $filename!) {
  my $ret = mgsl_matrix_uchar_fwrite($filename, $!matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't write the matrix" if $ret ≠ GSL_SUCCESS;
  self
}
method read(Str $filename!) {
  my $ret = mgsl_matrix_uchar_fread($filename, $!matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't read the matrix" if $ret ≠ GSL_SUCCESS;
  self
}
method printf(Str $filename!, Str $format!) {
  my $ret = mgsl_matrix_uchar_fprintf($filename, $!matrix, $format);
  fail X::Libgsl.new: errno => $ret, error => "Can't print the matrix" if $ret ≠ GSL_SUCCESS;
  self
}
method scanf(Str $filename!) {
  my $ret = mgsl_matrix_uchar_fscanf($filename, $!matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't scan the matrix" if $ret ≠ GSL_SUCCESS;
  self
}
# Copying matrices
method copy(Math::Libgsl::Matrix::UInt8 $src where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2) {
  my $ret = gsl_matrix_uchar_memcpy($!matrix, $src.matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't copy the matrix" if $ret ≠ GSL_SUCCESS;
  self
}
method swap(Math::Libgsl::Matrix::UInt8 $src where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2) {
  my $ret = gsl_matrix_uchar_swap($!matrix, $src.matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't swap the matrices" if $ret ≠ GSL_SUCCESS;
  self
}
# Rows and columns
method get-row(Int:D $i where * < $!matrix.size1) {
  my gsl_vector_uchar $v = gsl_vector_uchar_calloc($!matrix.size2);
  LEAVE { gsl_vector_uchar_free($v) }
  my $ret = gsl_matrix_uchar_get_row($v, $!matrix, $i);
  fail X::Libgsl.new: errno => $ret, error => "Can't get row" if $ret ≠ GSL_SUCCESS;
  my @row = gather take gsl_vector_uchar_get($v, $_) for ^$!matrix.size2;
}
method get-col(Int:D $j where * < $!matrix.size2) {
  my gsl_vector_uchar $v = gsl_vector_uchar_calloc($!matrix.size1);
  LEAVE { gsl_vector_uchar_free($v) }
  my $ret = gsl_matrix_uchar_get_col($v, $!matrix, $j);
  fail X::Libgsl.new: errno => $ret, error => "Can't get col" if $ret ≠ GSL_SUCCESS;
  my @col = gather take gsl_vector_uchar_get($v, $_) for ^$!matrix.size1;
}
multi method set-row(Int:D $i where * ≤ $!matrix.size1, @row where *.elems == $!matrix.size2) {
  my gsl_vector_uchar $v = gsl_vector_uchar_calloc($!matrix.size2);
  LEAVE { gsl_vector_uchar_free($v) }
  gsl_vector_uchar_set($v, $_, @row[$_].Num) for ^$!matrix.size2;
  my $ret = gsl_matrix_uchar_set_row($!matrix, $i, $v);
  fail X::Libgsl.new: errno => $ret, error => "Can't set row" if $ret ≠ GSL_SUCCESS;
  self
}
multi method set-row(Int:D $i where * ≤ $!matrix.size1, Math::Libgsl::Vector::UInt8 $v where .vector.size == $!matrix.size2) {
  my $ret = gsl_matrix_uchar_set_row($!matrix, $i, $v.vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't set row" if $ret ≠ GSL_SUCCESS;
  self
}
multi method set-col(Int:D $j where * ≤ $!matrix.size2, @col where *.elems == $!matrix.size1) {
  my gsl_vector_uchar $v = gsl_vector_uchar_calloc($!matrix.size1);
  LEAVE { gsl_vector_uchar_free($v) }
  gsl_vector_uchar_set($v, $_, @col[$_].Num) for ^$!matrix.size1;
  my $ret = gsl_matrix_uchar_set_col($!matrix, $j, $v);
  fail X::Libgsl.new: errno => $ret, error => "Can't set col" if $ret ≠ GSL_SUCCESS;
  self
}
multi method set-col(Int:D $j where * ≤ $!matrix.size2, Math::Libgsl::Vector::UInt8 $v where .vector.size == $!matrix.size1) {
  my $ret = gsl_matrix_uchar_set_col($!matrix, $j, $v.vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't set col" if $ret ≠ GSL_SUCCESS;
  self
}
# Exchanging rows and columns
method swap-rows(Int:D $i where * ≤ $!matrix.size1, Int:D $j where * ≤ $!matrix.size1) {
  my $ret = gsl_matrix_uchar_swap_rows($!matrix, $i, $j);
  fail X::Libgsl.new: errno => $ret, error => "Can't swap rows" if $ret ≠ GSL_SUCCESS;
  self
}
method swap-cols(Int:D $i where * ≤ $!matrix.size2, Int:D $j where * ≤ $!matrix.size2) {
  my $ret = gsl_matrix_uchar_swap_columns($!matrix, $i, $j);
  fail X::Libgsl.new: errno => $ret, error => "Can't swap columns" if $ret ≠ GSL_SUCCESS;
  self
}
method swap-rowcol(Int:D $i where * ≤ $!matrix.size1, Int:D $j where * ≤ $!matrix.size1) {
  fail X::Libgsl.new: errno => GSL_ENOTSQR, error => "Not a square matrix" if $!matrix.size1 ≠ $!matrix.size2;
  my $ret = gsl_matrix_uchar_swap_rowcol($!matrix, $i, $j);
  fail X::Libgsl.new: errno => $ret, error => "Can't swap row & column" if $ret ≠ GSL_SUCCESS;
  self
}
method copy-transpose(Math::Libgsl::Matrix::UInt8 $src where $!matrix.size1 == .matrix.size2 && $!matrix.size2 == .matrix.size1) {
  my $ret = gsl_matrix_uchar_transpose_memcpy($!matrix, $src.matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't copy and transpose" if $ret ≠ GSL_SUCCESS;
  self
}
method transpose() {
  fail X::Libgsl.new: errno => GSL_ENOTSQR, error => "Not a square matrix" if $!matrix.size1 ≠ $!matrix.size2;
  my $ret = gsl_matrix_uchar_transpose($!matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't transpose" if $ret ≠ GSL_SUCCESS;
  self
}
# Matrix operations
method add(Math::Libgsl::Matrix::UInt8 $b where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2) {
  my $ret = gsl_matrix_uchar_add($!matrix, $b.matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't add" if $ret ≠ GSL_SUCCESS;
  self
}
method sub(Math::Libgsl::Matrix::UInt8 $b where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2) {
  my $ret = gsl_matrix_uchar_sub($!matrix, $b.matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't sub" if $ret ≠ GSL_SUCCESS;
  self
}
method mul(Math::Libgsl::Matrix::UInt8 $b where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2) {
  my $ret = gsl_matrix_uchar_mul_elements($!matrix, $b.matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't mul" if $ret ≠ GSL_SUCCESS;
  self
}
method div(Math::Libgsl::Matrix::UInt8 $b where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2) {
  my $ret = gsl_matrix_uchar_div_elements($!matrix, $b.matrix);
  fail X::Libgsl.new: errno => $ret, error => "Can't div" if $ret ≠ GSL_SUCCESS;
  self
}
method scale(Num(Cool) $x) {
  my $ret = gsl_matrix_uchar_scale($!matrix, $x);
  fail X::Libgsl.new: errno => $ret, error => "Can't scale" if $ret ≠ GSL_SUCCESS;
  self
}
method add-constant(Num(Cool) $x) {
  my $ret = gsl_matrix_uchar_add_constant($!matrix, $x);
  fail X::Libgsl.new: errno => $ret, error => "Can't add constant" if $ret ≠ GSL_SUCCESS;
  self
}
# Finding maximum and minimum elements of matrices
method max(--> Num) { gsl_matrix_uchar_max($!matrix) }
method min(--> Num) { gsl_matrix_uchar_min($!matrix) }
method minmax(--> List) {
  my uint8 ($min, $max);
  gsl_matrix_uchar_minmax($!matrix, $min, $max);
  return $min, $max;
}
method max-index(--> List) {
  my size_t ($imax, $jmax);
  gsl_matrix_uchar_max_index($!matrix, $imax, $jmax);
  return $imax, $jmax;
}
method min-index(--> List) {
  my size_t ($imin, $jmin);
  gsl_matrix_uchar_min_index($!matrix, $imin, $jmin);
  return $imin, $jmin;
}
method minmax-index(--> List) {
  my size_t ($imin, $jmin, $imax, $jmax);
  gsl_matrix_uchar_minmax_index($!matrix, $imin, $jmin, $imax, $jmax);
  return $imin, $jmin, $imax, $jmax;
}
# Matrix properties
method is-null(--> Bool)   { gsl_matrix_uchar_isnull($!matrix)   ?? True !! False }
method is-pos(--> Bool)    { gsl_matrix_uchar_ispos($!matrix)    ?? True !! False }
method is-neg(--> Bool)    { gsl_matrix_uchar_isneg($!matrix)    ?? True !! False }
method is-nonneg(--> Bool) { gsl_matrix_uchar_isnonneg($!matrix) ?? True !! False }
method is-equal(Math::Libgsl::Matrix::UInt8 $b --> Bool) { gsl_matrix_uchar_equal($!matrix, $b.matrix) ?? True !! False }
