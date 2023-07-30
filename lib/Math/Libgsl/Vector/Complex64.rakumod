use v6;

unit class Math::Libgsl::Vector::Complex64:ver<0.6.0>:auth<zef:FRITH>;

use Math::Libgsl::Raw::Complex :ALL;
use Math::Libgsl::Raw::Matrix::Complex64 :ALL;
use Math::Libgsl::Exception;
use Math::Libgsl::Constants;
use Math::Libgsl::Vector ();
use NativeCall;

class View {
  has gsl_vector_complex_view $.view;
  submethod BUILD { $!view = alloc_gsl_vector_complex_view }
  submethod DESTROY { free_gsl_vector_complex_view($!view) }
  method subvector(Math::Libgsl::Vector::Complex64 $v, size_t $offset where * < $v.vector.size, size_t $n --> Math::Libgsl::Vector::Complex64) {
  fail X::Libgsl.new: errno => GSL_EDOM, error => "Subvector index out of bound" if $offset + $n > $v.vector.size;
    Math::Libgsl::Vector::Complex64.new: vector => mgsl_vector_complex_subvector($!view, $v.vector, $offset, $n);
  }
  method subvector-stride(Math::Libgsl::Vector::Complex64 $v, size_t $offset where * < $v.vector.size, size_t $stride, size_t $n --> Math::Libgsl::Vector::Complex64) {
  fail X::Libgsl.new: errno => GSL_EDOM, error => "Subvector index out of bound" if $offset + $n > $v.vector.size;
    Math::Libgsl::Vector::Complex64.new: vector => mgsl_vector_complex_subvector_with_stride($!view, $v.vector, $offset, $stride, $n);
  }
  method real(Math::Libgsl::Vector::Complex64 $v --> Math::Libgsl::Vector) {
    Math::Libgsl::Vector.new: vector => mgsl_vector_complex_real($!view, $v.vector);
  }
  method imag(Math::Libgsl::Vector::Complex64 $v --> Math::Libgsl::Vector) {
    Math::Libgsl::Vector.new: vector => mgsl_vector_complex_imag($!view, $v.vector);
  }
  method array($array --> Math::Libgsl::Vector::Complex64) {
    Math::Libgsl::Vector::Complex64.new: vector => mgsl_vector_complex_view_array($!view, $array, ($array.list.elems / 2).Int);
  }
  method array-stride($array, size_t $stride --> Math::Libgsl::Vector::Complex64) {
    Math::Libgsl::Vector::Complex64.new: vector => mgsl_vector_complex_view_array_with_stride($!view, $array, $stride, ($array.list.elems / 2).Int);
  }
}

has gsl_vector_complex $.vector;
has Bool               $.view = False;

multi method new(Int $size!) { self.bless(:$size) }
multi method new(Int :$size!) { self.bless(:$size) }
multi method new(gsl_vector_complex :$vector!) { self.bless(:$vector) }

submethod BUILD(Int :$size?, gsl_vector_complex :$vector?) {
  $!vector = gsl_vector_complex_calloc($size) with $size;
  with $vector {
    $!vector = $vector;
    $!view   = True;
  }
}

submethod DESTROY {
  gsl_vector_complex_free($!vector) unless $!view;
}

multi method list(Math::Libgsl::Vector::Complex64: --> List) {
  my gsl_complex $c = alloc_gsl_complex;
  LEAVE { free_gsl_complex($c) };
  (^$!vector.size).map({ mgsl_vector_complex_get($!vector, $_, $c); $c.dat[0] + i * $c.dat[1] }).List
}
multi method gist(Math::Libgsl::Vector::Complex64: --> Str) {
  my gsl_complex $c = alloc_gsl_complex;
  LEAVE { free_gsl_complex($c) };
  my ($size, $ellip) = $!vector.size > 100 ?? (100, ' ...') !! ($!vector.size, '');
  '(' ~ (^$size).map({ mgsl_vector_complex_get($!vector, $_, $c); $c.dat[0] + i * $c.dat[1] }).Str ~ "$ellip)";
}
multi method Str(Math::Libgsl::Vector::Complex64: --> Str) { self.list.join(' ') }

# Accessors
method get(Int:D $index! where * < $!vector.size --> Complex) {
  my gsl_complex $c = alloc_gsl_complex;
  LEAVE { free_gsl_complex($c) };
  mgsl_vector_complex_get($!vector, $index, $c);
  $c.dat[0] + i * $c.dat[1];
}
method AT-POS(Math::Libgsl::Vector::Complex64:D: Int:D $index! where * < $!vector.size --> Complex) {
  my $c = alloc_gsl_complex;
  LEAVE { free_gsl_complex($c) };
  mgsl_vector_complex_get($!vector, $index, $c);
  $c.dat[0] + i * $c.dat[1];
}
method set(Int:D $index! where * < $!vector.size, Complex $x!) {
  my $c = alloc_gsl_complex;
  LEAVE { free_gsl_complex($c) };
  mgsl_complex_rect($x.re, $x.im, $c);
  mgsl_vector_complex_set($!vector, $index, $c);
  self
}
method ASSIGN-POS(Math::Libgsl::Vector::Complex64:D: Int:D $index! where * < $!vector.size, Complex(Cool) $x!) {
  my $c = alloc_gsl_complex;
  LEAVE { free_gsl_complex($c) };
  mgsl_complex_rect($x.re, $x.im, $c);
  mgsl_vector_complex_set($!vector, $index, $c);
}
method setall(Complex $x!) {
  my $c = alloc_gsl_complex;
  LEAVE { free_gsl_complex($c) };
  mgsl_complex_rect($x.re, $x.im, $c);
  mgsl_vector_complex_set_all($!vector, $c);
  self
}
method zero() { gsl_vector_complex_set_zero($!vector); self }
method basis(Int:D $index! where * < $!vector.size) {
  my $ret = gsl_vector_complex_set_basis($!vector, $index);
  X::Libgsl.new(errno => $ret, error => "Can't make a basis vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method size(--> UInt){ self.vector.size }
# IO
method write(Str $filename!) {
  my $ret = mgsl_vector_complex_fwrite($filename, $!vector);
  X::Libgsl.new(errno => $ret, error => "Can't write the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method read(Str $filename!) {
  my $ret = mgsl_vector_complex_fread($filename, $!vector);
  X::Libgsl.new(errno => $ret, error => "Can't read the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method printf(Str $filename!, Str $format!) {
  my $ret = mgsl_vector_complex_fprintf($filename, $!vector, $format);
  X::Libgsl.new(errno => $ret, error => "Can't print the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method scanf(Str $filename!) {
  my $ret = mgsl_vector_complex_fscanf($filename, $!vector);
  X::Libgsl.new(errno => $ret, error => "Can't scan the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
# View
sub complex64-prepvec(*@array) is export {
  my CArray[num64] $array .= new: @array».Num;
}
sub complex64-array-vec(Block $bl, *@data) is export {
  my CArray[num64] $carray .= new: @data».Num;
  my Math::Libgsl::Vector::Complex64::View $vv .= new;
  my $v = $vv.array($carray);
  $bl($v);
}
sub complex64-array-stride-vec(Block $bl, size_t $stride, *@data) is export {
  my CArray[num64] $carray .= new: @data».Num;
  my Math::Libgsl::Vector::Complex64::View $vv .= new;
  my $v = $vv.array-stride($carray, $stride);
  $bl($v);
}
# Copy
method copy(Math::Libgsl::Vector::Complex64 $src where $!vector.size == .vector.size) {
  my $ret = gsl_vector_complex_memcpy($!vector, $src.vector);
  X::Libgsl.new(errno => $ret, error => "Can't copy the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method swap(Math::Libgsl::Vector::Complex64 $w where $!vector.size == .vector.size) {
  my $ret = gsl_vector_complex_swap($!vector, $w.vector);
  X::Libgsl.new(errno => $ret, error => "Can't swap vectors").throw if $ret ≠ GSL_SUCCESS;
  self
}
# Exchanging elements
method swap-elems(Int $i where * < $!vector.size, Int $j where * < $!vector.size) {
  my $ret = gsl_vector_complex_swap_elements($!vector, $i, $j);
  X::Libgsl.new(errno => $ret, error => "Can't swap elements").throw if $ret ≠ GSL_SUCCESS;
  self
}
method reverse() {
  my $ret = gsl_vector_complex_reverse($!vector);
  X::Libgsl.new(errno => $ret, error => "Can't reverse the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
# Vector operations
method add(Math::Libgsl::Vector::Complex64 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_complex_add($!vector, $b.vector);
  X::Libgsl.new(errno => $ret, error => "Can't add two vectors").throw if $ret ≠ GSL_SUCCESS;
  self
}
method sub(Math::Libgsl::Vector::Complex64 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_complex_sub($!vector, $b.vector);
  X::Libgsl.new(errno => $ret, error => "Can't sub two vectors").throw if $ret ≠ GSL_SUCCESS;
  self
}
method mul(Math::Libgsl::Vector::Complex64 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_complex_mul($!vector, $b.vector);
  X::Libgsl.new(errno => $ret, error => "Can't mul two vectors").throw if $ret ≠ GSL_SUCCESS;
  self
}
method div(Math::Libgsl::Vector::Complex64 $b where $!vector.size == .vector.size) {
  my $ret = gsl_vector_complex_div($!vector, $b.vector);
  X::Libgsl.new(errno => $ret, error => "Can't div two vectors").throw if $ret ≠ GSL_SUCCESS;
  self
}
method scale(Complex() $x) {
  my $c = alloc_gsl_complex;
  LEAVE { free_gsl_complex($c) };
  mgsl_complex_rect($x.re, $x.im, $c);
  my $ret = mgsl_vector_complex_scale($!vector, $c);
  X::Libgsl.new(errno => $ret, error => "Can't scale the vector").throw if $ret ≠ GSL_SUCCESS;
  self
}
method add-constant(Complex() $x) {
  my $c = alloc_gsl_complex;
  LEAVE { free_gsl_complex($c) };
  mgsl_complex_rect($x.re, $x.im, $c);
  my $ret = mgsl_vector_complex_add_constant($!vector, $c);
  X::Libgsl.new(errno => $ret, error => "Can't add a constant to all elements").throw if $ret ≠ GSL_SUCCESS;
  self
}
# Vector properties
method is-null(--> Bool)   { gsl_vector_complex_isnull($!vector)   ?? True !! False }
method is-pos(--> Bool)    { gsl_vector_complex_ispos($!vector)    ?? True !! False }
method is-neg(--> Bool)    { gsl_vector_complex_isneg($!vector)    ?? True !! False }
method is-nonneg(--> Bool) { gsl_vector_complex_isnonneg($!vector) ?? True !! False }
method is-equal(Math::Libgsl::Vector::Complex64 $b --> Bool) { gsl_vector_complex_equal($!vector, $b.vector) ?? True !! False }
