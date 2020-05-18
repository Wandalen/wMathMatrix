# Matrix creation

How to create a matrix.

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

The created matrix `matrix` has dimensions `2x2`, what is specified by the argument in the call of static routine.

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

### Static routine `MakeZero`

Creates a matrix from a given dimension, and fills it with zeros.

```js
var matrix = _.Matrix.MakeZero([ 2, 2 ]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.2x2 ::
  +0 +0
  +0 +0
*/
```

The dimension `2x2` is given explicitly by an array.

```js
var matrix = _.Matrix.MakeZero( 2 );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.2x2 ::
  +0 +0
  +0 +0
*/
```

The dimension `2x2` is given explicitly by a scalar.

### Static routine `MakeIdentity`

Let's create an identity matrix from a provided dimension. Diagonal values of such matrix are `1`.

```js
var matrix = _.Matrix.MakeIdentity( [ 2, 3 ] );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.2x3 ::
  +1 +0 +0
  +0 +1 +0
*/
```

The dimension `2x3` is given explicitly by an array.

```js
var matrix = _.Matrix.MakeIdentity( 2 );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.2x2 ::
  +1 +0
  +0 +1
*/
```

The dimension `2x2` is specified explicitly by the scalar.

### Static routine `MakeDiagonal`

Let's create a square matrix with specified diagonal values.

```js
var matrix = _.Matrix.MakeDiagonal( [ 2, 3, 1 ] );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.3x3 ::
  +2 +0 +0
  +0 +3 +0
  +0 +0 +1
*/
```

The dimension `3x3` is deduced from the length of the diagonal that is given as a vector.

### Static routine `MakeCol`

Let's creates a column vector.

```js
var matrix = _.Matrix.MakeCol([ 2, 3 ]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x1 ::
  +2
  +3
*/
```

The static routine `MakeCol` receives a column in a format of vector as an argument. The dimension of the matrix `2x1` is deduced from the length of the column.

```js
var matrix = _.Matrix.MakeCol( 2 );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.2x1 ::
  +0
  +0
*/
```

The length of the column is specified explicitly `2`. The dimensions of the matrix are `2x1`.

### Static routine `MakeRow`

Let's creates a row vector.

```js
var matrix = _.Matrix.MakeRow( [ 2, 3 ] );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.1x2 ::
  +2 +3
*/
```

The static routine `MakeRow` receives a row in a vector format as an argument. The dimension of the matrix `1x2` is deduced from the length of the row.

```js
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.1x2 ::
  +0 +0
*/
```

The length of the row is specified explicitly `2`. The dimensions of the matrix are `1x2`.

### Static routine `FromVector`

Let's creates a column vector from the passed vector. Accepts vector in any format

- vector adapter
- typed buffer
- regular array

```js
var array = [ 1, 2, 3, 4, 5, 6 ];
console.log( `array :\n${ array }` );
/* log : array :
[ 1, 2, 3, 4, 5, 6 ]
*/
var vector = _.vectorAdapter.fromLongLrangeAndStride( array, 1, 3, 2 );
console.log( `vector :\n${ vector }` );
/* log : vector :
VectorAdapter.x3.Array :: 2.000 4.000 6.000
*/

var matrix1 = _.Matrix.FromVector( vector );
console.log( `matrix1 :\n${ matrix1 }` );
/* log : matrix1 :
Matrix.Array.3x1 ::
  +2
  +4
  +6
*/

var matrix2 = _.Matrix.FromVector( array );
console.log( `matrix2 :\n${ matrix2 }` );
/* log : matrix2 :
Matrix.Array.6x1 ::
  +1
  +2
  +3
  +4
  +5
  +6
*/
```

### Static routine `FromScalar`

Creates a matrix with a specified dimension and fills it by the passed value.

```js
var matrix = _.Matrix.FromScalar( 5, [ 2, 2 ] );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.2x2 ::
  +5 +5
  +5 +5
*/
```

The dimension of the matrix `2x2` is given by the 2nd argument.

### Static routine `FromTransformations`

It creates a homogeneous matrix of 3D transformations by rotations, offsets, and scales. Rotations are specified by the quaternion.

```js
var position = [ 1, 2, 3 ];
var quaternion = [ 0, 0, 0, 1 ];
var scale = [ 1, 1, 1 ];
var matrix = _.Matrix.FromTransformations( position, quaternion, scale );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.4x4 ::
  +1 +0 +0 +1
  +0 +1 +0 +2
  +0 +0 +1 +3
  +0 +0 +0 +1
*/
```

Because the offset is the only component with a value different from one, the result is a shift matrix `matrix`.

### Infinity matrix

One of dimensions of the matrix can have infinite value.

```js
var matrix = _.Matrix.Make( [ Infinity, 2 ] ).copy
([
  0, 1,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.Infinityx2 ::
  +0 +1
... ...
*/
```

The matrix `matrix` has an infinite number of rows. That is specified with its dimension and means that the row `0 1` is repeated infinitely many times.

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

[Back to content](../README.md#Tutorials)
