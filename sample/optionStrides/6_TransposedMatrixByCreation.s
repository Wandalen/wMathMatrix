let _ = require( 'wmathmatrix' );

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
