use v6;

unit module Math::Libgsl::Raw::Matrix::Complex64:ver<0.3.1>:auth<cpan:FRITH>;

use Math::Libgsl::Raw::Complex :ALL;
use Math::Libgsl::Raw::Matrix;
use NativeCall;

constant GSLHELPER = %?RESOURCES<libraries/gslhelper>.absolute;

sub LIB {
  run('/sbin/ldconfig', '-p', :chomp, :out).out.slurp(:close).split("\n").grep(/^ \s+ libgsl\.so\. \d+ /).sort.head.comb(/\S+/).head;
}

class gsl_block_complex is repr('CStruct') is export {
  has size_t          $.size;
  has Pointer[num64]  $.data;
}

class gsl_vector_complex is repr('CStruct') is export {
  has size_t            $.size;
  has size_t            $.stride;
  has Pointer[num64]    $.data;
  has gsl_block_complex $.block;
  has int32             $.owner;
}

class gsl_vector_complex_view is repr('CStruct') is export {
  HAS gsl_vector_complex      $.vector;
}

class gsl_matrix_complex is repr('CStruct') is export {
  has size_t            $.size1;
  has size_t            $.size2;
  has size_t            $.tda;
  has Pointer[num64]    $.data;
  has gsl_block_complex $.block;
  has int32             $.owner;
}

class gsl_matrix_complex_view is repr('CStruct') is export {
  HAS gsl_matrix_complex      $.matrix;
}

# Block allocation
sub gsl_block_complex_alloc(size_t $n --> gsl_block_complex) is native(&LIB) is export(:block) { * }
sub gsl_block_complex_calloc(size_t $n --> gsl_block_complex) is native(&LIB) is export(:block) { * }
sub gsl_block_complex_free(gsl_block_complex $b) is native(&LIB) is export(:block) { * }
# Reading and writing blocks
sub mgsl_block_complex_fwrite(Str $filename, gsl_block_complex $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_complex_fread(Str $filename, gsl_block_complex $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_complex_fprintf(Str $filename, gsl_block_complex $b, Str $format --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_complex_fscanf(Str $filename, gsl_block_complex $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
# Vector allocation
sub gsl_vector_complex_alloc(size_t $n --> gsl_vector_complex) is native(&LIB) is export(:vector) { * }
sub gsl_vector_complex_calloc(size_t $n --> gsl_vector_complex) is native(&LIB) is export(:vector) { * }
sub gsl_vector_complex_free(gsl_vector_complex $v) is native(&LIB) is export(:vector) { * }
# Accessing vector elements
sub mgsl_vector_complex_get(gsl_vector_complex $v, size_t $i, gsl_complex $res) is native(GSLHELPER) is export(:vector) { * }
sub mgsl_vector_complex_set(gsl_vector_complex $v, size_t $i, gsl_complex $x) is native(GSLHELPER) is export(:vector) { * }
# Initializing vector elements
sub mgsl_vector_complex_set_all(gsl_vector_complex $v, gsl_complex $x) is native(GSLHELPER) is export(:vectorio) { * }
sub gsl_vector_complex_set_zero(gsl_vector_complex $v) is native(&LIB) is export(:vectorio) { * }
sub gsl_vector_complex_set_basis(gsl_vector_complex $v, size_t $i --> int32) is native(&LIB) is export(:vectorio) { * }
# Reading and writing vectors
sub mgsl_vector_complex_fwrite(Str $filename, gsl_vector_complex $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_complex_fread(Str $filename, gsl_vector_complex $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_complex_fprintf(Str $filename, gsl_vector_complex $v, Str $format --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_complex_fscanf(Str $filename, gsl_vector_complex $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
# Vector views
sub mgsl_vector_complex_real(gsl_vector_view $view, gsl_vector_complex $v --> gsl_vector) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_complex_imag(gsl_vector_view $view, gsl_vector_complex $v --> gsl_vector) is native(GSLHELPER) is export(:vectorview) { * }
sub alloc_gsl_vector_complex_view(--> gsl_vector_complex_view) is native(GSLHELPER) is export(:vectorview) { * }
sub free_gsl_vector_complex_view(gsl_vector_complex_view $vv) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_complex_subvector(gsl_vector_complex_view $view, gsl_vector_complex $v, size_t $offset, size_t $n --> gsl_vector_complex) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_complex_subvector_with_stride(gsl_vector_complex_view $view, gsl_vector_complex $v, size_t $offset, size_t $stride, size_t $n --> gsl_vector_complex) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_complex_view_array(gsl_vector_complex_view $view, CArray[num64] $base, size_t $n --> gsl_vector_complex) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_complex_view_array_with_stride(gsl_vector_complex_view $view, CArray[num64] $base, size_t $stride, size_t $n --> gsl_vector_complex) is native(GSLHELPER) is export(:vectorview) { * }
# Copying vectors
sub gsl_vector_complex_memcpy(gsl_vector_complex $dest, gsl_vector_complex $src --> int32) is native(&LIB) is export(:vectorcopy) { * }
sub gsl_vector_complex_swap(gsl_vector_complex $v, gsl_vector_complex $w --> int32) is native(&LIB) is export(:vectorcopy) { * }
# Exchanging elements
sub gsl_vector_complex_swap_elements(gsl_vector_complex $v, size_t $i, size_t $j --> int32) is native(&LIB) is export(:vectorelem) { * }
sub gsl_vector_complex_reverse(gsl_vector_complex $v --> int32) is native(&LIB) is export(:vectorelem) { * }
# Vector operations
sub gsl_vector_complex_add(gsl_vector_complex $a, gsl_vector_complex $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_complex_sub(gsl_vector_complex $a, gsl_vector_complex $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_complex_mul(gsl_vector_complex $a, gsl_vector_complex $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_complex_div(gsl_vector_complex $a, gsl_vector_complex $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub mgsl_vector_complex_scale(gsl_vector_complex $a, gsl_complex $x --> int32) is native(GSLHELPER) is export(:vectorop) { * }
sub mgsl_vector_complex_add_constant(gsl_vector_complex $a, gsl_complex $x --> int32) is native(GSLHELPER) is export(:vectorop) { * }
# Vector properties
sub gsl_vector_complex_isnull(gsl_vector_complex $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_complex_ispos(gsl_vector_complex $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_complex_isneg(gsl_vector_complex $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_complex_isnonneg(gsl_vector_complex $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_complex_equal(gsl_vector_complex $u, gsl_vector_complex $v --> int32) is native(&LIB) is export(:vectorprop) { * }
# Matrix allocation
sub gsl_matrix_complex_alloc(size_t $n1, size_t $n2 --> gsl_matrix_complex) is native(&LIB) is export(:matrix) { * }
sub gsl_matrix_complex_calloc(size_t $n1, size_t $n2 --> gsl_matrix_complex) is native(&LIB) is export(:matrix) { * }
sub gsl_matrix_complex_free(gsl_matrix_complex $m) is native(&LIB) is export(:matrix) { * }
# Accessing matrix elements
sub mgsl_matrix_complex_get(gsl_matrix_complex $m, size_t $i, size_t $j, gsl_complex $res) is native(GSLHELPER) is export(:matrix) { * }
sub mgsl_matrix_complex_set(gsl_matrix_complex $m, size_t $i, size_t $j, gsl_complex $x) is native(GSLHELPER) is export(:matrix) { * }
# Initializing matrix elements
sub mgsl_matrix_complex_set_all(gsl_matrix_complex $m, gsl_complex $x) is native(GSLHELPER) is export(:matrixio) { * }
sub gsl_matrix_complex_set_zero(gsl_matrix_complex $m) is native(&LIB) is export(:matrixio) { * }
sub gsl_matrix_complex_set_identity(gsl_matrix_complex $m) is native(&LIB) is export(:matrixio) { * }
# Reading and writing matrices
sub mgsl_matrix_complex_fwrite(Str $filename, gsl_matrix_complex $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_complex_fread(Str $filename, gsl_matrix_complex $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_complex_fprintf(Str $filename, gsl_matrix_complex $m, Str $format --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_complex_fscanf(Str $filename, gsl_matrix_complex $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
# Matrix views
sub alloc_gsl_matrix_complex_view(--> gsl_matrix_complex_view) is native(GSLHELPER) is export(:matrixview) { * }
sub free_gsl_matrix_complex_view(gsl_matrix_complex_view $mv) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_submatrix(gsl_matrix_complex_view $view, gsl_matrix_complex $m, size_t $k1, size_t $k2, size_t $n1, size_t $n2 --> gsl_matrix_complex) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_view_array(gsl_matrix_complex_view $view, CArray[num64] $base, size_t $n1, size_t $n2 --> gsl_matrix_complex) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_view_array_with_tda(gsl_matrix_complex_view $view, CArray[num64] $base, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix_complex) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_view_vector(gsl_matrix_complex_view $view, gsl_vector_complex $v, size_t $n1, size_t $n2 --> gsl_matrix_complex) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_view_vector_with_tda(gsl_matrix_complex_view $view, gsl_vector_complex $v, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix_complex) is native(GSLHELPER) is export(:matrixview) { * }
# Creating row and column views
sub mgsl_matrix_complex_row(gsl_vector_complex_view $view, gsl_matrix_complex $m, size_t $i --> gsl_vector_complex) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_column(gsl_vector_complex_view $view, gsl_matrix_complex $m, size_t $j --> gsl_vector_complex) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_subrow(gsl_vector_complex_view $view, gsl_matrix_complex $m, size_t $i, size_t $offset, size_t $n --> gsl_vector_complex) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_subcolumn(gsl_vector_complex_view $view, gsl_matrix_complex $m, size_t $j, size_t $offset, size_t $n --> gsl_vector_complex) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_diagonal(gsl_vector_complex_view $view, gsl_matrix_complex $m --> gsl_vector_complex) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_subdiagonal(gsl_vector_complex_view $view, gsl_matrix_complex $m, size_t $k --> gsl_vector_complex) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_complex_superdiagonal(gsl_vector_complex_view $view, gsl_matrix_complex $m, size_t $k --> gsl_vector_complex) is native(GSLHELPER) is export(:matrixview) { * }
# Copying matrices
sub gsl_matrix_complex_memcpy(gsl_matrix_complex $dest, gsl_matrix_complex $src --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_complex_swap(gsl_matrix_complex $m1, gsl_matrix_complex $m2 --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_complex_tricpy(int32 $uplo_src, int32 $copy_diag, gsl_matrix_complex $dest, gsl_matrix_complex $src --> int32) is native(&LIB) is export(:matrixcopy) { * }
# Copying rows and columns
sub gsl_matrix_complex_get_row(gsl_vector_complex $v, gsl_matrix_complex $m, size_t $i --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_complex_get_col(gsl_vector_complex $v, gsl_matrix_complex $m, size_t $j --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_complex_set_row(gsl_matrix_complex $m, size_t $i, gsl_vector_complex $v --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_complex_set_col(gsl_matrix_complex $m, size_t $j, gsl_vector_complex $v --> int32) is native(&LIB) is export(:matrixcopy) { * }
# Exchanging rows and columns
sub gsl_matrix_complex_swap_rows(gsl_matrix_complex $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_complex_swap_columns(gsl_matrix_complex $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_complex_swap_rowcol(gsl_matrix_complex $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_complex_transpose_memcpy(gsl_matrix_complex $dest, gsl_matrix_complex $src --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_complex_transpose(gsl_matrix_complex $m --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_complex_transpose_tricpy(int32 $uplo_src, int32 $copy_diag, gsl_matrix_complex $dest, gsl_matrix_complex $src --> int32) is native(&LIB) is export(:matrixexch) { * }
# Matrix operations
sub gsl_matrix_complex_add(gsl_matrix_complex $a, gsl_matrix_complex $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_complex_sub(gsl_matrix_complex $a, gsl_matrix_complex $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_complex_mul_elements(gsl_matrix_complex $a, gsl_matrix_complex $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_complex_div_elements(gsl_matrix_complex $a, gsl_matrix_complex $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_complex_scale(gsl_matrix_complex $a, num64 $x --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_complex_add_constant(gsl_matrix_complex $a, num64 $x --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_complex_add_diagonal(gsl_matrix_complex $a, num64 $x --> int32) is native(&LIB) is export(:matrixop) { * }
# Matrix properties
sub gsl_matrix_complex_isnull(gsl_matrix_complex $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_complex_ispos(gsl_matrix_complex $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_complex_isneg(gsl_matrix_complex $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_complex_isnonneg(gsl_matrix_complex $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_complex_equal(gsl_matrix_complex $a, gsl_matrix_complex $b --> int32) is native(&LIB) is export(:matrixprop) { * }
