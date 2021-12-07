use v6;

unit class Math::Libgsl::Block::Int32:ver<0.4.1>:auth<zef:frithnanth>;

use Math::Libgsl::Raw::Matrix::Int32 :ALL;
use NativeCall;

has gsl_block_int $.block;

multi method new(Int $size!) { self.bless(:$size) }
multi method new(Int :$size!) { self.bless(:$size) }

submethod BUILD(:$size!) { $!block = gsl_block_int_calloc($size) }
submethod DESTROY { gsl_block_int_free($!block) }

method write(Str $filename! --> Int) { mgsl_block_int_fwrite($filename, $!block) }
method read(Str $filename! --> Int) { mgsl_block_int_fread($filename, $!block) }
method printf(Str $filename!, Str $format! --> Int) { mgsl_block_int_fprintf($filename, $!block, $format) }
method scanf(Str $filename! --> Int) { mgsl_block_int_fscanf($filename, $!block) }
