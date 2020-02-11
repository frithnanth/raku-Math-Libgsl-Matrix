use v6;

unit module Math::Libgsl::Raw::Matrix::UInt64:ver<0.0.3>:auth<cpan:FRITH>;

use Math::Libgsl::Raw::Complex :ALL;
use NativeCall;
use LibraryMake;

constant GSLHELPER = %?RESOURCES<libraries/gslhelper>.absolute;

constant LIB  = ('gsl', v23);

class gsl_block_ulong is repr('CStruct') is export {
  has size_t          $.size;
  has Pointer[uint64] $.data;
}

class gsl_vector_ulong is repr('CStruct') is export {
  has size_t          $.size;
  has size_t          $.stride;
  has Pointer[uint64] $.data;
  has gsl_block_ulong $.block;
  has int32           $.owner;
}

class gsl_vector_ulong_view is repr('CStruct') is export {
  HAS gsl_vector_ulong      $.vector;
}

class gsl_matrix_ulong is repr('CStruct') is export {
  has size_t          $.size1;
  has size_t          $.size2;
  has size_t          $.tda;
  has Pointer[uint64] $.data;
  has gsl_block_ulong $.block;
  has int32           $.owner;
}

class gsl_matrix_ulong_view is repr('CStruct') is export {
  HAS gsl_matrix_ulong      $.matrix;
}

# Block allocation
sub gsl_block_ulong_alloc(size_t $n --> gsl_block_ulong) is native(LIB) is export(:block) { * }
sub gsl_block_ulong_calloc(size_t $n --> gsl_block_ulong) is native(LIB) is export(:block) { * }
sub gsl_block_ulong_free(gsl_block_ulong $b) is native(LIB) is export(:block) { * }
# Reading and writing blocks
sub mgsl_block_ulong_fwrite(Str $filename, gsl_block_ulong $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_ulong_fread(Str $filename, gsl_block_ulong $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_ulong_fprintf(Str $filename, gsl_block_ulong $b, Str $format --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_ulong_fscanf(Str $filename, gsl_block_ulong $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
# Vector allocation
sub gsl_vector_ulong_alloc(size_t $n --> gsl_vector_ulong) is native(LIB) is export(:vector) { * }
sub gsl_vector_ulong_calloc(size_t $n --> gsl_vector_ulong) is native(LIB) is export(:vector) { * }
sub gsl_vector_ulong_free(gsl_vector_ulong $v) is native(LIB) is export(:vector) { * }
# Accessing vector elements
sub gsl_vector_ulong_get(gsl_vector_ulong $v, size_t $i --> int64) is native(LIB) is export(:vector) { * }
sub gsl_vector_ulong_set(gsl_vector_ulong $v, size_t $i, int64 $x) is native(LIB) is export(:vector) { * }
# Initializing vector elements
sub gsl_vector_ulong_set_all(gsl_vector_ulong $v, uint64 $x) is native(LIB) is export(:vectorio) { * }
sub gsl_vector_ulong_set_zero(gsl_vector_ulong $v) is native(LIB) is export(:vectorio) { * }
sub gsl_vector_ulong_set_basis(gsl_vector_ulong $v, size_t $i --> int32) is native(LIB) is export(:vectorio) { * }
# Reading and writing vectors
sub mgsl_vector_ulong_fwrite(Str $filename, gsl_vector_ulong $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_ulong_fread(Str $filename, gsl_vector_ulong $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_ulong_fprintf(Str $filename, gsl_vector_ulong $v, Str $format --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_ulong_fscanf(Str $filename, gsl_vector_ulong $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
# Vector views
sub alloc_gsl_vector_ulong_view(--> gsl_vector_ulong_view) is native(GSLHELPER) is export(:vectorview) { * }
sub free_gsl_vector_ulong_view(gsl_vector_ulong_view $vv) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_ulong_subvector(gsl_vector_ulong_view $view, gsl_vector_ulong $v, size_t $offset, size_t $n --> gsl_vector_ulong) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_ulong_subvector_with_stride(gsl_vector_ulong_view $view, gsl_vector_ulong $v, size_t $offset, size_t $stride, size_t $n --> gsl_vector_ulong) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_ulong_view_array(gsl_vector_ulong_view $view, CArray[uint64] $base, size_t $n --> gsl_vector_ulong) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_ulong_view_array_with_stride(gsl_vector_ulong_view $view, CArray[uint64] $base, size_t $stride, size_t $n --> gsl_vector_ulong) is native(GSLHELPER) is export(:vectorview) { * }
# Copying vectors
sub gsl_vector_ulong_memcpy(gsl_vector_ulong $dest, gsl_vector_ulong $src --> int32) is native(LIB) is export(:vectorcopy) { * }
sub gsl_vector_ulong_swap(gsl_vector_ulong $v, gsl_vector_ulong $w --> int32) is native(LIB) is export(:vectorcopy) { * }
# Exchanging elements
sub gsl_vector_ulong_swap_elements(gsl_vector_ulong $v, size_t $i, size_t $j --> int32) is native(LIB) is export(:vectorelem) { * }
sub gsl_vector_ulong_reverse(gsl_vector_ulong $v --> int32) is native(LIB) is export(:vectorelem) { * }
# Vector operations
sub gsl_vector_ulong_add(gsl_vector_ulong $a, gsl_vector_ulong $b --> int32) is native(LIB) is export(:vectorop) { * }
sub gsl_vector_ulong_sub(gsl_vector_ulong $a, gsl_vector_ulong $b --> int32) is native(LIB) is export(:vectorop) { * }
sub gsl_vector_ulong_mul(gsl_vector_ulong $a, gsl_vector_ulong $b --> int32) is native(LIB) is export(:vectorop) { * }
sub gsl_vector_ulong_div(gsl_vector_ulong $a, gsl_vector_ulong $b --> int32) is native(LIB) is export(:vectorop) { * }
sub gsl_vector_ulong_scale(gsl_vector_ulong $a, num64 $x --> int32) is native(LIB) is export(:vectorop) { * }
sub gsl_vector_ulong_add_constant(gsl_vector_ulong $a, num64 $x --> int32) is native(LIB) is export(:vectorop) { * }
# Finding maximum and minimum elements of vectors
sub gsl_vector_ulong_max(gsl_vector_ulong $v --> uint64) is native(LIB) is export(:vectorminmax) { * }
sub gsl_vector_ulong_min(gsl_vector_ulong $v --> uint64) is native(LIB) is export(:vectorminmax) { * }
sub gsl_vector_ulong_minmax(gsl_vector_ulong $v, uint64 $min_out is rw, uint64 $max_out is rw) is native(LIB) is export(:vectorminmax) { * }
sub gsl_vector_ulong_max_index(gsl_vector_ulong $v --> size_t) is native(LIB) is export(:vectorminmax) { * }
sub gsl_vector_ulong_min_index(gsl_vector_ulong $v --> size_t) is native(LIB) is export(:vectorminmax) { * }
sub gsl_vector_ulong_minmax_index(gsl_vector_ulong $v, size_t $imin is rw, size_t $imax is rw) is native(LIB) is export(:vectorminmax) { * }
# Vector properties
sub gsl_vector_ulong_isnull(gsl_vector_ulong $v --> int32) is native(LIB) is export(:vectorprop) { * }
sub gsl_vector_ulong_ispos(gsl_vector_ulong $v --> int32) is native(LIB) is export(:vectorprop) { * }
sub gsl_vector_ulong_isneg(gsl_vector_ulong $v --> int32) is native(LIB) is export(:vectorprop) { * }
sub gsl_vector_ulong_isnonneg(gsl_vector_ulong $v --> int32) is native(LIB) is export(:vectorprop) { * }
sub gsl_vector_ulong_equal(gsl_vector_ulong $u, gsl_vector_ulong $v --> int32) is native(LIB) is export(:vectorprop) { * }
# Matrix allocation
sub gsl_matrix_ulong_alloc(size_t $n1, size_t $n2 --> gsl_matrix_ulong) is native(LIB) is export(:matrix) { * }
sub gsl_matrix_ulong_calloc(size_t $n1, size_t $n2 --> gsl_matrix_ulong) is native(LIB) is export(:matrix) { * }
sub gsl_matrix_ulong_free(gsl_matrix_ulong $m) is native(LIB) is export(:matrix) { * }
# Accessing matrix elements
sub gsl_matrix_ulong_get(gsl_matrix_ulong $m, size_t $i, size_t $j --> uint64) is native(LIB) is export(:matrix) { * }
sub gsl_matrix_ulong_set(gsl_matrix_ulong $m, size_t $i, size_t $j, uint64 $x) is native(LIB) is export(:matrix) { * }
# Initializing matrix elements
sub gsl_matrix_ulong_set_all(gsl_matrix_ulong $m, uint64 $x) is native(LIB) is export(:matrixio) { * }
sub gsl_matrix_ulong_set_zero(gsl_matrix_ulong $m) is native(LIB) is export(:matrixio) { * }
sub gsl_matrix_ulong_set_identity(gsl_matrix_ulong $m) is native(LIB) is export(:matrixio) { * }
# Reading and writing matrices
sub mgsl_matrix_ulong_fwrite(Str $filename, gsl_matrix_ulong $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_ulong_fread(Str $filename, gsl_matrix_ulong $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_ulong_fprintf(Str $filename, gsl_matrix_ulong $m, Str $format --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_ulong_fscanf(Str $filename, gsl_matrix_ulong $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
# Matrix views
sub alloc_gsl_matrix_ulong_view(--> gsl_matrix_ulong_view) is native(GSLHELPER) is export(:matrixview) { * }
sub free_gsl_matrix_ulong_view(gsl_matrix_ulong_view $mv) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ulong_submatrix(gsl_matrix_ulong_view $view, gsl_matrix_ulong $m, size_t $k1, size_t $k2, size_t $n1, size_t $n2 --> gsl_matrix_ulong) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ulong_view_array(gsl_matrix_ulong_view $view, CArray[uint64] $base, size_t $n1, size_t $n2 --> gsl_matrix_ulong) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ulong_view_array_with_tda(gsl_matrix_ulong_view $view, CArray[uint64] $base, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix_ulong) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ulong_view_vector(gsl_matrix_ulong_view $view, gsl_vector_ulong $v, size_t $n1, size_t $n2 --> gsl_matrix_ulong) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ulong_view_vector_with_tda(gsl_matrix_ulong_view $view, gsl_vector_ulong $v, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix_ulong) is native(GSLHELPER) is export(:matrixview) { * }
# Creating row and column views
sub mgsl_matrix_ulong_row(gsl_vector_ulong_view $view, gsl_matrix_ulong $m, size_t $i --> gsl_vector_ulong) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ulong_column(gsl_vector_ulong_view $view, gsl_matrix_ulong $m, size_t $j --> gsl_vector_ulong) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ulong_subrow(gsl_vector_ulong_view $view, gsl_matrix_ulong $m, size_t $i, size_t $offset, size_t $n --> gsl_vector_ulong) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ulong_subcolumn(gsl_vector_ulong_view $view, gsl_matrix_ulong $m, size_t $j, size_t $offset, size_t $n --> gsl_vector_ulong) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ulong_diagonal(gsl_vector_ulong_view $view, gsl_matrix_ulong $m --> gsl_vector_ulong) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ulong_subdiagonal(gsl_vector_ulong_view $view, gsl_matrix_ulong $m, size_t $k --> gsl_vector_ulong) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ulong_superdiagonal(gsl_vector_ulong_view $view, gsl_matrix_ulong $m, size_t $k --> gsl_vector_ulong) is native(GSLHELPER) is export(:matrixview) { * }
# Copying matrices
sub gsl_matrix_ulong_memcpy(gsl_matrix_ulong $dest, gsl_matrix_ulong $src --> int32) is native(LIB) is export(:matrixcopy) { * }
sub gsl_matrix_ulong_swap(gsl_matrix_ulong $m1, gsl_matrix_ulong $m2 --> int32) is native(LIB) is export(:matrixcopy) { * }
# Copying rows and columns
sub gsl_matrix_ulong_get_row(gsl_vector_ulong $v, gsl_matrix_ulong $m, size_t $i --> int32) is native(LIB) is export(:matrixcopy) { * }
sub gsl_matrix_ulong_get_col(gsl_vector_ulong $v, gsl_matrix_ulong $m, size_t $j --> int32) is native(LIB) is export(:matrixcopy) { * }
sub gsl_matrix_ulong_set_row(gsl_matrix_ulong $m, size_t $i, gsl_vector_ulong $v --> int32) is native(LIB) is export(:matrixcopy) { * }
sub gsl_matrix_ulong_set_col(gsl_matrix_ulong $m, size_t $j, gsl_vector_ulong $v --> int32) is native(LIB) is export(:matrixcopy) { * }
# Exchanging rows and columns
sub gsl_matrix_ulong_swap_rows(gsl_matrix_ulong $m, size_t $i, size_t $j --> int32) is native(LIB) is export(:matrixexch) { * }
sub gsl_matrix_ulong_swap_columns(gsl_matrix_ulong $m, size_t $i, size_t $j --> int32) is native(LIB) is export(:matrixexch) { * }
sub gsl_matrix_ulong_swap_rowcol(gsl_matrix_ulong $m, size_t $i, size_t $j --> int32) is native(LIB) is export(:matrixexch) { * }
sub gsl_matrix_ulong_transpose_memcpy(gsl_matrix_ulong $dest, gsl_matrix_ulong $src --> int32) is native(LIB) is export(:matrixexch) { * }
sub gsl_matrix_ulong_transpose(gsl_matrix_ulong $m --> int32) is native(LIB) is export(:matrixexch) { * }
# Matrix operations
sub gsl_matrix_ulong_add(gsl_matrix_ulong $a, gsl_matrix_ulong $b --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_ulong_sub(gsl_matrix_ulong $a, gsl_matrix_ulong $b --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_ulong_mul_elements(gsl_matrix_ulong $a, gsl_matrix_ulong $b --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_ulong_div_elements(gsl_matrix_ulong $a, gsl_matrix_ulong $b --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_ulong_scale(gsl_matrix_ulong $a, num64 $x --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_ulong_add_constant(gsl_matrix_ulong $a, num64 $x --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_ulong_add_diagonal(gsl_matrix_ulong $a, num64 $x --> int32) is native(LIB) is export(:matrixop) { * }
# Finding maximum and minimum elements of matrices
sub gsl_matrix_ulong_max(gsl_matrix_ulong $m --> uint64) is native(LIB) is export(:matrixminmax) { * }
sub gsl_matrix_ulong_min(gsl_matrix_ulong $m --> uint64) is native(LIB) is export(:matrixminmax) { * }
sub gsl_matrix_ulong_minmax(gsl_matrix_ulong $m, uint64 $min_out is rw, uint64 $max_out is rw) is native(LIB) is export(:matrixminmax) { * }
sub gsl_matrix_ulong_max_index(gsl_matrix_ulong $m, size_t $imax is rw, size_t $jmax is rw) is native(LIB) is export(:matrixminmax) { * }
sub gsl_matrix_ulong_min_index(gsl_matrix_ulong $m, size_t $imin is rw, size_t $jmin is rw) is native(LIB) is export(:matrixminmax) { * }
sub gsl_matrix_ulong_minmax_index(gsl_matrix_ulong $m, size_t $imin is rw, size_t $jmin is rw, size_t $imax is rw, size_t $jmax is rw) is native(LIB) is export(:matrixminmax) { * }
# Matrix properties
sub gsl_matrix_ulong_isnull(gsl_matrix_ulong $m --> int32) is native(LIB) is export(:matrixprop) { * }
sub gsl_matrix_ulong_ispos(gsl_matrix_ulong $m --> int32) is native(LIB) is export(:matrixprop) { * }
sub gsl_matrix_ulong_isneg(gsl_matrix_ulong $m --> int32) is native(LIB) is export(:matrixprop) { * }
sub gsl_matrix_ulong_isnonneg(gsl_matrix_ulong $m --> int32) is native(LIB) is export(:matrixprop) { * }
sub gsl_matrix_ulong_equal(gsl_matrix_ulong $a, gsl_matrix_ulong $b --> int32) is native(LIB) is export(:matrixprop) { * }
