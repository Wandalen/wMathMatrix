let _ = require( 'wmathmatrix' );

var matrix1 = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);
var matrix2 = _.Matrix.MakeSquare
([
  4, 3,
  2, 1
]);

matrix1.mulScalarWise( matrix2 );
console.log( matrix1 );
/* log :
Matrix.Array.2x2 ::
  +4 +6
  +6 +4
*/
