
if( typeof module !== 'undefined' )
require( 'wmathmatrix' );

var _ = wTools;

var matrix3x3 = _.Matrix.make( [ 3, 3 ] ).copy
([
  +1, +2, +3,
  +0, +4, +5,
  +0, +0, +6,
]);

var determinant = matrix3x3.determinant();
console.log( 'determinant of matrix\n' + determinant);// log "24"
