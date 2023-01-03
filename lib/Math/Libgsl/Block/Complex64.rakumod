use v6;

unit class Math::Libgsl::Block::Complex64:ver<0.5.0>:auth<zef:FRITH>;

use Math::Libgsl::Raw::Complex :ALL;
use Math::Libgsl::Raw::Matrix::Complex64 :ALL;
use NativeCall;

has gsl_block_complex $.block;

multi method new(Int $size!) { self.bless(:$size) }
multi method new(Int :$size!) { self.bless(:$size) }

submethod BUILD(:$size!) { $!block = gsl_block_complex_calloc($size) }
submethod DESTROY { gsl_block_complex_free($!block) }

method write(Str $filename! --> Int) { mgsl_block_complex_fwrite($filename, $!block) }
method read(Str $filename! --> Int) { mgsl_block_complex_fread($filename, $!block) }
method printf(Str $filename!, Str $format! --> Int) { mgsl_block_complex_fprintf($filename, $!block, $format) }
method scanf(Str $filename! --> Int) { mgsl_block_complex_fscanf($filename, $!block) }
