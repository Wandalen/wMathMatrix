let _ = require( 'wmathmatrix' );

var matrix1 = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);
console.log( `matrix :\n${ matrix1.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4,
*/
