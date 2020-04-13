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
var row = matrix.colGet( 0 );
console.log( `first column :\n${ row.toStr() }` );
/* log : first column :
1.000, 3.000
*/

