if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

var buffer1 = new I32x( [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 ] );

var matrix = _.Matrix
({
  buffer : buffer1,
  dims : [ 3, 2 ],
  strides : [ 3, 1 ],
  offset : 1,
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+4, +5,
+7, +8,
*/

var matrixTransposed = _.Matrix
({
  buffer : buffer1,
  dims : [ 2, 3 ],
  strides : [ 1, 3 ],
  offset : 1,
});
console.log( `transposed matrix :\n${ matrixTransposed.toStr() }` );
/* log : transposed matrix :
+1, +4, +7,
+2, +5, +8,
*/
