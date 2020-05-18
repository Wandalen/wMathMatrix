let _ = require( 'wmathmatrix' );

var position = [ 1, 2, 3 ];
var quaternion = [ 0, 0, 0, 1 ];
var scale = [ 1, 1, 1 ];
var matrix = _.Matrix.FromTransformations( position, quaternion, scale );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.4x4 ::
  +1 +0 +0 +1
  +0 +1 +0 +2
  +0 +0 +1 +3
  +0 +0 +0 +1
*/

