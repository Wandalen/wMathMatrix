# Matrix elements

How to get a row, column, element, scalar, or submatrix of a particular matrix.

### How to work with row

Use the method `rowGet` to get the string value.

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
var row = matrix.rowGet( 0 );
console.log( `first row :\n${ row.toStr() }` );
/* log : first row :
1.000, 2.000
*/
```

The method `rowGet` returns a row as a vector adapter, not by copying data, but only by providing link to it.

Use the method `rowSet` to set a value for a row.

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
matrix.rowSet( 0, [ 4, 3 ] );
console.log( `changed matrix :\n${ matrix.toStr() }` );
/* log : changed matrix :
+1, +2,
+4, +3,
*/
```

The method `rowSet` expects a vector in any format: an array, a typical array, or a vector adapter.

### How to work with column

Use the method `colGet` to get the column value.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4
*/
var row = matrix.colGet( 0 );
console.log( `first column :\n${ row.toStr() }` );
/* log : first column :
1.000, 3.000 */
```

The method `colGet` returns a column as a vector adapter, not by copying data, but only by providing link to it.

Use the method `colSet` to set a value for a column.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4
*/
matrix.colSet( 0, 5 );
console.log( `changed matrix :\n${ matrix.toStr() }` );
/* log : changed matrix :
+5, +2,
+5, +4
*/
```

The method `colSet` expects a vector in any format: an array, a typical array, or a vector adapter.

### How to get or set a value of scalar

To get access to a scalar element by its row and column index, the methods `scalarGet` and` scalarSet` are used.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4
*/

var el = matrix.scalarGet([ 0, 1 ]);
console.log( `second element of first row :\n${ el }` );
/* log : second element of first row :
2
*/

matrix.scalarSet( [ 0, 1 ], 5 );
console.log( `changed matrix :\n${ matrix.toStr() }` );
/* log : changed matrix :
+1, +5,
+3, +4
*/
```

The methods `scalarGet` and `scalarSet` expect a multidimensional index. In the case of a higher-order matrix, there will be more than two dimensions.

### How to get or set the value of an row element

The method `eGet` returns an element of the matrix. An element of a typical 2-dimensional matrix is a column. If the matrix has 3 dimensions, then the element will be a typical 2-dimensional matrix. If the matrix has 4 dimensions, then the element will be a typical 3-dimensional matrix.

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
var el = matrix.eGet( 1 );
console.log( `the second column of matrix :\n${ el.toStr() }` );
/* log : the second column of matrix :
2.000, 4.000
*/
```

Use the method `eSet` to set the value of a matrix element.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4
*/
matrix.eSet( 0, [ 3, 5 ] );
console.log( `changed matrix :\n${ matrix.toStr() }` );
/* log : changed matrix :
+3, +2,
+5, +4
*/
```

The element number ( column number ) `0` and the vector of new values are passed to the method `eSet`. The vector can be specified as an array, typed array, or adapter vector.

### How to get or set a diagonal

The method `diagonalGet` returns a vector from the diagonal of a matrix.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4,
*/
var diagonal = matrix.diagonalGet();
console.log( `diagonal of matrix :\n${ diagonal.toStr() }` );
/* log : diagonal of matrix :
1.000, 4.000
*/
```

Use the method `diagonalSet` to set the diagonal of the matrix.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4,
*/
matrix.diagonalSet([ 5, 7 ]);
console.log( `changed matrix :\n${ matrix.toStr() }` );
/* log : changed matrix :
+5, +2,
+3, +7,
*/
```

The vector passes in the method `diagonalSet`, it writes as the diagonal of the matrix. When a scalar passes, the diagonal of the matrix fills with the value of that scalar.

### How to get a submatrix

Use the method `submatrix` to get a submatrix.

```js
var buffer =
[
  0,  1,  2,  3,
  4,  5,  6,  7,
  8,  9,  10, 11,
  12, 13, 14, 15,
];
var matrix = _.Matrix
({
  buffer : buffer,
  dims : [ 4, 3 ],
  offset : 1,
  strides : [ 4, 1 ]
})
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1,  +2,  +3,
+5,  +6,  +7,
+9,  +10, +11,
+13, +14, +15,
*/
var sub1 = matrix.submatrix( [ 1, 2 ], [ 0, 1 ] );
console.log( `submatrix1 :\n${ sub1.toStr() }` );
/* log : submatrix1 :
+5, +6,
+9, +10,
*/
var sub2 = matrix.submatrix( [ 1, 2 ], [ 1, 2 ] );
console.log( `submatrix2 :\n${ sub2.toStr() }` );
/* log : submatrix2 :
+6,  +7,
+10, +11,
*/
```

The first range selects the desired rows, the second selects the columns. The submatrix `sub1` selects the intersection of rows `1, 2` and columns `0, 1` inclusive. The submatrix `sub2` selects the intersection of rows `1, 2` and columns `1, 2`. Submatrices have the common elements `6` and` 10`.

[Back to content](../README.md#Tutorials)
