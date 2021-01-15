use v6;

unit class Math::Libgsl::Block::UInt64:ver<0.3.3>:auth<cpan:FRITH>;

use Math::Libgsl::Raw::Matrix::UInt64 :ALL;
use NativeCall;

has gsl_block_ulong $.block;

multi method new(Int $size!) { self.bless(:$size) }
multi method new(Int :$size!) { self.bless(:$size) }

submethod BUILD(:$size!) { $!block = gsl_block_ulong_calloc($size) }
submethod DESTROY { gsl_block_ulong_free($!block) }

method write(Str $filename! --> Int) { mgsl_block_ulong_fwrite($filename, $!block) }
method read(Str $filename! --> Int) { mgsl_block_ulong_fread($filename, $!block) }
method printf(Str $filename!, Str $format! --> Int) { mgsl_block_ulong_fprintf($filename, $!block, $format) }
method scanf(Str $filename! --> Int) { mgsl_block_ulong_fscanf($filename, $!block) }
