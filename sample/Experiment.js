if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6 ],
  dims : [ 2, 2 ],
  inputTransposing : 0,
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +3,
+2, +4,
*/

console.log( `effective strides :\n${ matrix._stridesEffective }` );
/* log : effective strides :
[ 1, 2 ]
*/
