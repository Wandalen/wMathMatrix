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
matrix.diagonalSet( [ 5, 7 ] );
console.log( `changed matrix :\n${ matrix.toStr() }` );
/* log : changed matrix :
+5, +2,
+3, +7,
*/
