# Matrices comparison

Instruments to compare matrices.

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

### Comparison matrices with different strides

Strides do not affect the result of the matrix comparison.

```js
var buffer1 = new F32x
([
  1, 2,
  3, 4,
]);
var matrix1 = new _.Matrix
({
  buffer : buffer1,
  dims : [ 2, 2 ],
  strides : [ 2, 1 ],
});

var buffer2 = new F32x
([
  0, 1, 2, 3,
  3, 4, 5, 0,
]);
var matrix2 = new _.Matrix
({
  buffer : buffer2,
  dims : [ 2, 2 ],
  strides : [ 3, 1 ],
  offset : 1,
});

var identical = _.identical( matrix1, matrix2 );
console.log( `identical : ${ identical }` );
/* log : identical : true*/

var equivalent = _.equivalent( matrix1, matrix2 );
console.log( `equivalent : ${ equivalent }` );
/* log : equivalent : true */
```

Routines `_.identical` and` _.equivalent` compare the values of the matrix and both return `true`. As can be seen, the values of such fields as `strides` and` offset` are ignored by both routines for comparison.

### Comparison the matrices with buffers of different types

```js
var buffer1 = new I32x
([
  +1, -5,
  -3, +4,
]);
var matrix1 = new _.Matrix
({
  buffer : buffer1,
  dims : [ 2, 2 ],
  inputRowMajor : 1,
});

var buffer2 = new F32x
([
  +1, -5,
  -3, +4,
]);
var matrix2 = new _.Matrix
({
  buffer : buffer2,
  dims : [ 2, 2 ],
  inputRowMajor : 1,
});

var identical = _.identical( matrix1, matrix2 );
console.log( `identical : ${ identical }` );
/* log : identical : false */

var equivalent = _.equivalent( matrix1, matrix2 );
console.log( `equivalent : ${ equivalent }` );
/* log : equivalent : true */
```

No difference in values of matrices, their dimension, the way buffer is interpreted. The only difference is the types of buffers. The routine `_.identical` compares both the values of the matrix and the types of buffers. The routine `_.identical` returns `false`. The routine `_.equivalent` compares only values of matrices and ignores types of buffers. It returns `true`.

### Comparison of vector and matrix

A column vector can be compared to a vector in the format of either array or typed array.

```js
var matrixCol = _.Matrix.MakeCol
([
  1,
  2,
  3
]);

var vector = [ 1, 2, 3 ];

var identical = _.identical( matrixCol, vector );
console.log( `identical : ${ identical }` );
/* log : identical : false */

var equivalent = _.equivalent( matrixCol, vector );
console.log( `equivalent : ${ equivalent }` );
/* log : equivalent : true */
```

The strict comparison of the vector `matrixCol` in the matrix format and vector `vector` in the array format returns `false` because formats are different. The routine `_.equivalent` shows that both vectors are similar, ignoring the difference in formats.

### Comparison with a given accuracy

If the deviation of float value does have a place to be, then the strict comparison is not the right way. Routine `_.equivalent` compares with some accuracy. Routine `_.equivalent` makes it possible to explicitly specify the accuracy of the comparison.

```js
var matrix1 = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);

var matrix2 = _.Matrix.MakeSquare
([
  1, 2,
  3, 4.001
]);

var equivalent = _.equivalent( matrix1, matrix2 );
console.log( `result of comparison with standard accuracy : ${ equivalent }` );
/* log : result of comparison with standard accuracy : false */

var equivalent = _.equivalent( matrix1, matrix2, { accuracy : 0.01 } );
console.log( `result of comparison with accuracy 0.01 : ${ equivalent }` );
/* log : result of comparison with non-standard accuracy :true */
```

The matrices `matrix1` and` matrix2` differ only in the last scalar by `0.001`. When it's compared with the standard accuracy of `1e-7`, the check fails. Calling routine `_.equivalent` with accuracy set to `0.01` returns `true`.

[Back to content](../README.md#Tutorials)
