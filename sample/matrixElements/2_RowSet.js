if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

var matrix = _.Matrix.MakeSquare([ 1, 2, 3, 4 ]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4,
*/
matrix.rowSet( 0, [ 4, 3 ] );
console.log( `changed matrix :\n${ matrix.toStr() }` );
/* log : changed matrix :
+1, +2,
+4, +3,
*/

