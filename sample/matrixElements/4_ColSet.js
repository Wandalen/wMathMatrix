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
+3, +4
*/
matrix.colSet( 0, 5 );
console.log( `changed matrix :\n${ matrix.toStr() }` );
/* log : changed matrix :
+5, +2,
+5, +4
*/

