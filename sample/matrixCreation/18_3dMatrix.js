let _ = require( 'wmathmatrix' );

var matrix3d = _.Matrix.Make([ 2, 3, 4 ]).copy
([
  1,  2,  3,
  4,  5,  6,
  7,  8,  9,
  10, 11, 12,
  13, 14, 15,
  16, 17, 18,
  19, 20, 21,
  22, 23, 23,
]);
console.log( `3D matrix :\n${ matrix3d.toStr() }` );
/* log : 3D matrix :
Matrix-0
  +1 +2 +3
  +4 +5 +6
Matrix-1
  +7 +8 +9
  +10 +11 +12
Matrix-2
  +13 +14 +15
  +16 +17 +18
Matrix-3
  +19 +20 +21
  +22 +23 +23
*/
