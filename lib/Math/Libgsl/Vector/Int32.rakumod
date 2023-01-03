use v6;

unit class Math::Libgsl::Vector::Int32:ver<0.4.3>:auth<zef:FRITH>;

use Math::Libgsl::Raw::Matrix::Int32 :ALL;
use Math::Libgsl::Exception;
use Math::Libgsl::Constants;
use NativeCall;

class View {
  has gsl_vector_int_view $.view;
  submethod BUILD { $!view = alloc_gsl_vector_int_view }
  submethod DESTROY { free_gsl_vector_int_view($!view) }
  method subvector(Math::Libgsl::Vector::Int32 $v, size_t $offset where * < $v.vector.size, size_t $n --> Math::Libgsl::Vector::Int32) {
    fail X::Libgsl.new: errno => GSL_EDOM, error => "Subvector index out of bound" if $offset + $n > $v.vector.size;
    Math::Libgsl::Vector::Int32.new: vector => mgsl_vector_int_subvector($!view, $v.vector, $offset, $n);
  }
  method subvector-stride(Math::Libgsl::Vector::Int32 $v, size_t $offset where * < $v.vector.size, size_t $stride, size_t $n --> Math::Libgsl::Vector::Int32) {
    fail X::Libgsl.new: errno => GSL_EDOM, error => "Subvector index out of bound" if $offset + $n > $v.vector.size;
    Math::Libgsl::Vector::Int32.new: vector => mgsl_vector_int_subvector_with_stride($!view, $v.vector, $offset, $stride, $n);
  }
  method array($array --> Math::Libgsl::Vector::Int32) {
    Math::Libgsl::Vector::Int32.new: vector => mgsl_vector_int_view_array($!view, $array, $array.list.elems);
  }
  method array-stride($array, size_t $stride --> Math::Libgsl::Vector::Int32) {
    Math::Libgsl::Vector::Int32.new: vector => mgsl_vector_int_view_array_with_stride($!view, $array, $stride, $array.list.elems);
  }
}

has gsl_vector_int $.vector;
has Bool           $.view = False;

multi method new(Int $size!) { self.bless(:$size) }
multi method new(Int :$size!) { self.bless(:$size) }
multi method new(gsl_vector_int :$vector!) { self.bless(:$vector) }

submethod BUILD(Int :$size?, gsl_vector_int :$vector?) {
  $!vector = gsl_vector_int_calloc($size) with $size;
  with $vector {
    $!vector = $vector;
    $!view   = True;
  }
}

submethod DESTROY {
  gsl_vector_int_free($!vector) unless $!view;
}
# Accessors
method get(Int:D $index! where * < $!vector.size --> Int) { gsl_vector_int_get($!vector, $index) }
method AT-POS(Math::Libgsl::Vector::Int32:D: Int:D $index! where * < $!vector.size --> Int) {
  gsl_vector_int_get(self.vector, $index)
}
method set(Int:D $index! where * < $!vector.size, Int(Cool) $x!) { gsl_vector_int_set($!vector, $index, $x); self }
method ASSIGN-POS(Math::Libgsl::Vector::Int32:D: Int:D $index! where * < $!vector.size, Int(Cool) $x!) {
  gsl_vector_int_set(self.vector, $index, $x)
}
method setall(Int(Cool) $x!) { gsl_vector_int_set_all($!vector, $x); self }
method zero() { gsl_vector_int_set_zero($!vector); self }
method basis(Int:D $index! where * < $!vector.size) {
  my $ret = gsl_vector_int_set_basis($!vector, $index);
  X::Libgsl.new(errno => $ret, error => "Can't make a basis vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method size(--> UInt){ self.vector.size }
# IO
method write(Str $filename!) {
  my $ret = mgsl_vector_int_fwrite($filename, $!vector);
  X::Libgsl.new(errno => $ret, error => "Can't write the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method read(Str $filename!) {
  my $ret = mgsl_vector_int_fread($filename, $!vector);
  X::Libgsl.new(errno => $ret, error => "Can't read the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method printf(Str $filename!, Str $format!) {
  my $ret = mgsl_vector_int_fprintf($filename, $!vector, $format);
  X::Libgsl.new(errno => $ret, error => "Can't print the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method scanf(Str $filename!) {
  my $ret = mgsl_vector_int_fscanf($filename, $!vector);
  X::Libgsl.new(errno => $ret, error => "Can't scan the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
# View
sub int32-prepvec(*@array) is export {
  my CArray[int32] $array .= new: @array».Int;
}
sub int32-array-vec(Block $bl, *@data) is export {
  my CArray[int32] $carray .= new: @data».Int;
  my Math::Libgsl::Vector::Int32::View $vv .= new;
  my $v = $vv.array($carray);
  $bl($v);
}
sub int32-array-stride-vec(Block $bl, size_t $stride, *@data) is export {
  my CArray[int32] $carray .= new: @data».Int;
  my Math::Libgsl::Vector::Int32::View $vv .= new;
  my $v = $vv.array-stride($carray, $stride);
  $bl($v);
}
# Copy
method copy(Math::Libgsl::Vector::Int32 $src where $!vector.size == .vector.size) {
  my $ret = gsl_vector_int_memcpy($!vector, $src.vector);
  X::Libgsl.new(errno => $ret, error => "Can't copy the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method swap(Math::Libgsl::Vector::Int32 $w where $!vector.size == .vector.size) {
  my $ret = gsl_vector_int_swap($!vector, $w.vector);
  X::Libgsl.new(errno => $ret, error => "Can't swap vectors").throw if $ret ≠ GSL_SUCCESS;
  self
}
# Exchanging elements
method swap-elems(Int $i where * < $!vector.size, Int $j where * < $!vector.size) {
  my $ret = gsl_vector_int_swap_elements($!vector, $i, $j);
  X::Libgsl.new(errno => $ret, error => "Can't swap elements").throw if $ret ≠ GSL_SUCCESS;
  self
}
method reverse() {
  my $ret = gsl_vector_int_reverse($!vector);
  X::Libgsl.new(errno => $ret, error => "Can't reverse the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
# Vector operations
method add(Math::Libgsl::Vector::Int32 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_int_add($!vector, $b.vector);
  X::Libgsl.new(errno => $ret, error => "Can't add two vectors").throw if $ret ≠ GSL_SUCCESS;
  self
}
method sub(Math::Libgsl::Vector::Int32 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_int_sub($!vector, $b.vector);
  X::Libgsl.new(errno => $ret, error => "Can't sub two vectors").throw if $ret ≠ GSL_SUCCESS;
  self
}
method mul(Math::Libgsl::Vector::Int32 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_int_mul($!vector, $b.vector);
  X::Libgsl.new(errno => $ret, error => "Can't mul two vectors").throw if $ret ≠ GSL_SUCCESS;
  self
}
method div(Math::Libgsl::Vector::Int32 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_int_div($!vector, $b.vector);
  X::Libgsl.new(errno => $ret, error => "Can't div two vectors").throw if $ret ≠ GSL_SUCCESS;
  self
}
method scale(Int(Cool) $x) {
  my $ret = gsl_vector_int_scale($!vector, $x);
  X::Libgsl.new(errno => $ret, error => "Can't scale the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method add-constant(Int(Cool) $x) {
  my $ret = gsl_vector_int_add_constant($!vector, $x);
  X::Libgsl.new(errno => $ret, error => "Can't add a constant to the elements").throw if $ret ≠ GSL_SUCCESS;
  self
}
method sum(--> Int) {
  fail X::Libgsl.new: errno => GSL_FAILURE, error => "Error in sum: version < v2.7" if $gsl-version < v2.7;
  gsl_vector_int_sum($!vector)
}
method axpby(Int(Cool) $alpha, Int(Cool) $beta, Math::Libgsl::Vector::Int32 $b where $!vector.size == .vector.size) {
  X::Libgsl.new(errno => GSL_FAILURE, error => "Error in axpby: version < v2.7").throw if $gsl-version < v2.7;
  my $ret = gsl_vector_int_axpby($alpha, $!vector, $beta, $b.vector);
  X::Libgsl.new(errno => $ret, error => "Can't do axpby").throw if $ret ≠ GSL_SUCCESS;
  self
}
# Finding maximum and minimum elements of vectors
method max(--> Int) { gsl_vector_int_max($!vector) }
method min(--> Int) { gsl_vector_int_min($!vector) }
method minmax(--> List)
{
  my int32 ($min, $max);
  gsl_vector_int_minmax($!vector, $min, $max);
  return $min, $max;
}
method max-index(--> Int) { gsl_vector_int_max_index($!vector) }
method min-index(--> Int) { gsl_vector_int_min_index($!vector) }
method minmax-index(--> List)
{
  my size_t ($imin, $imax);
  gsl_vector_int_minmax_index($!vector, $imin, $imax);
  return $imin, $imax;
}
# Vector properties
method is-null(--> Bool)   { gsl_vector_int_isnull($!vector)   ?? True !! False }
method is-pos(--> Bool)    { gsl_vector_int_ispos($!vector)    ?? True !! False }
method is-neg(--> Bool)    { gsl_vector_int_isneg($!vector)    ?? True !! False }
method is-nonneg(--> Bool) { gsl_vector_int_isnonneg($!vector) ?? True !! False }
method is-equal(Math::Libgsl::Vector::Int32 $b --> Bool) { gsl_vector_int_equal($!vector, $b.vector) ?? True !! False }
