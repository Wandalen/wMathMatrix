if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

/* System of equations:
3*x1 - 2*x2 = 1;
2*x1 + 3*x2 = 2;
*/

var matrixA = _.Matrix.MakeSquare
([
  3, -2,
  2, 3
]);
var matrixB = _.Matrix.MakeCol( [ 1, 2 ] );

var matrixX = _.Matrix.Solve( null, matrixA, matrixB );

var x1 = matrixX.scalarGet( [ 0, 0 ] );
var x2 = matrixX.scalarGet( [ 1, 0 ] );
console.log( `x1 : ${ x1 },\nx2 : ${ x2 }` );
/* log :
x1 : 0.5384615659713745,
x2 : 0.307692289352417
*/
