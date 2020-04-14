let _ = require( 'wmathmatrix' );

var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);
var vector = [ 1, 1 ];

var dst = _.Matrix.Mul( null, [ matrix, vector ] );
console.log( `dst :\n${ dst }` );
/* log : dst :
[ 3, 7 ]
*/
