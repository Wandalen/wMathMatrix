if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

/* System of equations:
3*x1 - 2*x2 = 1;
2*x1 + 3*x2 = 2;
*/

var A = _.Matrix.MakeSquare
([
  3, -2,
  2,  3
]);
var x = _.Matrix.MakeCol
([
  1,
  2
]);

var y = _.Matrix.Solve( null, A, x );

console.log( `the unknown values is :\n${ y.toStr() }` );
/* log : the unknown values is :
0.538,
0.308,
*/
