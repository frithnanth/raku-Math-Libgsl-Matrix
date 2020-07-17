use v6;

unit module Math::Libgsl::Raw::Matrix::UInt8:ver<0.1.4>:auth<cpan:FRITH>;

use NativeCall;

constant GSLHELPER = %?RESOURCES<libraries/gslhelper>.absolute;

sub LIB {
  run('/sbin/ldconfig', '-p', :chomp, :out).out.slurp(:close).split("\n").grep(/^ \s+ libgsl\.so\. \d+ /).sort.head.comb(/\S+/).head;
}

class gsl_block_uchar is repr('CStruct') is export {
  has size_t          $.size;
  has Pointer[uint8]  $.data;
}

class gsl_vector_uchar is repr('CStruct') is export {
  has size_t          $.size;
  has size_t          $.stride;
  has Pointer[uint8]  $.data;
  has gsl_block_uchar $.block;
  has int32           $.owner;
}

class gsl_vector_uchar_view is repr('CStruct') is export {
  HAS gsl_vector_uchar      $.vector;
}

class gsl_matrix_uchar is repr('CStruct') is export {
  has size_t          $.size1;
  has size_t          $.size2;
  has size_t          $.tda;
  has Pointer[uint8]  $.data;
  has gsl_block_uchar $.block;
  has int32           $.owner;
}

class gsl_matrix_uchar_view is repr('CStruct') is export {
  HAS gsl_matrix_uchar      $.matrix;
}

# Block allocation
sub gsl_block_uchar_alloc(size_t $n --> gsl_block_uchar) is native(&LIB) is export(:block) { * }
sub gsl_block_uchar_calloc(size_t $n --> gsl_block_uchar) is native(&LIB) is export(:block) { * }
sub gsl_block_uchar_free(gsl_block_uchar $b) is native(&LIB) is export(:block) { * }
# Reading and writing blocks
sub mgsl_block_uchar_fwrite(Str $filename, gsl_block_uchar $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_uchar_fread(Str $filename, gsl_block_uchar $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_uchar_fprintf(Str $filename, gsl_block_uchar $b, Str $format --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_uchar_fscanf(Str $filename, gsl_block_uchar $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
# Vector allocation
sub gsl_vector_uchar_alloc(size_t $n --> gsl_vector_uchar) is native(&LIB) is export(:vector) { * }
sub gsl_vector_uchar_calloc(size_t $n --> gsl_vector_uchar) is native(&LIB) is export(:vector) { * }
sub gsl_vector_uchar_free(gsl_vector_uchar $v) is native(&LIB) is export(:vector) { * }
# Accessing vector elements
sub gsl_vector_uchar_get(gsl_vector_uchar $v, size_t $i --> uint8) is native(&LIB) is export(:vector) { * }
sub gsl_vector_uchar_set(gsl_vector_uchar $v, size_t $i, uint8 $x) is native(&LIB) is export(:vector) { * }
# Initializing vector elements
sub gsl_vector_uchar_set_all(gsl_vector_uchar $v, uint8 $x) is native(&LIB) is export(:vectorio) { * }
sub gsl_vector_uchar_set_zero(gsl_vector_uchar $v) is native(&LIB) is export(:vectorio) { * }
sub gsl_vector_uchar_set_basis(gsl_vector_uchar $v, size_t $i --> int32) is native(&LIB) is export(:vectorio) { * }
# Reading and writing vectors
sub mgsl_vector_uchar_fwrite(Str $filename, gsl_vector_uchar $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_uchar_fread(Str $filename, gsl_vector_uchar $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_uchar_fprintf(Str $filename, gsl_vector_uchar $v, Str $format --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_uchar_fscanf(Str $filename, gsl_vector_uchar $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
# Vector views
sub alloc_gsl_vector_uchar_view(--> gsl_vector_uchar_view) is native(GSLHELPER) is export(:vectorview) { * }
sub free_gsl_vector_uchar_view(gsl_vector_uchar_view $vv) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_uchar_subvector(gsl_vector_uchar_view $view, gsl_vector_uchar $v, size_t $offset, size_t $n --> gsl_vector_uchar) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_uchar_subvector_with_stride(gsl_vector_uchar_view $view, gsl_vector_uchar $v, size_t $offset, size_t $stride, size_t $n --> gsl_vector_uchar) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_uchar_view_array(gsl_vector_uchar_view $view, CArray[uint8] $base, size_t $n --> gsl_vector_uchar) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_uchar_view_array_with_stride(gsl_vector_uchar_view $view, CArray[uint8] $base, size_t $stride, size_t $n --> gsl_vector_uchar) is native(GSLHELPER) is export(:vectorview) { * }
# Copying vectors
sub gsl_vector_uchar_memcpy(gsl_vector_uchar $dest, gsl_vector_uchar $src --> int32) is native(&LIB) is export(:vectorcopy) { * }
sub gsl_vector_uchar_swap(gsl_vector_uchar $v, gsl_vector_uchar $w --> int32) is native(&LIB) is export(:vectorcopy) { * }
# Exchanging elements
sub gsl_vector_uchar_swap_elements(gsl_vector_uchar $v, size_t $i, size_t $j --> int32) is native(&LIB) is export(:vectorelem) { * }
sub gsl_vector_uchar_reverse(gsl_vector_uchar $v --> int32) is native(&LIB) is export(:vectorelem) { * }
# Vector operations
sub gsl_vector_uchar_add(gsl_vector_uchar $a, gsl_vector_uchar $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_uchar_sub(gsl_vector_uchar $a, gsl_vector_uchar $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_uchar_mul(gsl_vector_uchar $a, gsl_vector_uchar $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_uchar_div(gsl_vector_uchar $a, gsl_vector_uchar $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_uchar_scale(gsl_vector_uchar $a, num64 $x --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_uchar_add_constant(gsl_vector_uchar $a, num64 $x --> int32) is native(&LIB) is export(:vectorop) { * }
# Finding maximum and minimum elements of vectors
sub gsl_vector_uchar_max(gsl_vector_uchar $v --> uint8) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_uchar_min(gsl_vector_uchar $v --> uint8) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_uchar_minmax(gsl_vector_uchar $v, uint8 $min_out is rw, uint8 $max_out is rw) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_uchar_max_index(gsl_vector_uchar $v --> size_t) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_uchar_min_index(gsl_vector_uchar $v --> size_t) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_uchar_minmax_index(gsl_vector_uchar $v, size_t $imin is rw, size_t $imax is rw) is native(&LIB) is export(:vectorminmax) { * }
# Vector properties
sub gsl_vector_uchar_isnull(gsl_vector_uchar $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_uchar_ispos(gsl_vector_uchar $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_uchar_isneg(gsl_vector_uchar $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_uchar_isnonneg(gsl_vector_uchar $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_uchar_equal(gsl_vector_uchar $u, gsl_vector_uchar $v --> int32) is native(&LIB) is export(:vectorprop) { * }
# Matrix allocation
sub gsl_matrix_uchar_alloc(size_t $n1, size_t $n2 --> gsl_matrix_uchar) is native(&LIB) is export(:matrix) { * }
sub gsl_matrix_uchar_calloc(size_t $n1, size_t $n2 --> gsl_matrix_uchar) is native(&LIB) is export(:matrix) { * }
sub gsl_matrix_uchar_free(gsl_matrix_uchar $m) is native(&LIB) is export(:matrix) { * }
# Accessing matrix elements
sub gsl_matrix_uchar_get(gsl_matrix_uchar $m, size_t $i, size_t $j --> uint8) is native(&LIB) is export(:matrix) { * }
sub gsl_matrix_uchar_set(gsl_matrix_uchar $m, size_t $i, size_t $j, uint8 $x) is native(&LIB) is export(:matrix) { * }
# Initializing matrix elements
sub gsl_matrix_uchar_set_all(gsl_matrix_uchar $m, uint8 $x) is native(&LIB) is export(:matrixio) { * }
sub gsl_matrix_uchar_set_zero(gsl_matrix_uchar $m) is native(&LIB) is export(:matrixio) { * }
sub gsl_matrix_uchar_set_identity(gsl_matrix_uchar $m) is native(&LIB) is export(:matrixio) { * }
# Reading and writing matrices
sub mgsl_matrix_uchar_fwrite(Str $filename, gsl_matrix_uchar $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_uchar_fread(Str $filename, gsl_matrix_uchar $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_uchar_fprintf(Str $filename, gsl_matrix_uchar $m, Str $format --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_uchar_fscanf(Str $filename, gsl_matrix_uchar $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
# Matrix views
sub alloc_gsl_matrix_uchar_view(--> gsl_matrix_uchar_view) is native(GSLHELPER) is export(:matrixview) { * }
sub free_gsl_matrix_uchar_view(gsl_matrix_uchar_view $mv) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uchar_submatrix(gsl_matrix_uchar_view $view, gsl_matrix_uchar $m, size_t $k1, size_t $k2, size_t $n1, size_t $n2 --> gsl_matrix_uchar) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uchar_view_array(gsl_matrix_uchar_view $view, CArray[uint8] $base, size_t $n1, size_t $n2 --> gsl_matrix_uchar) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uchar_view_array_with_tda(gsl_matrix_uchar_view $view, CArray[uint8] $base, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix_uchar) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uchar_view_vector(gsl_matrix_uchar_view $view, gsl_vector_uchar $v, size_t $n1, size_t $n2 --> gsl_matrix_uchar) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uchar_view_vector_with_tda(gsl_matrix_uchar_view $view, gsl_vector_uchar $v, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix_uchar) is native(GSLHELPER) is export(:matrixview) { * }
# Creating row and column views
sub mgsl_matrix_uchar_row(gsl_vector_uchar_view $view, gsl_matrix_uchar $m, size_t $i --> gsl_vector_uchar) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uchar_column(gsl_vector_uchar_view $view, gsl_matrix_uchar $m, size_t $j --> gsl_vector_uchar) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uchar_subrow(gsl_vector_uchar_view $view, gsl_matrix_uchar $m, size_t $i, size_t $offset, size_t $n --> gsl_vector_uchar) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uchar_subcolumn(gsl_vector_uchar_view $view, gsl_matrix_uchar $m, size_t $j, size_t $offset, size_t $n --> gsl_vector_uchar) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uchar_diagonal(gsl_vector_uchar_view $view, gsl_matrix_uchar $m --> gsl_vector_uchar) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uchar_subdiagonal(gsl_vector_uchar_view $view, gsl_matrix_uchar $m, size_t $k --> gsl_vector_uchar) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uchar_superdiagonal(gsl_vector_uchar_view $view, gsl_matrix_uchar $m, size_t $k --> gsl_vector_uchar) is native(GSLHELPER) is export(:matrixview) { * }
# Copying matrices
sub gsl_matrix_uchar_memcpy(gsl_matrix_uchar $dest, gsl_matrix_uchar $src --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_uchar_swap(gsl_matrix_uchar $m1, gsl_matrix_uchar $m2 --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_uchar_tricpy(int32 $uplo_src, int32 $copy_diag, gsl_matrix_uchar $dest, gsl_matrix_uchar $src --> int32) is native(&LIB) is export(:matrixcopy) { * }
# Copying rows and columns
sub gsl_matrix_uchar_get_row(gsl_vector_uchar $v, gsl_matrix_uchar $m, size_t $i --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_uchar_get_col(gsl_vector_uchar $v, gsl_matrix_uchar $m, size_t $j --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_uchar_set_row(gsl_matrix_uchar $m, size_t $i, gsl_vector_uchar $v --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_uchar_set_col(gsl_matrix_uchar $m, size_t $j, gsl_vector_uchar $v --> int32) is native(&LIB) is export(:matrixcopy) { * }
# Exchanging rows and columns
sub gsl_matrix_uchar_swap_rows(gsl_matrix_uchar $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_uchar_swap_columns(gsl_matrix_uchar $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_uchar_swap_rowcol(gsl_matrix_uchar $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_uchar_transpose_memcpy(gsl_matrix_uchar $dest, gsl_matrix_uchar $src --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_uchar_transpose(gsl_matrix_uchar $m --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_uchar_transpose_tricpy(int32 $uplo_src, int32 $copy_diag, gsl_matrix_uchar $dest, gsl_matrix_uchar $src --> int32) is native(&LIB) is export(:matrixexch) { * }
# Matrix operations
sub gsl_matrix_uchar_add(gsl_matrix_uchar $a, gsl_matrix_uchar $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_uchar_sub(gsl_matrix_uchar $a, gsl_matrix_uchar $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_uchar_mul_elements(gsl_matrix_uchar $a, gsl_matrix_uchar $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_uchar_div_elements(gsl_matrix_uchar $a, gsl_matrix_uchar $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_uchar_scale(gsl_matrix_uchar $a, num64 $x --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_uchar_add_constant(gsl_matrix_uchar $a, num64 $x --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_uchar_add_diagonal(gsl_matrix_uchar $a, num64 $x --> int32) is native(&LIB) is export(:matrixop) { * }
# Finding maximum and minimum elements of matrices
sub gsl_matrix_uchar_max(gsl_matrix_uchar $m --> uint8) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_uchar_min(gsl_matrix_uchar $m --> uint8) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_uchar_minmax(gsl_matrix_uchar $m, uint8 $min_out is rw, uint8 $max_out is rw) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_uchar_max_index(gsl_matrix_uchar $m, size_t $imax is rw, size_t $jmax is rw) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_uchar_min_index(gsl_matrix_uchar $m, size_t $imin is rw, size_t $jmin is rw) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_uchar_minmax_index(gsl_matrix_uchar $m, size_t $imin is rw, size_t $jmin is rw, size_t $imax is rw, size_t $jmax is rw) is native(&LIB) is export(:matrixminmax) { * }
# Matrix properties
sub gsl_matrix_uchar_isnull(gsl_matrix_uchar $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_uchar_ispos(gsl_matrix_uchar $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_uchar_isneg(gsl_matrix_uchar $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_uchar_isnonneg(gsl_matrix_uchar $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_uchar_equal(gsl_matrix_uchar $a, gsl_matrix_uchar $b --> int32) is native(&LIB) is export(:matrixprop) { * }
