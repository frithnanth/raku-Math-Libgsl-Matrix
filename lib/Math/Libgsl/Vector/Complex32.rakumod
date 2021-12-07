use v6;

unit class Math::Libgsl::Vector::Complex32:ver<0.4.2>:auth<zef:frithnanth>;

use Math::Libgsl::Raw::Complex :ALL;
use Math::Libgsl::Raw::Matrix::Complex32 :ALL;
use Math::Libgsl::Exception;
use Math::Libgsl::Constants;
use Math::Libgsl::Vector::Num32 ();
use NativeCall;

class View {
  has gsl_vector_complex_float_view $.view;
  submethod BUILD { $!view = alloc_gsl_vector_complex_float_view }
  submethod DESTROY { free_gsl_vector_complex_float_view($!view) }
  method subvector(Math::Libgsl::Vector::Complex32 $v, size_t $offset where * < $v.vector.size, size_t $n --> Math::Libgsl::Vector::Complex32) {
  fail X::Libgsl.new: errno => GSL_EDOM, error => "Subvector index out of bound" if $offset + $n > $v.vector.size;
    Math::Libgsl::Vector::Complex32.new: vector => mgsl_vector_complex_float_subvector($!view, $v.vector, $offset, $n);
  }
  method subvector-stride(Math::Libgsl::Vector::Complex32 $v, size_t $offset where * < $v.vector.size, size_t $stride, size_t $n --> Math::Libgsl::Vector::Complex32) {
  fail X::Libgsl.new: errno => GSL_EDOM, error => "Subvector index out of bound" if $offset + $n > $v.vector.size;
    Math::Libgsl::Vector::Complex32.new: vector => mgsl_vector_complex_float_subvector_with_stride($!view, $v.vector, $offset, $stride, $n);
  }
  method real(Math::Libgsl::Vector::Complex32 $v--> Math::Libgsl::Vector::Num32) {
    Math::Libgsl::Vector::Num32.new: vector => mgsl_vector_complex_float_real($!view, $v.vector);
  }
  method imag(Math::Libgsl::Vector::Complex32 $v --> Math::Libgsl::Vector::Num32) {
    Math::Libgsl::Vector::Num32.new: vector => mgsl_vector_complex_float_imag($!view, $v.vector);
  }
  method array($array --> Math::Libgsl::Vector::Complex32) {
    Math::Libgsl::Vector::Complex32.new: vector => mgsl_vector_complex_float_view_array($!view, $array, ($array.list.elems / 2).Int);
  }
  method array-stride($array, size_t $stride --> Math::Libgsl::Vector::Complex32) {
    Math::Libgsl::Vector::Complex32.new: vector => mgsl_vector_complex_float_view_array_with_stride($!view, $array, $stride, ($array.list.elems / 2).Int);
  }
}

  has gsl_vector_complex_float $.vector;
  has Bool                     $.view = False;

  multi method new(Int $size!) { self.bless(:$size) }
  multi method new(Int :$size!) { self.bless(:$size) }
  multi method new(gsl_vector_complex_float :$vector!) { self.bless(:$vector) }

  submethod BUILD(Int :$size?, gsl_vector_complex_float :$vector?) {
    $!vector = gsl_vector_complex_float_calloc($size) with $size;
    with $vector {
      $!vector = $vector;
      $!view   = True;
  }
}

submethod DESTROY {
  gsl_vector_complex_float_free($!vector) unless $!view;
}
# Accessors
method get(Int:D $index! where * < $!vector.size --> Complex) {
  my gsl_complex_float $c = alloc_gsl_complex_float;
  mgsl_vector_complex_float_get($!vector, $index, $c);
  my Complex $nc = $c.dat[0] + i * $c.dat[1];
  free_gsl_complex_float($c);
  $nc;
}
method AT-POS(Math::Libgsl::Vector::Complex32:D: Int:D $index! where * < $!vector.size --> Complex) {
  my gsl_complex_float $c = alloc_gsl_complex_float;
  mgsl_vector_complex_float_get($!vector, $index, $c);
  my Complex $nc = $c.dat[0] + i * $c.dat[1];
  free_gsl_complex_float($c);
  $nc;
}
method set(Int:D $index! where * < $!vector.size, Complex(Cool) $x!) {
  my $c = alloc_gsl_complex_float;
  mgsl_complex_float_rect($x.re, $x.im, $c);
  mgsl_vector_complex_float_set($!vector, $index, $c);
  free_gsl_complex_float($c);
  self
}
method ASSIGN-POS(Math::Libgsl::Vector::Complex32:D: Int:D $index! where * < $!vector.size, Complex(Cool) $x!) {
  my $c = alloc_gsl_complex_float;
  mgsl_complex_float_rect($x.re, $x.im, $c);
  mgsl_vector_complex_float_set($!vector, $index, $c);
  free_gsl_complex_float($c);
}
method setall(Complex(Cool) $x!) {
  my $c = alloc_gsl_complex_float;
  mgsl_complex_float_rect($x.re, $x.im, $c);
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
method size(--> UInt){ self.vector.size }
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
sub complex32-prepvec(*@array) is export {
  my CArray[num32] $array .= new: @array».Num;
}
sub complex32-array-vec(Block $bl, *@data) is export {
  my CArray[num32] $carray .= new: @data».Num;
  my Math::Libgsl::Vector::Complex32::View $vv .= new;
  my $v = $vv.array($carray);
  $bl($v);
}
sub complex32-array-stride-vec(Block $bl, size_t $stride, *@data) is export {
  my CArray[num64] $carray .= new: @data».Num;
  my Math::Libgsl::Vector::Complex32::View $vv .= new;
  my $v = $vv.array-stride($carray, $stride);
  $bl($v);
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
method scale(Complex(Cool) $x) {
  my $c = alloc_gsl_complex_float;
  mgsl_complex_float_rect($x.re, $x.im, $c);
  my $ret = mgsl_vector_complex_float_scale($!vector, $c);
  free_gsl_complex_float($c);
  fail X::Libgsl.new: errno => $ret, error => "Can't scale the vector" if $ret ≠ GSL_SUCCESS;
  self
}
method add-constant(Complex(Cool) $x) {
  my $c = alloc_gsl_complex_float;
  mgsl_complex_float_rect($x.re, $x.im, $c);
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
