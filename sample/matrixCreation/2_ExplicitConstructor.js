let _ = require( 'wmathmatrix' );

var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4 ],
  dims : [ 2, 2 ],
  inputTransposing : 1,
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4,
*/
