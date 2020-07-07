let _ = require( 'wmathmatrix' );

var matrix3x3 = _.Matrix.Make( [ 3, 3 ] ).copy
([
  +1, +2, +3,
  +0, +4, +5,
  +0, +0, +6,
]);

var determinant = matrix3x3.determinant();
console.log( `determinant of matrix :\n${ determinant }` );
/* log: determinant of matrix :
24
*/
