let _ = require( 'wmathmatrix' );

var matrix = new _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 3, 2 ],
  strides : [ 2, 1 ],
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4,
+5, +6,
*/

console.log( `effective strides :\n${ matrix.stridesEffective }` );
/* log : effective strides :
[ 2, 1 ]
*/
