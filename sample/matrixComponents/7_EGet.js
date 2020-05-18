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
var el = matrix.eGet( 1 );
console.log( `second column of matrix :\n${ el }` );
/* log : second column of matrix :
VectorAdapter.x2.Array :: 2.000 4.000
*/

