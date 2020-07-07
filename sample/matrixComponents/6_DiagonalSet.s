let _ = require( 'wmathmatrix' );

var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
matrix.diagonalSet( [ 5, 7 ] );
console.log( `changed matrix :\n${ matrix }` );
/* log : changed matrix :
Matrix.Array.2x2 ::
  +5 +2
  +3 +7
*/
