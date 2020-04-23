if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

var buffer1 = new I32x
([
  +1, -5,
  -3, +4,
]);
var matrix1 = new _.Matrix
({
  buffer : buffer1,
  dims : [ 2, 2 ],
  inputRowMajor : 1,
});

var buffer2 = new F32x
([
  +1, -5,
  -3, +4,
]);
var matrix2 = new _.Matrix
({
  buffer : buffer2,
  dims : [ 2, 2 ],
  inputRowMajor : 1,
});
var identical = _.identical( matrix1, matrix2 );
console.log( `identical : ${ identical }` );
/* log : identical : false */

var equivalent = _.equivalent( matrix1, matrix2 );
console.log( `equivalent : ${ equivalent }` );
/* log : equivalent : true */

