let _ = require( 'wmathmatrix' );

var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
([
  1, 2, 3,
  4, 5, 6,
  7, 8, -9
]);
var result = matrix.determinant();
console.log( `determinant : ${ result }` );
/* log : determinant : 54 */
