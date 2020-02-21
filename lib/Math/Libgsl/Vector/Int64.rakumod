use v6;

unit class Math::Libgsl::Vector::Int64:ver<0.0.6>:auth<cpan:FRITH>;

use Math::Libgsl::Raw::Matrix::Int64 :ALL;
use Math::Libgsl::Exception;
use Math::Libgsl::Constants;
use NativeCall;

class View {
  has gsl_vector_long_view $.view;
  submethod BUILD { $!view = alloc_gsl_vector_long_view }
  submethod DESTROY { free_gsl_vector_long_view($!view) }
}

has gsl_vector_long $.vector;
has Bool            $.view = False;

multi method new(Int $size!) { self.bless(:$size) }
multi method new(Int :$size!) { self.bless(:$size) }
multi method new(gsl_vector_long :$vector!) { self.bless(:$vector) }

submethod BUILD(Int :$size?, gsl_vector_long :$vector?) {
  $!vector = gsl_vector_long_calloc($size) with $size;
  with $vector {
    $!vector = $vector;
    $!view   = True;
  }
}

submethod DESTROY {
  gsl_vector_long_free($!vector) unless $!view;
}
# Accessors
method get(Int:D $index! where * < $!vector.size --> Int) { gsl_vector_long_get($!vector, $index) }
method AT-POS(Math::Libgsl::Vector::Int64:D: Int:D $index! where * < $!vector.size --> Int) {
  gsl_vector_long_get(self.vector, $index)
}
method set(Int:D $index! where * < $!vector.size, Int(Cool) $x!) { gsl_vector_long_set($!vector, $index, $x); self }
method ASSIGN-POS(Math::Libgsl::Vector::Int64:D: Int:D $index! where * < $!vector.size, Int(Cool) $x!) {
  gsl_vector_long_set(self.vector, $index, $x)
}
method setall(Int(Cool) $x!) { gsl_vector_long_set_all($!vector, $x); self }
method zero() { gsl_vector_long_set_zero($!vector); self }
method basis(Int:D $index! where * < $!vector.size) {
  my $ret = gsl_vector_long_set_basis($!vector, $index);
  fail X::Libgsl.new: errno => $ret, error => "Can't make a basis vector" if $ret ≠ GSL_SUCCESS;
  self
}
# IO
method write(Str $filename!) {
  my $ret = mgsl_vector_long_fwrite($filename, $!vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't write the vector" if $ret ≠ GSL_SUCCESS;
  self
}
method read(Str $filename!) {
  my $ret = mgsl_vector_long_fread($filename, $!vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't read the vector" if $ret ≠ GSL_SUCCESS;
  self
}
method printf(Str $filename!, Str $format!) {
  my $ret = mgsl_vector_long_fprintf($filename, $!vector, $format);
  fail X::Libgsl.new: errno => $ret, error => "Can't print the vector" if $ret ≠ GSL_SUCCESS;
  self
}
method scanf(Str $filename!) {
  my $ret = mgsl_vector_long_fscanf($filename, $!vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't scan the vector" if $ret ≠ GSL_SUCCESS;
  self
}
# View
method subvector(Math::Libgsl::Vector::Int64::View $vv, size_t $offset where * < $!vector.size, size_t $n) {
  fail X::Libgsl.new: errno => GSL_EDOM, error => "Subvector index out of bound" if $offset + $n > $!vector.size;
  Math::Libgsl::Vector::Int64.new: vector => mgsl_vector_long_subvector($vv.view, $!vector, $offset, $n);
}
method subvector-stride(Math::Libgsl::Vector::Int64::View $vv, size_t $offset where * < $!vector.size, size_t $stride, size_t $n) {
  fail X::Libgsl.new: errno => GSL_EDOM, error => "Subvector index out of bound" if $offset + $n > $!vector.size;
  Math::Libgsl::Vector::Int64.new: vector => mgsl_vector_long_subvector_with_stride($vv.view, $!vector, $offset, $stride, $n);
}
sub view-long-array(Math::Libgsl::Vector::Int64::View $vv, @array) is export {
  my CArray[int64] $a .= new: @array».Int;
  Math::Libgsl::Vector::Int64.new: vector => mgsl_vector_long_view_array($vv.view, $a, @array.elems);
}
sub view-long-array-stride(Math::Libgsl::Vector::Int64::View $vv, @array, size_t $stride) is export {
  my CArray[int64] $a .= new: @array».Int;
  Math::Libgsl::Vector::Int64.new: vector => mgsl_vector_long_view_array_with_stride($vv.view, $a, $stride, @array.elems);
}
# Copy
method copy(Math::Libgsl::Vector::Int64 $src where $!vector.size == .vector.size) {
  my $ret = gsl_vector_long_memcpy($!vector, $src.vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't copy the vector" if $ret ≠ GSL_SUCCESS;
  self
}
method swap(Math::Libgsl::Vector::Int64 $w where $!vector.size == .vector.size) {
  my $ret = gsl_vector_long_swap($!vector, $w.vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't swap vectors" if $ret ≠ GSL_SUCCESS;
  self
}
# Exchanging elements
method swap-elems(Int $i where * < $!vector.size, Int $j where * < $!vector.size) {
  my $ret = gsl_vector_long_swap_elements($!vector, $i, $j);
  fail X::Libgsl.new: errno => $ret, error => "Can't swap elements" if $ret ≠ GSL_SUCCESS;
  self
}
method reverse() {
  my $ret = gsl_vector_long_reverse($!vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't reverse the vector" if $ret ≠ GSL_SUCCESS;
  self
}
# Vector operations
method add(Math::Libgsl::Vector::Int64 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_long_add($!vector, $b.vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't add two vectors" if $ret ≠ GSL_SUCCESS;
  self
}
method sub(Math::Libgsl::Vector::Int64 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_long_sub($!vector, $b.vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't sub two vectors" if $ret ≠ GSL_SUCCESS;
  self
}
method mul(Math::Libgsl::Vector::Int64 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_long_mul($!vector, $b.vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't mul two vectors" if $ret ≠ GSL_SUCCESS;
  self
}
method div(Math::Libgsl::Vector::Int64 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_long_div($!vector, $b.vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't div two vectors" if $ret ≠ GSL_SUCCESS;
  self
}
method scale(Int(Cool) $x) {
  my $ret = gsl_vector_long_scale($!vector, $x);
  fail X::Libgsl.new: errno => $ret, error => "Can't scale the vector" if $ret ≠ GSL_SUCCESS;
  self
}
method add-constant(Int(Cool) $x) {
  my $ret = gsl_vector_long_add_constant($!vector, $x);
  fail X::Libgsl.new: errno => $ret, error => "Can't add a constant to the elements" if $ret ≠ GSL_SUCCESS;
  self
}
# Finding maximum and minimum elements of vectors
method max(--> Int) { gsl_vector_long_max($!vector) }
method min(--> Int) { gsl_vector_long_min($!vector) }
method minmax(--> List)
{
  my int64 ($min, $max);
  gsl_vector_long_minmax($!vector, $min, $max);
  return $min, $max;
}
method max-index(--> Int) { gsl_vector_long_max_index($!vector) }
method min-index(--> Int) { gsl_vector_long_min_index($!vector) }
method minmax-index(--> List)
{
  my size_t ($imin, $imax);
  gsl_vector_long_minmax_index($!vector, $imin, $imax);
  return $imin, $imax;
}
# Vector properties
method is-null(--> Bool)   { gsl_vector_long_isnull($!vector)   ?? True !! False }
method is-pos(--> Bool)    { gsl_vector_long_ispos($!vector)    ?? True !! False }
method is-neg(--> Bool)    { gsl_vector_long_isneg($!vector)    ?? True !! False }
method is-nonneg(--> Bool) { gsl_vector_long_isnonneg($!vector) ?? True !! False }
method is-equal(Math::Libgsl::Vector::Int64 $b --> Bool) { gsl_vector_long_equal($!vector, $b.vector) ?? True !! False }
