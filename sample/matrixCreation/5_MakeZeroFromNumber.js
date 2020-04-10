if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

var matrix = _.Matrix.MakeZero( 2 );
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+0, +0,
+0, +0,
*/
