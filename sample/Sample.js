
let _ = require( 'wmathmatrix' );

var u = _.Matrix.Make([ 3,3 ]).copy
([
  +1, +2, +3,
  +0, +4, +5,
  +0, +0, +6,
]);

var l = _.Matrix.Make([ 3,3 ]).copy
([
  +1, +0, +0,
  +2, +4, +0,
  +3, +5, +6,
]);

var expected = _.Matrix.Make([ 3,3 ]).copy
([
  +14, +23, +18,
  +23, +41, +30,
  +18, +30, +36,
]);

var uxl = _.Matrix.Mul( null,[ u,l ] );
console.log( `got :\n${ uxl }` );
/* log : got :
got
Matrix.F32x.3x3 ::
  +14 +23 +18
  +23 +41 +30
  +18 +30 +36
*/
console.log( `expected :\n${ expected }` );
/* log : expected :
Matrix.F32x.3x3 ::
  +14 +23 +18
  +23 +41 +30
  +18 +30 +36
*/
