use v6;

unit class Math::Libgsl::Block::UInt32:ver<0.5.0>:auth<zef:FRITH>;

use Math::Libgsl::Raw::Matrix::UInt32 :ALL;
use NativeCall;

has gsl_block_uint $.block;

multi method new(Int $size!) { self.bless(:$size) }
multi method new(Int :$size!) { self.bless(:$size) }

submethod BUILD(:$size!) { $!block = gsl_block_uint_calloc($size) }
submethod DESTROY { gsl_block_uint_free($!block) }

method write(Str $filename! --> Int) { mgsl_block_uint_fwrite($filename, $!block) }
method read(Str $filename! --> Int) { mgsl_block_uint_fread($filename, $!block) }
method printf(Str $filename!, Str $format! --> Int) { mgsl_block_uint_fprintf($filename, $!block, $format) }
method scanf(Str $filename! --> Int) { mgsl_block_uint_fscanf($filename, $!block) }
