if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

var matrix1 = _.Matrix.MakeSquare([ 2, 2, 3, 3 ]);
console.log( `matrix :\n${ matrix1.toStr() }` );
/* log : matrix :
+2, +2,
+3, +3,
*/
