let _ = require( 'wmathmatrix' );

var matrix = _.Matrix.Make( [ Infinity, 2 ] ).copy
([
  0, 1,
]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+0  +1
... ...
*/
