if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

var matrix = _.Matrix.FromScalar( 5, [ 2, 2 ] );
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+5, +5,
+5, +5
*/
