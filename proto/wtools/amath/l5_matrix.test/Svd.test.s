( function _Svd_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

  _.include( 'wTesting' );

  require( '../l5_matrix/module/full/Include.s' );

}

//

const _ = _global_.wTools.withLong.Fx;
// var vectorAdapter = _.vectorAdapter;
// var vec = _.vectorAdapter.fromLong;
// var fvec = function( src ){ return _.vectorAdapter.fromLong( new Fx( src ) ) }
// var ivec = function( src ){ return _.vectorAdapter.fromLong( new Ix( src ) ) }
// var avector = _.avector;
var sqr = _.math.sqr;
var sqrt = _.math.sqrt;

// --
//
// --

function gramSchmidtDecompose( test )
{

  /* */

  test.case = '3x3, normalizing : 0';
  var m = _.Matrix.MakeSquare
  ([
    +4, +9,  -14,
    +3, +13, +2,
    +0, +5,  +0,
  ]);
  m.gramSchmidtDecompose({ normalizing : 0 });

  var exp = _.Matrix.MakeSquare
  ([
    +4, -3, -3,
    +3, +4, +4,
    +0, +5, -5,
  ]);
  test.equivalent( m, exp );

  test.description = 'dot';
  test.equivalent( m.colGet( 0 ).dot( m.colGet( 1 ) ), 0 );
  test.equivalent( m.colGet( 0 ).dot( m.colGet( 2 ) ), 0 );
  test.equivalent( m.colGet( 2 ).dot( m.colGet( 1 ) ), 0 );

  /* */

  test.case = '3x3, normalizing : 1';
  var m = _.Matrix.MakeSquare
  ([
    +4, +9,  -14,
    +3, +13, +2,
    +0, +5,  +0,
  ]);
  m.gramSchmidtDecompose({ normalizing : 1 });

  var den2 = 5*Math.sqrt( 2 );
  var exp = _.Matrix.MakeSquare
  ([
    +4/5, -3/den2, -3/den2,
    +3/5, +4/den2, +4/den2,
    +0  , +5/den2, -5/den2,
  ]);
  test.equivalent( m, exp );

  test.description = 'dot';
  test.equivalent( m.colGet( 0 ).dot( m.colGet( 1 ) ), 0 );
  test.equivalent( m.colGet( 0 ).dot( m.colGet( 2 ) ), 0 );
  test.equivalent( m.colGet( 2 ).dot( m.colGet( 1 ) ), 0 );

  test.description = 'mag';
  test.equivalent( m.colGet( 0 ).mag(), 1 );
  test.equivalent( m.colGet( 1 ).mag(), 1 );
  test.equivalent( m.colGet( 2 ).mag(), 1 );

  test.description = 'q.det()';
  test.equivalent( m.determinant(), -1 );

  test.description = 'q.inv() = q.transp()';
  test.equivalent( m.invert( null ), m.transpose( null ) );

  /* */

  test.case = '4x3, normalizing : 1';
  var m = _.Matrix.Make([ 4, 3 ]).copy
  ([
    +1, -1, +4,
    +1, +4, -2,
    +1, +4, +2,
    +1, -1, +0,
  ]);
  m.gramSchmidtDecompose({ normalizing : 1 });

  var exp = _.Matrix.Make([ 4, 3 ]).copy
  ([
    +0.5, -0.5, +0.5,
    +0.5, +0.5, -0.5,
    +0.5, +0.5, +0.5,
    +0.5, -0.5, -0.5,
  ]);
  test.equivalent( m, exp );

  test.description = 'dot';
  test.equivalent( m.colGet( 0 ).dot( m.colGet( 1 ) ), 0 );
  test.equivalent( m.colGet( 0 ).dot( m.colGet( 2 ) ), 0 );
  test.equivalent( m.colGet( 2 ).dot( m.colGet( 1 ) ), 0 );

  test.description = 'mag';
  test.equivalent( m.colGet( 0 ).mag(), 1 );
  test.equivalent( m.colGet( 1 ).mag(), 1 );
  test.equivalent( m.colGet( 2 ).mag(), 1 );

  /* */

}

//

function qrDecompose( test )
{

  /* */

  test.case = 'normalizing : 1';
  var m = _.Matrix.MakeSquare
  ([
    +4, +9,  -14,
    +3, +13, +2,
    +0, +5,  +0,
  ]);
  var original = m.clone();
  var op = m.qrDecompose();

  test.description = 'q';
  var den2 = 5*Math.sqrt( 2 );
  var exp = _.Matrix.MakeSquare
  ([
    +4/5, -3/den2, -3/den2,
    +3/5, +4/den2, +4/den2,
    +0  , +5/den2, -5/den2,
  ]);
  test.equivalent( m, exp );
  test.true( op.q === m );

  test.description = 'dot';
  test.equivalent( m.colGet( 0 ).dot( m.colGet( 1 ) ), 0 );
  test.equivalent( m.colGet( 0 ).dot( m.colGet( 2 ) ), 0 );
  test.equivalent( m.colGet( 2 ).dot( m.colGet( 1 ) ), 0 );

  test.description = 'mag';
  test.equivalent( m.colGet( 0 ).mag(), 1 );
  test.equivalent( m.colGet( 1 ).mag(), 1 );
  test.equivalent( m.colGet( 2 ).mag(), 1 );

  test.description = 'op.r';
  var den2 = 5*Math.sqrt( 2 );
  var exp = _.Matrix.MakeSquare
  ([
    +5, +15,  -10,
    +0, den2, den2,
    +0, +0,   den2,
  ]);
  /* op.r.copy( exp ); */
  test.equivalent( op.r, exp );
  test.true( op.r !== m );

  test.description = 'a = qr';
  var a = _.Matrix.Mul( null, [ op.q, op.r ] );
  test.equivalent( a, original );

  test.description = 'q.det()';
  test.equivalent( op.q.determinant(), -1 );

  test.description = 'q.inv() = q.transp()';
  test.equivalent( op.q.invert( null ), op.q.transpose( null ) );

  /* */

}

qrDecompose.accuracy = [ _.accuracy*10, 1e-1 ];

// function _qrIteration( test )
// {
//
//   /* */
//
//   test.description = 'Matrix remains unchanged';
//
//   var matrix =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     1, 2,
//     2, 1,
//   ]);
//   var expected = _.vectorAdapter.from( [ 3, -1 ]);
//
//   var gotValues = matrix._qrIteration( );
//   test.equivalent( gotValues, expected );
//
//   var oldMatrix =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     1, 2,
//     2, 1
//   ]);
//   test.equivalent( matrix, oldMatrix );
//
//   /* */
//
//   test.description = 'Matrix with one repeated eigenvalue 3x3';
//
//   var matrix =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     1,  -3,  3,
//     3, - 5,  3,
//     6, - 6,  4
//   ]);
//   var expected = _.vectorAdapter.from( [ 4, -2, -2 ] );
//
//   var gotValues = matrix._qrIteration( );
//   test.equivalent( gotValues, expected );
//
//   /* */
//
//   test.description = 'Matrix with different eigenvalues 3x3';
//
//   var matrix =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     13,  -4,  2,
//     -4,  11, -2,
//     2,   -2,  8
//   ]);
//   var expected = _.vectorAdapter.from( [ 17, 8, 7 ] );
//
//   var gotValues = matrix._qrIteration( );
//   test.equivalent( gotValues, expected );
//
//   /* */
//
//   test.description = 'Matrix 2x2';
//
//   var matrix =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     8,  7,
//     1,  2
//   ]);
//   var expected = _.vectorAdapter.from( [ 9, 1 ] );
//
//   var gotValues = matrix._qrIteration( );
//   test.equivalent( gotValues, expected );
//
//   /* */
//
//   test.description = 'Matrix 4x4';
//
//   var matrix =  _.Matrix.Make( [ 4, 4 ] ).copy
//   ([
//     17, 24, 1, 8,
//     23, 5, 7, 14,
//     4, 6, 13, 20,
//     10, 12, 19, 21
//   ]);
//   var expected = _.vectorAdapter.from( [ 52.01152, 21.52969, -3.60211, -13.93910 ] );
//
//   var gotValues = matrix._qrIteration( );
//   test.equivalent( gotValues, expected );
//
//   /* */
//
//   test.description = 'Symmetric matrix';
//
//   var matrix =  _.Matrix.Make( [ 4, 4 ] ).copy
//   ([
//     1, 0.5, 1/3, 0.25,
//     0.5, 1, 2/3, 0.5,
//     1/3, 2/3, 1, 0.75,
//     0.25, 0.5, 0.75, 1
//   ]);
//   var expected = _.vectorAdapter.from( [ 2.5362, 0.8482, 0.4078, 0.2078 ] );
//
//   var gotValues = matrix._qrIteration( );
//   test.equivalent( gotValues, expected );
//
//   /* */
//
//   test.description = 'Matrix 5x5 Symmetric';
//
//   var matrix =  _.Matrix.Make( [ 5, 5 ] ).copy
//   ([
//     17, 24, 0, 8, 0,
//     24, 5, 6, 0, 0,
//     0, 6, 13, 20, 0,
//     8, 0, 20, 21, 3,
//     0, 0, 0, 3, 9
//   ]);
//   var expected = _.vectorAdapter.from( [ 43.943070, 29.437279, 9.139799, -0.380354, -17.139794 ] );
//
//   var gotValues = matrix._qrIteration( );
//   test.equivalent( gotValues, expected );
//
//   /* */
//
//   test.description = 'Matrix Diagonal';
//
//   var matrix =  _.Matrix.Make( [ 4, 4 ] ).copy
//   ([
//     0.5, 0, 0, 0,
//     0, - 1, 0, 0,
//     0,  0,  1, 0,
//     0,  0, -0, 2
//   ]);
//   var expected = _.vectorAdapter.from( [ 2, 1, 0.5, -1 ] );
//
//   var gotValues = matrix._qrIteration( );
//   test.equivalent( gotValues, expected );
//
//   /* */
//
//   test.description = 'Input Q and R';
//
//   var matrix =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     1, - 3,  3,
//     3, - 5,  3,
//     6, - 6,  4
//   ]);
//   var q = _.Matrix.Make( [ 3, 3 ] );
//   var r = _.Matrix.Make( [ 3, 3 ] );
//   var expected = _.vectorAdapter.from( [ 4, -2, -2 ] );
//
//   var gotValues = matrix._qrIteration( q, r );
//   test.equivalent( gotValues, expected );
//
//   var oldQ =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     -0.408248, 0.707106, -0.577350,
//     -0.408248, -0.707106, -0.577350,
//     -0.816496, 0.000000, 0.577350
//   ]);
//   test.equivalent( q, oldQ );
//
//   var oldR =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     4.0000167, -4.242737, - 10.392261,
//     0,  -2,  0,
//     0,  0,  -2
//   ]);
//   test.equivalent( r, oldR );
//
//   /* */
//
//   if( !Config.debug )
//   return;
//
//   var matrix = 'matrix';
//   test.shouldThrowErrorSync( () => matrix._qrIteration( ));
//   var matrix = NaN;
//   test.shouldThrowErrorSync( () => matrix._qrIteration( ));
//   var matrix = null;
//   test.shouldThrowErrorSync( () => matrix._qrIteration( ));
//   var matrix = [ 0, 0, 0 ];
//   test.shouldThrowErrorSync( () => matrix._qrIteration( ));
//   var matrix = _.vectorAdapter.from( [ 0, 0, 0 ] );
//   test.shouldThrowErrorSync( () => matrix._qrIteration( ));
//
// }
//
// _qrIteration.accuracy = 1E-4;
// _qrIteration.timeOut = 20000;
//
// //
//
// function _qrDecomposition( test )
// {
//
//   /* */
//
//   test.description = 'Matrix remains unchanged';
//
//   var matrix =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     1, 2,
//     2, 1,
//   ]);
//
//   var q = _.Matrix.Make( [ 2, 2 ] );
//   var r = _.Matrix.Make( [ 2, 2 ] );
//   var gotValues = matrix.qrDecompositionGS( q, r );
//
//   var oldMatrix =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     1, 2,
//     2, 1
//   ]);
//   test.equivalent( matrix, oldMatrix );
//
//   var gotValues = matrix.qrDecompositionHh( q, r );
//
//   var oldMatrix =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     1, 2,
//     2, 1
//   ]);
//   test.equivalent( matrix, oldMatrix );
//
//   /* */
//
//   test.description = 'Matrix with one repeated eigenvalue 3x3';
//
//   var matrix =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     12, -51, 4,
//     6, 167, -68,
//     -4, -24, -41,
//   ]);
//   var q = _.Matrix.Make( [ 3, 3 ] );
//   var r = _.Matrix.Make( [ 3, 3 ] );
//   var gotValues = matrix.qrDecompositionGS( q, r );
//   test.equivalent( matrix, _.Matrix.mul2Matrices( null, q, r ) );
//
//   var expectedQ =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     0.857143, -0.467324, -0.216597,
//     0.428571, 0.880322, -0.203369,
//     -0.285714, -0.081489, -0.954844
//   ]);
//   test.equivalent( expectedQ, q );
//
//   var expectedR =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     14, 34.714287, -14,
//     0, 172.803116, -58.390148,
//     0, 0, 52.111328
//   ]);
//   test.equivalent( expectedR, r );
//
//   gotValues = matrix.qrDecompositionHh( q, r );
//   test.equivalent( matrix, _.Matrix.mul2Matrices( null, q, r ) );
//
//   var expectedQ =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     -0.857143, 0.467324, -0.216597,
//     -0.428571, -0.880322, -0.203369,
//     0.285714, 0.081489, -0.954844,
//   ]);
//   test.equivalent( expectedQ, q );
//
//   var expectedR =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     -14, -34.714287, 14,
//     0, -172.803116, 58.390148,
//     0, 0, 52.111328
//   ]);
//   test.equivalent( expectedR, r );
//
//   /* */
//
//   test.description = 'Symmetric matrix with different eigenvalues 3x3';
//
//   var matrix =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     13,  -4,  2,
//     -4,  11, -2,
//     2,   -2,  8
//   ]);
//   var q = _.Matrix.Make( [ 3, 3 ] );
//   var r = _.Matrix.Make( [ 3, 3 ] );
//   var gotValues = matrix.qrDecompositionGS( q, r );
//   test.equivalent( matrix, _.Matrix.mul2Matrices( null, q, r ) );
//
//   var expectedQ =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     0.945611, 0.306672, -0.108501,
//     -0.290957, 0.946511, 0.139501,
//     0.145479, -0.100345, 0.984260,
//   ]);
//   test.equivalent( expectedQ, q );
//
//   var expectedR =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     13.747727, -7.273930, 3.636965,
//     0, 9.385624, -2.082437,
//     0, 0, 7.378071,
//   ]);
//   test.equivalent( expectedR, r );
//
//   gotValues = matrix.qrDecompositionHh( q, r );
//   test.equivalent( matrix, _.Matrix.mul2Matrices( null, q, r ) );
//
//   var expectedQ =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     -0.945611, -0.306672, 0.108501,
//     0.290957, -0.946511, -0.139501,
//     -0.145479, 0.100345, -0.984260,
//   ]);
//   test.equivalent( expectedQ, q );
//
//   var expectedR =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     -13.747727, 7.273930, -3.636965,
//     0, -9.385624, 2.082437,
//     0, 0, -7.378071,
//   ]);
//   test.equivalent( expectedR, r );
//
//   /* */
//
//   if( !Config.debug )
//   return;
//
//   var matrix = 'matrix';
//   var q = _.Matrix.Make([ 3, 3 ]);
//   var r = _.Matrix.Make([ 3, 3 ]);
//   test.shouldThrowErrorSync( () => matrix.qrDecompositionGS( q, r ));
//   test.shouldThrowErrorSync( () => matrix.qrDecompositionHh( q, r ));
//   var matrix = NaN;
//   test.shouldThrowErrorSync( () => matrix.qrDecompositionGS( q, r ));
//   test.shouldThrowErrorSync( () => matrix.qrDecompositionHh( q, r ));
//   var matrix = null;
//   test.shouldThrowErrorSync( () => matrix.qrDecompositionGS( q, r ));
//   test.shouldThrowErrorSync( () => matrix.qrDecompositionHh( q, r ));
//   var matrix = [ 0, 0, 0 ];
//   test.shouldThrowErrorSync( () => matrix.qrDecompositionGS( q, r ));
//   test.shouldThrowErrorSync( () => matrix.qrDecompositionHh( q, r ));
//   var matrix = _.vectorAdapter.from( [ 0, 0, 0 ] );
//   test.shouldThrowErrorSync( () => matrix.qrDecompositionGS( q, r ));
//   test.shouldThrowErrorSync( () => matrix.qrDecompositionHh( q, r ));
//
// }
//
// _qrDecomposition.accuracy = 1E-4;
// _qrDecomposition.timeOut = 20000;
//
// // //
// //
// // function fromVectors( test )
// // {
// //
// // }
//
// //
//
// function svd( test )
// {
//
//   /* */
//
//   test.description = 'Matrix remains unchanged';
//
//   var matrix =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     1, 2,
//     2, 1,
//   ]);
//
//   var gotValues = matrix.svd( null, null, null );
//
//   var oldMatrix =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     1, 2,
//     2, 1
//   ]);
//   test.equivalent( matrix, oldMatrix );
//
//   /* */
//
//   test.description = '2x2 Symmetric Matrix';
//
//   var matrix =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     2, 4,
//     4, 2,
//   ]);
//
//   var u = _.Matrix.Make( [ 2, 2 ] );
//   var s = _.Matrix.Make( [ 2, 2 ] );
//   var v = _.Matrix.Make( [ 2, 2 ] );
//
//   var gotValues = matrix.svd( u, s, v );
//
//   var expectedU =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     -Math.sqrt( 2 ) / 2, -Math.sqrt( 2 ) / 2,
//     -Math.sqrt( 2 ) / 2, Math.sqrt( 2 ) / 2
//   ]);
//   test.equivalent( u, expectedU );
//
//   var expectedS =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     6.000, 0.000,
//     0.000, 2.000
//   ]);
//   test.equivalent( s, expectedS );
//
//   var expectedV =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     -Math.sqrt( 2 ) / 2, Math.sqrt( 2 ) / 2,
//     -Math.sqrt( 2 ) / 2, -Math.sqrt( 2 ) / 2
//   ]);
//   test.equivalent( v, expectedV );
//
//   var oldMatrix =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     2, 4,
//     4, 2
//   ]);
//   var sVT = _.Matrix.mul2Matrices( null, s, v.clone().transpose() );
//   var uSVT = _.Matrix.mul2Matrices( null, u, sVT );
//   test.equivalent( oldMatrix, uSVT );
//
//   /* */
//
//   test.description = '2x2 Matrix';
//
//   var matrix =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     4, 0,
//     3, -5
//   ]);
//
//   var u = _.Matrix.Make( [ 2, 2 ] );
//   var s = _.Matrix.Make( [ 2, 2 ] );
//   var v = _.Matrix.Make( [ 2, 2 ] );
//
//   var gotValues = matrix.svd( u, s, v );
//
//   var expectedU =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     0.4472, -0.8944,
//     0.8944, 0.4472
//   ]);
//   test.equivalent( u, expectedU );
//
//   var expectedS =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     6.3245, 0.000,
//     0.000, 3.1622
//   ]);
//   test.equivalent( s, expectedS );
//
//   var expectedV =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     Math.sqrt( 2 ) / 2, -Math.sqrt( 2 ) / 2,
//     -Math.sqrt( 2 ) / 2, -Math.sqrt( 2 ) / 2
//   ]);
//   test.equivalent( v, expectedV );
//
//   var oldMatrix =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     4, 0,
//     3, -5
//   ]);
//   var sVT = _.Matrix.mul2Matrices( null, s, v.clone().transpose() );
//   var uSVT = _.Matrix.mul2Matrices( null, u, sVT );
//   test.equivalent( oldMatrix, uSVT );
//
//   /* */
//
//   test.description = '2x3 Matrix';
//
//   var matrix =  _.Matrix.Make( [ 2, 3 ] ).copy
//   ([
//     3, 2, 2,
//     2, 3, -2,
//   ]);
//
//   var u = _.Matrix.Make( [ 2, 2 ] );
//   var s = _.Matrix.Make( [ 2, 3 ] );
//   var v = _.Matrix.Make( [ 3, 3 ] );
//
//   var gotValues = matrix.svd( u, s, v );
//
//   var expectedU =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     Math.sqrt( 2 ) / 2, -Math.sqrt( 2 ) / 2,
//     Math.sqrt( 2 ) / 2, Math.sqrt( 2 ) / 2
//   ]);
//   test.equivalent( u, expectedU );
//
//   var expectedS =  _.Matrix.Make( [ 2, 3 ] ).copy
//   ([
//     5.000, 0.000, 0.000,
//     0.000, 3.000, 0.000
//   ]);
//   test.equivalent( s, expectedS );
//
//   var expectedV =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     Math.sqrt( 2 ) / 2, -1/Math.sqrt( 18 ), 2/3,
//     Math.sqrt( 2 ) / 2, 1/Math.sqrt( 18 ), -2/3,
//     0, -4/Math.sqrt( 18 ), -1/3
//   ]);
//   test.equivalent( v, expectedV );
//
//   var oldMatrix =  _.Matrix.Make( [ 2, 3 ] ).copy
//   ([
//     3, 2, 2,
//     2, 3, -2,
//   ]);
//   var sVT = _.Matrix.mul2Matrices( null, s, v.clone().transpose() );
//   var uSVT = _.Matrix.mul2Matrices( null, u, sVT );
//   test.equivalent( oldMatrix, uSVT );
//
//   /* */
//
//   test.description = '3x2 Matrix';
//
//   var matrix =  _.Matrix.Make( [ 3, 2 ] ).copy
//   ([
//     0, 0,
//     0, 9,
//     3, 0
//   ]);
//
//   var u = _.Matrix.Make( [ 3, 3 ] );
//   var s = _.Matrix.Make( [ 3, 2 ] );
//   var v = _.Matrix.Make( [ 2, 2 ] );
//
//   var gotValues = matrix.svd( u, s, v );
//
//   var expectedU =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     0, 0, 1,
//     1, 0, 0,
//     0, 1, 0
//   ]);
//   test.equivalent( u, expectedU );
//
//   var expectedS =  _.Matrix.Make( [ 3, 2 ] ).copy
//   ([
//     9.000, 0.000,
//     0.000, 3.000,
//     0, 0
//   ]);
//   test.equivalent( s, expectedS );
//
//   var expectedV =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     0, 1,
//     1, 0
//   ]);
//   test.equivalent( v, expectedV );
//
//   var oldMatrix =  _.Matrix.Make( [ 3, 2 ] ).copy
//   ([
//     0, 0,
//     0, 9,
//     3, 0
//   ]);
//   var sVT = _.Matrix.mul2Matrices( null, s, v.clone().transpose() );
//   var uSVT = _.Matrix.mul2Matrices( null, u, sVT );
//   test.equivalent( oldMatrix, uSVT );
//
//   /* */
//
//   test.description = '3x3 Matrix';
//
//   var matrix =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     1, 2, 3,
//     -2, 3, 8,
//     5, 1, -3
//   ]);
//
//   var u = _.Matrix.Make( [ 3, 3 ] );
//   var s = _.Matrix.Make( [ 3, 3 ] );
//   var v = _.Matrix.Make( [ 3, 3 ] );
//
//   var gotValues = matrix.svd( u, s, v );
//
//   var expectedU =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     0.287101, -0.477321, -0.830504,
//     0.864001, -0.245327, 0.439679,
//     -0.413613, -0.843789, 0.341972
//   ]);
//   test.equivalent( u, expectedU );
//
//   var expectedS =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     10.05705738, 0, 0,
//     0.000, 4.985533, 0,
//     0, 0, 0.000490
//   ]);
//   test.equivalent( s, expectedS );
//
//   var expectedV =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     -0.348906, -0.843563, 0.742781,
//     0.273697, -0.508353, 0.557086,
//     0.8963, -0.173144, 0.371391
//   ]);
//   test.equivalent( v, expectedV );
//
//   var oldMatrix =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     1, 2, 3,
//     -2, 3, 8,
//     5, 1, -3
//   ]);
//   var sVT = _.Matrix.mul2Matrices( null, s, v.clone().transpose() );
//   var uSVT = _.Matrix.mul2Matrices( null, u, sVT );
//   test.equivalent( oldMatrix, uSVT );
//
//   /* */
//
//   test.description = '4x2 Matrix';
//
//   var matrix =  _.Matrix.Make( [ 4, 2 ] ).copy
//   ([
//     2, 4,
//     1, 3,
//     0, 0,
//     0, 0
//   ]);
//
//   var u = _.Matrix.Make( [ 4, 4 ] );
//   var s = _.Matrix.Make( [ 4, 2 ] );
//   var v = _.Matrix.Make( [ 2, 2 ] );
//
//   var gotValues = matrix.svd( u, s, v );
//
//   var expectedU =  _.Matrix.Make( [ 4, 4 ] ).copy
//   ([
//     -0.817415, 0.576048, 0, 0,
//     -0.576048, -0.817415, 0, 0,
//     0, 0, 1, 0,
//     0, 0, 0, 1
//   ]);
//   test.equivalent( u, expectedU );
//
//   var expectedS =  _.Matrix.Make( [ 4, 2 ] ).copy
//   ([
//     5.46499, 0.000,
//     0.000, 0.365966,
//     0, 0,
//     0, 0
//   ]);
//   test.equivalent( s, expectedS );
//
//   var expectedV =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     -0.404554, 0.914514,
//     -0.914514, -0.404554
//   ]);
//   test.equivalent( v, expectedV );
//
//   var oldMatrix =  _.Matrix.Make( [ 4, 2 ] ).copy
//   ([
//     2, 4,
//     1, 3,
//     0, 0,
//     0, 0
//   ]);
//   var sVT = _.Matrix.mul2Matrices( null, s, v.clone().transpose() );
//   var uSVT = _.Matrix.mul2Matrices( null, u, sVT );
//   test.equivalent( oldMatrix, uSVT );
//
//   /* */
//
//   test.description = '4x5 Matrix';
//
//   var matrix =  _.Matrix.Make( [ 4, 5 ] ).copy
//   ([
//     1, 0, 0, 0, 2,
//     0, 0, 3, 0, 0,
//     0, 0, 0, 0, 0,
//     0, 2, 0, 0, 0
//   ]);
//
//   var u = _.Matrix.Make( [ 4, 4 ] );
//   var s = _.Matrix.Make( [ 4, 5 ] );
//   var v = _.Matrix.Make( [ 5, 5 ] );
//
//   var gotValues = matrix.svd( u, s, v );
//   var expectedU = _.Matrix.Make( [ 4, 4 ] ).copy
//   ([
//     0, 1, 0, 0,
//     1, 0, 0, 0,
//     0, 0, 0, 1,
//     0, 0, 1, 0
//   ]);
//   test.equivalent( u, expectedU );
//
//   var expectedS =  _.Matrix.Make( [ 4, 5 ] ).copy
//   ([
//     3, 0, 0, 0, 0,
//     0, Math.sqrt( 5 ), 0, 0, 0,
//     0, 0, 2, 0, 0,
//     0, 0, 0, 0, 0
//   ]);
//
//   test.equivalent( s, expectedS );
//
//   var expectedV =  _.Matrix.Make( [ 5, 5 ] ).copy
//   ([
//     0, Math.sqrt(0.2), 0, 0, 0,
//     0, 0, 1, 0, 0,
//     1, 0, 0, 0, 0,
//     0, 0, 0, 0, 1,
//     0, Math.sqrt( 0.8 ), 0, 0, 0
//   ]);
//
//   test.equivalent( v, expectedV );
//
//   var oldMatrix =   _.Matrix.Make( [ 4, 5 ] ).copy
//   ([
//     1, 0, 0, 0, 2,
//     0, 0, 3, 0, 0,
//     0, 0, 0, 0, 0,
//     0, 2, 0, 0, 0
//   ]);
//   var sVT = _.Matrix.mul2Matrices( null, s, v.clone().transpose() );
//   var uSVT = _.Matrix.mul2Matrices( null, u, sVT );
//   test.equivalent( oldMatrix, uSVT );
//
//   /* */
//
//   test.description = '7x5 Matrix';
//
//   var matrix =  _.Matrix.Make( [ 7, 5 ] ).copy
//   ([
//     1, 1, 1, 0, 0,
//     2, 2, 2, 0, 0,
//     1, 1, 1, 0, 0,
//     5, 5, 5, 0, 0,
//     0, 0, 0, 2, 2,
//     0, 0, 0, 3, 3,
//     0, 0, 0, 1, 1
//   ]);
//
//   var u = _.Matrix.Make( [ 7, 7 ] );
//   var s = _.Matrix.Make( [ 7, 5 ] );
//   var v = _.Matrix.Make( [ 5, 5 ] );
//
//   var gotValues = matrix.svd( u, s, v );
//
//   var expectedS =  _.Matrix.Make( [ 7, 5 ] ).copy
//   ([
//     9.64365, 0, 0, 0, 0,
//     0, 5.291502, 0, 0, 0,
//     0, 0, 0, 0, 0,
//     0, 0, 0, 0, 0,
//     0, 0, 0, 0, 0,
//     0, 0, 0, 0, 0,
//     0, 0, 0, 0, 0,
//   ]);
//   test.equivalent( s, expectedS );
//
//   var oldMatrix = _.Matrix.Make( [ 7, 5 ] ).copy
//   ([
//     1, 1, 1, 0, 0,
//     2, 2, 2, 0, 0,
//     1, 1, 1, 0, 0,
//     5, 5, 5, 0, 0,
//     0, 0, 0, 2, 2,
//     0, 0, 0, 3, 3,
//     0, 0, 0, 1, 1
//   ]);
//
//   var sVT = _.Matrix.mul2Matrices( null, s, v.clone().transpose() );
//   var uSVT = _.Matrix.mul2Matrices( null, u, sVT );
//   test.equivalent( oldMatrix, uSVT );
//
//   /* */
//
//   if( !Config.debug )
//   return;
//
//   var matrix = 'matrix';
//   var u = _.Matrix.Make([ 3, 3 ]);
//   var s = _.Matrix.Make([ 3, 3 ]);
//   var v = _.Matrix.Make([ 3, 3 ]);
//   test.shouldThrowErrorSync( () => matrix.svd( u, s, v ));
//   var matrix = NaN;
//   test.shouldThrowErrorSync( () => matrix.svd( u, s, v ));
//   var matrix = null;
//   test.shouldThrowErrorSync( () => matrix.svd( u, s, v ));
//   var matrix = [ 0, 0, 0 ];
//   test.shouldThrowErrorSync( () => matrix.svd( u, s, v ));
//   var matrix = _.vectorAdapter.from( [ 0, 0, 0 ] );
//   test.shouldThrowErrorSync( () => matrix.svd( u, s, v ));
//
// }
//
// svd.accuracy = 1E-3;

// --
// declare
// --

const Proto =
{

  name : 'Tools/Math/Svd',
  silencing : 1,
  enabled : 1,

  tests :
  {

    gramSchmidtDecompose,
    qrDecompose,

    // _qrIteration,
    // _qrDecomposition,
    // fromVectors,
    // svd,

  },

}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
_global_.wTester.test( Self.name );

})();
