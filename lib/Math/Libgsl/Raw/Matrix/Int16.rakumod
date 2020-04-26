use v6;

unit module Math::Libgsl::Raw::Matrix::Int16:ver<0.1.4>:auth<cpan:FRITH>;

use NativeCall;

constant GSLHELPER = %?RESOURCES<libraries/gslhelper>.absolute;

constant LIB  = ('gsl', v23);

class gsl_block_short is repr('CStruct') is export {
  has size_t          $.size;
  has Pointer[int16]  $.data;
}

class gsl_vector_short is repr('CStruct') is export {
  has size_t          $.size;
  has size_t          $.stride;
  has Pointer[int16]  $.data;
  has gsl_block_short $.block;
  has int32           $.owner;
}

class gsl_vector_short_view is repr('CStruct') is export {
  HAS gsl_vector_short      $.vector;
}

class gsl_matrix_short is repr('CStruct') is export {
  has size_t          $.size1;
  has size_t          $.size2;
  has size_t          $.tda;
  has Pointer[int16]  $.data;
  has gsl_block_short $.block;
  has int32           $.owner;
}

class gsl_matrix_short_view is repr('CStruct') is export {
  HAS gsl_matrix_short      $.matrix;
}

# Block allocation
sub gsl_block_short_alloc(size_t $n --> gsl_block_short) is native(LIB) is export(:block) { * }
sub gsl_block_short_calloc(size_t $n --> gsl_block_short) is native(LIB) is export(:block) { * }
sub gsl_block_short_free(gsl_block_short $b) is native(LIB) is export(:block) { * }
# Reading and writing blocks
sub mgsl_block_short_fwrite(Str $filename, gsl_block_short $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_short_fread(Str $filename, gsl_block_short $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_short_fprintf(Str $filename, gsl_block_short $b, Str $format --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_short_fscanf(Str $filename, gsl_block_short $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
# Vector allocation
sub gsl_vector_short_alloc(size_t $n --> gsl_vector_short) is native(LIB) is export(:vector) { * }
sub gsl_vector_short_calloc(size_t $n --> gsl_vector_short) is native(LIB) is export(:vector) { * }
sub gsl_vector_short_free(gsl_vector_short $v) is native(LIB) is export(:vector) { * }
# Accessing vector elements
sub gsl_vector_short_get(gsl_vector_short $v, size_t $i --> int16) is native(LIB) is export(:vector) { * }
sub gsl_vector_short_set(gsl_vector_short $v, size_t $i, int16 $x) is native(LIB) is export(:vector) { * }
# Initializing vector elements
sub gsl_vector_short_set_all(gsl_vector_short $v, int16 $x) is native(LIB) is export(:vectorio) { * }
sub gsl_vector_short_set_zero(gsl_vector_short $v) is native(LIB) is export(:vectorio) { * }
sub gsl_vector_short_set_basis(gsl_vector_short $v, size_t $i --> int32) is native(LIB) is export(:vectorio) { * }
# Reading and writing vectors
sub mgsl_vector_short_fwrite(Str $filename, gsl_vector_short $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_short_fread(Str $filename, gsl_vector_short $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_short_fprintf(Str $filename, gsl_vector_short $v, Str $format --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_short_fscanf(Str $filename, gsl_vector_short $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
# Vector views
sub alloc_gsl_vector_short_view(--> gsl_vector_short_view) is native(GSLHELPER) is export(:vectorview) { * }
sub free_gsl_vector_short_view(gsl_vector_short_view $vv) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_short_subvector(gsl_vector_short_view $view, gsl_vector_short $v, size_t $offset, size_t $n --> gsl_vector_short) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_short_subvector_with_stride(gsl_vector_short_view $view, gsl_vector_short $v, size_t $offset, size_t $stride, size_t $n --> gsl_vector_short) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_short_view_array(gsl_vector_short_view $view, CArray[int16] $base, size_t $n --> gsl_vector_short) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_short_view_array_with_stride(gsl_vector_short_view $view, CArray[int16] $base, size_t $stride, size_t $n --> gsl_vector_short) is native(GSLHELPER) is export(:vectorview) { * }
# Copying vectors
sub gsl_vector_short_memcpy(gsl_vector_short $dest, gsl_vector_short $src --> int32) is native(LIB) is export(:vectorcopy) { * }
sub gsl_vector_short_swap(gsl_vector_short $v, gsl_vector_short $w --> int32) is native(LIB) is export(:vectorcopy) { * }
# Exchanging elements
sub gsl_vector_short_swap_elements(gsl_vector_short $v, size_t $i, size_t $j --> int32) is native(LIB) is export(:vectorelem) { * }
sub gsl_vector_short_reverse(gsl_vector_short $v --> int32) is native(LIB) is export(:vectorelem) { * }
# Vector operations
sub gsl_vector_short_add(gsl_vector_short $a, gsl_vector_short $b --> int32) is native(LIB) is export(:vectorop) { * }
sub gsl_vector_short_sub(gsl_vector_short $a, gsl_vector_short $b --> int32) is native(LIB) is export(:vectorop) { * }
sub gsl_vector_short_mul(gsl_vector_short $a, gsl_vector_short $b --> int32) is native(LIB) is export(:vectorop) { * }
sub gsl_vector_short_div(gsl_vector_short $a, gsl_vector_short $b --> int32) is native(LIB) is export(:vectorop) { * }
sub gsl_vector_short_scale(gsl_vector_short $a, num64 $x --> int32) is native(LIB) is export(:vectorop) { * }
sub gsl_vector_short_add_constant(gsl_vector_short $a, num64 $x --> int32) is native(LIB) is export(:vectorop) { * }
# Finding maximum and minimum elements of vectors
sub gsl_vector_short_max(gsl_vector_short $v --> int16) is native(LIB) is export(:vectorminmax) { * }
sub gsl_vector_short_min(gsl_vector_short $v --> int16) is native(LIB) is export(:vectorminmax) { * }
sub gsl_vector_short_minmax(gsl_vector_short $v, int16 $min_out is rw, int16 $max_out is rw) is native(LIB) is export(:vectorminmax) { * }
sub gsl_vector_short_max_index(gsl_vector_short $v --> size_t) is native(LIB) is export(:vectorminmax) { * }
sub gsl_vector_short_min_index(gsl_vector_short $v --> size_t) is native(LIB) is export(:vectorminmax) { * }
sub gsl_vector_short_minmax_index(gsl_vector_short $v, size_t $imin is rw, size_t $imax is rw) is native(LIB) is export(:vectorminmax) { * }
# Vector properties
sub gsl_vector_short_isnull(gsl_vector_short $v --> int32) is native(LIB) is export(:vectorprop) { * }
sub gsl_vector_short_ispos(gsl_vector_short $v --> int32) is native(LIB) is export(:vectorprop) { * }
sub gsl_vector_short_isneg(gsl_vector_short $v --> int32) is native(LIB) is export(:vectorprop) { * }
sub gsl_vector_short_isnonneg(gsl_vector_short $v --> int32) is native(LIB) is export(:vectorprop) { * }
sub gsl_vector_short_equal(gsl_vector_short $u, gsl_vector_short $v --> int32) is native(LIB) is export(:vectorprop) { * }
# Matrix allocation
sub gsl_matrix_short_alloc(size_t $n1, size_t $n2 --> gsl_matrix_short) is native(LIB) is export(:matrix) { * }
sub gsl_matrix_short_calloc(size_t $n1, size_t $n2 --> gsl_matrix_short) is native(LIB) is export(:matrix) { * }
sub gsl_matrix_short_free(gsl_matrix_short $m) is native(LIB) is export(:matrix) { * }
# Accessing matrix elements
sub gsl_matrix_short_get(gsl_matrix_short $m, size_t $i, size_t $j --> int16) is native(LIB) is export(:matrix) { * }
sub gsl_matrix_short_set(gsl_matrix_short $m, size_t $i, size_t $j, int16 $x) is native(LIB) is export(:matrix) { * }
# Initializing matrix elements
sub gsl_matrix_short_set_all(gsl_matrix_short $m, int16 $x) is native(LIB) is export(:matrixio) { * }
sub gsl_matrix_short_set_zero(gsl_matrix_short $m) is native(LIB) is export(:matrixio) { * }
sub gsl_matrix_short_set_identity(gsl_matrix_short $m) is native(LIB) is export(:matrixio) { * }
# Reading and writing matrices
sub mgsl_matrix_short_fwrite(Str $filename, gsl_matrix_short $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_short_fread(Str $filename, gsl_matrix_short $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_short_fprintf(Str $filename, gsl_matrix_short $m, Str $format --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_short_fscanf(Str $filename, gsl_matrix_short $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
# Matrix views
sub alloc_gsl_matrix_short_view(--> gsl_matrix_short_view) is native(GSLHELPER) is export(:matrixview) { * }
sub free_gsl_matrix_short_view(gsl_matrix_short_view $mv) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_short_submatrix(gsl_matrix_short_view $view, gsl_matrix_short $m, size_t $k1, size_t $k2, size_t $n1, size_t $n2 --> gsl_matrix_short) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_short_view_array(gsl_matrix_short_view $view, CArray[int16] $base, size_t $n1, size_t $n2 --> gsl_matrix_short) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_short_view_array_with_tda(gsl_matrix_short_view $view, CArray[int16] $base, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix_short) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_short_view_vector(gsl_matrix_short_view $view, gsl_vector_short $v, size_t $n1, size_t $n2 --> gsl_matrix_short) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_short_view_vector_with_tda(gsl_matrix_short_view $view, gsl_vector_short $v, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix_short) is native(GSLHELPER) is export(:matrixview) { * }
# Creating row and column views
sub mgsl_matrix_short_row(gsl_vector_short_view $view, gsl_matrix_short $m, size_t $i --> gsl_vector_short) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_short_column(gsl_vector_short_view $view, gsl_matrix_short $m, size_t $j --> gsl_vector_short) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_short_subrow(gsl_vector_short_view $view, gsl_matrix_short $m, size_t $i, size_t $offset, size_t $n --> gsl_vector_short) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_short_subcolumn(gsl_vector_short_view $view, gsl_matrix_short $m, size_t $j, size_t $offset, size_t $n --> gsl_vector_short) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_short_diagonal(gsl_vector_short_view $view, gsl_matrix_short $m --> gsl_vector_short) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_short_subdiagonal(gsl_vector_short_view $view, gsl_matrix_short $m, size_t $k --> gsl_vector_short) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_short_superdiagonal(gsl_vector_short_view $view, gsl_matrix_short $m, size_t $k --> gsl_vector_short) is native(GSLHELPER) is export(:matrixview) { * }
# Copying matrices
sub gsl_matrix_short_memcpy(gsl_matrix_short $dest, gsl_matrix_short $src --> int32) is native(LIB) is export(:matrixcopy) { * }
sub gsl_matrix_short_swap(gsl_matrix_short $m1, gsl_matrix_short $m2 --> int32) is native(LIB) is export(:matrixcopy) { * }
sub gsl_matrix_short_tricpy(int32 $uplo_src, int32 $copy_diag, gsl_matrix_short $dest, gsl_matrix_short $src --> int32) is native(LIB) is export(:matrixcopy) { * }
# Copying rows and columns
sub gsl_matrix_short_get_row(gsl_vector_short $v, gsl_matrix_short $m, size_t $i --> int32) is native(LIB) is export(:matrixcopy) { * }
sub gsl_matrix_short_get_col(gsl_vector_short $v, gsl_matrix_short $m, size_t $j --> int32) is native(LIB) is export(:matrixcopy) { * }
sub gsl_matrix_short_set_row(gsl_matrix_short $m, size_t $i, gsl_vector_short $v --> int32) is native(LIB) is export(:matrixcopy) { * }
sub gsl_matrix_short_set_col(gsl_matrix_short $m, size_t $j, gsl_vector_short $v --> int32) is native(LIB) is export(:matrixcopy) { * }
# Exchanging rows and columns
sub gsl_matrix_short_swap_rows(gsl_matrix_short $m, size_t $i, size_t $j --> int32) is native(LIB) is export(:matrixexch) { * }
sub gsl_matrix_short_swap_columns(gsl_matrix_short $m, size_t $i, size_t $j --> int32) is native(LIB) is export(:matrixexch) { * }
sub gsl_matrix_short_swap_rowcol(gsl_matrix_short $m, size_t $i, size_t $j --> int32) is native(LIB) is export(:matrixexch) { * }
sub gsl_matrix_short_transpose_memcpy(gsl_matrix_short $dest, gsl_matrix_short $src --> int32) is native(LIB) is export(:matrixexch) { * }
sub gsl_matrix_short_transpose(gsl_matrix_short $m --> int32) is native(LIB) is export(:matrixexch) { * }
sub gsl_matrix_short_transpose_tricpy(int32 $uplo_src, int32 $copy_diag, gsl_matrix_short $dest, gsl_matrix_short $src --> int32) is native(LIB) is export(:matrixexch) { * }
# Matrix operations
sub gsl_matrix_short_add(gsl_matrix_short $a, gsl_matrix_short $b --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_short_sub(gsl_matrix_short $a, gsl_matrix_short $b --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_short_mul_elements(gsl_matrix_short $a, gsl_matrix_short $b --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_short_div_elements(gsl_matrix_short $a, gsl_matrix_short $b --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_short_scale(gsl_matrix_short $a, num64 $x --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_short_add_constant(gsl_matrix_short $a, num64 $x --> int32) is native(LIB) is export(:matrixop) { * }
sub gsl_matrix_short_add_diagonal(gsl_matrix_short $a, num64 $x --> int32) is native(LIB) is export(:matrixop) { * }
# Finding maximum and minimum elements of matrices
sub gsl_matrix_short_max(gsl_matrix_short $m --> int16) is native(LIB) is export(:matrixminmax) { * }
sub gsl_matrix_short_min(gsl_matrix_short $m --> int16) is native(LIB) is export(:matrixminmax) { * }
sub gsl_matrix_short_minmax(gsl_matrix_short $m, int16 $min_out is rw, int16 $max_out is rw) is native(LIB) is export(:matrixminmax) { * }
sub gsl_matrix_short_max_index(gsl_matrix_short $m, size_t $imax is rw, size_t $jmax is rw) is native(LIB) is export(:matrixminmax) { * }
sub gsl_matrix_short_min_index(gsl_matrix_short $m, size_t $imin is rw, size_t $jmin is rw) is native(LIB) is export(:matrixminmax) { * }
sub gsl_matrix_short_minmax_index(gsl_matrix_short $m, size_t $imin is rw, size_t $jmin is rw, size_t $imax is rw, size_t $jmax is rw) is native(LIB) is export(:matrixminmax) { * }
# Matrix properties
sub gsl_matrix_short_isnull(gsl_matrix_short $m --> int32) is native(LIB) is export(:matrixprop) { * }
sub gsl_matrix_short_ispos(gsl_matrix_short $m --> int32) is native(LIB) is export(:matrixprop) { * }
sub gsl_matrix_short_isneg(gsl_matrix_short $m --> int32) is native(LIB) is export(:matrixprop) { * }
sub gsl_matrix_short_isnonneg(gsl_matrix_short $m --> int32) is native(LIB) is export(:matrixprop) { * }
sub gsl_matrix_short_equal(gsl_matrix_short $a, gsl_matrix_short $b --> int32) is native(LIB) is export(:matrixprop) { * }
