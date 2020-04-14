let _ = require( 'wmathmatrix' );

var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);
var vector = [ 1, 1 ];

matrix.matrixApplyTo( vector );
console.log( `vector :\n${ vector }` );
/* log : vector :
[ 3, 7 ]
*/
