use v6;

unit module Math::Libgsl::Raw::Matrix:ver<0.4.2>:auth<zef:FRITH>;

use NativeCall;

constant GSLHELPER = %?RESOURCES<libraries/gslhelper>.absolute;

sub LIB {
  run('/sbin/ldconfig', '-p', :chomp, :out)
    .out
    .slurp(:close)
    .split("\n")
    .grep(/^ \s+ libgsl\.so\. \d+ /)
    .sort
    .head
    .comb(/\S+/)
    .head;
}

class gsl_block is repr('CStruct') is export {
  has size_t          $.size;
  has Pointer[num64]  $.data;
}

class gsl_vector is repr('CStruct') is export {
  has size_t          $.size;
  has size_t          $.stride;
  has Pointer[num64]  $.data;
  has gsl_block       $.block;
  has int32           $.owner;
}

class gsl_vector_view is repr('CStruct') is export {
  HAS gsl_vector      $.vector;
}

class gsl_matrix is repr('CStruct') is export {
  has size_t          $.size1;
  has size_t          $.size2;
  has size_t          $.tda;
  has Pointer[num64]  $.data;
  has gsl_block       $.block;
  has int32           $.owner;
}

class gsl_matrix_view is repr('CStruct') is export {
  HAS gsl_matrix      $.matrix;
}

# Block allocation
sub gsl_block_alloc(size_t $n --> gsl_block) is native(&LIB) is export(:block) { * }
sub gsl_block_calloc(size_t $n --> gsl_block) is native(&LIB) is export(:block) { * }
sub gsl_block_free(gsl_block $b) is native(&LIB) is export(:block) { * }
# Reading and writing blocks
sub mgsl_block_fwrite(Str $filename, gsl_block $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_fread(Str $filename, gsl_block $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_fprintf(Str $filename, gsl_block $b, Str $format --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_fscanf(Str $filename, gsl_block $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
# Vector allocation
sub gsl_vector_alloc(size_t $n --> gsl_vector) is native(&LIB) is export(:vector) { * }
sub gsl_vector_calloc(size_t $n --> gsl_vector) is native(&LIB) is export(:vector) { * }
sub gsl_vector_free(gsl_vector $v) is native(&LIB) is export(:vector) { * }
# Accessing vector elements
sub gsl_vector_get(gsl_vector $v, size_t $i --> num64) is native(&LIB) is export(:vector) { * }
sub gsl_vector_set(gsl_vector $v, size_t $i, num64 $x) is native(&LIB) is export(:vector) { * }
# Initializing vector elements
sub gsl_vector_set_all(gsl_vector $v, num64 $x) is native(&LIB) is export(:vectorio) { * }
sub gsl_vector_set_zero(gsl_vector $v) is native(&LIB) is export(:vectorio) { * }
sub gsl_vector_set_basis(gsl_vector $v, size_t $i --> int32) is native(&LIB) is export(:vectorio) { * }
# Reading and writing vectors
sub mgsl_vector_fwrite(Str $filename, gsl_vector $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_fread(Str $filename, gsl_vector $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_fprintf(Str $filename, gsl_vector $v, Str $format --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_fscanf(Str $filename, gsl_vector $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
# Vector views
sub alloc_gsl_vector_view(--> gsl_vector_view) is native(GSLHELPER) is export(:vectorview) { * }
sub free_gsl_vector_view(gsl_vector_view $vv) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_subvector(gsl_vector_view $view, gsl_vector $v, size_t $offset, size_t $n --> gsl_vector) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_subvector_with_stride(gsl_vector_view $view, gsl_vector $v, size_t $offset, size_t $stride, size_t $n --> gsl_vector) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_view_array(gsl_vector_view $view, CArray[num64] $base, size_t $n --> gsl_vector) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_view_array_with_stride(gsl_vector_view $view, CArray[num64] $base, size_t $stride, size_t $n --> gsl_vector) is native(GSLHELPER) is export(:vectorview) { * }
# Copying vectors
sub gsl_vector_memcpy(gsl_vector $dest, gsl_vector $src --> int32) is native(&LIB) is export(:vectorcopy) { * }
sub gsl_vector_swap(gsl_vector $v, gsl_vector $w --> int32) is native(&LIB) is export(:vectorcopy) { * }
# Exchanging elements
sub gsl_vector_swap_elements(gsl_vector $v, size_t $i, size_t $j --> int32) is native(&LIB) is export(:vectorelem) { * }
sub gsl_vector_reverse(gsl_vector $v --> int32) is native(&LIB) is export(:vectorelem) { * }
# Vector operations
sub gsl_vector_add(gsl_vector $a, gsl_vector $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_sub(gsl_vector $a, gsl_vector $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_mul(gsl_vector $a, gsl_vector $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_div(gsl_vector $a, gsl_vector $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_scale(gsl_vector $a, num64 $x --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_add_constant(gsl_vector $a, num64 $x --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_sum(gsl_vector $a --> num64) is native(&LIB) is export(:vectorop) { * } # v. 2.7
sub gsl_vector_axpby(num64 $alpha, gsl_vector $x, num64 $beta, gsl_vector $y --> int32) is native(&LIB) is export(:vectorop) { * } # v. 2.7
# Finding maximum and minimum elements of vectors
sub gsl_vector_max(gsl_vector $v --> num64) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_min(gsl_vector $v --> num64) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_minmax(gsl_vector $v, num64 $min_out is rw, num64 $max_out is rw) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_max_index(gsl_vector $v --> size_t) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_min_index(gsl_vector $v --> size_t) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_minmax_index(gsl_vector $v, size_t $imin is rw, size_t $imax is rw) is native(&LIB) is export(:vectorminmax) { * }
# Vector properties
sub gsl_vector_isnull(gsl_vector $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_ispos(gsl_vector $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_isneg(gsl_vector $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_isnonneg(gsl_vector $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_equal(gsl_vector $u, gsl_vector $v --> int32) is native(&LIB) is export(:vectorprop) { * }
# Matrix allocation
sub gsl_matrix_alloc(size_t $n1, size_t $n2 --> gsl_matrix) is native(&LIB) is export(:matrix) { * }
sub gsl_matrix_calloc(size_t $n1, size_t $n2 --> gsl_matrix) is native(&LIB) is export(:matrix) { * }
sub gsl_matrix_free(gsl_matrix $m) is native(&LIB) is export(:matrix) { * }
# Accessing matrix elements
sub gsl_matrix_get(gsl_matrix $m, size_t $i, size_t $j --> num64) is native(&LIB) is export(:matrix) { * }
sub gsl_matrix_set(gsl_matrix $m, size_t $i, size_t $j, num64 $x) is native(&LIB) is export(:matrix) { * }
# Initializing matrix elements
sub gsl_matrix_set_all(gsl_matrix $m, num64 $x) is native(&LIB) is export(:matrixio) { * }
sub gsl_matrix_set_zero(gsl_matrix $m) is native(&LIB) is export(:matrixio) { * }
sub gsl_matrix_set_identity(gsl_matrix $m) is native(&LIB) is export(:matrixio) { * }
# Reading and writing matrices
sub mgsl_matrix_fwrite(Str $filename, gsl_matrix $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_fread(Str $filename, gsl_matrix $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_fprintf(Str $filename, gsl_matrix $m, Str $format --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_fscanf(Str $filename, gsl_matrix $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
# Matrix views
sub alloc_gsl_matrix_view(--> gsl_matrix_view) is native(GSLHELPER) is export(:matrixview) { * }
sub free_gsl_matrix_view(gsl_matrix_view $mv) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_submatrix(gsl_matrix_view $view, gsl_matrix $m, size_t $k1, size_t $k2, size_t $n1, size_t $n2 --> gsl_matrix) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_view_array(gsl_matrix_view $view, CArray[num64] $base, size_t $n1, size_t $n2 --> gsl_matrix) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_view_array_with_tda(gsl_matrix_view $view, CArray[num64] $base, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_view_vector(gsl_matrix_view $view, gsl_vector $v, size_t $n1, size_t $n2 --> gsl_matrix) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_view_vector_with_tda(gsl_matrix_view $view, gsl_vector $v, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix) is native(GSLHELPER) is export(:matrixview) { * }
# Creating row and column views
sub mgsl_matrix_row(gsl_vector_view $view, gsl_matrix $m, size_t $i --> gsl_vector) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_column(gsl_vector_view $view, gsl_matrix $m, size_t $j --> gsl_vector) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_subrow(gsl_vector_view $view, gsl_matrix $m, size_t $i, size_t $offset, size_t $n --> gsl_vector) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_subcolumn(gsl_vector_view $view, gsl_matrix $m, size_t $j, size_t $offset, size_t $n --> gsl_vector) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_diagonal(gsl_vector_view $view, gsl_matrix $m --> gsl_vector) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_subdiagonal(gsl_vector_view $view, gsl_matrix $m, size_t $k --> gsl_vector) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_superdiagonal(gsl_vector_view $view, gsl_matrix $m, size_t $k --> gsl_vector) is native(GSLHELPER) is export(:matrixview) { * }
# Copying matrices
sub gsl_matrix_memcpy(gsl_matrix $dest, gsl_matrix $src --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_swap(gsl_matrix $m1, gsl_matrix $m2 --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_tricpy(int32 $uplo_src, int32 $copy_diag, gsl_matrix $dest, gsl_matrix $src --> int32) is native(&LIB) is export(:matrixcopy) { * }
# Copying rows and columns
sub gsl_matrix_get_row(gsl_vector $v, gsl_matrix $m, size_t $i --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_get_col(gsl_vector $v, gsl_matrix $m, size_t $j --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_set_row(gsl_matrix $m, size_t $i, gsl_vector $v --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_set_col(gsl_matrix $m, size_t $j, gsl_vector $v --> int32) is native(&LIB) is export(:matrixcopy) { * }
# Exchanging rows and columns
sub gsl_matrix_swap_rows(gsl_matrix $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_swap_columns(gsl_matrix $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_swap_rowcol(gsl_matrix $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_transpose_memcpy(gsl_matrix $dest, gsl_matrix $src --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_transpose(gsl_matrix $m --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_transpose_tricpy(int32 $uplo_src, int32 $copy_diag, gsl_matrix $dest, gsl_matrix $src --> int32) is native(&LIB) is export(:matrixexch) { * }
# Matrix operations
sub gsl_matrix_add(gsl_matrix $a, gsl_matrix $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_sub(gsl_matrix $a, gsl_matrix $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_mul_elements(gsl_matrix $a, gsl_matrix $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_div_elements(gsl_matrix $a, gsl_matrix $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_scale(gsl_matrix $a, num64 $x --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_scale_rows(gsl_matrix $a, gsl_vector $x --> int32) is native(&LIB) is export(:matrixop) { * } # v. 2.7
sub gsl_matrix_scale_columns(gsl_matrix $a, gsl_vector $x --> int32) is native(&LIB) is export(:matrixop) { * } # v. 2.7
sub gsl_matrix_add_constant(gsl_matrix $a, num64 $x --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_add_diagonal(gsl_matrix $a, num64 $x --> int32) is native(&LIB) is export(:matrixop) { * }
# Finding maximum and minimum elements of matrices
sub gsl_matrix_max(gsl_matrix $m --> num64) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_min(gsl_matrix $m --> num64) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_minmax(gsl_matrix $m, num64 $min_out is rw, num64 $max_out is rw) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_max_index(gsl_matrix $m, size_t $imax is rw, size_t $jmax is rw) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_min_index(gsl_matrix $m, size_t $imin is rw, size_t $jmin is rw) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_minmax_index(gsl_matrix $m, size_t $imin is rw, size_t $jmin is rw, size_t $imax is rw, size_t $jmax is rw) is native(&LIB) is export(:matrixminmax) { * }
# Matrix properties
sub gsl_matrix_isnull(gsl_matrix $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_ispos(gsl_matrix $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_isneg(gsl_matrix $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_isnonneg(gsl_matrix $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_equal(gsl_matrix $a, gsl_matrix $b --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_norm1(gsl_matrix $a --> num64) is native(&LIB) is export(:matrixprop) { * } # v. 2.7
