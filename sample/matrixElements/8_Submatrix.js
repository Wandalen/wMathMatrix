if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

var buffer =
[
  0,  1,  2,  3,
  4,  5,  6,  7,
  8,  9,  10, 11,
  12, 13, 14, 15,
];
var matrix = _.Matrix
({
  buffer : buffer,
  dims : [ 4, 3 ],
  offset : 1,
  strides : [ 4, 1 ]
})
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1,  +2,  +3,
+5,  +6,  +7,
+9,  +10, +11,
+13, +14, +15,
*/
var sub1 = matrix.submatrix( [ 1, 2 ], [ 0, 1 ] );
console.log( `submatrix1 :\n${ sub1.toStr() }` );
/* log : submatrix1 :
+5, +6,
+9, +10,
*/
var sub2 = matrix.submatrix( [ 1, 2 ], [ 1, 2 ] );
console.log( `submatrix2 :\n${ sub2.toStr() }` );
/* log : submatrix2 :
+6,  +7,
+10, +11,
*/
