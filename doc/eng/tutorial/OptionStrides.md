# Usage of the option strides

How to use the option <code>stride</code> to interpret the buffer as a matrix.

### Standard step width

An object of the class `Matrix` can be created by one of the option sets that specifies the values of the object fields.

```js

var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 3, 2 ],
  inputTransposing : 0,
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +4,
+2, +5,
+3, +6,
*/

console.log( `effective strides :\n${ matrix._stridesEffective }` );
/* log : effective strides :
[ 1, 3 ]
*/

```

The three options are the minimum amount of information that a matrix constructor needs. Data buffer `Buffer`, information about dimensions `dims` and the option `inputTransposing` - information on whether the input data will be transposed.

By default, the elements in the buffer are in the following order:

![StandardStridesInputTransposing0.png](../../img/StandardStridesInputTransposing0.png)

If the value of the option is `inputTransposing : 1`, then the step width will be calculated according to an alternative algorithm.

```js

var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 3, 2 ],
  inputTransposing : 1,
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4,
+5, +6,
*/

console.log( `effective strides :\n${ matrix._stridesEffective }` );
/* log : effective strides :
[ 2, 1 ]
*/

```

If the value of the option is given by `inputTransposing : 1`, then the step width of this example will be `[ 2, 1 ]`:

![StandardStridesInputTransposing1.png](../../img/StandardStridesInputTransposing1.png)

The option `inputTransposing` shows the constructor to calculate the width of the step. Alternatively, it is possible to specify the width of the step explicitly:

```js

var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 3, 2 ],
  strides : [ 2, 1 ],
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4,
+5, +6,
*/

console.log( `effective strides :\n${ matrix._stridesEffective }` );
/* log : effective strides :
[ 2, 1 ]
*/

```

The last example is illustrated by the following diagram.

![StandardExplicitStrides.png](../../img/StandardExplicitStrides.png)

The diagram shows how the buffer maps into the matrix. All scalars follow one by one. By default, `strides` is calculated so that all scalars go one after another. The option `inputTransposing` specifies in which order the dimensions sorts.

Alternatively, one of the [static routines](./MatrixCreation.md) `_.Matrix.Make*` may be used to create the new matrix.

### Non-standard step width

Step widths can have arbitrary values that can be explicitly specified when a matrix creates.

```js
var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 3, 2 ],
  strides : [ 3, 1 ],
  offset : 1,
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+4, +5,
+7, +8,
*/
```

The value of the first element in the option `strides` determines what indentation you need to make to get the next element of a given column. The value of the second element in the option `strides` determines what indentation you need to make to get the next element of the given string.

![NonStandardStrides.png](../../img/NonStandardStrides.png)

The diagram shows how the elements of the matrix are placed in the buffer `buffer`. Buffer offset is one element. `strides` has the value `[ 3, 1 ]`.

### Negative step width

```js
var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 3, 2 ],
  offset : 8,
  strides : [ -2, -1 ],
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+9, +8,
+7, +6,
+5, +4,
*/
```

A negative step width `-2, -1` is given to the matrix `matrix`, it leads to the interpretation of the buffer in the matrix in the opposite direction.

![NegativeStrides.png](../../img/NegativeStrides.png)

The diagram shows how the elements of the matrix are placed in the buffer `buffer`. The matrix has a maximum offset to the element with index 8. The counting of the elements is done in the opposite direction and starts with the last element of the buffer.

### Zero-copy transposing

The matrix can be transposed without moving the data in the matrix buffer. Transposing of a square matrix can only be done by changing the strides width. In the following example, zero-copy transposing of the matrix is shown.

```js
var buffer1 = new I32x( [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 ] );

var matrix = _.Matrix
({
  buffer : buffer1,
  dims : [ 3, 2 ],
  strides : [ 3, 1 ],
  offset : 1,
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+4, +5,
+7, +8,
*/

var matrixTransposed = _.Matrix
({
  buffer : buffer1,
  dims : [ 2, 3 ],
  strides : [ 1, 3 ],
  offset : 1,
});
console.log( `transposed matrix :\n${ matrixTransposed.toStr() }` );
/* log : transposed matrix :
+1, +2, +4,
+5, +7, +9,
*/
```

Both matrices `matrix` and` matrixTransposed` use the same buffer but interpret it differently. The transposing is provided by changing of interpretation of the buffer `buffer1`. The matrix `matrixTransposed` uses another step widths and dimensions, and by it achieves transposing.

This is how the method `matrix.transpose ()` works.

```js
var buffer1 = new I32x( [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 ] );

var matrix = _.Matrix
({
  buffer : buffer1,
  dims : [ 3, 2 ],
  strides : [ 3, 1 ],
  offset : 1,
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+4, +5,
+7, +8,
*/

matrix.transpose();
console.log( `transposed matrix :\n${ matrix.toStr() }` );
/* log : transposed matrix :
+1, +2, +4,
+5, +7, +9,
*/
```

The dimensions and step widths of the matrix `matrix` are changed by the method `matrix.transpose()` in the same way as in the previous example, it has resulted in its transposing.

![ZeroCopyTransposing.png](../../img/ZeroCopyTransposing.png)

The diagram above shows how the buffer is interpreted into the matrix. When changing the widths of steps and dimensions, the matrix is transposed without changing the data in the buffer `buffer1`.

### Submatrices

```js
var matrix = _.Matrix
({
  buffer : [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ],
  dims : [ 4, 3 ],
  offset : 1,
  strides : [ 4, 1 ],
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1,  +2,  +3,
+5,  +6,  +7,
+9,  +10, +11,
+13, +14, +15,
*/

var sub1 = matrix.submatrix( [ 1, 2 ], [ 0, 1 ] );
console.log( `submatrix1 :\n${ sub1.toStr() }` );
/* log : matrix :
+5,  +6,
+9,  +10,
*/

var sub2 = matrix.submatrix( [ 1, 2 ], [ 1, 2 ] );
console.log( `submatrix2 :\n${ sub2.toStr() }` );
/* log : submatrix2 :
+6,  +7,
+10, +11,
*/

sub1.mul( [ sub1, 2 ] );
sub2.mul( [ sub2, 10 ] );
console.log( matrix.toStr() );
/* log : matrix :
+1,  +2,   +3,
+10, +120, +70,
+18, +200, +110,
+13, +14,  +15,
*/
```

![Submatrices.png](../../img/Submatrices.png)

The diagram above shows how two submatrices `sub1` and` sub2` of the same matrix `matrix` can be used independently of each other. The dotted lines show how the matrices are placed in the buffer and the corresponding matrix. All matrices use a single buffer, so common elements of submatrices have increased `20` times.

### Multidimensional matrix

...

[Back to content](../README.md#Tutorials)