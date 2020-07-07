let _ = require( 'wmathmatrix' );

var matrix = _.Matrix.Make( [ Infinity, 2 ] ).copy
([
  0, 1,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.Infinityx2 ::
  +0 +1
... ...
*/
