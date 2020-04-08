if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

var _ = wTools;

var matrix = _.Matrix.MakeSquare( [ 1, 1, 2, 2 ] );
var got = _.Matrix.Mul( null, [ matrix, 2 ] );

console.log( 'got : ', got.toStr() );
/* log : got : +2, +2,
               +4, +4,
*/
