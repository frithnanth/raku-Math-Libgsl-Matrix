use v6;

unit class Math::Libgsl::Block::Int8:ver<0.3.0>:auth<cpan:FRITH>;

use Math::Libgsl::Raw::Matrix::Int8 :ALL;
use NativeCall;

has gsl_block_char $.block;

multi method new(Int $size!) { self.bless(:$size) }
multi method new(Int :$size!) { self.bless(:$size) }

submethod BUILD(:$size!) { $!block = gsl_block_char_calloc($size) }
submethod DESTROY { gsl_block_char_free($!block) }

method write(Str $filename! --> Int) { mgsl_block_char_fwrite($filename, $!block) }
method read(Str $filename! --> Int) { mgsl_block_char_fread($filename, $!block) }
method printf(Str $filename!, Str $format! --> Int) { mgsl_block_char_fprintf($filename, $!block, $format) }
method scanf(Str $filename! --> Int) { mgsl_block_char_fscanf($filename, $!block) }
