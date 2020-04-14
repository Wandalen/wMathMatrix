let _ = require( 'wmathmatrix' );

var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 3, 2 ],
  offset : 8,
  strides : [ -2, -1 ],
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+9, +8,
+7, +6,
+5, +4,
*/
