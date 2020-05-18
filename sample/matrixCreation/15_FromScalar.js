let _ = require( 'wmathmatrix' );

var matrix = _.Matrix.FromScalar( 5, [ 2, 2 ] );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.2x2 ::
  +5 +5
  +5 +5
*/
