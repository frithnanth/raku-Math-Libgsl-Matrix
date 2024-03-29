use v6;

unit class Math::Libgsl::Matrix::Int64:ver<0.6.1>:auth<zef:FRITH>;

use Math::Libgsl::Raw::Matrix::Int64 :ALL;
use Math::Libgsl::Exception;
use Math::Libgsl::Constants;
use Math::Libgsl::Vector::Int64;
use NativeCall;

class View {
  has gsl_matrix_long_view $.view;
  submethod BUILD { $!view = alloc_gsl_matrix_long_view }
  submethod DESTROY { free_gsl_matrix_long_view($!view) }
  method submatrix(Math::Libgsl::Matrix::Int64 $m, size_t $k1 where * < $m.size1, size_t $k2 where * < $m.size2, size_t $n1, size_t $n2) {
    fail X::Libgsl.new: errno => GSL_EDOM, error => "Submatrix indices out of bound" if $k1 + $n1 > $m.size1 || $k2 + $n2 > $m.size2;
    Math::Libgsl::Matrix::Int64.new: matrix => mgsl_matrix_long_submatrix($!view, $m.matrix, $k1, $k2, $n1, $n2);
  }
  method vector(Math::Libgsl::Vector::Int64 $v, size_t $n1, size_t $n2 --> Math::Libgsl::Matrix::Int64) {
    Math::Libgsl::Matrix::Int64.new: matrix => mgsl_matrix_long_view_vector($!view, $v.vector, $n1, $n2);
  }
  method vector-tda(Math::Libgsl::Vector::Int64 $v, size_t $n1, size_t $n2, size_t $tda where * > $n2 --> Math::Libgsl::Matrix::Int64) {
    Math::Libgsl::Matrix::Int64.new: matrix => mgsl_matrix_long_view_vector_with_tda($!view, $v.vector, $n1, $n2, $tda);
  }
  method array($array, UInt $size1, UInt $size2 --> Math::Libgsl::Matrix::Int64) {
    Math::Libgsl::Matrix::Int64.new: matrix => mgsl_matrix_long_view_array($!view, $array, $size1, $size2);
  }
  method array-tda($array, UInt $size1, UInt $size2, size_t $tda where * > $size2 --> Math::Libgsl::Matrix::Int64) {
    Math::Libgsl::Matrix::Int64.new: matrix => mgsl_matrix_long_view_array_with_tda($!view, $array, $size1, $size2, $tda);
  }
}

has gsl_matrix_long $.matrix;
has Bool            $.view = False;

multi method new(Int $size1!, Int $size2!)   { self.bless(:$size1, :$size2) }
multi method new(Int :$size1!, Int :$size2!) { self.bless(:$size1, :$size2) }
multi method new(gsl_matrix_long :$matrix!) { self.bless(:$matrix) }

submethod BUILD(Int :$size1?, Int :$size2?, gsl_matrix_long :$matrix?) {
  $!matrix = gsl_matrix_long_calloc($size1, $size2) if $size1.defined && $size2.defined;
  with $matrix {
    $!matrix = $matrix;
    $!view   = True;
  }
}

submethod DESTROY {
  gsl_matrix_long_free($!matrix) unless $!view;
}

multi method list(Math::Libgsl::Matrix::Int64: --> List) {
  my gsl_vector_long $v = gsl_vector_long_calloc($!matrix.size2);
  LEAVE { gsl_vector_long_free($v) }

  do for ^$!matrix.size1 {
    gsl_matrix_long_get_row($v, $!matrix, $_);
    (^$v.size).map( { gsl_vector_long_get($v, $_) } ).eager;
  }
}
multi method gist(Math::Libgsl::Matrix::Int64: --> Str) {
  my ($size1, $ellip1) = $!matrix.size1 > 10 ?? (10, ' ...') !! ($!matrix.size1, '');
  my ($size2, $ellip2) = $!matrix.size2 > 10 ?? (10, '...')  !! ($!matrix.size2, '');

  my gsl_vector_long $v = gsl_vector_long_calloc($!matrix.size2);
  LEAVE { gsl_vector_long_free($v) }

  '(' ~
  do for ^$size1 {
    gsl_matrix_long_get_row($v, $!matrix, $_);
    '(' ~ (^$size2).map({ gsl_vector_long_get($v, $_) }).Str ~ "$ellip1)\n";
  } ~ "$ellip2)"
}
multi method Str(Math::Libgsl::Matrix::Int64: --> Str) { self.list.join(' ') }
# Accessors
method get(Int:D $i! where * < $!matrix.size1, Int:D $j! where * < $!matrix.size2 --> Num) {
  gsl_matrix_long_get($!matrix, $i, $j)
}
method AT-POS(Math::Libgsl::Matrix::Int64:D: Int:D $i! where * < $!matrix.size1, Int:D $j! where * < $!matrix.size2 --> Num) {
  gsl_matrix_long_get(self.matrix, $i, $j)
}
method set(Int:D $i! where * < $!matrix.size1, Int:D $j! where * < $!matrix.size2, Num(Cool) $x!) {
  gsl_matrix_long_set($!matrix, $i, $j, $x); self
}
method ASSIGN-POS(Math::Libgsl::Matrix::Int64:D: Int:D $i! where * < $!matrix.size1, Int:D $j! where * < $!matrix.size2, Num(Cool) $x!) {
  gsl_matrix_long_set(self.matrix, $i, $j, $x)
}
method setall(Num(Cool) $x!) { gsl_matrix_long_set_all($!matrix, $x); self }
method zero() { gsl_matrix_long_set_zero($!matrix); self }
method identity() { gsl_matrix_long_set_identity($!matrix); self }
# IO
method write(Str $filename!) {
  my $ret = mgsl_matrix_long_fwrite($filename, $!matrix);
  X::Libgsl.new(errno => $ret, error => "Can't write the matrix").throw if $ret ≠ GSL_SUCCESS;
  self
}
method read(Str $filename!) {
  my $ret = mgsl_matrix_long_fread($filename, $!matrix);
  X::Libgsl.new(errno => $ret, error => "Can't read the matrix").throw if $ret ≠ GSL_SUCCESS;
  self
}
method printf(Str $filename!, Str $format!) {
  my $ret = mgsl_matrix_long_fprintf($filename, $!matrix, $format);
  X::Libgsl.new(errno => $ret, error => "Can't print the matrix").throw if $ret ≠ GSL_SUCCESS;
  self
}
method scanf(Str $filename!) {
  my $ret = mgsl_matrix_long_fscanf($filename, $!matrix);
  X::Libgsl.new(errno => $ret, error => "Can't scan the matrix").throw if $ret ≠ GSL_SUCCESS;
  self
}
# View
method row-view(Math::Libgsl::Vector::Int64::View $vv, size_t $i where * < $!matrix.size1 --> Math::Libgsl::Vector::Int64) {
  Math::Libgsl::Vector::Int64.new: vector => mgsl_matrix_long_row($vv.view, $!matrix, $i);
}
method col-view(Math::Libgsl::Vector::Int64::View $vv, size_t $j where * < $!matrix.size2 --> Math::Libgsl::Vector::Int64) {
  Math::Libgsl::Vector::Int64.new: vector => mgsl_matrix_long_column($vv.view, $!matrix, $j);
}
method subrow-view(Math::Libgsl::Vector::Int64::View $vv, size_t $i where * < $!matrix.size1, size_t $offset, size_t $n --> Math::Libgsl::Vector::Int64) {
  Math::Libgsl::Vector::Int64.new: vector => mgsl_matrix_long_subrow($vv.view, $!matrix, $i, $offset, $n);
}
method subcol-view(Math::Libgsl::Vector::Int64::View $vv, size_t $j where * < $!matrix.size2, size_t $offset, size_t $n --> Math::Libgsl::Vector::Int64) {
  Math::Libgsl::Vector::Int64.new: vector => mgsl_matrix_long_subcolumn($vv.view, $!matrix, $j, $offset, $n);
}
method diagonal-view(Math::Libgsl::Vector::Int64::View $vv --> Math::Libgsl::Vector::Int64) {
  Math::Libgsl::Vector::Int64.new: vector => mgsl_matrix_long_diagonal($vv.view, $!matrix);
}
method subdiagonal-view(Math::Libgsl::Vector::Int64::View $vv, size_t $k where * < min($!matrix.size1, $!matrix.size2) --> Math::Libgsl::Vector::Int64) {
  Math::Libgsl::Vector::Int64.new: vector => mgsl_matrix_long_subdiagonal($vv.view, $!matrix, $k);
}
method superdiagonal-view(Math::Libgsl::Vector::Int64::View $vv, size_t $k where * < min($!matrix.size1, $!matrix.size2) --> Math::Libgsl::Vector::Int64) {
  Math::Libgsl::Vector::Int64.new: vector => mgsl_matrix_long_superdiagonal($vv.view, $!matrix, $k);
}
sub int64-prepmat(*@array --> CArray[int64]) is export {
  my CArray[int64] $array .= new: @array».Int;
}
sub int64-array-mat(Block $bl, UInt $size1, UInt $size2, *@data) is export {
  my CArray[int64] $carray .= new: @data».Int;
  my Math::Libgsl::Matrix::Int64::View $mv .= new;
  my $m = $mv.array($carray, $size1, $size2);
  $bl($m);
}
sub int64-array-tda-mat(Block $bl, UInt $size1, UInt $size2, size_t $tda where * > $size2, *@data) is export {
  my CArray[int64] $carray .= new: @data».Int;
  my Math::Libgsl::Matrix::Int64::View $mv .= new;
  my $m = $mv.array-tda($carray, $size1, $size2, $tda);
  $bl($m);
}
# Copying matrices
method copy(Math::Libgsl::Matrix::Int64 $src where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2) {
  my $ret = gsl_matrix_long_memcpy($!matrix, $src.matrix);
  X::Libgsl.new(errno => $ret, error => "Can't copy the matrix").throw if $ret ≠ GSL_SUCCESS;
  self
}
method swap(Math::Libgsl::Matrix::Int64 $src where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2) {
  my $ret = gsl_matrix_long_swap($!matrix, $src.matrix);
  X::Libgsl.new(errno => $ret, error => "Can't swap the matrices").throw if $ret ≠ GSL_SUCCESS;
  self
}
method tricpy(Math::Libgsl::Matrix::Int64 $src where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2, Int $Uplo, Int $Diag) {
  my $ret;
  if $gsl-version > v2.5 {
    $ret = gsl_matrix_long_tricpy($Uplo, $Diag, $!matrix, $src.matrix);
  } else {
    $ret = gsl_matrix_long_tricpy($Uplo == CblasUpper ?? 'U'.ord !! 'L'.ord, $Diag == CblasUnit ?? 0 !! 1, $!matrix, $src.matrix);
  }
  X::Libgsl.new(errno => $ret, error => "Can't triangular-copy the matrix").throw if $ret ≠ GSL_SUCCESS;
  self
}
# Rows and columns
method get-row(Int:D $i where * < $!matrix.size1) {
  my gsl_vector_long $v = gsl_vector_long_calloc($!matrix.size2);
  LEAVE { gsl_vector_long_free($v) }
  my $ret = gsl_matrix_long_get_row($v, $!matrix, $i);
  fail X::Libgsl.new: errno => $ret, error => "Can't get row" if $ret ≠ GSL_SUCCESS;
  my @row = gather take gsl_vector_long_get($v, $_) for ^$!matrix.size2;
}
method get-col(Int:D $j where * < $!matrix.size2) {
  my gsl_vector_long $v = gsl_vector_long_calloc($!matrix.size1);
  LEAVE { gsl_vector_long_free($v) }
  my $ret = gsl_matrix_long_get_col($v, $!matrix, $j);
  fail X::Libgsl.new: errno => $ret, error => "Can't get col" if $ret ≠ GSL_SUCCESS;
  my @col = gather take gsl_vector_long_get($v, $_) for ^$!matrix.size1;
}
multi method set-row(Int:D $i where * ≤ $!matrix.size1, @row where *.elems == $!matrix.size2) {
  my gsl_vector_long $v = gsl_vector_long_calloc($!matrix.size2);
  LEAVE { gsl_vector_long_free($v) }
  gsl_vector_long_set($v, $_, @row[$_].Num) for ^$!matrix.size2;
  my $ret = gsl_matrix_long_set_row($!matrix, $i, $v);
  X::Libgsl.new(errno => $ret, error => "Can't set row").throw if $ret ≠ GSL_SUCCESS;
  self
}
multi method set-row(Int:D $i where * ≤ $!matrix.size1, Math::Libgsl::Vector::Int64 $v where .vector.size == $!matrix.size2) {
  my $ret = gsl_matrix_long_set_row($!matrix, $i, $v.vector);
  X::Libgsl.new(errno => $ret, error => "Can't set row").throw if $ret ≠ GSL_SUCCESS;
  self
}
multi method set-col(Int:D $j where * ≤ $!matrix.size2, @col where *.elems == $!matrix.size1) {
  my gsl_vector_long $v = gsl_vector_long_calloc($!matrix.size1);
  LEAVE { gsl_vector_long_free($v) }
  gsl_vector_long_set($v, $_, @col[$_].Num) for ^$!matrix.size1;
  my $ret = gsl_matrix_long_set_col($!matrix, $j, $v);
  X::Libgsl.new(errno => $ret, error => "Can't set col").throw if $ret ≠ GSL_SUCCESS;
  self
}
multi method set-col(Int:D $j where * ≤ $!matrix.size2, Math::Libgsl::Vector::Int64 $v where .vector.size == $!matrix.size1) {
  my $ret = gsl_matrix_long_set_col($!matrix, $j, $v.vector);
  X::Libgsl.new(errno => $ret, error => "Can't set col").throw if $ret ≠ GSL_SUCCESS;
  self
}
# Exchanging rows and columns
method swap-rows(Int:D $i where * ≤ $!matrix.size1, Int:D $j where * ≤ $!matrix.size1) {
  my $ret = gsl_matrix_long_swap_rows($!matrix, $i, $j);
  X::Libgsl.new(errno => $ret, error => "Can't swap rows").throw if $ret ≠ GSL_SUCCESS;
  self
}
method swap-cols(Int:D $i where * ≤ $!matrix.size2, Int:D $j where * ≤ $!matrix.size2) {
  my $ret = gsl_matrix_long_swap_columns($!matrix, $i, $j);
  X::Libgsl.new(errno => $ret, error => "Can't swap columns").throw if $ret ≠ GSL_SUCCESS;
  self
}
method swap-rowcol(Int:D $i where * ≤ $!matrix.size1, Int:D $j where * ≤ $!matrix.size1) {
  X::Libgsl.new(errno => GSL_ENOTSQR, error => "Not a square matrix").throw if $!matrix.size1 ≠ $!matrix.size2;
  my $ret = gsl_matrix_long_swap_rowcol($!matrix, $i, $j);
  X::Libgsl.new(errno => $ret, error => "Can't swap row & column").throw if $ret ≠ GSL_SUCCESS;
  self
}
method copy-transpose(Math::Libgsl::Matrix::Int64 $src where $!matrix.size1 == .matrix.size2 && $!matrix.size2 == .matrix.size1) {
  my $ret = gsl_matrix_long_transpose_memcpy($!matrix, $src.matrix);
  X::Libgsl.new(errno => $ret, error => "Can't copy and transpose").throw if $ret ≠ GSL_SUCCESS;
  self
}
method transpose() {
  X::Libgsl.new(errno => GSL_ENOTSQR, error => "Not a square matrix").throw if $!matrix.size1 ≠ $!matrix.size2;
  my $ret = gsl_matrix_long_transpose($!matrix);
  X::Libgsl.new(errno => $ret, error => "Can't transpose").throw if $ret ≠ GSL_SUCCESS;
  self
}
method transpose-tricpy(Math::Libgsl::Matrix::Int64 $src where $!matrix.size1 == .matrix.size2 && $!matrix.size2 == .matrix.size1, Int $Uplo, Int $Diag) {
  X::Libgsl.new(errno => GSL_ENOTSQR, error => "Not a square matrix").throw if $!matrix.size1 ≠ $!matrix.size2;
  my $ret;
  if $gsl-version > v2.5 {
    $ret = gsl_matrix_long_transpose_tricpy($Uplo, $Diag, $!matrix, $src.matrix);
  } else {
    $ret = gsl_matrix_long_transpose_tricpy($Uplo == CblasUpper ?? 'U'.ord !! 'L'.ord, $Diag == CblasUnit ?? 0 !! 1, $!matrix, $src.matrix);
  }
  X::Libgsl.new(errno => $ret, error => "Can't triangular-copy transpose").throw if $ret ≠ GSL_SUCCESS;
  self
}
# Matrix operations
method add(Math::Libgsl::Matrix::Int64 $b where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2) {
  my $ret = gsl_matrix_long_add($!matrix, $b.matrix);
  X::Libgsl.new(errno => $ret, error => "Can't add").throw if $ret ≠ GSL_SUCCESS;
  self
}
method sub(Math::Libgsl::Matrix::Int64 $b where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2) {
  my $ret = gsl_matrix_long_sub($!matrix, $b.matrix);
  X::Libgsl.new(errno => $ret, error => "Can't sub").throw if $ret ≠ GSL_SUCCESS;
  self
}
method mul(Math::Libgsl::Matrix::Int64 $b where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2) {
  my $ret = gsl_matrix_long_mul_elements($!matrix, $b.matrix);
  X::Libgsl.new(errno => $ret, error => "Can't mul").throw if $ret ≠ GSL_SUCCESS;
  self
}
method div(Math::Libgsl::Matrix::Int64 $b where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2) {
  my $ret = gsl_matrix_long_div_elements($!matrix, $b.matrix);
  X::Libgsl.new(errno => $ret, error => "Can't div").throw if $ret ≠ GSL_SUCCESS;
  self
}
method scale(Num(Cool) $x) {
  my $ret = gsl_matrix_long_scale($!matrix, $x);
  X::Libgsl.new(errno => $ret, error => "Can't scale").throw if $ret ≠ GSL_SUCCESS;
  self
}
method scale-rows(Math::Libgsl::Vector::Int64 $x where .size == $!matrix.size1) {
  X::Libgsl.new(errno => GSL_FAILURE, error => "Error in scale-rows: version < v2.7").throw if $gsl-version < v2.7;
  my $ret = gsl_matrix_long_scale_rows($!matrix, $x.vector);
  X::Libgsl.new(errno => $ret, error => "Can't scale-rows").throw if $ret ≠ GSL_SUCCESS;
  self
}
method scale-columns(Math::Libgsl::Vector::Int64 $x where .size == $!matrix.size2) {
  X::Libgsl.new(errno => GSL_FAILURE, error => "Error in scale-columns: version < v2.7").throw if $gsl-version < v2.7;
  my $ret = gsl_matrix_long_scale_columns($!matrix, $x.vector);
  X::Libgsl.new(errno => $ret, error => "Can't scale-columns").throw if $ret ≠ GSL_SUCCESS;
  self
}
method add-constant(Num(Cool) $x) {
  my $ret = gsl_matrix_long_add_constant($!matrix, $x);
  X::Libgsl.new(errno => $ret, error => "Can't add constant").throw if $ret ≠ GSL_SUCCESS;
  self
}
# Finding maximum and minimum elements of matrices
method max(--> Num) { gsl_matrix_long_max($!matrix) }
method min(--> Num) { gsl_matrix_long_min($!matrix) }
method minmax(--> List) {
  my int64 ($min, $max);
  gsl_matrix_long_minmax($!matrix, $min, $max);
  return $min, $max;
}
method max-index(--> List) {
  my size_t ($imax, $jmax);
  gsl_matrix_long_max_index($!matrix, $imax, $jmax);
  return $imax, $jmax;
}
method min-index(--> List) {
  my size_t ($imin, $jmin);
  gsl_matrix_long_min_index($!matrix, $imin, $jmin);
  return $imin, $jmin;
}
method minmax-index(--> List) {
  my size_t ($imin, $jmin, $imax, $jmax);
  gsl_matrix_long_minmax_index($!matrix, $imin, $jmin, $imax, $jmax);
  return $imin, $jmin, $imax, $jmax;
}
# Matrix properties
method is-null(--> Bool)   { gsl_matrix_long_isnull($!matrix)   ?? True !! False }
method is-pos(--> Bool)    { gsl_matrix_long_ispos($!matrix)    ?? True !! False }
method is-neg(--> Bool)    { gsl_matrix_long_isneg($!matrix)    ?? True !! False }
method is-nonneg(--> Bool) { gsl_matrix_long_isnonneg($!matrix) ?? True !! False }
method is-equal(Math::Libgsl::Matrix::Int64 $b --> Bool) { gsl_matrix_long_equal($!matrix, $b.matrix) ?? True !! False }
method norm1(--> Int) {
  fail X::Libgsl.new: errno => GSL_FAILURE, error => "Error in norm1: version < v2.7" if $gsl-version < v2.7;
  gsl_matrix_long_norm1($!matrix)
}
