let _ = require( 'wmathmatrix' );

var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);

var dst = _.Matrix.Mul( null, [ matrix, 3 ] );
console.log( `dst :\n${ dst.toStr() }` );
/* log : dst :
+3, +6,
+9, +12,
*/
