let _ = require( 'wmathmatrix' );

var matrix = _.Matrix.MakeIdentity( [ 2, 3 ] );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.2x3 ::
  +1 +0 +0
  +0 +1 +0
*/
