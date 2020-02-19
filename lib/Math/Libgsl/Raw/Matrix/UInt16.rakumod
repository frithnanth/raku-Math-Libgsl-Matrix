use v6;

unit module Math::Libgsl::Raw::Matrix::UInt16:ver<0.0.6>:auth<cpan:FRITH>;

use NativeCall;
use LibraryMake;

constant GSLHELPER = %?RESOURCES<libraries/gslhelper>.absolute;

constant LIB  = ('gsl', v23);

class gsl_block_ushort is repr('CStruct') is export {
  has size_t          $.size;
  has Pointer[uint16] $.data;
}

class gsl_vector_ushort is repr('CStruct') is export {
  has size_t           $.size;
  has size_t           $.stride;
  has Pointer[uint16]  $.data;
  has gsl_block_ushort $.block;
  has int32            $.owner;
}

class gsl_vector_ushort_view is repr('CStruct') is export {
  HAS gsl_vector_ushort      $.vector;
}

class gsl_matrix_ushort is repr('CStruct') is export {
  has size_t           $.size1;
  has size_t           $.size2;
  has size_t           $.tda;
  has Pointer[uint16]  $.data;
  has gsl_block_ushort $.block;
  has int32            $.owner;
}

class gsl_matrix_ushort_view is repr('CStruct') is export {
  HAS gsl_matrix_ushort      $.matrix;
}

# Block allocation
sub gsl_block_ushort_alloc(size_t $n --> gsl_block_ushort) is native(LIB) is export(:block) { * }
sub gsl_block_ushort_calloc(size_t $n --> gsl_block_ushort) is native(LIB) is export(:block) { * }
sub gsl_block_ushort_free(gsl_block_ushort $b) is native(LIB) is export(:block) { * }
# Reading and writing blocks
sub mgsl_block_ushort_fwrite(Str $filename, gsl_block_ushort $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_ushort_fread(Str $filename, gsl_block_ushort $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_ushort_fprintf(Str $filename, gsl_block_ushort $b, Str $format --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_ushort_fscanf(Str $filename, gsl_block_ushort $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
# Vector allocation
sub gsl_vector_ushort_alloc(size_t $n --> gsl_vector_ushort) is native(LIB) is export(:vector) { * }
sub gsl_vector_ushort_calloc(size_t $n --> gsl_vector_ushort) is native(LIB) is export(:vector) { * }
sub gsl_vector_ushort_free(gsl_vector_ushort $v) is native(LIB) is export(:vector) { * }
# Accessing vector elements
sub gsl_vector_ushort_get(gsl_vector_ushort $v, size_t $i --> int16) is native(LIB) is export(:vector) { * }
sub gsl_vector_ushort_set(gsl_vector_ushort $v, size_t $i, int16 $x) is native(LIB) is export(:vector) { * }
# Initializing vector elements
sub gsl_vector_ushort_set_all(gsl_vector_ushort $v, uint16 $x) is native(LIB) is export(:vectorio) { * }
sub gsl_vector_ushort_set_zero(gsl_vector_ushort $v) is native(LIB) is export(:vectorio) { * }
sub gsl_vector_ushort_set_basis(gsl_vector_ushort $v, size_t $i --> int32) is native(LIB) is export(:vectorio) { * }
# Reading and writing vectors
sub mgsl_vector_ushort_fwrite(Str $filename, gsl_vector_ushort $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_ushort_fread(Str $filename, gsl_vector_ushort $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_ushort_fprintf(Str $filename, gsl_vector_ushort $v, Str $format --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_ushort_fscanf(Str $filename, gsl_vector_ushort $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
# Vector views
sub alloc_gsl_vector_ushort_view(--> gsl_vector_ushort_view) is native(GSLHELPER) is export(:vectorview) { * }
sub free_gsl_vector_ushort_view(gsl_vector_ushort_view $vv) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_ushort_subvector(gsl_vector_ushort_view $view, gsl_vector_ushort $v, size_t $offset, size_t $n --> gsl_vector_ushort) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_ushort_subvector_with_stride(gsl_vector_ushort_view $view, gsl_vector_ushort $v, size_t $offset, size_t $stride, size_t $n --> gsl_vector_ushort) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_ushort_view_array(gsl_vector_ushort_view $view, CArray[uint16] $base, size_t $n --> gsl_vector_ushort) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_ushort_view_array_with_stride(gsl_vector_ushort_view $view, CArray[uint16] $base, size_t $stride, size_t $n --> gsl_vector_ushort) is native(GSLHELPER) is export(:vectorview) { * }
# Copying vectors
sub gsl_vector_ushort_memcpy(gsl_vector_ushort $dest, gsl_vector_ushort $src --> int32) is native(LIB) is export(:vectorcopy) { * }
sub gsl_vector_ushort_swap(gsl_vector_ushort $v, gsl_vector_ushort $w --> int32) is native(LIB) is export(:vectorcopy) { * }
# Exchanging elements
sub gsl_vector_ushort_swap_elements(gsl_vector_ushort $v, size_t $i, size_t $j --> int32) is native(LIB) is export(:vectorelem) { * }
sub gsl_vector_ushort_reverse(gsl_vector_ushort $v --> int32) is native(LIB) is export(:vectorelem) { * }
# Vector operations
sub gsl_vector_ushort_add(gsl_vector_ushort $a, gsl_vector_ushort $b --> int32) is native(LIB) is export(:vectorop) { * }
sub gsl_vector_ushort_sub(gsl_vector_ushort $a, gsl_vector_ushort $b --> int32) is native(LIB) is export(:vectorop) { * }
sub gsl_vector_ushort_mul(gsl_vector_ushort $a, gsl_vector_ushort $b --> int32) is native(LIB) is export(:vectorop) { * }
sub gsl_vector_ushort_div(gsl_vector_ushort $a, gsl_vector_ushort $b --> int32) is native(LIB) is export(:vectorop) { * }
sub gsl_vector_ushort_scale(gsl_vector_ushort $a, num64 $x --> int32) is native(LIB) is export(:vectorop) { * }
sub gsl_vector_ushort_add_constant(gsl_vector_ushort $a, num64 $x --> int32) is native(LIB) is export(:vectorop) { * }
# Finding maximum and minimum elements of vectors
sub gsl_vector_ushort_max(gsl_vector_ushort $v --> uint16) is native(LIB) is export(:vectorminmax) { * }
sub gsl_vector_ushort_min(gsl_vector_ushort $v --> uint16) is native(LIB) is export(:vectorminmax) { * }
sub gsl_vector_ushort_minmax(gsl_vector_ushort $v, uint16 $min_out is rw, uint16 $max_out is rw) is native(LIB) is export(:vectorminmax) { * }
sub gsl_vector_ushort_max_index(gsl_vector_ushort $v --> size_t) is native(LIB) is export(:vectorminmax) { * }
sub gsl_vector_ushort_min_index(gsl_vector_ushort $v --> size_t) is native(LIB) is export(:vectorminmax) { * }
sub gsl_vector_ushort_minmax_index(gsl_vector_ushort $v, size_t $imin is rw, size_t $imax is rw) is native(LIB) is export(:vectorminmax) { * }
# Vector properties
sub gsl_vector_ushort_isnull(gsl_vector_ushort $v --> int32) is native(LIB) is export(:vectorprop) { * }
sub gsl_vector_ushort_ispos(gsl_vector_ushort $v --> int32) is native(LIB) is export(:vectorprop) { * }
sub gsl_vector_ushort_isneg(gsl_vector_ushort $v --> int32) is native(LIB) is export(:vectorprop) { * }
sub gsl_vector_ushort_isnonneg(gsl_vector_ushort $v --> int32) is native(LIB) is export(:vectorprop) { * }
sub gsl_vector_ushort_equal(gsl_vector_ushort $u, gsl_vector_ushort $v --> int32) is native(LIB) is export(:vectorprop) { * }
# Matrix allocation
sub gsl_matrix_ushort_alloc(size_t $n1, size_t $n2 --> gsl_matrix_ushort) is native(LIB) is export(:matrix) { * }
sub gsl_matrix_ushort_calloc(size_t $n1, size_t $n2 --> gsl_matrix_ushort) is native(LIB) is export(:matrix) { * }
sub gsl_matrix_ushort_free(gsl_matrix_ushort $m) is native(LIB) is export(:matrix) { * }
# Accessing matrix elements
sub gsl_matrix_ushort_get(gsl_matrix_ushort $m, size_t $i, size_t $j --> uint16) is native(LIB) is export(:matrix) { * }
sub gsl_matrix_ushort_set(gsl_matrix_ushort $m, size_t $i, size_t $j, uint16 $x) is native(LIB) is export(:matrix) { * }
# Initializing matrix elements
sub gsl_matrix_ushort_set_all(gsl_matrix_ushort $m, uint16 $x) is native(LIB) is export(:matrixio) { * }
sub gsl_matrix_ushort_set_zero(gsl_matrix_ushort $m) is native(LIB) is export(:matrixio) { * }
sub gsl_matrix_ushort_set_identity(gsl_matrix_ushort $m) is native(LIB) is export(:matrixio) { * }
# Reading and writing matrices
sub mgsl_matrix_ushort_fwrite(Str $filename, gsl_matrix_ushort $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_ushort_fread(Str $filename, gsl_matrix_ushort $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_ushort_fprintf(Str $filename, gsl_matrix_ushort $m, Str $format --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_ushort_fscanf(Str $filename, gsl_matrix_ushort $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
# Matrix views
sub alloc_gsl_matrix_ushort_view(--> gsl_matrix_ushort_view) is native(GSLHELPER) is export(:matrixview) { * }
sub free_gsl_matrix_ushort_view(gsl_matrix_ushort_view $mv) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ushort_submatrix(gsl_matrix_ushort_view $view, gsl_matrix_ushort $m, size_t $k1, size_t $k2, size_t $n1, size_t $n2 --> gsl_matrix_ushort) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ushort_view_array(gsl_matrix_ushort_view $view, CArray[uint16] $base, size_t $n1, size_t $n2 --> gsl_matrix_ushort) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ushort_view_array_with_tda(gsl_matrix_ushort_view $view, CArray[uint16] $base, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix_ushort) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ushort_view_vector(gsl_matrix_ushort_view $view, gsl_vector_ushort $v, size_t $n1, size_t $n2 --> gsl_matrix_ushort) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ushort_view_vector_with_tda(gsl_matrix_ushort_view $view, gsl_vector_ushort $v, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix_ushort) is native(GSLHELPER) is export(:matrixview) { * }
# Creating row and column views
sub mgsl_matrix_ushort_row(gsl_vector_ushort_view $view, gsl_matrix_ushort $m, size_t $i --> gsl_vector_ushort) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ushort_column(gsl_vector_ushort_view $view, gsl_matrix_ushort $m, size_t $j --> gsl_vector_ushort) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ushort_subrow(gsl_vector_ushort_view $view, gsl_matrix_ushort $m, size_t $i, size_t $offset, size_t $n --> gsl_vector_ushort) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ushort_subcolumn(gsl_vector_ushort_view $view, gsl_matrix_ushort $m, size_t $j, size_t $offset, size_t $n --> gsl_vector_ushort) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ushort_diagonal(gsl_vector_ushort_view $view, gsl_matrix_ushort $m --> gsl_vector_ushort) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ushort_subdiagonal(gsl_vector_ushort_view $view, gsl_matrix_ushort $m, size_t $k --> gsl_vector_ushort) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_ushort_superdiagonal(gsl_vector_ushort_view $view, gsl_matrix_ushort $m, size_t $k --> gsl_vector_ushort) is native(GSLHELPER) is export(:matrixview) { * }
# Copying matrices
sub gsl_matrix_ushort_memcpy(gsl_matrix_ushort $dest, gsl_matrix_ushort $src --> int32) is native(LIB) is export(:matrixcopy) { * }
sub gsl_matrix_ushort_swap(gsl_matrix_ushort $m1, gsl_matrix_ushort $m2 --> int32) is native(LIB) is export(:matrixcopy) { * }
# Copying rows and columns
sub gsl_matrix_ushort_get_row(gsl_vector_ushort $v, gsl_matrix_ushort $m, size_t $i --> int32) is native(LIB) is export(:matrixcopy) { * }
sub gsl_matrix_ushort_get_col(gsl_vector_ushort $v, gsl_matrix_ushort $m, size_t $j --> int32) is native(LIB) is export(:matrixcopy) { * }
sub gsl_matrix_ushort_set_row(gsl_matrix_ushort $m, size_t $i, gsl_vector_ushort $v --> int32) is native(LIB) is export(:matrixcopy) { * }
sub gsl_matrix_ushort_set_col(gsl_matrix_ushort $m, size_t $j, gsl_vector_ushort $v --> int32) is native(LIB) is export(:matrixcopy) { * }
# Exchanging rows and columns
sub gsl_matrix_ushort_swap_rows(gsl_matrix_ushort $m, size_t $i, size_t $j --> int32) is native(LIB) is export(:matrixexch) { * }
sub gsl_matrix_ushort_swap_columns(gsl_matrix_ushort $m, size_t $i, size_t $j --> int32) is native(LIB) is export(:matrixexch) { * }
sub gsl_matrix_ushort_swap_rowcol(gsl_matrix_ushort $m, size_t $i, size_t $j --> int32) is native(LIB) is export(:matrixexch) { * }
sub gsl_matrix_ushort_transpose_memcpy(gsl_matrix_ushort $dest, gsl_matrix_ushort $src --> int32) is native(LIB) is export(:matrixexch) { * }
sub gsl_matrix_ushort_transpose(gsl_matrix_ushort $m --> int32) is native(LIB) is export(:matrixexch) { * }
# Matrix operations
sub gsl_matrix_ushort_add(gsl_matrix_ushort $a, gsl_matrix_ushort $b --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_ushort_sub(gsl_matrix_ushort $a, gsl_matrix_ushort $b --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_ushort_mul_elements(gsl_matrix_ushort $a, gsl_matrix_ushort $b --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_ushort_div_elements(gsl_matrix_ushort $a, gsl_matrix_ushort $b --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_ushort_scale(gsl_matrix_ushort $a, num64 $x --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_ushort_add_constant(gsl_matrix_ushort $a, num64 $x --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_ushort_add_diagonal(gsl_matrix_ushort $a, num64 $x --> int32) is native(LIB) is export(:matrixop) { * }
# Finding maximum and minimum elements of matrices
sub gsl_matrix_ushort_max(gsl_matrix_ushort $m --> uint16) is native(LIB) is export(:matrixminmax) { * }
sub gsl_matrix_ushort_min(gsl_matrix_ushort $m --> uint16) is native(LIB) is export(:matrixminmax) { * }
sub gsl_matrix_ushort_minmax(gsl_matrix_ushort $m, uint16 $min_out is rw, uint16 $max_out is rw) is native(LIB) is export(:matrixminmax) { * }
sub gsl_matrix_ushort_max_index(gsl_matrix_ushort $m, size_t $imax is rw, size_t $jmax is rw) is native(LIB) is export(:matrixminmax) { * }
sub gsl_matrix_ushort_min_index(gsl_matrix_ushort $m, size_t $imin is rw, size_t $jmin is rw) is native(LIB) is export(:matrixminmax) { * }
sub gsl_matrix_ushort_minmax_index(gsl_matrix_ushort $m, size_t $imin is rw, size_t $jmin is rw, size_t $imax is rw, size_t $jmax is rw) is native(LIB) is export(:matrixminmax) { * }
# Matrix properties
sub gsl_matrix_ushort_isnull(gsl_matrix_ushort $m --> int32) is native(LIB) is export(:matrixprop) { * }
sub gsl_matrix_ushort_ispos(gsl_matrix_ushort $m --> int32) is native(LIB) is export(:matrixprop) { * }
sub gsl_matrix_ushort_isneg(gsl_matrix_ushort $m --> int32) is native(LIB) is export(:matrixprop) { * }
sub gsl_matrix_ushort_isnonneg(gsl_matrix_ushort $m --> int32) is native(LIB) is export(:matrixprop) { * }
sub gsl_matrix_ushort_equal(gsl_matrix_ushort $a, gsl_matrix_ushort $b --> int32) is native(LIB) is export(:matrixprop) { * }
