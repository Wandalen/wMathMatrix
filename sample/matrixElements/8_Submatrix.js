if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

var matrix = _.Matrix.MakeSquare
([
  1,  2,  3,  4,
  5,  6,  7,  8,
  9,  10, 11, 12,
  13, 14, 15, 16,
]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1,  +2,  +3,  +4,
+5,  +6,  +7,  +8,
+9,  +10, +11, +12,
+13, +14, +15, +16,
*/
var sub1 = matrix.submatrix( [ [ 0, 2 ], [ 0, 2 ] ] );
console.log( `submatrix1 :\n${ sub1.toStr() }` );
/* log : submatrix :
+1, +2,
+5, +6,
*/
var sub2 = matrix.submatrix( [ [ 2, 4 ], [ 2, 4 ] ] );
console.log( `submatrix2 :\n${ sub2.toStr() }` );
/* log : submatrix :
+3, +4,
+7, +8,
*/

