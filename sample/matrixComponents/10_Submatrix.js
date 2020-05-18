let _ = require( 'wmathmatrix' );

var matrix = _.Matrix.MakeSquare
([
  0,  1,  2,  3,
  4,  5,  6,  7,
  8,  9,  10, 11,
  12, 13, 14, 15,
])
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.4x4 ::
  +0 +1 +2 +3
  +4 +5 +6 +7
  +8 +9 +10 +11
  +12 +13 +14 +15
*/
var sub1 = matrix.submatrix( [ 1, 2 ], [ 0, 1 ] );
console.log( `submatrix1 :\n${ sub1 }` );
/* log : submatrix1 :
Matrix.Array.2x2 ::
  +4 +5
  +8 +9
*/
var sub2 = matrix.submatrix( [ 1, 2 ], [ 1, 2 ] );
console.log( `submatrix2 :\n${ sub2 }` );
/* log : submatrix2 :
Matrix.Array.2x2 ::
  +5 +6
  +9 +10
*/
