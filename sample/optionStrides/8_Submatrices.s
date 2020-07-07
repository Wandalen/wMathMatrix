let _ = require( 'wmathmatrix' );

var matrix = new _.Matrix
({
  buffer : [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ],
  dims : [ 4, 3 ],
  offset : 1,
  strides : [ 4, 1 ],
});
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.4x3 ::                                                                                                                                                    [10/
  +1 +2 +3
  +5 +6 +7
  +9 +10 +11
  +13 +14 +15
*/
var sub1 = matrix.submatrix( [ 1, 2 ], [ 0, 1 ] );
console.log( `submatrix1 :\n${ sub1 }` );
/* log : submatrix1 :
Matrix.Array.2x2 ::
  +5 +6
  +9 +10
*/
var sub2 = matrix.submatrix( [ 1, 2 ], [ 1, 2 ] );
console.log( `submatrix2 :\n${ sub2 }` );
/* log : submatrix2 :
Matrix.Array.2x2 ::
  +6 +7
  +10 +11
*/
sub1.mul( [ sub1, 2 ] );
sub2.mul( [ sub2, 10 ] );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.4x3 ::
  +1 +2 +3
  +10 +120 +70
  +18 +200 +110
  +13 +14 +15
*/
