let _ = require( 'wmathmatrix' );

var array = [ 1, 2, 3, 4, 5, 6 ];
console.log( `array :\n${ array }` );
/* log : array :
[ 1, 2, 3, 4, 5, 6 ]
*/
var vector = _.vectorAdapter.fromLongLrangeAndStride( array, 1, 3, 2 );
console.log( `vector :\n${ vector }` );
/* log : vector :
VectorAdapter.x3.Array :: 2.000 4.000 6.000
*/

var matrix1 = _.Matrix.FromVector( vector );
console.log( `matrix1 :\n${ matrix1 }` );
/* log : matrix1 :
Matrix.Array.3x1 ::
  +2
  +4
  +6
*/

var matrix2 = _.Matrix.FromVector( array );
console.log( `matrix2 :\n${ matrix2 }` );
/* log : matrix2 :
Matrix.Array.6x1 ::
  +1
  +2
  +3
  +4
  +5
  +6
*/
