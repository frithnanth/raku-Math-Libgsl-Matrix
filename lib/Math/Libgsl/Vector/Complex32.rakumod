use v6;

unit class Math::Libgsl::Vector::Complex32:ver<0.0.2>:auth<cpan:FRITH>;

use Math::Libgsl::Raw::Complex :ALL;
use Math::Libgsl::Raw::Matrix::Complex32 :ALL;
use Math::Libgsl::Exception;
use Math::Libgsl::Constants;
use Math::Libgsl::Vector::Num32;
use NativeCall;

class VView {
  has gsl_vector_complex_float_view $.view;
  submethod BUILD { $!view = alloc_gsl_vector_complex_float_view }
  submethod DESTROY { free_gsl_vector_complex_float_view($!view) }
}

has gsl_vector_complex_float $.vector;

multi method new(Int $size!) { self.bless(:$size) }
multi method new(Int :$size!) { self.bless(:$size) }
multi method new(gsl_vector_complex_float :$vector!) { self.bless(:$vector) }

submethod BUILD(Int :$size?, gsl_vector_complex_float :$vector?) {
  $!vector = gsl_vector_complex_float_calloc($size) with $size;
  $!vector = $vector with $vector;
}

submethod DESTROY {
  gsl_vector_complex_float_free($!vector);
}
# Accessors
method get(Int:D $index! where * < $!vector.size --> Complex) {
  my gsl_complex_float $c = alloc_gsl_complex_float;
  mgsl_vector_complex_float_get($!vector, $index, $c);
  my Complex $nc = $c.dat[0] + i * $c.dat[1];
  free_gsl_complex_float($c);
  $nc;
}
multi method AT-POS(Math::Libgsl::Vector::Complex32:D: Int:D $index! where * < $!vector.size --> Complex) {
  my gsl_complex_float $c = alloc_gsl_complex_float;
  mgsl_vector_complex_float_get($!vector, $index, $c);
  my Complex $nc = $c.dat[0] + i * $c.dat[1];
  free_gsl_complex_float($c);
  $nc;
}
multi method AT-POS(Math::Libgsl::Vector::Complex32:D: Range:D $range! where { .max < $!vector.size && .min ≥ 0 } --> List) {
  my Complex @cv;
  for $range {
    my $c = alloc_gsl_complex_float;
    mgsl_vector_complex_float_get($!vector, $_, $c);
    my Complex $nc = $c.dat[0] + i * $c.dat[1];
    @cv.push: $nc;
    free_gsl_complex_float($c);
  }
  @cv;
}
method set(Int:D $index! where * < $!vector.size, Num(Cool) $x!) {
  my $c = alloc_gsl_complex_float;
  mgsl_complex_rect($x.re, $x.im, $c);
  mgsl_vector_complex_float_set($!vector, $index, $c);
  free_gsl_complex_float($c);
  self
}
method ASSIGN-POS(Math::Libgsl::Vector::Complex32:D: Int:D $index! where * < $!vector.size, Num(Cool) $x!) {
  my $c = alloc_gsl_complex_float;
  mgsl_complex_rect($x.re, $x.im, $c);
  mgsl_vector_complex_float_set($!vector, $index, $c);
  free_gsl_complex_float($c);
}
method setall(Complex(Cool) $x!) {
  my $c = alloc_gsl_complex_float;
  #mgsl_complex_float_rect($x.re, $x.im, $c); # doesn't exist!
  $c.dat[0] = $x.re;
  $c.dat[1] = $x.im;
  mgsl_vector_complex_float_set_all($!vector, $c);
  free_gsl_complex_float($c);
  self
}
method zero() { gsl_vector_complex_float_set_zero($!vector); self }
method basis(Int:D $index! where * < $!vector.size) {
  my $ret = gsl_vector_complex_float_set_basis($!vector, $index);
  fail X::Libgsl.new: errno => $ret, error => "Can't make a basis vector" if $ret ≠ GSL_SUCCESS;
  self
}
# IO
method write(Str $filename!) {
  my $ret = mgsl_vector_complex_float_fwrite($filename, $!vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't write the vector" if $ret ≠ GSL_SUCCESS;
  self
}
method read(Str $filename!) {
  my $ret = mgsl_vector_complex_float_fread($filename, $!vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't read the vector" if $ret ≠ GSL_SUCCESS;
  self
}
method printf(Str $filename!, Str $format!) {
  my $ret = mgsl_vector_complex_float_fprintf($filename, $!vector, $format);
  fail X::Libgsl.new: errno => $ret, error => "Can't print the vector" if $ret ≠ GSL_SUCCESS;
  self
}
method scanf(Str $filename!) {
  my $ret = mgsl_vector_complex_float_fscanf($filename, $!vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't scan the vector" if $ret ≠ GSL_SUCCESS;
  self
}
# View
method subvector(size_t $offset where * < $!vector.size, size_t $n) {
fail X::Libgsl.new: errno => GSL_EDOM, error => "Subvector index out of bound" if $offset + $n > $!vector.size;
  my Math::Libgsl::Vector::Complex32::VView $vv .= new;
  Math::Libgsl::Vector::Complex32.new: vector => mgsl_vector_complex_float_subvector($vv.view, $!vector, $offset, $n);
}
method subvector-stride(size_t $offset where * < $!vector.size, size_t $stride, size_t $n) {
fail X::Libgsl.new: errno => GSL_EDOM, error => "Subvector index out of bound" if $offset + $n > $!vector.size;
  my Math::Libgsl::Vector::Complex32::VView $vv .= new;
  Math::Libgsl::Vector::Complex32.new: vector => mgsl_vector_complex_float_subvector_with_stride($vv.view, $!vector, $offset, $stride, $n);
}
sub view-complex32-array(@array) is export {
  my Math::Libgsl::Vector::Complex32::VView $vv .= new;
  my CArray[num32] $a .= new: @array».Num;
  Math::Libgsl::Vector::Complex32.new: vector => mgsl_vector_complex_float_view_array($vv.view, $a, @array.elems);
}
sub view-complex32-array-stride(@array, size_t $stride) is export {
  my Math::Libgsl::Vector::Complex32::VView $vv .= new;
  my CArray[num32] $a .= new: @array».Num;
  Math::Libgsl::Vector::Complex32.new: vector => mgsl_vector_complex_float_view_array_with_stride($vv.view, $a, $stride, @array.elems);
}
method complex32-real() {
  my Math::Libgsl::Vector::Num32::VView $vv .= new;
  Math::Libgsl::Vector::Num32.new: vector => mgsl_vector_complex_float_real($vv.view, $!vector);
}
method complex32-imag() {
  my Math::Libgsl::Vector::Num32::VView $vv .= new;
  Math::Libgsl::Vector::Num32.new: vector => mgsl_vector_complex_float_imag($vv.view, $!vector);
}
# Copy
method copy(Math::Libgsl::Vector::Complex32 $src where $!vector.size == .vector.size) {
  my $ret = gsl_vector_complex_float_memcpy($!vector, $src.vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't copy the vector" if $ret ≠ GSL_SUCCESS;
  self
}
method swap(Math::Libgsl::Vector::Complex32 $w where $!vector.size == .vector.size) {
  my $ret = gsl_vector_complex_float_swap($!vector, $w.vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't swap vectors" if $ret ≠ GSL_SUCCESS;
  self
}
# Exchanging elements
method swap-elems(Int $i where * < $!vector.size, Int $j where * < $!vector.size) {
  my $ret = gsl_vector_complex_float_swap_elements($!vector, $i, $j);
  fail X::Libgsl.new: errno => $ret, error => "Can't swap elements" if $ret ≠ GSL_SUCCESS;
  self
}
method reverse() {
  my $ret = gsl_vector_complex_float_reverse($!vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't reverse the vector" if $ret ≠ GSL_SUCCESS;
  self
}
# Vector operations
method add(Math::Libgsl::Vector::Complex32 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_complex_float_add($!vector, $b.vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't add two vectors" if $ret ≠ GSL_SUCCESS;
  self
}
method sub(Math::Libgsl::Vector::Complex32 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_complex_float_sub($!vector, $b.vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't sub two vectors" if $ret ≠ GSL_SUCCESS;
  self
}
method mul(Math::Libgsl::Vector::Complex32 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_complex_float_mul($!vector, $b.vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't mul two vectors" if $ret ≠ GSL_SUCCESS;
  self
}
method div(Math::Libgsl::Vector::Complex32 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_complex_float_div($!vector, $b.vector);
  fail X::Libgsl.new: errno => $ret, error => "Can't div two vectors" if $ret ≠ GSL_SUCCESS;
  self
}
method scale(Num(Cool) $x) {
  my $c = alloc_gsl_complex_float;
  #mgsl_complex_float_rect($x.re, $x.im, $c); # doesn't exist!
  $c.dat[0] = $x.re;
  $c.dat[1] = $x.im;
  my $ret = mgsl_vector_complex_float_scale($!vector, $c);
  free_gsl_complex_float($c);
  fail X::Libgsl.new: errno => $ret, error => "Can't scale the vector" if $ret ≠ GSL_SUCCESS;
  self
}
method add-constant(Num(Cool) $x) {
  my $c = alloc_gsl_complex_float;
  #mgsl_complex_float_rect($x.re, $x.im, $c); # doesn't exist!
  $c.dat[0] = $x.re;
  $c.dat[1] = $x.im;
  my $ret = mgsl_vector_complex_float_add_constant($!vector, $c);
  free_gsl_complex_float($c);
  fail X::Libgsl.new: errno => $ret, error => "Can't add a constant to all elements" if $ret ≠ GSL_SUCCESS;
  self
}
# Vector properties
method is-null(--> Bool)   { gsl_vector_complex_float_isnull($!vector)   ?? True !! False }
method is-pos(--> Bool)    { gsl_vector_complex_float_ispos($!vector)    ?? True !! False }
method is-neg(--> Bool)    { gsl_vector_complex_float_isneg($!vector)    ?? True !! False }
method is-nonneg(--> Bool) { gsl_vector_complex_float_isnonneg($!vector) ?? True !! False }
method is-equal(Math::Libgsl::Vector::Complex32 $b --> Bool) { gsl_vector_complex_float_equal($!vector, $b.vector) ?? True !! False }
