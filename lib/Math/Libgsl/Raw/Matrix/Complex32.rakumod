use v6;

unit module Math::Libgsl::Raw::Matrix::Complex32:ver<0.0.5>:auth<cpan:FRITH>;

use Math::Libgsl::Raw::Complex :ALL;
use Math::Libgsl::Raw::Matrix::Num32;
use NativeCall;
use LibraryMake;

constant GSLHELPER = %?RESOURCES<libraries/gslhelper>.absolute;

constant LIB  = ('gsl', v23);

class gsl_block_complex_float is repr('CStruct') is export {
  has size_t          $.size;
  has Pointer[num32]  $.data;
}

class gsl_vector_complex_float is repr('CStruct') is export {
  has size_t                  $.size;
  has size_t                  $.stride;
  has Pointer[num32]          $.data;
  has gsl_block_complex_float $.block;
  has int32                   $.owner;
}

class gsl_vector_complex_float_view is repr('CStruct') is export {
  HAS gsl_vector_complex_float      $.vector;
}

class gsl_matrix_complex_float is repr('CStruct') is export {
  has size_t                  $.size1;
  has size_t                  $.size2;
  has size_t                  $.tda;
  has Pointer[num32]          $.data;
  has gsl_block_complex_float $.block;
  has int32                   $.owner;
}

class gsl_matrix_complex_float_view is repr('CStruct') is export {
  HAS gsl_matrix_complex_float      $.matrix;
}

# Block allocation
sub gsl_block_complex_float_alloc(size_t $n --> gsl_block_complex_float) is native(LIB) is export(:block) { * }
sub gsl_block_complex_float_calloc(size_t $n --> gsl_block_complex_float) is native(LIB) is export(:block) { * }
sub gsl_block_complex_float_free(gsl_block_complex_float $b) is native(LIB) is export(:block) { * }
# Reading and writing blocks
sub mgsl_block_complex_float_fwrite(Str $filename, gsl_block_complex_float $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_complex_float_fread(Str $filename, gsl_block_complex_float $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_complex_float_fprintf(Str $filename, gsl_block_complex_float $b, Str $format --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_complex_float_fscanf(Str $filename, gsl_block_complex_float $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
# Vector allocation
sub gsl_vector_complex_float_alloc(size_t $n --> gsl_vector_complex_float) is native(LIB) is export(:vector) { * }
sub gsl_vector_complex_float_calloc(size_t $n --> gsl_vector_complex_float) is native(LIB) is export(:vector) { * }
sub gsl_vector_complex_float_free(gsl_vector_complex_float $v) is native(LIB) is export(:vector) { * }
# Accessing vector elements
sub mgsl_vector_complex_float_get(gsl_vector_complex_float $v, size_t $i, gsl_complex_float $res) is native(GSLHELPER) is export(:vector) { * }
sub mgsl_vector_complex_float_set(gsl_vector_complex_float $v, size_t $i, gsl_complex_float $x) is native(GSLHELPER) is export(:vector) { * }
# Initializing vector elements
sub mgsl_vector_complex_float_set_all(gsl_vector_complex_float $v, gsl_complex_float $x) is native(GSLHELPER) is export(:vectorio) { * }
sub gsl_vector_complex_float_set_zero(gsl_vector_complex_float $v) is native(LIB) is export(:vectorio) { * }
sub gsl_vector_complex_float_set_basis(gsl_vector_complex_float $v, size_t $i --> int32) is native(LIB) is export(:vectorio) { * }
# Reading and writing vectors
sub mgsl_vector_complex_float_fwrite(Str $filename, gsl_vector_complex_float $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_complex_float_fread(Str $filename, gsl_vector_complex_float $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_complex_float_fprintf(Str $filename, gsl_vector_complex_float $v, Str $format --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_complex_float_fscanf(Str $filename, gsl_vector_complex_float $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
# Vector views
sub mgsl_vector_complex_float_real(gsl_vector_float_view $view, gsl_vector_complex_float $v --> gsl_vector_float) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_complex_float_imag(gsl_vector_float_view $view, gsl_vector_complex_float $v --> gsl_vector_float) is native(GSLHELPER) is export(:vectorview) { * }
sub alloc_gsl_vector_complex_float_view(--> gsl_vector_complex_float_view) is native(GSLHELPER) is export(:vectorview) { * }
sub free_gsl_vector_complex_float_view(gsl_vector_complex_float_view $vv) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_complex_float_subvector(gsl_vector_complex_float_view $view, gsl_vector_complex_float $v, size_t $offset, size_t $n --> gsl_vector_complex_float) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_complex_float_subvector_with_stride(gsl_vector_complex_float_view $view, gsl_vector_complex_float $v, size_t $offset, size_t $stride, size_t $n --> gsl_vector_complex_float) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_complex_float_view_array(gsl_vector_complex_float_view $view, CArray[num32] $base, size_t $n --> gsl_vector_complex_float) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_complex_float_view_array_with_stride(gsl_vector_complex_float_view $view, CArray[num32] $base, size_t $stride, size_t $n --> gsl_vector_complex_float) is native(GSLHELPER) is export(:vectorview) { * }
# Copying vectors
sub gsl_vector_complex_float_memcpy(gsl_vector_complex_float $dest, gsl_vector_complex_float $src --> int32) is native(LIB) is export(:vectorcopy) { * }
sub gsl_vector_complex_float_swap(gsl_vector_complex_float $v, gsl_vector_complex_float $w --> int32) is native(LIB) is export(:vectorcopy) { * }
# Exchanging elements
sub gsl_vector_complex_float_swap_elements(gsl_vector_complex_float $v, size_t $i, size_t $j --> int32) is native(LIB) is export(:vectorelem) { * }
sub gsl_vector_complex_float_reverse(gsl_vector_complex_float $v --> int32) is native(LIB) is export(:vectorelem) { * }
# Vector operations
sub gsl_vector_complex_float_add(gsl_vector_complex_float $a, gsl_vector_complex_float $b --> int32) is native(LIB) is export(:vectorop) { * }
sub gsl_vector_complex_float_sub(gsl_vector_complex_float $a, gsl_vector_complex_float $b --> int32) is native(LIB) is export(:vectorop) { * }
sub gsl_vector_complex_float_mul(gsl_vector_complex_float $a, gsl_vector_complex_float $b --> int32) is native(LIB) is export(:vectorop) { * }
sub gsl_vector_complex_float_div(gsl_vector_complex_float $a, gsl_vector_complex_float $b --> int32) is native(LIB) is export(:vectorop) { * }
sub mgsl_vector_complex_float_scale(gsl_vector_complex_float $a, gsl_complex_float $x --> int32) is native(GSLHELPER) is export(:vectorop) { * }
sub mgsl_vector_complex_float_add_constant(gsl_vector_complex_float $a, gsl_complex_float $x --> int32) is native(GSLHELPER) is export(:vectorop) { * }
# Vector properties
sub gsl_vector_complex_float_isnull(gsl_vector_complex_float $v --> int32) is native(LIB) is export(:vectorprop) { * }
sub gsl_vector_complex_float_ispos(gsl_vector_complex_float $v --> int32) is native(LIB) is export(:vectorprop) { * }
sub gsl_vector_complex_float_isneg(gsl_vector_complex_float $v --> int32) is native(LIB) is export(:vectorprop) { * }
sub gsl_vector_complex_float_isnonneg(gsl_vector_complex_float $v --> int32) is native(LIB) is export(:vectorprop) { * }
sub gsl_vector_complex_float_equal(gsl_vector_complex_float $u, gsl_vector_complex_float $v --> int32) is native(LIB) is export(:vectorprop) { * }
# Matrix allocation
sub gsl_matrix_complex_float_alloc(size_t $n1, size_t $n2 --> gsl_matrix_complex_float) is native(LIB) is export(:matrix) { * }
sub gsl_matrix_complex_float_calloc(size_t $n1, size_t $n2 --> gsl_matrix_complex_float) is native(LIB) is export(:matrix) { * }
sub gsl_matrix_complex_float_free(gsl_matrix_complex_float $m) is native(LIB) is export(:matrix) { * }
# Accessing matrix elements
sub mgsl_matrix_complex_float_get(gsl_matrix_complex_float $m, size_t $i, size_t $j, gsl_complex_float $res) is native(GSLHELPER) is export(:matrix) { * }
sub mgsl_matrix_complex_float_set(gsl_matrix_complex_float $m, size_t $i, size_t $j, gsl_complex_float $x) is native(GSLHELPER) is export(:matrix) { * }
# Initializing matrix elements
sub mgsl_matrix_complex_float_set_all(gsl_matrix_complex_float $m, gsl_complex_float $x) is native(GSLHELPER) is export(:matrixio) { * }
sub gsl_matrix_complex_float_set_zero(gsl_matrix_complex_float $m) is native(LIB) is export(:matrixio) { * }
sub gsl_matrix_complex_float_set_identity(gsl_matrix_complex_float $m) is native(LIB) is export(:matrixio) { * }
# Reading and writing matrices
sub mgsl_matrix_complex_float_fwrite(Str $filename, gsl_matrix_complex_float $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_complex_float_fread(Str $filename, gsl_matrix_complex_float $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_complex_float_fprintf(Str $filename, gsl_matrix_complex_float $m, Str $format --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_complex_float_fscanf(Str $filename, gsl_matrix_complex_float $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
# Matrix views
sub alloc_gsl_matrix_complex_float_view(--> gsl_matrix_complex_float_view) is native(GSLHELPER) is export(:matrixview) { * }
sub free_gsl_matrix_complex_float_view(gsl_matrix_complex_float_view $mv) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_float_submatrix(gsl_matrix_complex_float_view $view, gsl_matrix_complex_float $m, size_t $k1, size_t $k2, size_t $n1, size_t $n2 --> gsl_matrix_complex_float) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_float_view_array(gsl_matrix_complex_float_view $view, CArray[num32] $base, size_t $n1, size_t $n2 --> gsl_matrix_complex_float) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_float_view_array_with_tda(gsl_matrix_complex_float_view $view, CArray[num32] $base, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix_complex_float) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_float_view_vector(gsl_matrix_complex_float_view $view, gsl_vector_complex_float $v, size_t $n1, size_t $n2 --> gsl_matrix_complex_float) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_float_view_vector_with_tda(gsl_matrix_complex_float_view $view, gsl_vector_complex_float $v, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix_complex_float) is native(GSLHELPER) is export(:matrixview) { * }
# Creating row and column views
sub mgsl_matrix_complex_float_row(gsl_vector_complex_float_view $view, gsl_matrix_complex_float $m, size_t $i --> gsl_vector_complex_float) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_float_column(gsl_vector_complex_float_view $view, gsl_matrix_complex_float $m, size_t $j --> gsl_vector_complex_float) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_float_subrow(gsl_vector_complex_float_view $view, gsl_matrix_complex_float $m, size_t $i, size_t $offset, size_t $n --> gsl_vector_complex_float) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_float_subcolumn(gsl_vector_complex_float_view $view, gsl_matrix_complex_float $m, size_t $j, size_t $offset, size_t $n --> gsl_vector_complex_float) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_float_diagonal(gsl_vector_complex_float_view $view, gsl_matrix_complex_float $m --> gsl_vector_complex_float) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_float_subdiagonal(gsl_vector_complex_float_view $view, gsl_matrix_complex_float $m, size_t $k --> gsl_vector_complex_float) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_float_superdiagonal(gsl_vector_complex_float_view $view, gsl_matrix_complex_float $m, size_t $k --> gsl_vector_complex_float) is native(GSLHELPER) is export(:matrixview) { * }
# Copying matrices
sub gsl_matrix_complex_float_memcpy(gsl_matrix_complex_float $dest, gsl_matrix_complex_float $src --> int32) is native(LIB) is export(:matrixcopy) { * }
sub gsl_matrix_complex_float_swap(gsl_matrix_complex_float $m1, gsl_matrix_complex_float $m2 --> int32) is native(LIB) is export(:matrixcopy) { * }
# Copying rows and columns
sub gsl_matrix_complex_float_get_row(gsl_vector_complex_float $v, gsl_matrix_complex_float $m, size_t $i --> int32) is native(LIB) is export(:matrixcopy) { * }
sub gsl_matrix_complex_float_get_col(gsl_vector_complex_float $v, gsl_matrix_complex_float $m, size_t $j --> int32) is native(LIB) is export(:matrixcopy) { * }
sub gsl_matrix_complex_float_set_row(gsl_matrix_complex_float $m, size_t $i, gsl_vector_complex_float $v --> int32) is native(LIB) is export(:matrixcopy) { * }
sub gsl_matrix_complex_float_set_col(gsl_matrix_complex_float $m, size_t $j, gsl_vector_complex_float $v --> int32) is native(LIB) is export(:matrixcopy) { * }
# Exchanging rows and columns
sub gsl_matrix_complex_float_swap_rows(gsl_matrix_complex_float $m, size_t $i, size_t $j --> int32) is native(LIB) is export(:matrixexch) { * }
sub gsl_matrix_complex_float_swap_columns(gsl_matrix_complex_float $m, size_t $i, size_t $j --> int32) is native(LIB) is export(:matrixexch) { * }
sub gsl_matrix_complex_float_swap_rowcol(gsl_matrix_complex_float $m, size_t $i, size_t $j --> int32) is native(LIB) is export(:matrixexch) { * }
sub gsl_matrix_complex_float_transpose_memcpy(gsl_matrix_complex_float $dest, gsl_matrix_complex_float $src --> int32) is native(LIB) is export(:matrixexch) { * }
sub gsl_matrix_complex_float_transpose(gsl_matrix_complex_float $m --> int32) is native(LIB) is export(:matrixexch) { * }
# Matrix operations
sub gsl_matrix_complex_float_add(gsl_matrix_complex_float $a, gsl_matrix_complex_float $b --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_complex_float_sub(gsl_matrix_complex_float $a, gsl_matrix_complex_float $b --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_complex_float_mul_elements(gsl_matrix_complex_float $a, gsl_matrix_complex_float $b --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_complex_float_div_elements(gsl_matrix_complex_float $a, gsl_matrix_complex_float $b --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_complex_float_scale(gsl_matrix_complex_float $a, num64 $x --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_complex_float_add_constant(gsl_matrix_complex_float $a, num64 $x --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_complex_float_add_diagonal(gsl_matrix_complex_float $a, num64 $x --> int32) is native(LIB) is export(:matrixop) { * }
# Matrix properties
sub gsl_matrix_complex_float_isnull(gsl_matrix_complex_float $m --> int32) is native(LIB) is export(:matrixprop) { * }
sub gsl_matrix_complex_float_ispos(gsl_matrix_complex_float $m --> int32) is native(LIB) is export(:matrixprop) { * }
sub gsl_matrix_complex_float_isneg(gsl_matrix_complex_float $m --> int32) is native(LIB) is export(:matrixprop) { * }
sub gsl_matrix_complex_float_isnonneg(gsl_matrix_complex_float $m --> int32) is native(LIB) is export(:matrixprop) { * }
sub gsl_matrix_complex_float_equal(gsl_matrix_complex_float $a, gsl_matrix_complex_float $b --> int32) is native(LIB) is export(:matrixprop) { * }
