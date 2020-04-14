# Matrix operations

Overview of operations on matrices.

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
console.log( `determinant :\n${ result }` );
/* log : determinant :
54
*/
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
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4,
*/

matrix.transpose();
console.log( `transposed matrix :\n${ matrix.toStr() }` );
/* log : transposed matrix :
+1, +3,
+2, +4,
*/
```

### Multiplying a matrix by a scalar

The matrix can be multiplied by a scalar using the static routine `Mul`. Each value of the matrix will be increased in an appropriate number of times. The routine places the result of the operation in the container `dst`. If `dst` is set to `null`, then the result is placed in the new container.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);

var dst = _.Matrix.Mul( null, [ matrix, 3 ] );
console.log( `dst :\n${ dst.toStr() }` );
/* log : dst :
+3, +6,
+9, +12,
*/
```

The static routine `Mul` multiplies the matrix` matrix` by the scalar `3`. Since the first argument has a `null` value, a new container` dst` is created, and it returns as a result of executing a routine.

Alternatively, instead of a static routine, it is possible to call the object method.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);

matrix.mul( 3 );
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+3, +6,
+9, +12,
*/
```

Method `mul`, multiplies matrix `matrix` by scalar `3`. The result is written to the `matrix`.

### Multiply the matrix by a vector

Example of matrix multiplication by a vector.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);
var vector = [ 1, 1 ];

var dst = _.Matrix.Mul( null, [ matrix, vector ] );
console.log( `dst :\n${ dst }` );
/* log : dst :
[ 3, 7 ]
*/
```

The static routine `Mul` multiplies the matrix` matrix` by the vector `vector`. Since the first argument has a `null` value, a new container` dst` is created to contain the result, and it returns as a result of executing a routine.

Alternatively, an instance of the class can be multiplied by a vector using the method `matrix1pplyTo`.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);
var vector = [ 1, 1 ];

matrix.matrixApplyTo( vector );
console.log( `vector :\n${ vector }` );
/* log : vector :
[ 3, 7 ]
*/
```

The `mul` method multiplies the matrix `matrix` by the vector `vector`. The result is written to the vector `vector`.

### Multiplication of two matrices

Multiple matrices can be multiplied with the static `Mul` routine.

```js
var matrix1 = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);
var matrix2 = _.Matrix.MakeSquare
([
  4, 3,
  2, 1
]);

var dst = _.Matrix.Mul( null, [ matrix1, matrix2 ] );
console.log( `dst :\n${ dst.toStr() }` );
/* log : dst :
+8,  +5,
+20, +13,
*/
```

The static routine `Mul` multiplies the matrix` matrix1` by the matrix `matrix2`. Since the first argument has a `null` value, a new container` dst` is created to contain the result, and it returns as a result of executing a routine.

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
console.log( `dst : ${ dst.toStr() }` );
/* log : dst :
+11
-3
*/
```

The order of recorded matrices in the array corresponds to the order of multiplication. The matrices are multiplied one by one. Since the first argument has a `null` value, a new container` dst` is created to contain the result, and it returns as a result of executing a routine. None of the matrices `matrix1`, `matrix2`, `matrix3` are changed.

[Back to content](../README.md#Tutorials)
