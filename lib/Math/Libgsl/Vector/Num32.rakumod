use v6;

unit class Math::Libgsl::Vector::Num32:ver<0.5.0>:auth<zef:FRITH>;

use Math::Libgsl::Raw::Matrix::Num32 :ALL;
use Math::Libgsl::Exception;
use Math::Libgsl::Constants;
use NativeCall;

class View {
  has gsl_vector_float_view $.view;
  submethod BUILD { $!view = alloc_gsl_vector_float_view }
  submethod DESTROY { free_gsl_vector_float_view($!view) }
  method subvector(Math::Libgsl::Vector::Num32 $v, size_t $offset where * < $v.vector.size, size_t $n --> Math::Libgsl::Vector::Num32) {
    fail X::Libgsl.new: errno => GSL_EDOM, error => "Subvector index out of bound" if $offset + $n > $v.vector.size;
    Math::Libgsl::Vector::Num32.new: vector => mgsl_vector_float_subvector($!view, $v.vector, $offset, $n);
  }
  method subvector-stride(Math::Libgsl::Vector::Num32 $v, size_t $offset where * < $v.vector.size, size_t $stride, size_t $n --> Math::Libgsl::Vector::Num32) {
    fail X::Libgsl.new: errno => GSL_EDOM, error => "Subvector index out of bound" if $offset + $n > $v.vector.size;
    Math::Libgsl::Vector::Num32.new: vector => mgsl_vector_float_subvector_with_stride($!view, $v.vector, $offset, $stride, $n);
  }
  method array($array --> Math::Libgsl::Vector::Num32) {
    Math::Libgsl::Vector::Num32.new: vector => mgsl_vector_float_view_array($!view, $array, $array.list.elems);
  }
  method array-stride($array, size_t $stride --> Math::Libgsl::Vector::Num32) {
    Math::Libgsl::Vector::Num32.new: vector => mgsl_vector_float_view_array_with_stride($!view, $array, $stride, $array.list.elems);
  }
}

has gsl_vector_float $.vector;
has Bool             $.view = False;

multi method new(Int $size!) { self.bless(:$size) }
multi method new(Int :$size!) { self.bless(:$size) }
multi method new(gsl_vector_float :$vector!) { self.bless(:$vector) }

submethod BUILD(Int :$size?, gsl_vector_float :$vector?) {
  $!vector = gsl_vector_float_calloc($size) with $size;
  with $vector {
    $!vector = $vector;
    $!view   = True;
  }
}

submethod DESTROY {
  gsl_vector_float_free($!vector) unless $!view;
}
# Accessors
method get(Int:D $index! where * < $!vector.size --> Num) { gsl_vector_float_get($!vector, $index) }
method AT-POS(Math::Libgsl::Vector::Num32:D: Int:D $index! where * < $!vector.size --> Num) {
  gsl_vector_float_get(self.vector, $index)
}
method set(Int:D $index! where * < $!vector.size, Num(Cool) $x!) { gsl_vector_float_set($!vector, $index, $x); self }
method ASSIGN-POS(Math::Libgsl::Vector::Num32:D: Int:D $index! where * < $!vector.size, Num(Cool) $x!) {
  gsl_vector_float_set(self.vector, $index, $x)
}
method setall(Num(Cool) $x!) { gsl_vector_float_set_all($!vector, $x); self }
method zero() { gsl_vector_float_set_zero($!vector); self }
method basis(Int:D $index! where * < $!vector.size) {
  my $ret = gsl_vector_float_set_basis($!vector, $index);
  X::Libgsl.new(errno => $ret, error => "Can't make a basis vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method size(--> UInt){ self.vector.size }
# IO
method write(Str $filename!) {
  my $ret = mgsl_vector_float_fwrite($filename, $!vector);
  X::Libgsl.new(errno => $ret, error => "Can't write the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method read(Str $filename!) {
  my $ret = mgsl_vector_float_fread($filename, $!vector);
  X::Libgsl.new(errno => $ret, error => "Can't read the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method printf(Str $filename!, Str $format!) {
  my $ret = mgsl_vector_float_fprintf($filename, $!vector, $format);
  X::Libgsl.new(errno => $ret, error => "Can't print the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method scanf(Str $filename!) {
  my $ret = mgsl_vector_float_fscanf($filename, $!vector);
  X::Libgsl.new(errno => $ret, error => "Can't scan the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
# View
sub num32-prepvec(*@array) is export {
  my CArray[num32] $array .= new: @array».Num;
}
sub num32-array-vec(Block $bl, *@data) is export {
  my CArray[num32] $carray .= new: @data».Num;
  my Math::Libgsl::Vector::Num32::View $vv .= new;
  my $v = $vv.array($carray);
  $bl($v);
}
sub num32-array-stride-vec(Block $bl, size_t $stride, *@data) is export {
  my CArray[num64] $carray .= new: @data».Num;
  my Math::Libgsl::Vector::Num32::View $vv .= new;
  my $v = $vv.array-stride($carray, $stride);
  $bl($v);
}
# Copy
method copy(Math::Libgsl::Vector::Num32 $src where $!vector.size == .vector.size) {
  my $ret = gsl_vector_float_memcpy($!vector, $src.vector);
  X::Libgsl.new(errno => $ret, error => "Can't copy the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method swap(Math::Libgsl::Vector::Num32 $w where $!vector.size == .vector.size) {
  my $ret = gsl_vector_float_swap($!vector, $w.vector);
  X::Libgsl.new(errno => $ret, error => "Can't swap vectors").throw if $ret ≠ GSL_SUCCESS;
  self
}
# Exchanging elements
method swap-elems(Int $i where * < $!vector.size, Int $j where * < $!vector.size) {
  my $ret = gsl_vector_float_swap_elements($!vector, $i, $j);
  X::Libgsl.new(errno => $ret, error => "Can't swap elements").throw if $ret ≠ GSL_SUCCESS;
  self
}
method reverse() {
  my $ret = gsl_vector_float_reverse($!vector);
  X::Libgsl.new(errno => $ret, error => "Can't reverse the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
# Vector operations
method add(Math::Libgsl::Vector::Num32 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_float_add($!vector, $b.vector);
  X::Libgsl.new(errno => $ret, error => "Can't add two vectors").throw if $ret ≠ GSL_SUCCESS;
  self
}
method sub(Math::Libgsl::Vector::Num32 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_float_sub($!vector, $b.vector);
  X::Libgsl.new(errno => $ret, error => "Can't sub two vectors").throw if $ret ≠ GSL_SUCCESS;
  self
}
method mul(Math::Libgsl::Vector::Num32 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_float_mul($!vector, $b.vector);
  X::Libgsl.new(errno => $ret, error => "Can't mul two vectors").throw if $ret ≠ GSL_SUCCESS;
  self
}
method div(Math::Libgsl::Vector::Num32 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_float_div($!vector, $b.vector);
  X::Libgsl.new(errno => $ret, error => "Can't div two vectors").throw if $ret ≠ GSL_SUCCESS;
  self
}
method scale(Num(Cool) $x) {
  my $ret = gsl_vector_float_scale($!vector, $x);
  X::Libgsl.new(errno => $ret, error => "Can't scale the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method sum(--> Num) {
  fail X::Libgsl.new: errno => GSL_FAILURE, error => "Error in sum: version < v2.7" if $gsl-version < v2.7;
  gsl_vector_float_sum($!vector)
}
method axpby(Num(Cool) $alpha, Num(Cool) $beta, Math::Libgsl::Vector::Num32 $b where $!vector.size == .vector.size) {
  X::Libgsl.new(errno => GSL_FAILURE, error => "Error in axpby: version < v2.7").throw if $gsl-version < v2.7;
  my $ret = gsl_vector_float_axpby($alpha, $!vector, $beta, $b.vector);
  X::Libgsl.new(errno => $ret, error => "Can't do axpby").throw if $ret ≠ GSL_SUCCESS;
  self
}
method add-constant(Num(Cool) $x) {
  my $ret = gsl_vector_float_add_constant($!vector, $x);
  X::Libgsl.new(errno => $ret, error => "Can't add a constant to the elements").throw if $ret ≠ GSL_SUCCESS;
  self
}
# Finding maximum and minimum elements of vectors
method max(--> Num) { gsl_vector_float_max($!vector) }
method min(--> Num) { gsl_vector_float_min($!vector) }
method minmax(--> List)
{
  my num32 ($min, $max);
  gsl_vector_float_minmax($!vector, $min, $max);
  return $min, $max;
}
method max-index(--> Int) { gsl_vector_float_max_index($!vector) }
method min-index(--> Int) { gsl_vector_float_min_index($!vector) }
method minmax-index(--> List)
{
  my size_t ($imin, $imax);
  gsl_vector_float_minmax_index($!vector, $imin, $imax);
  return $imin, $imax;
}
# Vector properties
method is-null(--> Bool)   { gsl_vector_float_isnull($!vector)   ?? True !! False }
method is-pos(--> Bool)    { gsl_vector_float_ispos($!vector)    ?? True !! False }
method is-neg(--> Bool)    { gsl_vector_float_isneg($!vector)    ?? True !! False }
method is-nonneg(--> Bool) { gsl_vector_float_isnonneg($!vector) ?? True !! False }
method is-equal(Math::Libgsl::Vector::Num32 $b --> Bool) { gsl_vector_float_equal($!vector, $b.vector) ?? True !! False }
