use v6;

unit class Math::Libgsl::Block::UInt16:ver<0.0.4>:auth<cpan:FRITH>;

use Math::Libgsl::Raw::Complex :ALL;
use Math::Libgsl::Raw::Matrix::UInt16 :ALL;
use NativeCall;

has gsl_block_ushort $.block;

multi method new(Int $size!) { self.bless(:$size) }
multi method new(Int :$size!) { self.bless(:$size) }

submethod BUILD(:$size!) { $!block = gsl_block_ushort_calloc($size) }
submethod DESTROY { gsl_block_ushort_free($!block) }

method write(Str $filename! --> Int) { mgsl_block_ushort_fwrite($filename, $!block) }
method read(Str $filename! --> Int) { mgsl_block_ushort_fread($filename, $!block) }
method printf(Str $filename!, Str $format! --> Int) { mgsl_block_ushort_fprintf($filename, $!block, $format) }
method scanf(Str $filename! --> Int) { mgsl_block_ushort_fscanf($filename, $!block) }
