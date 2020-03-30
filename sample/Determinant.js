
if( typeof module !== 'undefined' )
    require( 'wmathmatrix' );

var _ = wTools;

var matrix3x3 = _.Matrix.make([ 3,3 ]).copy
([
    +1, +2, +3,
    +0, +4, +5,
    +0, +0, +6,
]);

var determinant = matrix3x3.determinant();
var expected = 24;
console.log( 'determinant of matrix3x3\n' + determinant);
console.log( 'expected\n' + expected );


var matrix2x2 = _.Matrix.make([ 2,2 ]).copy
([
    +2, +4,
    +3, -1,
]);

var determinant2x2 = matrix2x2.determinant();
var expected2x2 = -14;
console.log( 'determinant of matrix2x2\n' + determinant2x2);
console.log( 'expected\n' + expected2x2 );
