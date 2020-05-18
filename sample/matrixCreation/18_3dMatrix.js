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
console.log( `3D matrix :\n${ matrix3d }` );
/* log : 3D matrix :
Matrix.F32x.2x3x4 ::
  Layer 0
    +1 +2 +3
    +4 +5 +6
  Layer 1
    +7 +8 +9
    +10 +11 +12
  Layer 2
    +13 +14 +15
    +16 +17 +18
  Layer 3
    +19 +20 +21
    +22 +23 +23
*/
