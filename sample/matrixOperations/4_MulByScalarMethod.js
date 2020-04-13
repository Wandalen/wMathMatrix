if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);

matrix.mul( 3 );
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+3, +6,
+9, +12,
*/
