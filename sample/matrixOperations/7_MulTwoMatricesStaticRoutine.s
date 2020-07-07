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

var dst = _.Matrix.Mul( null, [ matrix1, matrix2 ] );
console.log( `dst :\n${ dst }` );
/* log : dst :
Matrix.Array.2x2 ::
  +8 +5
  +20 +13
*/
