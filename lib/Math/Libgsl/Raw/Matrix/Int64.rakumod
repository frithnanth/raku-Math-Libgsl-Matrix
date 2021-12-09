use v6;

unit module Math::Libgsl::Raw::Matrix::Int64:ver<0.4.2>:auth<zef:FRITH>;

use NativeCall;

constant GSLHELPER = %?RESOURCES<libraries/gslhelper>.absolute;

sub LIB {
  run('/sbin/ldconfig', '-p', :chomp, :out).out.slurp(:close).split("\n").grep(/^ \s+ libgsl\.so\. \d+ /).sort.head.comb(/\S+/).head;
}

class gsl_block_long is repr('CStruct') is export {
  has size_t          $.size;
  has Pointer[int64]  $.data;
}

class gsl_vector_long is repr('CStruct') is export {
  has size_t          $.size;
  has size_t          $.stride;
  has Pointer[int64]  $.data;
  has gsl_block_long  $.block;
  has int32           $.owner;
}

class gsl_vector_long_view is repr('CStruct') is export {
  HAS gsl_vector_long      $.vector;
}

class gsl_matrix_long is repr('CStruct') is export {
  has size_t          $.size1;
  has size_t          $.size2;
  has size_t          $.tda;
  has Pointer[int64]  $.data;
  has gsl_block_long  $.block;
  has int32           $.owner;
}

class gsl_matrix_long_view is repr('CStruct') is export {
  HAS gsl_matrix_long      $.matrix;
}

# Block allocation
sub gsl_block_long_alloc(size_t $n --> gsl_block_long) is native(&LIB) is export(:block) { * }
sub gsl_block_long_calloc(size_t $n --> gsl_block_long) is native(&LIB) is export(:block) { * }
sub gsl_block_long_free(gsl_block_long $b) is native(&LIB) is export(:block) { * }
# Reading and writing blocks
sub mgsl_block_long_fwrite(Str $filename, gsl_block_long $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_long_fread(Str $filename, gsl_block_long $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_long_fprintf(Str $filename, gsl_block_long $b, Str $format --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_long_fscanf(Str $filename, gsl_block_long $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
# Vector allocation
sub gsl_vector_long_alloc(size_t $n --> gsl_vector_long) is native(&LIB) is export(:vector) { * }
sub gsl_vector_long_calloc(size_t $n --> gsl_vector_long) is native(&LIB) is export(:vector) { * }
sub gsl_vector_long_free(gsl_vector_long $v) is native(&LIB) is export(:vector) { * }
# Accessing vector elements
sub gsl_vector_long_get(gsl_vector_long $v, size_t $i --> int64) is native(&LIB) is export(:vector) { * }
sub gsl_vector_long_set(gsl_vector_long $v, size_t $i, int64 $x) is native(&LIB) is export(:vector) { * }
# Initializing vector elements
sub gsl_vector_long_set_all(gsl_vector_long $v, int64 $x) is native(&LIB) is export(:vectorio) { * }
sub gsl_vector_long_set_zero(gsl_vector_long $v) is native(&LIB) is export(:vectorio) { * }
sub gsl_vector_long_set_basis(gsl_vector_long $v, size_t $i --> int32) is native(&LIB) is export(:vectorio) { * }
# Reading and writing vectors
sub mgsl_vector_long_fwrite(Str $filename, gsl_vector_long $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_long_fread(Str $filename, gsl_vector_long $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_long_fprintf(Str $filename, gsl_vector_long $v, Str $format --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_long_fscanf(Str $filename, gsl_vector_long $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
# Vector views
sub alloc_gsl_vector_long_view(--> gsl_vector_long_view) is native(GSLHELPER) is export(:vectorview) { * }
sub free_gsl_vector_long_view(gsl_vector_long_view $vv) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_long_subvector(gsl_vector_long_view $view, gsl_vector_long $v, size_t $offset, size_t $n --> gsl_vector_long) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_long_subvector_with_stride(gsl_vector_long_view $view, gsl_vector_long $v, size_t $offset, size_t $stride, size_t $n --> gsl_vector_long) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_long_view_array(gsl_vector_long_view $view, CArray[int64] $base, size_t $n --> gsl_vector_long) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_long_view_array_with_stride(gsl_vector_long_view $view, CArray[int64] $base, size_t $stride, size_t $n --> gsl_vector_long) is native(GSLHELPER) is export(:vectorview) { * }
# Copying vectors
sub gsl_vector_long_memcpy(gsl_vector_long $dest, gsl_vector_long $src --> int32) is native(&LIB) is export(:vectorcopy) { * }
sub gsl_vector_long_swap(gsl_vector_long $v, gsl_vector_long $w --> int32) is native(&LIB) is export(:vectorcopy) { * }
# Exchanging elements
sub gsl_vector_long_swap_elements(gsl_vector_long $v, size_t $i, size_t $j --> int32) is native(&LIB) is export(:vectorelem) { * }
sub gsl_vector_long_reverse(gsl_vector_long $v --> int32) is native(&LIB) is export(:vectorelem) { * }
# Vector operations
sub gsl_vector_long_add(gsl_vector_long $a, gsl_vector_long $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_long_sub(gsl_vector_long $a, gsl_vector_long $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_long_mul(gsl_vector_long $a, gsl_vector_long $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_long_div(gsl_vector_long $a, gsl_vector_long $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_long_scale(gsl_vector_long $a, int64 $x --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_long_add_constant(gsl_vector_long $a, int64 $x --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_long_sum(gsl_vector_long $a --> int64) is native(&LIB) is export(:vectorop) { * } # v. 2.7
sub gsl_vector_long_axpby(int64 $alpha, gsl_vector_long $x, int64 $beta, gsl_vector_long $y --> int32) is native(&LIB) is export(:vectorop) { * } # v. 2.7
# Finding maximum and minimum elements of vectors
sub gsl_vector_long_max(gsl_vector_long $v --> int64) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_long_min(gsl_vector_long $v --> int64) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_long_minmax(gsl_vector_long $v, int64 $min_out is rw, int64 $max_out is rw) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_long_max_index(gsl_vector_long $v --> size_t) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_long_min_index(gsl_vector_long $v --> size_t) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_long_minmax_index(gsl_vector_long $v, size_t $imin is rw, size_t $imax is rw) is native(&LIB) is export(:vectorminmax) { * }
# Vector properties
sub gsl_vector_long_isnull(gsl_vector_long $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_long_ispos(gsl_vector_long $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_long_isneg(gsl_vector_long $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_long_isnonneg(gsl_vector_long $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_long_equal(gsl_vector_long $u, gsl_vector_long $v --> int32) is native(&LIB) is export(:vectorprop) { * }
# Matrix allocation
sub gsl_matrix_long_alloc(size_t $n1, size_t $n2 --> gsl_matrix_long) is native(&LIB) is export(:matrix) { * }
sub gsl_matrix_long_calloc(size_t $n1, size_t $n2 --> gsl_matrix_long) is native(&LIB) is export(:matrix) { * }
sub gsl_matrix_long_free(gsl_matrix_long $m) is native(&LIB) is export(:matrix) { * }
# Accessing matrix elements
sub gsl_matrix_long_get(gsl_matrix_long $m, size_t $i, size_t $j --> int64) is native(&LIB) is export(:matrix) { * }
sub gsl_matrix_long_set(gsl_matrix_long $m, size_t $i, size_t $j, int64 $x) is native(&LIB) is export(:matrix) { * }
# Initializing matrix elements
sub gsl_matrix_long_set_all(gsl_matrix_long $m, int64 $x) is native(&LIB) is export(:matrixio) { * }
sub gsl_matrix_long_set_zero(gsl_matrix_long $m) is native(&LIB) is export(:matrixio) { * }
sub gsl_matrix_long_set_identity(gsl_matrix_long $m) is native(&LIB) is export(:matrixio) { * }
# Reading and writing matrices
sub mgsl_matrix_long_fwrite(Str $filename, gsl_matrix_long $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_long_fread(Str $filename, gsl_matrix_long $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_long_fprintf(Str $filename, gsl_matrix_long $m, Str $format --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_long_fscanf(Str $filename, gsl_matrix_long $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
# Matrix views
sub alloc_gsl_matrix_long_view(--> gsl_matrix_long_view) is native(GSLHELPER) is export(:matrixview) { * }
sub free_gsl_matrix_long_view(gsl_matrix_long_view $mv) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_long_submatrix(gsl_matrix_long_view $view, gsl_matrix_long $m, size_t $k1, size_t $k2, size_t $n1, size_t $n2 --> gsl_matrix_long) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_long_view_array(gsl_matrix_long_view $view, CArray[int64] $base, size_t $n1, size_t $n2 --> gsl_matrix_long) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_long_view_array_with_tda(gsl_matrix_long_view $view, CArray[int64] $base, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix_long) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_long_view_vector(gsl_matrix_long_view $view, gsl_vector_long $v, size_t $n1, size_t $n2 --> gsl_matrix_long) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_long_view_vector_with_tda(gsl_matrix_long_view $view, gsl_vector_long $v, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix_long) is native(GSLHELPER) is export(:matrixview) { * }
# Creating row and column views
sub mgsl_matrix_long_row(gsl_vector_long_view $view, gsl_matrix_long $m, size_t $i --> gsl_vector_long) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_long_column(gsl_vector_long_view $view, gsl_matrix_long $m, size_t $j --> gsl_vector_long) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_long_subrow(gsl_vector_long_view $view, gsl_matrix_long $m, size_t $i, size_t $offset, size_t $n --> gsl_vector_long) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_long_subcolumn(gsl_vector_long_view $view, gsl_matrix_long $m, size_t $j, size_t $offset, size_t $n --> gsl_vector_long) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_long_diagonal(gsl_vector_long_view $view, gsl_matrix_long $m --> gsl_vector_long) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_long_subdiagonal(gsl_vector_long_view $view, gsl_matrix_long $m, size_t $k --> gsl_vector_long) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_long_superdiagonal(gsl_vector_long_view $view, gsl_matrix_long $m, size_t $k --> gsl_vector_long) is native(GSLHELPER) is export(:matrixview) { * }
# Copying matrices
sub gsl_matrix_long_memcpy(gsl_matrix_long $dest, gsl_matrix_long $src --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_long_swap(gsl_matrix_long $m1, gsl_matrix_long $m2 --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_long_tricpy(int32 $uplo_src, int32 $copy_diag, gsl_matrix_long $dest, gsl_matrix_long $src --> int32) is native(&LIB) is export(:matrixcopy) { * }
# Copying rows and columns
sub gsl_matrix_long_get_row(gsl_vector_long $v, gsl_matrix_long $m, size_t $i --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_long_get_col(gsl_vector_long $v, gsl_matrix_long $m, size_t $j --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_long_set_row(gsl_matrix_long $m, size_t $i, gsl_vector_long $v --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_long_set_col(gsl_matrix_long $m, size_t $j, gsl_vector_long $v --> int32) is native(&LIB) is export(:matrixcopy) { * }
# Exchanging rows and columns
sub gsl_matrix_long_swap_rows(gsl_matrix_long $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_long_swap_columns(gsl_matrix_long $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_long_swap_rowcol(gsl_matrix_long $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_long_transpose_memcpy(gsl_matrix_long $dest, gsl_matrix_long $src --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_long_transpose(gsl_matrix_long $m --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_long_transpose_tricpy(int32 $uplo_src, int32 $copy_diag, gsl_matrix_long $dest, gsl_matrix_long $src --> int32) is native(&LIB) is export(:matrixexch) { * }
# Matrix operations
sub gsl_matrix_long_add(gsl_matrix_long $a, gsl_matrix_long $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_long_sub(gsl_matrix_long $a, gsl_matrix_long $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_long_mul_elements(gsl_matrix_long $a, gsl_matrix_long $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_long_div_elements(gsl_matrix_long $a, gsl_matrix_long $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_long_scale(gsl_matrix_long $a, num64 $x --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_long_scale_rows(gsl_matrix_long $a, gsl_vector_long $x --> int32) is native(&LIB) is export(:matrixop) { * } # v. 2.7
sub gsl_matrix_long_scale_columns(gsl_matrix_long $a, gsl_vector_long $x --> int32) is native(&LIB) is export(:matrixop) { * } # v. 2.7
sub gsl_matrix_long_add_constant(gsl_matrix_long $a, num64 $x --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_long_add_diagonal(gsl_matrix_long $a, num64 $x --> int32) is native(&LIB) is export(:matrixop) { * }
# Finding maximum and minimum elements of matrices
sub gsl_matrix_long_max(gsl_matrix_long $m --> int64) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_long_min(gsl_matrix_long $m --> int64) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_long_minmax(gsl_matrix_long $m, int64 $min_out is rw, int64 $max_out is rw) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_long_max_index(gsl_matrix_long $m, size_t $imax is rw, size_t $jmax is rw) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_long_min_index(gsl_matrix_long $m, size_t $imin is rw, size_t $jmin is rw) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_long_minmax_index(gsl_matrix_long $m, size_t $imin is rw, size_t $jmin is rw, size_t $imax is rw, size_t $jmax is rw) is native(&LIB) is export(:matrixminmax) { * }
# Matrix properties
sub gsl_matrix_long_isnull(gsl_matrix_long $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_long_ispos(gsl_matrix_long $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_long_isneg(gsl_matrix_long $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_long_isnonneg(gsl_matrix_long $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_long_equal(gsl_matrix_long $a, gsl_matrix_long $b --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_long_norm1(gsl_matrix_long $a --> int64) is native(&LIB) is export(:matrixprop) { * } # v. 2.7
