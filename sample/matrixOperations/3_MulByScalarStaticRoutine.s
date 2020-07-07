let _ = require( 'wmathmatrix' );

var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);

var dst = _.Matrix.Mul( null, [ matrix, 3 ] );
console.log( `dst :\n${ dst }` );
/* log : dst :
Matrix.F32x.2x2 ::
  +3 +6
  +9 +12
*/
