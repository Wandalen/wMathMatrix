let _ = require( 'wmathmatrix' );

var matrix = _.Matrix.MakeIdentity( 2 );
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +0,
+0, +1,
*/
