if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

var matrix2 = _.Matrix.MakeSquare( 2 );
console.log( `matrix :\n${ matrix2.toStr() }` );
/* log : matrix :
+0, +0,
+0, +0,
*/
