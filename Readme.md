# module::MathMatrix [![status](https://github.com/Wandalen/wMathMatrix/actions/workflows/StandardPublish.yml/badge.svg)](https://github.com/Wandalen/wMathMatrix/actions/workflows/StandardPublish.yml) [![stable](https://img.shields.io/badge/stability-stable-brightgreen.svg)](https://github.com/emersion/stability-badges#stable)

Abstract implementation of matrix math. MathMatrix introduces class Matrix, which is a multidimensional structure which, in the most trivial case, is a 2D matrix. A matrix of specific form could also be classified as a vector. MathMatrix heavily relly on MathVector, which introduces VectorAdapter. A Vector adapter is an implementation of the abstract interface, a kind of link that defines how to interpret data as the vector. An adapter is a special object to make algorithms more abstract and to use the same code for very different formats of vector specifying. Use module MathMatrix for arithmetic operations with matrices, to triangulate, permutate or transform matrix, to get a particular or the general solution of a system of linear equations, to get LU, QR decomposition, for SVD or PCA. Also, Matrix is a convenient and efficient data container. You may use it to continuously store multidimensional data.

### Try out from the repository

```
git clone https://github.com/Wandalen/wMathMatrix
cd wMathMatrix
will .npm.install
node sample/trivial/Sample.s
```

Make sure you have utility `willbe` installed. To install willbe: `npm i -g willbe@stable`. Willbe is required to build of the module.

### To add to your project

```
npm add 'wmathmatrix@stable'
```

`Willbe` is not required to use the module in your project as submodule.

### Why?

Because this implementation of linear algebra abstracts algorithms and data thanks smart data structures, minimizing the need to write extensive code and enabling building up more complex systems on top of it. The instance of the matrix does not own data buffer, but only information on how to interpret ( map ) the buffer into K-dimensional space. The matrix, as an advanced link, enables the zero-copy principle. The matrix can be used with either arithmetic purposes or to orchestrate multidimensional data.

Features of this implementation of matrix mathematics are:

- **Cleanliness**: the module does not inject methods, does not contaminate or alter the standard interface.
- **Zero-copy principle**: the module makes it possible to avoid redundant moving of memory thanks to the concept of the adapter.
- **Simplicity**: a regular array or typed buffer could be interpreted as a vector, no need to use special classes.
- **Usability**: the readability and conciseness of the code which uses the module are as important for us as the performance of the module.
- **Flexibility**: it's highly flexible, thanks to strides.
- **Reliability**: the module has good test coverage.
- **Accessibility**: the module has documentation.
- **Functional programming principles**: the module uses some principles of functional programming.
- **Native implementation**: under the NodeJS, it optionally uses binding to the native implementation of [BLAS-like](https://github.com/flame/blis) library ( not ready ).
- **GPGPU** implementation: under the browser, it optionally uses WebGL ( not ready ).
- **Performance**: the optimized build has high performance ( not ready ).

### Concepts of vector and vector adapter

The vector in this module means an ordered set of scalars. The vector is not an object, but an abstraction.

Vector adapter is an abstract interface and its implementation is a kind of link that defines how to interpret data as the vector. The interface of the adapter has many implementations.

To get more details have a look module MathVector.

### Concept of Matrix

Matrix is a rectangular array of numbers, symbols, or expressions, arranged in rows and columns.

By default, matrix has two dimensions. In our implementation matrix might have more than two dimensions.

![Matrix](./doc/img/MatrixConcept.png)

### Static routine `Make`

Let's creates a matrix with specified dimensions.

```js
var matrix = _.Matrix.Make([ 2, 2 ]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.2x2 ::
  +0 +0
  +0 +0
*/
```

The created matrix `matrix` has dimension `2x2`, which is specified by the argument in the call of static routine.

### Explicit constructor

Matrix also could be created by explicitly calling the constructor. To do that, at least 3 options should be specified.

```js
var matrix = new _.Matrix
({
  buffer : [ 1, 2, 3, 4 ],
  dims : [ 2, 2 ],
  inputRowMajor : 1,
});

console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
```

The constructor receives buffer, dimensions, and hint to calculate effective strides. Created matrix `matrix` has dimensions `2х2`, what is specified explicitly.

### Static routine `MakeSquare`

Let's create a square matrix from a passed buffer or a given dimension.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);

console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
```

Static routine `MakeSquare` deduces dimension `2x2` from the length of the vector that is passed as the input.

```js
var matrix = _.Matrix.MakeSquare( 2 );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.2x2 ::
  +0 +0
  +0 +0
*/
```

The dimension `2x2` is given by the scalar` 2`. Scalar is sufficient to deduce dimensions because the created matrix is square.

### Standard strides

An object of the class `Matrix` could be created by an explicit call of the constructor.

```js
var matrix = new _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 3, 2 ],
  inputRowMajor : 0,
});

console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.3x2 ::
  +1 +4
  +2 +5
  +3 +6
*/

console.log( `effective strides :\n${ matrix.stridesEffective }` );
/* log : effective strides :
[ 1, 3 ]
*/
```

Three options are the minimum amount of information required to call the matrix constructor. Data buffer `buffer`, information about dimensions `dims`, and the option `inputRowMajor` - hints on whether the input data will be transposed.

By default, the elements in the buffer are in such sequence:

![StandardStridesInputRowMajor0.png](doc/img/StandardStridesInputRowMajor0.png)

Option `inputRowMajor : 1` alter algorithm of strides calculation.

```js
var matrix = new _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 3, 2 ],
  inputRowMajor : 1,
});

console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.3x2 ::
  +1 +2
  +3 +4
  +5 +6
*/

console.log( `effective strides :\n${ matrix.stridesEffective }` );
/* log : effective strides :
[ 2, 1 ]
*/
```

With `inputRowMajor : 1` strides are `[ 2, 1 ]`, instead of `[ 1, 2 ]` of the previous example. Sequence looks like that:

![StandardStridesInputRowMajor1.png](doc/img/StandardStridesInputRowMajor1.png)

The option `inputRowMajor` shows the constructor to calculate strides. Alternatively, it is possible to specify strides explicitly:

```js
var matrix = new _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 3, 2 ],
  strides : [ 2, 1 ],
});

console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.3x2 ::
  +1 +2
  +3 +4
  +5 +6
*/

console.log( `effective strides :\n${ matrix.stridesEffective }` );
/* log : effective strides :
[ 2, 1 ]
*/
```

Unlike the previous example, strides in this example are specified explicitly, but the result is the same.

![StandardExplicitStrides.png](doc/img/StandardExplicitStrides.png)

The diagram shows how the buffer maps into the matrix. All scalars follow one by one. By default, `strides` are calculated so that all scalars go one after another. The option `inputRowMajor` specifies in which sequence row and column go.

Alternatively, one of the [static routines](doc/eng/tutorial/MatrixCreation.md) `_.Matrix.Make*` may be used to create a matrix.

### Non-standard strides

The value of strides could be specified during construction.

```js
var matrix = new _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 3, 2 ],
  strides : [ 3, 1 ],
  offset : 1,
});

console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.3x2 ::
  +1 +2
  +4 +5
  +7 +8
*/
```

The value of the first element in the option `strides` determines what offset to make to get the next scalar of the given column. The value of the second element in the option `strides` determines what offset to make to get the next scalar of the given string.

![NonStandardStrides.png](doc/img/NonStandardStrides.png)

The diagram shows how scalars of the matrix are put in the buffer `buffer`. Buffer offset is `1`. `strides` has the value `[ 3, 1 ]`.

### Negative strides

```js
var matrix = new _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 3, 2 ],
  offset : 8,
  strides : [ -2, -1 ],
});

console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.3x2 ::
  +9 +8
  +7 +6
  +5 +4
*/
```

A negative strides `-2, -1` is given to the matrix `matrix`, it leads to the interpretation of the buffer in the matrix in the opposite direction.

![NegativeStrides.png](doc/img/NegativeStrides.png)

The diagram shows how the scalars of the matrix are put in the buffer `buffer`. The offset is `8`. Elements in the buffer are reversed.

### Zero-copy transposing

The matrix can be transposed without copying. It is possible to transpose a matrix by changing only strides. Example demonstrate zero-copy transposing of a matrix.

```js
var buffer1 = new I32x( [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 ] );

var matrix = new _.Matrix
({
  buffer : buffer1,
  dims : [ 3, 2 ],
  strides : [ 3, 1 ],
  offset : 1,
});

console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.I32x.3x2 ::
  +1 +2
  +4 +5
  +7 +8
*/

var matrixTransposed = new _.Matrix
({
  buffer : buffer1,
  dims : [ 2, 3 ],
  strides : [ 1, 3 ],
  offset : 1,
});

console.log( `transposed matrix :\n${ matrixTransposed }` );
/* log : transposed matrix :
Matrix.I32x.2x3 ::
  +1 +4 +7
  +2 +5 +8
*/
```

Both matrices `matrix` and` matrixTransposed` use the same buffer but interpret it differently. The transposing is made by changing of interpretation of the buffer `buffer1`. The matrix `matrixTransposed` uses other strides and dimensions. That's how transposing is achieved without copying data.

That is how the method `matrix.transpose()` works.

```js
var buffer1 = new I32x([ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 ]);

var matrix = new _.Matrix
({
  buffer : buffer1,
  dims : [ 3, 2 ],
  strides : [ 3, 1 ],
  offset : 1,
});

console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.I32x.3x2 ::
  +1 +2
  +4 +5
  +7 +8
*/

matrix.transpose();

console.log( `transposed matrix :\n${ matrix }` );
/* log : transposed matrix :
Matrix.I32x.2x3 ::
  +1 +4 +7
  +2 +5 +8
*/
```

The dimensions and strides of the matrix `matrix` are changed by the method `matrix.transpose()` in the same way as in the previous example as the result matrix is transposed.

![ZeroCopyTransposing.png](doc/img/ZeroCopyTransposing.png)

The diagram above shows how the buffer is interpreted into the matrix. When changing strides and dimensions, the matrix is transposed without changing the data in the buffer `buffer1`.

### Submatrices

```js
var matrix = new _.Matrix
({
  buffer : [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ],
  dims : [ 4, 3 ],
  offset : 1,
  strides : [ 4, 1 ],
});

console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.4x3 ::                                                                                                                                                    [10/
  +1 +2 +3
  +5 +6 +7
  +9 +10 +11
  +13 +14 +15
*/

var sub1 = matrix.submatrix( [ 1, 2 ], [ 0, 1 ] );

console.log( `submatrix1 :\n${ sub1 }` );
/* log : submatrix1 :
Matrix.Array.2x2 ::
  +5 +6
  +9 +10
*/

var sub2 = matrix.submatrix( [ 1, 2 ], [ 1, 2 ] );

console.log( `submatrix2 :\n${ sub2 }` );
/* log : submatrix2 :
Matrix.Array.2x2 ::
  +6 +7
  +10 +11
*/

sub1.mul( [ sub1, 2 ] );
sub2.mul( [ sub2, 10 ] );

console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.4x3 ::
  +1 +2 +3
  +10 +120 +70
  +18 +200 +110
  +13 +14 +15
*/
```

![Submatrices.png](doc/img/Submatrices.png)

The diagram above shows how two submatrices `sub1` and `sub2` of the same matrix `matrix` can be used independently of each other. Matrices do not own data buffer but refer to it. The dotted lines show how the matrices are put in the buffer and the corresponding matrix. All matrices use the same buffer, so common scalars of submatrices have increased `20` times.

### Multidimensional matrix

To create a multidimensional matrix, specify additional dimensions.

```js
var matrix3d = _.Matrix.Make([ 2, 3, 4 ]).copy
([
  1,  2,  3,
  4,  5,  6,
  7,  8,  9,
  10, 11, 12,
  13, 14, 15,
  16, 17, 18,
  19, 20, 21,
  22, 23, 23,
]);

console.log( `3D matrix :\n${ matrix3d }` );
/* log : 3D matrix :
Matrix.F32x.2x3x4 ::
  Layer 0
    +1 +2 +3
    +4 +5 +6
  Layer 1
    +7 +8 +9
    +10 +11 +12
  Layer 2
    +13 +14 +15
    +16 +17 +18
  Layer 3
    +19 +20 +21
    +22 +23 +23
*/
```

An element of a 3D matrix is a 2D matrix. The output shows that matrix `matrix3d` has 4 submatrices `Matrix-0`, `Matrix-1`, `Matrix-2`, `Matrix-3`, with dimensions `2x3` each.

### Performing of a simple operation

Matrix operations are performed by calling methods or static routines.

```js
var matrix = _.Matrix.Make([ 3, 3 ]).copy
([
  1, 2, 3,
  4, 5, 6,
  7, 8, -9
]);
var result = matrix.determinant();
console.log( `determinant : ${ result }` );
/* log : determinant : 54 */
```

The method `determinant` calculates the determinant of the matrix.

### Transposing of a matrix using the method `transpose`

The matrix can be transposed using the method `transpose`.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);

console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/

matrix.transpose();
console.log( `transposed matrix :\n${ matrix }` );
/* log : transposed matrix :
Matrix.Array.2x2 ::
  +1 +3
  +2 +4
*/
```

### Multiplication of multiple matrices

The static routine `Mul` can multiply several matrices at a time.

```js
var matrix1 = _.Matrix.Make([ 2, 3 ]).copy
([
  1, 2, -3,
  3, 4, -2,
]);

var matrix2 = _.Matrix.Make([ 3, 2 ]).copy
([
  4,  3,
  2,  1,
  -1, -2,
]);

var matrix3 = _.Matrix.MakeCol
([
  -4,
  5,
]);

var dst = _.Matrix.Mul( null, [ matrix1, matrix2, matrix3 ] );

console.log( `dst :\n${ dst }` );
/* log : dst :
Matrix.Array.2x1 ::
  +11
  -3
*/
```

The order of matrices of the array corresponds to the order of multiplication. The matrices are multiplied one by one. Since the first argument has a `null` value, a new container `dst` is created to adopt the result. Container `dst` is returned as the result of executing a routine. Nor `matrix1` neither `matrix2`, `matrix3` is changed.

### Matrices comparison

Matrices can be compared using routines `_.identical` and `_.equivalent`. The routine `_.identical` performs a strict comparison, and `_.equivalent` compares loosely.

The difference between the routines for comparison:
- `_.identical` compares container type.
- `_.identical` compares the type of buffer.
- `_.equivalent` compares with some accuracy.

### Comparison of two matrices

```js
var matrix1 = _.Matrix.MakeSquare
([
  +1, -5,
  -3, +4,
]);

var matrix2 = _.Matrix.MakeSquare
([
  +1, -5,
  -3, +4,
]);

var identical = _.identical( matrix1, matrix2 );
console.log( `identical : ${ identical }` );
/* log : identical : true */

var equivalent = _.equivalent( matrix1, matrix2 );
console.log( `equivalent : ${ equivalent }` );
/* log : equivalent : true */
```

Both matrices have the same buffers, dimensions, and element values, so both routines `_.identical` and `_.equivalent` return `true`.

### Solving of a system of linear equations

Solving of a system with two linear equations.

```
1*x1 - 2*x2 = -7;
3*x1 + 4*x2 = 39;
```

In compact form:

```
A*x = y
```

Let's use the static routine `Solve` to find unknown values.

```js

var A = _.Matrix.MakeSquare
([
  1, -2,
  3,  4
]);
var y = [ -7, 39 ];
var x = _.Matrix.Solve( null, A, y );

console.log( `x :\n${ x }` );
/* log : x : [ 5, 6 ] */

```

Routine `Solve` found the solution of a system of linear equations specified by matrix `A` and vector `y`. Value of `x1` is `5`, a value of `x2` is `6`.
