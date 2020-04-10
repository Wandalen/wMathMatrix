if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

var matrix = _.Matrix.MakeSquare([ 1, 2, 3, 4 ]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log :
matrix :
+1, +2,
+3, +4,
*/
var el = matrix.eGet( 1 );
console.log( `second column of matrix :\n${ el.toStr() }` );
/* log :
the second row of matrix :
2.000, 4.000
*/
var scalar = matrix.eGet( 1 ).eGet( 1 );
console.log( `second scalar of the second column :\n${ scalar }` );
/* log :
the second scalar of the first row :
4.000
*/

