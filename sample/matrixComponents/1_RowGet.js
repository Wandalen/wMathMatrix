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
var row = matrix.rowGet( 0 );
console.log( `first row :\n${ row }` );
/* log : first row :
VectorAdapter.x2.Array :: 1.000 2.000
*/
