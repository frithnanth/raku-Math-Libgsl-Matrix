use v6;

unit module Math::Libgsl::Raw::Matrix::Int8:ver<0.2.0>:auth<cpan:FRITH>;

use NativeCall;

constant GSLHELPER = %?RESOURCES<libraries/gslhelper>.absolute;

sub LIB {
  run('/sbin/ldconfig', '-p', :chomp, :out).out.slurp(:close).split("\n").grep(/^ \s+ libgsl\.so\. \d+ /).sort.head.comb(/\S+/).head;
}

class gsl_block_char is repr('CStruct') is export {
  has size_t          $.size;
  has Pointer[int8]   $.data;
}

class gsl_vector_char is repr('CStruct') is export {
  has size_t          $.size;
  has size_t          $.stride;
  has Pointer[int8]   $.data;
  has gsl_block_char  $.block;
  has int32           $.owner;
}

class gsl_vector_char_view is repr('CStruct') is export {
  HAS gsl_vector_char      $.vector;
}

class gsl_matrix_char is repr('CStruct') is export {
  has size_t          $.size1;
  has size_t          $.size2;
  has size_t          $.tda;
  has Pointer[int8]   $.data;
  has gsl_block_char  $.block;
  has int32           $.owner;
}

class gsl_matrix_char_view is repr('CStruct') is export {
  HAS gsl_matrix_char      $.matrix;
}

# Block allocation
sub gsl_block_char_alloc(size_t $n --> gsl_block_char) is native(&LIB) is export(:block) { * }
sub gsl_block_char_calloc(size_t $n --> gsl_block_char) is native(&LIB) is export(:block) { * }
sub gsl_block_char_free(gsl_block_char $b) is native(&LIB) is export(:block) { * }
# Reading and writing blocks
sub mgsl_block_char_fwrite(Str $filename, gsl_block_char $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_char_fread(Str $filename, gsl_block_char $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_char_fprintf(Str $filename, gsl_block_char $b, Str $format --> int32) is native(GSLHELPER) is export(:blockio) { * }
sub mgsl_block_char_fscanf(Str $filename, gsl_block_char $b --> int32) is native(GSLHELPER) is export(:blockio) { * }
# Vector allocation
sub gsl_vector_char_alloc(size_t $n --> gsl_vector_char) is native(&LIB) is export(:vector) { * }
sub gsl_vector_char_calloc(size_t $n --> gsl_vector_char) is native(&LIB) is export(:vector) { * }
sub gsl_vector_char_free(gsl_vector_char $v) is native(&LIB) is export(:vector) { * }
# Accessing vector elements
sub gsl_vector_char_get(gsl_vector_char $v, size_t $i --> int8) is native(&LIB) is export(:vector) { * }
sub gsl_vector_char_set(gsl_vector_char $v, size_t $i, int8 $x) is native(&LIB) is export(:vector) { * }
# Initializing vector elements
sub gsl_vector_char_set_all(gsl_vector_char $v, int8 $x) is native(&LIB) is export(:vectorio) { * }
sub gsl_vector_char_set_zero(gsl_vector_char $v) is native(&LIB) is export(:vectorio) { * }
sub gsl_vector_char_set_basis(gsl_vector_char $v, size_t $i --> int32) is native(&LIB) is export(:vectorio) { * }
# Reading and writing vectors
sub mgsl_vector_char_fwrite(Str $filename, gsl_vector_char $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_char_fread(Str $filename, gsl_vector_char $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_char_fprintf(Str $filename, gsl_vector_char $v, Str $format --> int32) is native(GSLHELPER) is export(:vectorio) { * }
sub mgsl_vector_char_fscanf(Str $filename, gsl_vector_char $v --> int32) is native(GSLHELPER) is export(:vectorio) { * }
# Vector views
sub alloc_gsl_vector_char_view(--> gsl_vector_char_view) is native(GSLHELPER) is export(:vectorview) { * }
sub free_gsl_vector_char_view(gsl_vector_char_view $vv) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_char_subvector(gsl_vector_char_view $view, gsl_vector_char $v, size_t $offset, size_t $n --> gsl_vector_char) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_char_subvector_with_stride(gsl_vector_char_view $view, gsl_vector_char $v, size_t $offset, size_t $stride, size_t $n --> gsl_vector_char) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_char_view_array(gsl_vector_char_view $view, CArray[int8] $base, size_t $n --> gsl_vector_char) is native(GSLHELPER) is export(:vectorview) { * }
sub mgsl_vector_char_view_array_with_stride(gsl_vector_char_view $view, CArray[int8] $base, size_t $stride, size_t $n --> gsl_vector_char) is native(GSLHELPER) is export(:vectorview) { * }
# Copying vectors
sub gsl_vector_char_memcpy(gsl_vector_char $dest, gsl_vector_char $src --> int32) is native(&LIB) is export(:vectorcopy) { * }
sub gsl_vector_char_swap(gsl_vector_char $v, gsl_vector_char $w --> int32) is native(&LIB) is export(:vectorcopy) { * }
# Exchanging elements
sub gsl_vector_char_swap_elements(gsl_vector_char $v, size_t $i, size_t $j --> int32) is native(&LIB) is export(:vectorelem) { * }
sub gsl_vector_char_reverse(gsl_vector_char $v --> int32) is native(&LIB) is export(:vectorelem) { * }
# Vector operations
sub gsl_vector_char_add(gsl_vector_char $a, gsl_vector_char $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_char_sub(gsl_vector_char $a, gsl_vector_char $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_char_mul(gsl_vector_char $a, gsl_vector_char $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_char_div(gsl_vector_char $a, gsl_vector_char $b --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_char_scale(gsl_vector_char $a, num64 $x --> int32) is native(&LIB) is export(:vectorop) { * }
sub gsl_vector_char_add_constant(gsl_vector_char $a, num64 $x --> int32) is native(&LIB) is export(:vectorop) { * }
# Finding maximum and minimum elements of vectors
sub gsl_vector_char_max(gsl_vector_char $v --> int8) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_char_min(gsl_vector_char $v --> int8) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_char_minmax(gsl_vector_char $v, int8 $min_out is rw, int8 $max_out is rw) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_char_max_index(gsl_vector_char $v --> size_t) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_char_min_index(gsl_vector_char $v --> size_t) is native(&LIB) is export(:vectorminmax) { * }
sub gsl_vector_char_minmax_index(gsl_vector_char $v, size_t $imin is rw, size_t $imax is rw) is native(&LIB) is export(:vectorminmax) { * }
# Vector properties
sub gsl_vector_char_isnull(gsl_vector_char $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_char_ispos(gsl_vector_char $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_char_isneg(gsl_vector_char $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_char_isnonneg(gsl_vector_char $v --> int32) is native(&LIB) is export(:vectorprop) { * }
sub gsl_vector_char_equal(gsl_vector_char $u, gsl_vector_char $v --> int32) is native(&LIB) is export(:vectorprop) { * }
# Matrix allocation
sub gsl_matrix_char_alloc(size_t $n1, size_t $n2 --> gsl_matrix_char) is native(&LIB) is export(:matrix) { * }
sub gsl_matrix_char_calloc(size_t $n1, size_t $n2 --> gsl_matrix_char) is native(&LIB) is export(:matrix) { * }
sub gsl_matrix_char_free(gsl_matrix_char $m) is native(&LIB) is export(:matrix) { * }
# Accessing matrix elements
sub gsl_matrix_char_get(gsl_matrix_char $m, size_t $i, size_t $j --> int8) is native(&LIB) is export(:matrix) { * }
sub gsl_matrix_char_set(gsl_matrix_char $m, size_t $i, size_t $j, int8 $x) is native(&LIB) is export(:matrix) { * }
# Initializing matrix elements
sub gsl_matrix_char_set_all(gsl_matrix_char $m, int8 $x) is native(&LIB) is export(:matrixio) { * }
sub gsl_matrix_char_set_zero(gsl_matrix_char $m) is native(&LIB) is export(:matrixio) { * }
sub gsl_matrix_char_set_identity(gsl_matrix_char $m) is native(&LIB) is export(:matrixio) { * }
# Reading and writing matrices
sub mgsl_matrix_char_fwrite(Str $filename, gsl_matrix_char $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_char_fread(Str $filename, gsl_matrix_char $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_char_fprintf(Str $filename, gsl_matrix_char $m, Str $format --> int32) is native(GSLHELPER) is export(:matrixio) { * }
sub mgsl_matrix_char_fscanf(Str $filename, gsl_matrix_char $m --> int32) is native(GSLHELPER) is export(:matrixio) { * }
# Matrix views
sub alloc_gsl_matrix_char_view(--> gsl_matrix_char_view) is native(GSLHELPER) is export(:matrixview) { * }
sub free_gsl_matrix_char_view(gsl_matrix_char_view $mv) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_char_submatrix(gsl_matrix_char_view $view, gsl_matrix_char $m, size_t $k1, size_t $k2, size_t $n1, size_t $n2 --> gsl_matrix_char) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_char_view_array(gsl_matrix_char_view $view, CArray[int8] $base, size_t $n1, size_t $n2 --> gsl_matrix_char) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_char_view_array_with_tda(gsl_matrix_char_view $view, CArray[int8] $base, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix_char) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_char_view_vector(gsl_matrix_char_view $view, gsl_vector_char $v, size_t $n1, size_t $n2 --> gsl_matrix_char) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_char_view_vector_with_tda(gsl_matrix_char_view $view, gsl_vector_char $v, size_t $n1, size_t $n2, size_t $tda --> gsl_matrix_char) is native(GSLHELPER) is export(:matrixview) { * }
# Creating row and column views
sub mgsl_matrix_char_row(gsl_vector_char_view $view, gsl_matrix_char $m, size_t $i --> gsl_vector_char) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_char_column(gsl_vector_char_view $view, gsl_matrix_char $m, size_t $j --> gsl_vector_char) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_char_subrow(gsl_vector_char_view $view, gsl_matrix_char $m, size_t $i, size_t $offset, size_t $n --> gsl_vector_char) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_char_subcolumn(gsl_vector_char_view $view, gsl_matrix_char $m, size_t $j, size_t $offset, size_t $n --> gsl_vector_char) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_char_diagonal(gsl_vector_char_view $view, gsl_matrix_char $m --> gsl_vector_char) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_char_subdiagonal(gsl_vector_char_view $view, gsl_matrix_char $m, size_t $k --> gsl_vector_char) is native(GSLHELPER) is export(:matrixview) { * }
sub mgsl_matrix_char_superdiagonal(gsl_vector_char_view $view, gsl_matrix_char $m, size_t $k --> gsl_vector_char) is native(GSLHELPER) is export(:matrixview) { * }
# Copying matrices
sub gsl_matrix_char_memcpy(gsl_matrix_char $dest, gsl_matrix_char $src --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_char_swap(gsl_matrix_char $m1, gsl_matrix_char $m2 --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_char_tricpy(int32 $uplo_src, int32 $copy_diag, gsl_matrix_char $dest, gsl_matrix_char $src --> int32) is native(&LIB) is export(:matrixcopy) { * }
# Copying rows and columns
sub gsl_matrix_char_get_row(gsl_vector_char $v, gsl_matrix_char $m, size_t $i --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_char_get_col(gsl_vector_char $v, gsl_matrix_char $m, size_t $j --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_char_set_row(gsl_matrix_char $m, size_t $i, gsl_vector_char $v --> int32) is native(&LIB) is export(:matrixcopy) { * }
sub gsl_matrix_char_set_col(gsl_matrix_char $m, size_t $j, gsl_vector_char $v --> int32) is native(&LIB) is export(:matrixcopy) { * }
# Exchanging rows and columns
sub gsl_matrix_char_swap_rows(gsl_matrix_char $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_char_swap_columns(gsl_matrix_char $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_char_swap_rowcol(gsl_matrix_char $m, size_t $i, size_t $j --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_char_transpose_memcpy(gsl_matrix_char $dest, gsl_matrix_char $src --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_char_transpose(gsl_matrix_char $m --> int32) is native(&LIB) is export(:matrixexch) { * }
sub gsl_matrix_char_transpose_tricpy(int32 $uplo_src, int32 $copy_diag, gsl_matrix_char $dest, gsl_matrix_char $src --> int32) is native(&LIB) is export(:matrixexch) { * }
# Matrix operations
sub gsl_matrix_char_add(gsl_matrix_char $a, gsl_matrix_char $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_char_sub(gsl_matrix_char $a, gsl_matrix_char $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_char_mul_elements(gsl_matrix_char $a, gsl_matrix_char $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_char_div_elements(gsl_matrix_char $a, gsl_matrix_char $b --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_char_scale(gsl_matrix_char $a, num64 $x --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_char_add_constant(gsl_matrix_char $a, num64 $x --> int32) is native(&LIB) is export(:matrixop) { * }
sub gsl_matrix_char_add_diagonal(gsl_matrix_char $a, num64 $x --> int32) is native(&LIB) is export(:matrixop) { * }
# Finding maximum and minimum elements of matrices
sub gsl_matrix_char_max(gsl_matrix_char $m --> int8) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_char_min(gsl_matrix_char $m --> int8) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_char_minmax(gsl_matrix_char $m, int8 $min_out is rw, int8 $max_out is rw) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_char_max_index(gsl_matrix_char $m, size_t $imax is rw, size_t $jmax is rw) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_char_min_index(gsl_matrix_char $m, size_t $imin is rw, size_t $jmin is rw) is native(&LIB) is export(:matrixminmax) { * }
sub gsl_matrix_char_minmax_index(gsl_matrix_char $m, size_t $imin is rw, size_t $jmin is rw, size_t $imax is rw, size_t $jmax is rw) is native(&LIB) is export(:matrixminmax) { * }
# Matrix properties
sub gsl_matrix_char_isnull(gsl_matrix_char $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_char_ispos(gsl_matrix_char $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_char_isneg(gsl_matrix_char $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_char_isnonneg(gsl_matrix_char $m --> int32) is native(&LIB) is export(:matrixprop) { * }
sub gsl_matrix_char_equal(gsl_matrix_char $a, gsl_matrix_char $b --> int32) is native(&LIB) is export(:matrixprop) { * }
