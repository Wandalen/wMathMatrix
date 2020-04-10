if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

var matrix = _.Matrix.MakeSquare([ 1, 2, 3, 4 ]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4
*/
matrix.eSet( 0, [ 3, 5 ] );
console.log( `changed matrix :\n${ matrix.toStr() }` );
/* log : changed matrix :
+3, +2,
+5, +4
*/

