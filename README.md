[![Actions Status](https://github.com/frithnanth/raku-Math-Libgsl-Matrix/workflows/test/badge.svg)](https://github.com/frithnanth/raku-Math-Libgsl-Matrix/actions)

NAME
====

Math::Libgsl::Matrix Math::Libgsl::Vector - An interface to libgsl, the Gnu Scientific Library - Vector and matrix algebra.

SYNOPSIS
========

```raku
use Math::Libgsl::Vector;
use Math::Libgsl::Matrix;
```

DESCRIPTION
===========

Math::Libgsl::Matrix provides an interface to the vector and matrix algebra functions of libgsl - the GNU Scientific Library.

This package provides both the low-level interface to the C library (Raw) and a more comfortable interface layer for the Raku programmer.

This module comes with two classes, Vector and Matrix, available in 12 data types, so it offers 24 classes:

  * Math::Libgsl::Vector - default, corresponding to a Math::Libgsl::Vector::Num64

  * Math::Libgsl::Vector::Num32

  * Math::Libgsl::Vector::Int32

  * Math::Libgsl::Vector::UInt32

  * Math::Libgsl::Vector::Int64

  * Math::Libgsl::Vector::UInt64

  * Math::Libgsl::Vector::Int16

  * Math::Libgsl::Vector::UInt16

  * Math::Libgsl::Vector::Int8

  * Math::Libgsl::Vector::UInt8

  * Math::Libgsl::Vector::Complex32

  * Math::Libgsl::Vector::Complex64

  * Math::Libgsl::Matrix - default, corresponding to a Math::Libgsl::Matrix::Num64

  * Math::Libgsl::Matrix::Num32

  * Math::Libgsl::Matrix::Int32

  * Math::Libgsl::Matrix::UInt32

  * Math::Libgsl::Matrix::Int64

  * Math::Libgsl::Matrix::UInt64

  * Math::Libgsl::Matrix::Int16

  * Math::Libgsl::Matrix::UInt16

  * Math::Libgsl::Matrix::Int8

  * Math::Libgsl::Matrix::UInt8

  * Math::Libgsl::Matrix::Complex32

  * Math::Libgsl::Matrix::Complex64

All the following methods are available for the classes correspondig to each datatype, except where noted.

Vector
------

### new(Int $size!)

### new(Int :$size!)

The constructor accepts one parameter: the vector's size; it can be passed as a Pair or as a single value.

### get(Int:D $index! where * < $!vector.size --> Num)

This method returns the value of a vector's element. It is possible to address a vector element as a Raku array element:

```raku
say $vector[1];
```

or even:

```raku
say $vector[^10];
```

### set(Int:D $index! where * < $!vector.size, Num(Cool)

This method sets the value of a vector's element. This method can be chained. It is possible to address a vector element as a Raku array element:

```raku
$vector[1] = 3;
```

Note that it's not possible to set a range of elements (yet). When used as a Raku array, this method can't be chained.

### setall(Num(Cool))

Sets all the elements of the vector to the same value. This method can be chained.

### zero()

Sets all the elements of the vector to zero. This method can be chained.

### basis(Int:D $index! where * < $!vector.size)

Sets all the elements of the vector to zero except for the element at $index, which is set to one. This method can be chained.

### size(--> UInt)

This method outputs the vector's size.

### write(Str $filename!)

Writes the vector to a file in binary form. This method can be chained.

### read(Str $filename!)

Reads the vector from a file in binary form. This method can be chained.

### printf(Str $filename!, Str $format!)

Writes the vector to a file using the specified format. This method can be chained.

### scanf(Str $filename!)

Reads the vector from a file containing formatted data. This method can be chained.

### copy(Math::Libgsl::Vector $src where $!vector.size == .vector.size)

This method copies the vector $src into the current object. This method can be chained.

### swap(Math::Libgsl::Vector $w where $!vector.size == .vector.size)

This method exchanges the elements of the current vector with the ones of the vector $w. This method can be chained.

### swap-elems(Int $i where * < $!vector.size, Int $j where * < $!vector.size)

This method exchanges the $i-th and $j-th elements in place. This method can be chained.

### reverse()

This method reverses the order of the elements of the vector. This method can be chained.

### add(Math::Libgsl::Vector $b where $!vector.size == .vector.size)

### sub(Math::Libgsl::Vector $b where $!vector.size == .vector.size)

### mul(Math::Libgsl::Vector $b where $!vector.size == .vector.size)

### div(Math::Libgsl::Vector $b where $!vector.size == .vector.size)

These methods perform operations on the elements of two vectors. The object on which the method is called is the one whose values are changed. All these methods can be chained.

### scale(Num(Cool) $x)

This method multiplies the elements of the vector by a factor $x. This method can be chained.

### add-constant(Num(Cool) $x)

This method adds a constant to the elements of the vector. This method can be chained.

### sum(--> Num)

This method returns the sum of the elements of the vector. This method fails if the underlying C library's version is less than 2.7.

### axpby(Num(Cool) $alpha, Num(Cool) $beta, Math::Libgsl::Vector $b where $!vector.size == .vector.size)

This method performs the operation αx + βy and returns the result in the vector $b. This method can be chained. This method fails if the underlying C library's version is less than 2.7.

### max(--> Num)

### min(--> Num)

These two methods return the min and max value in the vector. Not available in Math::Libgsl::Vector::Complex32 and Math::Libgsl::Vector::Complex64.

### minmax(--> List)

This method returns a list of two values: the min and max value in the vector. Not available in Math::Libgsl::Vector::Complex32 and Math::Libgsl::Vector::Complex64.

### max-index(--> Int)

### min-index(--> Int)

These two methods return the index of the min and max value in the vector. Not available in Math::Libgsl::Vector::Complex32 and Math::Libgsl::Vector::Complex64.

### minmax-index(--> List)

This method returns a list of two values: the indices of the min and max value in the vector. Not available in Math::Libgsl::Vector::Complex32 and Math::Libgsl::Vector::Complex64.

### is-null(--> Bool)

### is-pos(--> Bool)

### is-neg(--> Bool)

### is-nonneg(--> Bool)

These methods return True if all the elements of the vector are zero, strictly positive, strictly negative, or non-negative.

### is-equal(Math::Libgsl::Vector $b --> Bool)

This method returns True if the two vectors are equal element-wise.

Views
-----

Views are extremely handy, but their C-language interface uses a couple of low-level tricks that makes difficult to write a simple interface for high-level languages. A View is a reference to data in a Vector, Matrix, or array, so it makes possible to work on a subset of that data without having to duplicate it in memory or do complex address calculation to access it. Since a View is a reference to an object, the programmer needs to take care that the original object doesn't go out of scope, or the virtual machine might deallocate its memory causing the underlying C library to crash. Look in the **examples/** directory for more programs showing what can be done with views.

Vector View
-----------

```raku
use Math::Libgsl::Vector;

my Math::Libgsl::Vector $v .= new(30);                            # Create a 30-element vector
my Math::Libgsl::Vector::View $vv .= new;                         # Create a Vector View
my Math::Libgsl::Vector $v1 = $vv.subvector-stride($v, 0, 3, 10); # Get a subvector view with stride
$v1.setall(42);                                                   # Set all elements of the subvector view to 42
say $v[^30]; # output: (42 0 0 42 0 0 42 0 0 42 0 0 42 0 0 42 0 0 42 0 0 42 0 0 42 0 0 42 0 0)
```

There are two kinds of Vector Views: a Vector View on a Vector or a Vector View on a Raku array. These are Views of the first kind:

### subvector(Math::Libgsl::Vector $v, size_t $offset where * < $v.vector.size, size_t $n --> Math::Libgsl::Vector)

Creates a view on a subset of the vector, starting from $offset and of length $n. This method returns a new Vector object. Any operation done on this view affects the original vector as well.

### subvector-stride(Math::Libgsl::Vector $v, size_t $offset where * < $v.vector.size, size_t $stride, size_t $n --> Math::Libgsl::Vector)

Creates a view on a subset of the vector, starting from $offset and of length $n, with stride $stride. This method returns a new Vector object. Any operation done on this view affects the original vector as well.

Views on a Raku array are a bit more complex, because it's not possible to simply pass a Raku array to a C-language function. So for this to work the programmer has to *prepare* the array to be passed to the library. Both the View object and the *prepared* array must not go out of scope.

There are three ways to access a Raku array as a Math::Libgsl::Vector object:

  * The hard way - use NativeCall's CArray to create a C-language-happy array.

  * The easy way - use the *-prepvec sub to convert a Raku array into a C array.

  * The easiest way - use the *-array-vec sub, pass it the Raku array or list and a closure or anonymous sub.

This is an example of the "hard way":

```raku
use Math::Libgsl::Vector;
use NativeCall;

my CArray[num64] $array .= new: (1 xx 10)».Num;         # define a CArray
my Math::Libgsl::Vector::View $vv .= new;               # view: an object that will contain the view information
my Math::Libgsl::Vector $v = $vv.array($array);         # create an Math::Libgsl::Vector object
$v[0] = 2;                                              # assign a value to the first vector element
say $v[^10];                                            # output: (2 1 1 1 1 1 1 1 1 1)
```

This is an example of the "easy way":

```raku
use Math::Libgsl::Vector;

my @array = 1 xx 10;                                    # define an array
my $parray = num64-prepvec(@array);                     # prepare the array to be used as a Math::Libgsl::Vector
my Math::Libgsl::Vector::View $vv .= new;               # view: an object that will contain the view information
my Math::Libgsl::Vector $v = $vv.array($parray);        # create an Math::Libgsl::Vector object
$v[0] = 2;                                              # assign a value to the first vector element
say $v[^10];                                            # output: (2 1 1 1 1 1 1 1 1 1)
```

Here are some examples of the "easiest way":

```raku
use Math::Libgsl::Vector;

my @array = ^10;                                                    # initialize an array
my ($min, $max) = num64-array-vec(-> $vec { $vec.minmax }, @array); # find min and max value
say "$min $max";                                                    # output: 0 9
```

```raku
use Math::Libgsl::Constants;
use Math::Libgsl::Vector;
use Math::Libgsl::MovingWindow;

my @array = ^10;                                        # initialize an array
my Math::Libgsl::MovingWindow $mw .= new: :samples(5);  # initialize a MovingWindow object with a 5-sample window
                                                        # compute the moving-window mean of the array
my $w = num64-array-vec(-> $vec { $mw.mean($vec, :endtype(GSL_MOVSTAT_END_PADVALUE)) }, @array);
say $w[^10];                                            # output: (0.6 1.2 2 3 4 5 6 7 7.8 8.4)
```

Even using this last construct, if the Vector object is to be used outside of the closure it must be declared before calling array-vec.

```raku
use Math::Libgsl::Vector;

my @array = 1 xx 10;                                            # define an array
my Math::Libgsl::Vector $v .= new: 10;                          # declare a Math::Libgsl::Vector
num64-array-vec(-> $vec { $v.copy($vec); $v[0] = 2; }, @array); # assign a value to the first vector element
say $v[^10];                                                    # output: (2 1 1 1 1 1 1 1 1 1)
```

### num64-prepvec(@array)

This is just a sub, not a method; it gets a regular array and outputs a *prepared* array, kept in a scalar variable. There are similar functions for every data type, so for example if one is working with int16 Vectors, one will use the **int16-prepvec** sub. The num64, being the default data type, has a special **prepvec** alias. Once *prepared*, the original array can be discarded.

### array($parray --> Math::Libgsl::Vector)

This method gets a *prepared* array and returns a Math::Libgsl::Vector object.

### array-stride($array, size_t $stride --> Math::Libgsl::Vector)

This method gets a *prepared* array and a **$stride** and returns a Math::Libgsl::Vector object.

### sub num64-array-vec(Block $bl, *@data)

This sub arguments are a Block to execute and a regular Raku array. Internally it uses a vector view to convert the array into libgsl's own vector data type, obtains the Math::Libgsl::Vector from the View, and passes it to the Block. When the Block exits the Math::Libgsl::Vector object ceases to exist, so it must be consumed inside the Block, or copied into another externally defined variable. The num64, being the default data type, has a special **array-vec** alias.

### sub num64-array-stride-vec(Block $bl, size_t $stride, *@data)

This sub arguments are a Block to execute, a stride, and a regular Raku array. Internally it uses a vector view to convert the array into libgsl's own vector data type, obtains the Math::Libgsl::Vector from the View, and passes it to the Block. When the Block exits the Math::Libgsl::Vector object ceases to exist, so it must be consumed inside the Block, or copied into another externally defined variable. The num64, being the default data type, has a special **array-stride-vec** alias.

Matrix
------

### new(Int $size1!, Int $size2!)

### new(Int :$size1!, Int :$size2!)

The constructor accepts two parameters: the matrix sizes; they can be passed as Pairs or as single values.

### get(Int:D $i! where * < $!matrix.size1, Int:D $j! where * < $!matrix.size2 --> Num)

This method returns the value of a matrix element. It is possible to address a matrix element as a Raku shaped array element:

```raku
say $matrix[1;2];
```

### set(Int:D $i! where * < $!matrix.size1, Int:D $j! where * < $!matrix.size2, Num(Cool)

This method sets the value of a matrix element. This method can be chained. It is possible to address a matrix element as a Raku shaped array element:

```raku
$matrix[1;3] = 3;
```

### setall(Num(Cool))

Sets all the elements of the matrix to the same value. This method can be chained.

### zero()

Sets all the elements of the matrix to zero. This method can be chained.

### identity()

Sets all elements of the matrix to the corrisponding elements of the identity matrix.

### size1(--> UInt)

### size2(--> UInt)

### size(--> List)

These methods return the first, second, or both the matrix sizes.

### write(Str $filename!)

Writes the matrix to a file in binary form. This method can be chained.

### read(Str $filename!)

Reads the matrix from a file in binary form. This method can be chained.

### printf(Str $filename!, Str $format!)

Writes the matrix to a file using the specified format. This method can be chained.

### scanf(Str $filename!)

Reads the matrix from a file containing formatted data. This method can be chained.

### copy(Math::Libgsl::Matrix $src where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2)

This method copies the $src matrix into the current one. This method can be chained.

### swap(Math::Libgsl::Matrix $src where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2)

This method swaps elements of the $src matrix and the current one. This method can be chained.

### tricpy(Math::Libgsl::Matrix $src where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2, Int $Uplo, Int $Diag)

This method copies the upper or lower trianglular matrix from **$src** to **self**. Use the **cblas-uplo** enumeration to specify which triangle copy. Use the **cblas-diag** enumeration to specify whether to copy the matrix diagonal. This method can be chained.

### get-row(Int:D $i where * < $!matrix.size1)

This method returns an array from row number $i.

### get-col(Int:D $j where * < $!matrix.size2)

This method returns an array from column number $j.

### set-row(Int:D $i where * ≤ $!matrix.size1, @row where *.elems == $!matrix.size2)

### set-row(Int:D $i where * ≤ $!matrix.size1, Math::Libgsl::Vector $v where .vector.size == $!matrix.size2)

These methods set row number $i of the matrix from a Raku array or a Vector object. This method can be chained.

### set-col(Int:D $j where * ≤ $!matrix.size2, @col where *.elems == $!matrix.size1)

### set-col(Int:D $j where * ≤ $!matrix.size2, Math::Libgsl::Vector $v where .vector.size == $!matrix.size1)

These methods set column number $j of the matrix from a Raku array or a Vector object. This method can be chained.

### swap-rows(Int:D $i where * ≤ $!matrix.size1, Int:D $j where * ≤ $!matrix.size1)

This method swaps rows $i and $j. This method can be chained.

### swap-cols(Int:D $i where * ≤ $!matrix.size2, Int:D $j where * ≤ $!matrix.size2)

This method swaps columns $i and $j. This method can be chained.

### swap-rowcol(Int:D $i where * ≤ $!matrix.size1, Int:D $j where * ≤ $!matrix.size1)

This method exchanges row number $i with column number $j of a square matrix. This method can be chained.

### copy-transpose(Math::Libgsl::Matrix $src where $!matrix.size1 == .matrix.size2 && $!matrix.size2 == .matrix.size1)

This method copies a matrix into the current one, while transposing the elements. This method can be chained.

### transpose()

This method transposes the current matrix. This method can be chained.

### transpose-tricpy(Math::Libgsl::Matrix $src where $!matrix.size1 == .matrix.size2 && $!matrix.size2 == .matrix.size1, Int $Uplo, Int $Diag)

This method copies a triangle from the **$src** matrix into the current one, while transposing the elements. Use the **cblas-uplo** enumeration to specify which triangle copy. Use the **cblas-diag** enumeration to specify whether to copy the matrix diagonal. This method can be chained.

### add(Math::Libgsl::Matrix $b where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2)

This method adds a matrix to the current one element-wise. This method can be chained.

### sub(Math::Libgsl::Matrix $b where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2)

This method subtracts a matrix from the current one element-wise. This method can be chained.

### mul(Math::Libgsl::Matrix $b where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2)

This method multiplies a matrix to the current one element-wise. This method can be chained.

### div(Math::Libgsl::Matrix $b where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2)

This method divides the current matrix by another one element-wise. This method can be chained.

### scale(Num(Cool) $x)

This method multiplies the elements of the current matrix by a constant value. This method can be chained.

### scale-rows(Math::Libgsl::Vector $x where .size == $!matrix.size1)

This method scales the rows of the M-by-N matrix by the elements of the vector $x, of length N. The i-th row of the matrix is multiplied by $xᵢ. This method can be chained. This method fails if the underlying C library's version is less than 2.7.

### scale-columns(Math::Libgsl::Vector $x where .size == $!matrix.size1)

This method scales the columns of the M-by-N matrix by the elements of the vector $x, of length N. The j-th column of the matrix is multiplied by $xⱼ. This method can be chained. This method fails if the underlying C library's version is less than 2.7.

### add-constant(Num(Cool) $x)

This method adds a constant to the elements of the current matrix. This method can be chained.

### max(--> Num)

### min(--> Num)

These two methods return the min and max value in the matrix. Not available in Math::Libgsl::Matrix::Complex32 and Math::Libgsl::Matrix::Complex64.

### minmax(--> List)

This method returns a list of two values: the min and max value in the matrix. Not available in Math::Libgsl::Matrix::Complex32 and Math::Libgsl::Matrix::Complex64.

### max-index(--> Int)

### min-index(--> Int)

These two methods return the index of the min and max value in the matrix. Not available in Math::Libgsl::Matrix::Complex32 and Math::Libgsl::Matrix::Complex64.

### minmax-index(--> List)

This method returns a list of two values: the indices of the min and max value in the matrix. Not available in Math::Libgsl::Matrix::Complex32 and Math::Libgsl::Matrix::Complex64.

### is-null(--> Bool)

### is-pos(--> Bool)

### is-neg(--> Bool)

### is-nonneg(--> Bool)

These methods return True if all the elements of the matrix are zero, strictly positive, strictly negative, or non-negative.

### is-equal(Math::Libgsl::Matrix $b --> Bool)

This method returns True if the matrices are equal element-wise.

### norm1(--> Num)

This method returns the 1-norm of the m-by-n matrix, defined as the maximum column sum. This method fails if the underlying C library's version is less than 2.7.

Matrix View
-----------

```raku
use Math::Libgsl::Matrix;

my Math::Libgsl::Matrix $m1 .= new(:size1(3), :size2(4));      # create a 3x4 matrix
$m1.setall(1);                                                 # set all elements to 1
my Math::Libgsl::Matrix::View $mv .= new;                      # create a Matrix View
my Math::Libgsl::Matrix $m2 = $mv.submatrix($m1, 1, 1, 2, 2);  # get a submatrix
$m2.setall(12);                                                # set the submatrix elements to 12
$m1.get-row($_)».fmt('%2d').put for ^3;                        # print the original matrix
# output:
# 1  1  1  1
# 1 12 12  1
# 1 12 12  1
```

There are three kinds of Matrix Views: a Matrix View on a Matrix, a Matrix View on a Vector, and a Matrix View on a Raku array.

This is the View of the first kind:

### submatrix(Math::Libgsl::Matrix $m, size_t $k1 where * < $m.size1, size_t $k2 where * < $m.size2, size_t $n1, size_t $n2 --> Math::Libgsl::Matrix)

Creates a view on a subset of the matrix, starting from coordinates ($k1, $k2) with $n1 rows and $n2 columns. This method returns a new Matrix object. Any operation done on the returned matrix affects the original matrix as well.

These three methods create a matrix view on a Raku array:

There are three ways to view a Raku array as a Math::Libgsl::Vector object:

  * The hard way - use NativeCall's CArray to create a C-language-happy array.

  * The easy way - use the *-prepvec sub to convert a Raku array into a C array.

  * The easiest way - use the *-array-vec sub, pass it the Raku array or list and a closure or anonymous sub.

This is an example of the "hard way":

```raku
use Math::Libgsl::Matrix;
use NativeCall;

my CArray[num64] $array .= new: (1..6)».Num;            # define a CArray
my Math::Libgsl::Matrix::View $mv .= new;               # view: an object that will contain the view information
my Math::Libgsl::Matrix $m = $mv.array($array, 2, 3);   # create an Math::Libgsl::Matrix object
$m[0;0] = 2;                                            # assign a value to the first matrix element
say $m.get-row($_) for ^2;
# output:
# 2 2 3
# 4 5 6
```

This is an example of the "easy way":

Views on a Raku array are a bit more complex, because it's not possible to simply pass a Raku array to a C-language function. So for this to work the programmer has to *prepare* the array to be passed to the library. Both the View object and the *prepared* array must not go out of scope.

```raku
use Math::Libgsl::Matrix;

my @array = 1 xx 10;                                    # define an array
my $parray = prepmat(@array);                           # prepare the array to be used as a Math::Libgsl::Matrix
my Math::Libgsl::Matrix::View $mv .= new;               # view: an object that will contain the view information
my Math::Libgsl::Matrix $m = $mv.array($parray, 2, 5);  # create an Math::Libgsl::Matrix object
$m[0;0] = 2;                                            # assign a value to the first matrix element
$m.get-row($_).put for ^2;
# output:
# 2 1 1 1 1
# 1 1 1 1 1
```

This is an example of the "easiest way":

```raku
use Math::Libgsl::Matrix;

my @array = 1..6;                                                                 # initialize an array
my Math::Libgsl::Matrix $matrix .= new: 2, 3;                                     # declare a Math::Libgsl::Matrix
num64-array-mat(-> $mat { $matrix.copy($mat); $matrix[0;0] = 0 }, 2, 3, @array);  # assign 0 to matrix element [0;0]
$matrix.get-row($_).put for ^2;
# output:
# 0 2 3
# 4 5 6
```

### num64-prepmat(@array)

This is just a sub, not a method; it gets a regular array and outputs a *prepared* array, kept in a scalar variable. There are similar functions for every data type, so for example if one is working with int16 Vectors, one will use the **int16-prepmat** sub. The num64, being the default data type, has a special **prepmat** alias. Once *prepared*, the original array can be discarded.

### array($array, UInt $size1, UInt $size2 --> Math::Libgsl::Matrix)

This method gets a *prepared* array and returns a Math::Libgsl::Matrix object.

### array-tda($array, UInt $size1, UInt $size2, size_t $tda where * > $size2 --> Math::Libgsl::Matrix)

This method gets a *prepared* array with a number of physical columns **$tda**, which may differ from the corresponding dimension of the matrix, and returns a Math::Libgsl::Matrix object.

### sub num64-array-mat(Block $bl, UInt $size1, UInt $size2, *@data)

This sub arguments are a Block to execute, the sizes of the desired resulting matrix, and a regular Raku array. Internally it uses a matrix view to convert the array into libgsl's own matrix data type, obtains the Math::Libgsl::Matrix from the View, and passes it to the Block. When the Block exits the Math::Libgsl::Matrix object ceases to exist, so it must be consumed inside the Block, or copied into another externally defined variable. The num64, being the default data type, has a special **array-mat** alias.

### sub num64-array-tda-mat(Block $bl, UInt $size1, UInt $size2, size_t $tda where * > $size2, *@data)

This sub arguments are a Block to execute, the sizes of the desired resulting matrix, the number of physical columns **$tda**, and a regular Raku array. Internally it uses a matrix view to convert the array into libgsl's own matrix data type, obtains the Math::Libgsl::Matrix from the View, and passes it to the Block. When the Block exits the Math::Libgsl::Matrix object ceases to exist, so it must be consumed inside the Block, or copied into another externally defined variable. The num64, being the default data type, has a special **array-tda-mat** alias.

There are two methods to create a Matrix View on a Vector:

### vector(Math::Libgsl::Vector $v, size_t $n1, size_t $n2 --> Math::Libgsl::Matrix)

This method creates a Matrix object from a Vector object. The resultimg matrix will have $n1 rows and $n2 columns.

### vector-tda(Math::Libgsl::Vector $v, size_t $n1, size_t $n2, size_t $tda where * > $n2 --> Math::Libgsl::Matrix)

This method creates a Matrix object from a Vector object, with a physical number of columns $tda which may differ from the correspondig dimension of the matrix. The resultimg matrix will have $n1 rows and $n2 columns.

Vector View on a Matrix
-----------------------

There is a fourth kind of View that involves a Matrix: a Vector View on a Matrix. The following are methods of the Matrix class, not of the Matrix::View class, take a Vector::View argument, and deliver a Vector object. The Matrix object must not go out of scope while one is operating on the resulting Vector.

### row-view(Math::Libgsl::Vector::View $vv, size_t $i where * < $!matrix.size1 --> Math::Libgsl::Vector)

This method creates a Vector object from row $i of the matrix.

### col-view(Math::Libgsl::Vector::View $vv, size_t $j where * < $!matrix.size2 --> Math::Libgsl::Vector)

This method creates a Vector object from column $j of the matrix.

### subrow-view(Math::Libgsl::Vector::View $vv, size_t $i where * < $!matrix.size1, size_t $offset, size_t $n --> Math::Libgsl::Vector)

This method creates a Vector object from row $i of the matrix, starting from $offset and containing $n elements.

### subcol-view(Math::Libgsl::Vector::View $vv, size_t $j where * < $!matrix.size2, size_t $offset, size_t $n --> Math::Libgsl::Vector)

This method creates a Vector object from column $j of the matrix, starting from $offset and containing $n elements.

### diagonal-view(Math::Libgsl::Vector::View $vv --> Math::Libgsl::Vector)

This method creates a Vector object from the diagonal of the matrix.

### subdiagonal-view(Math::Libgsl::Vector::View $vv, size_t $k where * < min($!matrix.size1, $!matrix.size2) --> Math::Libgsl::Vector)

This method creates a Vector object from the subdiagonal number $k of the matrix.

### superdiagonal-view(Math::Libgsl::Vector::View $vv, size_t $k where * < min($!matrix.size1, $!matrix.size2) --> Math::Libgsl::Vector)

This method creates a Vector object from the superdiagonal number $k of the matrix.

C Library Documentation
=======================

For more details on libgsl see [https://www.gnu.org/software/gsl/](https://www.gnu.org/software/gsl/). The excellent C Library manual is available here [https://www.gnu.org/software/gsl/doc/html/index.html](https://www.gnu.org/software/gsl/doc/html/index.html), or here [https://www.gnu.org/software/gsl/doc/latex/gsl-ref.pdf](https://www.gnu.org/software/gsl/doc/latex/gsl-ref.pdf) in PDF format.

Prerequisites
=============

This module requires the libgsl library to be installed. Please follow the instructions below based on your platform:

Debian Linux and Ubuntu 20.04
-----------------------------

    sudo apt install libgsl23 libgsl-dev libgslcblas0

That command will install libgslcblas0 as well, since it's used by the GSL.

Ubuntu 18.04
------------

libgsl23 and libgslcblas0 have a missing symbol on Ubuntu 18.04. I solved the issue installing the Debian Buster version of those three libraries:

  * [http://http.us.debian.org/debian/pool/main/g/gsl/libgslcblas0_2.5+dfsg-6_amd64.deb](http://http.us.debian.org/debian/pool/main/g/gsl/libgslcblas0_2.5+dfsg-6_amd64.deb)

  * [http://http.us.debian.org/debian/pool/main/g/gsl/libgsl23_2.5+dfsg-6_amd64.deb](http://http.us.debian.org/debian/pool/main/g/gsl/libgsl23_2.5+dfsg-6_amd64.deb)

  * [http://http.us.debian.org/debian/pool/main/g/gsl/libgsl-dev_2.5+dfsg-6_amd64.deb](http://http.us.debian.org/debian/pool/main/g/gsl/libgsl-dev_2.5+dfsg-6_amd64.deb)

Installation
============

To install it using zef (a module management tool):

    $ zef install Math::Libgsl::Matrix

AUTHOR
======

Fernando Santagata <nando.santagata@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2020 Fernando Santagata

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

