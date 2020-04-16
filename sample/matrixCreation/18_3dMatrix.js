let _ = require( 'wmathmatrix' );

var matrix3d = _.Matrix.Make( [ 2, 3, 2 ] ).copy
([
  1,  2,  3,
  4,  5,  6,
  7,  8,  9,
  10, 11, 12,
]);
console.log( `3D matrix :\n${ matrix3d.toStr() }` );
/* log : 3D matrix :
Matrix-0
+1 +2 +3
+4 +5 +6
Matrix-1
+7 +8 +9
+10 +11 +12
*/
