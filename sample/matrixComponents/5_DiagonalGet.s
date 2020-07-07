let _ = require( 'wmathmatrix' );

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
