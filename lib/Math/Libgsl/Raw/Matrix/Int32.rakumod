use v6;

unit module Math::Libgsl::Raw::Matrix::Int32:ver<0.6.0>:auth<zef:FRITH>;

use NativeCall;

constant GSLHELPER = %?RESOURCES<libraries/gslhelper>.absolute;

sub LIB {
  run('/sbin/ldconfig', '-p', :chomp, :out).out.slurp(:close).split("\n").grep(/^ \s+ libgsl\.so\. \d+ /).sort.head.comb(/\S+/).head;
}

class gsl_block_int is repr('CStruct') is export {
  has size_t          $.size;
  has Pointer[int32]  $.data;
}

class gsl_vector_int is repr('CStruct') is export {
  has size_t          $.size;
  has size_t          $.stride;
  has Pointer[int32]  $.data;
  has gsl_block_int   $.block;
  has int32           $.owner;
}

class gsl_vector_int_view is repr('CStruct') is export {
  HAS gsl_vector_int      $.vector;
}

class gsl_matrix_int is repr('CStruct') is export {
  has size_t          $.size1;
  has size_t          $.size2;
  has size_t          $.tda;
  has Pointer[int32]  $.data;
  has gsl_block_int   $.block;
  has int32           $.owner;
}

class gsl_matrix_int_view is repr('CStruct') is export {
  HAS gsl_matrix_int      $.matrix;
}

# Block allocation
sub gsl_block_int_alloc(size_t $n --> gsl_block_int) is native(&LIB) is export(:block) { * }
sub gsl_block_int_calloc(size_t $n --> gsl_block_int) is native(&LIB) is export(:block) { * }
sub gsl_block_int_free(gsl_block_int $b) is native(&LIB) is export(:block) { * }
# Reading and writing blocks
sub mgsl_block_int_fwrite(Str $filename, gsl_block_int $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_int_fread(Str $filename, gsl_block_int $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_int_fprintf(Str $filename, gsl_block_int $b, Str $format --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_int_fscanf(Str $filename, gsl_block_int $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
# Vector allocation
sub gsl_vector_int_alloc(size_t $n --> gsl_vector_int) is native(&LIB) is export(:vector) { * }
sub gsl_vector_int_calloc(size_t $n --> gsl_vector_int) is native(&LIB) is export(:vector) { * }
sub gsl_vector_int_free(gsl_vector_int $v) is native(&LIB) is export(:vector) { * }
# Accessing vector elements
sub gsl_vector_int_get(gsl_vector_int $v, size_t $i --> int32) is native(&LIB) is export(:vector) { * }
sub gsl_vector_int_set(gsl_vector_int $v, size_t $i, int32 $x) is native(&LIB) is export(:vector) { * }
# Initializing vector elements
sub gsl_vector_int_set_all(gsl_vector_int $v, int32 $x) is native(&LIB) is export(:vectorio) { * }
sub gsl_vector_int_set_zero(gsl_vector_int $v) is native(&LIB) is export(:vectorio) { * }
sub gsl_vector_int_set_basis(gsl_vector_int $v, size_t $i --> int32) is native(&LIB) is export(:vectorio) { * }
# Reading and writing vectors
sub mgsl_vector_int_fwrite(Str $filename, gsl_vector_int $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_int_fread(Str $filename, gsl_vector_int $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_int_fprintf(Str $filename, gsl_vector_int $v, Str $format --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_int_fscanf(Str $filename, gsl_vector_int $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
# Vector views
sub alloc_gsl_vector_int_view(--> gsl_vector_int_view) is native(GSLHELPER) is export(:vectorview) { * }
sub free_gsl_vector_int_view(gsl_vector_int_view $vv) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_int_subvector(gsl_vector_int_view $view, gsl_vector_int $v, size_t $offset, size_t $n --> gsl_vector_int) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_int_subvector_with_stride(gsl_vector_int_view $view, gsl_vector_int $v, size_t $offset, size_t $stride, size_t $n --> gsl_vector_int) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_int_view_array(gsl_vector_int_view $view, CArray[int32] $base, size_t $n --> gsl_vector_int) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_int_view_array_with_stride(gsl_vector_int_view $view, CArray[int32] $base, size_t $stride, size_t $n --> gsl_vector_int) is native(GSLHELPER) is export(:vectorview) { * }
# Copying vectors
sub gsl_vector_int_memcpy(gsl_vector_int $dest, gsl_vector_int $src --> int32) is native(&LIB) is export(:vectorcopy) { * }
sub gsl_vector_int_swap(gsl_vector_int $v, gsl_vector_int $w --> int32) is native(&LIB) is export(:vectorcopy) { * }
# Exchanging elements
sub gsl_vector_int_swap_elements(gsl_vector_int $v, size_t $i, size_t $j --> int32) is native(&LIB) is export(:vectorelem) { * }
sub gsl_vector_int_reverse(gsl_vector_int $v --> int32) is native(&LIB) is export(:vectorelem) { * }
# Vector operations
sub gsl_vector_int_add(gsl_vector_int $a, gsl_vector_int $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_int_sub(gsl_vector_int $a, gsl_vector_int $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_int_mul(gsl_vector_int $a, gsl_vector_int $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_int_div(gsl_vector_int $a, gsl_vector_int $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_int_scale(gsl_vector_int $a, int32 $x --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_int_add_constant(gsl_vector_int $a, int32 $x --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_int_sum(gsl_vector_int $a --> int32) is native(&LIB) is export(:vectorop) { * } # v. 2.7
sub gsl_vector_int_axpby(int32 $alpha, gsl_vector_int $x, int32 $beta, gsl_vector_int $y --> int32) is native(&LIB) is export(:vectorop) { * } # v. 2.7
# Finding maximum and minimum elements of vectors
sub gsl_vector_int_max(gsl_vector_int $v --> int32) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_int_min(gsl_vector_int $v --> int32) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_int_minmax(gsl_vector_int $v, int32 $min_out is rw, int32 $max_out is rw) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_int_max_index(gsl_vector_int $v --> size_t) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_int_min_index(gsl_vector_int $v --> size_t) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_int_minmax_index(gsl_vector_int $v, size_t $imin is rw, size_t $imax is rw) is native(&LIB) is export(:vectorminmax) { * }
# Vector properties
sub gsl_vector_int_isnull(gsl_vector_int $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_int_ispos(gsl_vector_int $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_int_isneg(gsl_vector_int $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_int_isnonneg(gsl_vector_int $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_int_equal(gsl_vector_int $u, gsl_vector_int $v --> int32) is native(&LIB) is export(:vectorprop) { * }
# Matrix allocation
sub gsl_matrix_int_alloc(size_t $n1, size_t $n2 --> gsl_matrix_int) is native(&LIB) is export(:matrix) { * }
sub gsl_matrix_int_calloc(size_t $n1, size_t $n2 --> gsl_matrix_int) is native(&LIB) is export(:matrix) { * }
sub gsl_matrix_int_free(gsl_matrix_int $m) is native(&LIB) is export(:matrix) { * }
# Accessing matrix elements
sub gsl_matrix_int_get(gsl_matrix_int $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrix) { * }
sub gsl_matrix_int_set(gsl_matrix_int $m, size_t $i, size_t $j, int32 $x) is native(&LIB) is export(:matrix) { * }
# Initializing matrix elements
sub gsl_matrix_int_set_all(gsl_matrix_int $m, int32 $x) is native(&LIB) is export(:matrixio) { * }
sub gsl_matrix_int_set_zero(gsl_matrix_int $m) is native(&LIB) is export(:matrixio) { * }
sub gsl_matrix_int_set_identity(gsl_matrix_int $m) is native(&LIB) is export(:matrixio) { * }
# Reading and writing matrices
sub mgsl_matrix_int_fwrite(Str $filename, gsl_matrix_int $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_int_fread(Str $filename, gsl_matrix_int $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_int_fprintf(Str $filename, gsl_matrix_int $m, Str $format --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_int_fscanf(Str $filename, gsl_matrix_int $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
# Matrix views
sub alloc_gsl_matrix_int_view(--> gsl_matrix_int_view) is native(GSLHELPER) is export(:matrixview) { * }
sub free_gsl_matrix_int_view(gsl_matrix_int_view $mv) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_int_submatrix(gsl_matrix_int_view $view, gsl_matrix_int $m, size_t $k1, size_t $k2, size_t $n1, size_t $n2 --> gsl_matrix_int) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_int_view_array(gsl_matrix_int_view $view, CArray[int32] $base, size_t $n1, size_t $n2 --> gsl_matrix_int) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_int_view_array_with_tda(gsl_matrix_int_view $view, CArray[int32] $base, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix_int) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_int_view_vector(gsl_matrix_int_view $view, gsl_vector_int $v, size_t $n1, size_t $n2 --> gsl_matrix_int) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_int_view_vector_with_tda(gsl_matrix_int_view $view, gsl_vector_int $v, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix_int) is native(GSLHELPER) is export(:matrixview) { * }
# Creating row and column views
sub mgsl_matrix_int_row(gsl_vector_int_view $view, gsl_matrix_int $m, size_t $i --> gsl_vector_int) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_int_column(gsl_vector_int_view $view, gsl_matrix_int $m, size_t $j --> gsl_vector_int) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_int_subrow(gsl_vector_int_view $view, gsl_matrix_int $m, size_t $i, size_t $offset, size_t $n --> gsl_vector_int) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_int_subcolumn(gsl_vector_int_view $view, gsl_matrix_int $m, size_t $j, size_t $offset, size_t $n --> gsl_vector_int) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_int_diagonal(gsl_vector_int_view $view, gsl_matrix_int $m --> gsl_vector_int) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_int_subdiagonal(gsl_vector_int_view $view, gsl_matrix_int $m, size_t $k --> gsl_vector_int) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_int_superdiagonal(gsl_vector_int_view $view, gsl_matrix_int $m, size_t $k --> gsl_vector_int) is native(GSLHELPER) is export(:matrixview) { * }
# Copying matrices
sub gsl_matrix_int_memcpy(gsl_matrix_int $dest, gsl_matrix_int $src --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_int_swap(gsl_matrix_int $m1, gsl_matrix_int $m2 --> int32) is native(&LIB) is export(:matrixcopy) { * }
# Copying rows and columns
sub gsl_matrix_int_get_row(gsl_vector_int $v, gsl_matrix_int $m, size_t $i --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_int_get_col(gsl_vector_int $v, gsl_matrix_int $m, size_t $j --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_int_set_row(gsl_matrix_int $m, size_t $i, gsl_vector_int $v --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_int_set_col(gsl_matrix_int $m, size_t $j, gsl_vector_int $v --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_int_tricpy(int32 $uplo_src, int32 $copy_diag, gsl_matrix_int $dest, gsl_matrix_int $src --> int32) is native(&LIB) is export(:matrixcopy) { * }
# Exchanging rows and columns
sub gsl_matrix_int_swap_rows(gsl_matrix_int $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_int_swap_columns(gsl_matrix_int $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_int_swap_rowcol(gsl_matrix_int $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_int_transpose_memcpy(gsl_matrix_int $dest, gsl_matrix_int $src --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_int_transpose(gsl_matrix_int $m --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_int_transpose_tricpy(int32 $uplo_src, int32 $copy_diag, gsl_matrix_int $dest, gsl_matrix_int $src --> int32) is native(&LIB) is export(:matrixexch) { * }
# Matrix operations
sub gsl_matrix_int_add(gsl_matrix_int $a, gsl_matrix_int $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_int_sub(gsl_matrix_int $a, gsl_matrix_int $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_int_mul_elements(gsl_matrix_int $a, gsl_matrix_int $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_int_div_elements(gsl_matrix_int $a, gsl_matrix_int $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_int_scale(gsl_matrix_int $a, num64 $x --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_int_scale_rows(gsl_matrix_int $a, gsl_vector_int $x --> int32) is native(&LIB) is export(:matrixop) { * } # v. 2.7
sub gsl_matrix_int_scale_columns(gsl_matrix_int $a, gsl_vector_int $x --> int32) is native(&LIB) is export(:matrixop) { * } # v. 2.7
sub gsl_matrix_int_add_constant(gsl_matrix_int $a, num64 $x --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_int_add_diagonal(gsl_matrix_int $a, num64 $x --> int32) is native(&LIB) is export(:matrixop) { * }
# Finding maximum and minimum elements of matrices
sub gsl_matrix_int_max(gsl_matrix_int $m --> int32) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_int_min(gsl_matrix_int $m --> int32) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_int_minmax(gsl_matrix_int $m, int32 $min_out is rw, int32 $max_out is rw) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_int_max_index(gsl_matrix_int $m, size_t $imax is rw, size_t $jmax is rw) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_int_min_index(gsl_matrix_int $m, size_t $imin is rw, size_t $jmin is rw) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_int_minmax_index(gsl_matrix_int $m, size_t $imin is rw, size_t $jmin is rw, size_t $imax is rw, size_t $jmax is rw) is native(&LIB) is export(:matrixminmax) { * }
# Matrix properties
sub gsl_matrix_int_isnull(gsl_matrix_int $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_int_ispos(gsl_matrix_int $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_int_isneg(gsl_matrix_int $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_int_isnonneg(gsl_matrix_int $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_int_equal(gsl_matrix_int $a, gsl_matrix_int $b --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_int_norm1(gsl_matrix_int $a --> int32) is native(&LIB) is export(:matrixprop) { * } # v. 2.7
