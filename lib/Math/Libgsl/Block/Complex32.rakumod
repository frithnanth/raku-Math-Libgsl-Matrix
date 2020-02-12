use v6;

unit class Math::Libgsl::Block::Complex32:ver<0.0.6>:auth<cpan:FRITH>;

use Math::Libgsl::Raw::Complex :ALL;
use Math::Libgsl::Raw::Matrix::Complex32 :ALL;
use NativeCall;

has gsl_block_complex_float $.block;

multi method new(Int $size!) { self.bless(:$size) }
multi method new(Int :$size!) { self.bless(:$size) }

submethod BUILD(:$size!) { $!block = gsl_block_complex_float_calloc($size) }
submethod DESTROY { gsl_block_complex_float_free($!block) }

method write(Str $filename! --> Int) { mgsl_block_complex_float_fwrite($filename, $!block) }
method read(Str $filename! --> Int) { mgsl_block_complex_float_fread($filename, $!block) }
method printf(Str $filename!, Str $format! --> Int) { mgsl_block_complex_float_fprintf($filename, $!block, $format) }
method scanf(Str $filename! --> Int) { mgsl_block_complex_float_fscanf($filename, $!block) }
