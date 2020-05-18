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
