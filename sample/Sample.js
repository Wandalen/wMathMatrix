
if( typeof module !== 'undefined' )
require( 'wmathmatrix' );

var _ = wTools;

var u = _.Matrix.make([ 3,3 ]).copy
([
  +1, +2, +3,
  +0, +4, +5,
  +0, +0, +6,
]);

var l = _.Matrix.make([ 3,3 ]).copy
([
  +1, +0, +0,
  +2, +4, +0,
  +3, +5, +6,
]);

var expected = _.Matrix.make([ 3,3 ]).copy
([
  +14, +23, +18,
  +23, +41, +30,
  +18, +30, +36,
]);

var uxl = _.Matrix.mul( null,[ u,l ] );
console.log( 'got\n' + uxl.toStr() );
console.log( 'expected\n' + expected.toStr() );
