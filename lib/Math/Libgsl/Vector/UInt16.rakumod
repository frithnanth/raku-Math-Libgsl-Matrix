use v6;

unit class Math::Libgsl::Vector::UInt16:ver<0.5.0>:auth<zef:FRITH>;

use Math::Libgsl::Raw::Matrix::UInt16 :ALL;
use Math::Libgsl::Exception;
use Math::Libgsl::Constants;
use NativeCall;

class View {
  has gsl_vector_ushort_view $.view;
  submethod BUILD { $!view = alloc_gsl_vector_ushort_view }
  submethod DESTROY { free_gsl_vector_ushort_view($!view) }
  method subvector(Math::Libgsl::Vector::UInt16 $v, size_t $offset where * < $v.vector.size, size_t $n --> Math::Libgsl::Vector::UInt16) {
    fail X::Libgsl.new: errno => GSL_EDOM, error => "Subvector index out of bound" if $offset + $n > $v.vector.size;
    Math::Libgsl::Vector::UInt16.new: vector => mgsl_vector_ushort_subvector($!view, $v.vector, $offset, $n);
  }
  method subvector-stride(Math::Libgsl::Vector::UInt16 $v, size_t $offset where * < $v.vector.size, size_t $stride, size_t $n --> Math::Libgsl::Vector::UInt16) {
    fail X::Libgsl.new: errno => GSL_EDOM, error => "Subvector index out of bound" if $offset + $n > $v.vector.size;
    Math::Libgsl::Vector::UInt16.new: vector => mgsl_vector_ushort_subvector_with_stride($!view, $v.vector, $offset, $stride, $n);
  }
  method array($array --> Math::Libgsl::Vector::UInt16) {
    Math::Libgsl::Vector::UInt16.new: vector => mgsl_vector_ushort_view_array($!view, $array, $array.list.elems);
  }
  method array-stride($array, size_t $stride --> Math::Libgsl::Vector::UInt16) {
    Math::Libgsl::Vector::UInt16.new: vector => mgsl_vector_ushort_view_array_with_stride($!view, $array, $stride, $array.list.elems);
  }
}

has gsl_vector_ushort $.vector;
has Bool              $.view = False;

multi method new(Int $size!) { self.bless(:$size) }
multi method new(Int :$size!) { self.bless(:$size) }
multi method new(gsl_vector_ushort :$vector!) { self.bless(:$vector) }

submethod BUILD(Int :$size?, gsl_vector_ushort :$vector?) {
  $!vector = gsl_vector_ushort_calloc($size) with $size;
  with $vector {
    $!vector = $vector;
    $!view   = True;
  }
}

submethod DESTROY {
  gsl_vector_ushort_free($!vector) unless $!view;
}

multi method list(Math::Libgsl::Vector::UInt16: --> List) { (^$!vector.size).map({ gsl_vector_ushort_get($!vector, $_) }).List }
multi method gist(Math::Libgsl::Vector::UInt16: --> Str) {
  my ($size, $ellip);
  if $!vector.size > 100 {
    $size = 100;
    $ellip = ' ...';
  } else {
    $size = $!vector.size;
    $ellip = '';
  }
  '(' ~ (^$size).map({ gsl_vector_ushort_get($!vector, $_) }).Str ~ "$ellip)";
}
multi method Str(Math::Libgsl::Vector::UInt16: --> Str) { self.list.join(' ') }

# Accessors
method get(Int:D $index! where * < $!vector.size --> Int) { gsl_vector_ushort_get($!vector, $index) }
method AT-POS(Math::Libgsl::Vector::UInt16:D: Int:D $index! where * < $!vector.size --> Int) {
  gsl_vector_ushort_get(self.vector, $index)
}
method set(Int:D $index! where * < $!vector.size, Int(Cool) $x!) { gsl_vector_ushort_set($!vector, $index, $x); self }
method ASSIGN-POS(Math::Libgsl::Vector::UInt16:D: Int:D $index! where * < $!vector.size, Int(Cool) $x!) {
  gsl_vector_ushort_set(self.vector, $index, $x)
}
method setall(Int(Cool) $x!) { gsl_vector_ushort_set_all($!vector, $x); self }
method zero() { gsl_vector_ushort_set_zero($!vector); self }
method basis(Int:D $index! where * < $!vector.size) {
  my $ret = gsl_vector_ushort_set_basis($!vector, $index);
  X::Libgsl.new(errno => $ret, error => "Can't make a basis vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method size(--> UInt){ self.vector.size }
# IO
method write(Str $filename!) {
  my $ret = mgsl_vector_ushort_fwrite($filename, $!vector);
  X::Libgsl.new(errno => $ret, error => "Can't write the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method read(Str $filename!) {
  my $ret = mgsl_vector_ushort_fread($filename, $!vector);
  X::Libgsl.new(errno => $ret, error => "Can't read the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method printf(Str $filename!, Str $format!) {
  my $ret = mgsl_vector_ushort_fprintf($filename, $!vector, $format);
  X::Libgsl.new(errno => $ret, error => "Can't print the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method scanf(Str $filename!) {
  my $ret = mgsl_vector_ushort_fscanf($filename, $!vector);
  X::Libgsl.new(errno => $ret, error => "Can't scan the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
# View
sub uint16-prepvec(*@array) is export {
  my CArray[uint16] $array .= new: @array».Int;
}
sub uint16-array-vec(Block $bl, *@data) is export {
  my CArray[uint16] $carray .= new: @data».Int;
  my Math::Libgsl::Vector::UInt16::View $vv .= new;
  my $v = $vv.array($carray);
  $bl($v);
}
sub uint16-array-stride-vec(Block $bl, size_t $stride, *@data) is export {
  my CArray[uint16] $carray .= new: @data».Int;
  my Math::Libgsl::Vector::UInt16::View $vv .= new;
  my $v = $vv.array-stride($carray, $stride);
  $bl($v);
}
# Copy
method copy(Math::Libgsl::Vector::UInt16 $src where $!vector.size == .vector.size) {
  my $ret = gsl_vector_ushort_memcpy($!vector, $src.vector);
  X::Libgsl.new(errno => $ret, error => "Can't copy the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method swap(Math::Libgsl::Vector::UInt16 $w where $!vector.size == .vector.size) {
  my $ret = gsl_vector_ushort_swap($!vector, $w.vector);
  X::Libgsl.new(errno => $ret, error => "Can't swap vectors").throw if $ret ≠ GSL_SUCCESS;
  self
}
# Exchanging elements
method swap-elems(Int $i where * < $!vector.size, Int $j where * < $!vector.size) {
  my $ret = gsl_vector_ushort_swap_elements($!vector, $i, $j);
  X::Libgsl.new(errno => $ret, error => "Can't swap elements").throw if $ret ≠ GSL_SUCCESS;
  self
}
method reverse() {
  my $ret = gsl_vector_ushort_reverse($!vector);
  X::Libgsl.new(errno => $ret, error => "Can't reverse the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
# Vector operations
method add(Math::Libgsl::Vector::UInt16 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_ushort_add($!vector, $b.vector);
  X::Libgsl.new(errno => $ret, error => "Can't add two vectors").throw if $ret ≠ GSL_SUCCESS;
  self
}
method sub(Math::Libgsl::Vector::UInt16 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_ushort_sub($!vector, $b.vector);
  X::Libgsl.new(errno => $ret, error => "Can't sub two vectors").throw if $ret ≠ GSL_SUCCESS;
  self
}
method mul(Math::Libgsl::Vector::UInt16 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_ushort_mul($!vector, $b.vector);
  X::Libgsl.new(errno => $ret, error => "Can't mul two vectors").throw if $ret ≠ GSL_SUCCESS;
  self
}
method div(Math::Libgsl::Vector::UInt16 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_ushort_div($!vector, $b.vector);
  X::Libgsl.new(errno => $ret, error => "Can't div two vectors").throw if $ret ≠ GSL_SUCCESS;
  self
}
method scale(Int(Cool) $x) {
  my $ret = gsl_vector_ushort_scale($!vector, $x);
  X::Libgsl.new(errno => $ret, error => "Can't scale the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method add-constant(Int(Cool) $x) {
  my $ret = gsl_vector_ushort_add_constant($!vector, $x);
  X::Libgsl.new(errno => $ret, error => "Can't add a constant to the elements").throw if $ret ≠ GSL_SUCCESS;
  self
}
method sum(--> UInt) {
  fail X::Libgsl.new: errno => GSL_FAILURE, error => "Error in sum: version < v2.7" if $gsl-version < v2.7;
  gsl_vector_ushort_sum($!vector)
}
method axpby(UInt(Cool) $alpha, UInt(Cool) $beta, Math::Libgsl::Vector::UInt16 $b where $!vector.size == .vector.size) {
  X::Libgsl.new(errno => GSL_FAILURE, error => "Error in axpby: version < v2.7").throw if $gsl-version < v2.7;
  my $ret = gsl_vector_ushort_axpby($alpha, $!vector, $beta, $b.vector);
  X::Libgsl.new(errno => $ret, error => "Can't do axpby").throw if $ret ≠ GSL_SUCCESS;
  self
}
# Finding maximum and minimum elements of vectors
method max(--> UInt) { gsl_vector_ushort_max($!vector) }
method min(--> UInt) { gsl_vector_ushort_min($!vector) }
method minmax(--> List)
{
  my uint16 ($min, $max);
  gsl_vector_ushort_minmax($!vector, $min, $max);
  return $min, $max;
}
method max-index(--> Int) { gsl_vector_ushort_max_index($!vector) }
method min-index(--> Int) { gsl_vector_ushort_min_index($!vector) }
method minmax-index(--> List)
{
  my size_t ($imin, $imax);
  gsl_vector_ushort_minmax_index($!vector, $imin, $imax);
  return $imin, $imax;
}
# Vector properties
method is-null(--> Bool)   { gsl_vector_ushort_isnull($!vector)   ?? True !! False }
method is-pos(--> Bool)    { gsl_vector_ushort_ispos($!vector)    ?? True !! False }
method is-neg(--> Bool)    { gsl_vector_ushort_isneg($!vector)    ?? True !! False }
method is-nonneg(--> Bool) { gsl_vector_ushort_isnonneg($!vector) ?? True !! False }
method is-equal(Math::Libgsl::Vector::UInt16 $b --> Bool) { gsl_vector_ushort_equal($!vector, $b.vector) ?? True !! False }
