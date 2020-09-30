use v6;

unit class Math::Libgsl::Block::Int16:ver<0.3.0>:auth<cpan:FRITH>;

use Math::Libgsl::Raw::Matrix::Int16 :ALL;
use NativeCall;

has gsl_block_short $.block;

multi method new(Int $size!) { self.bless(:$size) }
multi method new(Int :$size!) { self.bless(:$size) }

submethod BUILD(:$size!) { $!block = gsl_block_short_calloc($size) }
submethod DESTROY { gsl_block_short_free($!block) }

method write(Str $filename! --> Int) { mgsl_block_short_fwrite($filename, $!block) }
method read(Str $filename! --> Int) { mgsl_block_short_fread($filename, $!block) }
method printf(Str $filename!, Str $format! --> Int) { mgsl_block_short_fprintf($filename, $!block, $format) }
method scanf(Str $filename! --> Int) { mgsl_block_short_fscanf($filename, $!block) }
