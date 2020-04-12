if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4 ] );
var vector = [ 1, 1 ];

var got = matrix.matrixApplyTo( vector );
console.log( `got :\n${ got }` );
/* log : got :
[ 3, 7 ]
*/
console.log( `got === vector :\n${ got === vector }` );
/* log : got === vector :
true
*/
