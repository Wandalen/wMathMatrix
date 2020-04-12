# Matrix creation

How to create a matrix.

### Static routine `Make`

Creates a matrix from specified dimension.

```js
var matrix = _.Matrix.Make([ 2, 2 ]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+0, +0,
+0, +0,
*/
```

The created matrix `matrix` has dimension `2x2`, it is specified by the argument in the call of static routine.

### Static routine `MakeSquare`

Creates a square matrix from a passed buffer or a given dimension.

```js
var matrix1 = _.Matrix.MakeSquare([ 2, 2, 3, 3 ]);
console.log( `matrix :\n${ matrix1.toStr() }` );
/* log : matrix :
+2, +2,
+3, +3,
*/
```

Static routine `MakeSquare` is deduces dimension `2x2` from the length of the vector that is passed to the input.

```js
var matrix2 = _.Matrix.MakeSquare( 2 );
console.log( `matrix :\n${ matrix2.toStr() }` );
/* log : matrix :
+0, +0,
+0, +0,
*/
```

The dimension `2x2` is given by the scalar` 2`. Since the created matrix is square, then the scalar is sufficient.

### Static routine `MakeZero`

Creates a matrix from a given dimension, and fills it with zeros.

```js
var matrix = _.Matrix.MakeZero([ 2, 2 ]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+0, +0,
+0, +0,
*/
```

The dimension `2x2` is given explicitly by an array.

```js
var matrix = _.Matrix.MakeZero( 2 );
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+0, +0,
+0, +0,
*/
```

The dimension `2x2` is given explicitly by a scalar.

### Static routine `MakeIdentity`

Creates an identity matrix from a provided dimension. Diagonal values of such matrix are `1`.

```js
var matrix = _.Matrix.MakeIdentity( [ 2, 3 ] );
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +0, +0,
+0, +1, +0,
*/
```

The dimension `2x3` is given explicitly by an array.

```js
var matrix = _.Matrix.MakeIdentity( 2 );
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +0,
+0, +1,
*/
```

The dimension `2x2` is given explicitly by a scalar.

### Static routine `MakeDiagonal`

Creates a square matrix with specified diagonal values.

```js
var matrix = _.Matrix.MakeDiagonal( [ 2, 3, 1 ] );
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+2, +0, +0,
+0, +3, +0,
+0, +0, +1,
*/
```

The dimension `3x3` is deduced from the length of the diagonal that is given as vector.

### Static routine `MakeCol`

Creates a column vector.

```js
var matrix = _.Matrix.MakeCol([ 2, 3 ]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+2,
+3,
*/
```

The static routine `MakeCol` receives a column in the vector format as an argument. The dimension of the matrix `2x1` is deduced from the length of the column.

```js
var matrix = _.Matrix.MakeCol( 2 );
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+0,
+0,
*/
```

The length of the column is specified explicitly `2`, the dimension of the matrix `2x1`.

### Static routine `MakeRow`

Creates a row vector.

```js
var matrix = _.Matrix.MakeRow( [ 2, 3 ] );
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+2, +3,
*/
```

The static routine `MakeRow` receives a row in the vector format as an argument. The dimension of the matrix `1x2` is deduced from the length of the row.

```js
var matrix = _.Matrix.MakeRow( 2 );
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+0, +0,
*/
```

The length of the row is specified explicitly `2`, the dimension of the matrix `2x1`.

### Static routine `FromVector`

Creates a column vector from the passed vector. Accepts vector in any format

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
console.log( `vector :\n${ vector.toStr() }` );
/* log : vector :
2.000, 4.000, 6.000
*/

var matrix1 = _.Matrix.FromVector( vector );
console.log( `matrix1 :\n${ matrix1.toStr() }` );
/* log : matrix1 :
+1,
+3,
+5,
*/

var matrix2 = _.Matrix.FromVector( array );
console.log( `matrix2 :\n${ matrix2.toStr() }` );
/* log : matrix2 :
+1,
+2,
+3,
+4,
+5,
+6,
*/
```

### Static routine `FromScalar`

Creates a matrix from a given dimension and fills it by the passed value.

```js
var matrix = _.Matrix.FromScalar( 5, [ 2, 2 ] );
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+5, +5,
+5, +5
*/
```

The dimension of the matrix `2x2` is given by the 2nd argument.

### Static routine `FromTransformations`

It creates a homogeneous matrix of 3D transformations by pivots, offsets, and scales. Pivots are given by a quaternion.

```js
var position = [ 1, 2, 3 ];
var quaternion = [ 0, 0, 0, 1 ];
var scale = [ 1, 1, 1 ];
var matrix = _.Matrix.FromTransformations( position, quaternion, scale );
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +0, +0, +1,
+0, +1, +0, +2,
+0, +0, +1, +3,
+0, +0, +0, +1,
*/
```

Since the offset is the only component with a value different from one, the result is a shift matrix `matrix`.

[Back to content](../README.md#Tutorials)
