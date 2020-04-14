let _ = require( 'wmathmatrix' );

var matrix = _.Matrix.MakeCol([ 2, 3 ]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+2,
+3,
*/
