# Matrix comparing

Methods and rules for comparing matrices are described.

The matrices can be compared using the routines `_.identical` and `_.equivalent`. The routine `_.identical` performs a strict comparison, and `_.equivalent` does not compare strictly.

The difference between the routines for comparison:
- `_.identical` compares container type.
- `_.identical` compares the type of buffer.
- `_.equivalent` compares with some accuracy.

### Comparing of two matrices

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

Both matrices have the same buffers, dimensions and element values, so the routines `_.identical` and `_.equivalent` return `true`.

### Comparing matrices with different strides widths

The width of the strides does not affect the result of the matrix comparison.

```js
var buffer1 = new F32x
([
  1, 2,
  3, 4,
]);
var matrix1 = _.Matrix
({
  buffer : buffer1,
  dims : [ 2, 2 ],
  strides : [ 2, 1  ],
});

var buffer2 = new F32x
([
  0, 1, 2, 3,
  3, 4, 5, 0,
]);

var matrix2 = _.Matrix
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

The routines `_.identical` and` _.equivalent` compare the values of the matrix and both return `true`. As can be seen, the values of such fields as `strides` and` offset` are ignored.

### Comparing the matrices with buffers of different types

```js
var buffer1 = new I32x
([
  +1, -5,
  -3, +4,
]);
var matrix1 = _.Matrix
({
  buffer : buffer1,
  dims : [ 2, 2 ],
  inputTransposing : 1,
});

var buffer2 = new F32x
([
  +1, -5,
  -3, +4,
]);
var matrix2 = _.Matrix
({
  buffer : buffer2,
  dims : [ 2, 2 ],
  inputTransposing : 1,
});
var identical = _.identical( matrix1, matrix2 );
console.log( `identical : ${ identical }` );
/* log : identical : false */

var equivalent = _.equivalent( matrix1, matrix2 );
console.log( `equivalent : ${ equivalent }` );
/* log : equivalent : true */
```

The values of the matrices, their dimension, the order of interpretation of the buffer are the same, only the types of buffers differ. The routine `_.identical` compares both the values of the matrix and the types of buffers, its result is `false`. The routine `_.equivalent` compares only the values of matrices, its result is` true`.

### Comparing of vector and matrix

A column vector can be compared to a vector in an array or typed array format.

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

A strict comparing of the vector `matrixCol` in the matrix format and vector `vector` in the array format returns `false` because the types of the vectors are different. The routine `_.equivalent` shows that both vectors are similar, ignoring the difference in formats.

### Comparing with a given accuracy

In calculations that allow deviations, use routine `_.equivalent`. Using the `_.equivalent` routine allows setting the accuracy of the comparing.

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

The matrices `matrix1` and` matrix2` differ only in the last scalar by `0.01`. When it compared to the standard deviation of `1e-7`, the check failed, and when setting lower accuracy `0.01`, the routine `_.equivalent` returned `true`.

[Back to content](../README.md#Tutorials)

