let _ = require( 'wmathmatrix' );

/*
1*x1 - 2*x2 = -2;
3*x1 + 4*x2 = 39;
*/

var A = _.Matrix.MakeSquare
([
  1, -2,
  3,  4
]);
var y = [ -7, 39 ];
var x = _.Matrix.Solve( null, A, y );

console.log( `x :\n${ x }` );
/* log : x : [ 5, 6 ] */
