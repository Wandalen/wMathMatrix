if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

var matrixA = _.Matrix.MakeSquare( [ 1, 2, 3, 4 ] );
var matrixB = _.Matrix.MakeSquare( [ 4, 3, 2, 1 ] );

var matrix = _.Matrix.Mul( null, [ matrixA, matrixB ] );
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+8,  +5,
+20, +13,
*/
