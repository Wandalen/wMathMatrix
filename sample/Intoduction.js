if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

var matrix = _.Matrix.make( [ 3, 3 ] );
console.log( matrix.buffer );
/* log Float32Array [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] */
matrix.copy( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
console.log( matrix.buffer );
/* log Float32Array [ 1, 4, 7, 2, 5, 8, 3, 6, 9 ] */

/* */

var matrix = _.Matrix.make( [ 3, 3 ] ).copy
([
  1, 2, 3,
  4, 5, 6,
  7, 8, -9
]);
var got = matrix.determinant();
console.log( got );
/* log 54 */

/* */

var matrix = _.Matrix.make( [ 3, 3 ] ).copy
([
  1, 2, 3,
  4, 5, 6,
  7, 8, -9
]);
matrix.strides = [ 1, 3 ];
console.log( matrix.rowVectorGet( 0 ).toStr() );
/* log : "1.000, 2.000, 3.000" */
console.log( matrix.rowVectorGet( 1 ).toStr() );
/* log : "4.000, 5.000, 6.000" */
console.log( matrix.rowVectorGet( 2 ).toStr() );
/* log : "7.000, 8.000, -9.000" */

/* */

var matrixA = _.Matrix.make( [ 2, 2 ] ).copy( [ 3, -2, 2, 3 ] );
var matrixB = _.Matrix.make( [ 2, 1 ] ).copy( [ 1, 2 ] );

var matrixAInv =  matrixA.invertingClone();
var matrixX = _.Matrix.mul( null, [ matrixAInv, matrixB ] );

var x1 = matrixX.eGet( 0 ).eGet( 0 );
var x2 = matrixX.eGet( 0 ).eGet( 1 );
console.log( x1, x2 )
/* log 0.5384615659713745 0.307692289352417 */

