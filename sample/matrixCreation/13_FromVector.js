let _ = require( 'wmathmatrix' );

var array = [ 1, 2, 3, 4, 5, 6 ];
console.log( `array :\n${ array }` );
/* log : array :
[ 1, 2, 3, 4, 5, 6 ]
*/
var vector = _.vectorAdapter.fromLongLrangeAndStride( array, 1, 3, 2 );
console.log( `vector :\n${ vector.toStr() }` );
/* log : vector :
2.000, 4.000, 6.000
*/

var matrix1 = _.Matrix.FromVector( vector );
console.log( `matrix1 :\n${ matrix1.toStr() }` );
/* log : matrix1 :
+1,
+3,
+5,
*/

var matrix2 = _.Matrix.FromVector( array );
console.log( `matrix2 :\n${ matrix2.toStr() }` );
/* log : matrix2 :
+1,
+2,
+3,
+4,
+5,
+6,
*/
