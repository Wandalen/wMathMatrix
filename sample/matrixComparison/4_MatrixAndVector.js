if( typeof 'module' !== undefined )
require( 'wmathmatrix' );

let _ = wTools;

var matrixCol = _.Matrix.MakeCol
([
  1,
  2,
  3
]);

var vector = [ 1, 2, 3 ];

var identical = _.identical( matrixCol, vector );
console.log( `identical : ${ identical }` );
/* log : identical : false */

var equivalent = _.equivalent( matrixCol, vector );
console.log( `equivalent : ${ equivalent }` );
/* log : equivalent : true */
