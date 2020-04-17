let _ = require( 'wmathmatrix' );

var buffer1 = new I32x
([
  +1, -5, +2,
  -3, +4, +7,
]);
var matrixA = new _.Matrix
({
  buffer : buffer1,
  dims : [ 2, 3 ],
  inputTransposing : 1,
});

var buffer2 = new F32x
([
  +1.01, -5, +2,
  -3,    +4, +7.01,
]);
var matrixB = new _.Matrix
({
  buffer : buffer2,
  dims : [ 2, 3 ],
  inputTransposing : 1,
});

var equivalent = _.equivalent( matrixA, matrixB );
console.log( `result of comparison with standard accuracy :\n${ equivalent }` );
/* log : result of comparison with standard accuracy :
false
*/

var equivalent = _.equivalent( matrixA, matrixB, { accuracy : 0.01 } );
console.log( `result of comparison with accuracy 0.01 :\n${ equivalent }` );
/* log : result of comparison with non-standard accuracy :
true
*/
