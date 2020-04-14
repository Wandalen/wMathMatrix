let _ =  require( 'wmathmatrix' );

var matrix1 = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);

var matrix2 = _.Matrix.MakeSquare
([
  1, 2,
  3, 4.001
]);

var equivalent = _.equivalent( matrix1, matrix2 );
console.log( `result of comparison with standard accuracy : ${ equivalent }` );
/* log : result of comparison with standard accuracy : false */

var equivalent = _.equivalent( matrix1, matrix2, { accuracy : 0.01 } );
console.log( `result of comparison with accuracy 0.01 : ${ equivalent }` );
/* log : result of comparison with non-standard accuracy :true */
