let _ = require( 'wmathmatrix' );

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
