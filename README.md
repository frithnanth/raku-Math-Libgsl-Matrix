[![Build Status](https://travis-ci.org/frithnanth/raku-Math-Libgsl-Matrix.svg?branch=master)](https://travis-ci.org/frithnanth/raku-Math-Libgsl-Matrix)

NAME
====

Math::Libgsl::Matrix Math::Libgsl::Vector - An interface to libgsl, the Gnu Scientific Library - Vector and matrix algebra.

SYNOPSIS
========

```perl6
use Math::Libgsl::Raw::Matrix :ALL;

use Math::Libgsl::Vector;
use Math::Libgsl::Matrix;
```

DESCRIPTION
===========

Math::Libgsl::Matrix provides an interface to the vector and matrix algebra functions of libgsl - the GNU Scientific Library.

This package provides both the low-level interface to the C library (Raw) and a more comfortable interface layer for the Raku programmer.

This module comes with two classes, Vector and Matrix, available in 12 data types, so it offers 24 classes:

  * Math::Libgsl::Vector - default, corresponding to a Math::Libgsl::Vector::Num

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

  * Math::Libgsl::Matrix - default, corresponding to a Math::Libgsl::Matrix::Num

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

All the following methods are available for every class, except where noted.

### new(Int $size1!, Int $size2!)

### new(Int :$size1!, Int :$size2!)

The constructor accepts two parameters: the matrix's sizes; they can be passed as Pairs or as a single values.

### get(Int:D $i! where * < $!matrix.size1, Int:D $j! where * < $!matrix.size2 --> Num)

This method returns the value of a matrix's element. It is possible to address a matrix element as a Raku shaped array element:

    say $matrix[1;2];

### set(Int:D $i! where * < $!matrix.size1, Int:D $j! where * < $!matrix.size2, Num(Cool)

This method sets the value of a matrix's element. This method can be chained. It is possible to address a matrix element as a Raku shaped array element:

    $matrix[1;3] = 3;

### setall(Num(Cool))

Sets all the elements of the matrix to the same value. This method can be chained.

### zero()

Sets all the elements of the matrix to zero. This method can be chained.

### identity()

Sets all elements of the matrix to the corrisponding elements of the identity matrix.

### write(Str $filename!)

Writes the matrix to a file in binary form. This method can be chained.

### read(Str $filename!)

Reads the matrix from a file in binary form. This method can be chained.

### printf(Str $filename!, Str $format!)

Writes the matrix to a file using the specified format. This method can be chained.

### scanf(Str $filename!)

Reads the matrix from a file containing formatted data. This method can be chained.

### submatrix(size_t $k1 where * < $!matrix.size1, size_t $k2 where * < $!matrix.size2, size_t $n1, size_t $n2)

Creates a view on a subset of the matrix, starting from coordinates ($k1, $k2) with $n1 rows and $n2 columns. This method returns a new Matrix object. Any operation done on this view affects the original matrix as well.

### mat-view-array(@array where { @array ~~ Array && @array.shape.elems == 2 })

This is not a method, but a sub. It creates a Matrix object from the Raku shaped array.

### mat-view-array-tda(@array where { @array ~~ Array && @array.shape.elems == 2 }, size_t $tda)

This is not a method, but a sub. It creates a Matrix object from the Raku array, with a physical number of columns $tda which may differ from the correspondig dimension of the matrix.

### mat-view-vector(Math::Libgsl::Vector $v, size_t $n1, size_t $n2)

This is not a method, but a sub. It creates a Matrix object from a Vector object. The resultimg matrix will have $n1 rows and $n2 columns.

### mat-view-vector-tda(Math::Libgsl::Vector $v, size_t $n1, size_t $n2, size_t $tda)

This is not a method, but a sub. It creates a Matrix object from a Vector object, with a physical number of columns $tda which may differ from the correspondig dimension of the matrix. The resultimg matrix will have $n1 rows and $n2 columns.

### row-view(size_t $i where * < $!matrix.size1)

This method creates a Vector object from row $i of the matrix.

### col-view(size_t $j where * < $!matrix.size2)

This method creates a Vector object from column $j of the matrix.

### subrow-view(size_t $i where * < $!matrix.size1, size_t $offset, size_t $n)

This method creates a Vector object from row $i of the matrix, starting from $offset and containing $n elements.

### subcol-view(size_t $j where * < $!matrix.size2, size_t $offset, size_t $n)

This method creates a Vector object from column $j of the matrix, starting from $offset and containing $n elements.

### diagonal-view()

This method creates a Vector object from the diagonal of the matrix.

### subdiagonal-view(size_t $k where * < min($!matrix.size1, $!matrix.size2))

This method creates a Vector object from the subdiagonal number $k of the matrix.

### superdiagonal-view(size_t $k where * < min($!matrix.size1, $!matrix.size2))

This method creates a Vector object from the superdiagonal number $k of the matrix.

### copy(Math::Libgsl::Matrix $src where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2)

This method copies the $src matrix into the current one. This method can be chained.

### swap(Math::Libgsl::Matrix $src where $!matrix.size1 == .matrix.size1 && $!matrix.size2 == .matrix.size2)

This method swaps elements of the $src matrix and the current one. This method can be chained.

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

C Library Documentation
=======================

For more details on libgsl see [https://www.gnu.org/software/gsl/](https://www.gnu.org/software/gsl/). The excellent C Library manual is available here [https://www.gnu.org/software/gsl/doc/html/index.html](https://www.gnu.org/software/gsl/doc/html/index.html), or here [https://www.gnu.org/software/gsl/doc/latex/gsl-ref.pdf](https://www.gnu.org/software/gsl/doc/latex/gsl-ref.pdf) in PDF format.

Prerequisites
=============

This module requires the libgsl library to be installed. Please follow the instructions below based on your platform:

Debian Linux
------------

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

