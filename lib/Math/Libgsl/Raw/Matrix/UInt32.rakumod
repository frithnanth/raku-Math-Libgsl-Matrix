use v6;

unit module Math::Libgsl::Raw::Matrix::UInt32:ver<0.3.3>:auth<cpan:FRITH>;

use NativeCall;

constant GSLHELPER = %?RESOURCES<libraries/gslhelper>.absolute;

sub LIB {
  run('/sbin/ldconfig', '-p', :chomp, :out).out.slurp(:close).split("\n").grep(/^ \s+ libgsl\.so\. \d+ /).sort.head.comb(/\S+/).head;
}

class gsl_block_uint is repr('CStruct') is export {
  has size_t          $.size;
  has Pointer[uint32] $.data;
}

class gsl_vector_uint is repr('CStruct') is export {
  has size_t          $.size;
  has size_t          $.stride;
  has Pointer[uint32] $.data;
  has gsl_block_uint  $.block;
  has int32           $.owner;
}

class gsl_vector_uint_view is repr('CStruct') is export {
  HAS gsl_vector_uint      $.vector;
}

class gsl_matrix_uint is repr('CStruct') is export {
  has size_t          $.size1;
  has size_t          $.size2;
  has size_t          $.tda;
  has Pointer[uint32] $.data;
  has gsl_block_uint  $.block;
  has int32           $.owner;
}

class gsl_matrix_uint_view is repr('CStruct') is export {
  HAS gsl_matrix_uint      $.matrix;
}

# Block allocation
sub gsl_block_uint_alloc(size_t $n --> gsl_block_uint) is native(&LIB) is export(:block) { * }
sub gsl_block_uint_calloc(size_t $n --> gsl_block_uint) is native(&LIB) is export(:block) { * }
sub gsl_block_uint_free(gsl_block_uint $b) is native(&LIB) is export(:block) { * }
# Reading and writing blocks
sub mgsl_block_uint_fwrite(Str $filename, gsl_block_uint $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_uint_fread(Str $filename, gsl_block_uint $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_uint_fprintf(Str $filename, gsl_block_uint $b, Str $format --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_uint_fscanf(Str $filename, gsl_block_uint $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
# Vector allocation
sub gsl_vector_uint_alloc(size_t $n --> gsl_vector_uint) is native(&LIB) is export(:vector) { * }
sub gsl_vector_uint_calloc(size_t $n --> gsl_vector_uint) is native(&LIB) is export(:vector) { * }
sub gsl_vector_uint_free(gsl_vector_uint $v) is native(&LIB) is export(:vector) { * }
# Accessing vector elements
sub gsl_vector_uint_get(gsl_vector_uint $v, size_t $i --> uint32) is native(&LIB) is export(:vector) { * }
sub gsl_vector_uint_set(gsl_vector_uint $v, size_t $i, uint32 $x) is native(&LIB) is export(:vector) { * }
# Initializing vector elements
sub gsl_vector_uint_set_all(gsl_vector_uint $v, uint32 $x) is native(&LIB) is export(:vectorio) { * }
sub gsl_vector_uint_set_zero(gsl_vector_uint $v) is native(&LIB) is export(:vectorio) { * }
sub gsl_vector_uint_set_basis(gsl_vector_uint $v, size_t $i --> int32) is native(&LIB) is export(:vectorio) { * }
# Reading and writing vectors
sub mgsl_vector_uint_fwrite(Str $filename, gsl_vector_uint $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_uint_fread(Str $filename, gsl_vector_uint $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_uint_fprintf(Str $filename, gsl_vector_uint $v, Str $format --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_uint_fscanf(Str $filename, gsl_vector_uint $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
# Vector views
sub alloc_gsl_vector_uint_view(--> gsl_vector_uint_view) is native(GSLHELPER) is export(:vectorview) { * }
sub free_gsl_vector_uint_view(gsl_vector_uint_view $vv) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_uint_subvector(gsl_vector_uint_view $view, gsl_vector_uint $v, size_t $offset, size_t $n --> gsl_vector_uint) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_uint_subvector_with_stride(gsl_vector_uint_view $view, gsl_vector_uint $v, size_t $offset, size_t $stride, size_t $n --> gsl_vector_uint) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_uint_view_array(gsl_vector_uint_view $view, CArray[uint32] $base, size_t $n --> gsl_vector_uint) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_uint_view_array_with_stride(gsl_vector_uint_view $view, CArray[uint32] $base, size_t $stride, size_t $n --> gsl_vector_uint) is native(GSLHELPER) is export(:vectorview) { * }
# Copying vectors
sub gsl_vector_uint_memcpy(gsl_vector_uint $dest, gsl_vector_uint $src --> int32) is native(&LIB) is export(:vectorcopy) { * }
sub gsl_vector_uint_swap(gsl_vector_uint $v, gsl_vector_uint $w --> int32) is native(&LIB) is export(:vectorcopy) { * }
# Exchanging elements
sub gsl_vector_uint_swap_elements(gsl_vector_uint $v, size_t $i, size_t $j --> int32) is native(&LIB) is export(:vectorelem) { * }
sub gsl_vector_uint_reverse(gsl_vector_uint $v --> int32) is native(&LIB) is export(:vectorelem) { * }
# Vector operations
sub gsl_vector_uint_add(gsl_vector_uint $a, gsl_vector_uint $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_uint_sub(gsl_vector_uint $a, gsl_vector_uint $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_uint_mul(gsl_vector_uint $a, gsl_vector_uint $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_uint_div(gsl_vector_uint $a, gsl_vector_uint $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_uint_scale(gsl_vector_uint $a, num64 $x --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_uint_add_constant(gsl_vector_uint $a, num64 $x --> int32) is native(&LIB) is export(:vectorop) { * }
# Finding maximum and minimum elements of vectors
sub gsl_vector_uint_max(gsl_vector_uint $v --> uint32) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_uint_min(gsl_vector_uint $v --> uint32) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_uint_minmax(gsl_vector_uint $v, uint32 $min_out is rw, uint32 $max_out is rw) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_uint_max_index(gsl_vector_uint $v --> size_t) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_uint_min_index(gsl_vector_uint $v --> size_t) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_uint_minmax_index(gsl_vector_uint $v, size_t $imin is rw, size_t $imax is rw) is native(&LIB) is export(:vectorminmax) { * }
# Vector properties
sub gsl_vector_uint_isnull(gsl_vector_uint $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_uint_ispos(gsl_vector_uint $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_uint_isneg(gsl_vector_uint $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_uint_isnonneg(gsl_vector_uint $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_uint_equal(gsl_vector_uint $u, gsl_vector_uint $v --> int32) is native(&LIB) is export(:vectorprop) { * }
# Matrix allocation
sub gsl_matrix_uint_alloc(size_t $n1, size_t $n2 --> gsl_matrix_uint) is native(&LIB) is export(:matrix) { * }
sub gsl_matrix_uint_calloc(size_t $n1, size_t $n2 --> gsl_matrix_uint) is native(&LIB) is export(:matrix) { * }
sub gsl_matrix_uint_free(gsl_matrix_uint $m) is native(&LIB) is export(:matrix) { * }
# Accessing matrix elements
sub gsl_matrix_uint_get(gsl_matrix_uint $m, size_t $i, size_t $j --> uint32) is native(&LIB) is export(:matrix) { * }
sub gsl_matrix_uint_set(gsl_matrix_uint $m, size_t $i, size_t $j, uint32 $x) is native(&LIB) is export(:matrix) { * }
# Initializing matrix elements
sub gsl_matrix_uint_set_all(gsl_matrix_uint $m, uint32 $x) is native(&LIB) is export(:matrixio) { * }
sub gsl_matrix_uint_set_zero(gsl_matrix_uint $m) is native(&LIB) is export(:matrixio) { * }
sub gsl_matrix_uint_set_identity(gsl_matrix_uint $m) is native(&LIB) is export(:matrixio) { * }
# Reading and writing matrices
sub mgsl_matrix_uint_fwrite(Str $filename, gsl_matrix_uint $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_uint_fread(Str $filename, gsl_matrix_uint $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_uint_fprintf(Str $filename, gsl_matrix_uint $m, Str $format --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_uint_fscanf(Str $filename, gsl_matrix_uint $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
# Matrix views
sub alloc_gsl_matrix_uint_view(--> gsl_matrix_uint_view) is native(GSLHELPER) is export(:matrixview) { * }
sub free_gsl_matrix_uint_view(gsl_matrix_uint_view $mv) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uint_submatrix(gsl_matrix_uint_view $view, gsl_matrix_uint $m, size_t $k1, size_t $k2, size_t $n1, size_t $n2 --> gsl_matrix_uint) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uint_view_array(gsl_matrix_uint_view $view, CArray[uint32] $base, size_t $n1, size_t $n2 --> gsl_matrix_uint) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uint_view_array_with_tda(gsl_matrix_uint_view $view, CArray[uint32] $base, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix_uint) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uint_view_vector(gsl_matrix_uint_view $view, gsl_vector_uint $v, size_t $n1, size_t $n2 --> gsl_matrix_uint) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uint_view_vector_with_tda(gsl_matrix_uint_view $view, gsl_vector_uint $v, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix_uint) is native(GSLHELPER) is export(:matrixview) { * }
# Creating row and column views
sub mgsl_matrix_uint_row(gsl_vector_uint_view $view, gsl_matrix_uint $m, size_t $i --> gsl_vector_uint) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uint_column(gsl_vector_uint_view $view, gsl_matrix_uint $m, size_t $j --> gsl_vector_uint) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uint_subrow(gsl_vector_uint_view $view, gsl_matrix_uint $m, size_t $i, size_t $offset, size_t $n --> gsl_vector_uint) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uint_subcolumn(gsl_vector_uint_view $view, gsl_matrix_uint $m, size_t $j, size_t $offset, size_t $n --> gsl_vector_uint) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uint_diagonal(gsl_vector_uint_view $view, gsl_matrix_uint $m --> gsl_vector_uint) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uint_subdiagonal(gsl_vector_uint_view $view, gsl_matrix_uint $m, size_t $k --> gsl_vector_uint) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_uint_superdiagonal(gsl_vector_uint_view $view, gsl_matrix_uint $m, size_t $k --> gsl_vector_uint) is native(GSLHELPER) is export(:matrixview) { * }
# Copying matrices
sub gsl_matrix_uint_memcpy(gsl_matrix_uint $dest, gsl_matrix_uint $src --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_uint_swap(gsl_matrix_uint $m1, gsl_matrix_uint $m2 --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_uint_tricpy(int32 $uplo_src, int32 $copy_diag, gsl_matrix_uint $dest, gsl_matrix_uint $src --> int32) is native(&LIB) is export(:matrixcopy) { * }
# Copying rows and columns
sub gsl_matrix_uint_get_row(gsl_vector_uint $v, gsl_matrix_uint $m, size_t $i --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_uint_get_col(gsl_vector_uint $v, gsl_matrix_uint $m, size_t $j --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_uint_set_row(gsl_matrix_uint $m, size_t $i, gsl_vector_uint $v --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_uint_set_col(gsl_matrix_uint $m, size_t $j, gsl_vector_uint $v --> int32) is native(&LIB) is export(:matrixcopy) { * }
# Exchanging rows and columns
sub gsl_matrix_uint_swap_rows(gsl_matrix_uint $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_uint_swap_columns(gsl_matrix_uint $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_uint_swap_rowcol(gsl_matrix_uint $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_uint_transpose_memcpy(gsl_matrix_uint $dest, gsl_matrix_uint $src --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_uint_transpose(gsl_matrix_uint $m --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_uint_transpose_tricpy(int32 $uplo_src, int32 $copy_diag, gsl_matrix_uint $dest, gsl_matrix_uint $src --> int32) is native(&LIB) is export(:matrixexch) { * }
# Matrix operations
sub gsl_matrix_uint_add(gsl_matrix_uint $a, gsl_matrix_uint $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_uint_sub(gsl_matrix_uint $a, gsl_matrix_uint $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_uint_mul_elements(gsl_matrix_uint $a, gsl_matrix_uint $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_uint_div_elements(gsl_matrix_uint $a, gsl_matrix_uint $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_uint_scale(gsl_matrix_uint $a, num64 $x --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_uint_add_constant(gsl_matrix_uint $a, num64 $x --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_uint_add_diagonal(gsl_matrix_uint $a, num64 $x --> int32) is native(&LIB) is export(:matrixop) { * }
# Finding maximum and minimum elements of matrices
sub gsl_matrix_uint_max(gsl_matrix_uint $m --> uint32) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_uint_min(gsl_matrix_uint $m --> uint32) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_uint_minmax(gsl_matrix_uint $m, uint32 $min_out is rw, uint32 $max_out is rw) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_uint_max_index(gsl_matrix_uint $m, size_t $imax is rw, size_t $jmax is rw) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_uint_min_index(gsl_matrix_uint $m, size_t $imin is rw, size_t $jmin is rw) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_uint_minmax_index(gsl_matrix_uint $m, size_t $imin is rw, size_t $jmin is rw, size_t $imax is rw, size_t $jmax is rw) is native(&LIB) is export(:matrixminmax) { * }
# Matrix properties
sub gsl_matrix_uint_isnull(gsl_matrix_uint $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_uint_ispos(gsl_matrix_uint $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_uint_isneg(gsl_matrix_uint $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_uint_isnonneg(gsl_matrix_uint $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_uint_equal(gsl_matrix_uint $a, gsl_matrix_uint $b --> int32) is native(&LIB) is export(:matrixprop) { * }
