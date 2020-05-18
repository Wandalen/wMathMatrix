let _ =  require( 'wmathmatrix' );

var matrix1 = _.Matrix.Make([ 2, 3 ]).copy
([
  1, 2, -3,
  3, 4, -2,
]);
var matrix2 = _.Matrix.Make([ 3, 2 ]).copy
([
  4,  3,
  2,  1,
  -1, -2,
]);

var matrix3 = _.Matrix.MakeCol
([
  -4,
  5,
]);

var dst = _.Matrix.Mul( null, [ matrix1, matrix2, matrix3 ] );
console.log( `dst :\n${ dst }` );
/* log : dst :
Matrix.Array.2x1 ::
  +11
  -3
*/
