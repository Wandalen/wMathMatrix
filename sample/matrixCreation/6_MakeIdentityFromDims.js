if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

var matrix = _.Matrix.MakeIdentity( [ 2, 3 ] );
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +0, +0,
+0, +1, +0,
*/
