if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);

var got = _.Matrix.Mul( null, [ matrix, 3 ] );
console.log( `got :\n${ got.toStr() }` );
/* log : matrix :
+3, +6,
+9, +12,
*/
