use v6;

unit class Math::Libgsl::Block:ver<0.0.5>:auth<cpan:FRITH>;

use Math::Libgsl::Raw::Complex :ALL;
use Math::Libgsl::Raw::Matrix :ALL;
use NativeCall;

has gsl_block $.block;

multi method new(Int $size!) { self.bless(:$size) }
multi method new(Int :$size!) { self.bless(:$size) }

submethod BUILD(:$size!) { $!block = gsl_block_calloc($size) }
submethod DESTROY { gsl_block_free($!block) }

method write(Str $filename! --> Int) { mgsl_block_fwrite($filename, $!block) }
method read(Str $filename! --> Int) { mgsl_block_fread($filename, $!block) }
method printf(Str $filename!, Str $format! --> Int) { mgsl_block_fprintf($filename, $!block, $format) }
method scanf(Str $filename! --> Int) { mgsl_block_fscanf($filename, $!block) }
