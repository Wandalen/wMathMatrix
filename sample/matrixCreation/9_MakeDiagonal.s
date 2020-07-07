let _ = require( 'wmathmatrix' );

var matrix = _.Matrix.MakeDiagonal( [ 2, 3, 1 ] );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.3x3 ::
  +2 +0 +0
  +0 +3 +0
  +0 +0 +1
*/
