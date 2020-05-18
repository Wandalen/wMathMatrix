# Matrix components

How to get a row, column, element, scalar, or submatrix of a matrix.

### Row

Use the method `rowGet` to get a row of a matrix.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
var row = matrix.rowGet( 0 );
console.log( `first row :\n${ row }` );
/* log : first row :
VectorAdapter.x2.Array :: 1.000 2.000
*/
```

The method `rowGet` returns a row as a vector adapter. This method does not make a copy of data but only provides a link on it.

Use the method `rowSet` to set a row of a matrix.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
matrix.rowSet( 0, [ 4, 3 ] );
console.log( `changed matrix :\n${ matrix }` );
/* log : changed matrix :
Matrix.Array.2x2 ::
  +4 +3
  +3 +4
*/
```

The method `rowSet` expects a vector in any format: an array, a typical array, or a vector adapter.

### Column

Use the method `colGet` to get the column value.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
var row = matrix.colGet( 0 );
console.log( `first column :\n${ row }` );
/* log : first column :
VectorAdapter.x2.Array :: 1.000 3.000
*/
```

The method `colGet` returns a column as a vector adapter. This method does not make a copy of data but only provides a link on it.

Use the method `colSet` to set a value for a column.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
matrix.colSet( 0, 5 );
console.log( `changed matrix :\n${ matrix }` );
/* log : changed matrix :
Matrix.Array.2x2 ::
  +5 +2
  +5 +4
*/
```

The method `colSet` expects a vector in any format: an array, a typical array, or a vector adapter.

### Diagonal

The method `diagonalGet` returns the diagonal of a matrix as a vector.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
var diagonal = matrix.diagonalGet();
console.log( `diagonal of matrix :\n${ diagonal }` );
/* log : diagonal of matrix :
VectorAdapter.x2.Array :: 1.000 4.000
*/
```

The method `diagonalGet` returns the diagonal as a vector adapter. This method does not make a copy of data but only provides a link on it.

Use the method `diagonalSet` to set the diagonal of the matrix.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
matrix.diagonalSet( [ 5, 7 ] );
console.log( `changed matrix :\n${ matrix }` );
/* log : changed matrix :
Matrix.Array.2x2 ::
  +5 +2
  +3 +7
*/
```

Method `diagonalSet` takes the vector [ 5, 7 ] and rewrites the diagonal of the matrix by the vector. If a scalar passed to the method, then the diagonal of the matrix is filled by that scalar.

### Elements

The method `eGet` returns an element of the matrix. An element of a typical 2-dimensional matrix is a column. If the matrix has 3 dimensions, then the element will be a typical 2-dimensional matrix. If the matrix has 4 dimensions, then the element will be a typical 3-dimensional matrix.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
var el = matrix.eGet( 1 );
console.log( `second column of matrix :\n${ el }` );
/* log : second column of matrix :
VectorAdapter.x2.Array :: 2.000 4.000
*/
```

Use the method `eSet` to set the value of a matrix element.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
matrix.eSet( 0, [ 3, 5 ] );
console.log( `changed matrix :\n${ matrix }` );
/* log : changed matrix :
Matrix.Array.2x2 ::
  +3 +2
  +5 +4
*/
```

The element number ( column number ) `0` and the vector to set are passed to the method `eSet`. The vector can be specified as an array, typed array, or adapter vector.

### Scalars

To get access to a scalar with row and column index, use methods `scalarGet` and `scalarSet`.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
var el = matrix.scalarGet([ 0, 1 ]);
console.log( `second element of first row :\n${ el }` );
/* log : second element of first row :
2
*/

matrix.scalarSet( [ 0, 1 ], 5 );
console.log( `changed matrix :\n${ matrix }` );
/* log : changed matrix :
Matrix.Array.2x2 ::
  +1 +5
  +3 +4
*/
```

The methods `scalarGet` and `scalarSet` expect a multidimensional index. In the case of a higher-order matrix, there will be more than two dimensions.

### Submatrices

Use the method `submatrix` to get a submatrix.

```js
var matrix = _.Matrix.MakeSquare
([
  0,  1,  2,  3,
  4,  5,  6,  7,
  8,  9,  10, 11,
  12, 13, 14, 15,
])
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.4x4 ::
  +0 +1 +2 +3
  +4 +5 +6 +7
  +8 +9 +10 +11
  +12 +13 +14 +15
*/
var sub1 = matrix.submatrix( [ 1, 2 ], [ 0, 1 ] );
console.log( `submatrix1 :\n${ sub1 }` );
/* log : submatrix1 :
Matrix.Array.2x2 ::
  +4 +5
  +8 +9
*/
var sub2 = matrix.submatrix( [ 1, 2 ], [ 1, 2 ] );
console.log( `submatrix2 :\n${ sub2 }` );
/* log : submatrix2 :
Matrix.Array.2x2 ::
  +5 +6
  +9 +10
*/
```

The first range selects rows of interest. The second range selects columns of interest. The submatrix `sub1` selects the intersection of rows `1, 2` and columns `0, 1`. The submatrix `sub2` selects the intersection of rows `1, 2` and columns `1, 2`. Submatrices have the common scalars `6` and` 10`.

[Back to content](../README.md#Tutorials)
