use v6;

unit class Math::Libgsl::Block::Int64:ver<0.6.0>:auth<zef:FRITH>;

use Math::Libgsl::Raw::Matrix::Int64 :ALL;
use NativeCall;

has gsl_block_long $.block;

multi method new(Int $size!) { self.bless(:$size) }
multi method new(Int :$size!) { self.bless(:$size) }

submethod BUILD(:$size!) { $!block = gsl_block_long_calloc($size) }
submethod DESTROY { gsl_block_long_free($!block) }

method write(Str $filename! --> Int) { mgsl_block_long_fwrite($filename, $!block) }
method read(Str $filename! --> Int) { mgsl_block_long_fread($filename, $!block) }
method printf(Str $filename!, Str $format! --> Int) { mgsl_block_long_fprintf($filename, $!block, $format) }
method scanf(Str $filename! --> Int) { mgsl_block_long_fscanf($filename, $!block) }
