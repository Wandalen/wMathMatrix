if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

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
1.000 4.000
*/
