let _ = require( 'wmathmatrix' );

var matrix = _.Matrix.MakeDiagonal( [ 2, 3, 1 ] );
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+2, +0, +0,
+0, +3, +0,
+0, +0, +1,
*/
