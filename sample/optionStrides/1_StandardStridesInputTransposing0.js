if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 3, 2 ],
  inputTransposing : 0,
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +4,
+2, +5,
+3, +6,
*/

console.log( `effective strides :\n${ matrix._stridesEffective }` );
/* log : effective strides :
[ 1, 3 ]
*/
