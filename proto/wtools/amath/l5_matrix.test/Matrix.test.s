( function _Matrix_test_s_() {

'use strict';

/*
*/

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../wtools/Tools.s' );
  _.include( 'wTesting' );
  require( '../l5_matrix/module/full/Include.s' );

}

//

let _ = _global_.wTools.withDefaultLong.Fx;
function fvec( src ){ return _.vectorAdapter.fromLong( new F32x( src ) ) }
function ivec( src ){ return _.vectorAdapter.fromLong( new I32x( src ) ) }
var sqr = _.math.sqr;
var sqrt = _.math.sqrt;

// --
// context
// --

function makeWithOffset( o )
{

  _.assert( _.longIs( o.buffer ) );
  _.assert( _.numberIs( o.offset ) )

  var buffer = new o.buffer.constructor( _.arrayAppendArrays( [], [ _.dup( -1, o.offset ), o.buffer ] ) )

  var m = new _.Matrix
  ({
    dims : o.dims,
    buffer,
    offset : o.offset,
    inputRowMajor : o.inputRowMajor,
  });

  return m;
}

// --
// checker
// --

function matrixIs( test )
{

  /* */

  test.case = 'instance of _.Matrix';
  var src = new _.Matrix
  ({
    buffer : new F32x([ 0, 1, 2, 3, 4, 5, 6, 7 ]),
    offset : 1,
    scalarsPerElement : 3,
    inputRowMajor : 0,
    strides : [ 2, 6 ],
    dims : [ 3, 1 ],
  });
  var got = _.matrixIs( src );
  test.identical( got, true );
  var got = _.Matrix.Is( src );
  test.identical( got, true );

  /* */

  test.case = 'without argument';
  var got = _.matrixIs();
  test.identical( got, false );

  test.case = 'check null';
  var got = _.matrixIs( null );
  test.identical( got, false );

  test.case = 'check undefined';
  var got = _.matrixIs( undefined );
  test.identical( got, false );

  test.case = 'check _.nothing';
  var got = _.matrixIs( _.nothing );
  test.identical( got, false );

  test.case = 'check zero';
  var got = _.matrixIs( 0 );
  test.identical( got, false );

  test.case = 'check empty string';
  var got = _.matrixIs( '' );
  test.identical( got, false );

  test.case = 'check false';
  var got = _.matrixIs( false );
  test.identical( got, false );

  test.case = 'check NaN';
  var got = _.matrixIs( NaN );
  test.identical( got, false );

  test.case = 'check Symbol';
  var got = _.matrixIs( Symbol() );
  test.identical( got, false );

  test.case = 'check empty array';
  var got = _.matrixIs( [] );
  test.identical( got, false );

  test.case = 'check empty arguments array';
  var got = _.matrixIs( _.argumentsArrayMake( [] ) );
  test.identical( got, false );

  test.case = 'check empty unroll';
  var got = _.matrixIs( _.unrollMake( [] ) );
  test.identical( got, false );

  test.case = 'check empty map';
  var got = _.matrixIs( {} );
  test.identical( got, false );

  test.case = 'check empty pure map';
  var got = _.matrixIs( Object.create( null ) );
  test.identical( got, false );

  test.case = 'check empty Set';
  var got = _.matrixIs( new Set( [] ) );
  test.identical( got, false );

  test.case = 'check empty Map';
  var got = _.matrixIs( new Map( [] ) );
  test.identical( got, false );

  test.case = 'check empty BufferRaw';
  var got = _.matrixIs( new BufferRaw() );
  test.identical( got, false );

  test.case = 'check empty BufferTyped';
  var got = _.matrixIs( new U8x() );
  test.identical( got, false );

  test.case = 'check number';
  var got = _.matrixIs( 3 );
  test.identical( got, false );

  test.case = 'check bigInt';
  var got = _.matrixIs( 1n );
  test.identical( got, false );

  test.case = 'check object Number';
  var got = _.matrixIs( new Number( 2 ) );
  test.identical( got, false );

  test.case = 'check string';
  var got = _.matrixIs( 'str' );
  test.identical( got, false );

  test.case = 'check not empty array';
  var got = _.matrixIs( [ null ] );
  test.identical( got, false );

  test.case = 'check not empty map';
  var got = _.matrixIs( { '' : null } );
  test.identical( got, false );

  test.case = 'check not empty map';
  var src = Object.create( null );
  var got = _.matrixIs( src );
  test.identical( got, false );

  test.case = 'check not empty map';
  var src = Object.create( null );
  src.some = false;
  var got = _.matrixIs( src );
  test.identical( got, false );

  test.case = 'check instance of constructor with not own property "constructor"';
  var Constr = function()
  {
    this.x = 1;
    return this;
  };
  var src = new Constr();
  var got = _.matrixIs( src );
  test.identical( got, false );

  /* */

}

//

function constructorIsMatrix( test )
{

  /* */

  test.case = 'instance of _.Matrix';
  var src = new _.Matrix
  ({
    buffer : new F32x([ 0, 1, 2, 3, 4, 5, 6, 7 ]),
    offset : 1,
    scalarsPerElement : 3,
    inputRowMajor : 0,
    strides : [ 2, 6 ],
    dims : [ 3, 1 ],
  });
  var got = _.constructorIsMatrix( src );
  test.identical( got, false );

  test.case = '_.Matrix';
  var got = _.constructorIsMatrix( _.Matrix );
  test.identical( got, true );

  /* */
  test.case = 'without argument';
  var got = _.constructorIsMatrix();
  test.identical( got, false );

  test.case = 'check null';
  var got = _.constructorIsMatrix( null );
  test.identical( got, false );

  test.case = 'check undefined';
  var got = _.constructorIsMatrix( undefined );
  test.identical( got, false );

  test.case = 'check _.nothing';
  var got = _.constructorIsMatrix( _.nothing );
  test.identical( got, false );

  test.case = 'check zero';
  var got = _.constructorIsMatrix( 0 );
  test.identical( got, false );

  test.case = 'check empty string';
  var got = _.constructorIsMatrix( '' );
  test.identical( got, false );

  test.case = 'check false';
  var got = _.constructorIsMatrix( false );
  test.identical( got, false );

  test.case = 'check NaN';
  var got = _.constructorIsMatrix( NaN );
  test.identical( got, false );

  test.case = 'check Symbol';
  var got = _.constructorIsMatrix( Symbol() );
  test.identical( got, false );

  test.case = 'check empty array';
  var got = _.constructorIsMatrix( [] );
  test.identical( got, false );

  test.case = 'check empty arguments array';
  var got = _.constructorIsMatrix( _.argumentsArrayMake( [] ) );
  test.identical( got, false );

  test.case = 'check empty unroll';
  var got = _.constructorIsMatrix( _.unrollMake( [] ) );
  test.identical( got, false );

  test.case = 'check empty map';
  var got = _.constructorIsMatrix( {} );
  test.identical( got, false );

  test.case = 'check empty pure map';
  var got = _.constructorIsMatrix( Object.create( null ) );
  test.identical( got, false );

  test.case = 'check empty Set';
  var got = _.constructorIsMatrix( new Set( [] ) );
  test.identical( got, false );

  test.case = 'check empty Map';
  var got = _.constructorIsMatrix( new Map( [] ) );
  test.identical( got, false );

  test.case = 'check empty BufferRaw';
  var got = _.constructorIsMatrix( new BufferRaw() );
  test.identical( got, false );

  test.case = 'check empty BufferTyped';
  var got = _.constructorIsMatrix( new U8x() );
  test.identical( got, false );

  test.case = 'check number';
  var got = _.constructorIsMatrix( 3 );
  test.identical( got, false );

  test.case = 'check bigInt';
  var got = _.constructorIsMatrix( 1n );
  test.identical( got, false );

  test.case = 'check object Number';
  var got = _.constructorIsMatrix( new Number( 2 ) );
  test.identical( got, false );

  test.case = 'check string';
  var got = _.constructorIsMatrix( 'str' );
  test.identical( got, false );

  test.case = 'check not empty array';
  var got = _.constructorIsMatrix( [ null ] );
  test.identical( got, false );

  test.case = 'check not empty map';
  var got = _.constructorIsMatrix( { '' : null } );
  test.identical( got, false );

  test.case = 'check not empty map';
  var src = Object.create( null );
  var got = _.constructorIsMatrix( src );
  test.identical( got, false );

  test.case = 'check not empty map';
  var src = Object.create( null );
  src.some = false;
  var got = _.constructorIsMatrix( src );
  test.identical( got, false );

  test.case = 'check instance of constructor with not own property "constructor"';
  var Constr = function()
  {
    this.x = 1;
    return this;
  };
  var src = new Constr();
  var got = _.constructorIsMatrix( src );
  test.identical( got, false );

  /* */

}

//

function isDiagonal( test )
{

  /* */

  test.description = 'Matrix remains unchanged';

  var m1 = _.Matrix.Make([ 4, 6 ]).copy
  ([
    0,   0,   0,   0, - 1,   1,
    1, - 1,   0,   0,   0,   0,
    0,   0,   1, - 1,   0,   0,
    - 1,   0, - 1,   0,   0, - 1
  ]);
  var exp = false;

  var got = m1.isDiagonal();
  test.identical( got, exp );

  var oldMatrix = _.Matrix.Make([ 4, 6 ]).copy
  ([
    0,   0,   0,   0, - 1,   1,
    1, - 1,   0,   0,   0,   0,
    0,   0,   1, - 1,   0,   0,
    - 1,   0, - 1,   0,   0, - 1
  ]);
  test.identical( m1, oldMatrix );

  /* */

  test.description = 'Matrix Not diagonal - square';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0,   0,   0,   0,
    1, - 1,   0,   0,
    0,   0,   1, - 1,
    - 1, 0,  - 1,  0
  ]);
  var exp = false;

  var got = m1.isDiagonal();
  test.identical( got, exp );

  /* */

  test.description = 'Matrix Not diagonal - Upper Triangular';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    1,   0,   3,   4,
    0, - 1,   2,   0,
    0,   0,   1, - 1,
    0,   0,   0,  0.5
  ]);
  var exp = false;

  var got = m1.isDiagonal();
  test.identical( got, exp );

  /* */

  test.description = 'Matrix Not diagonal - Lower Triangular';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0.5,  0,   0,  0,
    1,  - 1,   0,  0,
    2,    0,   1,  0,
    - 1, 3.4, - 1, 2
  ]);
  var exp = false;

  var got = m1.isDiagonal();
  test.identical( got, exp );

  /* */

  test.description = 'Matrix not square';

  var m1 = _.Matrix.Make([ 4, 2 ]).copy
  ([
    0.5,  0,
    1,  - 1,
    2,    0,
    - 1, 3.4
  ]);
  var exp = false;

  var got = m1.isDiagonal();
  test.identical( got, exp );

  /* */

  test.description = 'Matrix Diagonal';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0.5, 0, 0, 0,
    0, - 1, 0, 0,
    0,  0,  1, 0,
    0,  0, -0, 2
  ]);
  var exp = true;

  var got = m1.isDiagonal();
  test.identical( got, exp );

  /* */

  test.description = 'Matrix Diagonal 6x6';

  var m1 = _.Matrix.Make([ 6, 6 ]).copy
  ([
    0.5, 0, 0, 0, 0, 0,
    0, - 1, 0, 0, 0, 0,
    0,  0,  1, 0, 0, 0,
    0,  0, -0, 2, 0, 0,
    0,  0,  0, 0, 3, 0,
    0,  0,  0, 0, 0, - 1
  ]);
  var exp = true;

  var got = m1.isDiagonal();
  test.identical( got, exp );

  /* */

  test.description = 'Matrix Diagonal, not square, with minus zero';

  var m1 = _.Matrix.Make([ 4, 3 ]).copy
  ([
    0.5, 0, 0,
    0, - 1, 0,
    0,   0, 1,
    0,   0, -0
  ]);
  var exp = true;

  var got = m1.isDiagonal();
  test.identical( got, exp );

  /* */

  test.description = 'Zero matrix';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0,  0, 0, 0,
    0,  0, 0, 0,
    0,  0,  0, 0,
    0,  0, -0, 0
  ]);
  var exp = true;

  var got = m1.isDiagonal();
  test.identical( got, exp );

  /* */

  if( !Config.debug )
  return;

  var m1 = 'matrix';
  test.shouldThrowErrorSync( () => m1.isDiagonal( m1 ));
  var m1 = null;
  test.shouldThrowErrorSync( () => m1.isDiagonal( m1 ));
  var m1 = NaN;
  test.shouldThrowErrorSync( () => m1.isDiagonal( m1 ));
  var m1 = [ 0, 0, 0 ];
  test.shouldThrowErrorSync( () => m1.isDiagonal( m1 ));
  var m1 = _.vectorAdapter.from([ 0, 0, 0 ]);
  test.shouldThrowErrorSync( () => m1.isDiagonal( m1 ));

}

//

function isUpperTriangle( test )
{

  /* */

  test.description = 'Matrix remains unchanged';

  var m1 = _.Matrix.Make([ 4, 6 ]).copy
  ([
    0,   0,   0,   0, - 1,   1,
    1, - 1,   0,   0,   0,   0,
    0,   0,   1, - 1,   0,   0,
    - 1,   0, - 1,   0,   0, - 1
  ]);
  var exp = false;

  var got = m1.isUpperTriangle();
  test.identical( got, exp );

  var oldMatrix = _.Matrix.Make([ 4, 6 ]).copy
  ([
    0,   0,   0,   0, - 1,   1,
    1, - 1,   0,   0,   0,   0,
    0,   0,   1, - 1,   0,   0,
    - 1,   0, - 1,   0,   0, - 1
  ]);
  test.identical( m1, oldMatrix );

  /* */

  test.description = 'Matrix Not triangular - square';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0,   0,   0,   0,
    1, - 1,   0,   0,
    0,   0,   1, - 1,
    - 1, 0,  - 1,  0
  ]);
  var exp = false;

  var got = m1.isUpperTriangle();
  test.identical( got, exp );

  /* */

  test.description = 'Matrix Not diagonal - Lower Triangular';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0.5,  0,   0,  0,
    1,  - 1,   0,  0,
    2,    0,   1,  0,
    - 1, 3.4, - 1, 2
  ]);
  var exp = false;

  var got = m1.isUpperTriangle();
  test.identical( got, exp );

  /* */

  test.description = 'Matrix not square';

  var m1 = _.Matrix.Make([ 4, 2 ]).copy
  ([
    0.5,  0,
    1,  - 1,
    2,    0,
    - 1, 3.4
  ]);
  var exp = false;

  var got = m1.isUpperTriangle();
  test.identical( got, exp );

  /* */

  test.description = 'Matrix Upper Triangular';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    1,   0,   3,   4,
    0, - 1,   2,   0,
    0,   0,   1, - 1,
    0,   0,   0,  0.5
  ]);
  var exp = true;

  var got = m1.isUpperTriangle();
  test.identical( got, exp );

  /* */

  test.description = 'Matrix Diagonal';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0.5, 0, 0, 0,
    0, - 1, 0, 0,
    0,  0,  1, 0,
    0,  0, -0, 2
  ]);
  var exp = true;

  var got = m1.isUpperTriangle();
  test.identical( got, exp );

  /* */

  test.description = 'Matrix Upper Triangular 6x6';

  var m1 = _.Matrix.Make([ 6, 6 ]).copy
  ([
    0.5, 5, 8, 0, 3, -0.5,
    0, - 1, 0, 8, 0, 2,
    0,  0,  1, 0, 3, 2.2,
    0,  0, -0, 2, 0, 0,
    0,  0,  0, 0, 3, 7,
    0,  0,  0, 0, 0, - 1
  ]);
  var exp = true;

  var got = m1.isUpperTriangle();
  test.identical( got, exp );

  /* */

  test.description = 'Matrix Upper Triangular not square';

  var m1 = _.Matrix.Make([ 4, 3 ]).copy
  ([
    0.5, 0, 0,
    0, - 1, 0,
    0,  0,  1,
    0,  0, -0
  ]);
  var exp = true;

  var got = m1.isUpperTriangle();
  test.identical( got, exp );

  /* */

  test.description = 'Zero matrix ';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0,  0, 0, 0,
    0,  0, 0, 0,
    0,  0,  0, 0,
    0,  0, -0, 0
  ]);
  var exp = true;

  var got = m1.isUpperTriangle();
  test.identical( got, exp );

  /* */

  if( !Config.debug )
  return;

  var m1 = 'matrix';
  test.shouldThrowErrorSync( () => m1.isUpperTriangle());
  var m1 = NaN;
  test.shouldThrowErrorSync( () => m1.isUpperTriangle());
  var m1 = null;
  test.shouldThrowErrorSync( () => m1.isUpperTriangle());
  var m1 = [ 0, 0, 0 ];
  test.shouldThrowErrorSync( () => m1.isUpperTriangle());
  var m1 = _.vectorAdapter.from([ 0, 0, 0 ]);
  test.shouldThrowErrorSync( () => m1.isUpperTriangle());

}

//

function isSymmetric( test )
{

  /* */

  test.description = 'Matrix remains unchanged';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0,   0,   0,   0,
    1, - 1,   0,   0,
    0,   0,   1, - 1,
    - 1,   0, - 1, 0
  ]);
  var exp = false;

  var got = m1.isSymmetric();
  test.identical( got, exp );

  var oldMatrix = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0,   0,   0,   0,
    1, - 1,   0,   0,
    0,   0,   1, - 1,
    - 1,   0, - 1, 0
  ]);
  test.identical( m1, oldMatrix );

  /* */

  test.description = 'Matrix Not Symmetric';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0,   0,   2,   0,
    1, - 1,   0,   0,
    0,   0,   1, - 1,
    - 1, 0,  - 1,  0
  ]);
  var exp = false;

  var got = m1.isSymmetric();
  test.identical( got, exp );

  /* */

  test.description = 'Matrix Lower Triangular';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0.5,  0,   0,  0,
    1,  - 1,   0,  0,
    2,    0,   1,  0,
    - 1, 3.4, - 1, 2
  ]);
  var exp = false;

  var got = m1.isSymmetric();
  test.identical( got, exp );

  /* */

  test.description = 'Matrix Upper Triangular';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    1,   0,   3,   4,
    0, - 1,   2,   0,
    0,   0,   1, - 1,
    0,   0,   0,  0.5
  ]);
  var exp = false;

  var got = m1.isSymmetric();
  test.identical( got, exp );

  /* */

  test.description = 'Matrix Not Squared';

  var m1 = _.Matrix.Make([ 3, 4 ]).copy
  ([
    1,   0,   3,   4,
    0, - 1,   2,   0,
    3,   2,   1, - 1,
  ]);
  var exp = false;

  var got = m1.isSymmetric();
  test.identical( got, exp );

  /* */

  test.description = 'Matrix Diagonal';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0.5, 0, 0, 0,
    0, - 1, 0, 0,
    0,  0,  1, 0,
    0,  0, -0, 2
  ]);
  var exp = true;

  var got = m1.isSymmetric();
  test.identical( got, exp );

  /* */

  test.description = 'Matrix Symmetric';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0.5, 5, 8, 0.1,
    5, - 1, 2, 8,
    8,  2,  1, 0,
    0.1,  8, -0, 2
  ]);
  var exp = true;

  var got = m1.isSymmetric();
  test.identical( got, exp );

  /* */

  test.description = 'Zero matrix ';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0,  0, 0, 0,
    0,  0, 0, 0,
    0,  0,  0, 0,
    0,  0, -0, 0
  ]);
  var exp = true;

  var got = m1.isSymmetric();
  test.identical( got, exp );

  /* */

  if( !Config.debug )
  return;

  var m1 = 'matrix';
  test.shouldThrowErrorSync( () => m1.isSymmetric());
  var m1 = NaN;
  test.shouldThrowErrorSync( () => m1.isSymmetric());
  var m1 = null;
  test.shouldThrowErrorSync( () => m1.isSymmetric());
  var m1 = [ 0, 0, 0 ];
  test.shouldThrowErrorSync( () => m1.isSymmetric());
  var m1 = _.vectorAdapter.from([ 0, 0, 0 ]);
  test.shouldThrowErrorSync( () => m1.isSymmetric());

}

//

function EquivalentSpace( test )
{

  /* - */

  test.case = '0x0 vs 0x0';

  var m1 = _.Matrix.MakeSquare([]);
  var m2 = _.Matrix.MakeSquare([]);

  test.is( _.Matrix.EquivalentColumnSpace( m1, m2 ) );
  test.is( _.Matrix.EquivalentColumnSpace( m2, m1 ) );
  test.is( _.Matrix.EquivalentColumnSpace( m1.transpose( null ), m2.transpose( null ) ) );
  test.is( _.Matrix.EquivalentColumnSpace( m2.transpose( null ), m1.transpose( null ) ) );
  test.is( _.Matrix.EquivalentRowSpace( m1, m2 ) );
  test.is( _.Matrix.EquivalentRowSpace( m2, m1 ) );
  test.is( _.Matrix.EquivalentRowSpace( m1.transpose( null ), m2.transpose( null ) ) );
  test.is( _.Matrix.EquivalentRowSpace( m2.transpose( null ), m1.transpose( null ) ) );

  /* */

  test.case = '0x0 vs 0x2';

  var m1 = _.Matrix.MakeSquare([]);
  var m2 = _.Matrix.Make([ 0, 2 ]);

  test.is( _.Matrix.EquivalentColumnSpace( m1, m2 ) );
  test.is( _.Matrix.EquivalentColumnSpace( m2, m1 ) );
  test.isNot( _.Matrix.EquivalentColumnSpace( m1.transpose( null ), m2.transpose( null ) ) );
  test.isNot( _.Matrix.EquivalentColumnSpace( m2.transpose( null ), m1.transpose( null ) ) );
  test.isNot( _.Matrix.EquivalentRowSpace( m1, m2 ) );
  test.isNot( _.Matrix.EquivalentRowSpace( m2, m1 ) );
  test.is( _.Matrix.EquivalentRowSpace( m1.transpose( null ), m2.transpose( null ) ) );
  test.is( _.Matrix.EquivalentRowSpace( m2.transpose( null ), m1.transpose( null ) ) );

  /* */

  test.case = '0x0 vs 2x0';

  var m1 = _.Matrix.MakeSquare([]);
  var m2 = _.Matrix.Make([ 2, 0 ]);

  test.isNot( _.Matrix.EquivalentColumnSpace( m1, m2 ) );
  test.isNot( _.Matrix.EquivalentColumnSpace( m2, m1 ) );
  test.is( _.Matrix.EquivalentColumnSpace( m1.transpose( null ), m2.transpose( null ) ) );
  test.is( _.Matrix.EquivalentColumnSpace( m2.transpose( null ), m1.transpose( null ) ) );
  test.is( _.Matrix.EquivalentRowSpace( m1, m2 ) );
  test.is( _.Matrix.EquivalentRowSpace( m2, m1 ) );
  test.isNot( _.Matrix.EquivalentRowSpace( m1.transpose( null ), m2.transpose( null ) ) );
  test.isNot( _.Matrix.EquivalentRowSpace( m2.transpose( null ), m1.transpose( null ) ) );

  /* */

  test.case = 'diff space, 2x2 vs 2x2';

  var m1 = _.Matrix.MakeSquare
  ([
    1, 2,
    4, 3,
  ]);

  var m2 = _.Matrix.MakeSquare
  ([
    11, 12,
    14, 13,
  ]);

  test.isNot( _.Matrix.EquivalentColumnSpace( m1, m2 ) );
  test.isNot( _.Matrix.EquivalentColumnSpace( m2, m1 ) );
  test.isNot( _.Matrix.EquivalentColumnSpace( m1.transpose( null ), m2.transpose( null ) ) );
  test.isNot( _.Matrix.EquivalentColumnSpace( m2.transpose( null ), m1.transpose( null ) ) );
  test.isNot( _.Matrix.EquivalentRowSpace( m1, m2 ) );
  test.isNot( _.Matrix.EquivalentRowSpace( m2, m1 ) );
  test.isNot( _.Matrix.EquivalentRowSpace( m1.transpose( null ), m2.transpose( null ) ) );
  test.isNot( _.Matrix.EquivalentRowSpace( m2.transpose( null ), m1.transpose( null ) ) );

  /* - */

  test.case = 'eq col space, 2x2 vs 2x2';

  var m1 = _.Matrix.MakeSquare
  ([
    1/3, 4/10,
    1, 1,
  ]);

  var m2 = _.Matrix.MakeSquare
  ([
    2, 1,
    5, 3,
  ]);

  test.is( _.Matrix.EquivalentColumnSpace( m1, m2 ) );
  test.is( _.Matrix.EquivalentColumnSpace( m2, m1 ) );
  test.isNot( _.Matrix.EquivalentColumnSpace( m1.transpose( null ), m2.transpose( null ) ) );
  test.isNot( _.Matrix.EquivalentColumnSpace( m2.transpose( null ), m1.transpose( null ) ) );
  test.isNot( _.Matrix.EquivalentRowSpace( m1, m2 ) );
  test.isNot( _.Matrix.EquivalentRowSpace( m2, m1 ) );
  test.is( _.Matrix.EquivalentRowSpace( m1.transpose( null ), m2.transpose( null ) ) );
  test.is( _.Matrix.EquivalentRowSpace( m2.transpose( null ), m1.transpose( null ) ) );

  /* */

  test.case = 'eq col space, 2x2 vs 2x3';

  var m1 = _.Matrix.MakeSquare
  ([
    1/3, 4/10,
    1, 1,
  ]);

  var m2 = _.Matrix.Make([ 2, 3 ]).copy
  ([
    2, 0, 1,
    5, 0, 3,
  ]);

  test.is( _.Matrix.EquivalentColumnSpace( m1, m2 ) );
  test.is( _.Matrix.EquivalentColumnSpace( m2, m1 ) );
  test.isNot( _.Matrix.EquivalentColumnSpace( m1.transpose( null ), m2.transpose( null ) ) );
  test.isNot( _.Matrix.EquivalentColumnSpace( m2.transpose( null ), m1.transpose( null ) ) );
  test.isNot( _.Matrix.EquivalentRowSpace( m1, m2 ) );
  test.isNot( _.Matrix.EquivalentRowSpace( m2, m1 ) );
  test.is( _.Matrix.EquivalentRowSpace( m1.transpose( null ), m2.transpose( null ) ) );
  test.is( _.Matrix.EquivalentRowSpace( m2.transpose( null ), m1.transpose( null ) ) );

  /* */

  test.case = 'eq col space, 3x2 vs 2x2';

  var m1 = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1/3, 4/10,
    0, 0,
    1, 1,
  ]);

  var m2 = _.Matrix.Make([ 2, 2 ]).copy
  ([
    2, 1,
    5, 3,
  ]);

  test.isNot( _.Matrix.EquivalentColumnSpace( m1, m2 ) );
  test.isNot( _.Matrix.EquivalentColumnSpace( m2, m1 ) );
  test.isNot( _.Matrix.EquivalentColumnSpace( m1.transpose( null ), m2.transpose( null ) ) );
  test.isNot( _.Matrix.EquivalentColumnSpace( m2.transpose( null ), m1.transpose( null ) ) );
  test.isNot( _.Matrix.EquivalentRowSpace( m1, m2 ) );
  test.isNot( _.Matrix.EquivalentRowSpace( m2, m1 ) );
  test.isNot( _.Matrix.EquivalentRowSpace( m1.transpose( null ), m2.transpose( null ) ) );
  test.isNot( _.Matrix.EquivalentRowSpace( m2.transpose( null ), m1.transpose( null ) ) );

  /* - */

}

// --
// equaler
// --

function compareMatrices( test )
{

  /* */

  test.case = 'trivial';

  var src1 = _.Matrix.MakeIdentity([ 3, 3 ]);
  var src2 = _.Matrix.MakeIdentity([ 3, 3 ]);

  test.identical( src1.identicalWith( src2 ), true );
  test.identical( src2.identicalWith( src1 ), true );
  test.identical( src1.equivalentWith( src2 ), true );
  test.identical( src2.equivalentWith( src1 ), true );
  test.identical( _.identical( src1, src2 ), true );
  test.identical( _.identical( src2, src1 ), true );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.identical( src1, src2 );
  test.identical( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  /* */

  test.case = 'single 2d';

  var src1 = _.Matrix.MakeZero([ 1, 1 ]);
  var src2 = _.Matrix.MakeZero([ 1, 1 ]);

  test.identical( src1.identicalWith( src2 ), true );
  test.identical( src2.identicalWith( src1 ), true );
  test.identical( src1.equivalentWith( src2 ), true );
  test.identical( src2.equivalentWith( src1 ), true );
  test.identical( _.identical( src1, src2 ), true );
  test.identical( _.identical( src2, src1 ), true );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.identical( src1, src2 );
  test.identical( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  /* */

  test.case = 'single 3d';

  var src1 = _.Matrix.MakeZero([ 1, 1, 1 ]);
  var src2 = _.Matrix.MakeZero([ 1, 1, 1 ]);

  test.identical( src1.identicalWith( src2 ), true );
  test.identical( src2.identicalWith( src1 ), true );
  test.identical( src1.equivalentWith( src2 ), true );
  test.identical( src2.equivalentWith( src1 ), true );
  test.identical( _.identical( src1, src2 ), true );
  test.identical( _.identical( src2, src1 ), true );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.identical( src1, src2 );
  test.identical( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  /* */

  test.case = 'single 4d';

  var src1 = _.Matrix.MakeZero([ 1, 1, 1, 1 ]);
  var src2 = _.Matrix.MakeZero([ 1, 1, 1, 1 ]);

  test.identical( src1.identicalWith( src2 ), true );
  test.identical( src2.identicalWith( src1 ), true );
  test.identical( src1.equivalentWith( src2 ), true );
  test.identical( src2.equivalentWith( src1 ), true );
  test.identical( _.identical( src1, src2 ), true );
  test.identical( _.identical( src2, src1 ), true );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.identical( src1, src2 );
  test.identical( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  /* */

  test.case = 'empty 0x1 - 0x1';

  var src1 = _.Matrix.MakeZero([ 0, 1 ]);
  var src2 = _.Matrix.MakeZero([ 0, 1 ]);

  test.identical( src1.identicalWith( src2 ), true );
  test.identical( src2.identicalWith( src1 ), true );
  test.identical( src1.equivalentWith( src2 ), true );
  test.identical( src2.equivalentWith( src1 ), true );
  test.identical( _.identical( src1, src2 ), true );
  test.identical( _.identical( src2, src1 ), true );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.identical( src1, src2 );
  test.identical( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  /* */

  test.case = 'empty 1x0 - 1x0';

  var src1 = _.Matrix.MakeZero([ 1, 0 ]);
  var src2 = _.Matrix.MakeZero([ 1, 0 ]);

  test.identical( src1.identicalWith( src2 ), true );
  test.identical( src2.identicalWith( src1 ), true );
  test.identical( src1.equivalentWith( src2 ), true );
  test.identical( src2.equivalentWith( src1 ), true );
  test.identical( _.identical( src1, src2 ), true );
  test.identical( _.identical( src2, src1 ), true );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.identical( src1, src2 );
  test.identical( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  /* */

  test.case = 'empty 0x1 - 1x0';

  var src1 = _.Matrix.MakeZero([ 0, 1 ]);
  var src2 = _.Matrix.MakeZero([ 1, 0 ]);

  test.identical( src1.identicalWith( src2 ), false );
  test.identical( src2.identicalWith( src1 ), false );
  test.identical( src1.equivalentWith( src2 ), true );
  test.identical( src2.equivalentWith( src1 ), true );
  test.identical( _.identical( src1, src2 ), false );
  test.identical( _.identical( src2, src1 ), false );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.ni( src1, src2 );
  test.ni( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  test.case = 'empty 0x1 - 1x1x0';

  var src1 = _.Matrix.MakeZero([ 0, 1 ]);
  var src2 = _.Matrix.MakeZero([ 1, 1, 0 ]);

  test.identical( src1.identicalWith( src2 ), false );
  test.identical( src2.identicalWith( src1 ), false );
  test.identical( src1.equivalentWith( src2 ), true );
  test.identical( src2.equivalentWith( src1 ), true );
  test.identical( _.identical( src1, src2 ), false );
  test.identical( _.identical( src2, src1 ), false );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.ni( src1, src2 );
  test.ni( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  test.case = 'empty 0x1 - 1x0x1';

  var src1 = _.Matrix.MakeZero([ 0, 1 ]);
  var src2 = _.Matrix.MakeZero([ 1, 0, 1 ]);

  test.identical( src1.identicalWith( src2 ), false );
  test.identical( src2.identicalWith( src1 ), false );
  test.identical( src1.equivalentWith( src2 ), true );
  test.identical( src2.equivalentWith( src1 ), true );
  test.identical( _.identical( src1, src2 ), false );
  test.identical( _.identical( src2, src1 ), false );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.ni( src1, src2 );
  test.ni( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  test.case = 'empty 1x0 - 1x0x1';

  var src1 = _.Matrix.MakeZero([ 1, 0 ]);
  var src2 = _.Matrix.MakeZero([ 1, 0, 1 ]);

  test.identical( src1.identicalWith( src2 ), false );
  test.identical( src2.identicalWith( src1 ), false );
  test.identical( src1.equivalentWith( src2 ), true );
  test.identical( src2.equivalentWith( src1 ), true );
  test.identical( _.identical( src1, src2 ), false );
  test.identical( _.identical( src2, src1 ), false );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.ni( src1, src2 );
  test.ni( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  test.case = 'empty 1x0 - 1x1x1x0';

  var src1 = _.Matrix.MakeZero([ 1, 0 ]);
  var src2 = _.Matrix.MakeZero([ 1, 1, 1, 0 ]);

  test.identical( src1.identicalWith( src2 ), false );
  test.identical( src2.identicalWith( src1 ), false );
  test.identical( src1.equivalentWith( src2 ), true );
  test.identical( src2.equivalentWith( src1 ), true );
  test.identical( _.identical( src1, src2 ), false );
  test.identical( _.identical( src2, src1 ), false );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.ni( src1, src2 );
  test.ni( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  /* */

  test.case = 'row';

  var src1 = _.Matrix.MakeZero([ 1, 3 ]);
  var src2 = _.Matrix.MakeZero([ 1, 3 ]);

  test.identical( src1.identicalWith( src2 ), true );
  test.identical( src2.identicalWith( src1 ), true );
  test.identical( src1.equivalentWith( src2 ), true );
  test.identical( src2.equivalentWith( src1 ), true );
  test.identical( _.identical( src1, src2 ), true );
  test.identical( _.identical( src2, src1 ), true );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.identical( src1, src2 );
  test.identical( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  /* */

  test.case = 'col';

  var src1 = _.Matrix.MakeZero([ 3, 1 ]);
  var src2 = _.Matrix.MakeZero([ 3, 1 ]);

  test.identical( src1.identicalWith( src2 ), true );
  test.identical( src2.identicalWith( src1 ), true );
  test.identical( src1.equivalentWith( src2 ), true );
  test.identical( src2.equivalentWith( src1 ), true );
  test.identical( _.identical( src1, src2 ), true );
  test.identical( _.identical( src2, src1 ), true );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.identical( src1, src2 );
  test.identical( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  /* */

  test.case = 'different types';

  var src1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 2, 3, 4 ]),
    dims : [ 2, 2 ],
    inputRowMajor : 0,
  });

  var src2 = new _.Matrix
  ({
    buffer : new I32x([ 1, 2, 3, 4 ]),
    dims : [ 2, 2 ],
    inputRowMajor : 0,
  });

  test.identical( _.identical( src1, src2 ), false );
  test.identical( _.identical( src2, src1 ), false );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.ni( src1, src2 );
  test.ni( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  /* */

  test.case = 'with strides';

  var src1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 3, 5 ]),
    dims : [ 3, 1 ],
    inputRowMajor : 0,
  });

  var src2 = new _.Matrix
  ({
    buffer : new F32x([ 0, 1, 2, 3, 4, 5, 6, 7 ]),
    offset : 1,
    inputRowMajor : 0,
    strides : [ 2, 6 ],
    dims : [ 3, 1 ],
  });

  test.identical( src1.identicalWith( src2 ), true );
  test.identical( src2.identicalWith( src1 ), true );
  test.identical( src1.equivalentWith( src2 ), true );
  test.identical( src2.equivalentWith( src1 ), true );
  test.identical( _.identical( src1, src2 ), true );
  test.identical( _.identical( src2, src1 ), true );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.identical( src1, src2 );
  test.identical( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  /* */

  test.case = 'with infinity dim';

  var src1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 3, 5 ]),
    dims : [ 3, Infinity ],
    inputRowMajor : 0,
  });

  var src2 = new _.Matrix
  ({
    buffer : new F32x([ 1, 3, 5 ]),
    dims : [ 3, Infinity ],
    inputRowMajor : 0,
  });

  test.identical( src1.identicalWith( src2 ), true );
  test.identical( src2.identicalWith( src1 ), true );
  test.identical( src1.equivalentWith( src2 ), true );
  test.identical( src2.equivalentWith( src1 ), true );
  test.identical( _.identical( src1, src2 ), true );
  test.identical( _.identical( src2, src1 ), true );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.identical( src1, src2 );
  test.identical( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  /* */

  test.case = 'with different strides';

  var src1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 2, 3, 4, 5, 6 ]),
    dims : [ 2, 3 ],
    strides : [ 1, 2 ],
  });

  var src2 = new _.Matrix
  ({
    buffer : new F32x([ 1, 3, 5, 2, 4, 6 ]),
    dims : [ 2, 3 ],
    strides : [ 3, 1 ],
  });

  test.identical( src1.identicalWith( src2 ), true );
  test.identical( src2.identicalWith( src1 ), true );
  test.identical( src1.equivalentWith( src2 ), true );
  test.identical( src2.equivalentWith( src1 ), true );
  test.identical( _.identical( src1, src2 ), true );
  test.identical( _.identical( src2, src1 ), true );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.identical( src1, src2 );
  test.identical( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  /* */

  test.case = 'matrix 2x2x1, matrix 2x2';

  var src1 = _.Matrix.Make([ 2, 2 ]).copy
  ([
    1, 2,
    3, 4,
  ]);
  var src2 = _.Matrix.Make([ 2, 2, 1 ]).copy
  ([
    1, 2,
    3, 4,
  ]);

  test.identical( src1.identicalWith( src2 ), false );
  test.identical( src1.equivalentWith( src2 ), true );
  test.identical( _.identical( src1, src2 ), false );
  test.identical( _.identical( src2, src1 ), false );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.ni( src1, src2 );
  test.ni( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  /* */

  test.case = 'matrix 2x3xInfinity and 2x3xInfinity';
  var src1 = _.Matrix.Make([ 2, 3, Infinity ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);
  var src2 = _.Matrix.Make([ 2, 3, Infinity ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  test.identical( src1.identicalWith( src2 ), true );
  test.identical( src2.identicalWith( src1 ), true );
  test.identical( src1.equivalentWith( src2 ), true );
  test.identical( src2.equivalentWith( src1 ), true );
  test.identical( _.identical( src1, src2 ), true );
  test.identical( _.identical( src2, src1 ), true );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.identical( src1, src2 );
  test.identical( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  /* */

  test.case = 'matrix Infinityx1 and 1x1';
  var src1 = _.Matrix.Make([ Infinity, 1 ]).copy
  ([
    1
  ]);
  var src2 = _.Matrix.Make([ 1, 1 ]).copy
  ([
    1
  ]);

  test.identical( src1.identicalWith( src2 ), false );
  test.identical( src2.identicalWith( src1 ), false );
  test.identical( src1.equivalentWith( src2 ), false );
  test.identical( src2.equivalentWith( src1 ), false );
  test.identical( _.identical( src1, src2 ), false );
  test.identical( _.identical( src2, src1 ), false );
  test.identical( _.equivalent( src1, src2 ), false );
  test.identical( _.equivalent( src2, src1 ), false );
  test.identical( _.contains( src1, src2 ), false );
  test.identical( _.contains( src2, src1 ), false );
  test.ni( src1, src2 );
  test.ni( src2, src1 );
  test.ne( src1, src2 );
  test.ne( src2, src1 );

  /* */

  test.case = 'matrix 1xInfinity and 1x1';
  var src1 = _.Matrix.Make([ 1, Infinity ]).copy
  ([
    1
  ]);
  var src2 = _.Matrix.Make([ 1, 1 ]).copy
  ([
    1
  ]);

  test.identical( src1.identicalWith( src2 ), false );
  test.identical( src2.identicalWith( src1 ), false );
  test.identical( src1.equivalentWith( src2 ), false );
  test.identical( src2.equivalentWith( src1 ), false );
  test.identical( _.identical( src1, src2 ), false );
  test.identical( _.identical( src2, src1 ), false );
  test.identical( _.equivalent( src1, src2 ), false );
  test.identical( _.equivalent( src2, src1 ), false );
  test.identical( _.contains( src1, src2 ), false );
  test.identical( _.contains( src2, src1 ), false );
  test.ni( src1, src2 );
  test.ni( src2, src1 );
  test.ne( src1, src2 );
  test.ne( src2, src1 );

  /* */

  test.case = 'matrix 1x1xInfinity and 1x1x1';
  var src1 = _.Matrix.Make([ 1, 1, Infinity ]).copy
  ([
    1
  ]);
  var src2 = _.Matrix.Make([ 1, 1, 1 ]).copy
  ([
    1
  ]);

  test.identical( src1.identicalWith( src2 ), false );
  test.identical( src2.identicalWith( src1 ), false );
  test.identical( src1.equivalentWith( src2 ), false );
  test.identical( src2.equivalentWith( src1 ), false );
  test.identical( _.identical( src1, src2 ), false );
  test.identical( _.identical( src2, src1 ), false );
  test.identical( _.equivalent( src1, src2 ), false );
  test.identical( _.equivalent( src2, src1 ), false );
  test.identical( _.contains( src1, src2 ), false );
  test.identical( _.contains( src2, src1 ), false );
  test.ni( src1, src2 );
  test.ni( src2, src1 );
  test.ne( src1, src2 );
  test.ne( src2, src1 );

  /* */

}

//

function compareMatrixAndVector( test )
{

  /* */

  test.case = 'Matrix and BufferTyped';

  var src1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 3, 5 ]),
    dims : [ 3, 1 ],
    inputRowMajor : 0,
  });
  var src2 = new F32x([ 1, 3, 5 ]);

  test.identical( _.identical( src1, src2 ), false );
  test.identical( _.identical( src2, src1 ), false );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.ni( src1, src2 );
  test.ni( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  /* */

  test.case = 'Matrix and Array';

  var src1 = new _.Matrix
  ({
    buffer : ([ 1, 3, 5 ]),
    dims : [ 3, 1 ],
    inputRowMajor : 0,
  });
  var src2 = ([ 1, 3, 5 ]);

  test.identical( _.identical( src1, src2 ), false );
  test.identical( _.identical( src2, src1 ), false );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.ni( src1, src2 );
  test.ni( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  /* */

  test.case = 'Matrix and Array different type';

  var src1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 3, 5 ]),
    dims : [ 3, 1 ],
    inputRowMajor : 0,
  });
  var src2 = ([ 1, 3, 5 ]);

  test.identical( _.identical( src1, src2 ), false );
  test.identical( _.identical( src2, src1 ), false );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.ni( src1, src2 );
  test.ni( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  /* */

  test.case = 'Matrix and vadapter BufferTyped';

  var src1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 3, 5 ]),
    dims : [ 3, 1 ],
    inputRowMajor : 0,
  });
  var src2 = _.vectorAdapter.from( new F32x([ 1, 3, 5 ]) );

  test.identical( _.identical( src1, src2 ), false );
  test.identical( _.identical( src2, src1 ), false );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.ni( src1, src2 );
  test.ni( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  /* */

  test.case = 'Matrix and vadapter Array';

  var src1 = new _.Matrix
  ({
    buffer : [ 1, 3, 5 ],
    dims : [ 3, 1 ],
    inputRowMajor : 0,
  });
  var src2 = _.vectorAdapter.from([ 1, 3, 5 ]);

  test.identical( _.identical( src1, src2 ), false );
  test.identical( _.identical( src2, src1 ), false );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.ni( src1, src2 );
  test.ni( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

  /* */

  test.case = 'Matrix and vadapter Array different type';

  var src1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 3, 5 ]),
    dims : [ 3, 1 ],
    inputRowMajor : 0,
  });
  var src2 = _.vectorAdapter.from([ 1, 3, 5 ]);

  test.identical( _.identical( src1, src2 ), false );
  test.identical( _.identical( src2, src1 ), false );
  test.identical( _.equivalent( src1, src2 ), true );
  test.identical( _.equivalent( src2, src1 ), true );
  test.identical( _.contains( src1, src2 ), true );
  test.identical( _.contains( src2, src1 ), true );
  test.ni( src1, src2 );
  test.ni( src2, src1 );
  test.equivalent( src1, src2 );
  test.equivalent( src2, src1 );

}

//

function compareMatrixAndNot( test )
{

  /* */

  test.case = 'matrix and map';

  var src1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 3, 5 ]),
    dims : [ 3, 1 ],
    inputRowMajor : 0,
  });
  var src2 = {};

  test.identical( _.identical( src1, src2 ), false );
  test.identical( _.identical( src2, src1 ), false );
  test.identical( _.equivalent( src1, src2 ), false );
  test.identical( _.equivalent( src2, src1 ), false );
  test.identical( _.contains( src1, src2 ), false );
  test.identical( _.contains( src2, src1 ), false );
  test.ni( src1, src2 );
  test.ni( src2, src1 );
  test.ne( src1, src2 );
  test.ne( src2, src1 );

  /* */

  test.case = 'matrix and string';

  var src1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 3, 5 ]),
    dims : [ 3, 1 ],
    inputRowMajor : 0,
  });
  var src2 = 'string';

  test.identical( _.identical( src1, src2 ), false );
  test.identical( _.identical( src2, src1 ), false );
  test.identical( _.equivalent( src1, src2 ), false );
  test.identical( _.equivalent( src2, src1 ), false );
  test.identical( _.contains( src1, src2 ), false );
  test.identical( _.contains( src2, src1 ), false );
  test.ni( src1, src2 );
  test.ni( src2, src1 );
  test.ne( src1, src2 );
  test.ne( src2, src1 );

  /* */

  test.case = 'matrix and number';

  var src1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 3, 5 ]),
    dims : [ 3, 1 ],
    inputRowMajor : 0,
  });
  var src2 = 1;

  test.identical( _.identical( src1, src2 ), false );
  test.identical( _.identical( src2, src1 ), false );
  test.identical( _.equivalent( src1, src2 ), false );
  test.identical( _.equivalent( src2, src1 ), false );
  test.identical( _.contains( src1, src2 ), false );
  test.identical( _.contains( src2, src1 ), false );
  test.ni( src1, src2 );
  test.ni( src2, src1 );
  test.ne( src1, src2 );
  test.ne( src2, src1 );

  /* */

  test.case = 'matrix and null';

  var src1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 3, 5 ]),
    dims : [ 3, 1 ],
    inputRowMajor : 0,
  });
  var src2 = null;

  test.identical( _.identical( src1, src2 ), false );
  test.identical( _.identical( src2, src1 ), false );
  test.identical( _.equivalent( src1, src2 ), false );
  test.identical( _.equivalent( src2, src1 ), false );
  test.identical( _.contains( src1, src2 ), false );
  test.identical( _.contains( src2, src1 ), false );
  test.ni( src1, src2 );
  test.ni( src2, src1 );
  test.ne( src1, src2 );
  test.ne( src2, src1 );

  /* */

  test.case = 'matrix and undefined';

  var src1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 3, 5 ]),
    dims : [ 3, 1 ],
    inputRowMajor : 0,
  });
  var src2 = undefined;

  test.identical( _.identical( src1, src2 ), false );
  test.identical( _.identical( src2, src1 ), false );
  test.identical( _.equivalent( src1, src2 ), false );
  test.identical( _.equivalent( src2, src1 ), false );
  test.identical( _.contains( src1, src2 ), false );
  test.identical( _.contains( src2, src1 ), false );
  test.ni( src1, src2 );
  test.ni( src2, src1 );
  test.ne( src1, src2 );
  test.ne( src2, src1 );

  /* */

}

// --
// accessors
// --

function scalarGet( test )
{
  _.vectorAdapter.contextsForTesting({ onEach : act });

  function act( a )
  {
    test.open( '2D matrix' );

    test.case = `buffer - long ${ a.format }, regular dims values`;
    var buffer = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ 2, 3 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    test.identical( matrix.scalarGet([ 0, 0 ]), 2 );
    test.identical( matrix.scalarGet([ 0, 2 ]), 4 );
    test.identical( matrix.scalarGet([ 1, 2 ]), 7 );
    test.identical( matrix.buffer, exp );

    test.case = `buffer - long ${ a.format }, dims with Infinity`;
    var buffer = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ Infinity, 3 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    test.identical( matrix.scalarGet([ 0, 0 ]), 2 );
    test.identical( matrix.scalarGet([ 0, 2 ]), 4 );
    test.identical( matrix.buffer, exp );

    test.case = `buffer - vectorAdapter from ${ a.format }, regular dims values`;
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ 2, 3 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    test.identical( matrix.scalarGet([ 0, 0 ]), 2 );
    test.identical( matrix.scalarGet([ 0, 2 ]), 4 );
    test.identical( matrix.scalarGet([ 1, 2 ]), 7 );
    test.identical( matrix.buffer, exp._vectorBuffer );

    test.case = `buffer - vectorAdapter from ${ a.format }, dims with Infinity`;
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ Infinity, 3 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    test.identical( matrix.scalarGet([ 0, 0 ]), 2 );
    test.identical( matrix.scalarGet([ 0, 2 ]), 4 );
    test.identical( matrix.buffer, exp._vectorBuffer );

    test.close( '2D matrix' );

    /* - */

    test.open( '3D matrix' );

    test.case = `buffer - long ${ a.format }, regular dims values`;
    var buffer = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ 2, 3, 2 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    test.identical( matrix.scalarGet([ 0, 0, 0 ]), 2 );
    test.identical( matrix.scalarGet([ 1, 2, 0 ]), 7 );
    test.identical( matrix.scalarGet([ 0, 0, 1 ]), 8 );
    test.identical( matrix.scalarGet([ 1, 2, 1 ]), 13 );
    test.identical( matrix.buffer, exp );

    test.case = `buffer - long ${ a.format }, dims with Infinity`;
    var buffer = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ Infinity, 3, Infinity ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    test.identical( matrix.scalarGet([ 0, 0, 0 ]), 2 );
    test.identical( matrix.scalarGet([ 0, 2, 0 ]), 4 );
    test.identical( matrix.buffer, exp );

    test.case = `buffer - vectorAdapter from ${ a.format }, regular dims values`;
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ 2, 3, 2 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    test.identical( matrix.scalarGet([ 0, 0, 0 ]), 2 );
    test.identical( matrix.scalarGet([ 1, 2, 0 ]), 7 );
    test.identical( matrix.scalarGet([ 0, 0, 1 ]), 8 );
    test.identical( matrix.scalarGet([ 1, 2, 1 ]), 13 );
    test.identical( matrix.buffer, exp._vectorBuffer );

    test.case = `buffer - vectorAdapter from ${ a.format }, dims with Infinity`;
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ Infinity, 3, Infinity ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    test.identical( matrix.scalarGet([ 0, 0, 0 ]), 2 );
    test.identical( matrix.scalarGet([ 0, 2, 0 ]), 4 );
    test.identical( matrix.buffer, exp._vectorBuffer );

    test.close( '3D matrix' );

    /* - */

    test.open( '4D matrix' );

    test.case = `buffer - long ${ a.format }, regular dims values`;
    var buffer = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ 1, 3, 2, 2 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    test.identical( matrix.scalarGet([ 0, 0, 0, 0 ]), 2 );
    test.identical( matrix.scalarGet([ 0, 2, 0, 0 ]), 4 );
    test.identical( matrix.scalarGet([ 0, 2, 1, 0 ]), 7 );
    test.identical( matrix.scalarGet([ 0, 2, 0, 1 ]), 10 );
    test.identical( matrix.scalarGet([ 0, 2, 1, 1 ]), 13 );
    test.identical( matrix.buffer, exp );

    test.case = `buffer - long ${ a.format }, dims with Infinity`;
    var buffer = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ Infinity, 3, 2, Infinity ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    test.identical( matrix.scalarGet([ 0, 0, 0, 0 ]), 2 );
    test.identical( matrix.scalarGet([ 0, 2, 0, 0 ]), 4 );
    test.identical( matrix.scalarGet([ 0, 0, 1, 0 ]), 5 );
    test.identical( matrix.scalarGet([ 0, 2, 1, 0 ]), 7 );
    test.identical( matrix.buffer, exp );

    test.case = `buffer - vectorAdapter from ${ a.format }, regular dims values`;
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ 1, 3, 2, 2 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    test.identical( matrix.scalarGet([ 0, 0, 0, 0 ]), 2 );
    test.identical( matrix.scalarGet([ 0, 2, 0, 0 ]), 4 );
    test.identical( matrix.scalarGet([ 0, 2, 1, 0 ]), 7 );
    test.identical( matrix.scalarGet([ 0, 2, 0, 1 ]), 10 );
    test.identical( matrix.scalarGet([ 0, 2, 1, 1 ]), 13 );
    test.identical( matrix.buffer, exp._vectorBuffer );

    test.case = `buffer - vectorAdapter from ${ a.format }, dims with Infinity`;
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ Infinity, 3, 2, Infinity ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    test.identical( matrix.scalarGet([ 0, 0, 0, 0 ]), 2 );
    test.identical( matrix.scalarGet([ 0, 2, 0, 0 ]), 4 );
    test.identical( matrix.scalarGet([ 0, 0, 1, 0 ]), 5 );
    test.identical( matrix.scalarGet([ 0, 2, 1, 0 ]), 7 );
    test.identical( matrix.buffer, exp._vectorBuffer );

    test.close( '4D matrix' );
  }

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.scalarGet() );

  test.case = 'extra arguments';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.scalarGet( [ 1, 1 ], [ 0, 0 ] ) );

  test.case = 'wrong type of indexNd';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.scalarGet( 0 ) );
  test.shouldThrowErrorSync( () => matrix.scalarGet( 0, 0 ) );

  test.case = 'wrong values in indexNd';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.scalarGet( [ 0, undefined ] ) );
  test.shouldThrowErrorSync( () => matrix.scalarGet( [ undefined, 0 ] ) );

  test.case = 'some indexNd values is out of range of matrix';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.scalarGet([ 2, 2 ]) );
  test.shouldThrowErrorSync( () => matrix.scalarGet([ 1, 3 ]) );

  test.case = 'get value from empty matrix';
  var matrix = _.Matrix.Make([ 0, 0 ]);
  test.shouldThrowErrorSync( () => matrix.scalarGet([ 0, 0 ]) );
}

//

function scalarSet( test )
{
  _.vectorAdapter.contextsForTesting({ onEach : act });

  function act( a )
  {
    test.open( '2D matrix' );

    test.case = `buffer - long ${ a.format }, regular dims values`;
    var buffer = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ 2, 3 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.longMake([ 1, 0, 3, 0, 5, 6, 0, 8, 9 ]);
    matrix.scalarSet( [ 0, 0 ], 0 );
    matrix.scalarSet( [ 0, 2 ], 0 );
    var got = matrix.scalarSet( [ 1, 2 ], 0 );
    test.identical( got.buffer, exp );
    test.is( got === matrix );

    test.case = `buffer - long ${ a.format }, dims with Infinity`;
    var buffer = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ Infinity, 3 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.longMake([ 1, 0, 3, 0, 5, 6, 7, 8, 9 ]);
    matrix.scalarSet([ 0, 0 ], 0 );
    var got = matrix.scalarSet( [ 0, 2 ], 0 );
    test.identical( got.buffer, exp );
    test.is( got === matrix );

    test.case = `buffer - vectorAdapter from ${ a.format }, regular dims values`;
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 5, 8, 9 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ 2, 3 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.vadMake([ 1, 0, 3, 0, 5, 6, 0, 8, 9 ]);
    matrix.scalarSet( [ 0, 0 ], 0 );
    matrix.scalarSet( [ 0, 2 ], 0 );
    var got = matrix.scalarSet( [ 1, 2 ], 0 );
    test.identical( got.buffer, exp._vectorBuffer );
    test.is( got === matrix );

    test.case = `buffer - vectorAdapter from ${ a.format }, dims with Infinity`;
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ Infinity, 3 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.vadMake([ 1, 0, 3, 0, 5, 6, 7, 8, 9 ]);
    matrix.scalarSet( [ 0, 0 ], 0 );
    var got = matrix.scalarSet( [ 0, 2 ], 0 );
    test.identical( got.buffer, exp._vectorBuffer );
    test.is( got === matrix );

    test.close( '2D matrix' );

    /* - */

    test.open( '3D matrix' );

    test.case = `buffer - long ${ a.format }, regular dims values`;
    var buffer = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ 2, 3, 2 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.longMake([ 1, 0, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 0, 14, 15 ]);
    matrix.scalarSet( [ 0, 0, 0 ], 0 );
    var got = matrix.scalarSet( [ 1, 2, 1 ], 0 );
    test.identical( got.buffer, exp );
    test.is( got === matrix );

    test.case = `buffer - long ${ a.format }, dims with Infinity`;
    var buffer = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ Infinity, 3, Infinity ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.longMake([ 1, 0, 3, 0, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    matrix.scalarSet( [ 0, 0, 0 ], 0 );
    var got = matrix.scalarSet( [ 0, 2, 0 ], 0 );
    test.identical( got.buffer, exp );
    test.is( got === matrix );

    test.case = `buffer - vectorAdapter from ${ a.format }, regular dims values`;
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ 2, 3, 2 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.vadMake([ 1, 0, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 0, 14, 15 ]);
    matrix.scalarSet( [ 0, 0, 0 ], 0 );
    var got = matrix.scalarSet( [ 1, 2, 1 ], 0 );
    test.identical( got.buffer, exp._vectorBuffer );
    test.is( got === matrix );

    test.case = `buffer - vectorAdapter from ${ a.format }, dims with Infinity`;
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ Infinity, 3, Infinity ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.vadMake([ 1, 0, 3, 0, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    var got = matrix.scalarSet( [ 0, 0, 0 ], 0 );
    matrix.scalarSet( [ 0, 2, 0 ], 0 );
    test.identical( got.buffer, exp._vectorBuffer );
    test.is( got === matrix );

    test.close( '3D matrix' );

    /* - */

    test.open( '4D matrix' );

    test.case = `buffer - long ${ a.format }, regular dims values`;
    var buffer = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ 1, 3, 2, 2 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.longMake([ 1, 0, 3, 4, 5, 6, 0, 8, 9, 10, 11, 12, 0, 14, 15 ]);
    matrix.scalarSet( [ 0, 0, 0, 0 ], 0 );
    matrix.scalarSet( [ 0, 2, 1, 0 ], 0 );
    var got = matrix.scalarSet( [ 0, 2, 1, 1 ], 0 );
    test.identical( got.buffer, exp );
    test.is( got === matrix );

    test.case = `buffer - long ${ a.format }, dims with Infinity`;
    var buffer = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ Infinity, 3, 2, Infinity ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.longMake([ 1, 0, 3, 0, 0, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    matrix.scalarSet( [ 0, 0, 0, 0 ], 0 );
    matrix.scalarSet( [ 0, 2, 0, 0 ], 0 );
    var got = matrix.scalarSet( [ 0, 0, 1, 0 ], 0 );
    test.identical( got.buffer, exp );
    test.is( got === matrix );

    test.case = `buffer - vectorAdapter from ${ a.format }, regular dims values`;
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ 1, 3, 2, 2 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.vadMake([ 1, 0, 3, 4, 5, 6, 0, 8, 9, 10, 11, 12, 0, 14, 15 ]);
    matrix.scalarSet( [ 0, 0, 0, 0 ], 0 );
    matrix.scalarSet( [ 0, 2, 1, 0 ], 0 );
    var got = matrix.scalarSet( [ 0, 2, 1, 1 ], 0 );
    test.identical( got.buffer, exp._vectorBuffer );
    test.is( got === matrix );

    test.case = `buffer - vectorAdapter from ${ a.format }, dims with Infinity`;
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ Infinity, 3, 2, Infinity ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.vadMake([ 1, 0, 3, 0, 0, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ]);
    matrix.scalarSet( [ 0, 0, 0, 0 ], 0 );
    matrix.scalarSet( [ 0, 2, 0, 0 ], 0 );
    var got = matrix.scalarSet( [ 0, 0, 1, 0 ], 0 );
    test.identical( got.buffer, exp._vectorBuffer );
    test.is( got === matrix );

    test.close( '4D matrix' );
  }

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.scalarSet() );

  test.case = 'not enough arguments';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.scalarSet([ 0, 0 ]) );

  test.case = 'extra arguments';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.scalarSet( [ 1, 1 ], 1, 1 ) );

  test.case = 'wrong type of value';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.scalarSet( [ 0, 0 ], null ) );

  test.case = 'wrong values in indexNd';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.scalarSet( [ 0, undefined ], 1 ) );
  test.shouldThrowErrorSync( () => matrix.scalarSet( [ undefined, 0 ], 1 ) );

  test.case = 'some indexNd values is out of range of matrix';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.scalarSet( [ 2, 2 ], 1 ) );
  test.shouldThrowErrorSync( () => matrix.scalarSet( [ 1, 3 ], 1 ) );

  test.case = 'set value in empty matrix';
  var matrix = _.Matrix.Make([ 0, 0 ]);
  test.shouldThrowErrorSync( () => matrix.scalarSet( [ 0, 0 ], 2 ) );
}

//

function eGet( test )
{
  _.vectorAdapter.contextsForTesting({ onEach : act });

  function act( a )
  {
    test.case = `buffer - long ${ a.format }`;
    var buffer = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ 2, 3 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    test.identical( matrix.eGet( 0 ), _.vectorAdapter.fromLong( a.longMake([ 2, 5 ]) ) );
    test.identical( matrix.eGet( 1 ), _.vectorAdapter.fromLong( a.longMake([ 3, 6 ]) ) );
    test.identical( matrix.buffer, exp );

    test.case = `buffer - vector ${ a.form }`;
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ 2, 3 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    test.identical( matrix.eGet( 0 ), _.vectorAdapter.fromLong( a.longMake([ 2, 5 ]) ) );
    test.identical( matrix.eGet( 1 ), _.vectorAdapter.fromLong( a.longMake([ 3, 6 ]) ) );
    test.identical( matrix.buffer, exp._vectorBuffer );

    /* */

    test.case = `buffer - long ${ a.format }`;
    var buffer = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ 2, 3 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    test.identical( matrix.eGet( 0 ), _.vectorAdapter.fromLong( a.longMake([ 2, 5 ]) ) );
    test.identical( matrix.eGet( 1 ), _.vectorAdapter.fromLong( a.longMake([ 3, 6 ]) ) );
    test.identical( matrix.buffer, exp );

    test.case = `buffer - vector ${ a.form }`;
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ 2, 3 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    test.identical( matrix.eGet( 0 ), _.vectorAdapter.fromLong( a.longMake([ 2, 5 ]) ) );
    test.identical( matrix.eGet( 1 ), _.vectorAdapter.fromLong( a.longMake([ 3, 6 ]) ) );
    test.identical( matrix.buffer, exp._vectorBuffer );
  }

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.eGet() );

  test.case = 'extra arguments';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.eGet( 0, 0 ) );

  test.case = 'negative index';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.eGet( -1 ) );

  test.case = 'index is greater than max dimension value';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.eGet( 2 ) );

  test.case = 'wrong type of index';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.eGet([ 0 ]) );
}

//

function eSet( test )
{
  // m32.eSet( 0, [ 10, 20 ] ) // aaa2 : add test cases like this /* Dmytro : implemented */

  _.vectorAdapter.contextsForTesting({ onEach : act });

  function act( a )
  {
    test.case = `buffer - long ${ a.format }, full replacing`;
    var buffer = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ 3, 2 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.longMake([ 1, 55, 77, 55, 77, 55, 77, 8, 9 ]);
    matrix.eSet( 0, a.longMake([ 55, 55, 55 ]) );
    var got = matrix.eSet( 1, a.longMake([ 77, 77, 77 ]) );
    test.identical( matrix.buffer, exp );
    test.is( got === matrix );

    test.case = `buffer - vector ${ a.form }, full replacing`;
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ 3, 2 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.vadMake([ 1, 55, 77, 55, 77, 55, 77, 8, 9 ]);
    matrix.eSet( 0, a.vadMake([ 55, 55, 55 ]) );
    var got = matrix.eSet( 1, a.vadMake([ 77, 77, 77 ]) );
    test.identical( matrix.buffer, exp._vectorBuffer );
    test.is( got === matrix );

    /* */

    test.case = `buffer - long ${ a.format }, partial replacing`;
    var buffer = a.longMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ 3, 2 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.longMake([ 1, 55, 77, 55, 77, 0, 0, 8, 9 ]);
    matrix.eSet( 0, a.longMake([ 55, 55 ]) );
    var got = matrix.eSet( 1, a.longMake([ 77, 77 ]) );
    test.identical( matrix.buffer, exp );
    test.is( got === matrix );

    test.case = `buffer - vector ${ a.form }, partial replacing`;
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    var matrix = new _.Matrix
    ({
      buffer,
      dims : [ 3, 2 ],
      offset : 1,
      inputRowMajor : 1,
    });
    var exp = a.vadMake([ 1, 55, 77, 55, 77, 0, 0, 8, 9 ]);
    matrix.eSet( 0, a.vadMake([ 55, 55 ]) );
    var got = matrix.eSet( 1, a.vadMake([ 77, 77 ]) );
    test.identical( matrix.buffer, exp._vectorBuffer );
    test.is( got === matrix );
  }

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.eSet() );

  test.case = 'not enough arguments';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.eSet( 0 ) );

  test.case = 'extra arguments';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.eSet( 0, [ 1, 2 ], [ 2, 1 ] ) );

  test.case = 'negative index';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.eSet( -1, [ 1, 2 ] ) );

  test.case = 'index is greater than max dimension value';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.eSet( 2, [ 2, 2 ] ) );

  test.case = 'wrong type of index';
  var matrix = _.Matrix.Make( 2 );
  test.shouldThrowErrorSync( () => matrix.eSet([ 0 ], [ 2, 2 ]) );
}

// --
// maker
// --

function MakeChangeDimsLength( test )
{
  test.open( '2D' );

  test.case = 'dims - 0';
  var got = _.Matrix.Make( 0 );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'dims - 1';
  var got = _.Matrix.Make( 1 );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.strides, [ 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - 2';
  var got = _.Matrix.Make( 2 );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 4 ) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - Infinity';
  var got = _.Matrix.Make( Infinity );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ Infinity, Infinity ]';
  var got = _.Matrix.Make([ Infinity, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0 ]';
  var got = _.Matrix.Make([ 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'dims - [ 1, 1 ]';
  var got = _.Matrix.Make([ 1, 1 ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.strides, [ 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - [ 3, 2 ]';
  var got = _.Matrix.Make([ 3, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - [ 2, 0 ]';
  var got = _.Matrix.Make([ 2, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 0 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - [ 0, 2 ]';
  var got = _.Matrix.Make([ 0, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 2 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'dims - [ Infinity, 2 ]';
  var got = _.Matrix.Make([ 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'dims - [ 2, Infinity ]';
  var got = _.Matrix.Make([ 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.close( '2D' );

  /* - */

  test.open( '3D' );

  test.case = 'dims - [ Infinity, Infinity, Infinity ]';
  var got = _.Matrix.Make([ Infinity, Infinity, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ Infinity, Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0, 1 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0, 0 ]';
  var got = _.Matrix.Make([ 0, 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0, 0 ] );
  test.identical( got.strides, [ 1, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0, 0 ] );

  test.case = 'dims - [ 1, 1, 1 ]';
  var got = _.Matrix.Make([ 1, 1, 1 ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ 1, 1, 1 ] );
  test.identical( got.strides, [ 1, 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - [ 2, 3, 4 ]';
  var got = _.Matrix.Make([ 2, 3, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 24 ) );
  test.identical( got.dims, [ 2, 3, 4 ] );
  test.identical( got.strides, [ 1, 2, 6 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6 ] );

  test.case = 'dims - [ 0, 3, 4 ]';
  var got = _.Matrix.Make([ 0, 3, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 3, 4 ] );
  test.identical( got.strides, [ 1, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0, 0 ] );

  test.case = 'dims - [ 2, 0, 4 ]';
  var got = _.Matrix.Make([ 2, 0, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 0, 4 ] );
  test.identical( got.strides, [ 1, 2, 0 ] );
  test.identical( got.stridesEffective, [ 1, 2, 0 ] );

  test.case = 'dims - [ 2, 3, 0 ]';
  var got = _.Matrix.Make([ 2, 3, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 3, 0 ] );
  test.identical( got.strides, [ 1, 2, 6 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6 ] );

  test.case = 'dims - [ Infinity, 3, 4 ]';
  var got = _.Matrix.Make([ Infinity, 3, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 12 ) );
  test.identical( got.dims, [ Infinity, 3, 4 ] );
  test.identical( got.strides, [ 0, 1, 3 ] );
  test.identical( got.stridesEffective, [ 0, 1, 3 ] );

  test.case = 'dims - [ 2, Infinity, 4 ]';
  var got = _.Matrix.Make([ 2, Infinity, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 8 ) );
  test.identical( got.dims, [ 2, Infinity, 4 ] );
  test.identical( got.strides, [ 1, 0, 2 ] );
  test.identical( got.stridesEffective, [ 1, 0, 2 ] );

  test.case = 'dims - [ 2, 3, Infinity ]';
  var got = _.Matrix.Make([ 2, 3, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 2, 3, Infinity ] );
  test.identical( got.strides, [ 1, 2, 6 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.close( '3D' );

  /* - */

  test.open( '4D' );

  test.case = 'dims - [ Infinity, Infinity, Infinity, Infinity ]';
  var got = _.Matrix.Make([ Infinity, Infinity, Infinity, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ Infinity, Infinity, Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0, 1, 1 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0, 0, 0 ]';
  var got = _.Matrix.Make([ 0, 0, 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0, 0, 0 ] );
  test.identical( got.strides, [ 1, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0, 0, 0 ] );

  test.case = 'dims - [ 1, 1, 1, 1 ]';
  var got = _.Matrix.Make([ 1, 1, 1, 1 ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ 1, 1, 1, 1 ] );
  test.identical( got.strides, [ 1, 1, 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - [ 2, 3, 4, 5 ]';
  var got = _.Matrix.Make([ 2, 3, 4, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 120 ) );
  test.identical( got.dims, [ 2, 3, 4, 5 ] );
  test.identical( got.strides, [ 1, 2, 6, 24 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6, 24 ] );

  test.case = 'dims - [ 0, 3, 4, 5 ]';
  var got = _.Matrix.Make([ 0, 3, 4, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 3, 4, 5 ] );
  test.identical( got.strides, [ 1, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0, 0, 0 ] );

  test.case = 'dims - [ 2, 0, 4, 5 ]';
  var got = _.Matrix.Make([ 2, 0, 4, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 0, 4, 5 ] );
  test.identical( got.strides, [ 1, 2, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 2, 0, 0 ] );

  test.case = 'dims - [ 2, 3, 0, 5 ]';
  var got = _.Matrix.Make([ 2, 3, 0, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 3, 0, 5 ] );
  test.identical( got.strides, [ 1, 2, 6, 0 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6, 0 ] );

  test.case = 'dims - [ 2, 3, 4, 0 ]';
  var got = _.Matrix.Make([ 2, 3, 4, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 3, 4, 0 ] );
  test.identical( got.strides, [ 1, 2, 6, 24 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6, 24 ] );

  test.case = 'dims - [ Infinity, 3, 4, 5 ]';
  var got = _.Matrix.Make([ Infinity, 3, 4, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 60 ) );
  test.identical( got.dims, [ Infinity, 3, 4, 5 ] );
  test.identical( got.strides, [ 0, 1, 3, 12 ] );
  test.identical( got.stridesEffective, [ 0, 1, 3, 12 ] );

  test.case = 'dims - [ 2, Infinity, 4, 5 ]';
  var got = _.Matrix.Make([ 2, Infinity, 4, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 40 ) );
  test.identical( got.dims, [ 2, Infinity, 4, 5 ] );
  test.identical( got.strides, [ 1, 0, 2, 8 ] );
  test.identical( got.stridesEffective, [ 1, 0, 2, 8 ] );

  test.case = 'dims - [ 2, 3, Infinity, 5 ]';
  var got = _.Matrix.Make([ 2, 3, Infinity, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 30 ) );
  test.identical( got.dims, [ 2, 3, Infinity, 5 ] );
  test.identical( got.strides, [ 1, 2, 6, 6 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6, 6 ] );

  test.case = 'dims - [ 2, 3, 4, Infinity ]';
  var got = _.Matrix.Make([ 2, 3, 4, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 24 ) );
  test.identical( got.dims, [ 2, 3, 4, Infinity ] );
  test.identical( got.strides, [ 1, 2, 6, 24 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6 ] );

  test.close( '4D' );
}

//

function MakeChangeDimsType( test )
{
  test.case = 'dims - Array';
  var got = _.Matrix.Make([ 3, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - Unroll';
  var got = _.Matrix.Make( _.unrollMake([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - ArgumentsArray';
  var got = _.Matrix.Make( _.argumentsArrayMake([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - U8x';
  var got = _.Matrix.Make( new U8x([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - I16x';
  var got = _.Matrix.Make( new I16x([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - F32x';
  var got = _.Matrix.Make( new F32x([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - F64x';
  var got = _.Matrix.Make( new F64x([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - avector';
  var got = _.Matrix.Make( _.avector.make([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - VectorAdapter';
  var got = _.Matrix.Make( _.vectorAdapter.from([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - VectorAdapter, routine fromLongLrangeAndStride';
  var got = _.Matrix.Make( _.vectorAdapter.fromLongLrangeAndStride( [ 1, 2, 3, 1, 2 ], 2, 2, 2 ) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix.Make() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.Make( [ 1, 2 ], [ 1, 2 ] ) );

  test.case = 'wrong type of dims';
  test.shouldThrowErrorSync( () => _.Matrix.Make( { a : 1 } ) );
  test.shouldThrowErrorSync( () => _.Matrix.Make( 'wrong' ) );

  test.case = 'wrong length of dims';
  test.shouldThrowErrorSync( () => _.Matrix.Make([ 1 ]) );

  test.case = 'negative value in dims';
  test.shouldThrowErrorSync( () => _.Matrix.Make([ -1, 2 ]) );
}

//

function MakeSquareChangeBufferLength( test )
{

  test.case = 'buffer - 0';
  var got = _.Matrix.MakeSquare( 0 );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'buffer - 1';
  var got = _.Matrix.MakeSquare( 1 );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'buffer - 2';
  var got = _.Matrix.MakeSquare( 2 );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 4 ) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'buffer - Infinity';
  var got = _.Matrix.MakeSquare( Infinity );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ Infinity, Infinity ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'buffer - []';
  var got = _.Matrix.MakeSquare
  ([
  ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, [] );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'buffer - [ 1 ]';
  var got = _.Matrix.MakeSquare
  ([
    1
  ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, [ 1 ] );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'buffer - [ 1, -2, 3, -4, 5, 6, 0, 0, 2 ]';
  var got = _.Matrix.MakeSquare
  ([
     1, -2,  3,
    -4,  5,  6,
     0,  0,  2
  ]);
  test.identical( got.length, 3 );
  test.identical( got.buffer, [ 1, -2, 3, -4, 5, 6, 0, 0, 2 ] );
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 3, 1 ] );
}

//

function MakeSquareChangeBufferType( test )
{
  test.case = 'buffer - Array';
  var got = _.Matrix.MakeSquare
  ([
     1, -2,
    -4,  5,
  ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, [ 1, -2, -4, 5 ] );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 2, 1 ] );

  test.case = 'buffer - Unroll';
  var buffer = _.unrollMake
  ([
     1, -2,
    -4,  5,
  ]);
  var got = _.Matrix.MakeSquare( buffer );
  test.identical( got.length, 2 );
  test.identical( got.buffer, [ 1, -2, -4, 5 ] );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 2, 1 ] );

  test.case = 'buffer - ArgumentsArray';
  var buffer = _.unrollMake
  ([
     1, -2,
    -4,  5,
  ]);
  var got = _.Matrix.MakeSquare( buffer );
  test.identical( got.length, 2 );
  test.identical( got.buffer, [ 1, -2, -4, 5 ] );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 2, 1 ] );

  test.case = 'buffer - BufferTyped, U8x';
  var buffer = new U8x
  ([
    1,  2,
    4,  5,
  ]);
  var got = _.Matrix.MakeSquare( buffer );
  test.identical( got.length, 2 );
  test.identical( got.buffer, new U8x([ 1, 2, 4, 5 ]) );

  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 2, 1 ] );

  test.case = 'buffer - BufferTyped, I16x';
  var buffer = new I16x
  ([
     1, -2,
    -4,  5,
  ]);
  var got = _.Matrix.MakeSquare( buffer );
  test.identical( got.length, 2 );
  test.identical( got.buffer, new I16x([ 1, -2, -4, 5 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 2, 1 ] );

  test.case = 'buffer - BufferTyped, F32x';
  var buffer = new F32x
  ([
     1, -2,
    -4,  5,
  ]);
  var got = _.Matrix.MakeSquare( buffer );
  test.identical( got.length, 2 );
  test.identical( got.buffer, new F32x([ 1, -2, -4, 5 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 2, 1 ] );

  test.case = 'buffer - BufferTyped, F64x';
  var buffer = new F64x
  ([
     1, -2,
    -4,  5,
  ]);
  var got = _.Matrix.MakeSquare( buffer );
  test.identical( got.length, 2 );
  test.identical( got.buffer, new F64x([ 1, -2, -4, 5 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 2, 1 ] );

  test.case = 'buffer - avector';
  var buffer = _.avector.make
  ([
     1, -2,
    -4,  5,
  ]);
  var got = _.Matrix.MakeSquare( buffer );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, -2, -4, 5 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 2, 1 ] );

  test.case = 'buffer - VectorAdapter';
  var buffer = _.vectorAdapter.from
  ([
     1, -2,
    -4,  5,
  ]);
  var got = _.Matrix.MakeSquare( buffer );
  test.identical( got.length, 2 );
  test.identical( got.buffer, [ 1, -2, -4, 5 ] );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 2, 1 ] );
  test.identical( got.stridesEffective, [ 2, 1 ] );

  test.case = 'buffer - VectorAdapter, routine fromLongLrangeAndStride';
  var buffer = _.vectorAdapter.fromLongLrangeAndStride( [ 0,  1,  2, -2, 1, -4,  3,  5 ], 1, 4, 2 );
  var got = _.Matrix.MakeSquare( buffer );
  test.identical( got.length, 2 );
  test.identical( got.buffer, [ 0,  1,  2, -2, 1, -4,  3,  5 ] );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 4, 2 ] );
  test.identical( got.stridesEffective, [ 4, 2 ] );

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeSquare() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeSquare( [ 1, 2, 3, 4 ], 2 ) );

  test.case = 'wrong type of buffer';
  test.shouldThrowErrorSync( () => _.Matrix.MakeSquare( { 'wrong' : 1 } ) );
  test.shouldThrowErrorSync( () => _.Matrix.MakeSquare( 'wrong' ) );

  test.case = 'wrong length of buffer';
  test.shouldThrowErrorSync( () => _.Matrix.MakeSquare([ 1, 2, 3 ]) );
}

//

function MakeZeroChangeDimsLength( test )
{
  test.open( '2D' );

  test.case = 'dims - 0';
  var got = _.Matrix.MakeZero( 0 );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'dims - 1';
  var got = _.Matrix.MakeZero( 1 );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.strides, [ 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - 2';
  var got = _.Matrix.MakeZero( 2 );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 4 ) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - Infinity';
  var got = _.Matrix.MakeZero( Infinity );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ Infinity, Infinity ]';
  var got = _.Matrix.MakeZero([ Infinity, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0 ]';
  var got = _.Matrix.MakeZero([ 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'dims - [ 1, 1 ]';
  var got = _.Matrix.MakeZero([ 1, 1 ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.strides, [ 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - [ 3, 2 ]';
  var got = _.Matrix.MakeZero([ 3, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - [ 2, 0 ]';
  var got = _.Matrix.MakeZero([ 2, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 0 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - [ 0, 2 ]';
  var got = _.Matrix.MakeZero([ 0, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 2 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'dims - [ Infinity, 2 ]';
  var got = _.Matrix.MakeZero([ 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'dims - [ 2, Infinity ]';
  var got = _.Matrix.MakeZero([ 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.close( '2D' );

  /* - */

  test.open( '3D' );

  test.case = 'dims - [ Infinity, Infinity, Infinity ]';
  var got = _.Matrix.MakeZero([ Infinity, Infinity, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ Infinity, Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0, 1 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0, 0 ]';
  var got = _.Matrix.MakeZero([ 0, 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0, 0 ] );
  test.identical( got.strides, [ 1, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0, 0 ] );

  test.case = 'dims - [ 1, 1, 1 ]';
  var got = _.Matrix.MakeZero([ 1, 1, 1 ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ 1, 1, 1 ] );
  test.identical( got.strides, [ 1, 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - [ 2, 3, 4 ]';
  var got = _.Matrix.MakeZero([ 2, 3, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 24 ) );
  test.identical( got.dims, [ 2, 3, 4 ] );
  test.identical( got.strides, [ 1, 2, 6 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6 ] );

  test.case = 'dims - [ 0, 3, 4 ]';
  var got = _.Matrix.MakeZero([ 0, 3, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 3, 4 ] );
  test.identical( got.strides, [ 1, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0, 0 ] );

  test.case = 'dims - [ 2, 0, 4 ]';
  var got = _.Matrix.MakeZero([ 2, 0, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 0, 4 ] );
  test.identical( got.strides, [ 1, 2, 0 ] );
  test.identical( got.stridesEffective, [ 1, 2, 0 ] );

  test.case = 'dims - [ 2, 3, 0 ]';
  var got = _.Matrix.MakeZero([ 2, 3, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 3, 0 ] );
  test.identical( got.strides, [ 1, 2, 6 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6 ] );

  test.case = 'dims - [ Infinity, 3, 4 ]';
  var got = _.Matrix.MakeZero([ Infinity, 3, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 12 ) );
  test.identical( got.dims, [ Infinity, 3, 4 ] );
  test.identical( got.strides, [ 0, 1, 3 ] );
  test.identical( got.stridesEffective, [ 0, 1, 3 ] );

  test.case = 'dims - [ 2, Infinity, 4 ]';
  var got = _.Matrix.MakeZero([ 2, Infinity, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 8 ) );
  test.identical( got.dims, [ 2, Infinity, 4 ] );
  test.identical( got.strides, [ 1, 0, 2 ] );
  test.identical( got.stridesEffective, [ 1, 0, 2 ] );

  test.case = 'dims - [ 2, 3, Infinity ]';
  var got = _.Matrix.MakeZero([ 2, 3, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 2, 3, Infinity ] );
  test.identical( got.strides, [ 1, 2, 6 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.close( '3D' );

  /* - */

  test.open( '4D' );

  test.case = 'dims - [ Infinity, Infinity, Infinity, Infinity ]';
  var got = _.Matrix.MakeZero([ Infinity, Infinity, Infinity, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ Infinity, Infinity, Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0, 1, 1 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0, 0, 0 ]';
  var got = _.Matrix.MakeZero([ 0, 0, 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0, 0, 0 ] );
  test.identical( got.strides, [ 1, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0, 0, 0 ] );

  test.case = 'dims - [ 1, 1, 1, 1 ]';
  var got = _.Matrix.MakeZero([ 1, 1, 1, 1 ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ 1, 1, 1, 1 ] );
  test.identical( got.strides, [ 1, 1, 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - [ 2, 3, 4, 5 ]';
  var got = _.Matrix.MakeZero([ 2, 3, 4, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 120 ) );
  test.identical( got.dims, [ 2, 3, 4, 5 ] );
  test.identical( got.strides, [ 1, 2, 6, 24 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6, 24 ] );

  test.case = 'dims - [ 0, 3, 4, 5 ]';
  var got = _.Matrix.MakeZero([ 0, 3, 4, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 3, 4, 5 ] );
  test.identical( got.strides, [ 1, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0, 0, 0 ] );

  test.case = 'dims - [ 2, 0, 4, 5 ]';
  var got = _.Matrix.MakeZero([ 2, 0, 4, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 0, 4, 5 ] );
  test.identical( got.strides, [ 1, 2, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 2, 0, 0 ] );

  test.case = 'dims - [ 2, 3, 0, 5 ]';
  var got = _.Matrix.MakeZero([ 2, 3, 0, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 3, 0, 5 ] );
  test.identical( got.strides, [ 1, 2, 6, 0 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6, 0 ] );

  test.case = 'dims - [ 2, 3, 4, 0 ]';
  var got = _.Matrix.MakeZero([ 2, 3, 4, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 3, 4, 0 ] );
  test.identical( got.strides, [ 1, 2, 6, 24 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6, 24 ] );

  test.case = 'dims - [ Infinity, 3, 4, 5 ]';
  var got = _.Matrix.MakeZero([ Infinity, 3, 4, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 60 ) );
  test.identical( got.dims, [ Infinity, 3, 4, 5 ] );
  test.identical( got.strides, [ 0, 1, 3, 12 ] );
  test.identical( got.stridesEffective, [ 0, 1, 3, 12 ] );

  test.case = 'dims - [ 2, Infinity, 4, 5 ]';
  var got = _.Matrix.MakeZero([ 2, Infinity, 4, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 40 ) );
  test.identical( got.dims, [ 2, Infinity, 4, 5 ] );
  test.identical( got.strides, [ 1, 0, 2, 8 ] );
  test.identical( got.stridesEffective, [ 1, 0, 2, 8 ] );

  test.case = 'dims - [ 2, 3, Infinity, 5 ]';
  var got = _.Matrix.MakeZero([ 2, 3, Infinity, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 30 ) );
  test.identical( got.dims, [ 2, 3, Infinity, 5 ] );
  test.identical( got.strides, [ 1, 2, 6, 6 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6, 6 ] );

  test.case = 'dims - [ 2, 3, 4, Infinity ]';
  var got = _.Matrix.MakeZero([ 2, 3, 4, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 24 ) );
  test.identical( got.dims, [ 2, 3, 4, Infinity ] );
  test.identical( got.strides, [ 1, 2, 6, 24 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6 ] );

  test.close( '4D' );
}

//

function MakeZeroChangeDimsType( test )
{
  test.case = 'dims - Array';
  var got = _.Matrix.MakeZero([ 3, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - Unroll';
  var got = _.Matrix.MakeZero( _.unrollMake([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - ArgumentsArray';
  var got = _.Matrix.MakeZero( _.argumentsArrayMake([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - U8x';
  var got = _.Matrix.MakeZero( new U8x([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - I16x';
  var got = _.Matrix.MakeZero( new I16x([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - F32x';
  var got = _.Matrix.MakeZero( new F32x([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - F64x';
  var got = _.Matrix.MakeZero( new F64x([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - avector';
  var got = _.Matrix.MakeZero( _.avector.make([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - VectorAdapter';
  var got = _.Matrix.MakeZero( _.vectorAdapter.from([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - VectorAdapter, routine fromLongLrangeAndStride';
  var got = _.Matrix.MakeZero( _.vectorAdapter.fromLongLrangeAndStride( [ 1, 2, 3, 1, 2 ], 2, 2, 2 ) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeZero() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeZero( [ 1, 2 ], [ 1, 2 ] ) );

  test.case = 'wrong type of dims';
  test.shouldThrowErrorSync( () => _.Matrix.MakeZero( { a : 1 } ) );
  test.shouldThrowErrorSync( () => _.Matrix.MakeZero( 'wrong' ) );

  test.case = 'wrong length of dims';
  test.shouldThrowErrorSync( () => _.Matrix.MakeZero([ 1 ]) );

  test.case = 'negative value in dims';
  test.shouldThrowErrorSync( () => _.Matrix.MakeZero([ -1, 2 ]) );
}

//

function MakeIdentityChangeDimsLength( test )
{
  test.open( '2D' );

  test.case = 'dims - 0';
  var got = _.Matrix.MakeIdentity( 0 );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'dims - 1';
  var got = _.Matrix.MakeIdentity( 1 );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 1 ]) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.strides, [ 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - 2';
  var got = _.Matrix.MakeIdentity( 2 );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 0, 0, 1 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - Infinity';
  var got = _.Matrix.MakeIdentity( Infinity );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 1 ]) );
  test.identical( got.dims, [ Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ Infinity, Infinity ]';
  var got = _.Matrix.MakeIdentity([ Infinity, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 1 ]) );
  test.identical( got.dims, [ Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0 ]';
  var got = _.Matrix.MakeIdentity([ 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'dims - [ 1, 1 ]';
  var got = _.Matrix.MakeIdentity([ 1, 1 ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 1 ]) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.strides, [ 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - [ 3, 2 ]';
  var got = _.Matrix.MakeIdentity([ 3, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 0, 0, 0, 1, 0 ]) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - [ 2, 0 ]';
  var got = _.Matrix.MakeIdentity([ 2, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 0 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - [ 0, 2 ]';
  var got = _.Matrix.MakeIdentity([ 0, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 2 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'dims - [ Infinity, 2 ]';
  var got = _.Matrix.MakeIdentity([ 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'dims - [ 2, Infinity ]';
  var got = _.Matrix.MakeIdentity([ 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.close( '2D' );

  /* - */

  test.open( '3D' );

  test.case = 'dims - [ Infinity, Infinity, Infinity ]';
  var got = _.Matrix.MakeIdentity([ Infinity, Infinity, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 1 ]) );
  test.identical( got.dims, [ Infinity, Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0, 1 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0, 0 ]';
  var got = _.Matrix.MakeIdentity([ 0, 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0, 0 ] );
  test.identical( got.strides, [ 1, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0, 0 ] );

  test.case = 'dims - [ 1, 1, 1 ]';
  var got = _.Matrix.MakeIdentity([ 1, 1, 1 ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 1 ]) );
  test.identical( got.dims, [ 1, 1, 1 ] );
  test.identical( got.strides, [ 1, 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - [ 2, 3, 4 ]';
  var got = _.Matrix.MakeIdentity([ 2, 3, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    1, 0, 0, 1, 0, 0,
    1, 0, 0, 1, 0, 0,
    1, 0, 0, 1, 0, 0,
    1, 0, 0, 1, 0, 0,
  ]));
  test.identical( got.dims, [ 2, 3, 4 ] );
  test.identical( got.strides, [ 1, 2, 6 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6 ] );

  test.case = 'dims - [ 0, 3, 4 ]';
  var got = _.Matrix.MakeIdentity([ 0, 3, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 3, 4 ] );
  test.identical( got.strides, [ 1, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0, 0 ] );

  test.case = 'dims - [ 2, 0, 4 ]';
  var got = _.Matrix.MakeIdentity([ 2, 0, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 0, 4 ] );
  test.identical( got.strides, [ 1, 2, 0 ] );
  test.identical( got.stridesEffective, [ 1, 2, 0 ] );

  test.case = 'dims - [ 2, 3, 0 ]';
  var got = _.Matrix.MakeIdentity([ 2, 3, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 3, 0 ] );
  test.identical( got.strides, [ 1, 2, 6 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6 ] );

  test.case = 'dims - [ Infinity, 3, 4 ]';
  var got = _.Matrix.MakeIdentity([ Infinity, 3, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    1, 0, 0,
    1, 0, 0,
    1, 0, 0,
    1, 0, 0,
  ]));
  test.identical( got.dims, [ Infinity, 3, 4 ] );
  test.identical( got.strides, [ 0, 1, 3 ] );
  test.identical( got.stridesEffective, [ 0, 1, 3 ] );

  test.case = 'dims - [ 2, Infinity, 4 ]';
  var got = _.Matrix.MakeIdentity([ 2, Infinity, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    1, 0,
    1, 0,
    1, 0,
    1, 0,
  ]));
  test.identical( got.dims, [ 2, Infinity, 4 ] );
  test.identical( got.strides, [ 1, 0, 2 ] );
  test.identical( got.stridesEffective, [ 1, 0, 2 ] );

  test.case = 'dims - [ 2, 3, Infinity ]';
  var got = _.Matrix.MakeIdentity([ 2, 3, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    1, 0, 0,
    1, 0, 0,
  ]));
  test.identical( got.dims, [ 2, 3, Infinity ] );
  test.identical( got.strides, [ 1, 2, 6 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.close( '3D' );

  /* - */

  test.open( '4D' );

  test.case = 'dims - [ Infinity, Infinity, Infinity, Infinity ]';
  var got = _.Matrix.MakeIdentity([ Infinity, Infinity, Infinity, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 1 ]) );
  test.identical( got.dims, [ Infinity, Infinity, Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0, 1, 1 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0, 0, 0 ]';
  var got = _.Matrix.MakeIdentity([ 0, 0, 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0, 0, 0 ] );
  test.identical( got.strides, [ 1, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0, 0, 0 ] );

  test.case = 'dims - [ 1, 1, 1, 1 ]';
  var got = _.Matrix.MakeIdentity([ 1, 1, 1, 1 ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 1 ]) );
  test.identical( got.dims, [ 1, 1, 1, 1 ] );
  test.identical( got.strides, [ 1, 1, 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - [ 2, 3, 4, 2 ]';
  var got = _.Matrix.MakeIdentity([ 2, 3, 4, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0,
    1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0,
  ]));
  test.identical( got.dims, [ 2, 3, 4, 2 ] );
  test.identical( got.strides, [ 1, 2, 6, 24 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6, 24 ] );

  test.case = 'dims - [ 0, 3, 4, 5 ]';
  var got = _.Matrix.MakeIdentity([ 0, 3, 4, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 3, 4, 5 ] );
  test.identical( got.strides, [ 1, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0, 0, 0 ] );

  test.case = 'dims - [ 2, 0, 4, 5 ]';
  var got = _.Matrix.MakeIdentity([ 2, 0, 4, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 0, 4, 5 ] );
  test.identical( got.strides, [ 1, 2, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 2, 0, 0 ] );

  test.case = 'dims - [ 2, 3, 0, 5 ]';
  var got = _.Matrix.MakeIdentity([ 2, 3, 0, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 3, 0, 5 ] );
  test.identical( got.strides, [ 1, 2, 6, 0 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6, 0 ] );

  test.case = 'dims - [ 2, 3, 4, 0 ]';
  var got = _.Matrix.MakeIdentity([ 2, 3, 4, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 3, 4, 0 ] );
  test.identical( got.strides, [ 1, 2, 6, 24 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6, 24 ] );

  test.case = 'dims - [ Infinity, 3, 4, 2 ]';
  var got = _.Matrix.MakeIdentity([ Infinity, 3, 4, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0,
    1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0,
  ]));
  test.identical( got.dims, [ Infinity, 3, 4, 2 ] );
  test.identical( got.strides, [ 0, 1, 3, 12 ] );
  test.identical( got.stridesEffective, [ 0, 1, 3, 12 ] );

  test.case = 'dims - [ 2, Infinity, 4, 5 ]';
  var got = _.Matrix.MakeIdentity([ 2, Infinity, 4, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    1, 0, 1, 0, 1, 0, 1, 0,
    1, 0, 1, 0, 1, 0, 1, 0,
    1, 0, 1, 0, 1, 0, 1, 0,
    1, 0, 1, 0, 1, 0, 1, 0,
    1, 0, 1, 0, 1, 0, 1, 0,
  ]));
  test.identical( got.dims, [ 2, Infinity, 4, 5 ] );
  test.identical( got.strides, [ 1, 0, 2, 8 ] );
  test.identical( got.stridesEffective, [ 1, 0, 2, 8 ] );

  test.case = 'dims - [ 2, 3, Infinity, 5 ]';
  var got = _.Matrix.MakeIdentity([ 2, 3, Infinity, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    1, 0, 0, 1, 0, 0,
    1, 0, 0, 1, 0, 0,
    1, 0, 0, 1, 0, 0,
    1, 0, 0, 1, 0, 0,
    1, 0, 0, 1, 0, 0,
  ]));
  test.identical( got.dims, [ 2, 3, Infinity, 5 ] );
  test.identical( got.strides, [ 1, 2, 6, 6 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6, 6 ] );

  test.case = 'dims - [ 2, 3, 4, Infinity ]';
  var got = _.Matrix.MakeIdentity([ 2, 3, 4, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0,
    1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0,
  ]));
  test.identical( got.dims, [ 2, 3, 4, Infinity ] );
  test.identical( got.strides, [ 1, 2, 6, 24 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6 ] );

  test.close( '4D' );
}

//

function MakeIdentityChangeDimsType( test )
{
  test.case = 'dims - Array';
  var got = _.Matrix.MakeIdentity([ 2, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 0, 0, 1 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - Unroll';
  var got = _.Matrix.MakeIdentity( _.unrollMake([ 2, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 0, 0, 1 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - ArgumentsArray';
  var got = _.Matrix.MakeIdentity( _.argumentsArrayMake([ 2, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 0, 0, 1 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - U8x';
  var got = _.Matrix.MakeIdentity( new U8x([ 2, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 0, 0, 1 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - I16x';
  var got = _.Matrix.MakeIdentity( new I16x([ 2, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 0, 0, 1 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - F32x';
  var got = _.Matrix.MakeIdentity( new F32x([ 2, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 0, 0, 1 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - F64x';
  var got = _.Matrix.MakeIdentity( new F64x([ 2, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 0, 0, 1 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - avector';
  var got = _.Matrix.MakeIdentity( _.avector.make([ 2, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 0, 0, 1 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - VectorAdapter';
  var got = _.Matrix.MakeIdentity( _.vectorAdapter.from([ 2, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 0, 0, 1 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - VectorAdapter, routine fromLongLrangeAndStride';
  var got = _.Matrix.MakeIdentity( _.vectorAdapter.fromLongLrangeAndStride( [ 1, 1, 2, 1, 2 ], 2, 2, 2 ) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 0, 0, 1 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity( [ 1, 2 ], [ 1, 2 ] ) );

  test.case = 'wrong type of dims';
  test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity( { a : 1 } ) );
  test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity( 'wrong' ) );

  test.case = 'wrong length of dims';
  test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity([ 1 ]) );

  test.case = 'negative value in dims';
  test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity([ -1, 2 ]) );
}

//

function MakeIdentity2( test )
{
  test.case = 'without src';
  var got = _.Matrix.MakeIdentity2();
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 0, 0, 1 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'src - number';
  var got = _.Matrix.MakeIdentity2( 3 );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'src - Array';
  var src = [ 1, 2, -2, -3 ];
  var got = _.Matrix.MakeIdentity2( src );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, -2, 2, -3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'src - Unroll';
  var src = _.unrollMake([ 1, 2, -2, -3 ]);
  var got = _.Matrix.MakeIdentity2( src );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, -2, 2, -3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'src - ArgumentsArray';
  var src = _.argumentsArrayMake([ 1, 2, -2, -3 ]);
  var got = _.Matrix.MakeIdentity2( src );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, -2, 2, -3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'src - BufferTyped, U8x';
  var src = new U8x([ 1, 2, 2, 3 ]);
  var got = _.Matrix.MakeIdentity2( src );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 2, 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'src - BufferTyped, I16x';
  var src = new I16x([ 1, 2, -2, -3 ]);
  var got = _.Matrix.MakeIdentity2( src );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, -2, 2, -3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'src - BufferTyped, F32x';
  var src = new F32x([ 1, 2, -2, -3 ]);
  var got = _.Matrix.MakeIdentity2( src );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, -2, 2, -3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'src - BufferTyped, F64x';
  var src = new F32x([ 1, 2, -2, -3 ]);
  var got = _.Matrix.MakeIdentity2( src );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, -2, 2, -3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'src - avector';
  var src = _.avector.make([ 1, 2, -2, -3 ]);
  var got = _.Matrix.MakeIdentity2( src );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, -2, 2, -3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'src - VectorAdapter';
  var src = _.vectorAdapter.from([ 1, 2, -2, -3 ]);
  var got = _.Matrix.MakeIdentity2( src );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, -2, 2, -3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'src - VectorAdapter, routine fromLongLrangeAndStride';
  var src = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 0, 2, 0, -2, 0, -3 ], 1, 4, 2 );
  var got = _.Matrix.MakeIdentity2( src );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, -2, 2, -3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity2( [ 1, 2, 3, 4 ], 2 ) );

  test.case = 'wrong type of src';
  test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity2( { a : 1 } ) );
  test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity2( 'wrong' ) );
}

//

function MakeIdentity3( test )
{
  test.case = 'without src';
  var got = _.Matrix.MakeIdentity3();
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    1, 0, 0,
    0, 1, 0,
    0, 0, 1,
  ]));
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'src - number';
  var got = _.Matrix.MakeIdentity3( 3 );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    3, 3, 3,
    3, 3, 3,
    3, 3, 3,
  ]) );
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'src - Array';
  var src = [ 1, 3, -2, -3, 4, 5, 6, 7, 8 ];
  var got = _.Matrix.MakeIdentity3( src );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1, -3,  6,
     3,  4,  7,
    -2,  5,  8,
  ]));
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'src - Unroll';
  var src = _.unrollMake([ 1, 3, -2, -3, 4, 5, 6, 7, 8 ]);
  var got = _.Matrix.MakeIdentity3( src );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1, -3,  6,
     3,  4,  7,
    -2,  5,  8,
  ]));
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'src - ArgumentsArray';
  var src = _.argumentsArrayMake([ 1, 3, -2, -3, 4, 5, 6, 7, 8 ]);
  var got = _.Matrix.MakeIdentity3( src );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1, -3,  6,
     3,  4,  7,
    -2,  5,  8,
  ]));
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'src - BufferTyped, U8x';
  var src = new U8x([ 1, 3, 3, 3, 4, 5, 6, 7, 8 ]);
  var got = _.Matrix.MakeIdentity3( src );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1,  3,  6,
     3,  4,  7,
     3,  5,  8,
  ]));
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'src - BufferTyped, I16x';
  var src = new I16x([ 1, 3, -2, -3, 4, 5, 6, 7, 8 ]);
  var got = _.Matrix.MakeIdentity3( src );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1, -3,  6,
     3,  4,  7,
    -2,  5,  8,
  ]));
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'src - BufferTyped, F32x';
  var src = new F32x([ 1, 3, -2, -3, 4, 5, 6, 7, 8 ]);
  var got = _.Matrix.MakeIdentity3( src );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1, -3,  6,
     3,  4,  7,
    -2,  5,  8,
  ]));
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'src - BufferTyped, F64x';
  var src = new F32x([ 1, 3, -2, -3, 4, 5, 6, 7, 8 ]);
  var got = _.Matrix.MakeIdentity3( src );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1, -3,  6,
     3,  4,  7,
    -2,  5,  8,
  ]));
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'src - avector';
  var src = _.avector.make([ 1, 3, -2, -3, 4, 5, 6, 7, 8 ]);
  var got = _.Matrix.MakeIdentity3( src );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1, -3,  6,
     3,  4,  7,
    -2,  5,  8,
  ]));
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'src - VectorAdapter';
  var src = _.vectorAdapter.from([ 1, 3, -2, -3, 4, 5, 6, 7, 8 ]);
  var got = _.Matrix.MakeIdentity3( src );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1, -3,  6,
     3,  4,  7,
    -2,  5,  8,
  ]));
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'src - VectorAdapter, routine fromLongLrangeAndStride';
  var src = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 0, 2, 0,-2, 0, -3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8 ], 1, 9, 2 );
  var got = _.Matrix.MakeIdentity3( src );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1, -3,  6,
     2,  4,  7,
    -2,  5,  8,
  ]));
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity3( [ 1, 3, 3, 4, 5, 5, 6, 6, 3 ], 2 ) );

  test.case = 'wrong type of src';
  test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity3( { a : 1 } ) );
  test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity3( 'wrong' ) );
}

//

function MakeIdentity4( test )
{
  test.case = 'without src';
  var got = _.Matrix.MakeIdentity4();
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1,
  ]));
  test.identical( got.dims, [ 4, 4 ] );
  test.identical( got.strides, [ 1, 4 ] );
  test.identical( got.stridesEffective, [ 1, 4 ] );

  test.case = 'src - number';
  var got = _.Matrix.MakeIdentity4( 3 );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    3, 3, 3, 3,
    3, 3, 3, 3,
    3, 3, 3, 3,
    3, 3, 3, 3,
  ]) );
  test.identical( got.dims, [ 4, 4 ] );
  test.identical( got.strides, [ 1, 4 ] );
  test.identical( got.stridesEffective, [ 1, 4 ] );

  test.case = 'src - Array';
  var src = [ 1, 4, -2, -3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0 ];
  var got = _.Matrix.MakeIdentity4( src );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1,  4,  8, 12,
     4,  5,  9, 13,
    -2,  6, 10, 14,
    -3,  7, 11,  0,
  ]));
  test.identical( got.dims, [ 4, 4 ] );
  test.identical( got.strides, [ 1, 4 ] );
  test.identical( got.stridesEffective, [ 1, 4 ] );

  test.case = 'src - Unroll';
  var src = _.unrollMake([ 1, 4, -2, -3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0 ]);
  var got = _.Matrix.MakeIdentity4( src );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1,  4,  8, 12,
     4,  5,  9, 13,
    -2,  6, 10, 14,
    -3,  7, 11,  0,
  ]));
  test.identical( got.dims, [ 4, 4 ] );
  test.identical( got.strides, [ 1, 4 ] );
  test.identical( got.stridesEffective, [ 1, 4 ] );

  test.case = 'src - ArgumentsArray';
  var src = _.argumentsArrayMake([ 1, 4, -2, -3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0 ]);
  var got = _.Matrix.MakeIdentity4( src );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1,  4,  8, 12,
     4,  5,  9, 13,
    -2,  6, 10, 14,
    -3,  7, 11,  0,
  ]));
  test.identical( got.dims, [ 4, 4 ] );
  test.identical( got.strides, [ 1, 4 ] );
  test.identical( got.stridesEffective, [ 1, 4 ] );

  test.case = 'src - BufferTyped, U8x';
  var src = new U8x([ 1, 4, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0 ]);
  var got = _.Matrix.MakeIdentity4( src );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1,  4,  8, 12,
     4,  5,  9, 13,
     2,  6, 10, 14,
     3,  7, 11,  0,
  ]));
  test.identical( got.dims, [ 4, 4 ] );
  test.identical( got.strides, [ 1, 4 ] );
  test.identical( got.stridesEffective, [ 1, 4 ] );

  test.case = 'src - BufferTyped, I16x';
  var src = new I16x([ 1, 4, -2, -3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0 ]);
  var got = _.Matrix.MakeIdentity4( src );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1,  4,  8, 12,
     4,  5,  9, 13,
    -2,  6, 10, 14,
    -3,  7, 11,  0,
  ]));
  test.identical( got.dims, [ 4, 4 ] );
  test.identical( got.strides, [ 1, 4 ] );
  test.identical( got.stridesEffective, [ 1, 4 ] );

  test.case = 'src - BufferTyped, F32x';
  var src = new F32x([ 1, 4, -2, -3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0 ]);
  var got = _.Matrix.MakeIdentity4( src );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1,  4,  8, 12,
     4,  5,  9, 13,
    -2,  6, 10, 14,
    -3,  7, 11,  0,
  ]));
  test.identical( got.dims, [ 4, 4 ] );
  test.identical( got.strides, [ 1, 4 ] );
  test.identical( got.stridesEffective, [ 1, 4 ] );

  test.case = 'src - BufferTyped, F64x';
  var src = new F32x([ 1, 4, -2, -3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0 ]);
  var got = _.Matrix.MakeIdentity4( src );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1,  4,  8, 12,
     4,  5,  9, 13,
    -2,  6, 10, 14,
    -3,  7, 11,  0,
  ]));
  test.identical( got.dims, [ 4, 4 ] );
  test.identical( got.strides, [ 1, 4 ] );
  test.identical( got.stridesEffective, [ 1, 4 ] );

  test.case = 'src - avector';
  var src = _.avector.make([ 1, 4, -2, -3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0 ]);
  var got = _.Matrix.MakeIdentity4( src );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1,  4,  8, 12,
     4,  5,  9, 13,
    -2,  6, 10, 14,
    -3,  7, 11,  0,
  ]));
  test.identical( got.dims, [ 4, 4 ] );
  test.identical( got.strides, [ 1, 4 ] );
  test.identical( got.stridesEffective, [ 1, 4 ] );

  test.case = 'src - VectorAdapter';
  var src = _.vectorAdapter.from([ 1, 4, -2, -3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0 ]);
  var got = _.Matrix.MakeIdentity4( src );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1,  4,  8, 12,
     4,  5,  9, 13,
    -2,  6, 10, 14,
    -3,  7, 11,  0,
  ]));
  test.identical( got.dims, [ 4, 4 ] );
  test.identical( got.strides, [ 1, 4 ] );
  test.identical( got.stridesEffective, [ 1, 4 ] );

  test.case = 'src - VectorAdapter, routine fromLongLrangeAndStride';
  var src = _.vectorAdapter.fromLongLrangeAndStride
  (
    [ 0, 1, 0, 4, 0, -2, 0, -3, 0, 4, 0, 5, 0, 6, 0, 7, 0, 8, 0, 9, 0, 10, 0, 11, 0, 12, 0, 13, 0, 14, 0, 0 ],
    1,
    16,
    2
  );
  var got = _.Matrix.MakeIdentity4( src );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1,  4,  8, 12,
     4,  5,  9, 13,
    -2,  6, 10, 14,
    -3,  7, 11,  0,
  ]));
  test.identical( got.dims, [ 4, 4 ] );
  test.identical( got.strides, [ 1, 4 ] );
  test.identical( got.stridesEffective, [ 1, 4 ] );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity4( new U8x( 16 ), 2 ) );

  test.case = 'wrong type of src';
  test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity4( { a : 1 } ) );
  test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity4( 'wrong' ) );
}

//

function MakeDiagonal( test )
{
  test.open( 'change length of diagonal' );

  test.case = 'diagonal - empty array';
  var diagonal = [];
  var got = _.Matrix.MakeDiagonal( diagonal );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ));
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'diagonal - single element';
  var diagonal = [ 4 ];
  var got = _.Matrix.MakeDiagonal( diagonal );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 4 ]) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.strides, [ 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'diagonal - four elements';
  var diagonal = [ 4, 3, -1, 0 ];
  var got = _.Matrix.MakeDiagonal( diagonal );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    4,  0,  0,  0,
    0,  3,  0,  0,
    0,  0, -1,  0,
    0,  0,  0,  0,
  ]));
  test.identical( got.dims, [ 4, 4 ] );
  test.identical( got.strides, [ 1, 4 ] );
  test.identical( got.stridesEffective, [ 1, 4 ] );

  test.close( 'change length of diagonal' );

  /* - */

  test.open( 'change type of diagonal' );

  test.case = 'diagonal - Array';
  var diagonal = [ 1, 3, -2 ];
  var got = _.Matrix.MakeDiagonal( diagonal );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1,  0,  0,
     0,  3,  0,
     0,  0, -2,
  ]));
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'diagonal - Unroll';
  var diagonal = _.unrollMake([ 1, 3, -2 ]);
  var got = _.Matrix.MakeDiagonal( diagonal );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1,  0,  0,
     0,  3,  0,
     0,  0, -2,
  ]));
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'diagonal - ArgumentsArray';
  var diagonal = _.argumentsArrayMake([ 1, 3, -2 ]);
  var got = _.Matrix.MakeDiagonal( diagonal );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1,  0,  0,
     0,  3,  0,
     0,  0, -2,
  ]));
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'diagonal - BufferTyped, U8x';
  var diagonal = new U8x([ 1, 3, 3 ]);
  var got = _.Matrix.MakeDiagonal( diagonal );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1,  0,  0,
     0,  3,  0,
     0,  0,  3,
  ]));
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'diagonal - BufferTyped, I16x';
  var diagonal = new I16x([ 1, 3, -2 ]);
  var got = _.Matrix.MakeDiagonal( diagonal );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1,  0,  0,
     0,  3,  0,
     0,  0, -2,
  ]));
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'diagonal - BufferTyped, F32x';
  var diagonal = new F32x([ 1, 3, -2 ]);
  var got = _.Matrix.MakeDiagonal( diagonal );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1,  0,  0,
     0,  3,  0,
     0,  0, -2,
  ]));
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'diagonal - BufferTyped, F64x';
  var diagonal = new F32x([ 1, 3, -2 ]);
  var got = _.Matrix.MakeDiagonal( diagonal );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1,  0,  0,
     0,  3,  0,
     0,  0, -2,
  ]));
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'diagonal - avector';
  var diagonal = _.avector.make([ 1, 3, -2 ]);
  var got = _.Matrix.MakeDiagonal( diagonal );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1,  0,  0,
     0,  3,  0,
     0,  0, -2,
  ]));
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'diagonal - VectorAdapter';
  var diagonal = _.vectorAdapter.from([ 1, 3, -2 ]);
  var got = _.Matrix.MakeDiagonal( diagonal );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1,  0,  0,
     0,  3,  0,
     0,  0, -2,
  ]));
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'diagonal - VectorAdapter, routine fromLongLrangeAndStride';
  var diagonal = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 0, 3, 0, -2, 0 ], 1, 3, 2 );
  var got = _.Matrix.MakeDiagonal( diagonal );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
     1,  0,  0,
     0,  3,  0,
     0,  0, -2,
  ]));
  test.identical( got.dims, [ 3, 3 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.close( 'change type of diagonal' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeDiagonal() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeDiagonal( [ 1, 3, 3 ], 2 ) );

  test.case = 'wrong type of diagonal';
  test.shouldThrowErrorSync( () => _.Matrix.MakeDiagonal( { a : 1 } ) );
  test.shouldThrowErrorSync( () => _.Matrix.MakeDiagonal( 'wrong' ) );
}

//

function MakeSimilarMIsMatrixWithoutDims( test )
{
  test.open( '2D' );

  test.case = 'dims - 0';
  var m = _.Matrix.Make( 0 ).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - 1';
  var m = _.Matrix.Make( 1 ).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 5 ]) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.strides, [ 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - 2';
  var m = _.Matrix.Make( 2 ).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 5, 5, 5, 5 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - Infinity';
  var m = _.Matrix.Make( Infinity ).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 5 ]) );
  test.identical( got.dims, [ Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ Infinity, Infinity ]';
  var m = _.Matrix.Make([ Infinity, Infinity ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 5 ]) );
  test.identical( got.dims, [ Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 0, 0 ]';
  var m = _.Matrix.Make([ 0, 0 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 1, 1 ]';
  var m = _.Matrix.Make([ 1, 1 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 5 ]) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.strides, [ 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 3, 2 ]';
  var m = _.Matrix.Make([ 3, 2 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 5, 5, 5, 5, 5, 5 ]) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 0 ]';
  var m = _.Matrix.Make([ 2, 0 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 0 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 0, 2 ]';
  var m = _.Matrix.Make([ 0, 2 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 2 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ Infinity, 2 ]';
  var m = _.Matrix.Make([ 0, 0 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, Infinity ]';
  var m = _.Matrix.Make([ 0, 0 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.close( '2D' );

  /* - */

  test.open( '3D' );

  test.case = 'dims - [ Infinity, Infinity, Infinity ]';
  var m = _.Matrix.Make([ Infinity, Infinity, Infinity ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 5 ]) );
  test.identical( got.dims, [ Infinity, Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0, 1 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 0, 0, 0 ]';
  var m = _.Matrix.Make([ 0, 0, 0 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0, 0 ] );
  test.identical( got.strides, [ 1, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0, 0 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 1, 1, 1 ]';
  var m = _.Matrix.Make([ 1, 1, 1 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 5 ]) );
  test.identical( got.dims, [ 1, 1, 1 ] );
  test.identical( got.strides, [ 1, 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 3, 4 ]';
  var m = _.Matrix.Make([ 2, 3, 4 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    5, 5, 5, 5, 5, 5,
    5, 5, 5, 5, 5, 5,
    5, 5, 5, 5, 5, 5,
    5, 5, 5, 5, 5, 5,
  ]));
  test.identical( got.dims, [ 2, 3, 4 ] );
  test.identical( got.strides, [ 1, 2, 6 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 0, 3, 4 ]';
  var m = _.Matrix.Make([ 0, 3, 4 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 3, 4 ] );
  test.identical( got.strides, [ 1, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0, 0 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 0, 4 ]';
  var m = _.Matrix.Make([ 2, 0, 4 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 0, 4 ] );
  test.identical( got.strides, [ 1, 2, 0 ] );
  test.identical( got.stridesEffective, [ 1, 2, 0 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 3, 0 ]';
  var m = _.Matrix.Make([ 2, 3, 0 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 3, 0 ] );
  test.identical( got.strides, [ 1, 2, 6 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ Infinity, 3, 4 ]';
  var m = _.Matrix.Make([ Infinity, 3, 4 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    5, 5, 5,
    5, 5, 5,
    5, 5, 5,
    5, 5, 5,
  ]));
  test.identical( got.dims, [ Infinity, 3, 4 ] );
  test.identical( got.strides, [ 0, 1, 3 ] );
  test.identical( got.stridesEffective, [ 0, 1, 3 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, Infinity, 4 ]';
  var m = _.Matrix.Make([ 2, Infinity, 4 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    5, 5,
    5, 5,
    5, 5,
    5, 5,
  ]));
  test.identical( got.dims, [ 2, Infinity, 4 ] );
  test.identical( got.strides, [ 1, 0, 2 ] );
  test.identical( got.stridesEffective, [ 1, 0, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 3, Infinity ]';
  var m = _.Matrix.Make([ 2, 3, Infinity ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    5, 5, 5,
    5, 5, 5,
  ]));
  test.identical( got.dims, [ 2, 3, Infinity ] );
  test.identical( got.strides, [ 1, 2, 6 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.close( '3D' );

  /* - */

  test.open( '4D' );

  test.case = 'dims - [ Infinity, Infinity, Infinity, Infinity ]';
  var m = _.Matrix.Make([ Infinity, Infinity, Infinity, Infinity ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 5 ]) );
  test.identical( got.dims, [ Infinity, Infinity, Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0, 1, 1 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 0, 0, 0, 0 ]';
  var m = _.Matrix.Make([ 0, 0, 0, 0 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0, 0, 0 ] );
  test.identical( got.strides, [ 1, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0, 0, 0 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 1, 1, 1, 1 ]';
  var m = _.Matrix.Make([ 1, 1, 1, 1 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 5 ]) );
  test.identical( got.dims, [ 1, 1, 1, 1 ] );
  test.identical( got.strides, [ 1, 1, 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 3, 4, 2 ]';
  var m = _.Matrix.Make([ 2, 3, 4, 2 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
    5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
  ]));
  test.identical( got.dims, [ 2, 3, 4, 2 ] );
  test.identical( got.strides, [ 1, 2, 6, 24 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6, 24 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 0, 3, 4, 5 ]';
  var m = _.Matrix.Make([ 0, 3, 4, 5 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 3, 4, 5 ] );
  test.identical( got.strides, [ 1, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0, 0, 0 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 0, 4, 5 ]';
  var m = _.Matrix.Make([ 2, 0, 4, 5 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 0, 4, 5 ] );
  test.identical( got.strides, [ 1, 2, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 2, 0, 0 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 3, 0, 5 ]';
  var m = _.Matrix.Make([ 2, 3, 0, 5 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 3, 0, 5 ] );
  test.identical( got.strides, [ 1, 2, 6, 0 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6, 0 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 3, 4, 0 ]';
  var m = _.Matrix.Make([ 2, 3, 4, 0 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 3, 4, 0 ] );
  test.identical( got.strides, [ 1, 2, 6, 24 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6, 24 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ Infinity, 3, 4, 2 ]';
  var m = _.Matrix.Make([ Infinity, 3, 4, 2 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
    5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
  ]));
  test.identical( got.dims, [ Infinity, 3, 4, 2 ] );
  test.identical( got.strides, [ 0, 1, 3, 12 ] );
  test.identical( got.stridesEffective, [ 0, 1, 3, 12 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, Infinity, 4, 2 ]';
  var m = _.Matrix.Make([ 2, Infinity, 4, 2 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    5, 5, 5, 5, 5, 5, 5, 5,
    5, 5, 5, 5, 5, 5, 5, 5,
  ]));
  test.identical( got.dims, [ 2, Infinity, 4, 2 ] );
  test.identical( got.strides, [ 1, 0, 2, 8 ] );
  test.identical( got.stridesEffective, [ 1, 0, 2, 8 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 3, Infinity, 5 ]';
  var m = _.Matrix.Make([ 2, 3, Infinity, 5 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    5, 5, 5, 5, 5, 5,
    5, 5, 5, 5, 5, 5,
    5, 5, 5, 5, 5, 5,
    5, 5, 5, 5, 5, 5,
    5, 5, 5, 5, 5, 5,
  ]));
  test.identical( got.dims, [ 2, 3, Infinity, 5 ] );
  test.identical( got.strides, [ 1, 2, 6, 6 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6, 6 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 3, 4, Infinity ]';
  var m = _.Matrix.Make([ 2, 3, 4, Infinity ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
  ]));
  test.identical( got.dims, [ 2, 3, 4, Infinity ] );
  test.identical( got.strides, [ 1, 2, 6, 24 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.close( '4D' );
}

//

function MakeSimilarMIsMatrixWithDims( test )
{
  test.open( '2D' );

  test.case = 'dims - 0';
  var m = _.Matrix.Make( 0 ).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 4 ) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - 1';
  var m = _.Matrix.Make( 1 ).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 5, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - 2';
  var m = _.Matrix.Make( 2 ).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 5, 5, 5, 5 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - Infinity';
  var m = _.Matrix.Make( Infinity ).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 5, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ Infinity, Infinity ]';
  var m = _.Matrix.Make([ Infinity, Infinity ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 5, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 0, 0 ]';
  var m = _.Matrix.Make([ 0, 0 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 1, 1 ]';
  var m = _.Matrix.Make([ 1, 1 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 5, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 3, 2 ]';
  var m = _.Matrix.Make([ 3, 2 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 5, 5, 5, 5 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 0 ]';
  var m = _.Matrix.Make([ 2, 0 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 0, 2 ]';
  var m = _.Matrix.Make([ 0, 2 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ Infinity, 2 ]';
  var m = _.Matrix.Make([ 0, 0 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, Infinity ]';
  var m = _.Matrix.Make([ 0, 0 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.close( '2D' );

  /* - */

  test.open( '3D' );

  test.case = 'dims - [ Infinity, Infinity, Infinity ]';
  var m = _.Matrix.Make([ Infinity, Infinity, Infinity ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 5, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 0, 0, 0 ]';
  var m = _.Matrix.Make([ 0, 0, 0 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 1, 1, 1 ]';
  var m = _.Matrix.Make([ 1, 1, 1 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 5, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 3, 4 ]';
  var m = _.Matrix.Make([ 2, 3, 4 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 5, 5, 5, 5 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 0, 3, 4 ]';
  var m = _.Matrix.Make([ 0, 3, 4 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 0, 4 ]';
  var m = _.Matrix.Make([ 2, 0, 4 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 3, 0 ]';
  var m = _.Matrix.Make([ 2, 3, 0 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ Infinity, 3, 4 ]';
  var m = _.Matrix.Make([ Infinity, 3, 4 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 5, 5, 5, 5 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, Infinity, 4 ]';
  var m = _.Matrix.Make([ 2, Infinity, 4 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 5, 5, 5, 5 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 3, Infinity ]';
  var m = _.Matrix.Make([ 2, 3, Infinity ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 5, 5, 5, 5 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.close( '3D' );

  /* - */

  test.open( '4D' );

  test.case = 'dims - [ Infinity, Infinity, Infinity, Infinity ]';
  var m = _.Matrix.Make([ Infinity, Infinity, Infinity, Infinity ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 5, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 0, 0, 0, 0 ]';
  var m = _.Matrix.Make([ 0, 0, 0, 0 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 1, 1, 1, 1 ]';
  var m = _.Matrix.Make([ 1, 1, 1, 1 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 5, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 3, 4, 2 ]';
  var m = _.Matrix.Make([ 2, 3, 4, 2 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 5, 5, 5, 5 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 0, 3, 4, 5 ]';
  var m = _.Matrix.Make([ 0, 3, 4, 5 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 0, 4, 5 ]';
  var m = _.Matrix.Make([ 2, 0, 4, 5 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 3, 0, 5 ]';
  var m = _.Matrix.Make([ 2, 3, 0, 5 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 3, 4, 0 ]';
  var m = _.Matrix.Make([ 2, 3, 4, 0 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0, 0 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ Infinity, 3, 4, 2 ]';
  var m = _.Matrix.Make([ Infinity, 3, 4, 2 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 5, 5, 5, 5 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, Infinity, 4, 2 ]';
  var m = _.Matrix.Make([ 2, Infinity, 4, 2 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 5, 5, 5, 5 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 3, Infinity, 5 ]';
  var m = _.Matrix.Make([ 2, 3, Infinity, 5 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 5, 5, 5, 5 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims - [ 2, 3, 4, Infinity ]';
  var m = _.Matrix.Make([ 2, 3, 4, Infinity ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 5, 5, 5, 5 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.close( '4D' );

  /* - */

  test.open( 'different dims.length' );

  test.case = 'dims.length - 2';
  var m = new _.Matrix.Make([ 2, 2 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 0, 0 ] );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims.length - 3';
  var m = new _.Matrix.Make([ 2, 2 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 3, 3, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    5, 5, 5, 5, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0,
  ]));
  test.identical( got.dims, [ 3, 3, 2 ] );
  test.identical( got.strides, [ 1, 3, 9 ] );
  test.identical( got.stridesEffective, [ 1, 3, 9 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'dims.length - 4';
  var m = new _.Matrix.Make([ 2, 2 ]).copy( 5 );
  var got = _.Matrix.MakeSimilar( m, [ 3, 3, 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    5, 5, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  ]));
  test.identical( got.dims, [ 3, 3, 2, 2 ] );
  test.identical( got.strides, [ 1, 3, 9, 18 ] );
  test.identical( got.stridesEffective, [ 1, 3, 9, 18 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.close( 'different dims.length' );
}

//

function MakeSimilarDifferentBufferTypes( test )
{
  test.case = 'buffer - Array';
  var m = new _.Matrix
  ({
    buffer : [ 1, 2, 3, 4 ],
    dims : [ 2, 2 ],
    inputRowMajor : 1,
  });
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, [ 1, 2, 3, 4 ] );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'buffer - Unroll';
  var m = new _.Matrix
  ({
    buffer : _.unrollMake([ 1, 2, 3, 4 ]),
    dims : [ 2, 2 ],
    inputRowMajor : 1,
  });
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.unrollMake([ 1, 2, 3, 4 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'buffer - ArgumentsArray';
  var m = new _.Matrix
  ({
    buffer : _.argumentsArrayMake([ 1, 2, 3, 4 ]),
    dims : [ 2, 2 ],
    inputRowMajor : 1,
  });
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'buffer - BufferTyped, U8x';
  var m = new _.Matrix
  ({
    buffer : new U8x([ 1, 2, 3, 4 ]),
    dims : [ 2, 2 ],
    inputRowMajor : 1,
  });
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, new U8x([ 1, 2, 3, 4 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'buffer - BufferTyped, I16x';
  var m = new _.Matrix
  ({
    buffer : new I16x([ 1, 2, 3, 4 ]),
    dims : [ 2, 2 ],
    inputRowMajor : 1,
  });
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, new I16x([ 1, 2, 3, 4 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'buffer - BufferTyped, F32x';
  var m = new _.Matrix
  ({
    buffer : new F32x([ 1, 2, 3, 4 ]),
    dims : [ 2, 2 ],
    inputRowMajor : 1,
  });
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, new F32x([ 1, 2, 3, 4 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'buffer - BufferTyped, F64x';
  var m = new _.Matrix
  ({
    buffer : new F64x([ 1, 2, 3, 4 ]),
    dims : [ 2, 2 ],
    inputRowMajor : 1,
  });
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, new F64x([ 1, 2, 3, 4 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );

  test.case = 'buffer - BufferTyped, F64x';
  var m = new _.Matrix
  ({
    buffer : _.avector.make([ 1, 2, 3, 4 ]),
    dims : [ 2, 2 ],
    inputRowMajor : 1,
  });
  var got = _.Matrix.MakeSimilar( m, [ 2, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );
  test.is( got !== m );
  test.is( got.buffer !== m.buffer );
}

//

function MakeSimilarExperiment( test )
{
  test.case = 'buffer - BufferTyped, F64x';
  var m = _.Matrix.MakeSquare
  ([
    0, 1, 2,
    3, 4, 5,
    6, 7, 8
  ]);
  var got = _.Matrix.MakeSimilar( m, [ 3, 3 ] );
  var exp = _.Matrix.Make( 3 ).copy
  ([
    0, 1, 2,
    3, 4, 5,
    6, 7, 8
  ]);
  test.equivalent( got, exp );
}

MakeSimilarExperiment.experimental = 1;

//

function MakeSimilarWithVectors( test )
{
  test.case = 'm - Array';
  var m = [ 1, 2, 3 ];
  var got = _.Matrix.MakeSimilar( m, [ 2, 1 ] );
  test.identical( got, [ undefined, undefined ] );
  test.is( got !== m );

  test.case = 'm - Unroll';
  var m = _.unrollMake([ 1, 2, 3 ]);
  var got = _.Matrix.MakeSimilar( m, [ 2, 1 ] );
  test.identical( got, _.unrollMake([ undefined, undefined ]) );
  test.is( got !== m );

  test.case = 'm - ArgumentsArray';
  var m = _.argumentsArrayMake([ 1, 2, 3 ]);
  var got = _.Matrix.MakeSimilar( m, [ 2, 1 ] );
  test.identical( got, _.longDescriptor.make([ 0, 0 ]) );
  test.is( got !== m );

  test.case = 'm - BufferTyped, U8x';
  var m = new U8x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeSimilar( m, [ 2, 1 ] );
  test.identical( got, new U8x([ 0, 0 ]) );
  test.is( got !== m );

  test.case = 'm - BufferTyped, I16x';
  var m = new I16x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeSimilar( m, [ 2, 1 ] );
  test.identical( got, new I16x([ 0, 0 ]) );
  test.is( got !== m );

  test.case = 'm - BufferTyped, F32x';
  var m = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeSimilar( m, [ 2, 1 ] );
  test.identical( got, new F32x([ 0, 0 ]) );
  test.is( got !== m );

  test.case = 'm - BufferTyped, F64x';
  var m = new F64x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeSimilar( m, [ 2, 1 ] );
  test.identical( got, new F64x([ 0, 0 ]) );
  test.is( got !== m );

  test.case = 'm - avector';
  var m = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.MakeSimilar( m, [ 2, 1 ] );
  test.identical( got, _.longDescriptor.make([ 0, 0 ]) );
  test.is( got !== m );

  test.case = 'm - VectorAdapter';
  var m = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.MakeSimilar( m, [ 2, 1 ] );
  test.identical( got.toLong(), [ undefined, undefined ] );
  test.is( got !== m );

  test.case = 'm - VectorAdapter, routine fromLongLrangeAndStride';
  var m = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 0, 2, 0, 3, 0 ], 1, 2, 2 );
  var got = _.Matrix.MakeSimilar( m, [ 2, 1 ] );
  test.identical( got.toLong(), [ undefined, undefined ] );
  test.is( got !== m );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeSimilar() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeSimilar( _.Matrix.Make([ 2, 2 ]), [ 1, 2 ], 1 ) );

  test.case = 'wrong type of m';
  test.shouldThrowErrorSync( () => _.Matrix.MakeSimilar( 'wrong' ) );
  test.shouldThrowErrorSync( () => _.Matrix.MakeSimilar( 2 ) );

  test.case = 'wrong type of dims';
  test.shouldThrowErrorSync( () => _.Matrix.MakeSimilar( _.Matrix.Make([ 2, 2 ]), 'wrong' ) );
  test.shouldThrowErrorSync( () => _.Matrix.MakeSimilar( _.Matrix.Make([ 2, 2 ]), { a : 2 } ) );

  test.case = 'wrong dims for vectors';
  test.shouldThrowErrorSync( () => _.Matrix.MakeSimilar( [ 1, 2 ], [ 2, 3 ] ) );
  test.shouldThrowErrorSync( () => _.Matrix.MakeSimilar( [ 1, 2 ], [ 2, 2, 3 ] ) );
}

//

function MakeLineOptionZeroing0( test )
{
  test.case = 'o.buffer - Number, dimension - 0';
  var got = _.Matrix.MakeLine
  ({
    buffer : 3,
    dimension : 0,
    zeroing : 0,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'o.buffer - Number, dimension - 1';
  var got = _.Matrix.MakeLine
  ({
    buffer : 3,
    dimension : 1,
    zeroing : 0,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  /* */

  test.case = 'o.buffer - Array, dimension - 0';
  var buffer = [ 1, 2, 3 ];
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 0,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, [ 1, 2, 3 ] );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - Array, dimension - 1';
  var buffer = [ 1, 2, 3 ];
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 0,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, [ 1, 2, 3 ] );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* */

  test.case = 'o.buffer - Unroll, dimension - 0';
  var buffer = _.unrollMake([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 0,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, [ 1, 2, 3 ] );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - Unroll, dimension - 1';
  var buffer = _.unrollMake([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 0,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, [ 1, 2, 3 ] );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* */

  test.case = 'o.buffer - ArgumentsArray, dimension - 0';
  var buffer = _.argumentsArrayMake([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 0,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - ArgumentsArray, dimension - 1';
  var buffer = _.argumentsArrayMake([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 0,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* */

  test.case = 'o.buffer - BufferTyped, U8x, dimension - 0';
  var buffer = new U8x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 0,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, new U8x([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - BufferTyped, U8x, dimension - 1';
  var buffer = new U8x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 0,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, new U8x([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* */

  test.case = 'o.buffer - BufferTyped, I16x, dimension - 0';
  var buffer = new I16x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 0,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, new I16x([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - BufferTyped, I16x, dimension - 1';
  var buffer = new I16x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 0,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, new I16x([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* */

  test.case = 'o.buffer - BufferTyped, F32x, dimension - 0';
  var buffer = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 0,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, new F32x([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - BufferTyped, F32x, dimension - 1';
  var buffer = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 0,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, new F32x([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* */

  test.case = 'o.buffer - BufferTyped, F64x, dimension - 0';
  var buffer = new F64x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 0,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, new F64x([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - BufferTyped, F64x, dimension - 1';
  var buffer = new F64x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 0,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, new F64x([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* */

  test.case = 'o.buffer - avector, dimension - 0';
  var buffer = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 0,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - avector, dimension - 1';
  var buffer = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 0,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* */

  test.case = 'o.buffer - VectorAdapter, dimension - 0';
  var buffer = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 0,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, [ 1, 2, 3 ] );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - VectorAdapter, dimension - 1';
  var buffer = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 0,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, [ 1, 2, 3 ] );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, [ 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - VectorAdapter, routine fromLongLrangeAndStride, dimension - 0';
  var buffer = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 0, 2, 0, 3, 0 ], 1, 3, 2 );
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 0,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, [ 0, 1, 0, 2, 0, 3, 0 ] );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, [ 2, 6 ] );
  test.identical( got.stridesEffective, [ 2, 6 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - VectorAdapter, routine fromLongLrangeAndStride, dimension - 1';
  var buffer = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 0, 2, 0, 3, 0 ], 1, 3, 2 );
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 0,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, [ 0, 1, 0, 2, 0, 3, 0 ] );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, [ 2, 2 ] );
  test.identical( got.stridesEffective, [ 2, 2 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* */

  test.case = 'o.buffer - matrix, dimension - 0';
  var buffer = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3,
  ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 0,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got === buffer );
  test.is( got.buffer === buffer.buffer );

  test.case = 'o.buffer - matrix, dimension - 1';
  var buffer = _.Matrix.Make([ 1, 3 ]).copy([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 0,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, [ 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got === buffer );
  test.is( got.buffer === buffer.buffer );

  /* - */

  test.open( 'different length of line' );

  test.case = 'length - 0, dimension - 0';
  var buffer = _.Matrix.Make([ 0, 1 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 0,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 1 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );
  test.is( got === buffer );
  test.is( got.buffer === buffer.buffer );

  test.case = 'length - 0, dimension - 1';
  var buffer = _.Matrix.Make([ 1, 0 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 0,
  });
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 1, 0 ] );
  test.identical( got.strides, [ 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got === buffer );
  test.is( got.buffer === buffer.buffer );

  test.case = 'length - 1, dimension - 0';
  var buffer = _.Matrix.Make([ 1, 1 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 0,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.strides, [ 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got === buffer );
  test.is( got.buffer === buffer.buffer );

  test.case = 'length - 1, dimension - 1';
  var buffer = _.Matrix.Make([ 1, 1 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 0,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.strides, [ 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got === buffer );
  test.is( got.buffer === buffer.buffer );

  test.close( 'different length of line' );
}

//

function MakeLineOptionZeroing1( test )
{
  test.case = 'o.buffer - Number, dimension - 0';
  var got = _.Matrix.MakeLine
  ({
    buffer : 3,
    dimension : 0,
    zeroing : 1,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'o.buffer - Number, dimension - 1';
  var got = _.Matrix.MakeLine
  ({
    buffer : 3,
    dimension : 1,
    zeroing : 1,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  /* */

  test.case = 'o.buffer - Array, dimension - 0';
  var buffer = [ 1, 2, 3 ];
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 1,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - Array, dimension - 1';
  var buffer = [ 1, 2, 3 ];
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 1,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* */

  test.case = 'o.buffer - Unroll, dimension - 0';
  var buffer = _.unrollMake([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 1,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - Unroll, dimension - 1';
  var buffer = _.unrollMake([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 1,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* */

  test.case = 'o.buffer - ArgumentsArray, dimension - 0';
  var buffer = _.argumentsArrayMake([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 1,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - ArgumentsArray, dimension - 1';
  var buffer = _.argumentsArrayMake([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 1,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* */

  test.case = 'o.buffer - BufferTyped, U8x, dimension - 0';
  var buffer = new U8x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 1,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - BufferTyped, U8x, dimension - 1';
  var buffer = new U8x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 1,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* */

  test.case = 'o.buffer - BufferTyped, I16x, dimension - 0';
  var buffer = new I16x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 1,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - BufferTyped, I16x, dimension - 1';
  var buffer = new I16x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 1,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* */

  test.case = 'o.buffer - BufferTyped, F32x, dimension - 0';
  var buffer = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 1,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - BufferTyped, F32x, dimension - 1';
  var buffer = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 1,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* */

  test.case = 'o.buffer - BufferTyped, F64x, dimension - 0';
  var buffer = new F64x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 1,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - BufferTyped, F64x, dimension - 1';
  var buffer = new F64x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 1,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* */

  test.case = 'o.buffer - avector, dimension - 0';
  var buffer = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 1,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - avector, dimension - 1';
  var buffer = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 1,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* */

  test.case = 'o.buffer - VectorAdapter, dimension - 0';
  var buffer = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 1,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - VectorAdapter, dimension - 1';
  var buffer = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 1,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - VectorAdapter, routine fromLongLrangeAndStride, dimension - 0';
  var buffer = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 0, 2, 0, 3, 0 ], 1, 3, 2 );
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 1,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - VectorAdapter, routine fromLongLrangeAndStride, dimension - 1';
  var buffer = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 0, 2, 0, 3, 0 ], 1, 3, 2 );
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 1,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* */

  test.case = 'o.buffer - matrix, dimension - 0';
  var buffer = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3,
  ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 1,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'o.buffer - matrix, dimension - 1';
  var buffer = _.Matrix.Make([ 1, 3 ]).copy([ 1, 2, 3 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 1,
  });
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* - */

  test.open( 'different length of line' );

  test.case = 'length - 0, dimension - 0';
  var buffer = _.Matrix.Make([ 0, 1 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 1,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'length - 0, dimension - 1';
  var buffer = _.Matrix.Make([ 1, 0 ]);
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 1,
  });
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 1, 0 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'length - 1, dimension - 0';
  var buffer = _.Matrix.Make([ 1, 1 ]).copy( 2 );
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 0,
    zeroing : 1,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'length - 1, dimension - 1';
  var buffer = _.Matrix.Make([ 1, 1 ]).copy( 2 );
  var got = _.Matrix.MakeLine
  ({
    buffer : buffer,
    dimension : 1,
    zeroing : 1,
  });
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.close( 'different length of line' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeLine() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeLine( { buffer : [ 1, 2 ], dimension : 0 }, 'extra' ) );

  test.case = 'wrong type of o';
  test.shouldThrowErrorSync( () => _.Matrix.MakeLine( [ [ 'buffer', [ 1, 2 ] ], [ 'dimension', 0 ] ] ) );
  test.shouldThrowErrorSync( () => _.Matrix.MakeLine( 'wrong' ) );

  test.case = 'unknown options in o';
  test.shouldThrowErrorSync( () => _.Matrix.MakeLine({ buffer : [ 1, 2 ], dimension : 0, extra : 1 }) );

  test.case = 'wrong type of o.buffer';
  test.shouldThrowErrorSync( () => _.Matrix.MakeLine({ buffer : { 1 : 2 }, dimension : 0 }) );

  test.case = 'o.buffer with dimensions that is greater than 1';
  test.shouldThrowErrorSync( () => _.Matrix.MakeLine({ buffer : _.Matrix.Make([ 2, 3 ]), dimension : 0 }) );
  test.shouldThrowErrorSync( () => _.Matrix.MakeLine({ buffer : _.Matrix.Make([ 2, 3 ]), dimension : 1 }) );
}

//

function MakeCol( test )
{
  test.case = 'buffer - Number';
  var got = _.Matrix.MakeCol( 3 );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'buffer - Array';
  var buffer = [ 1, 2, 3 ];
  var got = _.Matrix.MakeCol( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, [ 1, 2, 3 ] );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - Unroll';
  var buffer = _.unrollMake([ 1, 2, 3 ]);
  var got = _.Matrix.MakeCol( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, [ 1, 2, 3 ] );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - ArgumentsArray';
  var buffer = _.argumentsArrayMake([ 1, 2, 3 ]);
  var got = _.Matrix.MakeCol( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - BufferTyped, U8x';
  var buffer = new U8x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeCol( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, new U8x([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - BufferTyped, I16x';
  var buffer = new I16x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeCol( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, new I16x([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - BufferTyped, F32x';
  var buffer = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeCol( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, new F32x([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - BufferTyped, F64x';
  var buffer = new F64x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeCol( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, new F64x([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - avector';
  var buffer = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.MakeCol( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - VectorAdapter';
  var buffer = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.MakeCol( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, [ 1, 2, 3 ] );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - VectorAdapter, routine fromLongLrangeAndStride';
  var buffer = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 0, 2, 0, 3, 0 ], 1, 3, 2 );
  var got = _.Matrix.MakeCol( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, [ 0, 1, 0, 2, 0, 3, 0 ] );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, [ 2, 6 ] );
  test.identical( got.stridesEffective, [ 2, 6 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - matrix';
  var buffer = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3,
  ]);
  var got = _.Matrix.MakeCol( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got === buffer );
  test.is( got.buffer === buffer.buffer );

  /* */

  test.case = 'length - 0';
  var buffer = _.Matrix.Make([ 0, 1 ]);
  var got = _.Matrix.MakeCol( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 1 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );
  test.is( got === buffer );
  test.is( got.buffer === buffer.buffer );

  test.case = 'length - 1';
  var buffer = _.Matrix.Make([ 1, 1 ]);
  var got = _.Matrix.MakeCol( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.strides, [ 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got === buffer );
  test.is( got.buffer === buffer.buffer );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeCol() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeCol( [ 1, 2 ], 0 ) );

  test.case = 'wrong type of buffer';
  test.shouldThrowErrorSync( () => _.Matrix.MakeCol({ buffer : [ 1, 2 ] }) );

  test.case = 'buffer with dimensions that is greater than 1';
  test.shouldThrowErrorSync( () => _.Matrix.MakeCol( _.Matrix.Make([ 2, 3 ]) ) );
}

//

function MakeColZeroed( test )
{
  test.case = 'buffer - Number';
  var got = _.Matrix.MakeColZeroed( 3 );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'buffer - Array';
  var buffer = [ 1, 2, 3 ];
  var got = _.Matrix.MakeColZeroed( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - Unroll';
  var buffer = _.unrollMake([ 1, 2, 3 ]);
  var got = _.Matrix.MakeColZeroed( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - ArgumentsArray';
  var buffer = _.argumentsArrayMake([ 1, 2, 3 ]);
  var got = _.Matrix.MakeColZeroed( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - BufferTyped, U8x';
  var buffer = new U8x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeColZeroed( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - BufferTyped, I16x';
  var buffer = new I16x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeColZeroed( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - BufferTyped, F32x';
  var buffer = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeColZeroed( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - BufferTyped, F64x';
  var buffer = new F64x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeColZeroed( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - avector';
  var buffer = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.MakeColZeroed( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - VectorAdapter';
  var buffer = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.MakeColZeroed( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - VectorAdapter, routine fromLongLrangeAndStride';
  var buffer = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 0, 2, 0, 3, 0 ], 1, 3, 2 );
  var got = _.Matrix.MakeColZeroed( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - matrix';
  var buffer = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3,
  ]);
  var got = _.Matrix.MakeColZeroed( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 3, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* */

  test.case = 'length - 0';
  var buffer = _.Matrix.Make([ 0, 1 ]);
  var got = _.Matrix.MakeColZeroed( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'length - 1';
  var buffer = _.Matrix.Make([ 1, 1 ]);
  var got = _.Matrix.MakeColZeroed( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeColZeroed() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeColZeroed( [ 1, 2 ], 0 ) );

  test.case = 'wrong type of buffer';
  test.shouldThrowErrorSync( () => _.Matrix.MakeColZeroed({ buffer : [ 1, 2 ] }) );

  test.case = 'buffer with dimensions that is greater than 1';
  test.shouldThrowErrorSync( () => _.Matrix.MakeColZeroed( _.Matrix.Make([ 2, 3 ]) ) );
}

//

function MakeRow( test )
{
  test.case = 'buffer - Number';
  var got = _.Matrix.MakeRow( 3 );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'buffer - Array';
  var buffer = [ 1, 2, 3 ];
  var got = _.Matrix.MakeRow( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, [ 1, 2, 3 ] );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - Unroll';
  var buffer = _.unrollMake([ 1, 2, 3 ]);
  var got = _.Matrix.MakeRow( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, [ 1, 2, 3 ] );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - ArgumentsArray';
  var buffer = _.argumentsArrayMake([ 1, 2, 3 ]);
  var got = _.Matrix.MakeRow( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - BufferTyped, U8x';
  var buffer = new U8x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeRow( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, new U8x([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - BufferTyped, I16x';
  var buffer = new I16x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeRow( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, new I16x([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - BufferTyped, F32x';
  var buffer = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeRow( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, new F32x([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - BufferTyped, F64x';
  var buffer = new F64x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeRow( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, new F64x([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - avector';
  var buffer = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.MakeRow( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - VectorAdapter';
  var buffer = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.MakeRow( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, [ 1, 2, 3 ] );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, [ 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - VectorAdapter, routine fromLongLrangeAndStride';
  var buffer = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 0, 2, 0, 3, 0 ], 1, 3, 2 );
  var got = _.Matrix.MakeRow( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, [ 0, 1, 0, 2, 0, 3, 0 ] );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, [ 2, 2 ] );
  test.identical( got.stridesEffective, [ 2, 2 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - matrix';
  var buffer = _.Matrix.Make([ 1, 3 ]).copy([ 1, 2, 3 ]);
  var got = _.Matrix.MakeRow( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, [ 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got === buffer );
  test.is( got.buffer === buffer.buffer );

  /* */

  test.case = 'length - 0';
  var buffer = _.Matrix.Make([ 1, 0 ]);
  var got = _.Matrix.MakeRow( buffer );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 1, 0 ] );
  test.identical( got.strides, [ 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got === buffer );
  test.is( got.buffer === buffer.buffer );

  test.case = 'length - 1';
  var buffer = _.Matrix.Make([ 1, 1 ]);
  var got = _.Matrix.MakeRow( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.strides, [ 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got === buffer );
  test.is( got.buffer === buffer.buffer );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeRow() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeRow( [ 1, 2 ], 0 ) );

  test.case = 'wrong type of buffer';
  test.shouldThrowErrorSync( () => _.Matrix.MakeRow({ buffer : [ 1, 2 ] }) );

  test.case = 'buffer with dimensions that is greater than 1';
  test.shouldThrowErrorSync( () => _.Matrix.MakeRow( _.Matrix.Make([ 2, 3 ]) ) );
}

//

function MakeRowZeroed( test )
{
  test.case = 'buffer - Number';
  var got = _.Matrix.MakeRowZeroed( 3 );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'buffer - Array';
  var buffer = [ 1, 2, 3 ];
  var got = _.Matrix.MakeRowZeroed( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - Unroll';
  var buffer = _.unrollMake([ 1, 2, 3 ]);
  var got = _.Matrix.MakeRowZeroed( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - ArgumentsArray';
  var buffer = _.argumentsArrayMake([ 1, 2, 3 ]);
  var got = _.Matrix.MakeRowZeroed( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - BufferTyped, U8x';
  var buffer = new U8x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeRowZeroed( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - BufferTyped, I16x';
  var buffer = new I16x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeRowZeroed( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - BufferTyped, F32x';
  var buffer = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeRowZeroed( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - BufferTyped, F64x';
  var buffer = new F64x([ 1, 2, 3 ]);
  var got = _.Matrix.MakeRowZeroed( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - avector';
  var buffer = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.MakeRowZeroed( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - VectorAdapter';
  var buffer = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.MakeRowZeroed( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - VectorAdapter, routine fromLongLrangeAndStride';
  var buffer = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 0, 2, 0, 3, 0 ], 1, 3, 2 );
  var got = _.Matrix.MakeRowZeroed( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'buffer - matrix';
  var buffer = _.Matrix.Make([ 1, 3 ]).copy([ 1, 2, 3 ]);
  var got = _.Matrix.MakeRowZeroed( buffer );
  test.identical( got.length, 3 );
  test.identical( got.buffer, _.longDescriptor.make([ 0, 0, 0 ]) );
  test.identical( got.dims, [ 1, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* */

  test.case = 'length - 0';
  var buffer = _.Matrix.Make([ 1, 0 ]);
  var got = _.Matrix.MakeRowZeroed( buffer );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 1, 0 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  test.case = 'length - 1';
  var buffer = _.Matrix.Make([ 1, 1 ]).copy( 2 );
  var got = _.Matrix.MakeRowZeroed( buffer );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );
  test.is( got !== buffer );
  test.is( got.buffer !== buffer.buffer );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeRowZeroed() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.MakeRowZeroed( [ 1, 2 ], 0 ) );

  test.case = 'wrong type of buffer';
  test.shouldThrowErrorSync( () => _.Matrix.MakeRowZeroed({ buffer : [ 1, 2 ] }) );

  test.case = 'buffer with dimensions that is greater than 1';
  test.shouldThrowErrorSync( () => _.Matrix.MakeRowZeroed( _.Matrix.Make([ 2, 3 ]) ) );
}

//

function ConvertToClassSrcIsMatrix( test )
{
  test.open( 'from classes links' );

  test.case = 'cls - Matrix';
  var src = _.Matrix.Make([ 2, 3 ]).copy
  ([
     1,  2,  3,
    -1, -2, -3
  ]);
  var got = _.Matrix.ConvertToClass( _.Matrix, src );
  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
     1,  2,  3,
    -1, -2, -3
  ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'cls - Array';
  var src = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3,
  ]);
  var got = _.Matrix.ConvertToClass( Array, src );
  var exp = [ 1, 2, 3 ];
  test.identical( got, exp );
  test.identical( src.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );

  test.case = 'cls - U8x';
  var src = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3,
  ]);
  var got = _.Matrix.ConvertToClass( U8x, src );
  var exp = new U8x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.identical( src.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );

  test.case = 'cls - I16x';
  var src = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3,
  ]);
  var got = _.Matrix.ConvertToClass( I16x, src );
  var exp = new I16x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.identical( src.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );

  test.case = 'cls - F32x';
  var src = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3,
  ]);
  var got = _.Matrix.ConvertToClass( F32x, src );
  var exp = new F32x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.identical( src.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );

  test.case = 'cls - F64x';
  var src = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3,
  ]);
  var got = _.Matrix.ConvertToClass( F64x, src );
  var exp = new F64x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.identical( src.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );

  test.case = 'cls - VectorAdapter';
  var src = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3,
  ]);
  var got = _.Matrix.ConvertToClass( _.VectorAdapter, src );
  var exp = _.longDescriptor.make([ 1, 2, 3 ]);
  test.identical( got.toLong(), exp );
  test.identical( src.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );

  test.close( 'from classes links' );

  /* - */

  test.open( 'from constructors' );

  test.case = 'constructor - Matrix';
  var src = _.Matrix.Make([ 2, 3 ]).copy
  ([
     1,  2,  3,
    -1, -2, -3
  ]);
  var got = _.Matrix.ConvertToClass( _.Matrix.Make([ 1, 1 ]).constructor, src );
  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
     1,  2,  3,
    -1, -2, -3
  ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'constructor - Array';
  var src = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3,
  ]);
  var got = _.Matrix.ConvertToClass( [].constructor, src );
  var exp = [ 1, 2, 3 ];
  test.identical( got, exp );
  test.identical( src.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );

  test.case = 'constructor of Unroll';
  var src = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3,
  ]);
  var got = _.Matrix.ConvertToClass( _.unrollMake([]).constructor, src );
  var exp = [ 1, 2, 3 ];
  test.identical( got, exp );
  test.identical( src.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );

  test.case = 'constructor - U8x';
  var src = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3,
  ]);
  var got = _.Matrix.ConvertToClass( new U8x( 0 ).constructor, src );
  var exp = new U8x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.identical( src.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );

  test.case = 'constructor - I16x';
  var src = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3,
  ]);
  var got = _.Matrix.ConvertToClass( new I16x( 0 ).constructor, src );
  var exp = new I16x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.identical( src.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );

  test.case = 'constructor - F32x';
  var src = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3,
  ]);
  var got = _.Matrix.ConvertToClass( new F32x( 0 ).constructor, src );
  var exp = new F32x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.identical( src.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );

  test.case = 'constructor - F64x';
  var src = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3,
  ]);
  var got = _.Matrix.ConvertToClass( new F64x( 0 ).constructor, src );
  var exp = new F64x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.identical( src.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );

  test.case = 'constructor - avector';
  var src = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3,
  ]);
  var got = _.Matrix.ConvertToClass( _.avector.make([]).constructor, src );
  var exp = _.longDescriptor.make([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.identical( src.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );

  test.case = 'constructor - VectorAdapter';
  var src = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3,
  ]);
  var got = _.Matrix.ConvertToClass( _.vectorAdapter.from([]).constructor, src );
  var exp = _.longDescriptor.make([ 1, 2, 3 ]);
  test.identical( got.toLong(), exp );
  test.identical( src.buffer, _.longDescriptor.make([ 1, 2, 3 ]) );

  test.close( 'from constructors' );

  /* - */

  test.open( 'from constructors, matrix with offset and non default strides' );

  test.case = 'constructor - Matrix';
  var src = new _.Matrix
  ({
    buffer : [ 0, 1, 0, 2, 0, 3, 0, -1, 0, -2, 0, -3 ],
    offset : 1,
    dims : [ 2, 3 ],
    strides : [ 6, 2 ]
  });
  var got = _.Matrix.ConvertToClass( _.Matrix.Make([ 1, 1 ]).constructor, src );
  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
     1,  2,  3,
    -1, -2, -3
  ]);
  test.equivalent( got, exp );
  test.is( got === src );

  test.case = 'constructor - Array';
  var src = new _.Matrix
  ({
    buffer : [ 0, 1, 0, 2, 0, 3, 0, -1, 0, -2, 0, -3 ],
    offset : 1,
    dims : [ 3, 1 ],
    strides : [ 2, 1 ]
  });
  var got = _.Matrix.ConvertToClass( [].constructor, src );
  var exp = [ 1, 2, 3 ];
  test.identical( got, exp );
  test.identical( src.buffer, [ 0, 1, 0, 2, 0, 3, 0, -1, 0, -2, 0, -3 ] );

  test.case = 'constructor of Unroll';
  var src = new _.Matrix
  ({
    buffer : [ 0, 1, 0, 2, 0, 3, 0, -1, 0, -2, 0, -3 ],
    offset : 1,
    dims : [ 3, 1 ],
    strides : [ 2, 1 ]
  });
  var got = _.Matrix.ConvertToClass( _.unrollMake([]).constructor, src );
  var exp = [ 1, 2, 3 ];
  test.identical( got, exp );
  test.identical( src.buffer, [ 0, 1, 0, 2, 0, 3, 0, -1, 0, -2, 0, -3 ] );

  test.case = 'constructor - U8x';
  var src = new _.Matrix
  ({
    buffer : [ 0, 1, 0, 2, 0, 3, 0, -1, 0, -2, 0, -3 ],
    offset : 1,
    dims : [ 3, 1 ],
    strides : [ 2, 1 ]
  });
  var got = _.Matrix.ConvertToClass( new U8x( 0 ).constructor, src );
  var exp = new U8x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.identical( src.buffer, [ 0, 1, 0, 2, 0, 3, 0, -1, 0, -2, 0, -3 ] );

  test.case = 'constructor - I16x';
  var src = new _.Matrix
  ({
    buffer : [ 0, 1, 0, 2, 0, 3, 0, -1, 0, -2, 0, -3 ],
    offset : 1,
    dims : [ 3, 1 ],
    strides : [ 2, 1 ]
  });
  var got = _.Matrix.ConvertToClass( new I16x( 0 ).constructor, src );
  var exp = new I16x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.identical( src.buffer, [ 0, 1, 0, 2, 0, 3, 0, -1, 0, -2, 0, -3 ] );

  test.case = 'constructor - F32x';
  var src = new _.Matrix
  ({
    buffer : [ 0, 1, 0, 2, 0, 3, 0, -1, 0, -2, 0, -3 ],
    offset : 1,
    dims : [ 3, 1 ],
    strides : [ 2, 1 ]
  });
  var got = _.Matrix.ConvertToClass( new F32x( 0 ).constructor, src );
  var exp = new F32x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.identical( src.buffer, [ 0, 1, 0, 2, 0, 3, 0, -1, 0, -2, 0, -3 ] );

  test.case = 'constructor - F64x';
  var src = new _.Matrix
  ({
    buffer : [ 0, 1, 0, 2, 0, 3, 0, -1, 0, -2, 0, -3 ],
    offset : 1,
    dims : [ 3, 1 ],
    strides : [ 2, 1 ]
  });
  var got = _.Matrix.ConvertToClass( new F64x( 0 ).constructor, src );
  var exp = new F64x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.identical( src.buffer, [ 0, 1, 0, 2, 0, 3, 0, -1, 0, -2, 0, -3 ] );

  test.case = 'constructor - avector';
  var src = new _.Matrix
  ({
    buffer : [ 0, 1, 0, 2, 0, 3, 0, -1, 0, -2, 0, -3 ],
    offset : 1,
    dims : [ 3, 1 ],
    strides : [ 2, 1 ]
  });
  var got = _.Matrix.ConvertToClass( _.avector.make([]).constructor, src );
  var exp = _.longDescriptor.make([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.identical( src.buffer, [ 0, 1, 0, 2, 0, 3, 0, -1, 0, -2, 0, -3 ] );

  test.case = 'constructor - VectorAdapter';
  var src = new _.Matrix
  ({
    buffer : [ 0, 1, 0, 2, 0, 3, 0, -1, 0, -2, 0, -3 ],
    offset : 1,
    dims : [ 3, 1 ],
    strides : [ 2, 1 ]
  });
  var got = _.Matrix.ConvertToClass( _.vectorAdapter.from([]).constructor, src );
  var exp = [ 1, 2, 3 ];
  test.identical( got.toLong(), exp );
  test.identical( src.buffer, [ 0, 1, 0, 2, 0, 3, 0, -1, 0, -2, 0, -3 ] );

  test.close( 'from constructors, matrix with offset and non default strides' );
}

//

function ConvertToClassSrcIsNotMatrix( test )
{
  test.open( 'src is an Array' );

  test.case = 'cls - Matrix';
  var src = [ 1, 2, 3 ];
  var got = _.Matrix.ConvertToClass( _.Matrix, src );
  var exp = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3
  ]);
  test.equivalent( got, exp );

  test.case = 'cls - Array';
  var src = [ 1, 2, 3 ];
  var got = _.Matrix.ConvertToClass( Array, src );
  var exp = [ 1, 2, 3 ];
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'cls - U8x';
  var src = [ 1, 2, 3 ];
  var got = _.Matrix.ConvertToClass( U8x, src );
  var exp = new U8x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'cls - I16x';
  var src = [ 1, 2, 3 ];
  var got = _.Matrix.ConvertToClass( I16x, src );
  var exp = new I16x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'cls - F32x';
  var src = [ 1, 2, 3 ];
  var got = _.Matrix.ConvertToClass( F32x, src );
  var exp = new F32x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'constructor - avector';
  var src = [ 1, 2, 3 ];
  var got = _.Matrix.ConvertToClass( _.avector.make([]).constructor, src );
  var exp = _.longDescriptor.make([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'cls - VectorAdapter';
  var src = [ 1, 2, 3 ];
  var got = _.Matrix.ConvertToClass( _.VectorAdapter, src );
  var exp = [ 1, 2, 3 ];
  test.identical( got.toLong(), exp );
  test.is( got !== src );

  test.case = 'constructor - VectorAdapter';
  var src = [ 1, 2, 3 ];
  var got = _.Matrix.ConvertToClass( _.vectorAdapter.from([]).constructor, src );
  var exp = [ 1, 2, 3 ];
  test.identical( got.toLong(), exp );
  test.is( got !== src );

  test.close( 'src is an Array' );

  /* - */

  test.open( 'src is a BufferTyped' );

  test.case = 'cls - Matrix';
  var src = new U8x([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( _.Matrix, src );
  var exp = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3
  ]);
  test.equivalent( got, exp );

  test.case = 'cls - Array';
  var src = new I16x([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( Array, src );
  var exp = [ 1, 2, 3 ];
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'cls - U8x';
  var src = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( U8x, src );
  var exp = new U8x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'cls - I16x';
  var src = new F64x([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( I16x, src );
  var exp = new I16x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'cls - F32x';
  var src = new I8x([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( F32x, src );
  var exp = new F32x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'constructor - avector';
  var src = new U16x([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( _.avector.make([]).constructor, src );
  var exp = _.longDescriptor.make([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'cls - VectorAdapter';
  var src = new I32x([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( _.VectorAdapter, src );
  var exp = new I32x([ 1, 2, 3 ]);
  test.identical( got.toLong(), exp );
  test.is( got !== src );

  test.case = 'constructor - VectorAdapter';
  var src = new U32x([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( _.vectorAdapter.from([]).constructor, src );
  var exp = new U32x([ 1, 2, 3 ]);
  test.identical( got.toLong(), exp );
  test.is( got !== src );

  test.close( 'src is a BufferTyped' );

  /* - */

  test.open( 'src is an avector' );

  test.case = 'cls - Matrix';
  var src = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( _.Matrix, src );
  var exp = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3
  ]);
  test.equivalent( got, exp );

  test.case = 'cls - Array';
  var src = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( Array, src );
  var exp = [ 1, 2, 3 ];
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'cls - U8x';
  var src = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( U8x, src );
  var exp = new U8x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'cls - I16x';
  var src = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( I16x, src );
  var exp = new I16x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'cls - F32x';
  var src = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( F32x, src );
  var exp = new F32x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'constructor - avector';
  var src = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( _.avector.make([]).constructor, src );
  var exp = _.longDescriptor.make([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'cls - VectorAdapter';
  var src = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( _.VectorAdapter, src );
  var exp = _.longDescriptor.make([ 1, 2, 3 ]);
  test.identical( got.toLong(), exp );
  test.is( got !== src );

  test.case = 'constructor - VectorAdapter';
  var src = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( _.vectorAdapter.from([]).constructor, src );
  var exp = _.longDescriptor.make([ 1, 2, 3 ]);
  test.identical( got.toLong(), exp );
  test.is( got !== src );

  test.close( 'src is an avector' );

  /* - */

  test.open( 'src is a VectorAdapter' );

  test.case = 'cls - Matrix';
  var src = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( _.Matrix, src );
  var exp = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3
  ]);
  test.equivalent( got, exp );

  test.case = 'cls - Array';
  var src = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( Array, src );
  var exp = [ 1, 2, 3 ];
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'cls - U8x';
  var src = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( U8x, src );
  var exp = new U8x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'cls - I16x';
  var src = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( I16x, src );
  var exp = new I16x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'cls - F32x';
  var src = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( F32x, src );
  var exp = new F32x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'constructor - avector';
  var src = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( _.avector.make([]).constructor, src );
  var exp = _.longDescriptor.make([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'cls - VectorAdapter';
  var src = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( _.VectorAdapter, src );
  var exp = [ 1, 2, 3 ];
  test.identical( got.toLong(), exp );
  test.is( got !== src );

  test.case = 'constructor - VectorAdapter';
  var src = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( _.vectorAdapter.from([]).constructor, src );
  var exp = [ 1, 2, 3 ];
  test.identical( got.toLong(), exp );
  test.is( got === src );

  test.close( 'src is a VectorAdapter' );

  /* - */

  test.open( 'src is a VectorAdapter with stride and offset' );

  test.case = 'cls - Matrix';
  var src = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 0, 2, 0, 3, 0 ], 1, 3, 2 );
  var got = _.Matrix.ConvertToClass( _.Matrix, src );
  var exp = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3
  ]);
  test.equivalent( got, exp );

  test.case = 'cls - Array';
  var src = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 0, 2, 0, 3, 0 ], 1, 3, 2 );
  var got = _.Matrix.ConvertToClass( Array, src );
  var exp = [ 1, 2, 3 ];
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'cls - U8x';
  var src = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 0, 2, 0, 3, 0 ], 1, 3, 2 );
  var got = _.Matrix.ConvertToClass( U8x, src );
  var exp = new U8x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'cls - I16x';
  var src = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 0, 2, 0, 3, 0 ], 1, 3, 2 );
  var got = _.Matrix.ConvertToClass( I16x, src );
  var exp = new I16x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'cls - F32x';
  var src = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 0, 2, 0, 3, 0 ], 1, 3, 2 );
  var got = _.Matrix.ConvertToClass( F32x, src );
  var exp = new F32x([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'constructor - avector';
  var src = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 0, 2, 0, 3, 0 ], 1, 3, 2 );
  var got = _.Matrix.ConvertToClass( _.avector.make([]).constructor, src );
  var exp = _.longDescriptor.make([ 1, 2, 3 ]);
  test.identical( got, exp );
  test.is( got !== src );

  test.case = 'cls - VectorAdapter';
  var src = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 0, 2, 0, 3, 0 ], 1, 3, 2 );
  var got = _.Matrix.ConvertToClass( _.VectorAdapter, src );
  var exp = [ 1, 2, 3 ];
  test.identical( got.toLong(), exp );
  test.is( got !== src );

  test.case = 'constructor - VectorAdapter';
  var src = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 0, 2, 0, 3, 0 ], 1, 3, 2 );
  var got = _.Matrix.ConvertToClass( _.vectorAdapter.from([]).constructor, src );
  var exp = [ 1, 2, 3 ];
  test.identical( got.toLong(), exp );
  test.is( got !== src );

  test.close( 'src is a VectorAdapter with stride and offset' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix.ConvertToClass() );

  test.case = 'not enough arguments';
  test.shouldThrowErrorSync( () => _.Matrix.ConvertToClass( Array ) );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.ConvertToClass( Array, _.Matrix.Make([ 2, 1 ]), Array ) );

  test.case = 'wrong type of cls';
  test.shouldThrowErrorSync( () => _.Matrix.ConvertToClass( null, _.Matrix.Make([ 2, 1 ]) ) );
  test.shouldThrowErrorSync( () => _.Matrix.ConvertToClass( [], _.Matrix.Make([ 2, 1 ]) ) );

  test.case = 'wrong type of src';
  test.shouldThrowErrorSync( () => _.Matrix.ConvertToClass( _.Matrix, null ) );
  test.shouldThrowErrorSync( () => _.Matrix.ConvertToClass( _.Matrix, _.argumentsArrayMake([ 1, 2 ]) ) );

  test.case = 'wrong length of dims[ 1 ] if src is a matrix';
  test.shouldThrowErrorSync( () => _.Matrix.ConvertToClass( Array, _.Matrix.Make([ 1, 2 ]) ) );

  test.case = 'wrong length of dims.length if src is a matrix';
  test.shouldThrowErrorSync( () => _.Matrix.ConvertToClass( Array, _.Matrix.Make([ 2, 1, 2 ]) ) );
}

//

function FromVector( test )
{
  test.open( 'src is a VectorAdapter' );

  test.case = 'routine make';
  var src = _.vectorAdapter.make([ 1, 2, 3 ]);
  var got = _.Matrix.FromVector( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine makeFilling';
  var src = _.vectorAdapter.makeFilling( 3, 5 );
  var got = _.Matrix.FromVector( src );
  var exp = _.Matrix.MakeCol
  ([
    5,
    5,
    5,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine from';
  var src = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.FromVector( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromLong';
  var src = _.vectorAdapter.fromLong([ 1, 2, 3 ]);
  var got = _.Matrix.FromVector( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromLongLrange';
  var src = _.vectorAdapter.fromLongLrange( [ 0, 1, 2, 3, 4 ], 1, 3 );
  var got = _.Matrix.FromVector( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromLongWithStride';
  var src = _.vectorAdapter.fromLongWithStride( [ 0, 1, 2, 3, 4 ], 2 );
  var got = _.Matrix.FromVector( src );
  var exp = _.Matrix.MakeCol
  ([
    0,
    2,
    4,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromLongLrangeAndStride';
  var src = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 2, 3, 4, 5, 6 ], 1, 3, 2 );
  var got = _.Matrix.FromVector( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    3,
    5,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromNumber, number';
  var src = _.vectorAdapter.fromNumber( 5, 3 );
  var got = _.Matrix.FromVector( src );
  var exp = _.Matrix.MakeCol
  ([
    5,
    5,
    5,
  ]);
  test.equivalent( got, exp ); /* xxx */
  test.is( got.buffer !== src._vectorBuffer );

  test.case = 'routine fromMaybeNumber, number';
  var src = _.vectorAdapter.fromMaybeNumber( 5, 3 );
  var got = _.Matrix.FromVector( src );
  var exp = _.Matrix.MakeCol
  ([
    5,
    5,
    5,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer !== src._vectorBuffer );

  test.case = 'routine fromMaybeNumber, Long';
  var src = _.vectorAdapter.fromMaybeNumber( [ 1, 2, 3 ], 3 );
  var got = _.Matrix.FromVector( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.close( 'src is a VectorAdapter' );

  /* - */

  test.open( 'src is a Long' );

  test.case = 'Array';
  var src = [ 1, 2, 3 ];
  var got = _.Matrix.FromVector( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'Unroll';
  var src = _.unrollMake([ 1, 2, 3 ]);
  var got = _.Matrix.FromVector( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'ArgumentsArray';
  var src = _.argumentsArrayMake([ 1, 2, 3 ]);
  var got = _.Matrix.FromVector( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'BufferTyped, U8x';
  var src = new U8x([ 1, 2, 3 ]);
  var got = _.Matrix.FromVector( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'BufferTyped, I16x';
  var src = new I16x([ 1, 2, 3 ]);
  var got = _.Matrix.FromVector( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'BufferTyped, F32x';
  var src = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix.FromVector( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'BufferTyped, F64x';
  var src = new F64x([ 1, 2, 3 ]);
  var got = _.Matrix.FromVector( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'avector';
  var src = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.FromVector( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.close( 'src is a Long' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix.FromVector() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.FromVector( [ 1, 2, 3 ], [ 1, 2 ] ) );

  test.case = 'wrong type of src';
  test.shouldThrowErrorSync( () => _.Matrix.FromVector( null ) );
  test.shouldThrowErrorSync( () => _.Matrix.FromVector( 2 ) );
}

//

function FromScalarChangeDimsLength( test )
{
  test.open( '2D' );

  test.case = 'single scalar';
  var got = _.Matrix.FromScalar( 3 );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.dimsEffective, [ 1, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - [ Infinity, Infinity ]';
  var got = _.Matrix.FromScalar( 3, [ Infinity, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ Infinity, Infinity ] );
  test.identical( got.dimsEffective, [ 1, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0 ]';
  var got = _.Matrix.FromScalar( 3, [ 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.dimsEffective, [ 0, 0 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'dims - [ 1, 1 ]';
  var got = _.Matrix.FromScalar( 3, [ 1, 1 ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.dimsEffective, [ 1, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - [ 3, 2 ]';
  var got = _.Matrix.FromScalar( 3, [ 3, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 3, 3, 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.dimsEffective, [ 3, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - [ 2, 0 ]';
  var got = _.Matrix.FromScalar( 3, [ 2, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 0 ] );
  test.identical( got.dimsEffective, [ 2, 0 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - [ 0, 2 ]';
  var got = _.Matrix.FromScalar( 3, [ 0, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 2 ] );
  test.identical( got.dimsEffective, [ 0, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'dims - [ Infinity, 2 ]';
  var got = _.Matrix.FromScalar( 3, [ 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.dimsEffective, [ 0, 0 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'dims - [ 2, Infinity ]';
  var got = _.Matrix.FromScalar( 3, [ 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.dimsEffective, [ 0, 0 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.close( '2D' );

  /* - */

  test.open( '3D' );

  test.case = 'dims - [ Infinity, Infinity, Infinity ]';
  var got = _.Matrix.FromScalar( 3, [ Infinity, Infinity, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ Infinity, Infinity, Infinity ] );
  test.identical( got.dimsEffective, [ 1, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0, 0 ]';
  var got = _.Matrix.FromScalar( 3, [ 0, 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0, 0 ] );
  test.identical( got.dimsEffective, [ 0, 0, 0 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0, 0 ] );

  test.case = 'dims - [ 1, 1, 1 ]';
  var got = _.Matrix.FromScalar( 3, [ 1, 1, 1 ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 1, 1, 1 ] );
  test.identical( got.dimsEffective, [ 1, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - [ 2, 3, 4 ]';
  var got = _.Matrix.FromScalar( 3, [ 2, 3, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3 ] ) );
  test.identical( got.dims, [ 2, 3, 4 ] );
  test.identical( got.dimsEffective, [ 2, 3, 4 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2, 6 ] );

  test.case = 'dims - [ 0, 3, 4 ]';
  var got = _.Matrix.FromScalar( 3, [ 0, 3, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 3, 4 ] );
  test.identical( got.dimsEffective, [ 0, 3, 4 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0, 0 ] );

  test.case = 'dims - [ 2, 0, 4 ]';
  var got = _.Matrix.FromScalar( 3, [ 2, 0, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 0, 4 ] );
  test.identical( got.dimsEffective, [ 2, 0, 4 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2, 0 ] );

  test.case = 'dims - [ 2, 3, 0 ]';
  var got = _.Matrix.FromScalar( 3, [ 2, 3, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 3, 0 ] );
  test.identical( got.dimsEffective, [ 2, 3, 0 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2, 6 ] );

  test.case = 'dims - [ Infinity, 3, 4 ]';
  var got = _.Matrix.FromScalar( 3, [ Infinity, 3, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make([ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ Infinity, 3, 4 ] );
  test.identical( got.dimsEffective, [ 1, 3, 4 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 0, 1, 3 ] );

  test.case = 'dims - [ 2, Infinity, 4 ]';
  var got = _.Matrix.FromScalar( 3, [ 2, Infinity, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make([ 3, 3, 3, 3, 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 2, Infinity, 4 ] );
  test.identical( got.dimsEffective, [ 2, 1, 4 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0, 2 ] );

  test.case = 'dims - [ 2, 3, Infinity ]';
  var got = _.Matrix.FromScalar( 3, [ 2, 3, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3, 3, 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 2, 3, Infinity ] );
  test.identical( got.dimsEffective, [ 2, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.close( '3D' );

  /* - */

  test.open( '4D' );

  test.case = 'dims - [ Infinity, Infinity, Infinity, Infinity ]';
  var got = _.Matrix.FromScalar( 3, [ Infinity, Infinity, Infinity, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ Infinity, Infinity, Infinity, Infinity ] );
  test.identical( got.dimsEffective, [ 1, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0, 0, 0 ]';
  var got = _.Matrix.FromScalar( 3, [ 0, 0, 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0, 0, 0 ] );
  test.identical( got.dimsEffective, [ 0, 0, 0, 0 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0, 0, 0 ] );

  test.case = 'dims - [ 1, 1, 1, 1 ]';
  var got = _.Matrix.FromScalar( 3, [ 1, 1, 1, 1 ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 1, 1, 1, 1 ] );
  test.identical( got.dimsEffective, [ 1, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - [ 2, 3, 4, 2 ]';
  var got = _.Matrix.FromScalar( 3, [ 2, 3, 4, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
    3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
  ]));
  test.identical( got.dims, [ 2, 3, 4, 2 ] );
  test.identical( got.dimsEffective, [ 2, 3, 4, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2, 6, 24 ] );

  test.case = 'dims - [ 0, 3, 4, 5 ]';
  var got = _.Matrix.FromScalar( 3, [ 0, 3, 4, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 3, 4, 5 ] );
  test.identical( got.dimsEffective, [ 0, 3, 4, 5 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0, 0, 0 ] );

  test.case = 'dims - [ 2, 0, 4, 5 ]';
  var got = _.Matrix.FromScalar( 3, [ 2, 0, 4, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 0, 4, 5 ] );
  test.identical( got.dimsEffective, [ 2, 0, 4, 5 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2, 0, 0 ] );

  test.case = 'dims - [ 2, 3, 0, 5 ]';
  var got = _.Matrix.FromScalar( 3, [ 2, 3, 0, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 3, 0, 5 ] );
  test.identical( got.dimsEffective, [ 2, 3, 0, 5 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2, 6, 0 ] );

  test.case = 'dims - [ 2, 3, 4, 0 ]';
  var got = _.Matrix.FromScalar( 3, [ 2, 3, 4, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 3, 4, 0 ] );
  test.identical( got.dimsEffective, [ 2, 3, 4, 0 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2, 6, 24 ] );

  test.case = 'dims - [ Infinity, 3, 4, 2 ]';
  var got = _.Matrix.FromScalar( 3, [ Infinity, 3, 4, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
    3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
  ]));
  test.identical( got.dims, [ Infinity, 3, 4, 2 ] );
  test.identical( got.dimsEffective, [ 1, 3, 4, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 0, 1, 3, 12 ] );

  test.case = 'dims - [ 2, Infinity, 4, 2 ]';
  var got = _.Matrix.FromScalar( 3, [ 2, Infinity, 4, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    3, 3, 3, 3, 3, 3, 3, 3,
    3, 3, 3, 3, 3, 3, 3, 3,
  ]));
  test.identical( got.dims, [ 2, Infinity, 4, 2 ] );
  test.identical( got.dimsEffective, [ 2, 1, 4, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0, 2, 8 ] );

  test.case = 'dims - [ 2, 3, Infinity, 2 ]';
  var got = _.Matrix.FromScalar( 3, [ 2, 3, Infinity, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    3, 3, 3, 3, 3, 3,
    3, 3, 3, 3, 3, 3
  ]));
  test.identical( got.dims, [ 2, 3, Infinity, 2 ] );
  test.identical( got.dimsEffective, [ 2, 3, 1, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2, 6, 6 ] );

  test.case = 'dims - [ 2, 3, 4, Infinity ]';
  var got = _.Matrix.FromScalar( 3, [ 2, 3, 4, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
  ]));
  test.identical( got.dims, [ 2, 3, 4, Infinity ] );
  test.identical( got.dimsEffective, [ 2, 3, 4 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2, 6 ] );

  test.close( '4D' );
}

//

function FromScalarChangeDimsType( test )
{

  test.case = 'dims - Array';
  var dims = [ 2, 2 ];
  var got = _.Matrix.FromScalar( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.dimsEffective, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - Unroll';
  var dims = _.unrollMake([ 2, 2 ]);
  var got = _.Matrix.FromScalar( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.dimsEffective, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - ArgumentsArray';
  var dims = _.argumentsArrayMake([ 2, 2 ]);
  var got = _.Matrix.FromScalar( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.dimsEffective, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - BufferTyped, U8x';
  var dims = new U8x([ 2, 2 ]);
  var got = _.Matrix.FromScalar( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3 ]) );
  test.identical( got.dims, new U8x([ 2, 2 ]) );
  test.identical( got.dimsEffective, new U8x([ 2, 2 ]) );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - BufferTyped, I16x';
  var dims = new I16x([ 2, 2 ]);
  var got = _.Matrix.FromScalar( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3 ]) );
  test.identical( got.dims, new I16x([ 2, 2 ]) );
  test.identical( got.dimsEffective, new I16x([ 2, 2 ]) );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - BufferTyped, F32x';
  var dims = new F32x([ 2, 2 ]);
  var got = _.Matrix.FromScalar( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3 ]) );
  test.identical( got.dims, new F32x([ 2, 2 ]) );
  test.identical( got.dimsEffective, new F32x([ 2, 2 ]) );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - BufferTyped, F64x';
  var dims = new F64x([ 2, 2 ]);
  var got = _.Matrix.FromScalar( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3 ]) );
  test.identical( got.dims, new F64x([ 2, 2 ]) );
  test.identical( got.dimsEffective, new F64x([ 2, 2 ]) );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - avector';
  var dims = _.avector.make([ 2, 2 ]);
  var got = _.Matrix.FromScalar( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3 ]) );
  test.identical( got.dims, _.avector.make([ 2, 2 ]) );
  test.identical( got.dimsEffective, _.avector.make([ 2, 2 ]) );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - VectorAdapter';
  var dims = _.vectorAdapter.from([ 2, 2 ]);
  var got = _.Matrix.FromScalar( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.dimsEffective, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - VectorAdapter, routine fromLongLrangeAndStride';
  var dims = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 2, 0, 2, 0 ], 1, 2, 2 );
  var got = _.Matrix.FromScalar( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.dimsEffective, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix.FromScalar() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.FromScalar( 3, [ 2, 1 ], 3 ) );

  test.case = 'wrong type of scalar';
  test.shouldThrowErrorSync( () => _.Matrix.FromScalar( [ 1 ], [ 2, 1 ] ) );
  test.shouldThrowErrorSync( () => _.Matrix.FromScalar( 'a', [ 2, 1 ] ) );

  test.case = 'wrong type of dims';
  test.shouldThrowErrorSync( () => _.Matrix.FromScalar( 3, null ) );
  test.shouldThrowErrorSync( () => _.Matrix.FromScalar( 3, { 1 : 2 } ) );
}

//

function FromScalarForReadingChangeDimsLength( test )
{
  test.open( '2D' );

  test.case = 'single scalar';
  var got = _.Matrix.FromScalarForReading( 3 );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.dimsEffective, [ 1, 1 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ Infinity, Infinity ]';
  var got = _.Matrix.FromScalarForReading( 3, [ Infinity, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ Infinity, Infinity ] );
  test.identical( got.dimsEffective, [ 1, 1 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 0, 0 ] );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.dimsEffective, [ 0, 0 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 1, 1 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 1, 1 ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.dimsEffective, [ 1, 1 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 3, 2 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 3, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.dimsEffective, [ 3, 2 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 2, 0 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 2, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 0 ] );
  test.identical( got.dimsEffective, [ 2, 0 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 2 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 0, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 0, 2 ] );
  test.identical( got.dimsEffective, [ 0, 2 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ Infinity, 2 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.dimsEffective, [ 0, 0 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 2, Infinity ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.dimsEffective, [ 0, 0 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.close( '2D' );

  /* - */

  test.open( '3D' );

  test.case = 'dims - [ Infinity, Infinity, Infinity ]';
  var got = _.Matrix.FromScalarForReading( 3, [ Infinity, Infinity, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ Infinity, Infinity, Infinity ] );
  test.identical( got.dimsEffective, [ 1, 1 ] );
  test.identical( got.strides, [ 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0, 0 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 0, 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 0, 0, 0 ] );
  test.identical( got.dimsEffective, [ 0, 0, 0 ] );
  test.identical( got.strides, [ 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0 ] );

  test.case = 'dims - [ 1, 1, 1 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 1, 1, 1 ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 1, 1, 1 ] );
  test.identical( got.dimsEffective, [ 1, 1 ] );
  test.identical( got.strides, [ 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 2, 3, 4 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 2, 3, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 3, 4 ] );
  test.identical( got.dimsEffective, [ 2, 3, 4 ] );
  test.identical( got.strides, [ 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0 ] );

  test.case = 'dims - [ 0, 3, 4 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 0, 3, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 0, 3, 4 ] );
  test.identical( got.dimsEffective, [ 0, 3, 4 ] );
  test.identical( got.strides, [ 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0 ] );

  test.case = 'dims - [ 2, 0, 4 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 2, 0, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 0, 4 ] );
  test.identical( got.dimsEffective, [ 2, 0, 4 ] );
  test.identical( got.strides, [ 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0 ] );

  test.case = 'dims - [ 2, 3, 0 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 2, 3, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 3, 0 ] );
  test.identical( got.dimsEffective, [ 2, 3, 0 ] );
  test.identical( got.strides, [ 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0 ] );

  test.case = 'dims - [ Infinity, 3, 4 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ Infinity, 3, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ Infinity, 3, 4 ] );
  test.identical( got.dimsEffective, [ 1, 3, 4 ] );
  test.identical( got.strides, [ 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0 ] );

  test.case = 'dims - [ 2, Infinity, 4 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 2, Infinity, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, Infinity, 4 ] );
  test.identical( got.dimsEffective, [ 2, 1, 4 ] );
  test.identical( got.strides, [ 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0 ] );

  test.case = 'dims - [ 2, 3, Infinity ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 2, 3, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 3, Infinity ] );
  test.identical( got.dimsEffective, [ 2, 3 ] );
  test.identical( got.strides, [ 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.close( '3D' );

  /* - */

  test.open( '4D' );

  test.case = 'dims - [ Infinity, Infinity, Infinity, Infinity ]';
  var got = _.Matrix.FromScalarForReading( 3, [ Infinity, Infinity, Infinity, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ Infinity, Infinity, Infinity, Infinity ] );
  test.identical( got.dimsEffective, [ 1, 1 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0, 0, 0 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 0, 0, 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 0, 0, 0, 0 ] );
  test.identical( got.dimsEffective, [ 0, 0, 0, 0 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0, 0 ] );

  test.case = 'dims - [ 1, 1, 1, 1 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 1, 1, 1, 1 ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 1, 1, 1, 1 ] );
  test.identical( got.dimsEffective, [ 1, 1 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 2, 3, 4, 2 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 2, 3, 4, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer,_.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 3, 4, 2 ] );
  test.identical( got.dimsEffective, [ 2, 3, 4, 2 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0, 0 ] );

  test.case = 'dims - [ 0, 3, 4, 5 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 0, 3, 4, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 0, 3, 4, 5 ] );
  test.identical( got.dimsEffective, [ 0, 3, 4, 5 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0, 0 ] );

  test.case = 'dims - [ 2, 0, 4, 5 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 2, 0, 4, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 0, 4, 5 ] );
  test.identical( got.dimsEffective, [ 2, 0, 4, 5 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0, 0 ] );

  test.case = 'dims - [ 2, 3, 0, 5 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 2, 3, 0, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 3, 0, 5 ] );
  test.identical( got.dimsEffective, [ 2, 3, 0, 5 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0, 0 ] );

  test.case = 'dims - [ 2, 3, 4, 0 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 2, 3, 4, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 3, 4, 0 ] );
  test.identical( got.dimsEffective, [ 2, 3, 4, 0 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0, 0 ] );

  test.case = 'dims - [ Infinity, 3, 4, 2 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ Infinity, 3, 4, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer,_.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ Infinity, 3, 4, 2 ] );
  test.identical( got.dimsEffective, [ 1, 3, 4, 2 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0, 0 ] );

  test.case = 'dims - [ 2, Infinity, 4, 2 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 2, Infinity, 4, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer,_.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, Infinity, 4, 2 ] );
  test.identical( got.dimsEffective, [ 2, 1, 4, 2 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0, 0 ] );

  test.case = 'dims - [ 2, 3, Infinity, 2 ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 2, 3, Infinity, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer,_.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 3, Infinity, 2 ] );
  test.identical( got.dimsEffective, [ 2, 3, 1, 2 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0, 0 ] );

  test.case = 'dims - [ 2, 3, 4, Infinity ]';
  var got = _.Matrix.FromScalarForReading( 3, [ 2, 3, 4, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer,_.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 3, 4, Infinity ] );
  test.identical( got.dimsEffective, [ 2, 3, 4 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0 ] );

  test.close( '4D' );
}

//

function FromScalarForReadingChangeDimsType( test )
{
  test.case = 'dims - Array';
  var dims = [ 2, 2 ];
  var got = _.Matrix.FromScalarForReading( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.dimsEffective, [ 2, 2 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - Unroll';
  var dims = _.unrollMake([ 2, 2 ]);
  var got = _.Matrix.FromScalarForReading( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.dimsEffective, [ 2, 2 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - ArgumentsArray';
  var dims = _.argumentsArrayMake([ 2, 2 ]);
  var got = _.Matrix.FromScalarForReading( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.dimsEffective, [ 2, 2 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - BufferTyped, U8x';
  var dims = new U8x([ 2, 2 ]);
  var got = _.Matrix.FromScalarForReading( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, new U8x([ 2, 2 ]) );
  test.identical( got.dimsEffective, new U8x([ 2, 2 ]) );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - BufferTyped, I16x';
  var dims = new I16x([ 2, 2 ]);
  var got = _.Matrix.FromScalarForReading( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, new I16x([ 2, 2 ]) );
  test.identical( got.dimsEffective, new I16x([ 2, 2 ]) );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - BufferTyped, F32x';
  var dims = new F32x([ 2, 2 ]);
  var got = _.Matrix.FromScalarForReading( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, new F32x([ 2, 2 ]) );
  test.identical( got.dimsEffective, new F32x([ 2, 2 ]) );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - BufferTyped, F64x';
  var dims = new F64x([ 2, 2 ]);
  var got = _.Matrix.FromScalarForReading( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, new F64x([ 2, 2 ]) );
  test.identical( got.dimsEffective, new F64x([ 2, 2 ]) );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - avector';
  var dims = _.avector.make([ 2, 2 ]);
  var got = _.Matrix.FromScalarForReading( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, _.avector.make([ 2, 2 ]) );
  test.identical( got.dimsEffective, _.avector.make([ 2, 2 ]) );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - VectorAdapter';
  var dims = _.vectorAdapter.from([ 2, 2 ]);
  var got = _.Matrix.FromScalarForReading( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.dimsEffective, [ 2, 2 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - VectorAdapter, routine fromLongLrangeAndStride';
  var dims = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 2, 0, 2, 0 ], 1, 2, 2 );
  var got = _.Matrix.FromScalarForReading( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.dimsEffective, [ 2, 2 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix.FromScalarForReading() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.FromScalarForReading( 3, [ 2, 1 ], 3 ) );

  test.case = 'wrong type of scalar';
  test.shouldThrowErrorSync( () => _.Matrix.FromScalarForReading( [ 1 ], [ 2, 1 ] ) );
  test.shouldThrowErrorSync( () => _.Matrix.FromScalarForReading( 'a', [ 2, 1 ] ) );

  test.case = 'wrong type of dims';
  test.shouldThrowErrorSync( () => _.Matrix.FromScalarForReading( 3, null ) );
  test.shouldThrowErrorSync( () => _.Matrix.FromScalarForReading( 3, { 1 : 2 } ) );
}

//

function FromSrcNullChangeDimsLength( test )
{
  test.open( '2D' );

  test.case = 'dims - [ Infinity, Infinity ]';
  var got = _.Matrix.From( null, [ Infinity, Infinity ] );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0 ]';
  var got = _.Matrix.From( null, [ 0, 0 ] );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'dims - [ 1, 1 ]';
  var got = _.Matrix.From( null, [ 1, 1 ] );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.strides, [ 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - [ 3, 2 ]';
  var got = _.Matrix.From( null, [ 3, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - [ 2, 0 ]';
  var got = _.Matrix.From( null, [ 2, 0 ] );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 0 ] );
  test.identical( got.strides, [ 1, 2 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - [ 0, 2 ]';
  var got = _.Matrix.From( null, [ 0, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 2 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'dims - [ Infinity, 2 ]';
  var got = _.Matrix.From( null, [ 0, 0 ] );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'dims - [ 2, Infinity ]';
  var got = _.Matrix.From( null, [ 0, 0 ] );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 1, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.close( '2D' );

  /* - */

  test.open( '3D' );

  test.case = 'dims - [ Infinity, Infinity, Infinity ]';
  var got = _.Matrix.From( null, [ Infinity, Infinity, Infinity ] );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ Infinity, Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0, 1 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0, 0 ]';
  var got = _.Matrix.From( null, [ 0, 0, 0 ] );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0, 0 ] );
  test.identical( got.strides, [ 1, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0, 0 ] );

  test.case = 'dims - [ 1, 1, 1 ]';
  var got = _.Matrix.From( null, [ 1, 1, 1 ] );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ 1, 1, 1 ] );
  test.identical( got.strides, [ 1, 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - [ 2, 3, 4 ]';
  var got = _.Matrix.From( null, [ 2, 3, 4 ] );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 24 ) );
  test.identical( got.dims, [ 2, 3, 4 ] );
  test.identical( got.strides, [ 1, 2, 6 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6 ] );

  test.case = 'dims - [ 0, 3, 4 ]';
  var got = _.Matrix.From( null, [ 0, 3, 4 ] );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 3, 4 ] );
  test.identical( got.strides, [ 1, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0, 0 ] );

  test.case = 'dims - [ 2, 0, 4 ]';
  var got = _.Matrix.From( null, [ 2, 0, 4 ] );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 0, 4 ] );
  test.identical( got.strides, [ 1, 2, 0 ] );
  test.identical( got.stridesEffective, [ 1, 2, 0 ] );

  test.case = 'dims - [ 2, 3, 0 ]';
  var got = _.Matrix.From( null, [ 2, 3, 0 ] );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 3, 0 ] );
  test.identical( got.strides, [ 1, 2, 6 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6 ] );

  test.case = 'dims - [ Infinity, 3, 4 ]';
  var got = _.Matrix.From( null, [ Infinity, 3, 4 ] );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 12 ) );
  test.identical( got.dims, [ Infinity, 3, 4 ] );
  test.identical( got.strides, [ 0, 1, 3 ] );
  test.identical( got.stridesEffective, [ 0, 1, 3 ] );

  test.case = 'dims - [ 2, Infinity, 4 ]';
  var got = _.Matrix.From( null, [ 2, Infinity, 4 ] );
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 8 ) );
  test.identical( got.dims, [ 2, Infinity, 4 ] );
  test.identical( got.strides, [ 1, 0, 2 ] );
  test.identical( got.stridesEffective, [ 1, 0, 2 ] );

  test.case = 'dims - [ 2, 3, Infinity ]';
  var got = _.Matrix.From( null, [ 2, 3, Infinity ] );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 2, 3, Infinity ] );
  test.identical( got.strides, [ 1, 2, 6 ] );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.close( '3D' );

  /* - */

  test.open( '4D' );

  test.case = 'dims - [ Infinity, Infinity, Infinity, Infinity ]';
  var got = _.Matrix.From( null, [ Infinity, Infinity, Infinity, Infinity ] );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ Infinity, Infinity, Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0, 1, 1 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0, 0, 0 ]';
  var got = _.Matrix.From( null, [ 0, 0, 0, 0 ] );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0, 0, 0 ] );
  test.identical( got.strides, [ 1, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0, 0, 0 ] );

  test.case = 'dims - [ 1, 1, 1, 1 ]';
  var got = _.Matrix.From( null, [ 1, 1, 1, 1 ] );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 1 ) );
  test.identical( got.dims, [ 1, 1, 1, 1 ] );
  test.identical( got.strides, [ 1, 1, 1, 1 ] );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - [ 2, 3, 4, 5 ]';
  var got = _.Matrix.From( null, [ 2, 3, 4, 5 ] );
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 120 ) );
  test.identical( got.dims, [ 2, 3, 4, 5 ] );
  test.identical( got.strides, [ 1, 2, 6, 24 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6, 24 ] );

  test.case = 'dims - [ 0, 3, 4, 5 ]';
  var got = _.Matrix.From( null, [ 0, 3, 4, 5 ] );
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 3, 4, 5 ] );
  test.identical( got.strides, [ 1, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 0, 0, 0 ] );

  test.case = 'dims - [ 2, 0, 4, 5 ]';
  var got = _.Matrix.From( null, [ 2, 0, 4, 5 ] );
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 0, 4, 5 ] );
  test.identical( got.strides, [ 1, 2, 0, 0 ] );
  test.identical( got.stridesEffective, [ 1, 2, 0, 0 ] );

  test.case = 'dims - [ 2, 3, 0, 5 ]';
  var got = _.Matrix.From( null, [ 2, 3, 0, 5 ] );
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 3, 0, 5 ] );
  test.identical( got.strides, [ 1, 2, 6, 0 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6, 0 ] );

  test.case = 'dims - [ 2, 3, 4, 0 ]';
  var got = _.Matrix.From( null, [ 2, 3, 4, 0 ] );
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 3, 4, 0 ] );
  test.identical( got.strides, [ 1, 2, 6, 24 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6, 24 ] );

  test.case = 'dims - [ Infinity, 3, 4, 5 ]';
  var got = _.Matrix.From( null, [ Infinity, 3, 4, 5 ] );
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 60 ) );
  test.identical( got.dims, [ Infinity, 3, 4, 5 ] );
  test.identical( got.strides, [ 0, 1, 3, 12 ] );
  test.identical( got.stridesEffective, [ 0, 1, 3, 12 ] );

  test.case = 'dims - [ 2, Infinity, 4, 5 ]';
  var got = _.Matrix.From( null, [ 2, Infinity, 4, 5 ] );
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 40 ) );
  test.identical( got.dims, [ 2, Infinity, 4, 5 ] );
  test.identical( got.strides, [ 1, 0, 2, 8 ] );
  test.identical( got.stridesEffective, [ 1, 0, 2, 8 ] );

  test.case = 'dims - [ 2, 3, Infinity, 5 ]';
  var got = _.Matrix.From( null, [ 2, 3, Infinity, 5 ] );
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 30 ) );
  test.identical( got.dims, [ 2, 3, Infinity, 5 ] );
  test.identical( got.strides, [ 1, 2, 6, 6 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6, 6 ] );

  test.case = 'dims - [ 2, 3, 4, Infinity ]';
  var got = _.Matrix.From( null, [ 2, 3, 4, Infinity ] );
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make( 24 ) );
  test.identical( got.dims, [ 2, 3, 4, Infinity ] );
  test.identical( got.strides, [ 1, 2, 6, 24 ] );
  test.identical( got.stridesEffective, [ 1, 2, 6 ] );

  test.close( '4D' );
}

//

function FromExperiment( test )
{
  test.case = 'imitation of use result.hasShape';
  var dims = [ 3, 2, Infinity ];
  var got = _.Matrix.From( null, dims );
  test.is( got.hasShape( dims ) );
  test.identical( got.dimsEffective, dims ); // analog of previous test check
}

FromExperiment.experimental = 1;
FromExperiment.description =
`
The test routine shows as static routine From makes new matrix.
The field 'dimsEffective' shows effective shape of the resulted matrix but not
the real shape.

So, if we make the matrix with some dimensions, we shold check the provided dimensions
with dimensions of the matrix.
`
//


function FromSrcNullChangeDimsType( test )
{
  test.case = 'dims - Array';
  var got = _.Matrix.From( null, [ 3, 2 ] );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - Unroll';
  var got = _.Matrix.From( null,  _.unrollMake([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - ArgumentsArray';
  var got = _.Matrix.From( null,  _.argumentsArrayMake([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - U8x';
  var got = _.Matrix.From( null,  new U8x([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - I16x';
  var got = _.Matrix.From( null,  new I16x([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - F32x';
  var got = _.Matrix.From( null,  new F32x([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - F64x';
  var got = _.Matrix.From( null,  new F64x([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - avector';
  var got = _.Matrix.From( null,  _.avector.make([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - VectorAdapter';
  var got = _.Matrix.From( null,  _.vectorAdapter.from([ 3, 2 ]) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - VectorAdapter, routine fromLongLrangeAndStride';
  var got = _.Matrix.From( null,  _.vectorAdapter.fromLongLrangeAndStride( [ 1, 2, 3, 1, 2 ], 2, 2, 2 ) );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 6 ) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 1, 3 ] );
  test.identical( got.stridesEffective, [ 1, 3 ] );
}

//

function FromSrcMatrix( test )
{
  test.case = 'routine Make';
  var src = _.Matrix.Make([ 2, 2 ]);
  var got = _.Matrix.From( src );
  var exp = _.Matrix.Make([ 2, 2 ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine MakeSquare';
  var src = _.Matrix.MakeSquare
  ([
    1, -2,
    3, -4,
  ]);
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeSquare
  ([
    1, -2,
    3, -4,
  ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine MakeZero';
  var src = _.Matrix.MakeZero([ 2, 2 ]);
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeZero([ 2, 2 ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine MakeIdentity';
  var src = _.Matrix.MakeIdentity([ 2, 2 ]);
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeIdentity([ 2, 2 ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine MakeIdentity2';
  var src = _.Matrix.MakeIdentity2();
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeIdentity2();
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine MakeIdentity3';
  var src = _.Matrix.MakeIdentity3();
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeIdentity3();
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine MakeIdentity4';
  var src = _.Matrix.MakeIdentity4();
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeIdentity4();
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine MakeDiagonal';
  var src = _.Matrix.MakeDiagonal([ 1, -2, 3 ]);
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeDiagonal([ 1, -2, 3 ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine MakeSimilar';
  var matrix = _.Matrix.Make([ 2, 2 ]).copy
  ([
     1, -2,
    -3,  4
  ]);
  var src = _.Matrix.MakeSimilar( matrix );
  var got = _.Matrix.From( src );
  var exp = _.Matrix.Make([ 2, 2 ]).copy
  ([
     1, -2,
    -3,  4
  ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'method makeSimilar';
  var matrix = _.Matrix.Make([ 2, 2 ]).copy
  ([
     1, -2,
    -3,  4
  ]);
  var src = matrix.makeSimilar( matrix );
  var got = _.Matrix.From( src );
  var exp = _.Matrix.Make([ 2, 2 ]).copy
  ([
     1, -2,
    -3,  4
  ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine MakeLine';
  var src = _.Matrix.MakeLine
  ({
    buffer : [ 1, -2, 3 ],
    dimension : 0,
    zeroing : 0,
  });
  var got = _.Matrix.From( src );
  var exp = _.Matrix.Make([ 3, 1 ]).copy
  ([
     1,
    -2,
     3,
  ]);
  test.equivalent( got, exp );
  test.is( got === src );

  test.case = 'routine MakeCol';
  var src = _.Matrix.MakeCol([ 1, -2, 3 ]);
  var got = _.Matrix.From( src );
  var exp = _.Matrix.Make([ 3, 1 ]).copy
  ([
     1,
    -2,
     3,
  ]);
  test.equivalent( got, exp );
  test.is( got === src );

  test.case = 'routine MakeColZeroed';
  var src = _.Matrix.MakeColZeroed([ 1, -2, 3 ]);
  var got = _.Matrix.From( src );
  var exp = _.Matrix.Make([ 3, 1 ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine MakeRow';
  var src = _.Matrix.MakeRow([ 1, -2, 3 ]);
  var got = _.Matrix.From( src );
  var exp = _.Matrix.Make([ 1, 3 ]).copy([ 1, -2, 3 ]);
  test.equivalent( got, exp );
  test.is( got === src );

  test.case = 'routine MakeRowZeroed';
  var src = _.Matrix.MakeRowZeroed([ 1, -2, 3 ]);
  var got = _.Matrix.From( src );
  var exp = _.Matrix.Make([ 1, 3 ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine FromVector';
  var src = _.Matrix.FromVector([ 1, -2, 3 ]);
  var got = _.Matrix.From( src );
  var exp = _.Matrix.Make([ 3, 1 ]).copy
  ([
     1,
    -2,
     3
  ]);
  test.equivalent( got, exp );
  test.is( got === src );

  test.case = 'routine FromScalar';
  var src = _.Matrix.FromScalar( 1, [ 2, 2 ] );
  var got = _.Matrix.From( src );
  var exp = _.Matrix.Make([ 2, 2 ]).copy
  ([
    1, 1,
    1, 1,
  ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine FromScalarForReading';
  var src = _.Matrix.FromScalarForReading( 1, [ 2, 2 ] );
  var got = _.Matrix.From( src );
  var exp = _.Matrix.Make([ 2, 2 ]).copy
  ([
    1, 1,
    1, 1,
  ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine From';
  var src = _.Matrix.From( null, [ 2, 2 ] );
  var got = _.Matrix.From( src );
  var exp = _.Matrix.Make([ 2, 2 ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine FromForReading';
  var src = _.Matrix.FromForReading( 1, [ 2, 2 ] );
  var got = _.Matrix.From( src );
  var exp = _.Matrix.Make([ 2, 2 ]).copy
  ([
    1, 1,
    1, 1,
  ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine FromTransformations';
  var dst = _.Matrix.Make([ 4, 4 ]);
  var position = [ 1, 2, 3 ];
  var quaternion = [ 1, 0, 0, 0 ];
  var scale = [ 1, 1, 1 ];
  var src = _.Matrix.FromTransformations( dst, position, quaternion, scale );
  var got = _.Matrix.From( src );
  var exp = _.Matrix.Make([ 4, 4 ]).copy
  ([
    1, 0, 0, 1,
    0, 1, 0, 2,
    0, 0, 1, 3,
    0, 0, 0, 1,
  ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'method fromTransformations';
  var matrix = _.Matrix.Make([ 4, 4 ]);
  var position = [ 1, 2, 3 ];
  var quaternion = [ 1, 0, 0, 0 ];
  var scale = [ 1, 1, 1 ];
  var src = matrix.fromTransformations( position, quaternion, scale );
  var got = _.Matrix.From( src );
  var exp = _.Matrix.Make([ 4, 4 ]).copy
  ([
    1, 0, 0, 1,
    0, 1, 0, 2,
    0, 0, 1, 3,
    0, 0, 0, 1,
  ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'method fromQuat';
  var matrix = _.Matrix.MakeSquare
  ([
    1, 2, 3, 1,
    0, 4, 5, 1,
    0, 0, 6, 1,
    0, 0, 6, 1,
  ]);
  var quaternion = [ 1, 0, 0, 0 ];
  var src = matrix.fromQuat( quaternion );
  var got = _.Matrix.From( src );
  var exp = _.Matrix.Make([ 4, 4 ]).copy
  ([
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1,
  ]);
  test.equivalent( got, exp );
  test.is( got === src );

  test.case = 'method fromQuatWithScale';
  var matrix = _.Matrix.MakeSquare
  ([
    1, 2, 3, 1,
    0, 4, 5, 1,
    0, 0, 6, 1,
    0, 0, 6, 1,
  ]);
  var quaternion = [ 0, 0, 1, 1 ];
  var src = matrix.fromQuatWithScale( quaternion );
  var got = _.Matrix.From( src );
  var exp = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0.000, -1.414,  0.000,  0.000,
    1.414,  0.000,  0.000,  0.000,
    0.000,  0.000,  1.414,  0.000,
    0.000,  0.000,  0.000,  1.000,

  ]);
  test.equivalent( got, exp );
  test.is( got === src );

  test.case = 'method fromAxisAndAngle';
  var matrix = _.Matrix.MakeSquare
  ([
    1, 2, 3,
    0, 4, 5,
    0, 0, 6,
  ]);
  var axis = [ 1, 4, 5 ];
  var src = matrix.fromAxisAndAngle( axis, 30 );
  var got = _.Matrix.From( src );
  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
     1.000,   8.323,   0.277,
    -1.557,  13.686,  17.903,
     8.181,  15.927,  21.298,
  ]);
  test.equivalent( got, exp );
  test.is( got === src );

  test.case = 'method fromAxisAndAngleWithScale';
  var matrix = _.Matrix.MakeSquare
  ([
    1, 2, 3,
    0, 4, 5,
    0, 0, 6,
  ]);
  var axis = [ 1, 4, 5 ];
  var src = matrix.fromAxisAndAngleWithScale( axis, 30 );
  var got = _.Matrix.From( src );
  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
     1.130,  5.462,  -3.300,
    -4.418,  3.088,   3.598,
     4.605,  1.622,   4.262,
  ]);
  test.equivalent( got, exp );
  test.is( got === src );
}

FromSrcMatrix.accuracy = 1e-3;

//

function FromSrcScalarChangeDimsLength( test )
{
  test.open( '2D' );

  test.case = 'dims - [ Infinity, Infinity ]';
  var got = _.Matrix.From( 3, [ Infinity, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ Infinity, Infinity ] );
  test.identical( got.dimsEffective, [ 1, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0 ]';
  var got = _.Matrix.From( 3, [ 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.dimsEffective, [ 0, 0 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'dims - [ 1, 1 ]';
  var got = _.Matrix.From( 3, [ 1, 1 ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.dimsEffective, [ 1, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - [ 3, 2 ]';
  var got = _.Matrix.From( 3, [ 3, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 3, 3, 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.dimsEffective, [ 3, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 3 ] );

  test.case = 'dims - [ 2, 0 ]';
  var got = _.Matrix.From( 3, [ 2, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 0 ] );
  test.identical( got.dimsEffective, [ 2, 0 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - [ 0, 2 ]';
  var got = _.Matrix.From( 3, [ 0, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 2 ] );
  test.identical( got.dimsEffective, [ 0, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'dims - [ Infinity, 2 ]';
  var got = _.Matrix.From( 3, [ 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.dimsEffective, [ 0, 0 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.case = 'dims - [ 2, Infinity ]';
  var got = _.Matrix.From( 3, [ 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.dimsEffective, [ 0, 0 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0 ] );

  test.close( '2D' );

  /* - */

  test.open( '3D' );

  test.case = 'dims - [ Infinity, Infinity, Infinity ]';
  var got = _.Matrix.From( 3, [ Infinity, Infinity, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ Infinity, Infinity, Infinity ] );
  test.identical( got.dimsEffective, [ 1, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0, 0 ]';
  var got = _.Matrix.From( 3, [ 0, 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0, 0 ] );
  test.identical( got.dimsEffective, [ 0, 0, 0 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0, 0 ] );

  test.case = 'dims - [ 1, 1, 1 ]';
  var got = _.Matrix.From( 3, [ 1, 1, 1 ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 1, 1, 1 ] );
  test.identical( got.dimsEffective, [ 1, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - [ 2, 3, 4 ]';
  var got = _.Matrix.From( 3, [ 2, 3, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3 ] ) );
  test.identical( got.dims, [ 2, 3, 4 ] );
  test.identical( got.dimsEffective, [ 2, 3, 4 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2, 6 ] );

  test.case = 'dims - [ 0, 3, 4 ]';
  var got = _.Matrix.From( 3, [ 0, 3, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 3, 4 ] );
  test.identical( got.dimsEffective, [ 0, 3, 4 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0, 0 ] );

  test.case = 'dims - [ 2, 0, 4 ]';
  var got = _.Matrix.From( 3, [ 2, 0, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 0, 4 ] );
  test.identical( got.dimsEffective, [ 2, 0, 4 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2, 0 ] );

  test.case = 'dims - [ 2, 3, 0 ]';
  var got = _.Matrix.From( 3, [ 2, 3, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 3, 0 ] );
  test.identical( got.dimsEffective, [ 2, 3, 0 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2, 6 ] );

  test.case = 'dims - [ Infinity, 3, 4 ]';
  var got = _.Matrix.From( 3, [ Infinity, 3, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make([ 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ Infinity, 3, 4 ] );
  test.identical( got.dimsEffective, [ 1, 3, 4 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 0, 1, 3 ] );

  test.case = 'dims - [ 2, Infinity, 4 ]';
  var got = _.Matrix.From( 3, [ 2, Infinity, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make([ 3, 3, 3, 3, 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 2, Infinity, 4 ] );
  test.identical( got.dimsEffective, [ 2, 1, 4 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0, 2 ] );

  test.case = 'dims - [ 2, 3, Infinity ]';
  var got = _.Matrix.From( 3, [ 2, 3, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3, 3, 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 2, 3, Infinity ] );
  test.identical( got.dimsEffective, [ 2, 3 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.close( '3D' );

  /* - */

  test.open( '4D' );

  test.case = 'dims - [ Infinity, Infinity, Infinity, Infinity ]';
  var got = _.Matrix.From( 3, [ Infinity, Infinity, Infinity, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ Infinity, Infinity, Infinity, Infinity ] );
  test.identical( got.dimsEffective, [ 1, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0, 0, 0 ]';
  var got = _.Matrix.From( 3, [ 0, 0, 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 0, 0, 0 ] );
  test.identical( got.dimsEffective, [ 0, 0, 0, 0 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0, 0, 0 ] );

  test.case = 'dims - [ 1, 1, 1, 1 ]';
  var got = _.Matrix.From( 3, [ 1, 1, 1, 1 ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 1, 1, 1, 1 ] );
  test.identical( got.dimsEffective, [ 1, 1 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 1 ] );

  test.case = 'dims - [ 2, 3, 4, 2 ]';
  var got = _.Matrix.From( 3, [ 2, 3, 4, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
    3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
  ]));
  test.identical( got.dims, [ 2, 3, 4, 2 ] );
  test.identical( got.dimsEffective, [ 2, 3, 4, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2, 6, 24 ] );

  test.case = 'dims - [ 0, 3, 4, 5 ]';
  var got = _.Matrix.From( 3, [ 0, 3, 4, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 0, 3, 4, 5 ] );
  test.identical( got.dimsEffective, [ 0, 3, 4, 5 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0, 0, 0 ] );

  test.case = 'dims - [ 2, 0, 4, 5 ]';
  var got = _.Matrix.From( 3, [ 2, 0, 4, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 0, 4, 5 ] );
  test.identical( got.dimsEffective, [ 2, 0, 4, 5 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2, 0, 0 ] );

  test.case = 'dims - [ 2, 3, 0, 5 ]';
  var got = _.Matrix.From( 3, [ 2, 3, 0, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 3, 0, 5 ] );
  test.identical( got.dimsEffective, [ 2, 3, 0, 5 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2, 6, 0 ] );

  test.case = 'dims - [ 2, 3, 4, 0 ]';
  var got = _.Matrix.From( 3, [ 2, 3, 4, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make( 0 ) );
  test.identical( got.dims, [ 2, 3, 4, 0 ] );
  test.identical( got.dimsEffective, [ 2, 3, 4, 0 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2, 6, 24 ] );

  test.case = 'dims - [ Infinity, 3, 4, 2 ]';
  var got = _.Matrix.From( 3, [ Infinity, 3, 4, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
    3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
  ]));
  test.identical( got.dims, [ Infinity, 3, 4, 2 ] );
  test.identical( got.dimsEffective, [ 1, 3, 4, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 0, 1, 3, 12 ] );

  test.case = 'dims - [ 2, Infinity, 4, 2 ]';
  var got = _.Matrix.From( 3, [ 2, Infinity, 4, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    3, 3, 3, 3, 3, 3, 3, 3,
    3, 3, 3, 3, 3, 3, 3, 3,
  ]));
  test.identical( got.dims, [ 2, Infinity, 4, 2 ] );
  test.identical( got.dimsEffective, [ 2, 1, 4, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 0, 2, 8 ] );

  test.case = 'dims - [ 2, 3, Infinity, 2 ]';
  var got = _.Matrix.From( 3, [ 2, 3, Infinity, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    3, 3, 3, 3, 3, 3,
    3, 3, 3, 3, 3, 3
  ]));
  test.identical( got.dims, [ 2, 3, Infinity, 2 ] );
  test.identical( got.dimsEffective, [ 2, 3, 1, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2, 6, 6 ] );

  test.case = 'dims - [ 2, 3, 4, Infinity ]';
  var got = _.Matrix.From( 3, [ 2, 3, 4, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make
  ([
    3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
  ]));
  test.identical( got.dims, [ 2, 3, 4, Infinity ] );
  test.identical( got.dimsEffective, [ 2, 3, 4 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2, 6 ] );

  test.close( '4D' );
}

//

function FromSrcScalarChangeDimsType( test )
{
  test.case = 'dims - Array';
  var dims = [ 2, 2 ];
  var got = _.Matrix.From( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.dimsEffective, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - Unroll';
  var dims = _.unrollMake([ 2, 2 ]);
  var got = _.Matrix.From( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.dimsEffective, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - ArgumentsArray';
  var dims = _.argumentsArrayMake([ 2, 2 ]);
  var got = _.Matrix.From( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.dimsEffective, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - BufferTyped, U8x';
  var dims = new U8x([ 2, 2 ]);
  var got = _.Matrix.From( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.dimsEffective, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - BufferTyped, I16x';
  var dims = new I16x([ 2, 2 ]);
  var got = _.Matrix.From( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.dimsEffective, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - BufferTyped, F32x';
  var dims = new F32x([ 2, 2 ]);
  var got = _.Matrix.From( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.dimsEffective, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - BufferTyped, F64x';
  var dims = new F64x([ 2, 2 ]);
  var got = _.Matrix.From( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.dimsEffective, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - avector';
  var dims = _.avector.make([ 2, 2 ]);
  var got = _.Matrix.From( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.dimsEffective, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - VectorAdapter';
  var dims = _.vectorAdapter.from([ 2, 2 ]);
  var got = _.Matrix.From( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.dimsEffective, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );

  test.case = 'dims - VectorAdapter, routine fromLongLrangeAndStride';
  var dims = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 2, 0, 2, 0 ], 1, 2, 2 );
  var got = _.Matrix.From( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3, 3, 3, 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.dimsEffective, [ 2, 2 ] );
  test.identical( got.strides, null );
  test.identical( got.stridesEffective, [ 1, 2 ] );
}

//

function FromSrcVector( test )
{
  test.open( 'src is a VectorAdapter' );

  test.case = 'routine make';
  var src = _.vectorAdapter.make([ 1, 2, 3 ]);
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine makeFilling';
  var src = _.vectorAdapter.makeFilling( 3, 5 );
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeCol
  ([
    5,
    5,
    5,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine from';
  var src = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromLong';
  var src = _.vectorAdapter.fromLong([ 1, 2, 3 ]);
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromLongLrange';
  var src = _.vectorAdapter.fromLongLrange( [ 0, 1, 2, 3, 4 ], 1, 3 );
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromLongWithStride';
  var src = _.vectorAdapter.fromLongWithStride( [ 0, 1, 2, 3, 4 ], 2 );
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeCol
  ([
    0,
    2,
    4,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromLongLrangeAndStride';
  var src = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 2, 3, 4, 5, 6 ], 1, 3, 2 );
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    3,
    5,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromNumber, number';
  var src = _.vectorAdapter.fromNumber( 5, 3 );
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeCol
  ([
    5,
    5,
    5,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer !== src._vectorBuffer );

  test.case = 'routine fromMaybeNumber, number';
  var src = _.vectorAdapter.fromMaybeNumber( 5, 3 );
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeCol
  ([
    5,
    5,
    5,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer !== src._vectorBuffer );

  test.case = 'routine fromMaybeNumber, Long';
  var src = _.vectorAdapter.fromMaybeNumber( [ 1, 2, 3 ], 3 );
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.close( 'src is a VectorAdapter' );

  /* - */

  test.open( 'src is a Long' );

  test.case = 'Array';
  var src = [ 1, 2, 3 ];
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'Unroll';
  var src = _.unrollMake([ 1, 2, 3 ]);
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'ArgumentsArray';
  var src = _.argumentsArrayMake([ 1, 2, 3 ]);
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'BufferTyped, U8x';
  var src = new U8x([ 1, 2, 3 ]);
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'BufferTyped, I16x';
  var src = new I16x([ 1, 2, 3 ]);
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'BufferTyped, F32x';
  var src = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'BufferTyped, F64x';
  var src = new F64x([ 1, 2, 3 ]);
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'avector';
  var src = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.From( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.close( 'src is a Long' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix.From() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.From( null, [ 2, 1 ], 2 ) );

  test.case = 'wrong type of dims';
  test.shouldThrowErrorSync( () => _.Matrix.From( null, null ) );
  test.shouldThrowErrorSync( () => _.Matrix.From( 2, { a : 1 } ) );

  test.case = 'src is null or number, dims is not long';
  test.shouldThrowErrorSync( () => _.Matrix.From( null ) );
  test.shouldThrowErrorSync( () => _.Matrix.From( null, undefined ) );
  test.shouldThrowErrorSync( () => _.Matrix.From( 2, undefined ) );

  test.case = 'src is vector, dims not undefined';
  test.shouldThrowErrorSync( () => _.Matrix.From( [ 1, 2, 3 ], [ 1, 3 ] ) );

  test.case = 'src is a Matrix, dims and matrix dims is different';
  test.shouldThrowErrorSync( () => _.Matrix.From( _.Matrix.Make([ 2, 2 ]), [ 1, 3 ] ) );
}

//

function FromForReadingSrcMatrix( test )
{
  test.case = 'routine Make';
  var src = _.Matrix.Make([ 2, 2 ]);
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.Make([ 2, 2 ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine MakeSquare';
  var src = _.Matrix.MakeSquare
  ([
    1, -2,
    3, -4,
  ]);
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeSquare
  ([
    1, -2,
    3, -4,
  ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine MakeZero';
  var src = _.Matrix.MakeZero([ 2, 2 ]);
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeZero([ 2, 2 ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine MakeIdentity';
  var src = _.Matrix.MakeIdentity([ 2, 2 ]);
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeIdentity([ 2, 2 ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine MakeIdentity2';
  var src = _.Matrix.MakeIdentity2();
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeIdentity2();
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine MakeIdentity3';
  var src = _.Matrix.MakeIdentity3();
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeIdentity3();
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine MakeIdentity4';
  var src = _.Matrix.MakeIdentity4();
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeIdentity4();
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine MakeDiagonal';
  var src = _.Matrix.MakeDiagonal([ 1, -2, 3 ]);
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeDiagonal([ 1, -2, 3 ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine MakeSimilar';
  var matrix = _.Matrix.Make([ 2, 2 ]).copy
  ([
     1, -2,
    -3,  4
  ]);
  var src = _.Matrix.MakeSimilar( matrix );
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.Make([ 2, 2 ]).copy
  ([
     1, -2,
    -3,  4
  ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'method makeSimilar';
  var matrix = _.Matrix.Make([ 2, 2 ]).copy
  ([
     1, -2,
    -3,  4
  ]);
  var src = matrix.makeSimilar( matrix );
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.Make([ 2, 2 ]).copy
  ([
     1, -2,
    -3,  4
  ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine MakeLine';
  var src = _.Matrix.MakeLine
  ({
    buffer : [ 1, -2, 3 ],
    dimension : 0,
    zeroing : 0,
  });
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.Make([ 3, 1 ]).copy
  ([
     1,
    -2,
     3,
  ]);
  test.equivalent( got, exp );
  test.is( got === src );

  test.case = 'routine MakeCol';
  var src = _.Matrix.MakeCol([ 1, -2, 3 ]);
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.Make([ 3, 1 ]).copy
  ([
     1,
    -2,
     3,
  ]);
  test.equivalent( got, exp );
  test.is( got === src );

  test.case = 'routine MakeColZeroed';
  var src = _.Matrix.MakeColZeroed([ 1, -2, 3 ]);
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.Make([ 3, 1 ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine MakeRow';
  var src = _.Matrix.MakeRow([ 1, -2, 3 ]);
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.Make([ 1, 3 ]).copy([ 1, -2, 3 ]);
  test.equivalent( got, exp );
  test.is( got === src );

  test.case = 'routine MakeRowZeroed';
  var src = _.Matrix.MakeRowZeroed([ 1, -2, 3 ]);
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.Make([ 1, 3 ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine FromVector';
  var src = _.Matrix.FromVector([ 1, -2, 3 ]);
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.Make([ 3, 1 ]).copy
  ([
     1,
    -2,
     3
  ]);
  test.equivalent( got, exp );
  test.is( got === src );

  test.case = 'routine FromScalar';
  var src = _.Matrix.FromScalar( 1, [ 2, 2 ] );
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.Make([ 2, 2 ]).copy
  ([
    1, 1,
    1, 1,
  ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine FromScalarForReading';
  var src = _.Matrix.FromScalarForReading( 1, [ 2, 2 ] );
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.Make([ 2, 2 ]).copy
  ([
    1, 1,
    1, 1,
  ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine From';
  var src = _.Matrix.From( null, [ 2, 2 ] );
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.Make([ 2, 2 ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine FromForReading';
  var src = _.Matrix.FromForReading( 1, [ 2, 2 ] );
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.Make([ 2, 2 ]).copy
  ([
    1, 1,
    1, 1,
  ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'routine FromTransformations';
  var dst = _.Matrix.Make([ 4, 4 ]);
  var position = [ 1, 2, 3 ];
  var quaternion = [ 1, 0, 0, 0 ];
  var scale = [ 1, 1, 1 ];
  var src = _.Matrix.FromTransformations( dst, position, quaternion, scale );
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.Make([ 4, 4 ]).copy
  ([
    1, 0, 0, 1,
    0, 1, 0, 2,
    0, 0, 1, 3,
    0, 0, 0, 1,
  ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'method fromTransformations';
  var matrix = _.Matrix.Make([ 4, 4 ]);
  var position = [ 1, 2, 3 ];
  var quaternion = [ 1, 0, 0, 0 ];
  var scale = [ 1, 1, 1 ];
  var src = matrix.fromTransformations( position, quaternion, scale );
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.Make([ 4, 4 ]).copy
  ([
    1, 0, 0, 1,
    0, 1, 0, 2,
    0, 0, 1, 3,
    0, 0, 0, 1,
  ]);
  test.identical( got, exp );
  test.is( got === src );

  test.case = 'method fromQuat';
  var matrix = _.Matrix.MakeSquare
  ([
    1, 2, 3, 1,
    0, 4, 5, 1,
    0, 0, 6, 1,
    0, 0, 6, 1,
  ]);
  var quaternion = [ 1, 0, 0, 0 ];
  var src = matrix.fromQuat( quaternion );
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.Make([ 4, 4 ]).copy
  ([
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1,
  ]);
  test.equivalent( got, exp );
  test.is( got === src );

  test.case = 'method fromQuatWithScale';
  var matrix = _.Matrix.MakeSquare
  ([
    1, 2, 3, 1,
    0, 4, 5, 1,
    0, 0, 6, 1,
    0, 0, 6, 1,
  ]);
  var quaternion = [ 0, 0, 1, 1 ];
  var src = matrix.fromQuatWithScale( quaternion );
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0.000, -1.414,  0.000,  0.000,
    1.414,  0.000,  0.000,  0.000,
    0.000,  0.000,  1.414,  0.000,
    0.000,  0.000,  0.000,  1.000,

  ]);
  test.equivalent( got, exp );
  test.is( got === src );

  test.case = 'method fromAxisAndAngle';
  var matrix = _.Matrix.MakeSquare
  ([
    1, 2, 3,
    0, 4, 5,
    0, 0, 6,
  ]);
  var axis = [ 1, 4, 5 ];
  var src = matrix.fromAxisAndAngle( axis, 30 );
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
     1.000,   8.323,   0.277,
    -1.557,  13.686,  17.903,
     8.181,  15.927,  21.298,
  ]);
  test.equivalent( got, exp );
  test.is( got === src );

  test.case = 'method fromAxisAndAngleWithScale';
  var matrix = _.Matrix.MakeSquare
  ([
    1, 2, 3,
    0, 4, 5,
    0, 0, 6,
  ]);
  var axis = [ 1, 4, 5 ];
  var src = matrix.fromAxisAndAngleWithScale( axis, 30 );
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
     1.130,  5.462,  -3.300,
    -4.418,  3.088,   3.598,
     4.605,  1.622,   4.262,
  ]);
  test.equivalent( got, exp );
  test.is( got === src );
}

FromForReadingSrcMatrix.accuracy = 1e-3;

//

function FromForReadingSrcScalarChangeDimsLength( test )
{
  test.open( '2D' );

  test.case = 'dims - [ Infinity, Infinity ]';
  var got = _.Matrix.FromForReading( 3, [ Infinity, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0 ]';
  var got = _.Matrix.FromForReading( 3, [ 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 1, 1 ]';
  var got = _.Matrix.FromForReading( 3, [ 1, 1 ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 1, 1 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 3, 2 ]';
  var got = _.Matrix.FromForReading( 3, [ 3, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 3, 2 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 2, 0 ]';
  var got = _.Matrix.FromForReading( 3, [ 2, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 0 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 2 ]';
  var got = _.Matrix.FromForReading( 3, [ 0, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 0, 2 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ Infinity, 2 ]';
  var got = _.Matrix.FromForReading( 3, [ 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 2, Infinity ]';
  var got = _.Matrix.FromForReading( 3, [ 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 0, 0 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.close( '2D' );

  /* - */

  test.open( '3D' );

  test.case = 'dims - [ Infinity, Infinity, Infinity ]';
  var got = _.Matrix.FromForReading( 3, [ Infinity, Infinity, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ Infinity, Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0, 0 ]';
  var got = _.Matrix.FromForReading( 3, [ 0, 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 0, 0, 0 ] );
  test.identical( got.strides, [ 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0 ] );

  test.case = 'dims - [ 1, 1, 1 ]';
  var got = _.Matrix.FromForReading( 3, [ 1, 1, 1 ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 1, 1, 1 ] );
  test.identical( got.strides, [ 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 2, 3, 4 ]';
  var got = _.Matrix.FromForReading( 3, [ 2, 3, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 3, 4 ] );
  test.identical( got.strides, [ 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0 ] );

  test.case = 'dims - [ 0, 3, 4 ]';
  var got = _.Matrix.FromForReading( 3, [ 0, 3, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 0, 3, 4 ] );
  test.identical( got.strides, [ 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0 ] );

  test.case = 'dims - [ 2, 0, 4 ]';
  var got = _.Matrix.FromForReading( 3, [ 2, 0, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 0, 4 ] );
  test.identical( got.strides, [ 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0 ] );

  test.case = 'dims - [ 2, 3, 0 ]';
  var got = _.Matrix.FromForReading( 3, [ 2, 3, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 3, 0 ] );
  test.identical( got.strides, [ 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0 ] );

  test.case = 'dims - [ Infinity, 3, 4 ]';
  var got = _.Matrix.FromForReading( 3, [ Infinity, 3, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ Infinity, 3, 4 ] );
  test.identical( got.strides, [ 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0 ] );

  test.case = 'dims - [ 2, Infinity, 4 ]';
  var got = _.Matrix.FromForReading( 3, [ 2, Infinity, 4 ]);
  test.identical( got.length, 4 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, Infinity, 4 ] );
  test.identical( got.strides, [ 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0 ] );

  test.case = 'dims - [ 2, 3, Infinity ]';
  var got = _.Matrix.FromForReading( 3, [ 2, 3, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 3, Infinity ] );
  test.identical( got.strides, [ 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.close( '3D' );

  /* - */

  test.open( '4D' );

  test.case = 'dims - [ Infinity, Infinity, Infinity, Infinity ]';
  var got = _.Matrix.FromForReading( 3, [ Infinity, Infinity, Infinity, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ Infinity, Infinity, Infinity, Infinity ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 0, 0, 0, 0 ]';
  var got = _.Matrix.FromForReading( 3, [ 0, 0, 0, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 0, 0, 0, 0 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0, 0 ] );

  test.case = 'dims - [ 1, 1, 1, 1 ]';
  var got = _.Matrix.FromForReading( 3, [ 1, 1, 1, 1 ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 1, 1, 1, 1 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - [ 2, 3, 4, 2 ]';
  var got = _.Matrix.FromForReading( 3, [ 2, 3, 4, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer,_.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 3, 4, 2 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0, 0 ] );

  test.case = 'dims - [ 0, 3, 4, 5 ]';
  var got = _.Matrix.FromForReading( 3, [ 0, 3, 4, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 0, 3, 4, 5 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0, 0 ] );

  test.case = 'dims - [ 2, 0, 4, 5 ]';
  var got = _.Matrix.FromForReading( 3, [ 2, 0, 4, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 0, 4, 5 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0, 0 ] );

  test.case = 'dims - [ 2, 3, 0, 5 ]';
  var got = _.Matrix.FromForReading( 3, [ 2, 3, 0, 5 ]);
  test.identical( got.length, 5 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 3, 0, 5 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0, 0 ] );

  test.case = 'dims - [ 2, 3, 4, 0 ]';
  var got = _.Matrix.FromForReading( 3, [ 2, 3, 4, 0 ]);
  test.identical( got.length, 0 );
  test.identical( got.buffer, _.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 3, 4, 0 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0, 0 ] );

  test.case = 'dims - [ Infinity, 3, 4, 2 ]';
  var got = _.Matrix.FromForReading( 3, [ Infinity, 3, 4, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer,_.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ Infinity, 3, 4, 2 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0, 0 ] );

  test.case = 'dims - [ 2, Infinity, 4, 2 ]';
  var got = _.Matrix.FromForReading( 3, [ 2, Infinity, 4, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer,_.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, Infinity, 4, 2 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0, 0 ] );

  test.case = 'dims - [ 2, 3, Infinity, 2 ]';
  var got = _.Matrix.FromForReading( 3, [ 2, 3, Infinity, 2 ]);
  test.identical( got.length, 2 );
  test.identical( got.buffer,_.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 3, Infinity, 2 ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0, 0 ] );

  test.case = 'dims - [ 2, 3, 4, Infinity ]';
  var got = _.Matrix.FromForReading( 3, [ 2, 3, 4, Infinity ]);
  test.identical( got.length, 1 );
  test.identical( got.buffer,_.longDescriptor.make([ 3 ]) );
  test.identical( got.dims, [ 2, 3, 4, Infinity ] );
  test.identical( got.strides, [ 0, 0, 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0, 0 ] );

  test.close( '4D' );
}

//

function FromForReadingSrcScalarChangeDimsType( test )
{
  test.case = 'dims - Array';
  var dims = [ 2, 2 ];
  var got = _.Matrix.FromForReading( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - Unroll';
  var dims = _.unrollMake([ 2, 2 ]);
  var got = _.Matrix.FromForReading( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - ArgumentsArray';
  var dims = _.argumentsArrayMake([ 2, 2 ]);
  var got = _.Matrix.FromForReading( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - BufferTyped, U8x';
  var dims = new U8x([ 2, 2 ]);
  var got = _.Matrix.FromForReading( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - BufferTyped, I16x';
  var dims = new I16x([ 2, 2 ]);
  var got = _.Matrix.FromForReading( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - BufferTyped, F32x';
  var dims = new F32x([ 2, 2 ]);
  var got = _.Matrix.FromForReading( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - BufferTyped, F64x';
  var dims = new F64x([ 2, 2 ]);
  var got = _.Matrix.FromForReading( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - avector';
  var dims = _.avector.make([ 2, 2 ]);
  var got = _.Matrix.FromForReading( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - VectorAdapter';
  var dims = _.vectorAdapter.from([ 2, 2 ]);
  var got = _.Matrix.FromForReading( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  test.case = 'dims - VectorAdapter, routine fromLongLrangeAndStride';
  var dims = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 2, 0, 2, 0 ], 1, 2, 2 );
  var got = _.Matrix.FromForReading( 3, dims );
  test.identical( got.length, 2 );
  test.identical( got.buffer, _.longDescriptor.make( [ 3 ]) );
  test.identical( got.dims, [ 2, 2 ] );
  test.identical( got.strides, [ 0, 0 ] );
  test.identical( got.stridesEffective, [ 0, 0 ] );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix.FromForReading() );

  test.case = 'not enough arguments';
  test.shouldThrowErrorSync( () => _.Matrix.FromForReading( 3 ) );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.FromForReading( 3, [ 2, 1 ], 3 ) );

  test.case = 'wrong type of scalar';
  test.shouldThrowErrorSync( () => _.Matrix.FromForReading( [ 1 ], [ 2, 1 ] ) );
  test.shouldThrowErrorSync( () => _.Matrix.FromForReading( 'a', [ 2, 1 ] ) );

  test.case = 'wrong type of dims';
  test.shouldThrowErrorSync( () => _.Matrix.FromForReading( 3, null ) );
  test.shouldThrowErrorSync( () => _.Matrix.FromForReading( 3, { 1 : 2 } ) );
}

//

function FromForReadingSrcVector( test )
{
  test.open( 'src is a VectorAdapter' );

  test.case = 'routine make';
  var src = _.vectorAdapter.make([ 1, 2, 3 ]);
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine makeFilling';
  var src = _.vectorAdapter.makeFilling( 3, 5 );
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeCol
  ([
    5,
    5,
    5,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine from';
  var src = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromLong';
  var src = _.vectorAdapter.fromLong([ 1, 2, 3 ]);
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromLongLrange';
  var src = _.vectorAdapter.fromLongLrange( [ 0, 1, 2, 3, 4 ], 1, 3 );
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromLongWithStride';
  var src = _.vectorAdapter.fromLongWithStride( [ 0, 1, 2, 3, 4 ], 2 );
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeCol
  ([
    0,
    2,
    4,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromLongLrangeAndStride';
  var src = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 2, 3, 4, 5, 6 ], 1, 3, 2 );
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    3,
    5,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromNumber, number';
  var src = _.vectorAdapter.fromNumber( 5, 3 );
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeCol
  ([
    5,
    5,
    5,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer !== src._vectorBuffer );

  test.case = 'routine fromMaybeNumber, number';
  var src = _.vectorAdapter.fromMaybeNumber( 5, 3 );
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeCol
  ([
    5,
    5,
    5,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer !== src._vectorBuffer );

  test.case = 'routine fromMaybeNumber, Long';
  var src = _.vectorAdapter.fromMaybeNumber( [ 1, 2, 3 ], 3 );
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.close( 'src is a VectorAdapter' );

  /* - */

  test.open( 'src is a Long' );

  test.case = 'Array';
  var src = [ 1, 2, 3 ];
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'Unroll';
  var src = _.unrollMake([ 1, 2, 3 ]);
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'ArgumentsArray';
  var src = _.argumentsArrayMake([ 1, 2, 3 ]);
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'BufferTyped, U8x';
  var src = new U8x([ 1, 2, 3 ]);
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'BufferTyped, I16x';
  var src = new I16x([ 1, 2, 3 ]);
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'BufferTyped, F32x';
  var src = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'BufferTyped, F64x';
  var src = new F64x([ 1, 2, 3 ]);
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'avector';
  var src = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.FromForReading( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.close( 'src is a Long' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix.FromForReading() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.FromForReading( null, [ 2, 1 ], 2 ) );

  test.case = 'wrong type of dims';
  test.shouldThrowErrorSync( () => _.Matrix.FromForReading( null, null ) );
  test.shouldThrowErrorSync( () => _.Matrix.FromForReading( 2, { a : 1 } ) );

  test.case = 'src is null or number, dims is not long';
  test.shouldThrowErrorSync( () => _.Matrix.FromForReading( null ) );
  test.shouldThrowErrorSync( () => _.Matrix.FromForReading( null, undefined ) );
  test.shouldThrowErrorSync( () => _.Matrix.FromForReading( 2, undefined ) );

  test.case = 'src is vector, dims not undefined';
  test.shouldThrowErrorSync( () => _.Matrix.FromForReading( [ 1, 2, 3 ], [ 1, 3 ] ) );

  test.case = 'src is a Matrix, dims and matrix dims is different';
  test.shouldThrowErrorSync( () => _.Matrix.FromForReading( _.Matrix.Make([ 2, 2 ]), [ 1, 3 ] ) );
}

//

function ColFrom( test )
{
  test.case = 'src - column matrix';
  var src = _.Matrix.Make([ 3, 1 ]).copy
  ([
    1,
    2,
    3
  ]);
  var got = _.Matrix.ColFrom( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got === src );

  /* */

  test.case = 'src - number';
  var src = 5;
  var got = _.Matrix.ColFrom( src );
  var exp = _.Matrix.MakeCol
  ([
    5,
  ]);
  test.equivalent( got, exp );
  test.is( got !== src );

  /* - */

  test.open( 'src is a VectorAdapter' );

  test.case = 'routine make';
  var src = _.vectorAdapter.make([ 1, 2, 3 ]);
  var got = _.Matrix.ColFrom( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine makeFilling';
  var src = _.vectorAdapter.makeFilling( 3, 5 );
  var got = _.Matrix.ColFrom( src );
  var exp = _.Matrix.MakeCol
  ([
    5,
    5,
    5,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine from';
  var src = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.ColFrom( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromLong';
  var src = _.vectorAdapter.fromLong([ 1, 2, 3 ]);
  var got = _.Matrix.ColFrom( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromLongLrange';
  var src = _.vectorAdapter.fromLongLrange( [ 0, 1, 2, 3, 4 ], 1, 3 );
  var got = _.Matrix.ColFrom( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromLongWithStride';
  var src = _.vectorAdapter.fromLongWithStride( [ 0, 1, 2, 3, 4 ], 2 );
  var got = _.Matrix.ColFrom( src );
  var exp = _.Matrix.MakeCol
  ([
    0,
    2,
    4,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromLongLrangeAndStride';
  var src = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 2, 3, 4, 5, 6 ], 1, 3, 2 );
  var got = _.Matrix.ColFrom( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    3,
    5,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromNumber, number';
  var src = _.vectorAdapter.fromNumber( 5, 3 );
  var got = _.Matrix.ColFrom( src );
  var exp = _.Matrix.MakeCol
  ([
    5,
    5,
    5,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromMaybeNumber, number';
  var src = _.vectorAdapter.fromMaybeNumber( 5, 3 );
  var got = _.Matrix.ColFrom( src );
  var exp = _.Matrix.MakeCol
  ([
    5,
    5,
    5,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromMaybeNumber, Long';
  var src = _.vectorAdapter.fromMaybeNumber( [ 1, 2, 3 ], 3 );
  var got = _.Matrix.ColFrom( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.close( 'src is a VectorAdapter' );

  /* - */

  test.open( 'src is a Long' );

  test.case = 'Array';
  var src = [ 1, 2, 3 ];
  var got = _.Matrix.ColFrom( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'Unroll';
  var src = _.unrollMake([ 1, 2, 3 ]);
  var got = _.Matrix.ColFrom( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'ArgumentsArray';
  var src = _.argumentsArrayMake([ 1, 2, 3 ]);
  var got = _.Matrix.ColFrom( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer !== src );

  test.case = 'BufferTyped, U8x';
  var src = new U8x([ 1, 2, 3 ]);
  var got = _.Matrix.ColFrom( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'BufferTyped, I16x';
  var src = new I16x([ 1, 2, 3 ]);
  var got = _.Matrix.ColFrom( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'BufferTyped, F32x';
  var src = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix.ColFrom( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'BufferTyped, F64x';
  var src = new F64x([ 1, 2, 3 ]);
  var got = _.Matrix.ColFrom( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'avector';
  var src = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.ColFrom( src );
  var exp = _.Matrix.MakeCol
  ([
    1,
    2,
    3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.close( 'src is a Long' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix.ColFrom() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.ColFrom( [ 1, 2, 3 ], [ 1, 2 ] ) );

  test.case = 'wrong type of src';
  test.shouldThrowErrorSync( () => _.Matrix.ColFrom( null ) );
  test.shouldThrowErrorSync( () => _.Matrix.ColFrom( {} ) );

  test.case = 'src is not flat matrix';
  test.shouldThrowErrorSync( () => _.Matrix.ColFrom( _.Matrix.Make([ 3, 1, 2 ]) ) );

  test.case = 'src is not column matrix';
  test.shouldThrowErrorSync( () => _.Matrix.ColFrom( _.Matrix.Make([ 1, 3 ]) ) );
}

//

function RowFrom( test )
{
  test.case = 'src - column matrix';
  var src = _.Matrix.Make([ 1, 3 ]).copy
  ([
    1, 2, 3
  ]);
  var got = _.Matrix.RowFrom( src );
  var exp = _.Matrix.MakeRow
  ([
    1, 2, 3,
  ]);
  test.equivalent( got, exp );
  test.is( got === src );

  /* */

  test.case = 'src - number';
  var src = 5;
  var got = _.Matrix.RowFrom( src );
  var exp = _.Matrix.MakeRow
  ([
    5,
  ]);
  test.equivalent( got, exp );
  test.is( got !== src );

  /* - */

  test.open( 'src is a VectorAdapter' );

  test.case = 'routine make';
  var src = _.vectorAdapter.make([ 1, 2, 3 ]);
  var got = _.Matrix.RowFrom( src );
  var exp = _.Matrix.MakeRow
  ([
    1, 2, 3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine makeFilling';
  var src = _.vectorAdapter.makeFilling( 3, 5 );
  var got = _.Matrix.RowFrom( src );
  var exp = _.Matrix.MakeRow
  ([
    5, 5, 5,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine from';
  var src = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = _.Matrix.RowFrom( src );
  var exp = _.Matrix.MakeRow
  ([
    1, 2, 3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromLong';
  var src = _.vectorAdapter.fromLong([ 1, 2, 3 ]);
  var got = _.Matrix.RowFrom( src );
  var exp = _.Matrix.MakeRow
  ([
    1, 2, 3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromLongLrange';
  var src = _.vectorAdapter.fromLongLrange( [ 0, 1, 2, 3, 4 ], 1, 3 );
  var got = _.Matrix.RowFrom( src );
  var exp = _.Matrix.MakeRow
  ([
    1, 2, 3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromLongWithStride';
  var src = _.vectorAdapter.fromLongWithStride( [ 0, 1, 2, 3, 4 ], 2 );
  var got = _.Matrix.RowFrom( src );
  var exp = _.Matrix.MakeRow
  ([
    0, 2, 4,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromLongLrangeAndStride';
  var src = _.vectorAdapter.fromLongLrangeAndStride( [ 0, 1, 2, 3, 4, 5, 6 ], 1, 3, 2 );
  var got = _.Matrix.RowFrom( src );
  var exp = _.Matrix.MakeRow
  ([
    1, 3, 5,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromNumber, number';
  var src = _.vectorAdapter.fromNumber( 5, 3 );
  var got = _.Matrix.RowFrom( src );
  var exp = _.Matrix.MakeRow
  ([
    5, 5, 5,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromMaybeNumber, number';
  var src = _.vectorAdapter.fromMaybeNumber( 5, 3 );
  var got = _.Matrix.RowFrom( src );
  var exp = _.Matrix.MakeRow
  ([
    5, 5, 5,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.case = 'routine fromMaybeNumber, Long';
  var src = _.vectorAdapter.fromMaybeNumber( [ 1, 2, 3 ], 3 );
  var got = _.Matrix.RowFrom( src );
  var exp = _.Matrix.MakeRow
  ([
    1, 2, 3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src._vectorBuffer );

  test.close( 'src is a VectorAdapter' );

  /* - */

  test.open( 'src is a Long' );

  test.case = 'Array';
  var src = [ 1, 2, 3 ];
  var got = _.Matrix.RowFrom( src );
  var exp = _.Matrix.MakeRow
  ([
    1, 2, 3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'Unroll';
  var src = _.unrollMake([ 1, 2, 3 ]);
  var got = _.Matrix.RowFrom( src );
  var exp = _.Matrix.MakeRow
  ([
    1, 2, 3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'ArgumentsArray';
  var src = _.argumentsArrayMake([ 1, 2, 3 ]);
  var got = _.Matrix.RowFrom( src );
  var exp = _.Matrix.MakeRow
  ([
    1, 2, 3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer !== src );

  test.case = 'BufferTyped, U8x';
  var src = new U8x([ 1, 2, 3 ]);
  var got = _.Matrix.RowFrom( src );
  var exp = _.Matrix.MakeRow
  ([
    1, 2, 3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'BufferTyped, I16x';
  var src = new I16x([ 1, 2, 3 ]);
  var got = _.Matrix.RowFrom( src );
  var exp = _.Matrix.MakeRow
  ([
    1, 2, 3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'BufferTyped, F32x';
  var src = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix.RowFrom( src );
  var exp = _.Matrix.MakeRow
  ([
    1, 2, 3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'BufferTyped, F64x';
  var src = new F64x([ 1, 2, 3 ]);
  var got = _.Matrix.RowFrom( src );
  var exp = _.Matrix.MakeRow
  ([
    1, 2, 3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.case = 'avector';
  var src = _.avector.make([ 1, 2, 3 ]);
  var got = _.Matrix.RowFrom( src );
  var exp = _.Matrix.MakeRow
  ([
    1, 2, 3,
  ]);
  test.equivalent( got, exp );
  test.is( got.buffer === src );

  test.close( 'src is a Long' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix.RowFrom() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.RowFrom( [ 1, 2, 3 ], [ 1, 2 ] ) );

  test.case = 'wrong type of src';
  test.shouldThrowErrorSync( () => _.Matrix.RowFrom( null ) );
  test.shouldThrowErrorSync( () => _.Matrix.RowFrom( {} ) );

  test.case = 'src is not flat matrix';
  test.shouldThrowErrorSync( () => _.Matrix.RowFrom( _.Matrix.Make([ 3, 1, 2 ]) ) );

  test.case = 'src is not column matrix';
  test.shouldThrowErrorSync( () => _.Matrix.RowFrom( _.Matrix.Make([ 3, 1 ]) ) );
}

//

function make( test )
{
  let context = this;

  var o = Object.create( null );
  o.arrayMake = function arrayMake( src )
  {
    if( arguments.length === 0 )
    src = [];
    for( var i = 0 ; i < this.offset ; i++ )
    src.unshift( i );
    return new I32x( src );
  }
  o.vec = function vec( src )
  {
    return ivec( src );
  }

  o.offset = 0;
  _make( test, o );

  o.offset = undefined;
  _make( test, o );

  o.offset = 13;
  _make( test, o );

  /* */

  function _make( test, o )
  {

    /* */

    test.case = 'matrix with dimensions without stride, transposing';

    var m = new _.Matrix
    ({
      inputRowMajor : 1,
      dims : [ 2, 3 ],
      offset : o.offset,
      buffer : o.arrayMake
      ([
        1, 2, 3,
        4, 5, 6,
      ]),
    });

    logger.log( 'm\n' + _.toStr( m ) );

    test.identical( m.size, 24 );
    test.identical( m.sizeOfElement, 8 );
    test.identical( m.sizeOfCol, 8 );
    test.identical( m.sizeOfRow, 12 );
    test.identical( m.dims, [ 2, 3 ] );
    test.identical( m.length, 3 );

    test.identical( m.stridesEffective, [ 3, 1 ] );
    test.identical( m.strideOfElement, 1 );
    test.identical( m.strideOfCol, 1 );
    test.identical( m.strideInCol, 3 );
    test.identical( m.strideOfRow, 3 );
    test.identical( m.strideInRow, 1 );

    var r1 = m.rowGet( 1 );
    var r2 = m.lineGet( 1, 1 );
    var c1 = m.colGet( 2 );
    var c2 = m.lineGet( 0, 2 );
    var e = m.eGet( 2 );
    var a1 = m.scalarFlatGet( 5 );
    var a2 = m.scalarGet([ 1, 1 ]);

    test.identical( r1, o.vec([ 4, 5, 6 ]) );
    test.identical( r1, r2 );
    test.identical( c1, o.vec([ 3, 6 ]) );
    test.identical( c1, c2 );
    test.identical( e, o.vec([ 3, 6 ]) );
    test.identical( a1, 6 );
    test.identical( a2, 5 );
    test.identical( m.reduceToSumScalarWise(), 21 );
    test.identical( m.reduceToProductScalarWise(), 720 );

    /* */

    test.case = 'matrix with dimensions without stride, non transposing';

    var m = new _.Matrix
    ({
      inputRowMajor : 0,
      dims : [ 2, 3 ],
      offset : o.offset,
      buffer : o.arrayMake
      ([
        1, 2, 3,
        4, 5, 6,
      ]),
    });

    logger.log( 'm\n' + _.toStr( m ) );

    test.identical( m.size, 24 );
    test.identical( m.sizeOfElement, 8 );
    test.identical( m.sizeOfCol, 8 );
    test.identical( m.sizeOfRow, 12 );
    test.identical( m.dims, [ 2, 3 ] );
    test.identical( m.length, 3 );

    test.identical( m.stridesEffective, [ 1, 2 ] );
    test.identical( m.strideOfElement, 2 );
    test.identical( m.strideOfCol, 2 );
    test.identical( m.strideInCol, 1 );
    test.identical( m.strideOfRow, 1 );
    test.identical( m.strideInRow, 2 );

    var r1 = m.rowGet( 1 );
    var r2 = m.lineGet( 1, 1 );
    var c1 = m.colGet( 2 );
    var c2 = m.lineGet( 0, 2 );
    var e = m.eGet( 2 );
    var a1 = m.scalarFlatGet( 5 );
    var a2 = m.scalarGet([ 1, 1 ]);

    test.identical( r1, o.vec([ 2, 4, 6 ]) );
    test.identical( r1, r2 );
    test.identical( c1, o.vec([ 5, 6 ]) );
    test.identical( c1, c2 );
    test.identical( e, o.vec([ 5, 6 ]) );
    test.identical( a1, 6 );
    test.identical( a2, 4 );
    test.identical( m.reduceToSumScalarWise(), 21 );
    test.identical( m.reduceToProductScalarWise(), 720 );

    /* */

    test.case = 'column with dimensions without stride, transposing';

    var m = new _.Matrix
    ({
      inputRowMajor : 1,
      dims : [ 3, 1 ],
      offset : o.offset,
      buffer : o.arrayMake
      ([
        1,
        2,
        3
      ]),
    });

    logger.log( 'm\n' + _.toStr( m ) );

    test.identical( m.size, 12 );
    test.identical( m.sizeOfElement, 12 );
    test.identical( m.sizeOfCol, 12 );
    test.identical( m.sizeOfRow, 4 );
    test.identical( m.dims, [ 3, 1 ] );
    test.identical( m.length, 1 );

    test.identical( m.stridesEffective, [ 1, 1 ] );
    test.identical( m.strideOfElement, 1 );
    test.identical( m.strideOfCol, 1 );
    test.identical( m.strideInCol, 1 );
    test.identical( m.strideOfRow, 1 );
    test.identical( m.strideInRow, 1 );

    var r1 = m.rowGet( 1 );
    var r2 = m.lineGet( 1, 1 );
    var c1 = m.colGet( 0 );
    var c2 = m.lineGet( 0, 0 );
    var e = m.eGet( 0 );
    var a1 = m.scalarFlatGet( 2 );
    var a2 = m.scalarGet([ 1, 0 ]);

    test.identical( r1, o.vec([ 2 ]) );
    test.identical( r1, r2 );
    test.identical( c1, o.vec([ 1, 2, 3 ]) );
    test.identical( c1, c2 );
    test.identical( e, o.vec([ 1, 2, 3 ]) );
    test.identical( a1, 3 );
    test.identical( a2, 2 );
    test.identical( m.reduceToSumScalarWise(), 6 );
    test.identical( m.reduceToProductScalarWise(), 6 );

    /* */

    test.case = 'column with dimensions without stride, non transposing';

    var m = new _.Matrix
    ({
      inputRowMajor : 0,
      dims : [ 3, 1 ],
      offset : o.offset,
      buffer : o.arrayMake
      ([
        1,
        2,
        3
      ]),
    });

    logger.log( 'm\n' + _.toStr( m ) );

    test.identical( m.size, 12 );
    test.identical( m.sizeOfElement, 12 );
    test.identical( m.sizeOfCol, 12 );
    test.identical( m.sizeOfRow, 4 );
    test.identical( m.dims, [ 3, 1 ] );
    test.identical( m.length, 1 );

    test.identical( m.stridesEffective, [ 1, 3 ] );
    test.identical( m.strideOfElement, 3 );
    test.identical( m.strideOfCol, 3 );
    test.identical( m.strideInCol, 1 );
    test.identical( m.strideOfRow, 1 );
    test.identical( m.strideInRow, 3 );

    var r1 = m.rowGet( 1 );
    var r2 = m.lineGet( 1, 1 );
    var c1 = m.colGet( 0 );
    var c2 = m.lineGet( 0, 0 );
    var e = m.eGet( 0 );
    var a1 = m.scalarFlatGet( 2 );
    var a2 = m.scalarGet([ 1, 0 ]);

    test.identical( r1, o.vec([ 2 ]) );
    test.identical( r1, r2 );
    test.identical( c1, o.vec([ 1, 2, 3 ]) );
    test.identical( c1, c2 );
    test.identical( e, o.vec([ 1, 2, 3 ]) );
    test.identical( a1, 3 );
    test.identical( a2, 2 );
    test.identical( m.reduceToSumScalarWise(), 6 );
    test.identical( m.reduceToProductScalarWise(), 6 );

    /* */

    test.case = 'construct empty matrix with dims defined';

    var m = new _.Matrix({ buffer : o.arrayMake(), offset : o.offset, inputRowMajor : 0, dims : [ 1, 0 ] });

    logger.log( 'm\n' + _.toStr( m ) );

    test.identical( m.size, 0 );
    test.identical( m.sizeOfElement, 4 );
    test.identical( m.sizeOfCol, 4 );
    test.identical( m.sizeOfRow, 0 );
    test.identical( m.dims, [ 1, 0 ] );
    test.identical( m.length, 0 );

    test.identical( m.stridesEffective, [ 1, 1 ] );
    test.identical( m.strideOfElement, 1 );
    test.identical( m.strideOfCol, 1 );
    test.identical( m.strideInCol, 1 );
    test.identical( m.strideOfRow, 1 );
    test.identical( m.strideInRow, 1 );

    var r1 = m.rowGet( 0 );
    var r2 = m.lineGet( 1, 0 );

    console.log( r1.toStr() );
    console.log( o.vec([]) );

    test.identical( r1, o.vec([]) );
    test.identical( r1, r2 );
    test.identical( m.reduceToSumScalarWise(), 0 );
    test.identical( m.reduceToProductScalarWise(), 1 );

    /* */

    test.case = 'construct empty matrix, inputRowMajor : 0';

    var m = new _.Matrix({ buffer : o.arrayMake(), offset : o.offset, inputRowMajor : 0 });

    logger.log( 'm\n' + _.toStr( m ) );

    test.identical( m.size, 0 );
    test.identical( m.sizeOfElement, 0 );
    test.identical( m.sizeOfCol, 0 );
    test.identical( m.sizeOfRow, 4 );
    test.identical( m.dims, [ 0, 1 ] );
    test.identical( m.length, 1 );

    test.identical( m.stridesEffective, [ 1, 0 ] );
    test.identical( m.strideOfElement, 0 );
    test.identical( m.strideOfCol, 0 );
    test.identical( m.strideInCol, 1 );
    test.identical( m.strideOfRow, 1 );
    test.identical( m.strideInRow, 0 );

    // test.identical( m.size, 0 );
    // test.identical( m.sizeOfElement, 4 );
    // test.identical( m.sizeOfCol, 4 );
    // test.identical( m.sizeOfRow, 0 );
    // test.identical( m.dims, [ 1, 0 ] );
    // test.identical( m.length, 0 );
    //
    // test.identical( m.stridesEffective, [ 1, 1 ] );
    // test.identical( m.strideOfElement, 1 );
    // test.identical( m.strideOfCol, 1 );
    // test.identical( m.strideInCol, 1 );
    // test.identical( m.strideOfRow, 1 );
    // test.identical( m.strideInRow, 1 );

    var r1 = m.colGet( 0 );
    var r2 = m.lineGet( 0, 0 );

    console.log( r1.toStr() );
    console.log( o.vec([]) );

    test.identical( r1, o.vec([]) );
    test.identical( r1, r2 );
    test.identical( m.reduceToSumScalarWise(), 0 );
    test.identical( m.reduceToProductScalarWise(), 1 );

    if( Config.debug )
    {

      test.shouldThrowErrorSync( () => m.rowGet( 0 ) );
      test.shouldThrowErrorSync( () => m.lineGet( 1, 0 ) );
      // test.shouldThrowErrorSync( () => m.eGet( 0 ) );

      test.shouldThrowErrorSync( () => m.rowGet( 1 ) );
      test.shouldThrowErrorSync( () => m.colGet( 1 ) );
      test.shouldThrowErrorSync( () => m.eGet( 1 ) );
      test.shouldThrowErrorSync( () => m.scalarFlatGet( 1 ) );
      test.shouldThrowErrorSync( () => m.scalarGet( 1 ) );

    }

    /* */

    test.case = 'construct empty matrix with long column, non transposing';

    function checkEmptyMatrixWithLongColNonTransposing( m )
    {

      test.identical( m.size, 0 );
      test.identical( m.sizeOfElement, 12 );
      test.identical( m.sizeOfCol, 12 );
      test.identical( m.sizeOfRow, 0 );
      test.identical( m.dims, [ 3, 0 ] );
      // test.identical( m.breadth, [ 3 ] );
      test.identical( m.length, 0 );

      test.identical( m.stridesEffective, [ 1, 3 ] );
      test.identical( m.strideOfElement, 3 );
      test.identical( m.strideOfCol, 3 );
      test.identical( m.strideInCol, 1 );
      test.identical( m.strideOfRow, 1 );
      test.identical( m.strideInRow, 3 );

      var r1 = m.rowGet( 0 );
      var r2 = m.rowGet( 1 );
      var r3 = m.lineGet( 1, 0 );

      console.log( r1.toStr() );
      console.log( o.vec([]) );

      test.identical( r1, _.vad.from( new m.buffer.constructor([]) ) );
      test.identical( r1, r2 );
      test.identical( r1, r3 );
      test.identical( m.reduceToSumScalarWise(), 0 );
      test.identical( m.reduceToProductScalarWise(), 1 );
      test.identical( m.buffer.length-m.offset, 0 );

      if( Config.debug )
      {
        test.shouldThrowErrorSync( () => m.colGet( 0 ) );
        test.shouldThrowErrorSync( () => m.lineGet( 0, 0 ) );
        test.shouldThrowErrorSync( () => m.eGet( 0 ) );
        test.shouldThrowErrorSync( () => m.colGet( 1 ) );
        test.shouldThrowErrorSync( () => m.eGet( 1 ) );
        test.shouldThrowErrorSync( () => m.scalarFlatGet( 1 ) );
        test.shouldThrowErrorSync( () => m.scalarGet( 1 ) );
      }

    }

    var m = new _.Matrix
    ({
      buffer : o.arrayMake(),
      offset : o.offset,
      inputRowMajor : 0,
      dims : [ 3, 0 ],
    });
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongColNonTransposing( m );

    var m = _.Matrix.Make([ 3, 0 ]);
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongColNonTransposing( m );
    test.identical( m.strides, [ 1, 3 ] );
    test.identical( m.stridesEffective, [ 1, 3 ] );

    test.description = 'change by empty buffer of empty matrix with long column, non transposing';

    m.buffer = new I32x();
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongColNonTransposing( m );

    test.description = 'change by empty buffer of empty matrix with long column, non transposing, with copy';

    m.copy({ buffer : o.arrayMake(), offset : o.offset, inputRowMajor : 0 });
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongColNonTransposing( m );

    test.description = 'change buffer of empty matrix with long column, non transposing';

    m.copy({ buffer : o.arrayMake([ 1, 2, 3 ]), offset : o.offset, inputRowMajor : 0, dims : [ 3, 1 ] /* yyy */ });
    logger.log( 'm\n' + _.toStr( m ) );

    test.identical( m.size, 12 );
    test.identical( m.sizeOfElement, 12 );
    test.identical( m.sizeOfCol, 12 );
    test.identical( m.sizeOfRow, 4 );
    test.identical( m.dims, [ 3, 1 ] );
    test.identical( m.length, 1 );

    test.identical( m.stridesEffective, [ 1, 3 ] );
    test.identical( m.strideOfElement, 3 );
    test.identical( m.strideOfCol, 3 );
    test.identical( m.strideInCol, 1 );
    test.identical( m.strideOfRow, 1 );
    test.identical( m.strideInRow, 3 );

    var r1 = m.rowGet( 1 );
    var r2 = m.lineGet( 1, 1 );
    var c1 = m.colGet( 0 );
    var c2 = m.lineGet( 0, 0 );
    var e = m.eGet( 0 );
    var a1 = m.scalarFlatGet( 1 );
    var a2 = m.scalarGet([ 1, 0 ]);

    test.identical( r1, o.vec([ 2 ]) );
    test.identical( r1, r2 );
    test.identical( c1, o.vec([ 1, 2, 3 ]) );
    test.identical( c1, c2 );
    test.identical( e, o.vec([ 1, 2, 3 ]) );
    test.identical( a1, 2 );
    test.identical( a2, 2 );
    test.identical( m.reduceToSumScalarWise(), 6 );
    test.identical( m.reduceToProductScalarWise(), 6 );

    test.description = 'change buffer of not empty matrix with long column, non transposing';

    m.copy({ buffer : o.arrayMake([ 1, 2, 3, 4, 5, 6 ]), offset : o.offset, inputRowMajor : 0, dims : [ 3, 2 ] /* yyy */ });
    logger.log( 'm\n' + _.toStr( m ) );

    test.identical( m.size, 24 );
    test.identical( m.sizeOfElement, 12 );
    test.identical( m.sizeOfCol, 12 );
    test.identical( m.sizeOfRow, 8 );
    test.identical( m.dims, [ 3, 2 ] );
    test.identical( m.length, 2 );

    test.identical( m.stridesEffective, [ 1, 3 ] );
    test.identical( m.strideOfElement, 3 );
    test.identical( m.strideOfCol, 3 );
    test.identical( m.strideInCol, 1 );
    test.identical( m.strideOfRow, 1 );
    test.identical( m.strideInRow, 3 );

    var r1 = m.rowGet( 1 );
    var r2 = m.lineGet( 1, 1 );
    var c1 = m.colGet( 0 );
    var c2 = m.lineGet( 0, 0 );
    var e = m.eGet( 0 );
    var a1 = m.scalarFlatGet( 1 );
    var a2 = m.scalarGet([ 1, 0 ]);

    test.identical( r1, o.vec([ 2, 5 ]) );
    test.identical( r1, r2 );
    test.identical( c1, o.vec([ 1, 2, 3 ]) );
    test.identical( c1, c2 );
    test.identical( e, o.vec([ 1, 2, 3 ]) );
    test.identical( a1, 2 );
    test.identical( a2, 2 );
    test.identical( m.reduceToSumScalarWise(), 21 );
    test.identical( m.reduceToProductScalarWise(), 720 );

    /* */

    test.case = 'construct empty matrix with long column, transposing';

    function checkEmptyMatrixWithLongColTransposing( m, bufferSet )
    {

      test.identical( m.size, 0 );
      test.identical( m.sizeOfElement, 12 );
      test.identical( m.sizeOfCol, 12 );
      test.identical( m.sizeOfRow, 0 );
      test.identical( m.dims, [ 3, 0 ] );
      test.identical( m.length, 0 );

      if( bufferSet )
      {
        test.identical( m.stridesEffective, [ 1, 3 ] );
        test.identical( m.strideOfElement, 3 );
        test.identical( m.strideOfCol, 3 );
        test.identical( m.strideInCol, 1 );
        test.identical( m.strideOfRow, 1 );
        test.identical( m.strideInRow, 3 );
      }
      else
      {
        test.identical( m.stridesEffective, [ 0, 1 ] );
        test.identical( m.strideOfElement, 1 );
        test.identical( m.strideOfCol, 1 );
        test.identical( m.strideInCol, 0 );
        test.identical( m.strideOfRow, 0 );
        test.identical( m.strideInRow, 1 );
      }

      var r1 = m.rowGet( 0 );
      var r2 = m.rowGet( 1 );
      var r3 = m.lineGet( 1, 0 );

      console.log( r1.toStr() );
      console.log( o.vec([]) );

      test.identical( r1, o.vec([]) );
      test.identical( r1, r2 );
      test.identical( r1, r3 );
      test.identical( m.reduceToSumScalarWise(), 0 );
      test.identical( m.reduceToProductScalarWise(), 1 );
      test.identical( m.buffer.length-m.offset, 0 );

      if( Config.debug )
      {
        test.shouldThrowErrorSync( () => m.colGet( 0 ) );
        test.shouldThrowErrorSync( () => m.lineGet( 0, 0 ) );
        test.shouldThrowErrorSync( () => m.eGet( 0 ) );
        test.shouldThrowErrorSync( () => m.colGet( 1 ) );
        test.shouldThrowErrorSync( () => m.eGet( 1 ) );
        test.shouldThrowErrorSync( () => m.scalarFlatGet( 1 ) );
        test.shouldThrowErrorSync( () => m.scalarGet( 1 ) );
      }

    }

    var m = new _.Matrix
    ({
      buffer : o.arrayMake(),
      offset : o.offset,
      inputRowMajor : 1,
      dims : [ 3, 0 ],
    });

    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongColTransposing( m );

    /* */

    test.description = 'change by empty buffer of empty matrix with long column, transposing';

    var m = new _.Matrix
    ({
      buffer : new I32x(),
      inputRowMajor : 1,
      dims : [ 3, 0 ],
    });
    m.buffer = new I32x();
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongColTransposing( m, 1 );

    /* */

    test.description = 'change by empty buffer of empty matrix with long column, transposing, by copy';

    m.copy({ buffer : o.arrayMake([]), offset : o.offset, inputRowMajor : 1 });
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongColTransposing( m );

    /* */

    test.description = 'change buffer of empty matrix with long column, transposing';

    m.copy({ buffer : o.arrayMake([ 1, 2, 3 ]), offset : o.offset, inputRowMajor : 1, dims : [ 3, 1 ] /* yyy */ });
    logger.log( 'm\n' + _.toStr( m ) );

    test.identical( m.size, 12 );
    test.identical( m.sizeOfElement, 12 );
    test.identical( m.sizeOfCol, 12 );
    test.identical( m.sizeOfRow, 4 );
    test.identical( m.dims, [ 3, 1 ] );
    test.identical( m.length, 1 );

    test.identical( m.stridesEffective, [ 1, 1 ] );
    test.identical( m.strideOfElement, 1 );
    test.identical( m.strideOfCol, 1 );
    test.identical( m.strideInCol, 1 );
    test.identical( m.strideOfRow, 1 );
    test.identical( m.strideInRow, 1 );

    var r1 = m.rowGet( 1 );
    var r2 = m.lineGet( 1, 1 );
    var c1 = m.colGet( 0 );
    var c2 = m.lineGet( 0, 0 );
    var e = m.eGet( 0 );
    var a1 = m.scalarFlatGet( 1 );
    var a2 = m.scalarGet([ 1, 0 ]);

    test.identical( r1, o.vec([ 2 ]) );
    test.identical( r1, r2 );
    test.identical( c1, o.vec([ 1, 2, 3 ]) );
    test.identical( c1, c2 );
    test.identical( e, o.vec([ 1, 2, 3 ]) );
    test.identical( a1, 2 );
    test.identical( a2, 2 );
    test.identical( m.reduceToSumScalarWise(), 6 );
    test.identical( m.reduceToProductScalarWise(), 6 );

    test.description = 'change buffer of empty matrix with long column, transposing';

    m.copy({ buffer : o.arrayMake([ 1, 2, 3, 4, 5, 6 ]), offset : o.offset, inputRowMajor : 1, dims : [ 3, 2 ] /* yyy */ });
    logger.log( 'm\n' + _.toStr( m ) );

    test.identical( m.size, 24 );
    test.identical( m.sizeOfElement, 12 );
    test.identical( m.sizeOfCol, 12 );
    test.identical( m.sizeOfRow, 8 );
    test.identical( m.dims, [ 3, 2 ] );
    test.identical( m.length, 2 );

    test.identical( m.stridesEffective, [ 2, 1 ] );
    test.identical( m.strideOfElement, 1 );
    test.identical( m.strideOfCol, 1 );
    test.identical( m.strideInCol, 2 );
    test.identical( m.strideOfRow, 2 );
    test.identical( m.strideInRow, 1 );

    var r1 = m.rowGet( 1 );
    var r2 = m.lineGet( 1, 1 );
    var c1 = m.colGet( 0 );
    var c2 = m.lineGet( 0, 0 );
    var e = m.eGet( 0 );
    var a1 = m.scalarFlatGet( 1 );
    var a2 = m.scalarGet([ 0, 1 ]);

    test.identical( r1, o.vec([ 3, 4 ]) );
    test.identical( r1, r2 );
    test.identical( c1, o.vec([ 1, 3, 5 ]) );
    test.identical( c1, c2 );
    test.identical( e, o.vec([ 1, 3, 5 ]) );
    test.identical( a1, 2 );
    test.identical( a2, 2 );
    test.identical( m.reduceToSumScalarWise(), 21 );
    test.identical( m.reduceToProductScalarWise(), 720 );

    /* */

    test.case = 'construct empty matrix with long row, transposing';

    function checkEmptyMatrixWithLongRowTransposing( m, bufferSet )
    {

      test.identical( m.size, 0 );
      test.identical( m.sizeOfElement, 0 );
      test.identical( m.sizeOfCol, 0 );
      test.identical( m.sizeOfRow, 12 );
      test.identical( m.dims, [ 0, 3 ] );
      test.identical( m.length, 3 );

      if( bufferSet )
      {
        test.identical( m.stridesEffective, [ 1, 0 ] );
        test.identical( m.strideOfElement, 0 );
        test.identical( m.strideOfCol, 0 );
        test.identical( m.strideInCol, 1 );
        test.identical( m.strideOfRow, 1 );
        test.identical( m.strideInRow, 0 );
      }
      else
      {
        test.identical( m.stridesEffective, [ 3, 1 ] );
        test.identical( m.strideOfElement, 1 );
        test.identical( m.strideOfCol, 1 );
        test.identical( m.strideInCol, 3 );
        test.identical( m.strideOfRow, 3 );
        test.identical( m.strideInRow, 1 );
      }

      var c1 = m.colGet( 0 );
      var c2 = m.colGet( 1 );
      var c3 = m.lineGet( 0, 0 );
      var e = m.eGet( 2 );

      test.identical( c1, o.vec([]) );
      test.identical( c1, c2 );
      test.identical( c1, c3 );
      test.identical( e, o.vec([]) );
      test.identical( m.reduceToSumScalarWise(), 0 );
      test.identical( m.reduceToProductScalarWise(), 1 );
      test.identical( m.buffer.length-m.offset, 0 );

      if( Config.debug )
      {

        test.shouldThrowErrorSync( () => m.rowGet( 0 ) );
        test.shouldThrowErrorSync( () => m.lineGet( 1, 0 ) );

        test.shouldThrowErrorSync( () => m.eGet( 3 ) );
        test.shouldThrowErrorSync( () => m.colGet( 3 ) );

        test.shouldThrowErrorSync( () => m.scalarFlatGet( 1 ) );
        test.shouldThrowErrorSync( () => m.scalarGet( 1 ) );

      }

    }

    var m = new _.Matrix
    ({
      buffer : o.arrayMake(),
      offset : o.offset,
      inputRowMajor : 1,
      dims : [ 0, 3 ],
    });
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongRowTransposing( m );

    /* */

    test.case = 'change by empty buffer of empty matrix with long row, transposing';

    var m = new _.Matrix
    ({
      buffer : o.arrayMake(),
      inputRowMajor : 1,
      dims : [ 0, 3 ],
    });

    m.buffer = new I32x();
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongRowTransposing( m, 1 );

    m.copy({ buffer : o.arrayMake([]), offset : o.offset, inputRowMajor : 1 });
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongRowTransposing( m );

    test.description = 'change by non empty buffer of empty matrix with long row, transposing';

    m.copy({ buffer : o.arrayMake([ 1, 2, 3 ]), offset : o.offset, inputRowMajor : 1, dims : [ 1, 3 ] /* yyy */ });
    logger.log( 'm\n' + _.toStr( m ) );

    test.identical( m.size, 12 );
    test.identical( m.sizeOfElement, 4 );
    test.identical( m.sizeOfCol, 4 );
    test.identical( m.sizeOfRow, 12 );
    test.identical( m.dims, [ 1, 3 ] );
    test.identical( m.length, 3 );

    test.identical( m.stridesEffective, [ 3, 1 ] );
    test.identical( m.strideOfElement, 1 );
    test.identical( m.strideOfCol, 1 );
    test.identical( m.strideInCol, 3 );
    test.identical( m.strideOfRow, 3 );
    test.identical( m.strideInRow, 1 );

    var r1 = m.rowGet( 0 );
    var r2 = m.lineGet( 1, 0 );
    var c1 = m.colGet( 1 );
    var c2 = m.lineGet( 0, 1 );
    var e = m.eGet( 1 );
    var a1 = m.scalarFlatGet( 1 );
    var a2 = m.scalarGet([ 0, 1 ]);

    test.identical( r1, o.vec([ 1, 2, 3 ]) );
    test.identical( r1, r2 );
    test.identical( c1, o.vec([ 2 ]) );
    test.identical( c1, c2 );
    test.identical( e, o.vec([ 2 ]) );
    test.identical( a1, 2 );
    test.identical( a2, 2 );
    test.identical( m.reduceToSumScalarWise(), 6 );
    test.identical( m.reduceToProductScalarWise(), 6 );

    test.description = 'change by non empty buffer of non empty matrix with long row, transposing';

    m.copy({ buffer : o.arrayMake([ 1, 2, 3, 4, 5, 6 ]), offset : o.offset, inputRowMajor : 1, dims : [ 2, 3 ] /* yyy */ });
    logger.log( 'm\n' + _.toStr( m ) );

    test.identical( m.size, 24 );
    test.identical( m.sizeOfElement, 8 );
    test.identical( m.sizeOfCol, 8 );
    test.identical( m.sizeOfRow, 12 );
    test.identical( m.dims, [ 2, 3 ] );
    test.identical( m.length, 3 );

    test.identical( m.stridesEffective, [ 3, 1 ] );
    test.identical( m.strideOfElement, 1 );
    test.identical( m.strideOfCol, 1 );
    test.identical( m.strideInCol, 3 );
    test.identical( m.strideOfRow, 3 );
    test.identical( m.strideInRow, 1 );

    var r1 = m.rowGet( 1 );
    var r2 = m.lineGet( 1, 1 );
    var c1 = m.colGet( 1 );
    var c2 = m.lineGet( 0, 1 );
    var e = m.eGet( 1 );
    var a1 = m.scalarFlatGet( 1 );
    var a2 = m.scalarGet([ 0, 1 ]);

    test.identical( r1, o.vec([ 4, 5, 6 ]) );
    test.identical( r1, r2 );
    test.identical( c1, o.vec([ 2, 5 ]) );
    test.identical( c1, c2 );
    test.identical( e, o.vec([ 2, 5 ]) );
    test.identical( a1, 2 );
    test.identical( a2, 2 );
    test.identical( m.reduceToSumScalarWise(), 21 );
    test.identical( m.reduceToProductScalarWise(), 720 );

    /* */

    test.case = 'construct empty matrix with long row, non transposing';

    function checkEmptyMatrixWithLongRowNonTransposing( m )
    {

      test.identical( m.size, 0 );
      test.identical( m.sizeOfElement, 0 );
      test.identical( m.sizeOfCol, 0 );
      test.identical( m.sizeOfRow, 12 );
      test.identical( m.dims, [ 0, 3 ] );
      test.identical( m.length, 3 );

      test.identical( m.stridesEffective, [ 1, 0 ] );
      test.identical( m.strideOfElement, 0 );
      test.identical( m.strideOfCol, 0 );
      test.identical( m.strideInCol, 1 );
      test.identical( m.strideOfRow, 1 );
      test.identical( m.strideInRow, 0 );

      var c1 = m.colGet( 0 );
      var c2 = m.colGet( 1 );
      var c3 = m.lineGet( 0, 0 );
      var e = m.eGet( 2 );

      test.identical( c1, _.vad.from( new m.buffer.constructor([]) ) );
      test.identical( c1, c2 );
      test.identical( c1, c3 );
      test.identical( e, _.vad.from( new m.buffer.constructor([]) ) );
      test.identical( m.reduceToSumScalarWise(), 0 );
      test.identical( m.reduceToProductScalarWise(), 1 );
      test.identical( m.buffer.length-m.offset, 0 );

      if( Config.debug )
      {

        test.shouldThrowErrorSync( () => m.rowGet( 0 ) );
        test.shouldThrowErrorSync( () => m.lineGet( 1, 0 ) );

        test.shouldThrowErrorSync( () => m.eGet( 3 ) );
        test.shouldThrowErrorSync( () => m.colGet( 3 ) );

        test.shouldThrowErrorSync( () => m.scalarFlatGet( 1 ) );
        test.shouldThrowErrorSync( () => m.scalarGet( 1 ) );

      }

    }

    var m = new _.Matrix
    ({
      buffer : o.arrayMake(),
      offset : o.offset,
      inputRowMajor : 0,
      dims : [ 0, 3 ],
    });
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongRowNonTransposing( m );

    var m = _.Matrix.Make([ 0, 3 ]);
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongRowNonTransposing( m );
    test.identical( m.strides, [ 1, 0 ] );
    test.identical( m.stridesEffective, [ 1, 0 ] );

    /* */

    test.case = 'change by empty buffer of empty matrix with long row, non transposing';

    var m = _.Matrix.Make([ 0, 3 ]);
    m.buffer = new I32x();
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongRowNonTransposing( m );

    test.description = 'change by empty buffer of empty matrix with long row, non transposing, by copy';

    m.copy({ buffer : o.arrayMake([]), offset : o.offset, inputRowMajor : 0 });
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongRowNonTransposing( m );

    test.description = 'change by non empty buffer of empty matrix with long row, non transposing';

    m.copy({ buffer : o.arrayMake([ 1, 2, 3 ]), offset : o.offset, inputRowMajor : 0, dims : [ 1, 3 ] /* yyy */ });
    logger.log( 'm\n' + _.toStr( m ) );

    test.identical( m.buffer, o.arrayMake([ 1, 2, 3 ]) );
    test.identical( m.dims, [ 1, 3 ] );
    test.identical( m.dimsEffective, [ 1, 3 ] );
    test.identical( m.strides, null );
    test.identical( m.stridesEffective, [ 1, 1 ] );

    test.identical( m.size, 12 );
    test.identical( m.sizeOfElement, 4 );
    test.identical( m.sizeOfCol, 4 );
    test.identical( m.sizeOfRow, 12 );
    test.identical( m.dims, [ 1, 3 ] );
    test.identical( m.length, 3 );

    test.identical( m.stridesEffective, [ 1, 1 ] );
    test.identical( m.strideOfElement, 1 );
    test.identical( m.strideOfCol, 1 );
    test.identical( m.strideInCol, 1 );
    test.identical( m.strideOfRow, 1 );
    test.identical( m.strideInRow, 1 );

    var r1 = m.rowGet( 0 );
    var r2 = m.lineGet( 1, 0 );
    var c1 = m.colGet( 1 );
    var c2 = m.lineGet( 0, 1 );
    var e = m.eGet( 1 );
    var a1 = m.scalarFlatGet( 1 );
    var a2 = m.scalarGet([ 0, 1 ]);

    test.identical( r1, o.vec([ 1, 2, 3 ]) );
    test.identical( r1, r2 );
    test.identical( c1, o.vec([ 2 ]) );
    test.identical( c1, c2 );
    test.identical( e, o.vec([ 2 ]) );
    test.identical( a1, 2 );
    test.identical( a2, 2 );
    test.identical( m.reduceToSumScalarWise(), 6 );
    test.identical( m.reduceToProductScalarWise(), 6 );

    test.description = 'change by non empty buffer of non empty matrix with long row, non transposing';

    m.copy({ buffer : o.arrayMake([ 1, 2, 3, 4, 5, 6 ]), offset : o.offset, inputRowMajor : 0, dims : [ 2, 3 ] });
    logger.log( 'm\n' + _.toStr( m ) );

    test.identical( m.size, 24 );
    test.identical( m.sizeOfElement, 8 );
    test.identical( m.sizeOfCol, 8 );
    test.identical( m.sizeOfRow, 12 );
    test.identical( m.dims, [ 2, 3 ] );
    test.identical( m.length, 3 );

    test.identical( m.stridesEffective, [ 1, 2 ] );
    test.identical( m.strideOfElement, 2 );
    test.identical( m.strideOfCol, 2 );
    test.identical( m.strideInCol, 1 );
    test.identical( m.strideOfRow, 1 );
    test.identical( m.strideInRow, 2 );

    var r1 = m.rowGet( 0 );
    var r2 = m.lineGet( 1, 0 );
    var c1 = m.colGet( 1 );
    var c2 = m.lineGet( 0, 1 );
    var e = m.eGet( 1 );
    var a1 = m.scalarFlatGet( 1 );
    var a2 = m.scalarGet([ 1, 0 ]);

    test.identical( r1, o.vec([ 1, 3, 5 ]) );
    test.identical( r1, r2 );
    test.identical( c1, o.vec([ 3, 4 ]) );
    test.identical( c1, c2 );
    test.identical( e, o.vec([ 3, 4 ]) );
    test.identical( a1, 2 );
    test.identical( a2, 2 );
    test.identical( m.reduceToSumScalarWise(), 21 );
    test.identical( m.reduceToProductScalarWise(), 720 );

    /* */

    test.case = 'construct matrix with only buffer';

    var m = new _.Matrix
    ({
      buffer : o.arrayMake([ 1, 2, 3 ]),
      offset : o.offset,
      inputRowMajor : 0,
    });
    logger.log( 'm\n' + _.toStr( m ) );


    test.identical( m.scalarsPerMatrix, 3 );
    test.identical( m.size, 12 );
    test.identical( m.sizeOfElement, 12 );
    test.identical( m.sizeOfCol, 12 );
    test.identical( m.sizeOfRow, 4 );
    test.identical( m.dims, [ 3, 1 ] );
    test.identical( m.length, 1 );

    test.identical( m.stridesEffective, [ 1, 3 ] );
    test.identical( m.strideOfElement, 3 );
    test.identical( m.strideOfCol, 3 );
    test.identical( m.strideInCol, 1 );
    test.identical( m.strideOfRow, 1 );
    test.identical( m.strideInRow, 3 );

    var r1 = m.rowGet( 1 );
    var r2 = m.lineGet( 1, 1 );
    var c1 = m.colGet( 0 );
    var c2 = m.lineGet( 0, 0 );
    var e = m.eGet( 0 );
    var a1 = m.scalarFlatGet( 1 );
    var a2 = m.scalarGet([ 1, 0 ]);

    test.identical( r1, o.vec([ 2 ]) );
    test.identical( r1, r2 );
    test.identical( c1, o.vec([ 1, 2, 3 ]) );
    test.identical( c1, c2 );
    test.identical( e, o.vec([ 1, 2, 3 ]) );
    test.identical( a1, 2 );
    test.identical( a2, 2 );
    test.identical( m.reduceToSumScalarWise(), 6 );
    test.identical( m.reduceToProductScalarWise(), 6 );

    /* */

    test.case = 'construct matrix without buffer';

    if( Config.debug )
    {

      test.shouldThrowErrorSync( () => new _.Matrix({ offset : o.offset, }) );

    }

    /* */

    test.case = 'construct matrix with buffer and strides';

    // if( Config.debug )
    // {
    //
    //   var buffer = new I32x
    //   ([
    //     1, 2, 3,
    //     4, 5, 6,
    //   ]);
    //   test.shouldThrowErrorSync( () => new _.Matrix({ buffer, strides : [ 1, 3 ] }) );
    //
    // }

    /* */

    test.case = 'construct empty matrix with dimensions, non transposing';

    var m = new _.Matrix
    ({
      buffer : o.arrayMake(),
      dims : [ 3, 0 ],
      inputRowMajor : 0,
      offset : o.offset,
    });
    logger.log( 'm\n' + _.toStr( m ) );

    test.identical( m.scalarsPerMatrix, 0 );
    test.identical( m.size, 0 );
    test.identical( m.sizeOfElement, 12 );
    test.identical( m.sizeOfCol, 12 );
    test.identical( m.sizeOfRow, 0 );
    test.identical( m.dims, [ 3, 0 ] );
    test.identical( m.length, 0 );

    test.identical( m.stridesEffective, [ 1, 3 ] );
    test.identical( m.strideOfElement, 3 );
    test.identical( m.strideOfCol, 3 );
    test.identical( m.strideInCol, 1 );
    test.identical( m.strideOfRow, 1 );
    test.identical( m.strideInRow, 3 );
    test.identical( m.reduceToSumScalarWise(), 0 );
    test.identical( m.reduceToProductScalarWise(), 1 );

    m.copy({ buffer : o.arrayMake([ 1, 2, 3, 4, 5, 6 ]), offset : o.offset, inputRowMajor : 0, dims : [ 3, 2 ] /* yyy */ });
    logger.log( 'm\n' + _.toStr( m ) );

    test.identical( m.size, 24 );
    test.identical( m.sizeOfElement, 12 );
    test.identical( m.sizeOfCol, 12 );
    test.identical( m.sizeOfRow, 8 );
    test.identical( m.dims, [ 3, 2 ] );
    test.identical( m.length, 2 );

    test.identical( m.stridesEffective, [ 1, 3 ] );
    test.identical( m.strideOfElement, 3 );
    test.identical( m.strideOfCol, 3 );
    test.identical( m.strideInCol, 1 );
    test.identical( m.strideOfRow, 1 );
    test.identical( m.strideInRow, 3 );

    var r1 = m.rowGet( 1 );
    var r2 = m.lineGet( 1, 1 );
    var c1 = m.colGet( 1 );
    var c2 = m.lineGet( 0, 1 );
    var e = m.eGet( 1 );
    var a1 = m.scalarFlatGet( 4 );
    var a2 = m.scalarGet([ 1, 1 ]);

    test.identical( r1, o.vec([ 2, 5 ]) );
    test.identical( r1, r2 );
    test.identical( c1, o.vec([ 4, 5, 6 ]) );
    test.identical( c1, c2 );
    test.identical( e, o.vec([ 4, 5, 6 ]) );
    test.identical( a1, 5 );
    test.identical( a2, 5 );
    test.identical( m.reduceToSumScalarWise(), 21 );
    test.identical( m.reduceToProductScalarWise(), 720 );

    /* */

    test.case = 'construct empty matrix with dimensions, transposing';

    var m = new _.Matrix
    ({
      buffer : o.arrayMake(),
      dims : [ 3, 0 ],
      inputRowMajor : 1,
      offset : o.offset,
    });
    logger.log( 'm\n' + _.toStr( m ) );

    test.identical( m.size, 0 );
    test.identical( m.sizeOfElement, 12 );
    test.identical( m.sizeOfCol, 12 );
    test.identical( m.sizeOfRow, 0 );
    test.identical( m.dims, [ 3, 0 ] );
    test.identical( m.length, 0 );

    test.identical( m.stridesEffective, [ 0, 1 ] );
    test.identical( m.strideOfElement, 1 );
    test.identical( m.strideOfCol, 1 );
    test.identical( m.strideInCol, 0 );
    test.identical( m.strideOfRow, 0 );
    test.identical( m.strideInRow, 1 );

    m.copy({ buffer : o.arrayMake([ 1, 2, 3, 4, 5, 6 ]), offset : o.offset, inputRowMajor : 1, dims : [ 3, 2 ] /* yyy */ });
    logger.log( 'm\n' + _.toStr( m ) );

    test.identical( m.size, 24 );
    test.identical( m.sizeOfElement, 12 );
    test.identical( m.sizeOfCol, 12 );
    test.identical( m.sizeOfRow, 8 );
    test.identical( m.dims, [ 3, 2 ] );
    test.identical( m.length, 2 );

    test.identical( m.stridesEffective, [ 2, 1 ] );
    test.identical( m.strideOfElement, 1 );
    test.identical( m.strideOfCol, 1 );
    test.identical( m.strideInCol, 2 );
    test.identical( m.strideOfRow, 2 );
    test.identical( m.strideInRow, 1 );

    var r1 = m.rowGet( 1 );
    var r2 = m.lineGet( 1, 1 );
    var c1 = m.colGet( 1 );
    var c2 = m.lineGet( 0, 1 );
    var e = m.eGet( 1 );
    var a1 = m.scalarFlatGet( 3 );
    var a2 = m.scalarGet([ 1, 1 ]);

    test.identical( r1, o.vec([ 3, 4 ]) );
    test.identical( r1, r2 );
    test.identical( c1, o.vec([ 2, 4, 6 ]) );
    test.identical( c1, c2 );
    test.identical( e, o.vec([ 2, 4, 6 ]) );
    test.identical( a1, 4 );
    test.identical( a2, 4 );
    test.identical( m.reduceToSumScalarWise(), 21 );
    test.identical( m.reduceToProductScalarWise(), 720 );

    /* */

    test.case = 'make then copy';

    var m = _.Matrix.Make([ 2, 3 ]).copy
    ([
      1, 2, 3,
      4, 5, 6,
    ]);

    logger.log( 'm\n' + _.toStr( m ) );

    test.identical( m.size, 24 );
    test.identical( m.sizeOfElement, 8 );
    test.identical( m.sizeOfCol, 8 );
    test.identical( m.sizeOfRow, 12 );
    test.identical( m.dims, [ 2, 3 ] );
    test.identical( m.length, 3 );

    test.identical( m.strides, [ 1, 2 ] );
    test.identical( m.stridesEffective, [ 1, 2 ] );
    test.identical( m.strideOfElement, 2 );
    test.identical( m.strideOfCol, 2 );
    test.identical( m.strideInCol, 1 );
    test.identical( m.strideOfRow, 1 );
    test.identical( m.strideInRow, 2 );

    var r1 = m.rowGet( 1 );
    var r2 = m.lineGet( 1, 1 );
    var c1 = m.colGet( 1 );
    var c2 = m.lineGet( 0, 1 );
    var e = m.eGet( 1 );
    var a1 = m.scalarFlatGet( 3 );
    var a2 = m.scalarGet([ 1, 1 ]);

    test.identical( r1, _.vad.from( new F32x([ 4, 5, 6 ]) ) );
    test.identical( r1, r2 );
    test.identical( c1, _.vad.from( new F32x([ 2, 5 ]) ) );
    test.identical( c1, c2 );
    test.identical( e, _.vad.from( new F32x([ 2, 5 ]) ) );
    test.identical( a1, 5 );
    test.identical( a2, 5 );
    test.identical( m.reduceToSumScalarWise(), 21 );
    test.identical( m.reduceToProductScalarWise(), 720 );

    test.is( m.buffer instanceof F32x );

    /* */

    test.case = 'copy buffer from scalar';

    var m = _.Matrix.MakeSquare([ 1, 2, 3, 4 ]);
    var exp = _.Matrix.MakeSquare([ 13, 13, 13, 13 ]);

    m.copy( 13 );
    test.identical( m, exp );

    var m = _.Matrix.MakeSquare([]);
    var exp = _.Matrix.MakeSquare([]);

    m.copy( 13 );
    test.identical( m, exp );

    /* */

    test.case = 'copy buffer of different type';

    var b = new F32x
    ([
      1, 2, 3,
      4, 5, 6,
      7, 8, 9,
    ]);

    var m = context.makeWithOffset
    ({
      buffer : b,
      dims : [ 3, 3 ],
      offset : o.offset||0,
      inputRowMajor : 1,
    });

    test.is( m.buffer.length-( o.offset||0 ) === 9 );
    test.is( m.buffer instanceof F32x );

    var exp = _.Matrix.Make([ 3, 3 ]).copy
    ([
      1, 2, 3,
      4, 5, 6,
      7, 8, 9,
    ]);

    m.copy
    ([
      1, 2, 3,
      4, 5, 6,
      7, 8, 9,
    ]);

    test.identical( m, exp );
    test.is( m.buffer.length === 9+( o.offset||0 ) );
    test.is( m.buffer instanceof F32x );

    m.copy
    ( new U32x([
      1, 2, 3,
      4, 5, 6,
      7, 8, 9,
    ]));

    test.identical( m, exp );
    test.is( m.buffer.length === 9+( o.offset||0 ) );
    test.is( m.offset === ( o.offset||0 ) );
    test.is( m.buffer instanceof F32x );

    m.copy
    ({
      offset : 0,
      inputRowMajor : 1,
      buffer : new U32x
      ([
        1, 2, 3,
        4, 5, 6,
        7, 8, 9,
      ]),
    });

    test.notIdentical( m, exp );
    test.is( m.buffer.length === 9 );
    test.is( m.offset === 0 );
    test.is( m.buffer instanceof U32x );

    /* */

    test.case = 'bad buffer';

    test.shouldThrowErrorSync( function()
    {
      new _.Matrix
      ({
        buffer : _.longFromRange([ 1, 5 ]),
        dims : [ 3, 3 ],
      });
    });

    test.shouldThrowErrorSync( function()
    {
      var m = _.Matrix.Make([ 2, 3 ]).copy
      ([
        1, 2, 3,
        4, 5, 6,
        7, 8, 9,
      ]);
    });

  }

}

make.timeOut = 30000;

//

function makeHelper( test )
{

  /* */

  test.case = 'make';

  var m = _.Matrix.Make([ 3, 2 ]);

  logger.log( 'm\n' + _.toStr( m ) );

  // test.identical( m.size, 24 );
  // test.identical( m.sizeOfElement, 12 );
  // test.identical( m.sizeOfCol, 12 );
  // test.identical( m.sizeOfRow, 8 );
  test.identical( m.dims, [ 3, 2 ] );
  test.identical( m.length, 2 );

  test.identical( m.stridesEffective, [ 1, 3 ] );
  test.identical( m.strideOfElement, 3 );
  test.identical( m.strideOfCol, 3 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 3 );

  test.identical( m.strides, [ 1, 3 ] );
  // test.is( m.buffer instanceof F32x );

  /* */

  test.case = 'square with buffer';

  var buffer =
  [
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
  ];
  var m = _.Matrix.MakeSquare( buffer );

  logger.log( 'm\n' + _.toStr( m ) );

  // test.identical( m.size, 36 );
  // test.identical( m.sizeOfElement, 12 );
  // test.identical( m.sizeOfCol, 12 );
  // test.identical( m.sizeOfRow, 12 );
  test.identical( m.dims, [ 3, 3 ] );
  test.identical( m.length, 3 );

  test.identical( m.stridesEffective, [ 3, 1 ] );
  test.identical( m.strideOfElement, 1 );
  test.identical( m.strideOfCol, 1 );
  test.identical( m.strideInCol, 3 );
  test.identical( m.strideOfRow, 3 );
  test.identical( m.strideInRow, 1 );

  var r1 = m.rowGet( 1 );
  var r2 = m.lineGet( 1, 1 );
  var c1 = m.colGet( 1 );
  var c2 = m.lineGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.scalarFlatGet( 4 );
  var a2 = m.scalarGet([ 1, 1 ]);

  test.equivalent( r1, [ 4, 5, 6 ] );
  test.identical( r1, r2 );
  test.equivalent( c1, [ 2, 5, 8 ] );
  test.identical( c1, c2 );
  test.equivalent( e, [ 2, 5, 8 ] );
  test.identical( a1, 5 );
  test.identical( a2, 5 );
  test.identical( m.reduceToSumScalarWise(), 45 );
  test.identical( m.reduceToProductScalarWise(), 362880 );
  test.identical( m.determinant(), 0 );

  // test.is( m.buffer instanceof F32x );
  test.identical( m.strides, null );

  var buffer = new U32x
  ([
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
  ]);
  var m = _.Matrix.MakeSquare( buffer );
  test.identical( m.determinant(), 0 );
  test.is( m.buffer instanceof U32x );

  /* */

  test.case = 'square with length';

  var m = _.Matrix.MakeSquare( 3 );

  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 36 );
  test.identical( m.sizeOfElement, 12 );
  test.identical( m.sizeOfCol, 12 );
  test.identical( m.sizeOfRow, 12 );
  test.identical( m.dims, [ 3, 3 ] );
  test.identical( m.length, 3 );

  test.identical( m.stridesEffective, [ 1, 3 ] );
  test.identical( m.strideOfElement, 3 );
  test.identical( m.strideOfCol, 3 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 3 );

  test.is( m.buffer instanceof F32x );
  test.identical( m.strides, null );

  /* */

  test.case = 'diagonal';

  var m = _.Matrix.MakeDiagonal([ 1, 2, 3 ]);

  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 36 );
  test.identical( m.sizeOfElement, 12 );
  test.identical( m.sizeOfCol, 12 );
  test.identical( m.sizeOfRow, 12 );
  test.identical( m.dims, [ 3, 3 ] );
  test.identical( m.length, 3 );

  test.identical( m.stridesEffective, [ 1, 3 ] );
  test.identical( m.strideOfElement, 3 );
  test.identical( m.strideOfCol, 3 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 3 );

  var r1 = m.rowGet( 1 );
  var r2 = m.lineGet( 1, 1 );
  var c1 = m.colGet( 1 );
  var c2 = m.lineGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.scalarFlatGet( 4 );
  var a2 = m.scalarGet([ 1, 1 ]);

  test.identical( r1, fvec([ 0, 2, 0 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 0, 2, 0 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 0, 2, 0 ]) );
  test.identical( a1, 2 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumScalarWise(), 6 );
  test.identical( m.reduceToProductScalarWise(), 0 );
  test.identical( m.determinant(), 6 );

  test.is( m.buffer instanceof F32x );
  test.identical( m.strides, [ 1, 3 ] );

  /* */

  test.case = 'identity';

  m = _.Matrix.MakeIdentity( 3 );

  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 36 );
  test.identical( m.sizeOfElement, 12 );
  test.identical( m.sizeOfCol, 12 );
  test.identical( m.sizeOfRow, 12 );
  test.identical( m.dims, [ 3, 3 ] );
  test.identical( m.length, 3 );

  test.identical( m.stridesEffective, [ 1, 3 ] );
  test.identical( m.strideOfElement, 3 );
  test.identical( m.strideOfCol, 3 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 3 );

  var r1 = m.rowGet( 1 );
  var r2 = m.lineGet( 1, 1 );
  var c1 = m.colGet( 1 );
  var c2 = m.lineGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.scalarFlatGet( 4 );
  var a2 = m.scalarGet([ 1, 1 ]);

  test.identical( r1, fvec([ 0, 1, 0 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 0, 1, 0 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 0, 1, 0 ]) );
  test.identical( a1, 1 );
  test.identical( a2, 1 );
  test.identical( m.reduceToSumScalarWise(), 3 );
  test.identical( m.reduceToProductScalarWise(), 0 );
  test.identical( m.determinant(), 1 );

  test.is( m.buffer instanceof F32x );
  test.identical( m.strides, [ 1, 3 ] );

  /* */

  test.case = 'identity, not square, 2x3';

  m = _.Matrix.MakeIdentity([ 2, 3 ]);

  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 24 );
  test.identical( m.sizeOfElement, 8 );
  test.identical( m.sizeOfCol, 8 );
  test.identical( m.sizeOfRow, 12 );
  test.identical( m.dims, [ 2, 3 ] );
  test.identical( m.length, 3 );

  test.identical( m.stridesEffective, [ 1, 2 ] );
  test.identical( m.strideOfElement, 2 );
  test.identical( m.strideOfCol, 2 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 2 );

  var r1 = m.rowGet( 1 );
  var r2 = m.lineGet( 1, 1 );
  var c1 = m.colGet( 1 );
  var c2 = m.lineGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.scalarFlatGet( 3 );
  var a2 = m.scalarGet([ 1, 1 ]);

  test.identical( r1, fvec([ 0, 1, 0 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 0, 1 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 0, 1 ]) );
  test.identical( a1, 1 );
  test.identical( a2, 1 );
  test.identical( m.reduceToSumScalarWise(), 2 );
  test.identical( m.reduceToProductScalarWise(), 0 );

  test.is( m.buffer instanceof F32x );
  test.identical( m.strides, [ 1, 2 ] );

  /* */

  test.case = 'identity, not square, 3x2';

  m = _.Matrix.MakeIdentity([ 3, 2 ]);

  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 24 );
  test.identical( m.sizeOfElement, 12 );
  test.identical( m.sizeOfCol, 12 );
  test.identical( m.sizeOfRow, 8 );
  test.identical( m.dims, [ 3, 2 ] );
  test.identical( m.length, 2 );

  test.identical( m.stridesEffective, [ 1, 3 ] );
  test.identical( m.strideOfElement, 3 );
  test.identical( m.strideOfCol, 3 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 3 );

  var r1 = m.rowGet( 1 );
  var r2 = m.lineGet( 1, 1 );
  var c1 = m.colGet( 1 );
  var c2 = m.lineGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.scalarFlatGet( 4 );
  var a2 = m.scalarGet([ 1, 1 ]);

  test.identical( r1, fvec([ 0, 1 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 0, 1, 0 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 0, 1, 0 ]) );
  test.identical( a1, 1 );
  test.identical( a2, 1 );
  test.identical( m.reduceToSumScalarWise(), 2 );
  test.identical( m.reduceToProductScalarWise(), 0 );

  test.is( m.buffer instanceof F32x );
  test.identical( m.strides, [ 1, 3 ] );

  /* */

  test.case = 'zeroed';

  m = _.Matrix.MakeZero( 3 );

  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 36 );
  test.identical( m.sizeOfElement, 12 );
  test.identical( m.sizeOfCol, 12 );
  test.identical( m.sizeOfRow, 12 );
  test.identical( m.dims, [ 3, 3 ] );
  test.identical( m.length, 3 );

  test.identical( m.stridesEffective, [ 1, 3 ] );
  test.identical( m.strideOfElement, 3 );
  test.identical( m.strideOfCol, 3 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 3 );

  var r1 = m.rowGet( 1 );
  var r2 = m.lineGet( 1, 1 );
  var c1 = m.colGet( 1 );
  var c2 = m.lineGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.scalarFlatGet( 4 );
  var a2 = m.scalarGet([ 1, 1 ]);

  test.identical( r1, fvec([ 0, 0, 0 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 0, 0, 0 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 0, 0, 0 ]) );
  test.identical( a1, 0 );
  test.identical( a2, 0 );
  test.identical( m.reduceToSumScalarWise(), 0 );
  test.identical( m.reduceToProductScalarWise(), 0 );
  test.identical( m.determinant(), 0 );

  test.is( m.buffer instanceof F32x );
  test.identical( m.strides, [ 1, 3 ] );

  /* */

  function checkNull( m )
  {

    logger.log( 'm\n' + _.toStr( m ) );

    // test.identical( m.size, 0 );
    // test.identical( m.sizeOfElement, 0 );
    // test.identical( m.sizeOfCol, 0 );
    // test.identical( m.sizeOfRow, 0 );
    test.identical( m.dims, [ 0, 0 ] );
    test.identical( m.length, 0 );

    test.identical( m.stridesEffective, [ 1, 0 ] );
    test.identical( m.strideOfElement, 0 );
    test.identical( m.strideOfCol, 0 );
    test.identical( m.strideInCol, 1 );
    test.identical( m.strideOfRow, 1 );
    test.identical( m.strideInRow, 0 );

    test.identical( m.reduceToSumScalarWise(), 0 );
    test.identical( m.reduceToProductScalarWise(), 1 );
    test.identical( m.determinant(), 0 );
    // test.is( m.buffer instanceof F32x );

    if( Config.debug )
    {

      test.shouldThrowErrorSync( () => m.colGet( 0 ) );
      test.shouldThrowErrorSync( () => m.lineGet( 0, 0 ) );
      test.shouldThrowErrorSync( () => m.eGet( 0 ) );
      test.shouldThrowErrorSync( () => m.rowGet( 0 ) );
      test.shouldThrowErrorSync( () => m.colGet( 0 ) );
      test.shouldThrowErrorSync( () => m.eGet( 0 ) );
      test.shouldThrowErrorSync( () => m.scalarFlatGet( 0 ) );
      test.shouldThrowErrorSync( () => m.scalarGet( 0 ) );

    }

  }

  /* */

  test.case = 'square null with buffer';

  var m = _.Matrix.MakeSquare([]);
  checkNull( m );

  /* */

  test.case = 'square null with length';

  var m = _.Matrix.MakeSquare( 0 );
  checkNull( m );

  /* */

  test.case = 'zeroed null';

  var m = _.Matrix.MakeZero([ 0, 0 ]);
  checkNull( m );

  /* */

  test.case = 'identity null';

  var m = _.Matrix.MakeIdentity([ 0, 0 ]);
  checkNull( m );

  /* */

  test.case = 'diagonal null';

  var m = _.Matrix.MakeDiagonal([]);
  checkNull( m );

}

//

function makeMultyMatrix( test )
{

  /* */

  test.case = 'basic';

  var simpleMatrix = _.Matrix.Make([ 2, 2 ]).copy
  ([
    1, 2,
    3, 4,
  ]);

  console.log( `\n= simple matrix\n${ simpleMatrix.toStr() }` );

  var superMatrix = _.Matrix.Make([ 2, 2, 2 ]).copy
  ([
    1, 2,
    3, 4,
    5, 6,
    7, 8,
  ]);

  console.log( `\n= super matrix\n${ superMatrix.toStr() }` );

  var subMatrix1 = superMatrix.submatrix( _.all, _.all, 0 );
  var subMatrix2 = superMatrix.submatrix( _.all, _.all, 1 );

  var exp = _.Matrix.Make([ 2, 2 ]).copy
  ([
    1, 2,
    3, 4,
  ]);
  test.equivalent( subMatrix1, exp );

  var exp = _.Matrix.Make([ 2, 2 ]).copy
  ([
    5, 6,
    7, 8,
  ]);
  test.equivalent( subMatrix2, exp );

  /* */

}

//

function from( test )
{

  /* */

  test.case = 'FromScalarForReading scalar';

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 1, 1,
    1, 1, 1,
  ]);

  var m = _.Matrix.FromScalarForReading( 1, [ 2, 3 ] );
  m.toStr();
  logger.log( m );

  test.identical( m, exp );
  test.identical( m.dims, [ 2, 3 ] );
  test.identical( m.stridesEffective, [ 0, 0 ] )

  /* */

  test.case = 'empty matrix FromScalarForReading scalar';

  var exp = _.Matrix.Make([ 0, 3 ]);
  var m = _.Matrix.FromScalarForReading( 1, [ 0, 3 ] );
  test.identical( m, exp )
  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.stridesEffective, [ 0, 0 ] )

  var exp = _.Matrix.Make([ 3, 0 ]);
  var m = _.Matrix.FromScalarForReading( 1, [ 3, 0 ] );
  test.identical( m, exp );
  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m.stridesEffective, [ 0, 0 ] )
  logger.log( m );

  /* */

  test.case = 'FromForReading scalar';

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 1, 1,
    1, 1, 1,
  ]);

  var m = _.Matrix.FromForReading( 1, [ 2, 3 ] );
  m.toStr();
  logger.log( m );

  test.identical( m, exp );
  test.identical( m.dims, [ 2, 3 ] );
  test.identical( m.stridesEffective, [ 0, 0 ] )

  /* */

  test.case = 'empty matrix FromForReading scalar';

  var exp = _.Matrix.Make([ 0, 3 ]);
  var m = _.Matrix.FromForReading( 1, [ 0, 3 ] );
  test.identical( m, exp )
  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.stridesEffective, [ 0, 0 ] )

  var exp = _.Matrix.Make([ 3, 0 ]);
  var m = _.Matrix.FromForReading( 1, [ 3, 0 ] );
  test.identical( m, exp )
  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m.stridesEffective, [ 0, 0 ] )
  logger.log( m );

  /* */

  test.case = 'from scalar';

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 1, 1,
    1, 1, 1,
  ]);

  var m = _.Matrix.From( 1, [ 2, 3 ] );
  m.toStr();
  logger.log( m );

  test.identical( m, exp );
  test.identical( m.dims, [ 2, 3 ] );
  test.identical( m.stridesEffective, [ 1, 2 ] )

  /* */

  test.case = 'empty matrix from scalar';

  var exp = _.Matrix.Make([ 0, 3 ]);
  var m = _.Matrix.From( 1, [ 0, 3 ] );
  test.identical( m, exp )
  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.stridesEffective, [ 1, 0 ] )

  var exp = _.Matrix.Make([ 3, 0 ]);
  var m = _.Matrix.From( 1, [ 3, 0 ] );
  test.identical( m, exp )
  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m.stridesEffective, [ 1, 3 ] )

  logger.log( m );

  /* */

  test.case = 'FromScalar scalar';

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 1, 1,
    1, 1, 1,
  ]);

  var m = _.Matrix.FromScalar( 1, [ 2, 3 ] );
  m.toStr();
  logger.log( m );

  test.identical( m, exp );
  test.identical( m.dims, [ 2, 3 ] );
  test.identical( m.stridesEffective, [ 1, 2 ] )

  /* */

  test.case = 'empty matrix FromScalar scalar';

  var exp = _.Matrix.Make([ 0, 3 ]);
  var m = _.Matrix.FromScalar( 1, [ 0, 3 ] );
  test.identical( m, exp )
  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.stridesEffective, [ 1, 0 ] )

  var exp = _.Matrix.Make([ 3, 0 ]);
  var m = _.Matrix.FromScalar( 1, [ 3, 0 ] );
  test.identical( m, exp )
  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m.stridesEffective, [ 1, 3 ] )

  logger.log( m );

  /* */

  test.case = 'from matrix';

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 1, 1,
    1, 1, 1,
  ]);

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 1, 1,
    1, 1, 1,
  ]);

  var got = _.Matrix.From( m, [ 2, 3 ] );
  test.identical( got, exp );

  var got = _.Matrix.From( m );
  test.identical( got, exp );

  /* */

  test.case = 'from array';

  var exp = _.Matrix.Make([ 3, 1 ]);
  exp.buffer = [ 1, 2, 3, ];

  var a = [ 1, 2, 3 ];

  var got = _.Matrix.From( a );
  test.identical( got, exp );

  var got = _.Matrix.From( a, [ 3, 1 ] );
  test.identical( got, exp );

  /* */

  test.case = 'from vector';

  var exp = _.Matrix.Make([ 3, 1 ]);
  exp.buffer = [ 1, 2, 3, ];

  var a = _.vad.from([ 1, 2, 3 ]);

  var got = _.Matrix.From( a );
  test.identical( got, exp );

  var got = _.Matrix.From( a, [ 3, 1 ] );
  test.identical( got, exp );

  /* */

  test.case = 'bad arguments';

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () => m.from() );
  test.shouldThrowErrorSync( () => m.from( 1, 1 ) );
  test.shouldThrowErrorSync( () => m.from( 1, [ 1, 1 ], 1 ) );
  test.shouldThrowErrorSync( () => m.from( [ 1, 2, 3 ], [ 2, 1 ] ) );
  test.shouldThrowErrorSync( () => m.from( [ 1, 2, 3 ], [ 4, 1 ] ) );
  test.shouldThrowErrorSync( () => m.from( [ 1, 2, 3 ], [ 3, 2 ] ) );
  test.shouldThrowErrorSync( () => m.from( _.vad.from([ 1, 2, 3 ]), [ 2, 1 ] ) );
  test.shouldThrowErrorSync( () => m.from( _.vad.from([ 1, 2, 3 ]), [ 4, 1 ] ) );
  test.shouldThrowErrorSync( () => m.from( _.vad.from([ 1, 2, 3 ]), [ 3, 2 ] ) );
  test.shouldThrowErrorSync( () => m.from( _.Matrix.Make([ 3, 3 ]), _.Matrix.Make([ 3, 3 ]) ) );
  test.shouldThrowErrorSync( () => m.from( _.Matrix.Make([ 2, 3 ]), [ 2, 4 ] ) );
  test.shouldThrowErrorSync( () => m.from( _.Matrix.Make([ 3, 2 ]), [ 3, 2 ] ) );

}

//

function bufferSetLarger( test )
{

  /* */

  test.case = 'strides : 1,0';

  var m = _.Matrix
  ({
    dims : [ 0, 3 ],
    strides : [ 1, 0 ],
  });

  test.identical( m.buffer, new F32x([]) );
  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.dimsEffective, [ 0, 3 ] );
  test.identical( m.strides, [ 1, 0 ] );
  test.identical( m.stridesEffective, [ 1, 0 ] );

  m.copy({ buffer : new F32x([ 1, 2, 3, 4, 5, 6 ]), inputRowMajor : 0 });
  logger.log( `m\n ${_.toStr( m )}` );

  test.identical( m.buffer, new F32x([ 1, 2, 3, 4, 5, 6 ]) );
  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.dimsEffective, [ 0, 3 ] );
  test.identical( m.strides, null );
  test.identical( m.stridesEffective, [ 1, 0 ] );

  var exp = _.Matrix.Make([ 0, 3 ]).copy
  ([
  ]);
  test.identical( m, exp );

  /* */

  test.case = 'strides : 0,1';

  var m = _.Matrix
  ({
    dims : [ 0, 3 ],
    strides : [ 0, 1 ],
  });

  test.identical( m.buffer, new F32x([]) );
  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.dimsEffective, [ 0, 3 ] );
  test.identical( m.strides, [ 0, 1 ] );
  test.identical( m.stridesEffective, [ 0, 1 ] );

  m.copy({ buffer : new F32x([ 1, 2, 3, 4, 5, 6 ]), inputRowMajor : 0 });
  logger.log( `m\n ${_.toStr( m )}` );

  test.identical( m.buffer, new F32x([ 1, 2, 3, 4, 5, 6 ]) );
  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.dimsEffective, [ 0, 3 ] );
  test.identical( m.strides, null );
  test.identical( m.stridesEffective, [ 1, 0 ] );

  var exp = _.Matrix.Make([ 0, 3 ]).copy
  ([
  ]);
  test.identical( m, exp );

  /* */

}

//

function constructTransposing( test )
{

  /* */

  test.case = 'inputRowMajor : 1';

  var buffer =
  [
    -1, -1,
    1, 2,
    3, 4,
    5, 6,
    11, 11,
  ]
  var obuffer = buffer.slice();

  var m = _.Matrix
  ({
    buffer,
    offset : 2,
    dims : [ 3, 2 ],
    inputRowMajor : 1,
  });

  console.log( `m\n${m.toStr()}` );

  test.identical( m.buffer, obuffer );
  test.identical( m.dims, [ 3, 2 ] );
  test.identical( m.dimsEffective, [ 3, 2 ] );
  test.identical( m.strides, null );
  test.identical( m.stridesEffective, [ 2, 1 ] );

  test.is( m.buffer === buffer );

  var exp = _.Matrix
  ({
    dims : [ 3, 2 ],
    strides : [ 2, 1 ],
    buffer :
    [
      1, 2,
      3, 4,
      5, 6
    ]
  });

  console.log( `m\n${m.toStr()}` );
  console.log( `exp\n${exp.toStr()}` );

  test.identical( m, exp );

  /* */

  test.case = 'inputRowMajor : 0';

  var buffer =
  [
    -1, -1,
    1, 2,
    3, 4,
    5, 6,
    11, 11,
  ]
  var obuffer = buffer.slice();

  var m = _.Matrix
  ({
    buffer,
    offset : 2,
    dims : [ 3, 2 ],
    inputRowMajor : 0,
  });

  console.log( `m\n${m.toStr()}` );

  test.identical( m.buffer, obuffer );
  test.identical( m.dims, [ 3, 2 ] );
  test.identical( m.dimsEffective, [ 3, 2 ] );
  test.identical( m.strides, null );
  test.identical( m.stridesEffective, [ 1, 3 ] );

  test.is( m.buffer === buffer );

  var exp = _.Matrix
  ({
    dims : [ 3, 2 ],
    strides : [ 2, 1 ],
    buffer :
    [
      1, 4,
      2, 5,
      3, 6
    ]
  });

  console.log( `m\n${m.toStr()}` );
  console.log( `exp\n${exp.toStr()}` );

  test.identical( m, exp );

  /* */

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () =>
  {
    var m = _.Matrix
    ({
      buffer,
      offset : 2,
      dims : [ 3, 2 ],
    });
  });

}

//

function constructWithInfinity( test )
{

  /* */

  test.case = 'dims : [ 3, Infinity ] ; inputRowMajor : 0';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 2, 3 ]),
    inputRowMajor : 0,
    dims : [ 3, Infinity ],
  });

  test.identical( m1.dims, [ 3, Infinity ] );
  test.identical( m1.dimsEffective, [ 3, 1 ] );
  test.identical( m1.strides, null );
  test.identical( m1.stridesEffective, [ 1, 0 ] );
  console.log( m1.toStr() );

  /* */

  test.case = 'dims : [ 3, Infinity ] ; inputRowMajor : 1';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 2, 3 ]),
    inputRowMajor : 1,
    dims : [ 3, Infinity ],
  });

  test.identical( m1.dims, [ 3, Infinity ] );
  test.identical( m1.dimsEffective, [ 3, 1 ] );
  test.identical( m1.strides, null );
  test.identical( m1.stridesEffective, [ 1, 0 ] );
  console.log( m1.toStr() );

  /* */

  test.case = 'dims : [ Infinity, 3 ] ; inputRowMajor : 0';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 2, 3 ]),
    inputRowMajor : 0,
    dims : [ Infinity, 3 ],
  });

  test.identical( m1.dims, [ Infinity, 3 ] );
  test.identical( m1.dimsEffective, [ 1, 3 ] );
  test.identical( m1.strides, null );
  test.identical( m1.stridesEffective, [ 0, 1 ] );
  console.log( m1.toStr() );

  /* */

  test.case = 'dims : [ Infinity, 3 ] ; inputRowMajor : 1';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 2, 3 ]),
    inputRowMajor : 1,
    dims : [ Infinity, 3 ],
  });

  test.identical( m1.dims, [ Infinity, 3 ] );
  test.identical( m1.dimsEffective, [ 1, 3 ] );
  test.identical( m1.strides, null );
  test.identical( m1.stridesEffective, [ 0, 1 ] );
  console.log( m1.toStr() );

  /* */

}

//

function constructWithScalarsPerElement( test )
{

  /* */

  test.case = 'non empty, inputRowMajor : 0';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 2, 3, 4, 5, 6 ]),
    inputRowMajor : 0,
    scalarsPerElement : 3,
  });

  test.identical( m1.dims, [ 3, 2 ] );
  test.identical( m1.dimsEffective, [ 3, 2 ] );
  test.identical( m1.strides, null );
  test.identical( m1.stridesEffective, [ 1, 3 ] );
  console.log( m1.toStr() );

  /* */

  test.case = 'non empty, inputRowMajor : 1';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 2, 3, 4, 5, 6 ]),
    inputRowMajor : 1,
    scalarsPerElement : 3,
  });

  test.identical( m1.dims, [ 3, 2 ] );
  test.identical( m1.dimsEffective, [ 3, 2 ] );
  test.identical( m1.strides, null );
  test.identical( m1.stridesEffective, [ 2, 1 ] );
  console.log( m1.toStr() );

  /* */

  test.case = 'empty, inputRowMajor : 0';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([]),
    inputRowMajor : 0,
    scalarsPerElement : 3,
  });

  test.identical( m1.dims, [ 3, 0 ] );
  test.identical( m1.dimsEffective, [ 3, 0 ] );
  test.identical( m1.strides, null );
  test.identical( m1.stridesEffective, [ 1, 3 ] );
  console.log( m1.toStr() );

  /* */

  test.case = 'empty, inputRowMajor : 1';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([]),
    inputRowMajor : 1,
    scalarsPerElement : 3,
  });

  test.identical( m1.dims, [ 3, 0 ] );
  test.identical( m1.dimsEffective, [ 3, 0 ] );
  test.identical( m1.strides, null );
  test.identical( m1.stridesEffective, [ 0, 1 ] );
  console.log( m1.toStr() );

  /* */

  if( !Config.debug )
  return;

  test.case = 'throwing';

  test.shouldThrowErrorSync( () =>
  {
    var m1 = new _.Matrix
    ({
      buffer : new F32x([ 1, 2, 3 ]),
      inputRowMajor : 1,
      atomsPerElement : 3,
    });
  });

  /* */

}

//

function constructWithoutBuffer( test )
{

  /* */

  var exp =
  {
    'dims' : [ 3, 2 ],
    'buffer' : ( new F32x([ 0, 0, 0, 0, 0, 0 ]) ),
    'offset' : 0,
    'strides' : [ 1, 3 ]
  }
  var inputRowMajor = 0;
  var dims = [ 3, 2 ];
  var matrix = _.Matrix({ dims, inputRowMajor });
  var exported = matrix.exportStructure({ dst : {} });
  test.identical( exported, exp );

  var exp =
  {
    'dims' : [ 3, 2 ],
    'buffer' : new F32x([ 1, 3, 5, 2, 4, 6 ]),
    'offset' : 0,
    'strides' : [ 1, 3 ]
  }
  var buffer = [ 1, 2, 3, 4, 5, 6 ];
  matrix.copy( buffer );
  logger.log( matrix.toStr() );
  var exported = matrix.exportStructure({ dst : {} });
  test.identical( exported, exp );

  /* */

}

//

function constructWithoutDims( test )
{

  /* */

  test.case = 'buffer and strides : [ 1, 3 ]';

  var buffer = new I32x
  ([
    1, 2, 3,
    4, 5, 6,
  ]);
  var m = new _.Matrix({ buffer, strides : [ 1, 3 ] });

  test.identical( m.offset, 0 );
  test.identical( m.dims, [ 3, 2 ] );
  test.identical( m.dimsEffective, [ 3, 2 ] );
  test.identical( m.strides, [ 1, 3 ] );
  test.identical( m.stridesEffective, [ 1, 3 ] );
  test.identical( m.toLong(), new I32x([ 1, 2, 3, 4, 5, 6 ]) );
  logger.log( m.toStr() );

  /* */

  test.case = 'empty buffer, inputRowMajor : 1';
  var buffer = new F32x();
  var src = new _.Matrix({ buffer, inputRowMajor : 1 });
  test.is( src.buffer === buffer );
  test.identical( src.buffer, new F32x([]) );
  test.identical( src.dims, [ 0, 1 ] );
  test.identical( src.dimsEffective, [ 0, 1 ] );
  test.identical( src.strides, null );
  test.identical( src.stridesEffective, [ 1, 1 ] );

  /* */

  test.case = 'empty buffer, inputRowMajor : 0';
  var buffer = new F32x();
  var src = new _.Matrix({ buffer, inputRowMajor : 0 });
  test.is( src.buffer === buffer );
  test.identical( src.buffer, new F32x([]) );
  // test.identical( src.dims, [ 1, 0 ] );
  // test.identical( src.dimsEffective, [ 1, 0 ] );
  test.identical( src.dims, [ 0, 1 ] );
  test.identical( src.dimsEffective, [ 0, 1 ] );
  test.identical( src.strides, null );
  test.identical( src.stridesEffective, [ 1, 0 ] );

  /* */

  test.case = 'empty buffer, inputRowMajor : 1';
  var buffer = new F32x([ 1, 2, 3 ]);
  var src = new _.Matrix({ buffer, inputRowMajor : 1 });
  test.is( src.buffer === buffer );
  test.identical( src.buffer, new F32x([ 1, 2, 3 ]) );
  test.identical( src.dims, [ 3, 1 ] );
  test.identical( src.dimsEffective, [ 3, 1 ] );
  test.identical( src.strides, null );
  test.identical( src.stridesEffective, [ 1, 1 ] );
  // test.identical( src.stridesEffective, [ 1, 3 ] );

  /* */

  test.case = 'empty buffer, inputRowMajor : 0';
  var buffer = new F32x([ 1, 2, 3 ]);
  var src = new _.Matrix({ buffer, inputRowMajor : 0 });
  test.is( src.buffer === buffer );
  test.identical( src.buffer, new F32x([ 1, 2, 3 ]) );
  test.identical( src.dims, [ 3, 1 ] );
  test.identical( src.dimsEffective, [ 3, 1 ] );
  test.identical( src.strides, null );
  test.identical( src.stridesEffective, [ 1, 3 ] );

  /* */

}

//

function constructDeducing( test )
{

  /* - */

  test.case = 'scalarsPerElement, strides : [ 2, 6 ], dims : [ 3, 1 ]';

  var m = new _.Matrix
  ({
    buffer : new I32x([ 0, 1, 2, 3, 4, 5, 6, 7 ]),
    offset : 1,
    scalarsPerElement : 3,
    strides : [ 2, 6 ],
    dims : [ 3, 1 ],
  });

  test.identical( m.offset, 1 );
  test.identical( m.dims, [ 3, 1 ] );
  test.identical( m.dimsEffective, [ 3, 1 ] );
  test.identical( m.strides, [ 2, 6 ] );
  test.identical( m.stridesEffective, [ 2, 6 ] );
  test.identical( m.toLong(), new I32x([ 1, 3, 5 ]) );

  /* */

  test.case = 'scalarsPerElement, strides : [ 2, 6 ]';

  var m = new _.Matrix
  ({
    buffer : new I32x([ 0, 1, 2, 3, 4, 5, 6, 7 ]),
    offset : 1,
    scalarsPerElement : 3,
    strides : [ 2, 6 ],
  });

  test.identical( m.offset, 1 );
  test.identical( m.dims, [ 3, 1 ] );
  test.identical( m.dimsEffective, [ 3, 1 ] );
  test.identical( m.strides, [ 2, 6 ] );
  test.identical( m.stridesEffective, [ 2, 6 ] );
  test.identical( m.toLong(), new I32x([ 1, 3, 5 ]) );

  /* */

  test.case = 'scalarsPerElement, strides : [ 6, 2 ]';

  var m = new _.Matrix
  ({
    buffer : new I32x([ 0, 1, 2, 3, 4, 5, 6, 7, 8 ]),
    offset : 1,
    scalarsPerElement : 2,
    strides : [ 4, 1 ],
  });

  test.identical( m.offset, 1 );
  test.identical( m.dims, [ 2, 4 ] );
  test.identical( m.dimsEffective, [ 2, 4 ] );
  test.identical( m.strides, [ 4, 1 ] );
  test.identical( m.stridesEffective, [ 4, 1 ] );
  test.identical( m.toLong(), new I32x([ 1, 5, 2, 6, 3, 7, 4, 8 ]) );

  /* - */

  test.case = 'scalarsPerCol, strides : [ 2, 6 ], dims : [ 3, 1 ]';

  var m = new _.Matrix
  ({
    buffer : new I32x([ 0, 1, 2, 3, 4, 5, 6, 7 ]),
    offset : 1,
    scalarsPerCol : 3,
    strides : [ 2, 6 ],
    dims : [ 3, 1 ],
  });

  test.identical( m.offset, 1 );
  test.identical( m.dims, [ 3, 1 ] );
  test.identical( m.dimsEffective, [ 3, 1 ] );
  test.identical( m.strides, [ 2, 6 ] );
  test.identical( m.stridesEffective, [ 2, 6 ] );
  test.identical( m.toLong(), new I32x([ 1, 3, 5 ]) );

  /* */

  test.case = 'scalarsPerCol, strides : [ 2, 6 ]';

  var m = new _.Matrix
  ({
    buffer : new I32x([ 0, 1, 2, 3, 4, 5, 6, 7 ]),
    offset : 1,
    scalarsPerCol : 3,
    strides : [ 2, 6 ],
  });

  test.identical( m.offset, 1 );
  test.identical( m.dims, [ 3, 1 ] );
  test.identical( m.dimsEffective, [ 3, 1 ] );
  test.identical( m.strides, [ 2, 6 ] );
  test.identical( m.stridesEffective, [ 2, 6 ] );
  test.identical( m.toLong(), new I32x([ 1, 3, 5 ]) );

  /* */

  test.case = 'scalarsPerCol, strides : [ 6, 2 ]';

  var m = new _.Matrix
  ({
    buffer : new I32x([ 0, 1, 2, 3, 4, 5, 6, 7, 8 ]),
    offset : 1,
    scalarsPerCol : 2,
    strides : [ 4, 1 ],
  });

  test.identical( m.offset, 1 );
  test.identical( m.dims, [ 2, 4 ] );
  test.identical( m.dimsEffective, [ 2, 4 ] );
  test.identical( m.strides, [ 4, 1 ] );
  test.identical( m.stridesEffective, [ 4, 1 ] );
  test.identical( m.toLong(), new I32x([ 1, 5, 2, 6, 3, 7, 4, 8 ]) );

  /* - */

  test.case = 'ncol, strides : [ 2, 6 ], dims : [ 3, 1 ]';

  var m = new _.Matrix
  ({
    buffer : new I32x([ 0, 1, 2, 3, 4, 5, 6, 7 ]),
    offset : 1,
    ncol : 3,
    strides : [ 2, 6 ],
    dims : [ 3, 1 ],
  });

  test.identical( m.offset, 1 );
  test.identical( m.dims, [ 3, 1 ] );
  test.identical( m.dimsEffective, [ 3, 1 ] );
  test.identical( m.strides, [ 2, 6 ] );
  test.identical( m.stridesEffective, [ 2, 6 ] );
  test.identical( m.toLong(), new I32x([ 1, 3, 5 ]) );

  /* */

  test.case = 'ncol, strides : [ 2, 6 ]';

  var m = new _.Matrix
  ({
    buffer : new I32x([ 0, 1, 2, 3, 4, 5, 6, 7 ]),
    offset : 1,
    ncol : 3,
    strides : [ 2, 6 ],
  });

  test.identical( m.offset, 1 );
  test.identical( m.dims, [ 3, 1 ] );
  test.identical( m.dimsEffective, [ 3, 1 ] );
  test.identical( m.strides, [ 2, 6 ] );
  test.identical( m.stridesEffective, [ 2, 6 ] );
  test.identical( m.toLong(), new I32x([ 1, 3, 5 ]) );

  /* */

  test.case = 'ncol, strides : [ 6, 2 ]';

  var m = new _.Matrix
  ({
    buffer : new I32x([ 0, 1, 2, 3, 4, 5, 6, 7, 8 ]),
    offset : 1,
    ncol : 2,
    strides : [ 4, 1 ],
  });

  test.identical( m.offset, 1 );
  test.identical( m.dims, [ 2, 4 ] );
  test.identical( m.dimsEffective, [ 2, 4 ] );
  test.identical( m.strides, [ 4, 1 ] );
  test.identical( m.stridesEffective, [ 4, 1 ] );
  test.identical( m.toLong(), new I32x([ 1, 5, 2, 6, 3, 7, 4, 8 ]) );

  /* - */

  test.case = 'nrow, strides : [ 4, 1 ], dims : [ 3, 1 ]';

  var m = new _.Matrix
  ({
    buffer : new I32x([ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]),
    offset : 1,
    nrow : 2,
    strides : [ 4, 1 ],
    dims : [ 3, 2 ],
  });

  test.identical( m.offset, 1 );
  test.identical( m.dims, [ 3, 2 ] );
  test.identical( m.dimsEffective, [ 3, 2 ] );
  test.identical( m.strides, [ 4, 1 ] );
  test.identical( m.stridesEffective, [ 4, 1 ] );
  test.identical( m.toLong(), new I32x([ 1, 5, 9, 2, 6, 10 ]) );
  logger.log( m.toStr() );

  /* */

  test.case = 'nrow, strides : [ 4, 1 ]';

  var m = new _.Matrix
  ({
    buffer : new I32x([ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]),
    offset : 1,
    nrow : 2,
    strides : [ 4, 1 ],
  });

  test.identical( m.offset, 1 );
  test.identical( m.dims, [ 3, 2 ] );
  test.identical( m.dimsEffective, [ 3, 2 ] );
  test.identical( m.strides, [ 4, 1 ] );
  test.identical( m.stridesEffective, [ 4, 1 ] );
  test.identical( m.toLong(), new I32x([ 1, 5, 9, 2, 6, 10 ]) );
  logger.log( m.toStr() );

  /* - */

  test.case = 'scalarsPerRow, strides : [ 4, 1 ], dims : [ 3, 1 ]';

  var m = new _.Matrix
  ({
    buffer : new I32x([ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]),
    offset : 1,
    scalarsPerRow : 2,
    strides : [ 4, 1 ],
    dims : [ 3, 2 ],
  });

  test.identical( m.offset, 1 );
  test.identical( m.dims, [ 3, 2 ] );
  test.identical( m.dimsEffective, [ 3, 2 ] );
  test.identical( m.strides, [ 4, 1 ] );
  test.identical( m.stridesEffective, [ 4, 1 ] );
  test.identical( m.toLong(), new I32x([ 1, 5, 9, 2, 6, 10 ]) );
  logger.log( m.toStr() );

  /* */

  test.case = 'scalarsPerRow, strides : [ 4, 1 ]';

  var m = new _.Matrix
  ({
    buffer : new I32x([ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]),
    offset : 1,
    scalarsPerRow : 2,
    strides : [ 4, 1 ],
  });

  test.identical( m.offset, 1 );
  test.identical( m.dims, [ 3, 2 ] );
  test.identical( m.dimsEffective, [ 3, 2 ] );
  test.identical( m.strides, [ 4, 1 ] );
  test.identical( m.stridesEffective, [ 4, 1 ] );
  test.identical( m.toLong(), new I32x([ 1, 5, 9, 2, 6, 10 ]) );
  logger.log( m.toStr() );

  /* */

  test.case = 'scalarsPerRow, strides : [ 1, 4 ]';

  var m = new _.Matrix
  ({
    buffer : new I32x([ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]),
    offset : 1,
    scalarsPerRow : 2,
    strides : [ 1, 4 ],
  });

  test.identical( m.offset, 1 );
  test.identical( m.dims, [ 5, 2 ] );
  test.identical( m.dimsEffective, [ 5, 2 ] );
  test.identical( m.strides, [ 1, 4 ] );
  test.identical( m.stridesEffective, [ 1, 4 ] );
  test.identical( m.toLong(), new I32x([ 1, 2, 3, 4, 5, 5, 6, 7, 8, 9 ]) );
  logger.log( m.toStr() );

  /* */

  test.case = 'scalarsPerRow : 2, strides : [ 1, 4 ], dims : [ 6, 2 ]';

  var m = new _.Matrix
  ({
    buffer : new I32x([ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]),
    offset : 1,
    scalarsPerRow : 2,
    strides : [ 1, 4 ],
    dims : [ 6, 2 ],
  });

  test.identical( m.offset, 1 );
  test.identical( m.dims, [ 6, 2 ] );
  test.identical( m.dimsEffective, [ 6, 2 ] );
  test.identical( m.strides, [ 1, 4 ] );
  test.identical( m.stridesEffective, [ 1, 4 ] );
  test.identical( m.toLong(), new I32x([ 1, 2, 3, 4, 5, 6, 5, 6, 7, 8, 9, 10 ]) );
  logger.log( m.toStr() );

  /* */

  test.case = 'scalarsPerRow : 1, strides : [ 1, 4 ]';

  var m = new _.Matrix
  ({
    buffer : new I32x([ 0, 1 ]),
    offset : 1,
    scalarsPerRow : 1,
    strides : [ 1, 4 ],
  });

  test.identical( m.offset, 1 );
  test.identical( m.dims, [ 1, 1 ] );
  test.identical( m.dimsEffective, [ 1, 1 ] );
  test.identical( m.strides, [ 1, 4 ] );
  test.identical( m.stridesEffective, [ 1, 4 ] );
  test.identical( m.toLong(), new I32x([ 1 ]) );
  logger.log( m.toStr() );

  /* - */

}

//

function clone( test )
{

  /* */

  test.case = 'clone';

  var buffer = new F32x([ 1, 2, 3, 4, 5, 6 ]);
  var a = new _.Matrix
  ({
    buffer,
    dims : [ 3, 2 ],
    inputRowMajor : 0,
  });

  var b = a.clone();
  test.identical( a, b );
  test.is( a.buffer !== b.buffer );
  test.is( a.buffer === buffer );

  test.identical( a.size, 24 );
  test.identical( a.sizeOfElementStride, 12 );
  test.identical( a.sizeOfElement, 12 );
  test.identical( a.sizeOfCol, 12 );
  test.identical( a.sizeOfRow, 8 );
  test.identical( a.dims, [ 3, 2 ] );
  test.identical( a.length, 2 );

  test.identical( a.stridesEffective, [ 1, 3 ] );
  test.identical( a.strideOfElement, 3 );
  test.identical( a.strideOfCol, 3 );
  test.identical( a.strideInCol, 1 );
  test.identical( a.strideOfRow, 1 );
  test.identical( a.strideInRow, 3 );

  /* */

}

//

function cloneSerializing( test )
{

  /* */

  test.case = 'inputRowMajor : 0';

  var a = new _.Matrix
  ({
    buffer : new F32x([ 0, 1, 2, 3, 4, 5, 6, 7 ]),
    offset : 1,
    scalarsPerElement : 3,
    inputRowMajor : 0,
    strides : [ 2, 6 ],
    dims : [ 3, 1 ],
  });

  var cloned = a.cloneSerializing();

  var exp =
  {
    "data" :
    {
      "dims" : [ 3, 1 ],
      "buffer" : `--buffer-->0<--buffer--`,
      "offset" : 0,
      "strides" : [ 1, 3 ]
    },
    "descriptorsMap" :
    {
      "--buffer-->0<--buffer--" :
      {
        "bufferConstructorName" : `F32x`,
        "sizeOfScalar" : 4,
        "offset" : 0,
        "size" : 12,
        "index" : 0
      }
    },
    "buffer" : ( new U8x([ 0x0, 0x0, 0x80, 0x3f, 0x0, 0x0, 0x40, 0x40, 0x0, 0x0, 0xa0, 0x40 ]) ).buffer
  }

  test.identical( cloned, exp );

  test.description = 'deserializing clone';

  var b = new _.Matrix({ buffer : new F32x(), inputRowMajor : true });
  b.copyDeserializing( cloned );
  test.identical( b, a );
  test.is( a.buffer !== b.buffer );

  test.identical( a.buffer.length, 8 );
  test.identical( a.size, 12 );
  test.identical( a.sizeOfElement, 12 );
  test.identical( a.sizeOfCol, 12 );
  test.identical( a.sizeOfRow, 4 );
  test.identical( a.dims, [ 3, 1 ] );
  test.identical( a.length, 1 );
  test.identical( a.offset, 1 );

  test.identical( a.strides, [ 2, 6 ] );
  test.identical( a.stridesEffective, [ 2, 6 ] );
  test.identical( a.strideOfElement, 6 );
  test.identical( a.strideOfCol, 6 );
  test.identical( a.strideInCol, 2 );
  test.identical( a.strideOfRow, 2 );
  test.identical( a.strideInRow, 6 );

  test.identical( b.buffer.length, 3 );
  test.identical( b.size, 12 );
  test.identical( b.sizeOfElement, 12 );
  test.identical( b.sizeOfCol, 12 );
  test.identical( b.sizeOfRow, 4 );
  test.identical( b.dims, [ 3, 1 ] );
  test.identical( b.length, 1 );
  test.identical( b.offset, 0 );

  test.identical( b.strides, [ 1, 3 ] );
  test.identical( b.stridesEffective, [ 1, 3 ] );
  test.identical( b.strideOfElement, 3 );
  test.identical( b.strideOfCol, 3 );
  test.identical( b.strideInCol, 1 );
  test.identical( b.strideOfRow, 1 );
  test.identical( b.strideInRow, 3 );

  /* */

  test.case = 'inputRowMajor : 1';

  var a = new _.Matrix
  ({
    buffer : new F32x([ 0, 1, 2, 3, 4, 5, 6, 7 ]),
    offset : 1,
    scalarsPerElement : 3,
    inputRowMajor : 1,
    strides : [ 2, 6 ],
  });

  var cloned = a.cloneSerializing();

  var exp =
  {
    "data" :
    {
      "dims" : [ 3, 1 ],
      "buffer" : `--buffer-->0<--buffer--`,
      "offset" : 0,
      "strides" : [ 1, 3 ],
    },
    "descriptorsMap" :
    {
      "--buffer-->0<--buffer--" :
      {
        "bufferConstructorName" : `F32x`,
        "sizeOfScalar" : 4,
        "offset" : 0,
        "size" : 12,
        "index" : 0
      }
    },
    "buffer" : ( new U8x([ 0x0, 0x0, 0x80, 0x3f, 0x0, 0x0, 0x40, 0x40, 0x0, 0x0, 0xa0, 0x40 ]) ).buffer
  }

  test.identical( cloned, exp );

  test.description = 'deserializing clone';

  var b = new _.Matrix({ buffer : new F32x(), inputRowMajor : true });
  b.copyDeserializing( cloned );
  test.identical( b, a );
  test.is( a.buffer !== b.buffer );

  test.identical( a.buffer.length, 8 );
  test.identical( a.size, 12 );
  test.identical( a.sizeOfElement, 12 );
  test.identical( a.sizeOfCol, 12 );
  test.identical( a.sizeOfRow, 4 );
  test.identical( a.dims, [ 3, 1 ] );
  test.identical( a.length, 1 );
  test.identical( a.offset, 1 );

  test.identical( a.strides, [ 2, 6 ] );
  test.identical( a.stridesEffective, [ 2, 6 ] );
  test.identical( a.strideOfElement, 6 );
  test.identical( a.strideOfCol, 6 );
  test.identical( a.strideInCol, 2 );
  test.identical( a.strideOfRow, 2 );
  test.identical( a.strideInRow, 6 );

  test.identical( b.buffer.length, 3 );
  test.identical( b.size, 12 );
  test.identical( b.sizeOfElement, 12 );
  test.identical( b.sizeOfCol, 12 );
  test.identical( b.sizeOfRow, 4 );
  test.identical( b.dims, [ 3, 1 ] );
  test.identical( b.length, 1 );
  test.identical( b.offset, 0 );

  test.identical( b.strides, [ 1, 3 ] );
  test.identical( b.stridesEffective, [ 1, 3 ] );
  test.identical( b.strideOfElement, 3 );
  test.identical( b.strideOfCol, 3 );
  test.identical( b.strideInCol, 1 );
  test.identical( b.strideOfRow, 1 );
  test.identical( b.strideInRow, 3 );

  /* */

}

// --
// exporter
// --

function copyTransposing( test )
{

  /* */

  test.case = 'inputRowMajor : 1';

  var buffer =
  [
    -1, -1,
    1, 2,
    3, 4,
    5, 6,
    11, 11,
  ]
  var obuffer = buffer.slice();

  var m = _.Matrix.Make([ 3, 2 ]);

  m.copy
  ({
    buffer,
    offset : 2,
    dims : [ 3, 2 ],
    inputRowMajor : 1,
  });

  console.log( `m\n${m.toStr()}` );

  test.identical( m.buffer, obuffer );
  test.identical( m.dims, [ 3, 2 ] );
  test.identical( m.dimsEffective, [ 3, 2 ] );
  test.identical( m.strides, null );
  test.identical( m.stridesEffective, [ 2, 1 ] );

  test.is( m.buffer === buffer );

  var exp = _.Matrix
  ({
    dims : [ 3, 2 ],
    strides : [ 2, 1 ],
    buffer :
    [
      1, 2,
      3, 4,
      5, 6
    ]
  });

  console.log( `m\n${m.toStr()}` );
  console.log( `exp\n${exp.toStr()}` );

  test.identical( m, exp );

  /* */

  test.case = 'inputRowMajor : 0';

  var buffer =
  [
    -1, -1,
    1, 2,
    3, 4,
    5, 6,
    11, 11,
  ]
  var obuffer = buffer.slice();

  var m = _.Matrix.Make([ 3, 2 ]);

  m.copy
  ({
    buffer,
    offset : 2,
    dims : [ 3, 2 ],
    inputRowMajor : 0,
  });

  console.log( `m\n${m.toStr()}` );

  test.identical( m.buffer, obuffer );
  test.identical( m.dims, [ 3, 2 ] );
  test.identical( m.dimsEffective, [ 3, 2 ] );
  test.identical( m.strides, null );
  test.identical( m.stridesEffective, [ 1, 3 ] );

  test.is( m.buffer === buffer );

  var exp = _.Matrix
  ({
    dims : [ 3, 2 ],
    strides : [ 2, 1 ],
    buffer :
    [
      1, 4,
      2, 5,
      3, 6
    ]
  });

  console.log( `m\n${m.toStr()}` );
  console.log( `exp\n${exp.toStr()}` );

  test.identical( m, exp );

  /* */

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () =>
  {
    var m = _.Matrix.Make([ 3, 2 ]);
    m.copy
    ({
      buffer,
      dims : [ 3, 2 ],
    });
  });

}

//

function copyClone( test )
{

  /* */

  test.case = 'clone 3x3';

  var m1 = _.Matrix.MakeIdentity([ 3, 3 ]);
  m2 = m1.clone();

  test.identical( m1, m2 );
  test.is( m1.buffer !== m2.buffer );

  /* */

  test.case = 'clone 0x0';

  var m1 = _.Matrix.MakeIdentity([ 0, 0 ]);
  m2 = m1.clone();

  test.identical( m2.dims, [ 0, 0 ] );
  test.identical( m1, m2 );
  test.is( m1.buffer !== m2.buffer );

  /* */

  test.case = 'clone 3x0';

  var m1 = _.Matrix.MakeIdentity([ 3, 0 ]);
  m2 = m1.clone();

  test.identical( m2.dims, [ 3, 0 ] );
  test.identical( m1, m2 );
  test.is( m1.buffer !== m2.buffer );

  /* */

  test.case = 'clone 0x3';

  var m1 = _.Matrix.MakeIdentity([ 0, 3 ]);
  m2 = m1.clone();

  test.identical( m2.dims, [ 0, 3 ] );
  test.identical( m1, m2 );
  test.is( m1.buffer !== m2.buffer );

  /* */

  test.case = 'copy 3x3';

  var m1 = _.Matrix.MakeIdentity([ 3, 3 ]);
  var m2 = _.Matrix.MakeZero([ 3, 3 ]);
  m2.copy( m1 );

  test.identical( m1, m2 );
  test.is( m1.buffer !== m2.buffer );

  /* */

  test.case = 'copy 3x3 itself';

  var exp = _.Matrix.MakeIdentity([ 3, 3 ]);
  var m1 = _.Matrix.MakeIdentity([ 3, 3 ]);
  m1.copy( m1 );

  test.identical( m1, exp );

  /* */

  test.case = 'copy 0x0';

  var m1 = _.Matrix.MakeIdentity([ 0, 0 ]);
  var m2 = _.Matrix.MakeZero([ 0, 0 ]);
  m2.copy( m1 );

  test.identical( m2.dims, [ 0, 0 ] );
  test.identical( m1, m2 );
  test.is( m1.buffer !== m2.buffer );

  /* */

  test.case = 'copy 3x0';

  var m1 = _.Matrix.MakeIdentity([ 3, 0 ]);
  var m2 = _.Matrix.MakeZero([ 3, 0 ]);
  m2.copy( m1 );

  test.identical( m2.dims, [ 3, 0 ] );
  test.identical( m1, m2 );
  test.is( m1.buffer !== m2.buffer );

  /* */

  test.case = 'copy 0x3';

  var m1 = _.Matrix.MakeIdentity([ 0, 3 ]);
  var m2 = _.Matrix.MakeZero([ 0, 3 ]);
  m2.copy( m1 );

  test.identical( m2.dims, [ 0, 3 ] );
  test.identical( m1, m2 );
  test.is( m1.buffer !== m2.buffer );

  /* */

  test.case = 'copy 0x0 itself';

  var exp = _.Matrix.MakeIdentity([ 0, 0 ]);
  var m1 = _.Matrix.MakeIdentity([ 0, 0 ]);
  m1.copy( m1 );

  test.identical( m1, exp );
  test.identical( m1.dims, [ 0, 0 ] );

}

//

function CopyToSrcIsNotMatrix( test )
{
  _.vectorAdapter.contextsForTesting({ onEach : act });

  /* - */

  function act( a )
  {
    test.open( 'dst is not a Matrix' );

    test.case = `dst - empty long ${ a.format }, src - empty long ${ a.format }`;
    var dst = a.longMake([]);
    var src = a.longMake([]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.longMake([]);
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - empty vector ${ a.format }, src - empty long ${ a.format }`;
    var dst = a.vadMake([]);
    var src = a.longMake([]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.vadMake([]);
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - empty vector ${ a.format }, src - empty vector ${ a.format }`;
    var dst = a.vadMake([]);
    var src = a.vadMake([]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.vadMake([]);
    test.identical( got, exp );
    test.is( got === dst );

    /* */

    test.case = `dst - long ${ a.format }, src - empty long ${ a.format }`;
    var dst = a.longMake([ 1, 0, -1 ]);
    var src = a.longMake([]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.longMake([ 0, 0, 0 ]);
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - vector ${ a.format }, src - empty long ${ a.format }`;
    var dst = a.vadMake([ 1, 0, -1 ]);
    var src = a.longMake([]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.vadMake([ 0, 0, 0 ]);
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - vector ${ a.format }, src - empty vector ${ a.format }`;
    var dst = a.vadMake([ 1, 0, -1 ]);
    var src = a.vadMake([]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.vadMake([ 0, 0, 0 ]);
    test.identical( got, exp );
    test.is( got === dst );

    /* */

    test.case = `dst - long ${ a.format }, src - long ${ a.format }, dst.length === src.length`;
    var dst = a.longMake([ 1, 0, -1 ]);
    var src = a.longMake([ 2, 2, 2 ]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.longMake([ 2, 2, 2 ]);
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - vector ${ a.format }, src - long ${ a.format }, dst.length === src.length`;
    var dst = a.vadMake([ 1, 0, -1 ]);
    var src = a.longMake([ 2, 2, 2 ]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.vadMake([ 2, 2, 2 ]);
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - vector ${ a.format }, src - vector ${ a.format }, dst.length === src.length`;
    var dst = a.vadMake([ 1, 0, -1 ]);
    var src = a.vadMake([ 2, 2, 2 ]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.vadMake([ 2, 2, 2 ]);
    test.identical( got, exp );
    test.is( got === dst );

    /* */

    test.case = `dst - long ${ a.format }, src - long ${ a.format }, dst.length > src.length`;
    var dst = a.longMake([ 1, 0, -1 ]);
    var src = a.longMake([ 2, 2 ]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.longMake([ 2, 2, 0 ]);
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - vector ${ a.format }, src - long ${ a.format }, dst.length > src.length`;
    var dst = a.vadMake([ 1, 0, -1 ]);
    var src = a.longMake([ 2, 2 ]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.vadMake([ 2, 2, 0 ]);
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - vector ${ a.format }, src - vector ${ a.format }, dst.length > src.length`;
    var dst = a.vadMake([ 1, 0, -1 ]);
    var src = a.vadMake([ 2, 2 ]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.vadMake([ 2, 2, 0 ]);
    test.identical( got, exp );
    test.is( got === dst );

    test.close( 'dst is not a Matrix' );

    /* - */

    test.open( 'dst is a column Matrix' );

    test.case = `dst - matrix from empty long ${ a.format }, src - empty long ${ a.format }`;
    var dst = _.Matrix.MakeCol( a.longMake([]) );
    var src = a.longMake([]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.MakeCol( a.longMake([]) );
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from empty vector ${ a.format }, src - empty long ${ a.format }`;
    var dst = _.Matrix.MakeCol( a.vadMake([]) );
    var src = a.longMake([]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.MakeCol( a.vadMake([]) );
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from empty vector ${ a.format }, src - empty vector ${ a.format }`;
    var dst = _.Matrix.MakeCol( a.vadMake([]) );
    var src = a.vadMake([]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.MakeCol( a.vadMake([]) );
    test.identical( got, exp );
    test.is( got === dst );

    /* */

    test.case = `dst - matrix from long ${ a.format }, src - empty long ${ a.format }`;
    var dst = _.Matrix.MakeCol( a.longMake([ 1, 0, -1 ]) );
    var src = a.longMake([]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.MakeCol( a.longMake([ 0, 0, 0 ]) );
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - empty long ${ a.format }`;
    var dst = _.Matrix.MakeCol( a.vadMake([ 1, 0, -1 ]) );
    var src = a.longMake([]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.MakeCol( a.vadMake([ 0, 0, 0 ]) );
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - empty vector ${ a.format }`;
    var dst = _.Matrix.MakeCol( a.vadMake([ 1, 0, -1 ]) );
    var src = a.vadMake([]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.MakeCol( a.vadMake([ 0, 0, 0 ]) );
    test.identical( got, exp );
    test.is( got === dst );

    /* */

    test.case = `dst - matrix from long ${ a.format }, src - long ${ a.format }, dst.length === src.length`;
    var dst = _.Matrix.MakeCol( a.longMake([ 1, 0, -1 ]) );
    var src = a.longMake([ 2, 2, 2 ]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.MakeCol( a.longMake([ 2, 2, 2 ]) );
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - long ${ a.format }, dst.length === src.length`;
    var dst = _.Matrix.MakeCol( a.vadMake([ 1, 0, -1 ]) );
    var src = a.longMake([ 2, 2, 2 ]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.MakeCol( a.vadMake([ 2, 2, 2 ]) );
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - vector ${ a.format }, dst.length === src.length`;
    var dst = _.Matrix.MakeCol( a.vadMake([ 1, 0, -1 ]) );
    var src = a.vadMake([ 2, 2, 2 ]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.MakeCol( a.vadMake([ 2, 2, 2 ]) );
    test.identical( got, exp );
    test.is( got === dst );

    /* */

    test.case = `dst - matrix from long ${ a.format }, src - long ${ a.format }, dst.length > src.length`;
    var dst = _.Matrix.MakeCol( a.longMake([ 1, 0, -1 ]) );
    var src = a.longMake([ 2, 2 ]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.MakeCol( a.longMake([ 2, 2, 0 ]) );
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - long ${ a.format }, dst.length > src.length`;
    var dst = _.Matrix.MakeCol( a.vadMake([ 1, 0, -1 ]) );
    var src = a.longMake([ 2, 2 ]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.MakeCol( a.vadMake([ 2, 2, 0 ]) );
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - vector ${ a.format }, dst.length > src.length`;
    var dst = _.Matrix.MakeCol( a.vadMake([ 1, 0, -1 ]) );
    var src = a.vadMake([ 2, 2 ]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.MakeCol( a.vadMake([ 2, 2, 0 ]) );
    test.identical( got, exp );
    test.is( got === dst );

    test.close( 'dst is a column Matrix' );

    /* - */

    test.open( 'dst is a column Matrix - second dimension is Infinity' );

    test.case = `dst - matrix from long ${ a.format }, src - empty long ${ a.format }`;
    var dst = _.Matrix.Make([ 3, Infinity ]).copy( a.longMake([ 1, 0, -1 ]) );
    var src = a.longMake([]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 3, Infinity ]).copy( a.longMake([ 0, 0, 0 ]) );
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - empty long ${ a.format }`;
    var dst = _.Matrix.Make([ 3, Infinity ]).copy( a.vadMake([ 1, 0, -1 ]) );
    var src = a.longMake([]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 3, Infinity ]).copy( a.vadMake([ 0, 0, 0 ]) );
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - empty vector ${ a.format }`;
    var dst = _.Matrix.Make([ 3, Infinity ]).copy( a.vadMake([ 1, 0, -1 ]) );
    var src = a.vadMake([]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 3, Infinity ]).copy( a.vadMake([ 0, 0, 0 ]) );
    test.identical( got, exp );
    test.is( got === dst );

    /* */

    test.case = `dst - matrix from long ${ a.format }, src - long ${ a.format }, dst.length === src.length`;
    var dst = _.Matrix.Make([ 3, Infinity ]).copy( a.longMake([ 1, 0, -1 ]) );
    var src = a.longMake([ 2, 2, 2 ]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 3, Infinity ]).copy( a.longMake([ 2, 2, 2 ]) );
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - long ${ a.format }, dst.length === src.length`;
    var dst = _.Matrix.Make([ 3, Infinity ]).copy( a.vadMake([ 1, 0, -1 ]) );
    var src = a.longMake([ 2, 2, 2 ]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 3, Infinity ]).copy( a.vadMake([ 2, 2, 2 ]) );
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - vector ${ a.format }, dst.length === src.length`;
    var dst = _.Matrix.Make([ 3, Infinity ]).copy( a.vadMake([ 1, 0, -1 ]) );
    var src = a.vadMake([ 2, 2, 2 ]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 3, Infinity ]).copy( a.vadMake([ 2, 2, 2 ]) );
    test.identical( got, exp );
    test.is( got === dst );

    /* */

    test.case = `dst - matrix from long ${ a.format }, src - long ${ a.format }, dst.length > src.length`;
    var dst = _.Matrix.Make([ 3, Infinity ]).copy( a.longMake([ 1, 0, -1 ]) );
    var src = a.longMake([ 2, 2 ]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 3, Infinity ]).copy( a.longMake([ 2, 2, 0 ]) );
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - long ${ a.format }, dst.length > src.length`;
    var dst = _.Matrix.Make([ 3, Infinity ]).copy( a.vadMake([ 1, 0, -1 ]) );
    var src = a.longMake([ 2, 2 ]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 3, Infinity ]).copy( a.vadMake([ 2, 2, 0 ]) );
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - vector ${ a.format }, dst.length > src.length`;
    var dst = _.Matrix.Make([ 3, Infinity ]).copy( a.vadMake([ 1, 0, -1 ]) );
    var src = a.vadMake([ 2, 2 ]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 3, Infinity ]).copy( a.vadMake([ 2, 2, 0 ]) );
    test.identical( got, exp );
    test.is( got === dst );

    test.close( 'dst is a column Matrix - second dimension is Infinity' );

    /* - */

    test.open( 'dst is a 2D Matrix' );

    test.case = `dst - matrix from long ${ a.format }, src - empty long ${ a.format }`;
    var dst = _.Matrix.Make([ 3, 2 ]).copy( a.longMake
    ([
      1, 0,
      2, 1,
      3, -1
    ]));
    var src = a.longMake([]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 3, 2 ]).copy( a.longMake
    ([
      0, 0,
      0, 0,
      0, 0
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - empty long ${ a.format }`;
    var dst = _.Matrix.Make([ 3, 2 ]).copy( a.vadMake
    ([
      1, 0,
      2, 1,
      3, -1
    ]));
    var src = a.longMake([]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 3, 2 ]).copy( a.vadMake
    ([
      0, 0,
      0, 0,
      0, 0
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - empty vector ${ a.format }`;
    var dst = _.Matrix.Make([ 3, 2 ]).copy( a.vadMake
    ([
      1, 0,
      2, 1,
      3, -1
    ]));
    var src = a.vadMake([]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 3, 2 ]).copy( a.vadMake
    ([
      0, 0,
      0, 0,
      0, 0
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    /* */

    test.case = `dst - matrix from long ${ a.format }, src - long ${ a.format }, dst.length > src.length`;
    var dst = _.Matrix.Make([ 3, 2 ]).copy( a.longMake
    ([
      1, 0,
      2, 1,
      3, -1
    ]));
    var src = a.longMake([ 2, 2 ]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 3, 2 ]).copy( a.longMake
    ([
      2, 0,
      2, 0,
      0, 0
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - long ${ a.format }, dst.length > src.length`;
    var dst = _.Matrix.Make([ 3, 2 ]).copy( a.vadMake
    ([
      1, 0,
      2, 1,
      3, -1
    ]));
    var src = a.longMake([ 2, 2 ]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 3, 2 ]).copy( a.vadMake
    ([
      2, 0,
      2, 0,
      0, 0
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - vector ${ a.format }, dst.length > src.length`;
    var dst = _.Matrix.Make([ 3, 2 ]).copy( a.vadMake
    ([
      1, 0,
      2, 1,
      3, -1
    ]));
    var src = a.vadMake([ 2, 2 ]);
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 3, 2 ]).copy( a.vadMake
    ([
      2, 0,
      2, 0,
      0, 0
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.close( 'dst is a 2D Matrix' );
  }

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix.CopyTo() );

  test.case = 'not enough arguments';
  test.shouldThrowErrorSync( () => _.Matrix.CopyTo( [ 1, 2 ] ) );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.Matrix.CopyTo( [ 1, 2 ], [ 3, 4 ], [ 5, 6 ] ) );

  test.case = 'wrong type of dst';
  test.shouldThrowErrorSync( () => _.Matrix.CopyTo( null, [ 1, 2 ] ) );

  test.case = 'wrong type of src';
  test.shouldThrowErrorSync( () => _.Matrix.CopyTo( [ 1, 2 ], { 0 : 1, 1 : 0 } ) );

  test.case = 'dst dims value is less than src dims value';
  test.shouldThrowErrorSync( () => _.Matrix.CopyTo( _.Matrix.MakeRow([ 1, 2 ]), [ 0, 0 ] ) );
  test.shouldThrowErrorSync( () => _.Matrix.CopyTo( _.Matrix.Make([ 1, 2 ]), _.Matrix.Make([ 2, 3 ]) ) );

  test.case = 'different dims length in dst and src';
  test.shouldThrowErrorSync( () => _.Matrix.CopyTo( _.Matrix.Make([ 1, 2, 3 ]), [ 0, 0 ] ) );
  test.shouldThrowErrorSync( () => _.Matrix.CopyTo( _.Matrix.Make([ 1, 2, 3 ]), _.Matrix.Make([ 2, 3 ]) ) );
}

//

function CopyToSrcIsMatrix( test )
{
  _.vectorAdapter.contextsForTesting({ onEach : act });

  /* - */

  function act( a )
  {
    test.open( 'dst is not a Matrix' );

    test.case = `dst - empty long ${ a.format }, src - from empty long ${ a.format }`;
    var dst = a.longMake([]);
    var src = _.Matrix.MakeCol( a.longMake([]) );
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.longMake([]);
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - empty vector ${ a.format }, src - from empty long ${ a.format }`;
    var dst = a.vadMake([]);
    var src = _.Matrix.MakeCol( a.longMake([]) );
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.vadMake([]);
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - empty vector ${ a.format }, src - from empty vector ${ a.format }`;
    var dst = a.vadMake([]);
    var src = _.Matrix.MakeCol( a.vadMake([]) );
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.vadMake([]);
    test.identical( got, exp );
    test.is( got === dst );

    /* */

    test.case = `dst - long ${ a.format }, src - from empty long ${ a.format }`;
    var dst = a.longMake([ 1, 0, -1 ]);
    var src = _.Matrix.MakeCol( a.longMake([]) );
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.longMake([ 0, 0, 0 ]);
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - vector ${ a.format }, src - from empty long ${ a.format }`;
    var dst = a.vadMake([ 1, 0, -1 ]);
    var src = _.Matrix.MakeCol( a.longMake([]) );
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.vadMake([ 0, 0, 0 ]);
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - vector ${ a.format }, src - from empty vector ${ a.format }`;
    var dst = a.vadMake([ 1, 0, -1 ]);
    var src = _.Matrix.MakeCol( a.vadMake([]) );
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.vadMake([ 0, 0, 0 ]);
    test.identical( got, exp );
    test.is( got === dst );

    /* */

    test.case = `dst - long ${ a.format }, src - from long ${ a.format }, dst.length === src.length`;
    var dst = a.longMake([ 1, 0, -1 ]);
    var src = _.Matrix.MakeCol( a.longMake([ 2, 2, 2 ]) );
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.longMake([ 2, 2, 2 ]);
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - vector ${ a.format }, src - from long ${ a.format }, dst.length === src.length`;
    var dst = a.vadMake([ 1, 0, -1 ]);
    var src = _.Matrix.MakeCol( a.longMake([ 2, 2, 2 ]) );
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.vadMake([ 2, 2, 2 ]);
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - vector ${ a.format }, src - from vector ${ a.format }, dst.length === src.length`;
    var dst = a.vadMake([ 1, 0, -1 ]);
    var src = _.Matrix.MakeCol( a.vadMake([ 2, 2, 2 ]) );
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.vadMake([ 2, 2, 2 ]);
    test.identical( got, exp );
    test.is( got === dst );

    /* */

    test.case = `dst - long ${ a.format }, src - from long ${ a.format }, dst.length > src.length`;
    var dst = a.longMake([ 1, 0, -1 ]);
    var src = _.Matrix.MakeCol( a.longMake([ 2, 2 ]) );
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.longMake([ 2, 2, 0 ]);
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - vector ${ a.format }, src - from long ${ a.format }, dst.length > src.length`;
    var dst = a.vadMake([ 1, 0, -1 ]);
    var src = _.Matrix.MakeCol( a.longMake([ 2, 2 ]) );
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.vadMake([ 2, 2, 0 ]);
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - vector ${ a.format }, src - from vector ${ a.format }, dst.length > src.length`;
    var dst = a.vadMake([ 1, 0, -1 ]);
    var src = _.Matrix.MakeCol( a.vadMake([ 2, 2 ]) );
    var got = _.Matrix.CopyTo( dst, src );
    var exp = a.vadMake([ 2, 2, 0 ]);
    test.identical( got, exp );
    test.is( got === dst );

    test.close( 'dst is not a Matrix' );

    /* - */

    test.open( 'dst is a 2D Matrix' );

    test.case = `dst - matrix from long ${ a.format }, src - from empty long ${ a.format }`;
    var dst = _.Matrix.Make([ 3, 2 ]).copy( a.longMake
    ([
      1, 0,
      2, 1,
      3, -1
    ]));
    var src = _.Matrix.MakeCol( a.longMake([]) );
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 3, 2 ]).copy( a.longMake
    ([
      0, 0,
      0, 0,
      0, 0
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from empty long ${ a.format }`;
    var dst = _.Matrix.Make([ 3, 2 ]).copy( a.vadMake
    ([
      1, 0,
      2, 1,
      3, -1
    ]));
    var src = _.Matrix.MakeCol( a.longMake([]) );
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 3, 2 ]).copy( a.vadMake
    ([
      0, 0,
      0, 0,
      0, 0
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from empty vector ${ a.format }`;
    var dst = _.Matrix.Make([ 3, 2 ]).copy( a.vadMake
    ([
      1, 0,
      2, 1,
      3, -1
    ]));
    var src = _.Matrix.MakeCol( a.vadMake([]) );
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 3, 2 ]).copy( a.vadMake
    ([
      0, 0,
      0, 0,
      0, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    /* */

    test.case = `dst - matrix from long ${ a.format }, src - from long ${ a.format }, dst.dims values is bigger than src.dims.values`;
    var dst = _.Matrix.Make([ 3, 3 ]).copy( a.longMake
    ([
      1, 0, 5,
      2, 1, 5,
      3, -1, 5,
    ]));
    var src = _.Matrix.Make([ 2, 2 ]).copy( a.longMake
    ([
      3, 3,
      3, 3
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 3, 3 ]).copy( a.longMake
    ([
      3, 3, 0,
      3, 3, 0,
      0, 0, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from long ${ a.format }, dst.dims values is bigger than src.dims.values`;
    var dst = _.Matrix.Make([ 3, 3 ]).copy( a.vadMake
    ([
      1, 0, 5,
      2, 1, 5,
      3, -1, 5,
    ]));
    var src = _.Matrix.Make([ 2, 2 ]).copy( a.longMake
    ([
      3, 3,
      3, 3
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 3, 3 ]).copy( a.vadMake
    ([
      3, 3, 0,
      3, 3, 0,
      0, 0, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from vector ${ a.format }, dst.dims values is bigger than src.dims.values`;
    var dst = _.Matrix.Make([ 3, 3 ]).copy( a.vadMake
    ([
      1, 0, 5,
      2, 1, 5,
      3, -1, 5,
    ]));
    var src = _.Matrix.Make([ 2, 2 ]).copy( a.vadMake
    ([
      3, 3,
      3, 3
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 3, 3 ]).copy( a.vadMake
    ([
      3, 3, 0,
      3, 3, 0,
      0, 0, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    /* */

    test.case = `dst - matrix from long ${ a.format }, src - from long ${ a.format }, dst.dims values is identical to src.dims.values`;
    var dst = _.Matrix.Make([ 2, 3 ]).copy( a.longMake
    ([
      1, 0, 2,
      1, 3, -1,
    ]));
    var src = _.Matrix.Make([ 2, 3 ]).copy( a.longMake
    ([
      3, 3, 3,
      3, 3, 3,
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 2, 3 ]).copy( a.longMake
    ([
      3, 3, 3,
      3, 3, 3,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from long ${ a.format }, dst.dims values is identical to src.dims.values`;
    var dst = _.Matrix.Make([ 2, 3 ]).copy( a.vadMake
    ([
      1, 0, 2,
      1, 3, -1,
    ]));
    var src = _.Matrix.Make([ 2, 3 ]).copy( a.longMake
    ([
      3, 3, 3,
      3, 3, 3,
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 2, 3 ]).copy( a.vadMake
    ([
      3, 3, 3,
      3, 3, 3,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from vector ${ a.format }, dst.dims values is identical to src.dims.values`;
    var dst = _.Matrix.Make([ 2, 3 ]).copy( a.vadMake
    ([
      1, 0, 2,
      1, 3, -1,
    ]));
    var src = _.Matrix.Make([ 2, 3 ]).copy( a.vadMake
    ([
      3, 3, 3,
      3, 3, 3,
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 2, 3 ]).copy( a.vadMake
    ([
      3, 3, 3,
      3, 3, 3,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.close( 'dst is a 2D Matrix' );

    /* - */

    test.open( 'dst is a 3D Matrix' );

    test.case = `dst - matrix from long ${ a.format }, src - from empty long ${ a.format }`;
    var dst = _.Matrix.Make([ 2, 3, 2 ]).copy( a.longMake
    ([
      1, 0, 1,
      2, 1, 2,
      3, -1, 3,
      4, 1, 4,
    ]));
    var src = _.Matrix.Make([ 0, 0, 0 ]).copy( a.longMake([]) );
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 2, 3, 2 ]).copy( a.longMake
    ([
      0, 0, 0,
      0, 0, 0,
      0, 0, 0,
      0, 0, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from empty long ${ a.format }`;
    var dst = _.Matrix.Make([ 2, 3, 2 ]).copy( a.vadMake
    ([
      1, 0, 1,
      2, 1, 2,
      3, -1, 3,
      4, 1, 4,
    ]));
    var src = _.Matrix.Make([ 0, 0, 0 ]).copy( a.longMake([]) );
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 2, 3, 2 ]).copy( a.vadMake
    ([
      0, 0, 0,
      0, 0, 0,
      0, 0, 0,
      0, 0, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from empty vector ${ a.format }`;
    var dst = _.Matrix.Make([ 2, 3, 2 ]).copy( a.vadMake
    ([
      1, 0, 1,
      2, 1, 2,
      3, -1, 3,
      4, 1, 4,
    ]));
    var src = _.Matrix.Make([ 0, 0, 0 ]).copy( a.vadMake([]) );
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 2, 3, 2 ]).copy( a.vadMake
    ([
      0, 0, 0,
      0, 0, 0,
      0, 0, 0,
      0, 0, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    /* */

    test.case = `dst - matrix from long ${ a.format }, src - from long ${ a.format }, dst.dims values is bigger than src.dims.values`;
    var dst = _.Matrix.Make([ 2, 3, 2 ]).copy( a.longMake
    ([
      1, 0, 1,
      2, 1, 2,
      3, -1, 3,
      4, 1, 4,
    ]));
    var src = _.Matrix.Make([ 2, 2, 2 ]).copy( a.longMake
    ([
      3, 3,
      3, 3,
      5, 5,
      5, 5,
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 2, 3, 2 ]).copy( a.longMake
    ([
      3, 3, 0,
      3, 3, 0,
      5, 5, 0,
      5, 5, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from long ${ a.format }, dst.dims values is bigger than src.dims.values`;
    var dst = _.Matrix.Make([ 2, 3, 2 ]).copy( a.vadMake
    ([
      1, 0, 1,
      2, 1, 2,
      3, -1, 3,
      4, 1, 4,
    ]));
    var src = _.Matrix.Make([ 2, 2, 2 ]).copy( a.longMake
    ([
      3, 3,
      3, 3,
      5, 5,
      5, 5,
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 2, 3, 2 ]).copy( a.vadMake
    ([
      3, 3, 0,
      3, 3, 0,
      5, 5, 0,
      5, 5, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from vector ${ a.format }, dst.dims values is bigger than src.dims.values`;
    var dst = _.Matrix.Make([ 2, 3, 2 ]).copy( a.vadMake
    ([
      1, 0, 1,
      2, 1, 2,
      3, -1, 3,
      4, 1, 4,
    ]));
    var src = _.Matrix.Make([ 2, 2, 2 ]).copy( a.vadMake
    ([
      3, 3,
      3, 3,
      5, 5,
      5, 5,
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 2, 3, 2 ]).copy( a.vadMake
    ([
      3, 3, 0,
      3, 3, 0,
      5, 5, 0,
      5, 5, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    /* */

    test.case = `dst - matrix from long ${ a.format }, src - from long ${ a.format }, dst.dims and src.dims have Infinity`;
    var dst = _.Matrix.Make([ 2, 3, Infinity ]).copy( a.longMake
    ([
      1, 0, 1,
      2, 1, 2,
    ]));
    var src = _.Matrix.Make([ 2, 2, Infinity ]).copy( a.longMake
    ([
      3, 3,
      5, 5,
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 2, 3, Infinity ]).copy( a.longMake
    ([
      3, 3, 0,
      5, 5, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from long ${ a.format }, dst.dims and src.dims have Infinity`;
    var dst = _.Matrix.Make([ 2, 3, Infinity ]).copy( a.vadMake
    ([
      1, 0, 1,
      2, 1, 2,
    ]));
    var src = _.Matrix.Make([ 2, 2, Infinity ]).copy( a.longMake
    ([
      3, 3,
      5, 5,
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 2, 3, Infinity ]).copy( a.vadMake
    ([
      3, 3, 0,
      5, 5, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from vector ${ a.format }, dst.dims has Infinity`;
    var dst = _.Matrix.Make([ 2, 3, Infinity ]).copy( a.vadMake
    ([
      1, 0, 1,
      2, 1, 2,
    ]));
    var src = _.Matrix.Make([ 2, 2, 1 ]).copy( a.vadMake
    ([
      3, 3,
      5, 5,
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 2, 3, Infinity ]).copy( a.vadMake
    ([
      3, 3, 0,
      5, 5, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    /* */

    test.case = `dst - matrix from long ${ a.format }, src - from long ${ a.format }, dst.dims values is identical to src.dims.values`;
    var dst = _.Matrix.Make([ 2, 3, 2 ]).copy( a.longMake
    ([
      1, 0, 1,
      2, 1, 2,
      3, -1, 3,
      4, 1, 4,
    ]));
    var src = _.Matrix.Make([ 2, 3, 2 ]).copy( a.longMake
    ([
      3, 3, 3,
      3, 3, 3,
      7, 7, 7,
      7, 7, 7,
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 2, 3, 2 ]).copy( a.longMake
    ([
      3, 3, 3,
      3, 3, 3,
      7, 7, 7,
      7, 7, 7,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from long ${ a.format }, dst.dims values is identical to src.dims.values`;
    var dst = _.Matrix.Make([ 2, 3, 2 ]).copy( a.vadMake
    ([
      1, 0, 1,
      2, 1, 2,
      3, -1, 3,
      4, 1, 4,
    ]));
    var src = _.Matrix.Make([ 2, 3, 2 ]).copy( a.longMake
    ([
      3, 3, 3,
      3, 3, 3,
      7, 7, 7,
      7, 7, 7,
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 2, 3, 2 ]).copy( a.vadMake
    ([
      3, 3, 3,
      3, 3, 3,
      7, 7, 7,
      7, 7, 7,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from vector ${ a.format }, dst.dims values is identical to src.dims.values`;
    var dst = _.Matrix.Make([ 2, 3, 2 ]).copy( a.vadMake
    ([
      1, 0, 1,
      2, 1, 2,
      3, -1, 3,
      4, 1, 4,
    ]));
    var src = _.Matrix.Make([ 2, 3, 2 ]).copy( a.vadMake
    ([
      3, 3, 3,
      3, 3, 3,
      7, 7, 7,
      7, 7, 7,
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 2, 3, 2 ]).copy( a.vadMake
    ([
      3, 3, 3,
      3, 3, 3,
      7, 7, 7,
      7, 7, 7,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.close( 'dst is a 3D Matrix' );

    /* - */

    test.open( 'dst is a 4D Matrix' );

    test.case = `dst - matrix from long ${ a.format }, src - from empty long ${ a.format }`;
    var dst = _.Matrix.Make([ 1, 3, 2, 2 ]).copy( a.longMake
    ([
      1, 0, 1, 2, 1, 2,
      3, -1, 3, 4, 1, 4,
    ]));
    var src = _.Matrix.Make([ 0, 0, 0, 0 ]).copy( a.longMake([]) );
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 1, 3, 2, 2 ]).copy( a.longMake
    ([
      0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from empty long ${ a.format }`;
    var dst = _.Matrix.Make([ 1, 3, 2, 2 ]).copy( a.vadMake
    ([
      1, 0, 1, 2, 1, 2,
      3, -1, 3, 4, 1, 4,
    ]));
    var src = _.Matrix.Make([ 0, 0, 0, 0 ]).copy( a.longMake([]) );
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 1, 3, 2, 2 ]).copy( a.vadMake
    ([
      0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from empty vector ${ a.format }`;
    var dst = _.Matrix.Make([ 1, 3, 2, 2 ]).copy( a.vadMake
    ([
      1, 0, 1, 2, 1, 2,
      3, -1, 3, 4, 1, 4,
    ]));
    var src = _.Matrix.Make([ 0, 0, 0, 0 ]).copy( a.vadMake([]) );
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 1, 3, 2, 2 ]).copy( a.vadMake
    ([
      0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    /* */

    test.case = `dst - matrix from long ${ a.format }, src - from long ${ a.format }, dst.dims values is bigger than src.dims.values`;
    var dst = _.Matrix.Make([ 1, 3, 2, 2 ]).copy( a.longMake
    ([
      1, 0, 1, 2, 1, 2,
      3, -1, 3, 4, 1, 4,
    ]));
    var src = _.Matrix.Make([ 1, 2, 2, 2 ]).copy( a.longMake
    ([
      3, 3, 3, 3,
      5, 5, 5, 5,
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 1, 3, 2, 2 ]).copy( a.longMake
    ([
      3, 3, 0, 3, 3, 0,
      5, 5, 0, 5, 5, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from long ${ a.format }, dst.dims values is bigger than src.dims.values`;
    var dst = _.Matrix.Make([ 1, 3, 2, 2 ]).copy( a.vadMake
    ([
      1, 0, 1, 2, 1, 2,
      3, -1, 3, 4, 1, 4,
    ]));
    var src = _.Matrix.Make([ 1, 2, 2, 2 ]).copy( a.longMake
    ([
      3, 3, 3, 3,
      5, 5, 5, 5,
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 1, 3, 2, 2 ]).copy( a.vadMake
    ([
      3, 3, 0, 3, 3, 0,
      5, 5, 0, 5, 5, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from vector ${ a.format }, dst.dims values is bigger than src.dims.values`;
    var dst = _.Matrix.Make([ 1, 3, 2, 2 ]).copy( a.vadMake
    ([
      1, 0, 1, 2, 1, 2,
      3, -1, 3, 4, 1, 4,
    ]));
    var src = _.Matrix.Make([ 1, 2, 2, 2 ]).copy( a.vadMake
    ([
      3, 3, 3, 3,
      5, 5, 5, 5,
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 1, 3, 2, 2 ]).copy( a.vadMake
    ([
      3, 3, 0, 3, 3, 0,
      5, 5, 0, 5, 5, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    /* */

    test.case = `dst - matrix from long ${ a.format }, src - from long ${ a.format }, dst.dims and src.dims have Infinity`;
    var dst = _.Matrix.Make([ 1, 3, 2, Infinity ]).copy( a.longMake
    ([
      1, 0, 1,
      2, 1, 2,
    ]));
    var src = _.Matrix.Make([ 1, 2, 2, Infinity ]).copy( a.longMake
    ([
      3, 3,
      5, 5,
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 1, 3, 2, Infinity ]).copy( a.longMake
    ([
      3, 3, 0,
      5, 5, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from long ${ a.format }, dst.dims and src.dims have Infinity`;
    var dst = _.Matrix.Make([ 1, 3, 2, Infinity ]).copy( a.vadMake
    ([
      1, 0, 1,
      2, 1, 2,
    ]));
    var src = _.Matrix.Make([ 1, 2, 2, Infinity ]).copy( a.longMake
    ([
      3, 3,
      5, 5,
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 1, 3, 2, Infinity ]).copy( a.vadMake
    ([
      3, 3, 0,
      5, 5, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from vector ${ a.format }, dst.dims has Infinity`;
    var dst = _.Matrix.Make([ 1, 3, 2, Infinity ]).copy( a.vadMake
    ([
      1, 0, 1, 2, 1, 2,
    ]));
    var src = _.Matrix.Make([ 1, 2, 2, 1 ]).copy( a.vadMake
    ([
      3, 3,
      5, 5,
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 1, 3, 2, Infinity ]).copy( a.vadMake
    ([
      3, 3, 0,
      5, 5, 0,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    /* */

    test.case = `dst - matrix from long ${ a.format }, src - from long ${ a.format }, dst.dims values is identical to src.dims.values`;
    var dst = _.Matrix.Make([ 1, 3, 2, 2 ]).copy( a.longMake
    ([
      1, 0, 1, 2, 1, 2,
      3, -1, 3, 4, 1, 4,
    ]));
    var src = _.Matrix.Make([ 1, 3, 2, 2 ]).copy( a.longMake
    ([
      3, 3, 3, 3, 3, 3,
      7, 7, 7, 7, 7, 7,
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 1, 3, 2, 2 ]).copy( a.longMake
    ([
      3, 3, 3, 3, 3, 3,
      7, 7, 7, 7, 7, 7,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from long ${ a.format }, dst.dims values is identical to src.dims.values`;
    var dst = _.Matrix.Make([ 1, 3, 2, 2 ]).copy( a.vadMake
    ([
      1, 0, 1, 2, 1, 2,
      3, -1, 3, 4, 1, 4,
    ]));
    var src = _.Matrix.Make([ 1, 3, 2, 2 ]).copy( a.longMake
    ([
      3, 3, 3, 3, 3, 3,
      7, 7, 7, 7, 7, 7,
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 1, 3, 2, 2 ]).copy( a.vadMake
    ([
      3, 3, 3, 3, 3, 3,
      7, 7, 7, 7, 7, 7,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.case = `dst - matrix from vector ${ a.format }, src - from vector ${ a.format }, dst.dims values is identical to src.dims.values`;
    var dst = _.Matrix.Make([ 1, 3, 2, 2 ]).copy( a.vadMake
    ([
      1, 0, 1, 2, 1, 2,
      3, -1, 3, 4, 1, 4,
    ]));
    var src = _.Matrix.Make([ 1, 3, 2, 2 ]).copy( a.vadMake
    ([
      3, 3, 3, 3, 3, 3,
      7, 7, 7, 7, 7, 7,
    ]));
    var got = _.Matrix.CopyTo( dst, src );
    var exp = _.Matrix.Make([ 1, 3, 2, 2 ]).copy( a.vadMake
    ([
      3, 3, 3, 3, 3, 3,
      7, 7, 7, 7, 7, 7,
    ]));
    test.identical( got, exp );
    test.is( got === dst );

    test.close( 'dst is a 4D Matrix' );
  }
}

//

function copy( test )
{

  /* */

  test.case = 'copy buffer without copying strides and offset';

  var b1 = new F32x([
    0,
    1, 7,
    2, 8,
    3, 9,
    4, 10,
    5, 11,
    6, 12,
    13,
  ]);
  var b2 = new F32x([ 0, 0, 10, 20, 30, 40, 50, 60, 0, 0 ])

  var src = new _.Matrix
  ({
    buffer : b1,
    dims : [ 2, 3 ],
    strides : [ 2, 4 ],
    offset : 1,
    inputRowMajor : 1,
  });

  var dst = new _.Matrix
  ({
    buffer : b2,
    dims : [ 2, 3 ],
    offset : 2,
    inputRowMajor : 0,
  });

  logger.log( 'src', src );
  logger.log( 'dst', dst );

  test.identical( src.stridesEffective, [ 2, 4 ] );
  test.identical( dst.stridesEffective, [ 1, 2 ] );

  dst.copy( src );

  test.identical( src.stridesEffective, [ 2, 4 ] );
  test.identical( dst.stridesEffective, [ 1, 2 ] );

  test.identical( dst, src );
  test.is( dst.buffer !== src.buffer );
  test.is( src.buffer === b1 );

  test.identical( src.offset, 1 );
  test.identical( src.size, 24 );
  test.identical( src.sizeOfElementStride, 16 );
  test.identical( src.sizeOfElement, 8 );
  test.identical( src.sizeOfCol, 8 );
  test.identical( src.sizeOfRow, 12 );
  test.identical( src.dims, [ 2, 3 ] );
  test.identical( src.length, 3 );

  test.identical( src.strides, [ 2, 4 ] );
  test.identical( src.stridesEffective, [ 2, 4 ] );
  test.identical( src.strideOfElement, 4 );
  test.identical( src.strideOfCol, 4 );
  test.identical( src.strideInCol, 2 );
  test.identical( src.strideOfRow, 2 );
  test.identical( src.strideInRow, 4 );

  test.is( dst.buffer === b2 );

  test.identical( dst.offset, 2 );
  test.identical( dst.size, 24 );
  // test.identical( dst.sizeOfElementStride, 4 );
  test.identical( dst.sizeOfElementStride, 8 );
  test.identical( dst.sizeOfElement, 8 );
  test.identical( dst.sizeOfCol, 8 );
  test.identical( dst.sizeOfRow, 12 );
  test.identical( dst.dims, [ 2, 3 ] );
  test.identical( dst.length, 3 );

  test.identical( dst.strides, null );
  test.identical( dst.stridesEffective, [ 1, 2 ] );
  test.identical( dst.strideOfElement, 2 );
  test.identical( dst.strideOfCol, 2 );
  test.identical( dst.strideInCol, 1 );
  test.identical( dst.strideOfRow, 1 );
  test.identical( dst.strideInRow, 2 );

  // test.identical( dst.strides, null );
  // test.identical( dst.stridesEffective, [ 3, 1 ] );
  // test.identical( dst.strideOfElement, 1 );
  // test.identical( dst.strideOfCol, 1 );
  // test.identical( dst.strideInCol, 3 );
  // test.identical( dst.strideOfRow, 3 );
  // test.identical( dst.strideInRow, 1 );

  /* */

  test.case = 'no buffer move';

  var src = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);
  var dst = _.Matrix.Make([ 3, 2 ]).copy
  ([
    10, 40,
    20, 50,
    30, 60,
  ]);

  var srcBuffer = src.buffer;
  var dstBuffer = dst.buffer;

  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);

  dst.copy( src );
  test.identical( dst, exp );
  test.is( src.buffer === srcBuffer );
  test.is( dst.buffer === dstBuffer );
  test.is( src.buffer !== dst.buffer );

  /* */

  test.case = 'copy null matrix';

  var src = _.Matrix.Make([ 0, 0 ]);
  var dst = _.Matrix.Make([ 0, 0 ]);

  var srcBuffer = src.buffer;
  var dstBuffer = dst.buffer;

  var exp = _.Matrix.Make([ 0, 0 ]);

  dst.copy( src );
  test.identical( dst, exp );
  test.is( src.buffer === srcBuffer );
  test.is( dst.buffer === dstBuffer );
  test.is( src.buffer !== dst.buffer );

  /* */

  test.case = 'converting constructor and copy itself';

  var src = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);

  var srcBuffer = src.buffer;

  var dst = _.Matrix( src );

  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);

  test.identical( dst, exp );
  test.is( src.buffer === srcBuffer );
  test.is( dst.buffer === srcBuffer );
  test.is( src === dst );

  dst.copy( src );

  test.identical( dst, exp );
  test.is( src.buffer === srcBuffer );
  test.is( dst.buffer === srcBuffer );
  test.is( src === dst );


  /* */

  test.case = 'copy via constructor with instance';

  var src = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);

  var dst = new _.Matrix( src );

  var srcBuffer = src.buffer;
  var dstBuffer = dst.buffer;

  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);

  dst.copy( src );
  test.identical( dst, exp );
  test.is( src.buffer === srcBuffer );
  test.is( dst.buffer === dstBuffer );
  test.is( src.buffer !== dst.buffer );

  /* */

  test.case = 'copy via constructor with map';

  var buffer = new F32x
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);
  var dst = _.Matrix({ buffer, dims : [ 3, 2 ], inputRowMajor : 1 });
  var dstBuffer = dst.buffer;

  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);

  test.identical( dst, exp );
  test.is( dst.buffer === buffer );

  /* */

  test.case = 'copy different size';

  var src = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);

  var dst = _.Matrix.Make([ 2, 1 ]).copy
  ([
    11,
    22,
  ]);

  logger.log( `src\n${src.toStr()}` );
  logger.log( `dst\n${dst.toStr()}` );

  dst.copy( src );

  logger.log( `src\n${src.toStr()}` );
  logger.log( `dst\n${dst.toStr()}` );

  test.identical( src.buffer, new F32x([ 1, 2, 3, 4, 5, 6 ]) );
  test.identical( src.dims, [ 3, 2 ] );
  test.identical( src.dimsEffective, [ 3, 2 ] );
  test.identical( src.strides, [ 1, 3 ] );
  test.identical( src.stridesEffective, [ 1, 3 ] );

  test.identical( dst.dims, src.dims );
  test.identical( dst.buffer, new F32x([ 1, 2, 3, 4, 5, 6 ]) );
  test.identical( dst.dims, src.dims );
  test.identical( dst.strides, null );
  test.identical( dst.stridesEffective, [ 1, 3 ] );

  test.is( dst.buffer !== src.buffer );
  test.is( dst.dims !== src.dims );
  test.is( dst.strides === null );
  test.is( dst.stridesEffective !== src.stridesEffective );

  /* */

  test.case = 'copy different size, empty';

  var src = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);

  var dst = _.Matrix.Make([ 0, 0 ]);

  dst.copy( src );

  test.identical( src.buffer, new F32x([ 1, 2, 3, 4, 5, 6 ]) );
  test.identical( src.dims, [ 3, 2 ] );
  test.identical( src.dimsEffective, [ 3, 2 ] );
  test.identical( src.strides, [ 1, 3 ] );
  test.identical( src.stridesEffective, [ 1, 3 ] );

  test.identical( dst.dims, src.dims );
  test.identical( dst.buffer, new F32x([ 1, 2, 3, 4, 5, 6 ]) );
  test.identical( dst.dims, src.dims );
  test.identical( dst.strides, null );
  test.identical( dst.stridesEffective, [ 1, 3 ] );

  test.is( dst.buffer !== src.buffer );
  test.is( dst.dims !== src.dims );
  test.is( dst.strides === null );
  test.is( dst.stridesEffective !== src.stridesEffective );

  /* */

  if( !Config.debug )
  return;

  /* */

  test.case = 'throwing';

  test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 2 ]).copy( 'x' ) );

}

//

function copySubmatrix( test )
{

  /* */

  test.case = 'copy from matrix with different srides';

  var src1 = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);

  var src2 = src1.submatrix( [ 0, src1.dims[ 0 ]-2 ], [ 0, src1.dims[ 1 ]-2 ] );

  var dst = _.Matrix.Make([ 2, 1 ]).copy
  ([
    11,
    22,
  ]);

  test.identical( src1.stridesEffective, [ 1, 3 ] );
  test.identical( src2.stridesEffective, [ 1, 3 ] );
  test.identical( dst.stridesEffective, [ 1, 2 ] );

  test.identical( src1.dims, [ 3, 2 ] );
  test.identical( src2.dims, [ 2, 1 ] );
  test.identical( dst.dims, [ 2, 1 ] );

  console.log( 'src1', src1.toStr() );
  console.log( 'src2', src2.toStr() );
  console.log( 'dst', dst.toStr() );

  dst.copy( src2 );

  test.identical( src1.stridesEffective, [ 1, 3 ] );
  test.identical( src2.stridesEffective, [ 1, 3 ] );
  test.identical( dst.stridesEffective, [ 1, 2 ] );

  test.identical( src1.dims, [ 3, 2 ] );
  test.identical( src2.dims, [ 2, 1 ] );
  test.identical( dst.dims, [ 2, 1 ] );

  console.log( 'src1', src1.toStr() );
  console.log( 'src2', src2.toStr() );

  /* */

}

//

function copyInstanceInstance( test )
{

  /* */

  test.case = 'src : 1, dst : 1';

  var src = _.Matrix
  ({
    inputRowMajor : 1,
    dims : [ 3, 2 ],
    buffer :
    [
      1, 2,
      3, 4,
      5, 6,
    ]
  });

  test.identical( src.buffer, [ 1, 2, 3, 4, 5, 6 ] );
  test.identical( src.dims, [ 3, 2 ] );
  test.identical( src.dimsEffective, [ 3, 2 ] );
  test.identical( src.strides, null );
  test.identical( src.stridesEffective, [ 2, 1 ] );

  var dst = _.Matrix
  ({
    inputRowMajor : 1,
    dims : [ 2, 1 ],
    buffer :
    [
      11,
      22,
    ]
  });

  test.identical( dst.buffer, [ 11, 22 ] );
  test.identical( dst.dims, [ 2, 1 ] );
  test.identical( dst.dimsEffective, [ 2, 1 ] );
  test.identical( dst.strides, null );
  test.identical( dst.stridesEffective, [ 1, 1 ] );

  dst.copy( src );

  logger.log( `dst\n${dst.toStr()}` );
  logger.log( `src\n${src.toStr()}` );

  test.identical( dst.buffer, [ 1, 3, 5, 2, 4, 6 ] );
  test.identical( dst.dims, src.dims );
  test.identical( dst.dimsEffective, src.dimsEffective );
  test.identical( dst.strides, null );
  test.identical( dst.stridesEffective, [ 1, 3 ] );
  test.identical( dst, src );

  test.is( dst.buffer !== src.buffer );
  test.is( dst.dims !== src.dims );
  test.is( dst.dimsEffective !== src.dimsEffective );
  test.is( dst.strides === null );
  test.is( dst.stridesEffective !== src.stridesEffective );

  /* */

  test.case = 'src : 0, dst : 1';

  var src = _.Matrix
  ({
    inputRowMajor : 0,
    dims : [ 3, 2 ],
    buffer :
    [
      1, 2,
      3, 4,
      5, 6,
    ]
  });

  test.identical( src.buffer, [ 1, 2, 3, 4, 5, 6 ] );
  test.identical( src.dims, [ 3, 2 ] );
  test.identical( src.dimsEffective, [ 3, 2 ] );
  test.identical( src.strides, null );
  test.identical( src.stridesEffective, [ 1, 3 ] );

  var dst = _.Matrix
  ({
    inputRowMajor : 1,
    dims : [ 2, 1 ],
    buffer :
    [
      11,
      22,
    ]
  });

  test.identical( dst.buffer, [ 11, 22 ] );
  test.identical( dst.dims, [ 2, 1 ] );
  test.identical( dst.dimsEffective, [ 2, 1 ] );
  test.identical( dst.strides, null );
  test.identical( dst.stridesEffective, [ 1, 1 ] );

  dst.copy( src );

  logger.log( `dst\n${dst.toStr()}` );
  logger.log( `src\n${src.toStr()}` );

  test.identical( dst.buffer, [ 1, 2, 3, 4, 5, 6 ] );
  test.identical( dst.dims, src.dims );
  test.identical( dst.dimsEffective, src.dimsEffective );
  test.identical( dst.strides, null );
  test.identical( dst.stridesEffective, [ 1, 3 ] );
  test.identical( dst, src );

  test.is( dst.buffer !== src.buffer );
  test.is( dst.dims !== src.dims );
  test.is( dst.dimsEffective !== src.dimsEffective );
  test.is( dst.strides === null );
  test.is( dst.stridesEffective !== src.stridesEffective );

  /* */

  test.case = 'src : 1, dst : 0';

  var src = _.Matrix
  ({
    inputRowMajor : 1,
    dims : [ 3, 2 ],
    buffer :
    [
      1, 2,
      3, 4,
      5, 6,
    ]
  });

  test.identical( src.buffer, [ 1, 2, 3, 4, 5, 6 ] );
  test.identical( src.dims, [ 3, 2 ] );
  test.identical( src.dimsEffective, [ 3, 2 ] );
  test.identical( src.strides, null );
  test.identical( src.stridesEffective, [ 2, 1 ] );

  var dst = _.Matrix
  ({
    inputRowMajor : 0,
    dims : [ 2, 1 ],
    buffer :
    [
      11,
      22,
    ]
  });

  test.identical( dst.buffer, [ 11, 22 ] );
  test.identical( dst.dims, [ 2, 1 ] );
  test.identical( dst.dimsEffective, [ 2, 1 ] );
  test.identical( dst.strides, null );
  test.identical( dst.stridesEffective, [ 1, 2 ] );

  dst.copy( src );

  logger.log( `dst\n${dst.toStr()}` );
  logger.log( `src\n${src.toStr()}` );

  test.identical( dst.buffer, [ 1, 3, 5, 2, 4, 6 ] );
  test.identical( dst.dims, src.dims );
  test.identical( dst.dimsEffective, src.dimsEffective );
  test.identical( dst.strides, null );
  test.identical( dst.stridesEffective, [ 1, 3 ] );
  test.identical( dst, src );

  test.is( dst.buffer !== src.buffer );
  test.is( dst.dims !== src.dims );
  test.is( dst.dimsEffective !== src.dimsEffective );
  test.is( dst.strides === null );
  test.is( dst.stridesEffective !== src.stridesEffective );

  /* */

  test.case = 'src : 0, dst : 0';

  var src = _.Matrix
  ({
    inputRowMajor : 0,
    dims : [ 3, 2 ],
    buffer :
    [
      1, 2,
      3, 4,
      5, 6,
    ]
  });

  test.identical( src.buffer, [ 1, 2, 3, 4, 5, 6 ] );
  test.identical( src.dims, [ 3, 2 ] );
  test.identical( src.dimsEffective, [ 3, 2 ] );
  test.identical( src.strides, null );
  test.identical( src.stridesEffective, [ 1, 3 ] );

  var dst = _.Matrix
  ({
    inputRowMajor : 0,
    dims : [ 2, 1 ],
    buffer :
    [
      11,
      22,
    ]
  });

  test.identical( dst.buffer, [ 11, 22 ] );
  test.identical( dst.dims, [ 2, 1 ] );
  test.identical( dst.dimsEffective, [ 2, 1 ] );
  test.identical( dst.strides, null );
  test.identical( dst.stridesEffective, [ 1, 2 ] );

  dst.copy( src );

  logger.log( `dst\n${dst.toStr()}` );
  logger.log( `src\n${src.toStr()}` );

  test.identical( dst.buffer, [ 1, 2, 3, 4, 5, 6 ] );
  test.identical( dst.dims, src.dims );
  test.identical( dst.dimsEffective, src.dimsEffective );
  test.identical( dst.strides, null );
  test.identical( dst.stridesEffective, [ 1, 3 ] );
  test.identical( dst, src );

  test.is( dst.buffer !== src.buffer );
  test.is( dst.dims !== src.dims );
  test.is( dst.dimsEffective !== src.dimsEffective );
  test.is( dst.strides === null );
  test.is( dst.stridesEffective !== src.stridesEffective );

  test.case = 'src : 1, dst : 1, with strides';

  var src = _.Matrix
  ({
    inputRowMajor : 1,
    dims : [ 3, 2 ],
    strides : [ 1, 3 ],
    buffer :
    [
      1, 2,
      3, 4,
      5, 6,
    ]
  });

  test.identical( src.buffer, [ 1, 2, 3, 4, 5, 6 ] );
  test.identical( src.dims, [ 3, 2 ] );
  test.identical( src.dimsEffective, [ 3, 2 ] );
  test.identical( src.strides, [ 1, 3 ] );
  test.identical( src.stridesEffective, [ 1, 3 ] );

  var dst = _.Matrix
  ({
    inputRowMajor : 1,
    dims : [ 2, 1 ],
    strides : [ 1, 2 ],
    buffer :
    [
      11,
      22,
    ]
  });

  test.identical( dst.buffer, [ 11, 22 ] );
  test.identical( dst.dims, [ 2, 1 ] );
  test.identical( dst.dimsEffective, [ 2, 1 ] );
  test.identical( dst.strides, [ 1, 2 ] );
  test.identical( dst.stridesEffective, [ 1, 2 ] );

  dst.copy( src );

  logger.log( `dst\n${dst.toStr()}` );
  logger.log( `src\n${src.toStr()}` );

  test.identical( dst.buffer, [ 1, 2, 3, 4, 5, 6 ] );
  test.identical( dst.dims, src.dims );
  test.identical( dst.dimsEffective, src.dimsEffective );
  test.identical( dst.strides, null );
  test.identical( dst.stridesEffective, [ 1, 3 ] );
  test.identical( dst, src );

  test.is( dst.buffer !== src.buffer );
  test.is( dst.dims !== src.dims );
  test.is( dst.dimsEffective !== src.dimsEffective );
  test.is( dst.strides === null );
  test.is( dst.stridesEffective !== src.stridesEffective );

  /* */

  test.case = 'src : 0, dst : 1, with strides';

  var src = _.Matrix
  ({
    inputRowMajor : 0,
    dims : [ 3, 2 ],
    strides : [ 2, 1 ],
    buffer :
    [
      1, 2,
      3, 4,
      5, 6,
    ]
  });

  test.identical( src.buffer, [ 1, 2, 3, 4, 5, 6 ] );
  test.identical( src.dims, [ 3, 2 ] );
  test.identical( src.dimsEffective, [ 3, 2 ] );
  test.identical( src.strides, [ 2, 1 ] );
  test.identical( src.stridesEffective, [ 2, 1 ] );

  var dst = _.Matrix
  ({
    inputRowMajor : 1,
    dims : [ 2, 1 ],
    strides : [ 1, 2 ],
    buffer :
    [
      11,
      22,
    ]
  });

  test.identical( dst.buffer, [ 11, 22 ] );
  test.identical( dst.dims, [ 2, 1 ] );
  test.identical( dst.dimsEffective, [ 2, 1 ] );
  test.identical( dst.strides, [ 1, 2 ] );
  test.identical( dst.stridesEffective, [ 1, 2 ] );

  dst.copy( src );

  logger.log( `dst\n${dst.toStr()}` );
  logger.log( `src\n${src.toStr()}` );

  test.identical( dst.buffer, [ 1, 3, 5, 2, 4, 6 ] );
  test.identical( dst.dims, src.dims );
  test.identical( dst.dimsEffective, src.dimsEffective );
  test.identical( dst.strides, null );
  test.identical( dst.stridesEffective, [ 1, 3 ] );
  test.identical( dst, src );

  test.is( dst.buffer !== src.buffer );
  test.is( dst.dims !== src.dims );
  test.is( dst.dimsEffective !== src.dimsEffective );
  test.is( dst.strides === null );
  test.is( dst.stridesEffective !== src.stridesEffective );

  /* */

  test.case = 'src : 1, dst : 0, with strides';

  var src = _.Matrix
  ({
    inputRowMajor : 1,
    dims : [ 3, 2 ],
    strides : [ 1, 3 ],
    buffer :
    [
      1, 2,
      3, 4,
      5, 6,
    ]
  });

  test.identical( src.buffer, [ 1, 2, 3, 4, 5, 6 ] );
  test.identical( src.dims, [ 3, 2 ] );
  test.identical( src.dimsEffective, [ 3, 2 ] );
  test.identical( src.strides, [ 1, 3 ] );
  test.identical( src.stridesEffective, [ 1, 3 ] );

  var dst = _.Matrix
  ({
    inputRowMajor : 0,
    dims : [ 2, 1 ],
    strides : [ 1, 1 ],
    buffer :
    [
      11,
      22,
    ]
  });

  test.identical( dst.buffer, [ 11, 22 ] );
  test.identical( dst.dims, [ 2, 1 ] );
  test.identical( dst.dimsEffective, [ 2, 1 ] );
  test.identical( dst.strides, [ 1, 1 ] );
  test.identical( dst.stridesEffective, [ 1, 1 ] );

  dst.copy( src );

  logger.log( `dst\n${dst.toStr()}` );
  logger.log( `src\n${src.toStr()}` );

  test.identical( dst.buffer, [ 1, 2, 3, 4, 5, 6 ] );
  test.identical( dst.dims, src.dims );
  test.identical( dst.dimsEffective, src.dimsEffective );
  test.identical( dst.strides, null );
  test.identical( dst.stridesEffective, [ 1, 3 ] );
  test.identical( dst, src );

  test.is( dst.buffer !== src.buffer );
  test.is( dst.dims !== src.dims );
  test.is( dst.dimsEffective !== src.dimsEffective );
  test.is( dst.strides === null );
  test.is( dst.stridesEffective !== src.stridesEffective );

  /* - */

  test.case = 'src : 0, dst : 0, with strides';

  var src = _.Matrix
  ({
    inputRowMajor : 0,
    dims : [ 3, 2 ],
    strides : [ 2, 1 ],
    buffer :
    [
      1, 2,
      3, 4,
      5, 6,
    ]
  });

  test.identical( src.buffer, [ 1, 2, 3, 4, 5, 6 ] );
  test.identical( src.dims, [ 3, 2 ] );
  test.identical( src.dimsEffective, [ 3, 2 ] );
  test.identical( src.strides, [ 2, 1 ] );
  test.identical( src.stridesEffective, [ 2, 1 ] );

  var dst = _.Matrix
  ({
    inputRowMajor : 0,
    dims : [ 2, 1 ],
    strides : [ 1, 1 ],
    buffer :
    [
      11,
      22,
    ]
  });

  test.identical( dst.buffer, [ 11, 22 ] );
  test.identical( dst.dims, [ 2, 1 ] );
  test.identical( dst.dimsEffective, [ 2, 1 ] );
  test.identical( dst.strides, [ 1, 1 ] );
  test.identical( dst.stridesEffective, [ 1, 1 ] );

  dst.copy( src );

  logger.log( `dst\n${dst.toStr()}` );
  logger.log( `src\n${src.toStr()}` );

  test.identical( dst.buffer, [ 1, 3, 5, 2, 4, 6 ] );
  test.identical( dst.dims, src.dims );
  test.identical( dst.dimsEffective, src.dimsEffective );
  test.identical( dst.strides, null );
  test.identical( dst.stridesEffective, [ 1, 3 ] );
  test.identical( dst, src );

  test.is( dst.buffer !== src.buffer );
  test.is( dst.dims !== src.dims );
  test.is( dst.dimsEffective !== src.dimsEffective );
  test.is( dst.strides === null );
  test.is( dst.stridesEffective !== src.stridesEffective );

  /* - */

}

//

function exportStructureToStructure( test )
{

  /* */

  test.case = 'basic';
  var exp =
  {
    'dims' : [ 2, 3 ],
    'buffer' : ( new F32x([ 1, 4, 2, 5, 3, 6 ]) ),
    'offset' : 0,
    'strides' : [ 1, 2 ]
  }
  var matrix = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);
  var got = matrix.exportStructure({ dst : Object.create( null ) });
  test.identical( got, exp );

  /* */

  test.case = 'dims : ( 3, Infinity )';
  var exp =
  {
    'dims' : [ 3, Infinity ],
    'buffer' : ( new F32x([ 1, 2, 3 ]) ),
    'offset' : 0,
    'strides' : [ 1, 0 ]
  }
  var matrix = _.Matrix
  ({
    dims : [ 3, Infinity ],
    buffer : new F32x([ 1, 2, 3 ]),
    inputRowMajor : 0,
  });
  test.identical( matrix.dims, [ 3, Infinity ] );
  test.identical( matrix.dimsEffective, [ 3, 1 ] );
  test.identical( matrix.strides, null );
  test.identical( matrix.stridesEffective, [ 1, 0 ] );
  logger.log( matrix.toStr() );
  var got = matrix.exportStructure({ dst : Object.create( null ) });
  test.identical( got, exp );

  /* */

  test.case = 'dims : ( Infinity, 3 )';
  var exp =
  {
    'dims' : [ Infinity, 3 ],
    'buffer' : ( new F32x([ 1, 2, 3 ]) ),
    'offset' : 0,
    'strides' : [ 0, 1 ]
  }
  var matrix = _.Matrix
  ({
    dims : [ Infinity, 3 ],
    buffer : new F32x([ 1, 2, 3 ]),
    inputRowMajor : 0,
  });
  test.identical( matrix.dims, [ Infinity, 3 ] );
  test.identical( matrix.dimsEffective, [ 1, 3 ] );
  test.identical( matrix.strides, null );
  test.identical( matrix.stridesEffective, [ 0, 1 ] );
  logger.log( matrix.toStr() );
  var got = matrix.exportStructure({ dst : Object.create( null ) });
  test.identical( got, exp );

  /* */

}

//

function bufferExportDstBufferNullFullUsedMatrix( test )
{

  test.case = 'restriding - 1, asFloat - 0, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 1, -1, 2, 3 ],
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 1,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = [ 1, 2, -1, 3 ];
  test.identical( got, exp );

  test.case = 'restriding - 0, asFloat - 0, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 1, -1, 2, 3 ],
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 0,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = [ 1, -1, 2, 3 ];
  test.identical( got, exp );

  test.case = 'restriding - null, asFloat - 0, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 1, -1, 2, 3 ],
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : null,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = [ 1, -1, 2, 3 ];
  test.identical( got, exp );

  /* */

  test.case = 'restriding - 1, asFloat - 0, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 1,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = new F64x([ 1, 2, -1, 3 ]);
  test.identical( got, exp );

  test.case = 'restriding - 0, asFloat - 0, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 0,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = _.withDefaultLong.F64x.longDescriptor.make([ 1, -1, 2, 3 ]);
  test.identical( got, exp );

  test.case = 'restriding - null, asFloat - 0, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : null,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = _.withDefaultLong.F64x.longDescriptor.make([ 1, -1, 2, 3 ]);
  test.identical( got, exp );

  /* */

  test.case = 'restriding - 1, asFloat - 1, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 1, -1, 2, 3 ],
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 1,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = _.withDefaultLong.F32x.longDescriptor.make([ 1, 2, -1, 3 ]);
  test.identical( got, exp );

  test.case = 'restriding - 0, asFloat - 1, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 1, -1, 2, 3 ],
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 0,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = _.longDescriptor.make([ 1, -1, 2, 3 ]);
  test.identical( got, exp );

  test.case = 'restriding - null, asFloat - 1, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 1, -1, 2, 3 ],
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : null,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = _.longDescriptor.make([ 1, -1, 2, 3 ]);
  test.identical( got, exp );

  /* */

  test.case = 'restriding - 1, asFloat - 1, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 1,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = new F64x([ 1, 2, -1, 3 ]);
  test.identical( got, exp );

  test.case = 'restriding - 0, asFloat - 1, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 0,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = new F64x([ 1, -1, 2, 3 ]);
  test.identical( got, exp );

  test.case = 'restriding - null, asFloat - 1, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : null,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = new F64x([ 1, -1, 2, 3 ]);
  test.identical( got, exp );

  /* */

  test.case = 'restriding - 1, asFloat - 0, dstObject - null';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 1,
    dstObject : null,
    asFloat : 0,
  });
  var exp =
  {
    buffer : new F64x([ 1, 2, -1, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 1, 2 ],
    offset : 0
  };
  test.identical( got, exp );

  test.case = 'restriding - 0, asFloat - 0, dstObject - null';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 0,
    dstObject : null,
    asFloat : 0,
  });
  var exp =
  {
    buffer : _.withDefaultLong.F64x.longDescriptor.make([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
    offset : 0
  };
  test.identical( got, exp );

  test.case = 'restriding - null, asFloat - 1, dstObject - null';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : null,
    dstObject : null,
    asFloat : 0,
  });
  var exp =
  {
    buffer : _.withDefaultLong.F64x.longDescriptor.make([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
    offset : 0
  };
  test.identical( got, exp );

  /* */

  test.case = 'restriding - 1, asFloat - 0, dstObject - map';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var dstObject = {};
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 1,
    dstObject : dstObject,
    asFloat : 0,
  });
  var exp =
  {
    buffer : new F64x([ 1, 2, -1, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 1, 2 ],
    offset : 0
  };
  test.identical( got, exp );
  test.is( got === dstObject );

  test.case = 'restriding - 0, asFloat - 0, dstObject - null';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var dstObject = {};
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 0,
    dstObject,
    asFloat : 0,
  });
  var exp =
  {
    buffer : _.withDefaultLong.F64x.longDescriptor.make([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
    offset : 0
  };
  test.identical( got, exp );
  test.is( got === dstObject );

  test.case = 'restriding - null, asFloat - 1, dstObject - null';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var dstObject = {};
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : null,
    dstObject,
    asFloat : 0,
  });
  var exp =
  {
    buffer : _.withDefaultLong.F64x.longDescriptor.make([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
    offset : 0
  };
  test.identical( got, exp );
  test.is( got === dstObject );
}

//

function bufferExportDstBufferNullMatrixWithOffset( test )
{
  test.case = 'restriding - 1, asFloat - 0, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 0, 1, -1, 2, 3, 4, 5, 6, 7 ],
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 1,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = [ 1, 2, 3, 5 ];
  test.identical( got, exp );

  test.case = 'restriding - 0, asFloat - 0, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 0, 1, -1, 2, 3, 4, 5, 6, 7 ],
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 0,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = [ 0, 1, -1, 2, 3, 4, 5, 6, 7 ];
  test.identical( got, exp );

  test.case = 'restriding - null, asFloat - 0, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 0, 1, -1, 2, 3, 4, 5, 6, 7 ],
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : null,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = [ 1, 2, 3, 5 ];
  test.identical( got, exp );

  /* */

  test.case = 'restriding - 1, asFloat - 0, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 1,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = new F64x([ 1, 2, 3, 5 ]);
  test.identical( got, exp );

  test.case = 'restriding - 0, asFloat - 0, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 0,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = _.withDefaultLong.F64x.longDescriptor.make([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]);
  test.identical( got, exp );

  test.case = 'restriding - null, asFloat - 0, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : null,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = new F64x([ 1, 2, 3, 5 ]);
  test.identical( got, exp );

  /* */

  test.case = 'restriding - 1, asFloat - 1, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 0, 1, -1, 2, 3, 4, 5, 6, 7 ],
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 1,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = _.longDescriptor.make([ 1, 2, 3, 5 ]);
  test.identical( got, exp );

  test.case = 'restriding - 0, asFloat - 1, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 0, 1, -1, 2, 3, 4, 5, 6, 7 ],
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 0,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = _.longDescriptor.make([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]);
  test.identical( got, exp );

  test.case = 'restriding - null, asFloat - 1, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 0, 1, -1, 2, 3, 4, 5, 6, 7 ],
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : null,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = _.longDescriptor.make( [ 1, 2, 3, 5 ] );
  test.identical( got, exp );

  /* */

  test.case = 'restriding - 1, asFloat - 1, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 1,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = new F64x([ 1, 2, 3, 5 ]);
  test.identical( got, exp );

  test.case = 'restriding - 0, asFloat - 1, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 0,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]);
  test.identical( got, exp );

  test.case = 'restriding - null, asFloat - 1, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : null,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = new F64x([ 1, 2, 3, 5 ]);
  test.identical( got, exp );

  /* */

  test.case = 'restriding - 1, asFloat - 0, dstObject - null';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 1,
    dstObject : null,
    asFloat : 0,
  });
  var exp =
  {
    buffer : new F64x([ 1, 2, 3, 5 ]),
    dims : [ 2, 2 ],
    strides : [ 1, 2 ],
    offset : 0
  };
  test.identical( got, exp );

  test.case = 'restriding - 0, asFloat - 0, dstObject - null';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 0,
    dstObject : null,
    asFloat : 0,
  });
  var exp =
  {
    buffer : _.withDefaultLong.F64x.longDescriptor.make([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  };
  test.identical( got, exp );

  test.case = 'restriding - null, asFloat - 1, dstObject - null';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : null,
    dstObject : null,
    asFloat : 0,
  });
  var exp =
  {
    buffer : new F64x([ 1, 2, 3, 5 ]),
    dims : [ 2, 2 ],
    strides : [ 1, 2 ],
    offset : 0
  };
  test.identical( got, exp );

  /* */

  test.case = 'restriding - 1, asFloat - 0, dstObject - map';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var dstObject = {};
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 1,
    dstObject : dstObject,
    asFloat : 0,
  });
  var exp =
  {
    buffer : new F64x([ 1, 2, 3, 5 ]),
    dims : [ 2, 2 ],
    strides : [ 1, 2 ],
    offset : 0
  };
  test.identical( got, exp );
  test.is( got === dstObject );

  test.case = 'restriding - 0, asFloat - 0, dstObject - null';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var dstObject = {};
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : 0,
    dstObject,
    asFloat : 0,
  });
  var exp =
  {
    buffer : _.withDefaultLong.F64x.longDescriptor.make([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  };
  test.identical( got, exp );
  test.is( got === dstObject );

  test.case = 'restriding - null, asFloat - 1, dstObject - null';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var dstObject = {};
  var got = matrix.bufferExport
  ({
    dstBuffer : null,
    restriding : null,
    dstObject,
    asFloat : 0,
  });
  var exp =
  {
    buffer : new F64x([ 1, 2, 3, 5 ]),
    dims : [ 2, 2 ],
    strides : [ 1, 2 ],
    offset : 0
  };
  test.identical( got, exp );
  test.is( got === dstObject );
}

//

function bufferExportDstBufferFullUsedMatrix( test )
{
  test.case = 'restriding - 1, asFloat - 0, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 1, -1, 2, 3 ],
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var dstBuffer = [ 0, 0, 0, 0 ];
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 1,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = [ 1, 2, -1, 3 ];
  test.identical( got, exp );
  test.is( got === dstBuffer );

  test.case = 'restriding - 0, asFloat - 0, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 1, -1, 2, 3 ],
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var dstBuffer = [ 0, 0, 0, 0 ];
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 0,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = [ 1, -1, 2, 3 ];
  test.identical( got, exp );
  test.is( got === dstBuffer );

  test.case = 'restriding - null, asFloat - 0, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 1, -1, 2, 3 ],
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var dstBuffer = [ 0, 0, 0, 0 ];
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : null,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = [ 1, -1, 2, 3 ];
  test.identical( got, exp );
  test.is( got === dstBuffer );

  /* */

  test.case = 'restriding - 1, asFloat - 0, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var dstBuffer = [ 0, 0, 0, 0 ];
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 1,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = [ 1, 2, -1, 3 ];
  test.identical( got, exp );
  test.is( got === dstBuffer );

  test.case = 'restriding - 0, asFloat - 0, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var dstBuffer = [ 0, 0, 0, 0 ];
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 0,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = [ 1, -1, 2, 3 ];
  test.identical( got, exp );
  test.is( got === dstBuffer );

  test.case = 'restriding - null, asFloat - 0, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var dstBuffer = [ 0, 0, 0, 0 ];
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : null,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = [ 1, -1, 2, 3 ];
  test.identical( got, exp );
  test.is( got === dstBuffer );

  /* */

  test.case = 'restriding - 1, asFloat - 1, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 1, -1, 2, 3 ],
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var dstBuffer = [ 0, 0, 0, 0 ];
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 1,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = [ 1, 2, -1, 3 ];
  test.identical( got, exp );
  test.is( got === dstBuffer );

  test.case = 'restriding - 0, asFloat - 1, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 1, -1, 2, 3 ],
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var dstBuffer = [ 0, 0, 0, 0 ];
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 0,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = [ 1, -1, 2, 3 ];
  test.identical( got, exp );
  test.is( got === dstBuffer );

  test.case = 'restriding - null, asFloat - 1, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 1, -1, 2, 3 ],
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var dstBuffer = [ 0, 0, 0, 0 ];
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : null,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = [ 1, -1, 2, 3 ];
  test.identical( got, exp );
  test.is( got === dstBuffer );

  /* */

  test.case = 'restriding - 1, asFloat - 1, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var dstBuffer = [ 0, 0, 0, 0 ];
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 1,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = [ 1, 2, -1, 3 ];
  test.identical( got, exp );
  test.is( got === dstBuffer );

  test.case = 'restriding - 0, asFloat - 1, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var dstBuffer = [ 0, 0, 0, 0 ];
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 0,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = [ 1, -1, 2, 3 ];
  test.identical( got, exp );
  test.is( got === dstBuffer );

  test.case = 'restriding - null, asFloat - 1, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var dstBuffer = [ 0, 0, 0, 0 ];
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : null,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = [ 1, -1, 2, 3 ];
  test.identical( got, exp );
  test.is( got === dstBuffer );

  /* */

  test.case = 'restriding - 1, asFloat - 0, dstObject - null';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var dstBuffer = [ 0, 0, 0, 0 ];
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 1,
    dstObject : null,
    asFloat : 0,
  });
  var exp =
  {
    buffer : [ 1, 2, -1, 3 ],
    dims : [ 2, 2 ],
    strides : [ 1, 2 ],
    offset : 0
  };
  test.identical( got, exp );
  test.is( got.buffer === dstBuffer );

  test.case = 'restriding - 0, asFloat - 0, dstObject - null';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var dstBuffer = [ 0, 0, 0, 0 ];
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 0,
    dstObject : null,
    asFloat : 0,
  });
  var exp =
  {
    buffer : [ 1, -1, 2, 3 ],
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
    offset : 0
  };
  test.identical( got, exp );
  test.is( got.buffer === dstBuffer );

  test.case = 'restriding - null, asFloat - 1, dstObject - null';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var dstBuffer = [ 0, 0, 0, 0 ];
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : null,
    dstObject : null,
    asFloat : 0,
  });
  var exp =
  {
    buffer : [ 1, -1, 2, 3 ],
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
    offset : 0
  };
  test.identical( got, exp );
  test.is( got.buffer === dstBuffer );

  /* */

  test.case = 'restriding - 1, asFloat - 0, dstObject - map';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var dstBuffer = [ 0, 0, 0, 0 ];
  var dstObject = {};
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 1,
    dstObject : dstObject,
    asFloat : 0,
  });
  var exp =
  {
    buffer : [ 1, 2, -1, 3 ],
    dims : [ 2, 2 ],
    strides : [ 1, 2 ],
    offset : 0
  };
  test.identical( got, exp );
  test.is( got.buffer === dstBuffer );
  test.is( got === dstObject );

  test.case = 'restriding - 0, asFloat - 0, dstObject - null';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var dstBuffer = [ 0, 0, 0, 0 ];
  var dstObject = {};
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 0,
    dstObject,
    asFloat : 0,
  });
  var exp =
  {
    buffer : [ 1, -1, 2, 3 ],
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
    offset : 0
  };
  test.identical( got, exp );
  test.is( got.buffer === dstBuffer );
  test.is( got === dstObject );

  test.case = 'restriding - null, asFloat - 1, dstObject - null';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 1, -1, 2, 3 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
  });
  var dstBuffer = [ 0, 0, 0, 0 ];
  var dstObject = {};
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : null,
    dstObject,
    asFloat : 0,
  });
  var exp =
  {
    buffer : [ 1, -1, 2, 3 ],
    dims : [ 2, 2 ],
    strides : [ 2, 1 ],
    offset : 0
  };
  test.identical( got, exp );
  test.is( got.buffer === dstBuffer );
  test.is( got === dstObject );
}

//

function bufferExportDstBufferMatrixWithOffset( test )
{
  test.case = 'restriding - 1, asFloat - 0, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 0, 1, -1, 2, 3, 4, 5, 6, 7 ],
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var dstBuffer = [ 0, 0, 0, 0 ];
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 1,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = [ 1, 2, 3, 5 ];
  test.identical( got, exp );
  test.is( got === dstBuffer );

  test.case = 'restriding - 0, asFloat - 0, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 0, 1, -1, 2, 3, 4, 5, 6, 7 ],
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var dstBuffer = new F64x([ 0, 0, 0, 0, 0, 0, 0 ]);
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 0,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = new F64x([ 0, 1, -1, 2, 3, 4, 5 ]);
  test.identical( got, exp );
  test.is( got === dstBuffer );

  test.case = 'restriding - null, asFloat - 0, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 0, 1, -1, 2, 3, 4, 5, 6, 7 ],
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var dstBuffer = new F64x([ 0, 0, 0, 0 ]);
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : null,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = new F64x([ 1, 2, 3, 5 ]);
  test.identical( got, exp );
  test.is( got === dstBuffer );

  /* */

  test.case = 'restriding - 1, asFloat - 0, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var dstBuffer = [ 0, 0, 0, 0 ];
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 1,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = [ 1, 2, 3, 5 ];
  test.identical( got, exp );
  test.is( got === dstBuffer );

  test.case = 'restriding - 0, asFloat - 0, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var dstBuffer = new F64x([ 0, 0, 0, 0, 0, 0, 0 ]);
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 0,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = new F64x([ 0, 1, -1, 2, 3, 4, 5 ]);
  test.identical( got, exp );
  test.is( got === dstBuffer );

  test.case = 'restriding - null, asFloat - 0, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var dstBuffer = new F64x([ 0, 0, 0, 0 ]);
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : null,
    dstObject : 0,
    asFloat : 0,
  });
  var exp = new F64x([ 1, 2, 3, 5 ]);
  test.identical( got, exp );
  test.is( got === dstBuffer );

  /* */

  test.case = 'restriding - 1, asFloat - 1, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 0, 1, -1, 2, 3, 4, 5, 6, 7 ],
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var dstBuffer = new F64x([ 0, 0, 0, 0 ]);
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 1,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = new F64x([ 1, 2, 3, 5 ]);
  test.identical( got, exp );
  test.is( got === dstBuffer );

  test.case = 'restriding - 0, asFloat - 1, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 0, 1, -1, 2, 3, 4, 5, 6, 7 ],
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var dstBuffer = new F64x([ 0, 0, 0, 0, 0, 0, 0 ]);
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 0,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = new F64x([ 0, 1, -1, 2, 3, 4, 5 ]);
  test.identical( got, exp );
  test.is( got === dstBuffer );

  test.case = 'restriding - null, asFloat - 1, dstObject - 0, self.buffer - array';
  var matrix = new _.Matrix
  ({
    buffer : [ 0, 1, -1, 2, 3, 4, 5, 6, 7 ],
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var dstBuffer = new F64x([ 0, 0, 0, 0 ]);
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : null,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = new F64x( [ 1, 2, 3, 5 ] );
  test.identical( got, exp );
  test.is( got === dstBuffer );

  /* */

  test.case = 'restriding - 1, asFloat - 1, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var dstBuffer = new F64x([ 0, 0, 0, 0 ]);
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 1,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = new F64x([ 1, 2, 3, 5 ]);
  test.identical( got, exp );
  test.is( got === dstBuffer );

  test.case = 'restriding - 0, asFloat - 1, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var dstBuffer = new F64x([ 0, 0, 0, 0, 0, 0, 0 ]);
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 0,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = new F64x([ 0, 1, -1, 2, 3, 4, 5 ]);
  test.identical( got, exp );
  test.is( got === dstBuffer );

  test.case = 'restriding - null, asFloat - 1, dstObject - 0, self.buffer - F64x';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var dstBuffer = new F64x([ 0, 0, 0, 0 ]);
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : null,
    dstObject : 0,
    asFloat : 1,
  });
  var exp = new F64x([ 1, 2, 3, 5 ]);
  test.identical( got, exp );
  test.is( got === dstBuffer );

  /* */

  test.case = 'restriding - 1, asFloat - 0, dstObject - null';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var dstBuffer = new F64x([ 0, 0, 0, 0 ]);
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 1,
    dstObject : null,
    asFloat : 0,
  });
  var exp =
  {
    buffer : new F64x([ 1, 2, 3, 5 ]),
    dims : [ 2, 2 ],
    strides : [ 1, 2 ],
    offset : 0
  };
  test.identical( got, exp );
  test.is( got.buffer === dstBuffer );

  test.case = 'restriding - 0, asFloat - 0, dstObject - null';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var dstBuffer = new F64x([ 0, 0, 0, 0, 0, 0, 0 ]);
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 0,
    dstObject : null,
    asFloat : 0,
  });
  var exp =
  {
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  };
  test.identical( got, exp );
  test.is( got.buffer === dstBuffer );

  test.case = 'restriding - null, asFloat - 1, dstObject - null';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var dstBuffer = new F64x([ 0, 0, 0, 0 ]);
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : null,
    dstObject : null,
    asFloat : 0,
  });
  var exp =
  {
    buffer : new F64x([ 1, 2, 3, 5 ]),
    dims : [ 2, 2 ],
    strides : [ 1, 2 ],
    offset : 0
  };
  test.identical( got, exp );
  test.is( got.buffer === dstBuffer );

  /* */

  test.case = 'restriding - 1, asFloat - 0, dstObject - map';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var dstBuffer = new F64x([ 0, 0, 0, 0 ]);
  var dstObject = {};
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 1,
    dstObject : dstObject,
    asFloat : 0,
  });
  var exp =
  {
    buffer : new F64x([ 1, 2, 3, 5 ]),
    dims : [ 2, 2 ],
    strides : [ 1, 2 ],
    offset : 0
  };
  test.identical( got, exp );
  test.is( got.buffer === dstBuffer );
  test.is( got === dstObject );

  test.case = 'restriding - 0, asFloat - 0, dstObject - null';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var dstBuffer = new F64x([ 0, 0, 0, 0, 0, 0, 0 ]);
  var dstObject = {};
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : 0,
    dstObject,
    asFloat : 0,
  });
  var exp =
  {
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  };
  test.identical( got, exp );
  test.is( got.buffer === dstBuffer );
  test.is( got === dstObject );

  test.case = 'restriding - null, asFloat - 1, dstObject - null';
  var matrix = new _.Matrix
  ({
    buffer : new F64x([ 0, 1, -1, 2, 3, 4, 5, 6, 7 ]),
    dims : [ 2, 2 ],
    strides : [ 2, 3 ],
    offset : 1
  });
  var dstBuffer = new F64x([ 0, 0, 0, 0 ]);
  var dstObject = {};
  var got = matrix.bufferExport
  ({
    dstBuffer,
    restriding : null,
    dstObject,
    asFloat : 0,
  });
  var exp =
  {
    buffer : new F64x([ 1, 2, 3, 5 ]),
    dims : [ 2, 2 ],
    strides : [ 1, 2 ],
    offset : 0
  };
  test.identical( got, exp );
  test.is( got.buffer === dstBuffer );
  test.is( got === dstObject );
}

//

function bufferImportOptionsReplacing1AndDims( test )
{
  _.vectorAdapter.contextsForTesting({ onEach : act });

  /* - */

  function act( a )
  {
    test.open( `form - ${ a.form }, format - ${ a.format }` );

    test.open( 'changing of dims length, inputRowMajor - 1' );

    test.case = 'same dims, 2D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6 ]);
    var m = _.Matrix.Make([ 2, 3 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 1,
      dims : [ 2, 3 ]
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 2, 3 ] );
    test.identical( got.dimsEffective, [ 2, 3 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 2 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'same dims, 3D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 2, 3, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 1,
      dims : [ 2, 3, 2 ]
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 2, 3, 2 ] );
    test.identical( got.dimsEffective, [ 2, 3, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 2, 6 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'same dims, 4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 1,
      dims : [ 1, 3, 2, 2 ]
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 1, 3, 2, 2 ] );
    test.identical( got.dimsEffective, [ 1, 3, 2, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 1, 3, 6 ] );
    test.is( got.buffer === m.buffer );

    /* */

    test.case = 'o.dims < dims, 2D';
    var buffer = a.vadMake([ 1, 2, 3, 4 ]);
    var m = _.Matrix.Make([ 2, 3 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 1,
      dims : [ 2, 2 ]
    });
    var exp = a.vadMake([ 1, 2, 3, 4 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 2, 2 ] );
    test.identical( got.dimsEffective, [ 2, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 2 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'o.dims < dims, 3D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    var m = _.Matrix.Make([ 2, 3, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 1,
      dims : [ 1, 3, 3 ]
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 1, 3, 3 ] );
    test.identical( got.dimsEffective, [ 1, 3, 3 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 1, 3 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'o.dims < dims, 4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 1,
      dims : [ 2, 3, 2, 1 ]
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 2, 3, 2, 1 ] );
    test.identical( got.dimsEffective, [ 2, 3, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 2, 6 ] );
    test.is( got.buffer === m.buffer );

    /* */

    test.case = 'o.dims < dims, 2D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8 ]);
    var m = _.Matrix.Make([ 2, 3 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 1,
      dims : [ 2, 4 ]
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 2, 4 ] );
    test.identical( got.dimsEffective, [ 2, 4 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 2 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'o.dims < dims, 3D';
    var buffer = a.vadMake
    ([
      1, 2, 3, 4, 5, 6, 7, 8, 9,
      1, 2, 3, 4, 5, 6, 7, 8, 9,
    ]);
    var m = _.Matrix.Make([ 2, 3, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 1,
      dims : [ 2, 3, 3 ]
    });
    var exp = a.vadMake
    ([
      1, 2, 3, 4, 5, 6, 7, 8, 9,
      1, 2, 3, 4, 5, 6, 7, 8, 9,
    ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 2, 3, 3 ] );
    test.identical( got.dimsEffective, [ 2, 3, 3 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 2, 6 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'o.dims > dims, 4D';
    var buffer = a.vadMake
    ([
      1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
      1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
    ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 1,
      dims : [ 2, 3, 2, 2 ]
    });
    var exp = a.vadMake
    ([
      1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
      1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
    ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 2, 3, 2, 2 ] );
    test.identical( got.dimsEffective, [ 2, 3, 2, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 2, 6, 12 ] );
    test.is( got.buffer === m.buffer );

    test.close( 'changing of dims length, inputRowMajor - 1' );

    /* - */

    test.open( 'null in dims, inputRowMajor - 1' );

    test.case = 'null does not change result, 4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 1,
      dims : [ 1, null, 2, 2 ]
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 1, 3, 2, 2 ] );
    test.identical( got.dimsEffective, [ 1, 3, 2, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 1, 3, 6 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'calculates new dimensions, 4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 1,
      dims : [ 1, 2, null ]
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 1, 2, 6 ] );
    test.identical( got.dimsEffective, [ 1, 2, 6 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 1, 2 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'calculates new dimensions, 4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 1,
      dims : [ null, 2, 2 ]
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 3, 2, 2 ] );
    test.identical( got.dimsEffective, [ 3, 2, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 3, 6 ] );
    test.is( got.buffer === m.buffer );

    test.close( 'null in dims, inputRowMajor - 1' );

    /* - */

    test.open( 'changing of dims length, inputRowMajor - 0' );

    test.case = 'same dims, 2D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6 ]);
    var m = _.Matrix.Make([ 2, 3 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 0,
      dims : [ 2, 3 ]
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 2, 3 ] );
    test.identical( got.dimsEffective, [ 2, 3 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 2 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'same dims, 3D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 2, 3, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 0,
      dims : [ 2, 3, 2 ]
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 2, 3, 2 ] );
    test.identical( got.dimsEffective, [ 2, 3, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 2, 6 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'same dims, 4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 0,
      dims : [ 1, 3, 2, 2 ]
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 1, 3, 2, 2 ] );
    test.identical( got.dimsEffective, [ 1, 3, 2, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 1, 3, 6 ] );
    test.is( got.buffer === m.buffer );

    /* */

    test.case = 'o.dims < dims, 2D';
    var buffer = a.vadMake([ 1, 2, 3, 4 ]);
    var m = _.Matrix.Make([ 2, 3 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 0,
      dims : [ 2, 2 ]
    });
    var exp = a.vadMake([ 1, 2, 3, 4 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 2, 2 ] );
    test.identical( got.dimsEffective, [ 2, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 2 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'o.dims < dims, 3D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    var m = _.Matrix.Make([ 2, 3, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 0,
      dims : [ 1, 3, 3 ]
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 1, 3, 3 ] );
    test.identical( got.dimsEffective, [ 1, 3, 3 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 1, 3 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'o.dims < dims, 4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 0,
      dims : [ 2, 3, 2, 1 ]
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 2, 3, 2, 1 ] );
    test.identical( got.dimsEffective, [ 2, 3, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 2, 6 ] );
    test.is( got.buffer === m.buffer );

    /* */

    test.case = 'o.dims < dims, 2D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8 ]);
    var m = _.Matrix.Make([ 2, 3 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 0,
      dims : [ 2, 4 ]
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 2, 4 ] );
    test.identical( got.dimsEffective, [ 2, 4 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 2 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'o.dims < dims, 3D';
    var buffer = a.vadMake
    ([
      1, 2, 3, 4, 5, 6, 7, 8, 9,
      1, 2, 3, 4, 5, 6, 7, 8, 9,
    ]);
    var m = _.Matrix.Make([ 2, 3, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 0,
      dims : [ 2, 3, 3 ]
    });
    var exp = a.vadMake
    ([
      1, 2, 3, 4, 5, 6, 7, 8, 9,
      1, 2, 3, 4, 5, 6, 7, 8, 9,
    ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 2, 3, 3 ] );
    test.identical( got.dimsEffective, [ 2, 3, 3 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 2, 6 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'o.dims > dims, 4D';
    var buffer = a.vadMake
    ([
      1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
      1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
    ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 0,
      dims : [ 2, 3, 2, 2 ]
    });
    var exp = a.vadMake
    ([
      1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
      1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
    ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 2, 3, 2, 2 ] );
    test.identical( got.dimsEffective, [ 2, 3, 2, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 2, 6, 12 ] );
    test.is( got.buffer === m.buffer );

    test.close( 'changing of dims length, inputRowMajor - 0' );

    /* - */

    test.open( 'null in dims, inputRowMajor - 0' );

    test.case = 'null does not change result, 4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 0,
      dims : [ 1, null, 2, 2 ]
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 1, 3, 2, 2 ] );
    test.identical( got.dimsEffective, [ 1, 3, 2, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 1, 3, 6 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'calculates new dimensions, 4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 0,
      dims : [ 1, 2, null ]
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 1, 2, 6 ] );
    test.identical( got.dimsEffective, [ 1, 2, 6 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 1, 2 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'calculates new dimensions, 4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 0,
      dims : [ null, 2, 2 ]
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 3, 2, 2 ] );
    test.identical( got.dimsEffective, [ 3, 2, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 3, 6 ] );
    test.is( got.buffer === m.buffer );

    test.close( 'null in dims, inputRowMajor - 0' );

    /* - */

    if( !Config.debug )
    return;

    test.case = 'without arguments';
    test.shouldThrowErrorSync( () =>
    {
      var m = _.Matrix.Make([ 2, 3 ]);
      var got = m.bufferImport();
    });

    test.case = 'extra arguments';
    test.shouldThrowErrorSync( () =>
    {
      var m = _.Matrix.Make([ 2, 3 ]);
      var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7 ]);
      var got = m.bufferImport( buffer, [ 5, null ] );
    });

    test.case = 'wrong type of buffer';
    test.shouldThrowErrorSync( () =>
    {
      var m = _.Matrix.Make([ 2, 3 ]);
      var buffer = { buffer : [ 1, 2 ] };
      var got = m.bufferImport({ buffer, dims : [ 5, null ], replacing : 1 });
    });

    test.case = 'calculates not integer in dims';
    test.shouldThrowErrorSync( () =>
    {
      var m = _.Matrix.Make([ 2, 3 ]);
      var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7 ]);
      var got = m.bufferImport({ buffer, dims : [ 5, null ], replacing : 1 });
    });

    test.case = 'new buffer is smaller than new scalarsPerMatrix';
    test.shouldThrowErrorSync( () =>
    {
      var m = _.Matrix.Make([ 2, 3 ]);
      var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8 ]);
      var got = m.bufferImport({ buffer, dims : [ 3, 3 ], replacing : 1 });
    });

    test.case = 'source buffer is not equal to new value of scalarsPerMatrix';
    test.shouldThrowErrorSync( () =>
    {
      var m = _.Matrix.Make([ 2, 3 ]);
      var buffer = a.vadMake([ 1, 2, 3 ]);
      var got = m.bufferImport({ buffer, dims : [ 2, 2 ], replacing : 1 });
    });

    test.close( `form - ${ a.form }, format - ${ a.format }` );
  }
}

//

function bufferImportOptionsReplacing1WithoutDims( test )
{
  _.vectorAdapter.contextsForTesting({ onEach : act });

  /* - */

  function act( a )
  {
    test.open( `form - ${ a.form }, format - ${ a.format }` );

    test.open( 'changing of dims length, inputRowMajor - 1' );

    test.case = '2D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6 ]);
    var m = _.Matrix.Make([ 2, 3 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 1,
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 2, 3 ] );
    test.identical( got.dimsEffective, [ 2, 3 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 2 ] );
    test.is( got.buffer === m.buffer );

    test.case = '3D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 2, 3, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 1,
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 2, 3, 2 ] );
    test.identical( got.dimsEffective, [ 2, 3, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 2, 6 ] );
    test.is( got.buffer === m.buffer );

    test.case = '4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 1,
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 1, 3, 2, 2 ] );
    test.identical( got.dimsEffective, [ 1, 3, 2, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 1, 3, 6 ] );
    test.is( got.buffer === m.buffer );

    test.close( 'changing of dims length, inputRowMajor - 1' );

    /* - */

    test.open( 'changing of dims length, inputRowMajor - 0' );

    test.case = '2D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6 ]);
    var m = _.Matrix.Make([ 2, 3 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 0,
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 2, 3 ] );
    test.identical( got.dimsEffective, [ 2, 3 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 2 ] );
    test.is( got.buffer === m.buffer );

    test.case = '3D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 2, 3, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 0,
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 2, 3, 2 ] );
    test.identical( got.dimsEffective, [ 2, 3, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 2, 6 ] );
    test.is( got.buffer === m.buffer );

    test.case = '4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 1,
      inputRowMajor : 0,
    });
    var exp = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    exp = _.vectorAdapterIs( exp ) ? exp._vectorBuffer : exp;
    test.equivalent( got.buffer, exp );
    test.identical( got.dims, [ 1, 3, 2, 2 ] );
    test.identical( got.dimsEffective, [ 1, 3, 2, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 1, 3, 6 ] );
    test.is( got.buffer === m.buffer );

    test.close( 'changing of dims length, inputRowMajor - 0' );

    /* - */

    if( !Config.debug )
    return;

    test.case = 'source buffer is not equal to new value of scalarsPerMatrix';
    test.shouldThrowErrorSync( () =>
    {
      var m = _.Matrix.Make([ 2, 3 ]);
      var buffer = a.vadMake([ 1, 2, 3 ]);
      var got = m.bufferImport({ buffer });
    });

    test.close( `form - ${ a.form }, format - ${ a.format }` );
  }
}

//

function bufferImportOptionsReplacing0AndDims( test )
{
  _.vectorAdapter.contextsForTesting({ onEach : act });

  /* - */

  function act( a )
  {
    test.open( `form - ${ a.form }, format - ${ a.format }` );

    test.open( 'changing of dims length, inputRowMajor - 1' );

    test.case = 'same dims, 2D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6 ]);
    var m = _.Matrix.Make([ 2, 3 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 1,
      dims : [ 2, 3 ]
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 4, 2, 5, 3, 6 ]) );
    test.identical( got.dims, [ 2, 3 ] );
    test.identical( got.dimsEffective, [ 2, 3 ] );
    test.identical( got.strides, [ 1, 2 ] );
    test.identical( got.stridesEffective, [ 1, 2 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'same dims, 3D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 2, 3, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 1,
      dims : [ 2, 3, 2 ]
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 4, 2, 5, 3, 6, 7, 10, 8, 11, 9, 12 ]) );
    test.identical( got.dims, [ 2, 3, 2 ] );
    test.identical( got.dimsEffective, [ 2, 3, 2 ] );
    test.identical( got.strides, [ 1, 2, 6 ] );
    test.identical( got.stridesEffective, [ 1, 2, 6 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'same dims, 4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 1,
      dims : [ 1, 3, 2, 2 ]
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]) );
    test.identical( got.dims, [ 1, 3, 2, 2 ] );
    test.identical( got.dimsEffective, [ 1, 3, 2, 2 ] );
    test.identical( got.strides, [ 1, 1, 3, 6 ] );
    test.identical( got.stridesEffective, [ 1, 1, 3, 6 ] );
    test.is( got.buffer === m.buffer );

    /* */

    test.case = 'o.dims < dims, 2D';
    var buffer = a.vadMake([ 1, 2, 3, 4 ]);
    var m = _.Matrix.Make([ 2, 3 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 1,
      dims : [ 2, 2 ]
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4, 0, 0 ]) );
    test.identical( got.dims, [ 2, 2 ] );
    test.identical( got.dimsEffective, [ 2, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 2, 1 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'o.dims < dims, 3D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    var m = _.Matrix.Make([ 2, 3, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 1,
      dims : [ 1, 3, 3 ]
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0 ]) );
    test.identical( got.dims, [ 1, 3, 3 ] );
    test.identical( got.dimsEffective, [ 1, 3, 3 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 3, 1, 3 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'o.dims < dims, 4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 1,
      dims : [ 2, 3, 2, 1 ]
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]) );
    test.identical( got.dims, [ 2, 3, 2, 1 ] );
    test.identical( got.dimsEffective, [ 2, 3, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 3, 1, 6 ] );
    test.is( got.buffer === m.buffer );

    test.close( 'changing of dims length, inputRowMajor - 1' );

    /* - */

    test.open( 'null in dims, inputRowMajor - 1' );

    test.case = 'null does not change result, 4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 1,
      dims : [ 1, null, 2, 2 ]
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]) );
    test.identical( got.dims, [ 1, 3, 2, 2 ] );
    test.identical( got.dimsEffective, [ 1, 3, 2, 2 ] );
    test.identical( got.strides, [ 1, 1, 3, 6 ] );
    test.identical( got.stridesEffective, [ 1, 1, 3, 6 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'calculates new dimensions, 4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 1,
      dims : [ 1, 2, null ]
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]) );
    test.identical( got.dims, [ 1, 2, 6 ] );
    test.identical( got.dimsEffective, [ 1, 2, 6 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 2, 1, 2 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'calculates new dimensions, 4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 1,
      dims : [ null, 2, 2 ]
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]) );
    test.identical( got.dims, [ 3, 2, 2 ] );
    test.identical( got.dimsEffective, [ 3, 2, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 2, 1, 6 ] );
    test.is( got.buffer === m.buffer );

    test.close( 'null in dims, inputRowMajor - 1' );

    /* - */

    test.open( 'changing of dims length, inputRowMajor - 0' );

    test.case = 'same dims, 2D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6 ]);
    var m = _.Matrix.Make([ 2, 3 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 0,
      dims : [ 2, 3 ]
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4, 5, 6 ]) );
    test.identical( got.dims, [ 2, 3 ] );
    test.identical( got.dimsEffective, [ 2, 3 ] );
    test.identical( got.strides, [ 1, 2 ] );
    test.identical( got.stridesEffective, [ 1, 2 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'same dims, 3D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 2, 3, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 0,
      dims : [ 2, 3, 2 ]
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]) );
    test.identical( got.dims, [ 2, 3, 2 ] );
    test.identical( got.dimsEffective, [ 2, 3, 2 ] );
    test.identical( got.strides, [ 1, 2, 6 ] );
    test.identical( got.stridesEffective, [ 1, 2, 6 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'same dims, 4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 0,
      dims : [ 1, 3, 2, 2 ]
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]) );
    test.identical( got.dims, [ 1, 3, 2, 2 ] );
    test.identical( got.dimsEffective, [ 1, 3, 2, 2 ] );
    test.identical( got.strides, [ 1, 1, 3, 6 ] );
    test.identical( got.stridesEffective, [ 1, 1, 3, 6 ] );
    test.is( got.buffer === m.buffer );

    /* */

    test.case = 'o.dims < dims, 2D';
    var buffer = a.vadMake([ 1, 2, 3, 4 ]);
    var m = _.Matrix.Make([ 2, 3 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 0,
      dims : [ 2, 2 ]
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4, 0, 0 ]) );
    test.identical( got.dims, [ 2, 2 ] );
    test.identical( got.dimsEffective, [ 2, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 2 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'o.dims < dims, 3D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
    var m = _.Matrix.Make([ 2, 3, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 0,
      dims : [ 1, 3, 3 ]
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0 ]) );
    test.identical( got.dims, [ 1, 3, 3 ] );
    test.identical( got.dimsEffective, [ 1, 3, 3 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 1, 3 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'o.dims < dims, 4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 0,
      dims : [ 2, 3, 2, 1 ]
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]) );
    test.identical( got.dims, [ 2, 3, 2, 1 ] );
    test.identical( got.dimsEffective, [ 2, 3, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 2, 6 ] );
    test.is( got.buffer === m.buffer );

    test.close( 'changing of dims length, inputRowMajor - 0' );

    /* - */

    test.open( 'null in dims, inputRowMajor - 0' );

    test.case = 'null does not change result, 4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 0,
      dims : [ 1, null, 2, 2 ]
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]) );
    test.identical( got.dims, [ 1, 3, 2, 2 ] );
    test.identical( got.dimsEffective, [ 1, 3, 2, 2 ] );
    test.identical( got.strides, [ 1, 1, 3, 6 ] );
    test.identical( got.stridesEffective, [ 1, 1, 3, 6 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'calculates new dimensions, 4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 0,
      dims : [ 1, 2, null ]
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]) );
    test.identical( got.dims, [ 1, 2, 6 ] );
    test.identical( got.dimsEffective, [ 1, 2, 6 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 1, 2 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'calculates new dimensions, 4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 0,
      dims : [ null, 2, 2 ]
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]) );
    test.identical( got.dims, [ 3, 2, 2 ] );
    test.identical( got.dimsEffective, [ 3, 2, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 3, 6 ] );
    test.is( got.buffer === m.buffer );

    test.close( 'null in dims, inputRowMajor - 0' );

    /* - */

    test.open( 'changing offset' );

    test.case = 'offset sets to 0, inputRowMajor - 1';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6 ]);
    var m = new _.Matrix
    ({
      buffer : [ -1, 0, 1, 2, 1, 1, 1, 1 ],
      offset : 1,
      dims : [ 2, 3 ],
      strides : [ 1, 2 ],
    });
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 1,
      dims : [ 2, 3 ]
    });
    test.identical( got.buffer, [ -1, 1, 4, 2, 5, 3, 6, 1 ] );
    test.identical( got.dims, [ 2, 3 ] );
    test.identical( got.dimsEffective, [ 2, 3 ] );
    test.identical( got.strides, [ 1, 2 ] );
    test.identical( got.stridesEffective, [ 1, 2 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'offset saves, inputRowMajor - 0';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6 ]);
    var m = new _.Matrix
    ({
      buffer : [ -1, 0, 1, 2, 1, 1, 1, 1 ],
      offset : 1,
      dims : [ 2, 3 ],
      strides : [ 1, 2 ],
    });
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 0,
      dims : [ 2, 3 ]
    });
    test.identical( got.buffer, [ -1, 1, 2, 3, 4, 5, 6, 1 ] );
    test.identical( got.dims, [ 2, 3 ] );
    test.identical( got.dimsEffective, [ 2, 3 ] );
    test.identical( got.strides, [ 1, 2 ] );
    test.identical( got.stridesEffective, [ 1, 2 ] );
    test.is( got.buffer === m.buffer );

    /* */

    test.case = 'offset sets to 0, inputRowMajor - 1';
    var buffer = a.vadMake([ 1, 2, 3, 4 ]);
    var m = new _.Matrix
    ({
      buffer : [ -1, 0, 1, 2, 1, 1, 1, 1 ],
      offset : 1,
      dims : [ 2, 3 ],
      strides : [ 1, 2 ],
    });
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 1,
      dims : [ 2, 2 ]
    });
    test.identical( got.buffer, [ 1, 2, 3, 4, 1, 1, 1, 1 ] );
    test.identical( got.dims, [ 2, 2 ] );
    test.identical( got.dimsEffective, [ 2, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 2, 1 ] );
    test.is( got.buffer === m.buffer );

    test.case = 'offset sets to 0, inputRowMajor - 0';
    var buffer = a.vadMake([ 1, 2, 3, 4 ]);
    var m = new _.Matrix
    ({
      buffer : [ -1, 0, 1, 2, 1, 1, 1, 1 ],
      offset : 1,
      dims : [ 2, 3 ],
      strides : [ 1, 2 ],
    });
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 0,
      dims : [ 2, 2 ]
    });
    test.identical( got.buffer, [ 1, 2, 3, 4, 1, 1, 1, 1 ] );
    test.identical( got.dims, [ 2, 2 ] );
    test.identical( got.dimsEffective, [ 2, 2 ] );
    test.identical( got.strides, null );
    test.identical( got.stridesEffective, [ 1, 2 ] );
    test.is( got.buffer === m.buffer );

    test.close( 'changing offset' );

    /* - */

    if( !Config.debug )
    return;

    test.case = 'calculates not integer in dims';
    test.shouldThrowErrorSync( () =>
    {
      var m = _.Matrix.Make([ 2, 3 ]);
      var buffer = a.vadMake([ 1, 2, 3, 4, 5 ]);
      var got = m.bufferImport({ buffer, dims : [ 5, null ], replacing : 0 });
    });

    test.case = 'matrix buffer is smaller than new scalarsPerMatrix';
    test.shouldThrowErrorSync( () =>
    {
      var m = _.Matrix.Make([ 2, 3 ]);
      var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
      var got = m.bufferImport({ buffer, dims : [ 3, 3 ], replacing : 0 });
    });

    test.case = 'source buffer is not equal to new value of scalarsPerMatrix';
    test.shouldThrowErrorSync( () =>
    {
      var m = _.Matrix.Make([ 2, 3 ]);
      var buffer = a.vadMake([ 1, 2, 3 ]);
      var got = m.bufferImport({ buffer, dims : [ 2, 2 ], replacing : 0 });
    });

    test.close( `form - ${ a.form }, format - ${ a.format }` );
  }
}

//

function bufferImportOptionsReplacing0WithoutDims( test )
{
  _.vectorAdapter.contextsForTesting({ onEach : act });

  /* - */

  function act( a )
  {
    test.open( 'changing of dims length, inputRowMajor - 1' );

    test.case = '2D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6 ]);
    var m = _.Matrix.Make([ 2, 3 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 1,
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 4, 2, 5, 3, 6 ]) );
    test.identical( got.dims, [ 2, 3 ] );
    test.identical( got.dimsEffective, [ 2, 3 ] );
    test.identical( got.strides, [ 1, 2 ] );
    test.identical( got.stridesEffective, [ 1, 2 ] );
    test.is( got.buffer === m.buffer );

    test.case = '3D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 2, 3, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 1,
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 4, 2, 5, 3, 6, 7, 10, 8, 11, 9, 12 ]) );
    test.identical( got.dims, [ 2, 3, 2 ] );
    test.identical( got.dimsEffective, [ 2, 3, 2 ] );
    test.identical( got.strides, [ 1, 2, 6 ] );
    test.identical( got.stridesEffective, [ 1, 2, 6 ] );
    test.is( got.buffer === m.buffer );

    test.case = '4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 1,
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]) );
    test.identical( got.dims, [ 1, 3, 2, 2 ] );
    test.identical( got.dimsEffective, [ 1, 3, 2, 2 ] );
    test.identical( got.strides, [ 1, 1, 3, 6 ] );
    test.identical( got.stridesEffective, [ 1, 1, 3, 6 ] );
    test.is( got.buffer === m.buffer );

    test.close( 'changing of dims length, inputRowMajor - 1' );

    /* - */

    test.open( 'changing of dims length, inputRowMajor - 0' );

    test.case = '2D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6 ]);
    var m = _.Matrix.Make([ 2, 3 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 0,
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4, 5, 6 ]) );
    test.identical( got.dims, [ 2, 3 ] );
    test.identical( got.dimsEffective, [ 2, 3 ] );
    test.identical( got.strides, [ 1, 2 ] );
    test.identical( got.stridesEffective, [ 1, 2 ] );
    test.is( got.buffer === m.buffer );

    test.case = '3D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 2, 3, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 0,
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]) );
    test.identical( got.dims, [ 2, 3, 2 ] );
    test.identical( got.dimsEffective, [ 2, 3, 2 ] );
    test.identical( got.strides, [ 1, 2, 6 ] );
    test.identical( got.stridesEffective, [ 1, 2, 6 ] );
    test.is( got.buffer === m.buffer );

    test.case = '4D';
    var buffer = a.vadMake([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]);
    var m = _.Matrix.Make([ 1, 3, 2, 2 ]);
    var got = m.bufferImport
    ({
      buffer,
      replacing : 0,
      inputRowMajor : 0,
    });
    test.identical( got.buffer, _.longDescriptor.make([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 ]) );
    test.identical( got.dims, [ 1, 3, 2, 2 ] );
    test.identical( got.dimsEffective, [ 1, 3, 2, 2 ] );
    test.identical( got.strides, [ 1, 1, 3, 6 ] );
    test.identical( got.stridesEffective, [ 1, 1, 3, 6 ] );
    test.is( got.buffer === m.buffer );

    test.close( 'changing of dims length, inputRowMajor - 0' );

    /* - */

    if( !Config.debug )
    return;

    test.case = 'source buffer is not equal to new value of scalarsPerMatrix';
    test.shouldThrowErrorSync( () =>
    {
      var m = _.Matrix.Make([ 2, 3 ]);
      var buffer = a.vadMake([ 1, 2, 3 ]);
      var got = m.bufferImport({ buffer });
    });
  }
}

//

function toStr( test )
{

  test.case = 'empty matrix, 2D';
  var matrix = _.Matrix.Make([ 0, 0 ]);
  var exp = 'Matrix.F32x.0x0 ::\n';
  var got = matrix.toStr();
  test.identical( got, exp );

  test.case = 'empty matrix, two rows';
  var matrix = _.Matrix.Make([ 2, 0 ]);
  var exp = 'Matrix.F32x.2x0 ::\n';
  var got = matrix.toStr();
  test.identical( got, exp );

  test.case = 'empty matrix, two columns';
  var matrix = _.Matrix.Make([ 0, 2 ]);
  var exp = 'Matrix.F32x.0x2 ::\n';
  var got = matrix.toStr();
  test.identical( got, exp );

  /* */

  test.case = 'a row 1x3';
  var matrix = _.Matrix.Make([ 1, 3 ]);
  var exp =
  `Matrix.F32x.1x3 ::
  +0 +0 +0`;
  var got = matrix.toStr();
  test.identical( got, exp );

  test.case = 'a columt 1x3';
  var matrix = _.Matrix.Make([ 3, 1 ]);
  var exp =
`
Matrix.F32x.3x1 ::
  +0
  +0
  +0
`;
  var got = matrix.toStr();
  test.equivalent( got, exp );

  /* */

  test.case = '2x3';
  var matrix = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);
  var exp =
`
Matrix.F32x.2x3 ::
  +1 +2 +3
  +4 +5 +6
`
  var got = matrix.toStr();
  test.equivalent( got, exp );

  /* */

  test.case = '3x2';
  var matrix = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1, 2,
    3, 4,
    5, 6,
  ]);
  var exp =
`
Matrix.F32x.3x2 ::
  +1 +2
  +3 +4
  +5 +6
`
  var got = matrix.toStr();
  test.equivalent( got, exp );

  /* */

  test.case = '2xInfinity';
  var matrix = _.Matrix.Make([ 2, Infinity ]).copy
  ([
    0,
    1,
  ]);
  var exp =
`
Matrix.F32x.2xInfinity ::
  +0 ...
  +1 ...
`
  var got = matrix.toStr();
  test.equivalent( got, exp );

  /* */

  test.case = 'Infinityx2';
  var matrix = _.Matrix.Make([ Infinity, 2 ]).copy
  ([
    0, 1,
  ]);
  var exp =
`
Matrix.F32x.Infinityx2 ::
  +0 +1
  ... ...
`
  var got = matrix.toStr();
  test.equivalent( got, exp );

  /* - */

  test.case = 'empty matrix, 3d';
  var matrix = _.Matrix.Make([ 0, 0, 0 ]);
  var exp = 'Matrix.F32x.0x0x0 ::\n';
  var got = matrix.toStr();
  test.identical( got, exp );

  test.case = 'empty matrix, 4d';
  var matrix = _.Matrix.Make([ 0, 0, 0, 0 ]);
  var exp = 'Matrix.F32x.0x0x0x0 ::\n';
  var got = matrix.toStr();
  test.identical( got, exp );

  test.case = 'empty matrix, 4d';
  var matrix = _.Matrix.Make([ 0, 0, 0, 1 ]);
  var exp = 'Matrix.F32x.0x0x0x1 ::\n';
  var got = matrix.toStr();
  test.identical( got, exp );

  test.case = 'empty matrix, 4d';
  var matrix = _.Matrix.Make([ 0, 0, 1, 0 ]);
  var exp = 'Matrix.F32x.0x0x1x0 ::\n';
  var got = matrix.toStr();
  test.identical( got, exp );

  /* */

  test.case = '2x3x4';
  var matrix = _.Matrix.Make([ 2, 3, 4 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
    10, 11, 12,
    13, 14, 15,
    16, 17, 18,
    19, 20, 21,
    22, 23, 24,
  ]);
  var exp =
`Matrix.F32x.2x3x4 ::
  Layer 0
    +1 +2 +3
    +4 +5 +6
  Layer 1
    +7 +8 +9
    +10 +11 +12
  Layer 2
    +13 +14 +15
    +16 +17 +18
  Layer 3
    +19 +20 +21
    +22 +23 +24`
  var got = matrix.toStr();
  test.identical( got, exp );

  /* */

  test.case = '1x1x2x3x4';
  var matrix = _.Matrix.Make([ 1, 1, 2, 3, 4 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
    10, 11, 12,
    13, 14, 15,
    16, 17, 18,
    19, 20, 21,
    22, 23, 24,
  ]);
  var exp =
`
Matrix.F32x.1x1x2x3x4 ::
  Layer 0 0 0
    +1
  Layer 1 0 0
    +2
  Layer 0 1 0
    +3
  Layer 1 1 0
    +4
  Layer 0 2 0
    +5
  Layer 1 2 0
    +6
  Layer 0 0 1
    +7
  Layer 1 0 1
    +8
  Layer 0 1 1
    +9
  Layer 1 1 1
    +10
  Layer 0 2 1
    +11
  Layer 1 2 1
    +12
  Layer 0 0 2
    +13
  Layer 1 0 2
    +14
  Layer 0 1 2
    +15
  Layer 1 1 2
    +16
  Layer 0 2 2
    +17
  Layer 1 2 2
    +18
  Layer 0 0 3
    +19
  Layer 1 0 3
    +20
  Layer 0 1 3
    +21
  Layer 1 1 3
    +22
  Layer 0 2 3
    +23
  Layer 1 2 3
    +24
`
  var got = matrix.toStr();
  test.equivalent( got, exp );

  /* */

  test.case = '2x3xInfinity';
  var matrix = _.Matrix.Make([ 2, 3, Infinity ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);
  var exp =
`
Matrix.F32x.2x3xInfinity ::
  Layer
    +1 +2 +3
    +4 +5 +6
`
  var got = matrix.toStr();
  test.equivalent( got, exp );

  /* */

}

//

function toStrStandard( test )
{

  test.case = 'String( matrix )';
  var matrix = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);
  var got = String( matrix );
  var exp =
  `Matrix.F32x.2x3 ::
  +1 +2 +3
  +4 +5 +6`;
  test.identical( got, exp );

  test.case = 'vad.toStr()';
  var matrix = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);
  var got = matrix.toStr();
  var exp =
  `Matrix.F32x.2x3 ::
  +1 +2 +3
  +4 +5 +6`;
  test.identical( got, exp );

  test.case = 'Object.prototype.toString';
  var matrix = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);
  var got = Object.prototype.toString.call( matrix );
  var exp = '[object Matrix]';
  test.identical( got, exp );

}

//

function toLong( test )
{

  /* */

  test.case = 'smaller buffer, explicit strides';

  var buffer = new I32x([ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]);
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 3, 2 ],
    strides : [ 1, 4 ],
  });

  test.identical( m.dims, [ 3, 2 ] );
  test.identical( m.dimsEffective, [ 3, 2 ] );
  test.identical( m.strides, [ 1, 4 ] );
  test.identical( m.stridesEffective, [ 1, 4 ] );
  test.identical( m.toLong(), new I32x([ 1, 2, 3, 5, 6, 7 ]) );

  /* */

  test.case = '2x3x4';
  var matrix = _.Matrix
  ({
    dims : [ 2, 3, 4 ],
    inputRowMajor : 0,
    buffer :
    [
      1, 2, 3,
      4, 5, 6,
      7, 8, 9,
      10, 11, 12,
      13, 14, 15,
      16, 17, 18,
      19, 20, 21,
      22, 23, 24,
    ]
  });
  var exp =
  [
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
    10, 11, 12,
    13, 14, 15,
    16, 17, 18,
    19, 20, 21,
    22, 23, 24,
  ];
  var got = matrix.toLong();
  test.identical( got, exp );

  /* */

  test.case = 'dims : [ 6, 2 ], overlap';
  var m = new _.Matrix
  ({
    buffer : new I32x([ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]),
    offset : 1,
    strides : [ 1, 4 ],
    dims : [ 6, 2 ],
  });

  test.identical( m.offset, 1 );
  test.identical( m.dims, [ 6, 2 ] );
  test.identical( m.dimsEffective, [ 6, 2 ] );
  test.identical( m.strides, [ 1, 4 ] );
  test.identical( m.stridesEffective, [ 1, 4 ] );
  test.identical( m.toLong(), new I32x([ 1, 2, 3, 4, 5, 6, 5, 6, 7, 8, 9, 10 ]) );
  logger.log( m.toStr() );

  /* */

}

//

function log()
{
  let logger = new _.LoggerToString();

  test.case = 'several';
  var exp = '.';
  var v1 = _.vectorAdapter.from([ 1, 2, 3 ]);
  var m1 = _.Matrix.MakeIdentity( 2 );
  logger.log( m1, v1, 3 );
  test.identical( logger.text, exp );

}

// --
// setting
// --

function bufferSetBasic( test )
{

  /* */

  test.case = 'control';

  var buffer = new I32x([ 1, 2, 3, 4, 5, 6 ]);
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 3, 2 ],
    inputRowMajor : 1,
  });

  test.identical( m.dims, [ 3, 2 ] );
  test.identical( m.dimsEffective, [ 3, 2 ] );
  test.identical( m.strides, null );
  test.identical( m.stridesEffective, [ 2, 1 ] );
  test.identical( m.toLong(), new I32x([ 1, 3, 5, 2, 4, 6 ]) );
  logger.log( m.toStr() );

  /* */

  test.case = 'smaller buffer, inputRowMajor:0';

  var buffer = new I32x([ 1, 2, 3, 4, 5, 6 ]);
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 3, 2 ],
    inputRowMajor : 1,
  });

  m.copy({ buffer : new I16x([ 11, 12, 13, 14 ]), dims : [ 2, 2 ], inputRowMajor : 0 });

  test.identical( m.dims, [ 2, 2 ] );
  test.identical( m.dimsEffective, [ 2, 2 ] );
  test.identical( m.strides, null );
  test.identical( m.stridesEffective, [ 1, 2 ] );
  test.identical( m.toLong(), new I16x([ 11, 12, 13, 14 ]) );

  /* */

  test.case = 'smaller buffer, inputRowMajor:1';

  var buffer = new I32x([ 1, 2, 3, 4, 5, 6 ]);
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 3, 2 ],
    inputRowMajor : 1,
  });

  m.copy({ buffer : new I16x([ 11, 12, 13, 14 ]), dims : [ 2, 2 ], inputRowMajor : 1 });

  test.identical( m.dims, [ 2, 2 ] );
  test.identical( m.dimsEffective, [ 2, 2 ] );
  test.identical( m.strides, null );
  test.identical( m.stridesEffective, [ 2, 1 ] );
  test.identical( m.toLong(), new I16x([ 11, 13, 12, 14 ]) );

  /* */

  test.case = 'smaller buffer, explicit strides';

  var buffer = new I32x([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]);
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 3, 2 ],
    strides : [ 1, 4 ],
  });

  test.identical( m.dims, [ 3, 2 ] );
  test.identical( m.dimsEffective, [ 3, 2 ] );
  test.identical( m.strides, [ 1, 4 ] );
  test.identical( m.stridesEffective, [ 1, 4 ] );
  test.identical( m.toLong(), new I32x([ 1, 2, 3, 5, 6, 7 ]) );

  m.copy({ buffer : new I16x([ 11, 12, 13, 14 ]), dims : [ 2, 2 ], strides : [ 2, 1 ] });

  test.identical( m.dims, [ 2, 2 ] );
  test.identical( m.dimsEffective, [ 2, 2 ] );
  test.identical( m.strides, [ 2, 1 ] );
  test.identical( m.stridesEffective, [ 2, 1 ] );
  test.identical( m.toLong(), new I16x([ 11, 13, 12, 14 ]) );

  /* */

  test.case = 'larger buffer, inputRowMajor:0';

  var buffer = new I32x([ 1, 2, 3, 4, 5, 6 ]);
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 3, 2 ],
    inputRowMajor : 1,
  });

  m.copy({ buffer : new I16x([ 11, 12, 13, 14, 15, 16, 17, 18 ]), dims : [ 4, 2 ], inputRowMajor : 0 });

  test.identical( m.dims, [ 4, 2 ] );
  test.identical( m.dimsEffective, [ 4, 2 ] );
  test.identical( m.strides, null );
  test.identical( m.stridesEffective, [ 1, 4 ] );
  test.identical( m.toLong(), new I16x([ 11, 12, 13, 14, 15, 16, 17, 18 ]) );

  /* */

  test.case = 'larger buffer, inputRowMajor:1';

  var buffer = new I32x([ 1, 2, 3, 4, 5, 6 ]);
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 3, 2 ],
    inputRowMajor : 1,
  });

  m.copy({ buffer : new I16x([ 11, 12, 13, 14, 15, 16, 17, 18 ]), dims : [ 4, 2 ], inputRowMajor : 1 });

  test.identical( m.dims, [ 4, 2 ] );
  test.identical( m.dimsEffective, [ 4, 2 ] );
  test.identical( m.strides, null );
  test.identical( m.stridesEffective, [ 2, 1 ] );
  test.identical( m.toLong(), new I16x([ 11, 13, 15, 17, 12, 14, 16, 18 ]) );

  /* */

  test.case = 'larger buffer, explicit strides';

  var buffer = new I32x([ 1, 2, 3, 4, 5, 6, 7 ]);
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 3, 2 ],
    strides : [ 1, 4 ],
  });

  test.identical( m.dims, [ 3, 2 ] );
  test.identical( m.dimsEffective, [ 3, 2 ] );
  test.identical( m.strides, [ 1, 4 ] );
  test.identical( m.stridesEffective, [ 1, 4 ] );
  test.identical( m.toLong(), new I32x([ 1, 2, 3, 5, 6, 7 ]) );

  m.copy({ buffer : new I16x([ 11, 12, 13, 14, 15, 16, 17, 18, 19 ]), dims : [ 4, 2 ], strides : [ 1, 5 ] });

  test.identical( m.dims, [ 4, 2 ] );
  test.identical( m.dimsEffective, [ 4, 2 ] );
  test.identical( m.strides, [ 1, 5 ] );
  test.identical( m.stridesEffective, [ 1, 5 ] );
  test.identical( m.toLong(), new I16x([ 11, 12, 13, 14, 16, 17, 18, 19 ]) );

  /* */

  test.case = 'smaller dimension';

  var buffer = new I32x([ 1, 2, 3, 4, 5, 6 ]);
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 3, 2 ],
    inputRowMajor : 1,
  });

  m.dims = [ 2, 2 ];

  test.identical( m.dims, [ 2, 2 ] );
  test.identical( m.dimsEffective, [ 2, 2 ] );
  test.identical( m.strides, null );
  test.identical( m.stridesEffective, [ 1, 2 ] );
  test.identical( m.toLong(), new I32x([ 1, 2, 3, 4 ]) );

  /* */

  test.case = 'larger dimension';

  var buffer = new I32x([ 1, 2, 3, 4, 5, 6 ]);
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 2 ],
    inputRowMajor : 1,
  });

  m.dims = [ 3, 2 ];

  test.identical( m.dims, [ 3, 2 ] );
  test.identical( m.dimsEffective, [ 3, 2 ] );
  test.identical( m.strides, null );
  test.identical( m.stridesEffective, [ 1, 3 ] );
  test.identical( m.toLong(), new I32x([ 1, 2, 3, 4, 5, 6 ]) );

  /* */

  test.case = 'copy buffer then dims';

  var buffer = new I32x([ 1, 2, 3, 4, 5, 6 ]);
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 3, 2 ],
    inputRowMajor : 1,
  });

  m.buffer = new I16x([ 0, 1, 2, 3, 4, 5, 6, 7 ])
  m.copy({ buffer : new I16x([ 3, 4, 5 ]), dims : [ 3, 1 ], inputRowMajor : 0 });

  test.identical( m.dims, [ 3, 1 ] );
  test.identical( m.dimsEffective, [ 3, 1 ] );
  test.identical( m.strides, null );
  test.identical( m.stridesEffective, [ 1, 3 ] );

  /* */

  test.case = 'copy dims then buffer';

  var buffer = new I32x([ 1, 2, 3, 4, 5, 6 ]);
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 3, 2 ],
    inputRowMajor : 1,
  });

  m.dims = [ 1, 3 ];
  m.copy({ dims : [ 3, 1 ], buffer : new I16x([ 3, 4, 5 ]), inputRowMajor : 0 });

  test.identical( m.dims, [ 3, 1 ] );
  test.identical( m.dimsEffective, [ 3, 1 ] );
  test.identical( m.strides, null );
  test.identical( m.stridesEffective, [ 1, 3 ] );

  /* */

  if( !Config.debug )
  return;

  test.case = 'throwing';

  var m = new _.Matrix
  ({
    buffer : new F32x([ 1, 2, 3, 4, 5, 6 ]),
    dims : [ 3, 2 ],
    inputRowMajor : 0,
  });
  test.shouldThrowErrorSync( () => a.buffer = new F32x([ 11, 12, 13 ]) );

}

//

function bufferSetResetOffset( test )
{

  /* */

  test.case = 'smaller buffer, explicit strides';

  var buffer = new I32x([ 0, 1, 2, 3, 4, 5, 6, 7, 8 ]);
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3 ],
    strides : [ 1, 3 ],
    offset : 1,
  });

  test.identical( m.offset, 1 );
  test.identical( m.dims, [ 2, 3 ] );
  test.identical( m.dimsEffective, [ 2, 3 ] );
  test.identical( m.strides, [ 1, 3 ] );
  test.identical( m.stridesEffective, [ 1, 3 ] );
  test.identical( m.toLong(), new I32x([ 1, 2, 4, 5, 7, 8 ]) );

  logger.log( m.toStr() );

  m.copy({ buffer : new I16x([ 11, 12, 13, 14, 15, 16 ]), dims : [ 3, 2 ], strides : [ 2, 1 ] });

  test.identical( m.offset, 0 );
  test.identical( m.dims, [ 3, 2 ] );
  test.identical( m.dimsEffective, [ 3, 2 ] );
  test.identical( m.strides, [ 2, 1 ] );
  test.identical( m.stridesEffective, [ 2, 1 ] );
  test.identical( m.toLong(), new I16x([ 11, 13, 15, 12, 14, 16 ]) );

  /* */

}

//

function bufferSetEmpty( test )
{

  /* */

  test.case = 'dims:[ 0, 3 ], strides:[ 3, 1 ]';

  var m = _.Matrix
  ({
    dims : [ 0, 3 ],
    strides : [ 3, 1 ],
  });

  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.dimsEffective, [ 0, 3 ] );
  test.identical( m.strides, [ 3, 1 ] );
  test.identical( m.stridesEffective, [ 3, 1 ] );

  m.buffer = new I32x();

  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.dimsEffective, [ 0, 3 ] );
  test.identical( m.strides, [ 3, 1 ] );
  test.identical( m.stridesEffective, [ 3, 1 ] );

  m.copy({ buffer : new I32x() });

  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.dimsEffective, [ 0, 3 ] );
  test.identical( m.strides, [ 3, 1 ] );
  test.identical( m.stridesEffective, [ 3, 1 ] );

  m.buffer = new I32x([ 1, 2, 3, 4, 5, 6 ]);

  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.dimsEffective, [ 0, 3 ] );
  test.identical( m.strides, [ 3, 1 ] );
  test.identical( m.stridesEffective, [ 3, 1 ] );

  m.copy({ buffer : new I32x([ 1, 2, 3, 4, 5, 6 ]) });

  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.dimsEffective, [ 0, 3 ] );
  test.identical( m.strides, [ 3, 1 ] );
  test.identical( m.stridesEffective, [ 3, 1 ] );

  /* */

  test.case = 'dims:[ 0, 3 ], strides:[ 3, 0 ]';

  var m = _.Matrix
  ({
    dims : [ 0, 3 ],
    strides : [ 3, 0 ],
  });

  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.dimsEffective, [ 0, 3 ] );
  test.identical( m.strides, [ 3, 0 ] );
  test.identical( m.stridesEffective, [ 3, 0 ] );

  m.buffer = new I32x();

  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.dimsEffective, [ 0, 3 ] );
  test.identical( m.strides, [ 3, 0 ] );
  test.identical( m.stridesEffective, [ 3, 0 ] );

  m.copy({ buffer : new I32x() });

  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.dimsEffective, [ 0, 3 ] );
  test.identical( m.strides, [ 3, 0 ] );
  test.identical( m.stridesEffective, [ 3, 0 ] );

  m.buffer = new I32x([ 1, 2, 3, 4, 5, 6 ]);

  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.dimsEffective, [ 0, 3 ] );
  test.identical( m.strides, [ 3, 0 ] );
  test.identical( m.stridesEffective, [ 3, 0 ] );

  m.copy({ buffer : new I32x([ 1, 2, 3, 4, 5, 6 ]) });

  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.dimsEffective, [ 0, 3 ] );
  test.identical( m.strides, [ 3, 0 ] );
  test.identical( m.stridesEffective, [ 3, 0 ] );

  /* */

  test.case = 'dims:[ 3, 0 ], strides:[ 1, 3 ]';

  var m = _.Matrix
  ({
    dims : [ 3, 0 ],
    strides : [ 1, 3 ],
  });

  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m.dimsEffective, [ 3, 0 ] );
  test.identical( m.strides, [ 1, 3 ] );
  test.identical( m.stridesEffective, [ 1, 3 ] );

  m.buffer = new I32x();

  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m.dimsEffective, [ 3, 0 ] );
  test.identical( m.strides, [ 1, 3 ] );
  test.identical( m.stridesEffective, [ 1, 3 ] );

  m.copy({ buffer : new I32x() });

  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m.dimsEffective, [ 3, 0 ] );
  test.identical( m.strides, [ 1, 3 ] );
  test.identical( m.stridesEffective, [ 1, 3 ] );

  m.buffer = new I32x([ 1, 2, 3, 4, 5, 6 ]);

  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m.dimsEffective, [ 3, 0 ] );
  test.identical( m.strides, [ 1, 3 ] );
  test.identical( m.stridesEffective, [ 1, 3 ] );

  m.copy({ buffer : new I32x([ 1, 2, 3, 4, 5, 6 ]) });

  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m.dimsEffective, [ 3, 0 ] );
  test.identical( m.strides, [ 1, 3 ] );
  test.identical( m.stridesEffective, [ 1, 3 ] );

  /* */

  test.case = 'dims:[ 3, 0 ], strides:[ 0, 3 ]';

  var m = _.Matrix
  ({
    dims : [ 3, 0 ],
    strides : [ 0, 3 ],
  });

  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m.dimsEffective, [ 3, 0 ] );
  test.identical( m.strides, [ 0, 3 ] );
  test.identical( m.stridesEffective, [ 0, 3 ] );

  m.buffer = new I32x();

  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m.dimsEffective, [ 3, 0 ] );
  test.identical( m.strides, [ 0, 3 ] );
  test.identical( m.stridesEffective, [ 0, 3 ] );

  m.copy({ buffer : new I32x() });

  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m.dimsEffective, [ 3, 0 ] );
  test.identical( m.strides, [ 0, 3 ] );
  test.identical( m.stridesEffective, [ 0, 3 ] );

  m.buffer = new I32x([ 1, 2, 3, 4, 5, 6 ]);

  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m.dimsEffective, [ 3, 0 ] );
  test.identical( m.strides, [ 0, 3 ] );
  test.identical( m.stridesEffective, [ 0, 3 ] );

  m.copy({ buffer : new I32x([ 1, 2, 3, 4, 5, 6 ]) });

  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m.dimsEffective, [ 3, 0 ] );
  test.identical( m.strides, [ 0, 3 ] );
  test.identical( m.stridesEffective, [ 0, 3 ] );

  /* */

}

//

function bufferSetFromVectorAdapter( test )
{

  _.vectorAdapter.contextsForTesting
  ({
    onEach : act,
/*
    varyingFormat : 'Array',
    varyingForm : 'straight',
*/
  });

  function act( a )
  {

    /* */

    test.case = `${a.format} ${a.form} basic`;

    var m = new _.Matrix
    ({
      buffer : new I32x([ 1, 2, 3, 4, 5, 6 ]),
      dims : [ 3, 2 ],
      strides : [ 1, 3 ]
    });

    test.identical( m.dims, [ 3, 2 ] );
    test.identical( m.dimsEffective, [ 3, 2 ] );

    var vad = a.vadMake([ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]);

    m.copy
    ({
      buffer : vad,
      offset : 1,
      strides : [ 3, 1 ],
      dims : [ 3, 2 ],
    })
    logger.log( m.toStr() );

    test.identical( m.dims, [ 3, 2 ] );
    test.identical( m.dimsEffective, [ 3, 2 ] );

    var exp = a.longMake( [ 1, 4, 7, 2, 5, 8 ] );
    var got = m.toLong();
    test.identical( got, exp );

    var exp = new _.Matrix
    ({
      buffer : a.longMake([ 1, 4, 7, 2, 5, 8 ]),
      dims : [ 3, 2 ],
      inputRowMajor : 0,
    });
    test.identical( m, exp );

    /* */

    test.case = `${a.format} ${a.form} without dims, strides : explicit`;

    var m = new _.Matrix
    ({
      buffer : new I32x([ 1, 2, 3, 4, 5, 6 ]),
      dims : [ 3, 2 ],
      inputRowMajor : 0,
    });

    test.identical( m.dims, [ 3, 2 ] );
    test.identical( m.dimsEffective, [ 3, 2 ] );

    var vad = a.vadMake([ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]);

    m.copy
    ({
      buffer : vad,
      offset : 1,
      strides : [ 3, 1 ],
    });
    logger.log( m.toStr() );

    test.identical( m.dims, [ 3, 2 ] );
    test.identical( m.dimsEffective, [ 3, 2 ] );

    var exp = a.longMake( [ 1, 4, 7, 2, 5, 8 ] );
    var got = m.toLong();
    test.identical( got, exp );

    var exp = new _.Matrix
    ({
      buffer : a.longMake([ 1, 4, 7, 2, 5, 8 ]),
      dims : [ 3, 2 ],
      inputRowMajor : 0,
    });
    test.identical( m, exp );

    /* */

    test.case = `${a.format} ${a.form} without dims, strides : implicit`;

    var m = new _.Matrix
    ({
      buffer : new I32x([ 1, 2, 3, 4, 5, 6 ]),
      dims : [ 3, 2 ],
      inputRowMajor : 0,
    });

    test.identical( m.dims, [ 3, 2 ] );
    test.identical( m.dimsEffective, [ 3, 2 ] );

    var vad = a.vadMake([ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]);

    m.copy
    ({
      buffer : vad,
      offset : 1,
      inputRowMajor : 0,
    });

    test.identical( m.dims, [ 3, 2 ] );
    test.identical( m.dimsEffective, [ 3, 2 ] );

    var exp = a.longMake( [ 1, 2, 3, 4, 5, 6 ] );
    var got = m.toLong();
    test.identical( got, exp );

    var exp = new _.Matrix
    ({
      buffer : a.longMake([ 1, 2, 3, 4, 5, 6 ]),
      dims : [ 3, 2 ],
      inputRowMajor : 0,
    });
    test.identical( m, exp );

    /* */

    test.case = `${a.format} ${a.form} imm copy`;

    var m = new _.Matrix
    ({
      buffer : new I32x([ 1, 2, 3, 4, 5, 6 ]),
      dims : [ 3, 2 ],
      inputRowMajor : 0,
    });

    test.identical( m.dims, [ 3, 2 ] );
    test.identical( m.dimsEffective, [ 3, 2 ] );

    var vad = a.vadMake([ 0, 1, 2, 3, 4, 5 ]);

    m.copy( vad );
    logger.log( m.toStr() );

    test.identical( m.dims, [ 3, 2 ] );
    test.identical( m.dimsEffective, [ 3, 2 ] );

    var exp = new I32x([ 0, 2, 4, 1, 3, 5 ]);
    var got = m.toLong();
    test.identical( got, exp );

    var exp = new _.Matrix
    ({
      buffer : new I32x([ 0, 2, 4, 1, 3, 5 ]),
      dims : [ 3, 2 ],
      inputRowMajor : 0,
    });
    test.identical( m, exp );

    /* */

  }

}

// --
// utils
// --

function StridesFromDimensions( test )
{

  /* - */

  test.case = 'basic 2d, inputRowMajor : 0';
  var dims = [ 2, 3 ]
  var exp = [ 1, 2 ];
  var got = _.Matrix.StridesFromDimensions( dims, 0 )
  test.identical( got, exp );

  /* */

  test.case = 'basic 2d, inputRowMajor : 1';
  var dims = [ 2, 3 ]
  var exp = [ 3, 1 ];
  var got = _.Matrix.StridesFromDimensions( dims, 1 )
  test.identical( got, exp );

  /* */

  test.case = 'basic 3d, inputRowMajor : 0';
  var dims = [ 2, 3, 4 ]
  var exp = [ 1, 2, 6 ];
  var got = _.Matrix.StridesFromDimensions( dims, 0 )
  test.identical( got, exp );

  /* */

  test.case = 'basic 3d, inputRowMajor : 1';
  var dims = [ 2, 3, 4 ]
  var exp = [ 3, 1, 6 ];
  var got = _.Matrix.StridesFromDimensions( dims, 1 )
  test.identical( got, exp );

  /* */

  test.case = 'basic 4d, inputRowMajor : 0';
  var dims = [ 2, 3, 4, 5 ]
  var exp = [ 1, 2, 6, 24 ];
  var got = _.Matrix.StridesFromDimensions( dims, 0 )
  test.identical( got, exp );

  /* */

  test.case = 'basic 4d, inputRowMajor : 1';
  var dims = [ 2, 3, 4, 5 ]
  var exp = [ 3, 1, 6, 24 ];
  var got = _.Matrix.StridesFromDimensions( dims, 1 )
  test.identical( got, exp );

  /* - */

  test.case = 'empty 2d, inputRowMajor : 0';
  var dims = [ 0, 0 ]
  var exp = [ 1, 0 ];
  var got = _.Matrix.StridesFromDimensions( dims, 0 )
  test.identical( got, exp );

  /* */

  test.case = 'empty 2d, inputRowMajor : 1';
  var dims = [ 0, 0 ]
  var exp = [ 0, 1 ];
  var got = _.Matrix.StridesFromDimensions( dims, 1 )
  test.identical( got, exp );

  /* */

  test.case = 'empty 3d, inputRowMajor : 0';
  var dims = [ 0, 0, 0 ]
  var exp = [ 1, 0, 0 ];
  var got = _.Matrix.StridesFromDimensions( dims, 0 )
  test.identical( got, exp );

  /* */

  test.case = 'empty 3d, inputRowMajor : 1';
  var dims = [ 0, 0, 0 ]
  var exp = [ 0, 1, 0 ];
  var got = _.Matrix.StridesFromDimensions( dims, 1 )
  test.identical( got, exp );

  /* */

  test.case = 'empty 4d, inputRowMajor : 0';
  var dims = [ 0, 0, 0, 0 ]
  var exp = [ 1, 0, 0, 0 ];
  var got = _.Matrix.StridesFromDimensions( dims, 0 )
  test.identical( got, exp );

  /* */

  test.case = 'empty 4d, inputRowMajor : 1';
  var dims = [ 0, 0, 0, 0 ]
  var exp = [ 0, 1, 0, 0 ];
  var got = _.Matrix.StridesFromDimensions( dims, 1 )
  test.identical( got, exp );

  /* - */

  test.case = 'unity 2d, inputRowMajor : 0';
  var dims = [ 1, 1 ]
  var exp = [ 1, 1 ];
  var got = _.Matrix.StridesFromDimensions( dims, 0 )
  test.identical( got, exp );

  /* */

  test.case = 'unity 2d, inputRowMajor : 1';
  var dims = [ 1, 1 ]
  var exp = [ 1, 1 ];
  var got = _.Matrix.StridesFromDimensions( dims, 1 )
  test.identical( got, exp );

  /* */

  test.case = 'unity 3d, inputRowMajor : 0';
  var dims = [ 1, 1, 1 ]
  var exp = [ 1, 1, 1 ];
  var got = _.Matrix.StridesFromDimensions( dims, 0 )
  test.identical( got, exp );

  /* */

  test.case = 'unity 3d, inputRowMajor : 1';
  var dims = [ 1, 1, 1 ]
  var exp = [ 1, 1, 1 ];
  var got = _.Matrix.StridesFromDimensions( dims, 1 )
  test.identical( got, exp );

  /* */

  test.case = 'unity 4d, inputRowMajor : 0';
  var dims = [ 1, 1, 1, 1 ]
  var exp = [ 1, 1, 1, 1 ];
  var got = _.Matrix.StridesFromDimensions( dims, 0 )
  test.identical( got, exp );

  /* */

  test.case = 'unity 4d, inputRowMajor : 1';
  var dims = [ 1, 1, 1, 1 ]
  var exp = [ 1, 1, 1, 1 ];
  var got = _.Matrix.StridesFromDimensions( dims, 1 )
  test.identical( got, exp );

  /* - */

}

//

function TempBorrow( test )
{

  /* */

  test.case = 'should give same temp';

  var m = _.Matrix.Make([ 3, 2 ]);
  var t1 = m.tempBorrow();

  test.identical( t1.dims, [ 3, 2 ] )
  test.identical( t1.stridesEffective, [ 1, 3 ] )

  var t2 = m.tempBorrow();
  var t3 = _.Matrix.TempBorrow( m );
  var t3 = _.Matrix.TempBorrow( m.dims );

  test.is( t1 === t2 );
  test.is( t1 === t3 );

  test.is( t1.buffer.constructor === F32x );
  test.is( t2.buffer.constructor === F32x );
  test.is( t3.buffer.constructor === F32x );

  /* */

  test.case = 'should give another temp';

  var m = _.Matrix.Make([ 3, 2 ]);
  m.buffer = new I32x( 6 );
  var t2 = m.tempBorrow();

  test.identical( t2.dims, [ 3, 2 ] )
  test.identical( t2.stridesEffective, [ 1, 3 ] )

  var t3 = m.tempBorrow();
  var t4 = _.Matrix.TempBorrow( m );
  var t5 = _.Matrix.TempBorrow( m.dims );

  test.is( t1 !== t2 );
  test.is( t2 === t3 );
  test.is( t2 === t4 );
  test.is( t1 === t5 );

  test.is( t2.buffer.constructor === I32x );
  test.is( t3.buffer.constructor === I32x );
  test.is( t4.buffer.constructor === I32x );
  test.is( t5.buffer.constructor === F32x );

  /* */

  test.case = 'with dims';

  var m = _.Matrix.Make([ 3, 2 ]);
  m.buffer = new I32x( 6 );
  var t1 = _.Matrix._TempBorrow( m, [ 4, 4 ], 0 );
  var t2 = _.Matrix._TempBorrow( m, [ 4, 4 ], 1 );

  test.identical( t1.dims, [ 4, 4 ] );
  test.identical( t2.dims, [ 4, 4 ] );
  test.is( t1.buffer.constructor === I32x );
  test.is( t2.buffer.constructor === I32x );
  test.is( t1 !== t2 );

  /* */

  test.case = 'with dims from matrix';

  var m = _.Matrix.Make([ 3, 2 ]);
  m.buffer = new I32x( 6 );
  var m2 = _.Matrix.Make([ 4, 4 ]);
  var t1 = _.Matrix._TempBorrow( m, m2, 0 );
  var t2 = _.Matrix._TempBorrow( m, m2, 1 );

  test.identical( t1.dims, [ 4, 4 ] );
  test.identical( t2.dims, [ 4, 4 ] );
  test.is( t1.buffer.constructor === I32x );
  test.is( t2.buffer.constructor === I32x );
  test.is( t1 !== t2 );

  /* */

  test.case = 'without dims';

  var m = _.Matrix.Make([ 3, 2 ]);
  m.buffer = new I32x( 6 );
  var t1 = _.Matrix._TempBorrow( m, null, 0 );
  var t2 = _.Matrix._TempBorrow( m, null, 1 );

  test.identical( t1.dims, [ 3, 2 ] );
  test.identical( t2.dims, [ 3, 2 ] );
  test.is( t1.buffer.constructor === I32x );
  test.is( t2.buffer.constructor === I32x );
  test.is( t1 !== t2 );

  /* */

  test.case = 'without matrix';

  var t1 = _.Matrix._TempBorrow( null, [ 4, 4 ], 0 );
  var t2 = _.Matrix._TempBorrow( null, [ 4, 4 ], 1 );

  test.identical( t1.dims, [ 4, 4 ] );
  test.identical( t2.dims, [ 4, 4 ] );
  test.is( t1.buffer.constructor === F32x );
  test.is( t2.buffer.constructor === F32x );
  test.is( t1 !== t2 );

}

// --
// structural
// --

function offset( test )
{

  /* */

  test.case = 'init';

  var buffer =
  [
    -1, -1,
    1, 2,
    3, 4,
    5, 6,
    11, 11,
  ]

  var m = _.Matrix.Make([ 3, 2 ]);

  m.copy
  ({
    buffer,
    offset : 2,
    dims : [ 3, 2 ],
    inputRowMajor : 1,
  });

  console.log( `m\n${m.toStr()}` );

  test.is( m.buffer instanceof Array );

  /* */

  test.case = 'scalarGet';

  test.identical( m.scalarGet([ 0, 0 ]), 1 );
  test.identical( m.scalarGet([ 2, 1 ]), 6 );

  /* */

  test.case = 'scalarFlatGet';

  test.identical( m.scalarFlatGet( 0 ), 1 );
  test.identical( m.scalarFlatGet( 5 ), 6 );

  /* */

  test.case = 'scalarSet, scalarFlatSet';

  m.scalarSet([ 0, 0 ], 101 );
  m.scalarSet([ 2, 1 ], 106 );
  m.scalarFlatSet( 1, 102 );
  m.scalarFlatSet( 4, 105 );

  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ({
    buffer : [ 101, 102, 3, 4, 105, 106 ],
    inputRowMajor : 1,
  });

  console.log( `m\n${m.toStr()}` );
  console.log( `exp\n${exp.toStr()}` );

  test.identical( m, exp );

  /*  */

  test.case = 'scalarGet 0 0 0';

  var m = _.Matrix.Make([ 3, 2 ]).copy
  ({
    buffer :
    [
      1, 2,
      3, 4,
      5, 6,
    ],
    inputRowMajor : 1,
  });

  var got = m.scalarGet([ 0, 0, 0, 0 ])
  test.identical( got, 1 );
  var got = m.scalarGet([ 2, 1, 0, 0 ])
  test.identical( got, 6 );

  /* */

  test.case = 'bad arguments';

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () => m.scalarFlatGet() );
  test.shouldThrowErrorSync( () => m.scalarFlatGet( '' ) );
  test.shouldThrowErrorSync( () => m.scalarFlatGet( '0' ) );
  test.shouldThrowErrorSync( () => m.scalarFlatGet( -1 ) );
  test.shouldThrowErrorSync( () => m.scalarFlatGet( 6 ) );

  test.shouldThrowErrorSync( () => m.scalarFlatSet( -1, -1 ) );
  test.shouldThrowErrorSync( () => m.scalarFlatSet( 6, -1 ) );

  test.shouldThrowErrorSync( () => m.scalarGet() );
  test.shouldThrowErrorSync( () => m.scalarGet( '' ) );
  test.shouldThrowErrorSync( () => m.scalarGet( '0' ) );
  test.shouldThrowErrorSync( () => m.scalarGet( [] ) );
  test.shouldThrowErrorSync( () => m.scalarGet([ 3, 0 ]) );
  test.shouldThrowErrorSync( () => m.scalarGet([ 0, 2 ]) );

  test.shouldThrowErrorSync( () => m.scalarSet( [ 3, 0 ], -1 ) );
  test.shouldThrowErrorSync( () => m.scalarSet( [ 0, 2 ], -1 ) );

}

//

function stride( test )
{

  /* */

  test.case = '2x2 same strides';

  var buffer = new F32x
  ([
    -1,
    1, -1, 2, -1,
    3, -1, 4, -1,
    -1,
  ]);

  var m = _.Matrix
  ({
    dims : [ 2, 2 ],
    inputRowMajor : 1,
    offset : 1,
    buffer,
    strides : [ 2, 2 ],
  });

  var exp = _.Matrix.Make([ 2, 2 ]).copy
  ([
    1, 2,
    2, 3,
  ]);

  test.identical( m.occupiedRange, [ 1, 6 ] );
  test.identical( m, exp );
  test.identical( m.strides, [ 2, 2 ] );
  test.identical( m.stridesEffective, [ 2, 2 ] );
  logger.log( m );

  /* */

  test.case = '2x3 same strides';

  var buffer = new F32x
  ([
    -1,
    1, -1, 2, -1, 3, -1,
    4, -1, 5, -1, 6, -1,
    -1,
  ]);

  var m = _.Matrix
  ({
    dims : [ 2, 3 ],
    inputRowMajor : 1,
    offset : 1,
    buffer,
    strides : [ 2, 2 ],
  });

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    2, 3, 4,
  ]);

  test.identical( m, exp );
  test.identical( m.strides, [ 2, 2 ] );
  test.identical( m.stridesEffective, [ 2, 2 ] );
  logger.log( m );

}

//

function strideNegative( test )
{
  test.case = 'negative stride';
  var matrix = new _.Matrix
  ({
    buffer : new F32x([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]),
    dims : [ 2, 2 ],
    offset : 8,
    strides : [ -1, -2 ],
  });
  console.log( matrix.toStr() );
  var exp = _.Matrix.MakeSquare
  ([
    9, 7,
    8, 6,
  ]);
  test.equivalent( matrix, exp );
}

//

function bufferNormalize( test )
{
  let context = this;

  var o = Object.create( null );
  o.test = test;

  o.offset = 0;
  _bufferNormalize( o );

  o.offset = 10;
  _bufferNormalize( o );

  function _bufferNormalize( o )
  {

    /* */

    test.case = 'trivial';

    var buffer = new F64x
    ([
      1, 2, 3,
      4, 5, 6,
    ]);
    var m = context.makeWithOffset
    ({
      buffer,
      dims : [ 2, 3 ],
      offset : o.offset,
      inputRowMajor : 1,
    })

    m.bufferNormalize();

    test.identical( m.offset, 0 );
    test.identical( m.size, 48 );
    test.identical( m.sizeOfElement, 16 );
    test.identical( m.sizeOfCol, 16 );
    test.identical( m.sizeOfRow, 24 );
    test.identical( m.dims, [ 2, 3 ] );
    test.identical( m.length, 3 );

    test.identical( m.stridesEffective, [ 1, 2 ] );
    test.identical( m.strideOfElement, 2 );
    test.identical( m.strideOfCol, 2 );
    test.identical( m.strideInCol, 1 );
    test.identical( m.strideOfRow, 1 );
    test.identical( m.strideInRow, 2 );

    var r1 = m.rowGet( 1 );
    var r2 = m.lineGet( 1, 1 );
    var c1 = m.colGet( 2 );
    var c2 = m.lineGet( 0, 2 );
    var e = m.eGet( 2 );
    var a1 = m.scalarFlatGet( 5 );
    var a2 = m.scalarGet([ 1, 1 ]);

    test.identical( r1, _.vad.from( new F64x([ 4, 5, 6 ]) ) );
    test.identical( r1, r2 );
    test.identical( c1, _.vad.from( new F64x([ 3, 6 ]) ) );
    test.identical( c1, c2 );
    test.identical( e, _.vad.from( new F64x([ 3, 6 ]) ) );
    test.identical( a1, 6 );
    test.identical( a2, 5 );
    test.identical( m.reduceToSumScalarWise(), 21 );
    test.identical( m.reduceToProductScalarWise(), 720 );

    /* */

    test.case = 'not transposed';

    var buffer = new F64x
    ([
      1, 4,
      2, 5,
      3, 6,
    ]);
    var m = context.makeWithOffset
    ({
      buffer,
      dims : [ 2, 3 ],
      offset : o.offset,
      inputRowMajor : 0,
    })

    m.bufferNormalize();

    test.identical( m.offset, 0 );
    test.identical( m.size, 48 );
    test.identical( m.sizeOfElement, 16 );
    test.identical( m.sizeOfCol, 16 );
    test.identical( m.sizeOfRow, 24 );
    test.identical( m.dims, [ 2, 3 ] );
    test.identical( m.length, 3 );

    test.identical( m.stridesEffective, [ 1, 2 ] );
    test.identical( m.strideOfElement, 2 );
    test.identical( m.strideOfCol, 2 );
    test.identical( m.strideInCol, 1 );
    test.identical( m.strideOfRow, 1 );
    test.identical( m.strideInRow, 2 );

    var r1 = m.rowGet( 1 );
    var r2 = m.lineGet( 1, 1 );
    var c1 = m.colGet( 2 );
    var c2 = m.lineGet( 0, 2 );
    var e = m.eGet( 2 );
    var a1 = m.scalarFlatGet( 5 );
    var a2 = m.scalarGet([ 1, 1 ]);

    test.identical( r1, _.vad.from( new F64x([ 4, 5, 6 ]) ) );
    test.identical( r1, r2 );
    test.identical( c1, _.vad.from( new F64x([ 3, 6 ]) ) );
    test.identical( c1, c2 );
    test.identical( e, _.vad.from( new F64x([ 3, 6 ]) ) );
    test.identical( a1, 6 );
    test.identical( a2, 5 );
    test.identical( m.reduceToSumScalarWise(), 21 );
    test.identical( m.reduceToProductScalarWise(), 720 );

  }

}

//

function expand( test )
{

  /* */

  test.case = 'left grow';

  var exp = _.Matrix.Make([ 3, 5 ]).copy
  ([
    0, 0, 0, 0, 0,
    0, 0, 1, 2, 3,
    0, 0, 3, 4, 5,
  ]);

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    3, 4, 5,
  ]);

  m.expand([ [ 1, null ], [ 2, null ] ]);
  test.identical( m, exp );

  /* */

  test.case = 'right grow';

  var exp = _.Matrix.Make([ 3, 5 ]).copy
  ([
    1, 2, 3, 0, 0,
    3, 4, 5, 0, 0,
    0, 0, 0, 0, 0,
  ]);

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    3, 4, 5,
  ]);

  m.expand([ [ null, 1 ], [ null, 2 ] ]);
  test.identical( m, exp );

  /* */

  test.case = 'left shrink';

  var exp = _.Matrix.Make([ 1, 2 ]).copy
  ([
    4, 5,
  ]);

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    3, 4, 5,
  ]);

  m.expand([ [ -1, null ], [ -1, null ] ]);
  test.identical( m, exp );

  /* */

  test.case = 'right shrink';

  var exp = _.Matrix.Make([ 1, 2 ]).copy
  ([
    1, 2,
  ]);

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    3, 4, 5,
  ]);

  m.expand([ [ null, -1 ], [ null, -1 ] ]);
  test.identical( m, exp );

  /* */

  test.case = 'no expand';

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    3, 4, 5,
  ]);

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    3, 4, 5,
  ]);

  var buffer = m.buffer;

  m.expand([ null, null ]);
  test.identical( m, exp );
  test.is( buffer === m.buffer );

  /* */

  test.case = 'number as argument';

  var exp = _.Matrix.Make([ 5, 1 ]).copy
  ([
    0,
    2,
    4,
    0,
    0,
  ]);

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    3, 4, 5,
  ]);

  var buffer = m.buffer;
  m.expand([ [ 1, 2 ], -1 ]);
  test.identical( m, exp );

  /* */

  test.case = 'add rows to empty matrix';

  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    0, 0, 0,
    0, 0, 0,
    0, 0, 0,
  ]);

  var m = _.Matrix.Make([ 0, 3 ]);
  m.expand([ [ 2, 1 ], [ 0, 0 ] ]);
  test.identical( m, exp );

  var exp = _.Matrix.Make([ 3, 0 ]);
  var m = _.Matrix.Make([ 0, 0 ]);
  m.expand([ [ 2, 1 ], [ 0, 0 ] ]);
  test.identical( m, exp );

  var exp = _.Matrix.Make([ 6, 0 ]);
  var m = _.Matrix.Make([ 3, 0 ]);
  m.expand([ [ 2, 1 ], [ 0, 0 ] ]);
  test.identical( m, exp );

  /* */

  test.case = 'add cols to empty matrix';

  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    0, 0, 0,
    0, 0, 0,
    0, 0, 0,
  ]);

  var m = _.Matrix.Make([ 3, 0 ]);
  m.expand([ [ 0, 0 ], [ 2, 1 ] ]);
  test.identical( m, exp );

  var exp = _.Matrix.Make([ 0, 3 ]);
  var m = _.Matrix.Make([ 0, 0 ]);
  m.expand([ [ 0, 0 ], [ 2, 1 ] ]);
  test.identical( m, exp );

  var exp = _.Matrix.Make([ 0, 6 ]);
  var m = _.Matrix.Make([ 0, 3 ]);
  m.expand([ [ 0, 0 ], [ 2, 1 ] ]);
  test.identical( m, exp );

  /* */

  test.case = 'bad arguments';

  _.Matrix.Make([ 3, 2 ]).expand([ [ 1, 1 ], [ 1, 1 ] ]);
  test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 2 ]).expand() );
  test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 2 ]).expand( [ '1', '1' ] ) );
  test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 2 ]).expand([ 1, 1, 1 ]) );
  test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 2 ]).expand( [ 1, 1 ], [ 1, 1 ] ) );
  test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 2 ]).expand([ [ 1, 1 ] ]) );
  test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 2 ]).expand([ [ 1, 1 ], [ 1, 1 ], [ 1, 1 ] ]) );
  test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 2 ]).expand([ [ 1, 1 ], [ 1, 1, 1 ] ]) );

  test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 2 ]).expand([ [ 1, 1 ], '1' ]) );
  test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 2 ]).expand([ '1', [ 1, 1 ] ]) );
  test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 2 ]).expand([ [ 1, 1 ], [ 1, 1 ], 1 ]) );

  test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 2 ]).expand([ [ -4, 1 ], [ 1, 1 ] ]) );
  test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 2 ]).expand([ [ 1, 1 ], [ 1, -3 ] ]) );
  test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 2 ]).expand([ [ 1, -4 ], [ -4, 1 ] ]) );
  test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 2 ]).expand([ [ 1, 1 ], [ 1, -3 ] ]) );

}

//

function vectorToMatrix( test )
{

  /* */

  /* */

  test.case = 'vector to matrix';
  var v = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = v.to( _.Matrix );
  var exp = _.Matrix.MakeCol([ 1, 2, 3 ]);
  test.identical( got, exp );

  /* */

}

//

function accessors( test ) /* qqq2 : split test routine appropriately and extend each */
{
  var m32, m23;

  function remake()
  {

    var buffer = new F32x
    ([
      -1,
      1, 2,
      3, 4,
      5, 6,
      -1,
    ]);

    m32 = _.Matrix
    ({
      dims : [ 3, 2 ],
      inputRowMajor : 1,
      offset : 1,
      buffer,
    });

    var buffer = new F32x
    ([
      -1,
      1, 2, 3,
      4, 5, 6,
      -1,
    ]);

    m23 = _.Matrix
    ({
      dims : [ 2, 3 ],
      inputRowMajor : 1,
      offset : 1,
      buffer,
    });

  }

  /* */

  test.case = 'colGet';

  remake();

  test.identical( m32.colGet( 0 ), fvec([ 1, 3, 5 ]) );
  test.identical( m32.colGet( 1 ), fvec([ 2, 4, 6 ]) );
  test.identical( m23.colGet( 0 ), fvec([ 1, 4 ]) );
  test.identical( m23.colGet( 2 ), fvec([ 3, 6 ]) );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m23.colGet() );
    test.shouldThrowErrorSync( () => m32.colGet( -1 ) );
    test.shouldThrowErrorSync( () => m32.colGet( 2 ) );
    test.shouldThrowErrorSync( () => m23.colGet( -1 ) );
    test.shouldThrowErrorSync( () => m23.colGet( 3 ) );
    test.shouldThrowErrorSync( () => m23.colGet( 0, 0 ) );
    test.shouldThrowErrorSync( () => m23.colGet( [ 0 ] ) );
  }

  /* */

  test.case = 'lineGet col';

  remake();

  test.identical( m32.lineGet( 0, 0 ), fvec([ 1, 3, 5 ]) );
  test.identical( m32.lineGet( 0, 1 ), fvec([ 2, 4, 6 ]) );
  test.identical( m23.lineGet( 0, 0 ), fvec([ 1, 4 ]) );
  test.identical( m23.lineGet( 0, 2 ), fvec([ 3, 6 ]) );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m23.lineGet( 0 ) );
    test.shouldThrowErrorSync( () => m32.lineGet( 0, -1 ) );
    test.shouldThrowErrorSync( () => m32.lineGet( 0, 2 ) );
    test.shouldThrowErrorSync( () => m23.lineGet( 0, -1 ) );
    test.shouldThrowErrorSync( () => m23.lineGet( 0, 3 ) );
    test.shouldThrowErrorSync( () => m23.lineGet( 0, 0, 0 ) );
    test.shouldThrowErrorSync( () => m23.lineGet( 0, [ 0 ] ) );
    test.shouldThrowErrorSync( () => m23.lineGet( [ 0 ] ) );
  }

  /* */

  test.case = 'colSet';

  remake();

  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
    10, 40,
    20, 50,
    30, 60,
  ]);

  m32.colSet( 0, [ 10, 20, 30 ] );
  m32.colSet( 1, [ 40, 50, 60 ] );
  test.identical( m32, exp );

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    10, 0, 30,
    40, 0, 60,
  ]);

  m23.colSet( 0, [ 10, 40 ] );
  m23.colSet( 1, 0 );
  m23.colSet( 2, [ 30, 60 ] );
  test.identical( m23, exp );

  // m32.colSet( 0, [ 10, 20 ] ) // qqq2 : add test cases like this

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m32.colSet() );
    test.shouldThrowErrorSync( () => m32.colSet( 0 ) );
    test.shouldThrowErrorSync( () => m32.colSet( 0, 0, 0 ) );
    // test.shouldThrowErrorSync( () => m32.colSet( 0, [ 10, 20 ] ) );
    test.shouldThrowErrorSync( () => m32.colSet( 0, [ 10, 20, 30 ], 0 ) );
    test.shouldThrowErrorSync( () => m32.colSet( [ 0 ], [ 10, 20, 30 ] ) );
  }

  /* */

  test.case = 'colSet vector';

  remake();

  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
    10, 40,
    20, 50,
    30, 60,
  ]);

  m32.colSet( 0, ivec([ 10, 20, 30 ]) );
  m32.colSet( 1, ivec([ 40, 50, 60 ]) );
  test.identical( m32, exp );

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    10, 0, 30,
    40, 0, 60,
  ]);

  m23.colSet( 0, ivec([ 10, 40 ]) );
  m23.colSet( 1, 0 );
  m23.colSet( 2, ivec([ 30, 60 ]) );
  test.identical( m23, exp );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m32.colSet() );
    test.shouldThrowErrorSync( () => m32.colSet( 0 ) );
    test.shouldThrowErrorSync( () => m32.colSet( 0, 0, 0 ) );
    // test.shouldThrowErrorSync( () => m32.colSet( 0, ivec([ 10, 20 ]) ) ); // qqq2 : add positive test cases like this
    test.shouldThrowErrorSync( () => m32.colSet( 0, ivec([ 10, 20, 30 ]), 0 ) );
    test.shouldThrowErrorSync( () => m32.colSet( [ 0 ], ivec([ 10, 20, 30 ]) ) );
  }

  /* */

  test.case = 'lineSet col';

  remake();

  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
    10, 40,
    20, 50,
    30, 60,
  ]);

  m32.lineSet( 0, 0, [ 10, 20, 30 ] );
  m32.lineSet( 0, 1, [ 40, 50, 60 ] );
  test.identical( m32, exp );

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    10, 0, 30,
    40, 0, 60,
  ]);

  m23.lineSet( 0, 0, [ 10, 40 ] );
  m23.lineSet( 0, 1, 0 );
  m23.lineSet( 0, 2, [ 30, 60 ] );
  test.identical( m23, exp );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m32.lineSet() );
    test.shouldThrowErrorSync( () => m32.lineSet( 0 ) );
    test.shouldThrowErrorSync( () => m32.lineSet( 0, 0 ) );
    test.shouldThrowErrorSync( () => m32.lineSet( 0, 0, 0, 0 ) );
    // test.shouldThrowErrorSync( () => m32.lineSet( 0, 0, [ 10, 20 ] ) ); // qqq2 : add positive test cases like this
    test.shouldThrowErrorSync( () => m32.lineSet( 0, 0, [ 10, 20, 30 ], 0 ) );
    test.shouldThrowErrorSync( () => m32.lineSet( 0, [ 0 ], [ 10, 20, 30 ] ) );
  }

  /* */

  test.case = 'rowGet';

  remake();

  test.identical( m23.rowGet( 0 ), fvec([ 1, 2, 3 ]) );
  test.identical( m23.rowGet( 1 ), fvec([ 4, 5, 6 ]) );
  test.identical( m32.rowGet( 0 ), fvec([ 1, 2 ]) );
  test.identical( m32.rowGet( 2 ), fvec([ 5, 6 ]) );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m23.rowGet() );
    test.shouldThrowErrorSync( () => m23.rowGet( -1 ) );
    test.shouldThrowErrorSync( () => m23.rowGet( 2 ) );

    test.shouldThrowErrorSync( () => m32.rowGet( -1 ) );
    test.shouldThrowErrorSync( () => m32.rowGet( 3 ) );
    test.shouldThrowErrorSync( () => m32.rowGet( 0, 0 ) );
    test.shouldThrowErrorSync( () => m32.rowGet( [ 0 ] ) );
  }

  /* */

  test.case = 'lineGet row';

  remake();

  test.identical( m23.lineGet( 1, 0 ), fvec([ 1, 2, 3 ]) );
  test.identical( m23.lineGet( 1, 1 ), fvec([ 4, 5, 6 ]) );
  test.identical( m32.lineGet( 1, 0 ), fvec([ 1, 2 ]) );
  test.identical( m32.lineGet( 1, 2 ), fvec([ 5, 6 ]) );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m23.lineGet() );
    test.shouldThrowErrorSync( () => m23.lineGet( 1 ) );
    test.shouldThrowErrorSync( () => m23.lineGet( 1, -1 ) );
    test.shouldThrowErrorSync( () => m23.lineGet( 1, 2 ) );
    test.shouldThrowErrorSync( () => m32.lineGet( 1, -1 ) );
    test.shouldThrowErrorSync( () => m32.lineGet( 1, 3 ) );
    test.shouldThrowErrorSync( () => m32.lineGet( 1, 0, 0 ) );
    test.shouldThrowErrorSync( () => m32.lineGet( 1, [ 0 ] ) );
  }

  /* */

  test.case = 'rowSet';

  remake();

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    10, 20, 30,
    40, 50, 60,
  ]);

  m23.rowSet( 0, [ 10, 20, 30 ] );
  m23.rowSet( 1, [ 40, 50, 60 ] );
  test.identical( m23, exp );

  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
    10, 20,
    0, 0,
    50, 60,
  ]);

  m32.rowSet( 0, [ 10, 20 ] );
  m32.rowSet( 1, 0 );
  m32.rowSet( 2, [ 50, 60 ] );
  test.identical( m32, exp );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m23.rowSet() );
    test.shouldThrowErrorSync( () => m23.rowSet( 0 ) );
    test.shouldThrowErrorSync( () => m23.rowSet( 0, 0, 0 ) );
    // test.shouldThrowErrorSync( () => m23.rowSet( 0, [ 10, 20 ] ) );  // qqq2 : add positive test cases like this
    test.shouldThrowErrorSync( () => m23.rowSet( 0, [ 10, 20, 30 ], 0 ) );
    test.shouldThrowErrorSync( () => m23.rowSet( [ 0 ], [ 10, 20, 30 ] ) );
  }

  /* */

  test.case = 'rowSet vector';

  remake();

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    10, 20, 30,
    40, 50, 60,
  ]);

  m23.rowSet( 0, ivec([ 10, 20, 30 ]) );
  m23.rowSet( 1, ivec([ 40, 50, 60 ]) );
  test.identical( m23, exp );

  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
    10, 20,
    0, 0,
    50, 60,
  ]);

  m32.rowSet( 0, ivec([ 10, 20 ]) );
  m32.rowSet( 1, 0 );
  m32.rowSet( 2, ivec([ 50, 60 ]) );
  test.identical( m32, exp );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m23.rowSet() );
    test.shouldThrowErrorSync( () => m23.rowSet( 0 ) );
    test.shouldThrowErrorSync( () => m23.rowSet( 0, 0, 0 ) );
    // test.shouldThrowErrorSync( () => m23.rowSet( 0, ivec([ 10, 20 ]) ) );  // qqq2 : add positive test cases like this
    test.shouldThrowErrorSync( () => m23.rowSet( 0, ivec([ 10, 20, 30 ]), 0 ) );
    test.shouldThrowErrorSync( () => m23.rowSet( [ 0 ], ivec([ 10, 20, 30 ]) ) );
  }

  /* */

  test.case = 'lineSet row';

  remake();

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    10, 20, 30,
    40, 50, 60,
  ]);

  m23.lineSet( 1, 0, [ 10, 20, 30 ] );
  m23.lineSet( 1, 1, [ 40, 50, 60 ] );
  test.identical( m23, exp );

  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
    10, 20,
    0, 0,
    50, 60,
  ]);

  m32.lineSet( 1, 0, [ 10, 20 ] );
  m32.lineSet( 1, 1, 0 );
  m32.lineSet( 1, 2, [ 50, 60 ] );
  test.identical( m32, exp );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m23.lineSet() );
    test.shouldThrowErrorSync( () => m23.lineSet( 1, 0 ) );
    test.shouldThrowErrorSync( () => m23.lineSet( 1, 0 ) );
    test.shouldThrowErrorSync( () => m23.lineSet( 1, 0, 0, 0 ) );
    // test.shouldThrowErrorSync( () => m23.lineSet( 1, 0, [ 10, 20 ] ) );  // qqq2 : add positive test cases like this
    test.shouldThrowErrorSync( () => m23.lineSet( 1, 0, [ 10, 20, 30 ], 0 ) );
    test.shouldThrowErrorSync( () => m23.lineSet( 1, [ 0 ], [ 10, 20, 30 ] ) );
  }
}

//

function lineNdGet( test )
{

  /* */

  test.case = '2x3';
  var matrix = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  test.description = 'd:0 i:1';
  var exp = _.vectorAdapter.from( new F32x([ 2, 5 ]) );
  var line = matrix.lineGet( 0, 1 );
  test.identical( line, exp );
  var line = matrix.lineNdGet( 0, [ 1 ] );
  test.identical( line, exp );

  test.description = 'd:0 i:0';
  var exp = _.vectorAdapter.from( new F32x([ 1, 4 ]) );
  var line = matrix.lineGet( 0, 0 );
  test.identical( line, exp );
  var line = matrix.lineNdGet( 0, [ 0 ] );
  test.identical( line, exp );

  test.description = 'd:0 i:2';
  var exp = _.vectorAdapter.from( new F32x([ 3, 6 ]) );
  var line = matrix.lineGet( 0, 2 );
  test.identical( line, exp );
  var line = matrix.lineNdGet( 0, [ 2 ] );
  test.identical( line, exp );

  test.description = 'd:1 i:0';
  var exp = _.vectorAdapter.from( new F32x([ 1, 2, 3 ]) );
  var line = matrix.lineGet( 1, 0 );
  test.identical( line, exp );
  var line = matrix.lineNdGet( 1, [ 0 ] );
  test.identical( line, exp );

  test.description = 'd:1 i:1';
  var exp = _.vectorAdapter.from( new F32x([ 4, 5, 6 ]) );
  var line = matrix.lineGet( 1, 1 );
  test.identical( line, exp );
  var line = matrix.lineNdGet( 1, [ 1 ] );
  test.identical( line, exp );

  /* */

  test.case = '2x3x4 d:0';
  var matrix = _.Matrix.Make([ 2, 3, 4 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
    10, 11, 12,
    13, 14, 15,
    16, 17, 18,
    19, 20, 21,
    22, 23, 24,
  ]);

  test.description = 'd:0 i:0,0';
  var exp = _.vectorAdapter.from( new F32x([ 1, 4 ]) );
  var line = matrix.lineNdGet( 0, [ 0, 0 ] );
  test.identical( line, exp );

  test.description = 'd:0 i:1,0';
  var exp = _.vectorAdapter.from( new F32x([ 2, 5 ]) );
  var line = matrix.lineNdGet( 0, [ 1, 0 ] );
  test.identical( line, exp );

  test.description = 'd:0 i:2,0';
  var exp = _.vectorAdapter.from( new F32x([ 3, 6 ]) );
  var line = matrix.lineNdGet( 0, [ 2, 0 ] );
  test.identical( line, exp );

  test.description = 'd:0 i:0,1';
  var exp = _.vectorAdapter.from( new F32x([ 7, 10 ]) );
  var line = matrix.lineNdGet( 0, [ 0, 1 ] );
  test.identical( line, exp );

  test.description = 'd:0 i:1,1';
  var exp = _.vectorAdapter.from( new F32x([ 8, 11 ]) );
  var line = matrix.lineNdGet( 0, [ 1, 1 ] );
  test.identical( line, exp );

  test.description = 'd:0 i:2,1';
  var exp = _.vectorAdapter.from( new F32x([ 9, 12 ]) );
  var line = matrix.lineNdGet( 0, [ 2, 1 ] );
  test.identical( line, exp );

  test.description = 'd:0 i:0,3';
  var exp = _.vectorAdapter.from( new F32x([ 19, 22 ]) );
  var line = matrix.lineNdGet( 0, [ 0, 3 ] );
  test.identical( line, exp );

  test.description = 'd:0 i:1,3';
  var exp = _.vectorAdapter.from( new F32x([ 20, 23 ]) );
  var line = matrix.lineNdGet( 0, [ 1, 3 ] );
  test.identical( line, exp );

  test.description = 'd:0 i:2,3';
  var exp = _.vectorAdapter.from( new F32x([ 21, 24 ]) );
  var line = matrix.lineNdGet( 0, [ 2, 3 ] );
  test.identical( line, exp );

  /* */

  test.case = '2x3x4 d:1';
  var matrix = _.Matrix.Make([ 2, 3, 4 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
    10, 11, 12,
    13, 14, 15,
    16, 17, 18,
    19, 20, 21,
    22, 23, 24,
  ]);

  test.description = 'd:1 i:0,0';
  var exp = _.vectorAdapter.from( new F32x([ 1, 2, 3 ]) );
  var line = matrix.lineNdGet( 1, [ 0, 0 ] );
  test.identical( line, exp );

  test.description = 'd:1 i:1,0';
  var exp = _.vectorAdapter.from( new F32x([ 4, 5, 6 ]) );
  var line = matrix.lineNdGet( 1, [ 1, 0 ] );
  test.identical( line, exp );

  test.description = 'd:1 i:0,1';
  var exp = _.vectorAdapter.from( new F32x([ 7, 8, 9 ]) );
  var line = matrix.lineNdGet( 1, [ 0, 1 ] );
  test.identical( line, exp );

  test.description = 'd:1 i:1,1';
  var exp = _.vectorAdapter.from( new F32x([ 10, 11, 12 ]) );
  var line = matrix.lineNdGet( 1, [ 1, 1 ] );
  test.identical( line, exp );

  test.description = 'd:1 i:0,3';
  var exp = _.vectorAdapter.from( new F32x([ 19, 20, 21 ]) );
  var line = matrix.lineNdGet( 1, [ 0, 3 ] );
  test.identical( line, exp );

  test.description = 'd:1 i:1,3';
  var exp = _.vectorAdapter.from( new F32x([ 22, 23, 24 ]) );
  var line = matrix.lineNdGet( 1, [ 1, 3 ] );
  test.identical( line, exp );

  /* */

  test.case = '2x3x4 d:2';
  var matrix = _.Matrix.Make([ 2, 3, 4 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
    10, 11, 12,
    13, 14, 15,
    16, 17, 18,
    19, 20, 21,
    22, 23, 24,
  ]);

  test.description = 'd:2 i:0,0';
  var exp = _.vectorAdapter.from( new F32x([ 1, 7, 13, 19 ]) );
  var line = matrix.lineNdGet( 2, [ 0, 0 ] );
  test.identical( line, exp );

  test.description = 'd:2 i:1,1';
  var exp = _.vectorAdapter.from( new F32x([ 5, 11, 17, 23 ]) );
  var line = matrix.lineNdGet( 2, [ 1, 1 ] );
  test.identical( line, exp );

  test.description = 'd:2 i:1,2';
  var exp = _.vectorAdapter.from( new F32x([ 6, 12, 18, 24 ]) );
  var line = matrix.lineNdGet( 2, [ 1, 2 ] );
  test.identical( line, exp );

  /* */

}

//

function lineNdGetIterate( test )
{

  /* */

  test.case = '2x3. iterate dimension 0';

  var dims = [ 2, 3 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  for( let v = 0; v < dims[ 1 ]; v += 1 )
  {
    let line = matrix.lineNdGet( 0, [ v ] );
    got.push( ... line, '.' );
  }
  var exp = [ 1, 2, '.', 3, 4, '.', 5, 6, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '2x3. iterate dimension 1';

  var dims = [ 2, 3 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  for( let v = 0; v < dims[ 0 ]; v += 1 )
  {
    let line = matrix.lineNdGet( 1, [ v ] );
    got.push( ... line, '.' );
  }
  var exp = [ 1, 3, 5, '.', 2, 4, 6, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '2x3x4. iterate dimension 0';

  var dims = [ 2, 3, 4 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  for( let x = 0 ; x < dims[ 2 ] ; x += 1 )
  {
    for( let v = 0; v < dims[ 1 ]; v += 1 )
    {
      let line = matrix.lineNdGet( 0, [ v, x ] );
      got.push( ... line, '.' );
    }
  }
  var exp = [ 1, 2, '.', 3, 4, '.', 5, 6, '.', 7, 8, '.', 9, 10, '.', 11, 12, '.', 13, 14, '.', 15, 16, '.', 17, 18, '.', 19, 20, '.', 21, 22, '.', 23, 24, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '2x3x4. iterate dimension 1';

  var dims = [ 2, 3, 4 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  for( let x = 0 ; x < dims[ 2 ] ; x += 1 )
  {
    for( let v = 0; v < dims[ 0 ]; v += 1 )
    {
      let line = matrix.lineNdGet( 1, [ v, x ] );
      got.push( ... line, '.' );
    }
  }
  var exp = [ 1, 3, 5, '.', 2, 4, 6, '.', 7, 9, 11, '.', 8, 10, 12, '.', 13, 15, 17, '.', 14, 16, 18, '.', 19, 21, 23, '.', 20, 22, 24, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '2x3x4. iterate dimension 2';

  var dims = [ 2, 3, 4 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  for( let x = 0 ; x < dims[ 1 ] ; x += 1 )
  {
    for( let v = 0; v < dims[ 0 ]; v += 1 )
    {
      let line = matrix.lineNdGet( 2, [ v, x ] );
      got.push( ... line, '.' );
    }
  }
  var exp = [ 1, 7, 13, 19, '.', 2, 8, 14, 20, '.', 3, 9, 15, 21, '.', 4, 10, 16, 22, '.', 5, 11, 17, 23, '.', 6, 12, 18, 24, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '1x2x3x4. iterate dimension 0';

  var dims = [ 1, 2, 3, 4 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  for( let y = 0 ; y < dims[ 3 ] ; y += 1 )
  for( let x = 0 ; x < dims[ 2 ] ; x += 1 )
  {
    for( let v = 0; v < dims[ 1 ]; v += 1 )
    {
      let line = matrix.lineNdGet( 0, [ v, x, y ] );
      got.push( ... line, '.' );
    }
  }
  var exp = [ 1, '.', 2, '.', 3, '.', 4, '.', 5, '.', 6, '.', 7, '.', 8, '.', 9, '.', 10, '.', 11, '.', 12, '.', 13, '.', 14, '.', 15, '.', 16, '.', 17, '.', 18, '.', 19, '.', 20, '.', 21, '.', 22, '.', 23, '.', 24, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '1x2x3x4. iterate dimension 1';

  var dims = [ 1, 2, 3, 4 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  for( let y = 0 ; y < dims[ 3 ] ; y += 1 )
  for( let x = 0 ; x < dims[ 2 ] ; x += 1 )
  {
    for( let v = 0 ; v < dims[ 0 ]; v += 1 )
    {
      let line = matrix.lineNdGet( 1, [ v, x, y ] );
      got.push( ... line, '.' );
    }
  }
  var exp = [ 1, 2, '.', 3, 4, '.', 5, 6, '.', 7, 8, '.', 9, 10, '.', 11, 12, '.', 13, 14, '.', 15, 16, '.', 17, 18, '.', 19, 20, '.', 21, 22, '.', 23, 24, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '1x2x3x4. iterate dimension 2';

  var dims = [ 1, 2, 3, 4 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  for( let y = 0 ; y < dims[ 3 ] ; y += 1 )
  for( let x = 0 ; x < dims[ 1 ] ; x += 1 )
  {
    for( let v = 0 ; v < dims[ 0 ] ; v += 1 )
    {
      let line = matrix.lineNdGet( 2, [ v, x, y ] );
      got.push( ... line, '.' );
    }
  }
  var exp = [ 1, 3, 5, '.', 2, 4, 6, '.', 7, 9, 11, '.', 8, 10, 12, '.', 13, 15, 17, '.', 14, 16, 18, '.', 19, 21, 23, '.', 20, 22, 24, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '1x2x3x4. iterate dimension 3';

  var dims = [ 1, 2, 3, 4 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  for( let y = 0 ; y < dims[ 2 ] ; y += 1 )
  for( let x = 0 ; x < dims[ 1 ] ; x += 1 )
  {
    for( let v = 0 ; v < dims[ 0 ] ; v += 1 )
    {
      let line = matrix.lineNdGet( 3, [ v, x, y ] );
      got.push( ... line, '.' );
    }
  }
  var exp = [ 1, 7, 13, 19, '.', 2, 8, 14, 20, '.', 3, 9, 15, 21, '.', 4, 10, 16, 22, '.', 5, 11, 17, 23, '.', 6, 12, 18, 24, '.' ];
  test.identical( got, exp );

  /* */

  console.log( matrix );
  console.log( _.vad.from([ 1, 2, 3 ]) );

}

//

function scalarWhile( test )
{
  test.open( 'standard strides' );

  test.case = '2d matrix without Infinity';
  var buffer = new I32x( 6 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp = [ 1, 2, 3, 4, 5, 6 ];
  test.identical( got, exp );

  test.case = '2d matrix, dims[ 0 ] - Infinity';
  var buffer = new I32x( 6 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ Infinity, 3 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp = [ 1, 2, 3 ];
  test.identical( got, exp );

  /* */

  test.case = '3d matrix without Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp =
  [
    1, 2, 3, 4, 5, 6,
    7, 8, 9, 10, 11, 12,
    13, 14, 15, 16, 17, 18,
    19, 20, 21, 22, 23, 24
  ];
  test.identical( got, exp );

  test.case = '3d matrix, dims[ 0 ] - Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ Infinity, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp =
  [
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
    10, 11, 12
  ];
  test.identical( got, exp );

  /* */

  test.case = '4d matrix without Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, 2, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp =
  [
    1, 2, 3, 4, 5, 6,
    7, 8, 9, 10, 11, 12,
    13, 14, 15, 16, 17, 18,
    19, 20, 21, 22, 23, 24
  ];
  test.identical( got, exp );

  test.case = '4d matrix, dims[ 1 ] - Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, Infinity, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp =
  [
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
    10, 11, 12,
  ];
  test.identical( got, exp );

  test.close( 'standard strides' );

  /* - */

  test.open( 'non-standard strides' );

  test.case = '2d matrix without Infinity';
  var buffer = new I32x( 12 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3 ],
    offset : 1,
    strides : [ 2, 3 ]
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp = [ 2, 4, 5, 7, 8, 10 ];
  test.identical( got, exp );

  test.case = '2d matrix, dims[ 0 ] - Infinity';
  var buffer = new I32x( 12 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ Infinity, 3 ],
    offset : 1,
    strides : [ 2, 3 ]
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp = [ 2, 5, 8 ];
  test.identical( got, exp );

  /* */

  test.case = '3d matrix without Infinity';
  var buffer = new I32x( 48 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3, 4 ],
    offset : 1,
    strides : [ 2, 3, 9 ],
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp =
  [
    2, 4, 5, 7, 8, 10,
    11, 13, 14, 16, 17, 19,
    20, 22, 23, 25, 26, 28,
    29, 31, 32, 34, 35, 37,
  ];
  test.identical( got, exp );

  test.case = '3d matrix, dims[ 0 ] - Infinity';
  var buffer = new I32x( 48 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ Infinity, 3, 4 ],
    offset : 1,
    strides : [ 2, 3, 9 ]
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp =
  [
    2, 5, 8,
    11, 14, 17,
    20, 23, 26,
    29, 32, 35
  ];
  test.identical( got, exp );

  /* */

  test.case = '4d matrix without Infinity';
  var buffer = new I32x( 48 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, 2, 3, 4 ],
    offset : 1,
    strides : [ 2, 3, 8, 9 ]
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp =
  [
    2, 5, 10, 13, 18, 21,
    11, 14, 19, 22, 27, 30,
    20, 23, 28, 31, 36, 39,
    29, 32, 37, 40, 45, 48
  ];
  test.identical( got, exp );

  test.case = '4d matrix, dims[ 1 ] - Infinity';
  var buffer = new I32x( 48 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, Infinity, 3, 4 ],
    offset : 1,
    strides : [ 2, 3, 8, 9 ],
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp =
  [
    2, 10, 18,
    11, 19, 27,
    20, 28, 36,
    29, 37, 45,
  ];
  test.identical( got, exp );

  test.close( 'non-standard strides' );

  /* - */

  test.open( 'onScalar returns false' );

  test.case = '2d matrix without Infinity';
  var buffer = new I32x( 12 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3 ],
    offset : 1,
    strides : [ 2, 3 ]
  });
  var got = [];
  m.scalarWhile( ( it ) => got.length < 2 ? got.push( m.buffer[ it.offset[ 0 ] ] ) : false );
  var exp = [ 2, 4 ];
  test.identical( got, exp );

  /* */

  test.case = '3d matrix without Infinity';
  var buffer = new I32x( 48 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3, 4 ],
    offset : 1,
    strides : [ 2, 3, 9 ],
  });
  var got = [];
  m.scalarWhile( ( it ) => got.length < 2 ? got.push( m.buffer[ it.offset[ 0 ] ] ) : false );
  var exp = [ 2, 4 ];
  test.identical( got, exp );

  /* */

  test.case = '4d matrix without Infinity';
  var buffer = new I32x( 48 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, 2, 3, 4 ],
    offset : 1,
    strides : [ 2, 3, 8, 9 ]
  });
  var got = [];
  m.scalarWhile( ( it ) => got.length < 2 ? got.push( m.buffer[ it.offset[ 0 ] ] ) : false );
  var exp = [ 2, 5 ];
  test.identical( got, exp );

  test.close( 'onScalar returns false' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () =>
  {
    var m = _.Matrix.Make([ 2, 3, 4 ]);
    var got = m.scalarWhile();
  });

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () =>
  {
    var m = _.Matrix.Make([ 2, 3, 4 ]);
    var got = m.scalarWhile( ( it ) => it.args.push( it.indexLogical ), ( it ) => it );
  });

  test.case = 'unknown option in options map';
  test.shouldThrowErrorSync( () =>
  {
    var m = _.Matrix.Make([ 2, 3, 4 ]);
    var got = m.scalarWhile({ onMatrix : ( it ) => it.args.push( it.indexLogical ), args : [], unknown : [] });
  });

  test.case = 'wrong type of o.args';
  test.shouldThrowErrorSync( () =>
  {
    var m = _.Matrix.Make([ 2, 3, 4 ]);
    var got = m.scalarWhile({ onMatrix : ( it ) => it.args.push( it.indexLogical ), args : null });
  });

  test.case = 'wrong type of o.onScalar';
  test.shouldThrowErrorSync( () =>
  {
    var m = _.Matrix.Make([ 2, 3, 4 ]);
    var got = m.scalarWhile({ onMatrix : [], args : [] });
  });

  test.case = 'wrong length of o.onScalar';
  test.shouldThrowErrorSync( () =>
  {
    var m = _.Matrix.Make([ 2, 3, 4 ]);
    var got = m.scalarWhile({ onMatrix : ( it ) => it.args.push( it.indexLogical ), args : null });
  });
}

//

function scalarWhileCheckingFields( test )
{

  test.open( 'check fields' );

  test.case = '2d matrix without Infinity';
  var buffer = new I32x( 6 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 1, 2 ],
    strides : [ 1, 2 ],
    offset : [ 6, 6 ],
    indexLogical : 5
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 6 );
  test.is( got[ 0 ] === got[ 1 ] );

  test.case = '2d matrix, dims[ 0 ] - Infinity';
  var buffer = new I32x( 6 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ Infinity, 3 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 0, 2 ],
    strides : [ 0, 1 ],
    offset : [ 3, 3 ],
    indexLogical : 2
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 3 );
  test.is( got[ 0 ] === got[ 1 ] );

  test.case = '2d matrix, dims[ 1 ] - Infinity';
  var buffer = new I32x( 6 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, Infinity ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 1, 0 ],
    strides : [ 1, 0 ],
    offset : [ 0, 0 ],
    indexLogical : 1
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 2 );
  test.is( got[ 0 ] === got[ 1 ] );

  /* */

  test.case = '3d matrix without Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 1, 2, 3 ],
    strides : [ 1, 2, 6 ],
    offset : [ 24, 24, 24 ],
    indexLogical : 23
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 24 );
  test.is( got[ 0 ] == got[ 1 ] );

  test.case = '3d matrix, dims[ 0 ] - Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ Infinity, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 0, 2, 3 ],
    strides : [ 0, 1, 3 ],
    offset : [ 12, 12, 12 ],
    indexLogical : 11
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 12 );
  test.is( got[ 0 ] == got[ 1 ] );

  test.case = '3d matrix, dims[ 1 ] - Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, Infinity, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 1, 0, 3 ],
    strides : [ 1, 0, 2 ],
    offset : [ 8, 8, 8 ],
    indexLogical : 7
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 8 );
  test.is( got[ 0 ] == got[ 1 ] );

  test.case = '3d matrix, dims[ 2 ] - Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3, Infinity ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 1, 2 ],
    strides : [ 1, 2 ],
    offset : [ 6, 6 ],
    indexLogical : 5
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 6 );
  test.is( got[ 0 ] == got[ 1 ] );

  /* */

  test.case = '4d matrix without Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, 2, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 0, 1, 2, 3 ],
    strides : [ 1, 1, 2, 6 ],
    offset : [ 23, 23, 22, 18 ],
    indexLogical : 23
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 24 );
  test.is( got[ 0 ] === got[ 1 ] );

  test.case = '4d matrix, dims[ 0 ] - Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ Infinity, 2, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 0, 1, 2, 3 ],
    strides : [ 0, 1, 2, 6 ],
    offset : [ 23, 23, 22, 18 ],
    indexLogical : 23
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 24 );
  test.is( got[ 0 ] === got[ 1 ] );

  test.case = '4d matrix, dims[ 1 ] - Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, Infinity, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 0, 0, 2, 3 ],
    strides : [ 1, 0, 1, 3 ],
    offset : [ 11, 11, 11, 9 ],
    indexLogical : 11
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 12 );
  test.is( got[ 0 ] === got[ 1 ] );

  test.case = '4d matrix, dims[ 2 ] - Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, 2, Infinity, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 0, 1, 0, 3 ],
    strides : [ 1, 1, 2, 2 ],
    offset : [ 7, 7, 6, 6 ],
    indexLogical : 7
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 8 );
  test.is( got[ 0 ] === got[ 1 ] );

  test.case = '4d matrix, dims[ 3 ] - Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, 2, 3, Infinity ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 0, 1, 2 ],
    strides : [ 1, 1, 2 ],
    offset : [ 6, 6, 6 ],
    indexLogical : 5
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 6 );
  test.is( got[ 0 ] === got[ 1 ] );

  test.close( 'check fields' );

  /* - */

  test.open( 'check order' );

  test.case = '2d matrix without Infinity';
  var buffer = new I32x( 6 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( it.indexNd.slice(), it.offset.slice() ) );
  var exp =
  [
    [ 0, 0 ], [ 0, 0 ],
    [ 1, 0 ], [ 1, 0 ],
    [ 0, 1 ], [ 2, 2 ],
    [ 1, 1 ], [ 3, 2 ],
    [ 0, 2 ], [ 4, 4 ],
    [ 1, 2 ], [ 5, 4 ]
  ];
  test.identical( got, exp );

  /* */

  test.case = '3d matrix without Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( it.indexNd.slice(), it.offset.slice() ) );
  var exp =
  [
    [ 0, 0, 0 ], [ 0, 0, 0 ],
    [ 1, 0, 0 ], [ 1, 0, 0 ],
    [ 0, 1, 0 ], [ 2, 2, 0 ],
    [ 1, 1, 0 ], [ 3, 2, 0 ],
    [ 0, 2, 0 ], [ 4, 4, 0 ],
    [ 1, 2, 0 ], [ 5, 4, 0 ],
    [ 0, 0, 1 ], [ 6, 6, 6 ],
  ];
  test.identical( got.slice( 0, 14 ), exp );
  test.identical( got.slice( 46, 48 ), [ [ 1, 2, 3 ], [ 23, 22, 18 ] ] );

  /* */

  test.case = '4d matrix without Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, 2, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarWhile( ( it ) => got.push( it.indexNd.slice(), it.offset.slice() ) );
  var exp =
  [
    [ 0, 0, 0, 0 ], [ 0, 0, 0, 0 ],
    [ 0, 1, 0, 0 ], [ 1, 1, 0, 0 ],
    [ 0, 0, 1, 0 ], [ 2, 2, 2, 0 ],
    [ 0, 1, 1, 0 ], [ 3, 3, 2, 0 ],
    [ 0, 0, 2, 0 ], [ 4, 4, 4, 0 ],
    [ 0, 1, 2, 0 ], [ 5, 5, 4, 0 ],
    [ 0, 0, 0, 1 ], [ 6, 6, 6, 6 ],
  ];
  test.identical( got.slice( 0, 14 ), exp );
  test.identical( got.slice( 46, 48 ), [ [ 0, 1, 2, 3 ], [ 23, 23, 22, 18 ] ] );

  test.close( 'check order' );
}

//

function scalarEach( test )
{
  test.open( 'standard strides' );

  test.case = '2d matrix without Infinity';
  var buffer = new I32x( 6 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp = [ 1, 2, 3, 4, 5, 6 ];
  test.identical( got, exp );

  test.case = '2d matrix, dims[ 0 ] - Infinity';
  var buffer = new I32x( 6 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ Infinity, 3 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp = [ 1, 2, 3 ];
  test.identical( got, exp );

  /* */

  test.case = '3d matrix without Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp =
  [
    1, 2, 3, 4, 5, 6,
    7, 8, 9, 10, 11, 12,
    13, 14, 15, 16, 17, 18,
    19, 20, 21, 22, 23, 24
  ];
  test.identical( got, exp );

  test.case = '3d matrix, dims[ 0 ] - Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ Infinity, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp =
  [
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
    10, 11, 12
  ];
  test.identical( got, exp );

  /* */

  test.case = '4d matrix without Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, 2, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp =
  [
    1, 2, 3, 4, 5, 6,
    7, 8, 9, 10, 11, 12,
    13, 14, 15, 16, 17, 18,
    19, 20, 21, 22, 23, 24
  ];
  test.identical( got, exp );

  test.case = '4d matrix, dims[ 1 ] - Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, Infinity, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp =
  [
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
    10, 11, 12,
  ];
  test.identical( got, exp );

  test.close( 'standard strides' );

  /* - */

  test.open( 'non-standard strides' );

  test.case = '2d matrix without Infinity';
  var buffer = new I32x( 12 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3 ],
    offset : 1,
    strides : [ 2, 3 ]
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp = [ 2, 4, 5, 7, 8, 10 ];
  test.identical( got, exp );

  test.case = '2d matrix, dims[ 0 ] - Infinity';
  var buffer = new I32x( 12 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ Infinity, 3 ],
    offset : 1,
    strides : [ 2, 3 ]
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp = [ 2, 5, 8 ];
  test.identical( got, exp );

  /* */

  test.case = '3d matrix without Infinity';
  var buffer = new I32x( 48 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3, 4 ],
    offset : 1,
    strides : [ 2, 3, 9 ],
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp =
  [
    2, 4, 5, 7, 8, 10,
    11, 13, 14, 16, 17, 19,
    20, 22, 23, 25, 26, 28,
    29, 31, 32, 34, 35, 37,
  ];
  test.identical( got, exp );

  test.case = '3d matrix, dims[ 0 ] - Infinity';
  var buffer = new I32x( 48 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ Infinity, 3, 4 ],
    offset : 1,
    strides : [ 2, 3, 9 ]
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp =
  [
    2, 5, 8,
    11, 14, 17,
    20, 23, 26,
    29, 32, 35
  ];
  test.identical( got, exp );

  /* */

  test.case = '4d matrix without Infinity';
  var buffer = new I32x( 48 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, 2, 3, 4 ],
    offset : 1,
    strides : [ 2, 3, 8, 9 ]
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp =
  [
    2, 5, 10, 13, 18, 21,
    11, 14, 19, 22, 27, 30,
    20, 23, 28, 31, 36, 39,
    29, 32, 37, 40, 45, 48
  ];
  test.identical( got, exp );

  test.case = '4d matrix, dims[ 1 ] - Infinity';
  var buffer = new I32x( 48 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, Infinity, 3, 4 ],
    offset : 1,
    strides : [ 2, 3, 8, 9 ],
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( m.buffer[ it.offset[ 0 ] ] ) );
  var exp =
  [
    2, 10, 18,
    11, 19, 27,
    20, 28, 36,
    29, 37, 45,
  ];
  test.identical( got, exp );

  test.close( 'non-standard strides' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () =>
  {
    var m = _.Matrix.Make([ 2, 3, 4 ]);
    var got = m.scalarEach();
  });

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () =>
  {
    var m = _.Matrix.Make([ 2, 3, 4 ]);
    var got = m.scalarEach( ( it ) => it.args.push( it.indexLogical ), ( it ) => it );
  });

  test.case = 'wrong type of o.args';
  test.shouldThrowErrorSync( () =>
  {
    var m = _.Matrix.Make([ 2, 3, 4 ]);
    var got = m.scalarEach({ onMatrix : ( it ) => it.args.push( it.indexLogical ), args : null });
  });

  test.case = 'wrong type of o.onScalar';
  test.shouldThrowErrorSync( () =>
  {
    var m = _.Matrix.Make([ 2, 3, 4 ]);
    var got = m.scalarEach({ onMatrix : [], args : [] });
  });

  test.case = 'wrong length of o.onScalar';
  test.shouldThrowErrorSync( () =>
  {
    var m = _.Matrix.Make([ 2, 3, 4 ]);
    var got = m.scalarEach({ onMatrix : ( it ) => it.args.push( it.indexLogical ), args : null });
  });
}

//

function scalarEachCheckingFields( test )
{
  test.open( 'check fields' );

  test.case = '2d matrix without Infinity';
  var buffer = new I32x( 6 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 1, 2 ],
    strides : [ 1, 2 ],
    offset : [ 6, 6 ],
    indexLogical : 5
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 6 );
  test.is( got[ 0 ] === got[ 1 ] );

  test.case = '2d matrix, dims[ 0 ] - Infinity';
  var buffer = new I32x( 6 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ Infinity, 3 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 0, 2 ],
    strides : [ 0, 1 ],
    offset : [ 3, 3 ],
    indexLogical : 2
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 3 );
  test.is( got[ 0 ] === got[ 1 ] );

  test.case = '2d matrix, dims[ 1 ] - Infinity';
  var buffer = new I32x( 6 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, Infinity ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 1, 0 ],
    strides : [ 1, 0 ],
    offset : [ 0, 0 ],
    indexLogical : 1
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 2 );
  test.is( got[ 0 ] === got[ 1 ] );

  /* */

  test.case = '3d matrix without Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 1, 2, 3 ],
    strides : [ 1, 2, 6 ],
    offset : [ 24, 24, 24 ],
    indexLogical : 23
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 24 );
  test.is( got[ 0 ] == got[ 1 ] );

  test.case = '3d matrix, dims[ 0 ] - Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ Infinity, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 0, 2, 3 ],
    strides : [ 0, 1, 3 ],
    offset : [ 12, 12, 12 ],
    indexLogical : 11
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 12 );
  test.is( got[ 0 ] == got[ 1 ] );

  test.case = '3d matrix, dims[ 1 ] - Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, Infinity, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 1, 0, 3 ],
    strides : [ 1, 0, 2 ],
    offset : [ 8, 8, 8 ],
    indexLogical : 7
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 8 );
  test.is( got[ 0 ] == got[ 1 ] );

  test.case = '3d matrix, dims[ 2 ] - Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3, Infinity ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 1, 2 ],
    strides : [ 1, 2 ],
    offset : [ 6, 6 ],
    indexLogical : 5
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 6 );
  test.is( got[ 0 ] == got[ 1 ] );

  /* */

  test.case = '4d matrix without Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, 2, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 0, 1, 2, 3 ],
    strides : [ 1, 1, 2, 6 ],
    offset : [ 23, 23, 22, 18 ],
    indexLogical : 23
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 24 );
  test.is( got[ 0 ] === got[ 1 ] );

  test.case = '4d matrix, dims[ 0 ] - Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ Infinity, 2, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 0, 1, 2, 3 ],
    strides : [ 0, 1, 2, 6 ],
    offset : [ 23, 23, 22, 18 ],
    indexLogical : 23
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 24 );
  test.is( got[ 0 ] === got[ 1 ] );

  test.case = '4d matrix, dims[ 1 ] - Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, Infinity, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 0, 0, 2, 3 ],
    strides : [ 1, 0, 1, 3 ],
    offset : [ 11, 11, 11, 9 ],
    indexLogical : 11
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 12 );
  test.is( got[ 0 ] === got[ 1 ] );

  test.case = '4d matrix, dims[ 2 ] - Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, 2, Infinity, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 0, 1, 0, 3 ],
    strides : [ 1, 1, 2, 2 ],
    offset : [ 7, 7, 6, 6 ],
    indexLogical : 7
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 8 );
  test.is( got[ 0 ] === got[ 1 ] );

  test.case = '4d matrix, dims[ 3 ] - Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, 2, 3, Infinity ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( it ) );
  var exp =
  {
    matrix : m,
    buffer : m.buffer,
    args : [],
    indexNd : [ 0, 1, 2 ],
    strides : [ 1, 1, 2 ],
    offset : [ 6, 6, 6 ],
    indexLogical : 5
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 6 );
  test.is( got[ 0 ] === got[ 1 ] );

  test.close( 'check fields' );

  /* - */

  test.open( 'check order' );

  test.case = '2d matrix without Infinity';
  var buffer = new I32x( 6 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( it.indexNd.slice(), it.offset.slice() ) );
  var exp =
  [
    [ 0, 0 ], [ 0, 0 ],
    [ 1, 0 ], [ 1, 0 ],
    [ 0, 1 ], [ 2, 2 ],
    [ 1, 1 ], [ 3, 2 ],
    [ 0, 2 ], [ 4, 4 ],
    [ 1, 2 ], [ 5, 4 ]
  ];
  test.identical( got, exp );

  /* */

  test.case = '3d matrix without Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( it.indexNd.slice(), it.offset.slice() ) );
  var exp =
  [
    [ 0, 0, 0 ], [ 0, 0, 0 ],
    [ 1, 0, 0 ], [ 1, 0, 0 ],
    [ 0, 1, 0 ], [ 2, 2, 0 ],
    [ 1, 1, 0 ], [ 3, 2, 0 ],
    [ 0, 2, 0 ], [ 4, 4, 0 ],
    [ 1, 2, 0 ], [ 5, 4, 0 ],
    [ 0, 0, 1 ], [ 6, 6, 6 ],
  ];
  test.identical( got.slice( 0, 14 ), exp );
  test.identical( got.slice( 46, 48 ), [ [ 1, 2, 3 ], [ 23, 22, 18 ] ] );

  /* */

  test.case = '4d matrix without Infinity';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, 2, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.scalarEach( ( it ) => got.push( it.indexNd.slice(), it.offset.slice() ) );
  var exp =
  [
    [ 0, 0, 0, 0 ], [ 0, 0, 0, 0 ],
    [ 0, 1, 0, 0 ], [ 1, 1, 0, 0 ],
    [ 0, 0, 1, 0 ], [ 2, 2, 2, 0 ],
    [ 0, 1, 1, 0 ], [ 3, 3, 2, 0 ],
    [ 0, 0, 2, 0 ], [ 4, 4, 4, 0 ],
    [ 0, 1, 2, 0 ], [ 5, 5, 4, 0 ],
    [ 0, 0, 0, 1 ], [ 6, 6, 6, 6 ],
  ];
  test.identical( got.slice( 0, 14 ), exp );
  test.identical( got.slice( 46, 48 ), [ [ 0, 1, 2, 3 ], [ 23, 23, 22, 18 ] ] );

  test.close( 'check order' );
}

//

function layerEach( test )
{
  test.open( 'standard strides' );

  test.case = '2d matrix';
  var buffer = new I32x( 6 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.layerEach( ( it ) => got.push( [ ... m.rowGet( 0 ), ... m.rowGet( 1 ) ] ) );
  var exp = [ [ 1, 3, 5, 2, 4, 6 ] ];
  test.identical( got, exp );

  /* */

  test.case = '3d matrix';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.layerEach( ( it ) =>
  {
    let offset = it.indexNd[ 0 ] * m.stridesEffective[ 2 ] + m.offset;
    let m1 = new _.Matrix
    ({
      buffer : m.buffer,
      dims : [ 2, 3 ],
      offset,
      strides : m.stridesEffective.slice( 0, 2 ),
    });
    got.push( [ ... m1.rowGet( 0 ), ... m1.rowGet( 1 ) ] )
  });
  var exp =
  [
    [ 1, 3, 5, 2, 4, 6 ],
    [ 7, 9, 11, 8, 10, 12 ],
    [ 13, 15, 17, 14, 16, 18 ],
    [ 19, 21, 23, 20, 22, 24 ]
  ];
  test.identical( got, exp );

  /* */

  test.case = '4d matrix';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, 2, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.layerEach( ( it ) =>
  {
    let offset = it.indexNd[ 0 ] * m.stridesEffective[ 2 ] + it.indexNd[ 1 ] * m.stridesEffective[ 3 ] + m.offset;
    let m1 = new _.Matrix
    ({
      buffer : m.buffer,
      dims : [ 1, 2 ],
      offset,
      strides : m.stridesEffective.slice( 0, 2 ),
    });
    got.push( [ ... m1.rowGet( 0 ) ] )
  });
  var exp =
  [
    [ 1, 2 ], [ 3, 4 ], [ 5, 6 ],
    [ 7, 8 ], [ 9, 10 ], [ 11, 12 ],
    [ 13, 14 ], [ 15, 16 ], [ 17, 18 ],
    [ 19, 20 ], [ 21, 22 ], [ 23, 24 ]
  ];
  test.identical( got, exp );

  test.close( 'standard strides' );

  /* - */

  test.open( 'non-standard strides' );

  test.case = '2d matrix';
  var buffer = new I32x( 12 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3 ],
    offset : 1,
    strides : [ 2, 3 ],
  });
  var got = [];
  m.layerEach( ( it ) => got.push( [ ... m.rowGet( 0 ), ... m.rowGet( 1 ) ] ) );
  var exp = [ [ 2, 5, 8, 4, 7, 10 ] ];
  test.identical( got, exp );

  /* */

  test.case = '3d matrix';
  var buffer = new I32x( 48 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3, 4 ],
    offset : 1,
    strides : [ 2, 3, 9 ],
  });
  var got = [];
  m.layerEach( ( it ) =>
  {
    let offset = it.indexNd[ 0 ] * m.stridesEffective[ 2 ] + m.offset;
    let m1 = new _.Matrix
    ({
      buffer : m.buffer,
      dims : [ 2, 3 ],
      offset,
      strides : m.stridesEffective.slice( 0, 2 ),
    });
    got.push( [ ... m1.rowGet( 0 ), ... m1.rowGet( 1 ) ] )
  });
  var exp =
  [
    [ 2, 5, 8, 4, 7, 10 ],
    [ 11, 14, 17, 13, 16, 19 ],
    [ 20, 23, 26, 22, 25, 28 ],
    [ 29, 32, 35, 31, 34, 37 ]
  ];
  test.identical( got, exp );

  /* */

  test.case = '4d matrix';
  var buffer = new I32x( 48 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, 2, 3, 4 ],
    offset : 1,
    strides : [ 2, 3, 8, 9 ],
  });
  var got = [];
  m.layerEach( ( it ) =>
  {
    let offset = it.indexNd[ 0 ] * m.stridesEffective[ 2 ] + it.indexNd[ 1 ] * m.stridesEffective[ 3 ] + m.offset;
    let m1 = new _.Matrix
    ({
      buffer : m.buffer,
      dims : [ 1, 2 ],
      offset,
      strides : m.stridesEffective.slice( 0, 2 ),
    });
    got.push( [ ... m1.rowGet( 0 ) ] )
  });
  var exp =
  [
    [ 2, 5 ], [ 10, 13 ], [ 18, 21 ],
    [ 11, 14 ], [ 19, 22 ], [ 27, 30 ],
    [ 20, 23 ], [ 28, 31 ], [ 36, 39 ],
    [ 29, 32 ], [ 37, 40 ], [ 45, 48 ]
  ];
  test.identical( got, exp );

  test.close( 'non-standard strides' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () =>
  {
    var m = _.Matrix.Make([ 2, 3, 4 ]);
    var got = m.layerEach();
  });

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () =>
  {
    var m = _.Matrix.Make([ 2, 3, 4 ]);
    var got = m.layerEach( ( it ) => it.args.push( it.indexLogical ), ( it ) => it );
  });

  test.case = 'wrong type of o.args';
  test.shouldThrowErrorSync( () =>
  {
    var m = _.Matrix.Make([ 2, 3, 4 ]);
    var got = m.layerEach({ onMatrix : ( it ) => it.args.push( it.indexLogical ), args : null });
  });

  test.case = 'wrong type of o.onMatrix';
  test.shouldThrowErrorSync( () =>
  {
    var m = _.Matrix.Make([ 2, 3, 4 ]);
    var got = m.layerEach({ onMatrix : [], args : [] });
  });

  test.case = 'wrong length of o.onMatrix';
  test.shouldThrowErrorSync( () =>
  {
    var m = _.Matrix.Make([ 2, 3, 4 ]);
    var got = m.layerEach({ onMatrix : ( it ) => it.args.push( it.indexLogical ), args : null });
  });
}

//

function layerEachCheckFields( test )
{
  test.case = '2d matrix';
  var buffer = new I32x( 6 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.layerEach( ( it ) => got.push( it ) );
  var exp =
  {
    args : [],
    indexLogical : 0,
    indexNd : [],
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 1 );

  /* */

  test.case = '3d matrix';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.layerEach( ( it ) => got.push( it ) );
  var exp =
  {
    args : [],
    indexLogical : 3,
    indexNd : [ 0 ],
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 4 );
  test.is( got[ 0 ] == got[ 1 ] );

  /* */

  test.case = '4d matrix';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, 2, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.layerEach( ( it ) => got.push( it ) );
  var exp =
  {
    args : [],
    indexLogical : 11,
    indexNd : [ 0, 0 ],
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 12 );
  test.is( got[ 0 ] === got[ 1 ] );

  /* */

  test.case = '3d matrix';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 2, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.layerEach( ( it ) => got.push( it.indexNd.slice(), it.indexLogical ) );
  var exp = [ [ 0 ], 0, [ 1 ], 1, [ 2 ], 2, [ 3 ], 3 ];
  test.identical( got, exp );

  /* */

  test.case = '4d matrix';
  var buffer = new I32x( 24 );
  for( let i = 0; i < buffer.length; i++ )
  buffer[ i ] = i + 1;
  var m = new _.Matrix
  ({
    buffer,
    dims : [ 1, 2, 3, 4 ],
    inputRowMajor : 0,
  });
  var got = [];
  m.layerEach( ( it ) => got.push( it.indexNd.slice(), it.indexLogical ) );
  var exp =
  [
    [ 0, 0 ], 0, [ 1, 0 ], 1, [ 2, 0 ], 2,
    [ 0, 1 ], 3, [ 1, 1 ], 4, [ 2, 1 ], 5,
    [ 0, 2 ], 6, [ 1, 2 ], 7, [ 2, 2 ], 8,
    [ 0, 3 ], 9, [ 1, 3 ], 10, [ 2, 3 ], 11
  ];
  test.identical( got, exp );
}

//

function lineEachStandardStrides( test )
{
  test.case = '2x3. iterate dimension 0';

  var dims = [ 2, 3 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  matrix.lineEach( 0, ( it ) =>
  {
    got.push( ... it.line, '.' );
  });
  var exp = [ 1, 2, '.', 3, 4, '.', 5, 6, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '2x3. iterate dimension 1';

  var dims = [ 2, 3 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  matrix.lineEach( 1, ( it ) =>
  {
    got.push( ... it.line, '.' );
  });
  var exp = [ 1, 3, 5, '.', 2, 4, 6, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '2x3x4. iterate dimension 0';

  var dims = [ 2, 3, 4 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  matrix.lineEach( 0, ( it ) =>
  {
    got.push( ... it.line, '.' );
  });
  var exp = [ 1, 2, '.', 3, 4, '.', 5, 6, '.', 7, 8, '.', 9, 10, '.', 11, 12, '.', 13, 14, '.', 15, 16, '.', 17, 18, '.', 19, 20, '.', 21, 22, '.', 23, 24, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '2x3x4. iterate dimension 1';

  var dims = [ 2, 3, 4 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  matrix.lineEach( 1, ( it ) =>
  {
    got.push( ... it.line, '.' );
  });
  var exp = [ 1, 3, 5, '.', 2, 4, 6, '.', 7, 9, 11, '.', 8, 10, 12, '.', 13, 15, 17, '.', 14, 16, 18, '.', 19, 21, 23, '.', 20, 22, 24, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '2x3x4. iterate dimension 2';

  var dims = [ 2, 3, 4 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  matrix.lineEach( 2, ( it ) =>
  {
    got.push( ... it.line, '.' );
  });
  var exp = [ 1, 7, 13, 19, '.', 2, 8, 14, 20, '.', 3, 9, 15, 21, '.', 4, 10, 16, 22, '.', 5, 11, 17, 23, '.', 6, 12, 18, 24, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '1x2x3x4. iterate dimension 0';

  var dims = [ 1, 2, 3, 4 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  matrix.lineEach( 0, ( it ) =>
  {
    got.push( ... it.line, '.' );
  });
  var exp = [ 1, '.', 2, '.', 3, '.', 4, '.', 5, '.', 6, '.', 7, '.', 8, '.', 9, '.', 10, '.', 11, '.', 12, '.', 13, '.', 14, '.', 15, '.', 16, '.', 17, '.', 18, '.', 19, '.', 20, '.', 21, '.', 22, '.', 23, '.', 24, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '1x2x3x4. iterate dimension 1';

  var dims = [ 1, 2, 3, 4 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  matrix.lineEach( 1, ( it ) =>
  {
    got.push( ... it.line, '.' );
  });
  var exp = [ 1, 2, '.', 3, 4, '.', 5, 6, '.', 7, 8, '.', 9, 10, '.', 11, 12, '.', 13, 14, '.', 15, 16, '.', 17, 18, '.', 19, 20, '.', 21, 22, '.', 23, 24, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '1x2x3x4. iterate dimension 2';

  var dims = [ 1, 2, 3, 4 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  matrix.lineEach( 2, ( it ) =>
  {
    got.push( ... it.line, '.' );
  });
  var exp = [ 1, 3, 5, '.', 2, 4, 6, '.', 7, 9, 11, '.', 8, 10, 12, '.', 13, 15, 17, '.', 14, 16, 18, '.', 19, 21, 23, '.', 20, 22, 24, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '1x2x3x4. iterate dimension 3';

  var dims = [ 1, 2, 3, 4 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  matrix.lineEach( 3, ( it ) =>
  {
    got.push( ... it.line, '.' );
  });
  var exp = [ 1, 7, 13, 19, '.', 2, 8, 14, 20, '.', 3, 9, 15, 21, '.', 4, 10, 16, 22, '.', 5, 11, 17, 23, '.', 6, 12, 18, 24, '.' ];
  test.identical( got, exp );
}

//

function lineEachCheckFields( test )
{
  test.case = '2x3, iterate dimension : 0';

  var dims = [ 2, 3 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  matrix.lineEach( 0, ( it ) =>
  {
    got.push( it );
  });
  var exp =
  {
    buffer : buffer,
    indexNd : [ null, 3 ],
    offset : [ 6 ],
    line : _.vectorAdapter.from( new I32x([ 5, 6 ]) ),
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 3 );
  test.is( got[ 0 ] === got[ 1 ] );

  /* */

  test.case = '2x3, iterate dimension : 1';

  var dims = [ 2, 3 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  matrix.lineEach( 1, ( it ) =>
  {
    got.push( it );
  });
  var exp =
  {
    buffer : buffer,
    indexNd : [ 2, null ],
    offset : [ 2 ],
    line : _.vectorAdapter.from( new I32x([ 2, 4, 6 ]) ),
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 2 );
  test.is( got[ 0 ] === got[ 1 ] );

  /* */

  test.case = '2x3x4, iterate dimension : 1';

  var dims = [ 2, 3, 4 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  matrix.lineEach( 1, ( it ) =>
  {
    got.push( it );
  });
  var exp =
  {
    buffer : buffer,
    indexNd : [ 8, null, 4 ],
    offset : [ 24, 24 ],
    line : _.vectorAdapter.from( new I32x([ 20, 22, 24 ]) ),
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 8 );
  test.is( got[ 0 ] === got[ 1 ] );

  /* */

  test.case = '2x3x4, iterate dimension : 2';

  var dims = [ 2, 3, 4 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  matrix.lineEach( 2, ( it ) =>
  {
    got.push( it );
  });
  var exp =
  {
    buffer : buffer,
    indexNd : [ 6, 3, null ],
    offset : [ 6, 6 ],
    line : _.vectorAdapter.from( new I32x([ 6, 12, 18, 24 ]) ),
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 6 );
  test.is( got[ 0 ] === got[ 1 ] );

  /* */

  test.case = '1x2x3x4, iterate dimension : 2';

  var dims = [ 1, 2, 3, 4 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  matrix.lineEach( 2, ( it ) =>
  {
    got.push( it );
  });
  var exp =
  {
    buffer : buffer,
    indexNd : [ 0, 0, null, 4 ],
    offset : [ 24, 24, 24  ],
    line : _.vectorAdapter.from( new I32x([ 20, 22, 24 ]) ),
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 8 );
  test.is( got[ 0 ] === got[ 1 ] );

  /* */

  test.case = '1x2x3x4, iterate dimension : 3';

  var dims = [ 1, 2, 3, 4 ];
  var length = _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    inputRowMajor : 0,
  });

  var got = [];
  matrix.lineEach( 3, ( it ) =>
  {
    got.push( it );
  });
  var exp =
  {
    buffer : buffer,
    indexNd : [ 0, 0, 3, null ],
    offset : [ 6, 6, 6 ],
    line : _.vectorAdapter.from( new I32x([ 6, 12, 18, 24 ]) ),
  };
  test.identical( got[ 0 ], exp );
  test.identical( got.length, 6 );
  test.is( got[ 0 ] === got[ 1 ] );
}

//

function lineEachNonStandardStrides( test )
{
  test.case = '2x3. iterate dimension 0';

  var dims = [ 2, 3 ];
  var length = 2 * _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    offset : 1,
    strides : [ 2, 3 ]
  });

  var got = [];
  matrix.lineEach( 0, ( it ) =>
  {
    got.push( ... it.line, '.' );
  });
  var exp = [ 2, 4, '.', 5, 7, '.', 8, 10, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '2x3. iterate dimension 1';

  var dims = [ 2, 3 ];
  var length = 2 * _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    offset : 1,
    strides : [ 2, 3 ]
  });

  var got = [];
  matrix.lineEach( 1, ( it ) =>
  {
    got.push( ... it.line, '.' );
  });
  var exp = [ 2, 5, 8, '.', 4, 7, 10, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '2x3x4. iterate dimension 0';

  var dims = [ 2, 3, 4 ];
  var length = 2 * _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    offset : 1,
    strides : [ 2, 3, 9 ]
  });

  var got = [];
  matrix.lineEach( 0, ( it ) =>
  {
    got.push( ... it.line, '.' );
  });
  var exp = [ 2, 4, '.', 5, 7, '.', 8, 10, '.', 11, 13, '.', 14, 16, '.', 17, 19, '.', 20, 22, '.', 23, 25, '.', 26, 28, '.', 29, 31, '.', 32, 34, '.', 35, 37, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '2x3x4. iterate dimension 1';

  var dims = [ 2, 3, 4 ];
  var length = 2 * _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    offset : 1,
    strides : [ 2, 3, 9 ]
  });

  var got = [];
  matrix.lineEach( 1, ( it ) =>
  {
    got.push( ... it.line, '.' );
  });
  var exp = [ 2, 5, 8, '.', 4, 7, 10, '.', 11, 14, 17, '.', 13, 16, 19, '.', 20, 23, 26, '.', 22, 25, 28, '.', 29, 32, 35, '.', 31, 34, 37, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '2x3x4. iterate dimension 2';

  var dims = [ 2, 3, 4 ];
  var length = 2 * _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    offset : 1,
    strides : [ 2, 3, 9 ],
  });

  var got = [];
  matrix.lineEach( 2, ( it ) =>
  {
    got.push( ... it.line, '.' );
  });
  var exp = [ 2, 11, 20, 29, '.', 4, 13, 22, 31, '.', 5, 14, 23, 32, '.', 7, 16, 25, 34, '.', 8, 17, 26, 35, '.', 10, 19, 28, 37, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '1x2x3x4. iterate dimension 0';

  var dims = [ 1, 2, 3, 4 ];
  var length = 2 * _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    offset : 1,
    strides : [ 2, 3, 8, 9 ],
  });

  var got = [];
  matrix.lineEach( 0, ( it ) =>
  {
    got.push( ... it.line, '.' );
  });
  var exp = [ 2, '.', 5, '.', 10, '.', 13, '.', 18, '.', 21, '.', 11, '.', 14, '.', 19, '.', 22, '.', 27, '.', 30, '.', 20, '.', 23, '.', 28, '.', 31, '.', 36, '.', 39, '.', 29, '.', 32, '.', 37, '.', 40, '.', 45, '.', 48, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '1x2x3x4. iterate dimension 1';

  var dims = [ 1, 2, 3, 4 ];
  var length = 2 * _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    offset : 1,
    strides : [ 2, 3, 8, 9 ],
  });

  var got = [];
  matrix.lineEach( 1, ( it ) =>
  {
    got.push( ... it.line, '.' );
  });
  var exp = [ 2, 5, '.', 10, 13, '.', 18, 21, '.', 11, 14, '.', 19, 22, '.', 27, 30, '.', 20, 23, '.', 28, 31, '.', 36, 39, '.', 29, 32, '.', 37, 40, '.', 45, 48, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '1x2x3x4. iterate dimension 2';

  var dims = [ 1, 2, 3, 4 ];
  var length = 2 * _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    offset : 1,
    strides : [ 2, 3, 8, 9 ],
  });

  var got = [];
  matrix.lineEach( 2, ( it ) =>
  {
    got.push( ... it.line, '.' );
  });
  var exp = [ 2, 10, 18, '.', 5, 13, 21, '.', 11, 19, 27,  '.', 14, 22, 30, '.', 20, 28, 36, '.', 23, 31, 39, '.', 29, 37, 45, '.', 32, 40, 48, '.' ];
  test.identical( got, exp );

  /* */

  test.case = '1x2x3x4. iterate dimension 3';

  var dims = [ 1, 2, 3, 4 ];
  var length = 2 * _.avector.reduceToProduct( dims );
  var buffer = new I32x( length );
  for( let i = 0 ; i < length ; i++ )
  buffer[ i ] = i+1;

  var matrix = new wTools.Matrix
  ({
    buffer,
    dims,
    offset : 1,
    strides : [ 2, 3, 8, 9 ],
  });

  var got = [];
  matrix.lineEach( 3, ( it ) =>
  {
    got.push( ... it.line, '.' );
  });
  var exp = [ 2, 11, 20, 29, '.', 5, 14, 23, 32, '.', 10, 19, 28, 37, '.', 13, 22, 31, 40, '.', 18, 27, 36, 45, '.', 21, 30, 39, 48, '.' ];
  test.identical( got, exp );
}

//

function partialAccessors( test ) /* qqq : split */
{

  /* */

  test.case = 'mul';

  var u = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, +2, +3,
    +0, +4, +5,
    +0, +0, +6,
  ]);

  var l = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, +0, +0,
    +2, +4, +0,
    +3, +5, +6,
  ]);

  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +14, +23, +18,
    +23, +41, +30,
    +18, +30, +36,
  ]);

  var uxl = _.Matrix.Mul( null, [ u, l ] );
  logger.log( uxl );
  test.identical( uxl, exp );

  /* */

  test.case = 'zero';

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    0, 0, 0,
    0, 0, 0,
  ]);

  m.zero();
  test.identical( m, exp );

  /* */

  test.case = 'zero empty';

  var m = _.Matrix.Make([ 0, 0 ]);
  var exp = _.Matrix.Make([ 0, 0 ]);
  var r = m.zero();
  test.identical( m, exp );
  test.is( m === r );

  /* */

  test.case = 'zero bad arguments';

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity( 3 ).zero( 1 ) );
    test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity( 3 ).zero([ 1, 1 ]) );
    test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity( 3 ).zero( _.Matrix.MakeIdentity( 3 ) ) );
  }

  /* */

  test.case = 'diagonalGet 3x4 transposed';

  var buffer =
  [
    -1,
    1, 2, 3, 4,
    5, 6, 7, 8,
    9, 10, 11, 12,
    -1,
  ]

  var m = _.Matrix
  ({
    dims : [ 3, 4 ],
    inputRowMajor : 1,
    offset : 1,
    buffer,
  });

  var exp = _.vad.from([ 1, 6, 11 ]);
  var diagonal = m.diagonalGet();
  test.identical( diagonal, exp );

  /* */

  test.case = 'diagonalGet 3x4 not transposed';

  var buffer =
  [
    -1,
    1, 5, 9,
    2, 6, 10,
    3, 7, 11,
    4, 8, 12,
    -1,
  ]

  var m = _.Matrix
  ({
    dims : [ 3, 4 ],
    inputRowMajor : 0,
    offset : 1,
    buffer,
  });

  var exp = _.vad.from([ 1, 6, 11 ]);
  var diagonal = m.diagonalGet();
  test.identical( diagonal, exp );

  /* */

  test.case = 'diagonalGet null row';

  var m = _.Matrix.Make([ 0, 4 ]);
  var exp = fvec([]);
  var diagonal = m.diagonalGet();
  test.identical( diagonal, exp );

  /* */

  test.case = 'diagonalGet 4x3 transposed';

  var buffer =
  [
    -1,
    1, 5, 9,
    2, 6, 10,
    3, 7, 11,
    4, 8, 12,
    -1,
  ]

  var m = _.Matrix
  ({
    dims : [ 4, 3 ],
    inputRowMajor : 1,
    offset : 1,
    buffer,
  });

  var exp = _.vad.from([ 1, 6, 11 ]);
  var diagonal = m.diagonalGet();
  test.identical( diagonal, exp );

  /* */

  test.case = 'diagonalGet 4x3 not transposed';

  var buffer =
  [
    -1,
    1, 2, 3, 4,
    5, 6, 7, 8,
    9, 10, 11, 12,
    -1,
  ]

  var m = _.Matrix
  ({
    dims : [ 4, 3 ],
    inputRowMajor : 0,
    offset : 1,
    buffer,
  });

  var exp = _.vad.from([ 1, 6, 11 ]);
  var diagonal = m.diagonalGet();
  test.identical( diagonal, exp );

  /* */

  test.case = 'diagonalGet null column';

  var m = _.Matrix.Make([ 4, 0 ]);
  var exp = fvec([]);
  var diagonal = m.diagonalGet();
  test.identical( diagonal, exp );

  /* */

  test.case = 'diagonalGet bad arguments';

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity( 3 ).diagonalGet( 1 ) );
    test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity( 3 ).diagonalGet([ 1, 1 ]) );
    test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity( 3 ).diagonalGet( _.Matrix.MakeIdentity( 3 ) ) );
  }

  /* */

  test.case = 'diagonalSet vector';

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    11, 2, 3,
    4, 22, 6,
  ]);

  m.diagonalSet( ivec([ 11, 22 ]) );
  test.identical( m, exp );

  /* */

  test.case = 'diagonalSet 2x3';

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    11, 2, 3,
    4, 22, 6,
  ]);

  m.diagonalSet([ 11, 22 ]);
  test.identical( m, exp );

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    0, 2, 3,
    4, 0, 6,
  ]);

  m.diagonalSet( 0 );
  test.identical( m, exp );

  /* */

  test.case = 'diagonalSet 3x2';

  var m = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1, 2,
    3, 4,
    5, 6,
  ]);

  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
    11, 2,
    3, 22,
    5, 6,
  ]);

  m.diagonalSet([ 11, 22 ]);
  test.identical( m, exp );

  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
    0, 2,
    3, 0,
    5, 6,
  ]);

  m.diagonalSet( 0 );
  test.identical( m, exp );

  /* */

  test.case = 'diagonalSet from another matrix';

  var m1 = _.Matrix.Make([ 3, 4 ]).copy
  ([
    1, 2, 3, 4,
    5, 6, 7, 8,
    9, 10, 11, 12,
  ]);

  var m2 = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +10, -1, -1,
    -1, +20, -1,
    -1, -1, +30,
  ]);

  m2.buffer = new I32x
  ([
    +10, -1, -1,
    -1, +20, -1,
    -1, -1, +30,
  ]);

  var exp = _.Matrix.Make([ 3, 4 ]).copy
  ([
    10, 2, 3, 4,
    5, 20, 7, 8,
    9, 10, 30, 12,
  ]);

  m1.diagonalSet( m2 );
  test.identical( m1, exp );

  var m1 = _.Matrix.Make([ 4, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
    10, 11, 12,
  ]);

  var m2 = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +10, -1, -1,
    -1, +20, -1,
    -1, -1, +30,
  ]);

  var exp = _.Matrix.Make([ 4, 3 ]).copy
  ([
    10, 2, 3,
    4, 20, 6,
    7, 8, 30,
    10, 11, 12,
  ]);

  m1.diagonalSet( m2 );
  test.identical( m1, exp );

  /* */

  test.case = 'diagonalSet 0x0';

  var m = _.Matrix.Make([ 0, 0 ]);
  var r = m.diagonalSet( 0 );
  test.identical( m.dims, [ 0, 0 ] );
  test.identical( m.stridesEffective, [ 1, 0 ] );
  test.is( m === r );

  var m = _.Matrix.Make([ 0, 0 ]);
  var r = m.diagonalSet( _.Matrix.Make([ 0, 3 ]) );
  test.identical( m.dims, [ 0, 0 ] );
  test.identical( m.stridesEffective, [ 1, 0 ] );
  test.is( m === r );

  var m = _.Matrix.Make([ 0, 0 ]);
  var r = m.diagonalSet( _.Matrix.Make([ 3, 0 ]) );
  test.identical( m.dims, [ 0, 0 ] );
  test.identical( m.stridesEffective, [ 1, 0 ] );
  test.is( m === r );

  /* */

  test.case = 'diagonalSet bad arguments';

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity( 3 ).diagonalSet() );
    test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity( 3 ).diagonalSet([ 1, 1 ]) );
    test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity( 3 ).diagonalSet( _.Matrix.MakeIdentity( 2 ) ) );
  }

  /* */

  test.case = 'identity 3x2';

  var m = _.Matrix.MakeZero([ 3, 2 ]);

  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1, 0,
    0, 1,
    0, 0,
  ]);

  m.identity();
  test.identical( m, exp );

  /* */

  test.case = 'identity 2x3';

  var m = _.Matrix.MakeZero([ 2, 3 ]);

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 0, 0,
    0, 1, 0,
  ]);

  m.identity();
  test.identical( m, exp );

  /* */

  test.case = 'identity 0x0';

  var m = _.Matrix.MakeZero([ 0, 3 ]);
  var r = m.identity();
  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.stridesEffective, [ 1, 0 ] );
  test.is( m === r );

  var m = _.Matrix.MakeZero([ 3, 0 ]);
  var r = m.identity();
  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m.stridesEffective, [ 1, 3 ] );
  test.is( m === r );

  /* */

  test.case = 'identity bad arguments';

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity( 3 ).identity( 1 ) );
    test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity( 3 ).identity([ 1, 1 ]) );
  }

  /* */

  test.case = 'triangleLowerSet 3x4';

  var exp = _.Matrix.Make([ 3, 4 ]).copy
  ([
    1, 2, 3, 4,
    0, 6, 7, 8,
    0, 0, 11, 12,
  ]);

  var buffer = new F32x
  ([
    -1,
    1, 2, 3, 4,
    5, 6, 7, 8,
    9, 10, 11, 12,
    -1,
  ]);

  var m = _.Matrix
  ({
    dims : [ 3, 4 ],
    inputRowMajor : 1,
    offset : 1,
    buffer,
  });

  m.triangleLowerSet( 0 );
  test.identical( m, exp );

  var exp = _.Matrix.Make([ 3, 4 ]).copy
  ([
    1 , 2, 3, 4,
    10, 6, 7, 8,
    20, 30, 11, 12,
  ]);

  var m2 = _.Matrix.Make([ 3, 2 ]).copy
  ([
    -1, -1,
    +10, -1,
    +20, +30,
  ]);

  m.triangleLowerSet( m2 );
  test.identical( m, exp );

  /* */

  test.case = 'triangleLowerSet 4x3';

  var exp = _.Matrix.Make([ 4, 3 ]).copy
  ([
    1, 5, 9,
    0, 6, 10,
    0, 0, 11,
    0, 0, 0,
  ]);

  var buffer = new F32x
  ([
    -1,
    1, 5, 9,
    2, 6, 10,
    3, 7, 11,
    4, 8, 12,
    -1,
  ]);

  var m = _.Matrix
  ({
    dims : [ 4, 3 ],
    inputRowMajor : 1,
    offset : 1,
    buffer,
  });

  m.triangleLowerSet( 0 );
  test.identical( m, exp );

  var exp = _.Matrix.Make([ 4, 3 ]).copy
  ([
    1, 5, 9,
    10, 6, 10,
    20, 40, 11,
    30, 50, 60,
  ]);

  var m2 = _.Matrix.Make([ 4, 3 ]).copy
  ([
    -1, -1, -1,
    +10, -1, -1,
    +20, +40, -1,
    +30, +50, +60,
  ]);

  m.triangleLowerSet( m2 );
  test.identical( m, exp );

  /* */

  test.case = 'triangleLowerSet 4x1';

  var buffer = new F32x
  ([
    -1,
    1,
    2,
    3,
    4,
    -1,
  ]);

  var m = _.Matrix
  ({
    dims : [ 4, 1 ],
    inputRowMajor : 1,
    offset : 1,
    buffer,
  });

  var exp = _.Matrix.Make([ 4, 1 ]).copy
  ([
    1,
    10,
    20,
    30,
  ]);

  var m2 = _.Matrix.Make([ 4, 1 ]).copy
  ([
    -1,
    +10,
    +20,
    +30,
  ]);

  m.triangleLowerSet( m2 );
  test.identical( m, exp );

  /* */

  test.case = 'triangleLowerSet 1x4';

  var buffer = new F32x
  ([
    -1,
    1, 2, 3, 4,
    -1,
  ]);

  var m = _.Matrix
  ({
    dims : [ 1, 4 ],
    inputRowMajor : 1,
    offset : 1,
    buffer,
  });

  var exp = _.Matrix.Make([ 1, 4 ]).copy
  ([
    1, 2, 3, 4,
  ]);

  var m2 = _.Matrix.Make([ 1, 1 ]).copy
  ([
    -10,
  ]);

  m.triangleLowerSet( m2 );
  test.identical( m, exp );

  /* */

  test.case = 'triangleLowerSet bad arguments';

  if( Config.debug )
  {

    test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 4 ]).triangleLowerSet( _.Matrix.Make([ 2, 4 ]) ) );
    test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 4 ]).triangleLowerSet( _.Matrix.Make([ 3, 1 ]) ) );
    test.shouldThrowErrorSync( () => _.Matrix.Make([ 4, 3 ]).triangleLowerSet( _.Matrix.Make([ 3, 3 ]) ) );
    test.shouldThrowErrorSync( () => _.Matrix.Make([ 4, 3 ]).triangleLowerSet( _.Matrix.Make([ 4, 2 ]) ) );

    test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 0 ]).triangleLowerSet( _.Matrix.Make([ 0, 0 ]) ) );
    test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 0 ]).triangleLowerSet( _.Matrix.Make([ 2, 0 ]) ) );
    test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 0 ]).triangleLowerSet( _.Matrix.Make([ 0, 3 ]) ) );
    test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 0 ]).triangleLowerSet( _.Matrix.Make([ 0, 4 ]) ) );

  }

  /* */

  test.case = 'triangleUpperSet 4x3';

  var exp = _.Matrix.Make([ 4, 3 ]).copy
  ([
    1, 0, 0,
    2, 6, 0,
    3, 7, 11,
    4, 8, 12,
  ]);

  var buffer = new F32x
  ([
    -1,
    1, 5, 9,
    2, 6, 10,
    3, 7, 11,
    4, 8, 12,
    -1,
  ]);

  var m = _.Matrix
  ({
    dims : [ 4, 3 ],
    inputRowMajor : 1,
    offset : 1,
    buffer,
  });

  m.triangleUpperSet( 0 );
  test.identical( m, exp );

  var exp = _.Matrix.Make([ 4, 3 ]).copy
  ([
    1, 10, 20,
    2, 6, 30,
    3, 7, 11,
    4, 8, 12,
  ]);

  var m2 = _.Matrix.Make([ 2, 3 ]).copy
  ([
    -1, +10, +20,
    -1, -1, +30,
  ]);

  m.triangleUpperSet( m2 );
  test.identical( m, exp );

  /* */

  test.case = 'triangleUpperSet 3x4';

  var exp = _.Matrix.Make([ 3, 4 ]).copy
  ([
    1, 0, 0, 0,
    5, 6, 0, 0,
    9, 10, 11, 0,
  ]);

  var buffer = new F32x
  ([
    -1,
    1, 2, 3, 4,
    5, 6, 7, 8,
    9, 10, 11, 12,
    -1,
  ]);

  var m = _.Matrix
  ({
    dims : [ 3, 4 ],
    inputRowMajor : 1,
    offset : 1,
    buffer,
  });

  m.triangleUpperSet( 0 );
  test.identical( m, exp );

  var m2 = _.Matrix.Make([ 3, 4 ]).copy
  ([
    -1, 10, 20, 30,
    -1, -1, 40, 50,
    -1, -1, -1, 60,
  ]);

  var exp = _.Matrix.Make([ 3, 4 ]).copy
  ([
    1, 10, 20, 30,
    5, 6, 40, 50,
    9, 10, 11, 60,
  ]);

  m.triangleUpperSet( m2 );
  test.identical( m, exp );

  /* */

  test.case = 'triangleUpperSet 1x4';

  var buffer = new F32x
  ([
    -1,
    1, 2, 3, 4,
    -1,
  ]);

  var m = _.Matrix
  ({
    dims : [ 1, 4 ],
    inputRowMajor : 1,
    offset : 1,
    buffer,
  });

  var m2 = _.Matrix.Make([ 1, 4 ]).copy
  ([
    -1, 10, 20, 30,
  ]);

  var exp = _.Matrix.Make([ 1, 4 ]).copy
  ([
    1, 10, 20, 30,
  ]);

  m.triangleUpperSet( m2 );
  test.identical( m, exp );

  /* */

  test.case = 'triangleUpperSet 4x1';

  var buffer = new F32x
  ([
    -1,
    1,
    2,
    3,
    4,
    -1,
  ]);

  var m = _.Matrix
  ({
    dims : [ 4, 1 ],
    inputRowMajor : 1,
    offset : 1,
    buffer,
  });

  var m2 = _.Matrix.Make([ 1, 1 ]).copy
  ([
    -1,
  ]);

  var exp = _.Matrix.Make([ 4, 1 ]).copy
  ([
    1,
    2,
    3,
    4,
  ]);

  m.triangleUpperSet( m2 );
  test.identical( m, exp );

  /* */

  test.case = 'triangleUpperSet bad arguments';

  if( Config.debug )
  {

    test.shouldThrowErrorSync( () => _.Matrix.Make([ 4, 3 ]).triangleUpperSet( _.Matrix.Make([ 4, 2 ]) ) );
    test.shouldThrowErrorSync( () => _.Matrix.Make([ 4, 3 ]).triangleUpperSet( _.Matrix.Make([ 1, 3 ]) ) );
    test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 4 ]).triangleUpperSet( _.Matrix.Make([ 3, 3 ]) ) );
    test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 4 ]).triangleUpperSet( _.Matrix.Make([ 2, 4 ]) ) );

    test.shouldThrowErrorSync( () => _.Matrix.Make([ 0, 3 ]).triangleUpperSet( _.Matrix.Make([ 0, 0 ]) ) );
    test.shouldThrowErrorSync( () => _.Matrix.Make([ 0, 3 ]).triangleUpperSet( _.Matrix.Make([ 0, 2 ]) ) );
    test.shouldThrowErrorSync( () => _.Matrix.Make([ 0, 3 ]).triangleUpperSet( _.Matrix.Make([ 3, 0 ]) ) );
    test.shouldThrowErrorSync( () => _.Matrix.Make([ 0, 3 ]).triangleUpperSet( _.Matrix.Make([ 4, 0 ]) ) );

  }

  /* */

  test.case = 'triangleSet null matrix';

  function triangleSetNull( rname )
  {

    /* */

    test.case = rname + ' null matrix by scalar';

    var m = _.Matrix.Make([ 0, 3 ]);
    var exp = _.Matrix.Make([ 0, 0 ]);
    var r = m[ rname ]( 0 );
    test.identical( m.dims, [ 0, 3 ] );
    test.is( m === r );

    var m = _.Matrix.Make([ 3, 0 ]);
    var exp = _.Matrix.Make([ 0, 0 ]);
    var r = m[ rname ]( 0 );
    test.identical( m.dims, [ 3, 0 ] );
    test.is( m === r );

    /* */

    test.case = rname + ' null matrix by null matrix';

    var m = _.Matrix.Make([ 0, 0 ]);
    var exp = _.Matrix.Make([ 0, 0 ]);
    var r = m[ rname ]( _.Matrix.Make([ 0, 0 ]) );
    test.is( m === r );

    var m = _.Matrix.Make([ 0, 0 ]);
    var exp = _.Matrix.Make([ 0, 0 ]);
    var r = m[ rname ]( _.Matrix.Make([ 0, 3 ]) );
    test.is( m === r );

    var m = _.Matrix.Make([ 0, 0 ]);
    var exp = _.Matrix.Make([ 0, 0 ]);
    var r = m[ rname ]( _.Matrix.Make([ 3, 0 ]) );
    test.is( m === r );

    /* */

    if( rname !== 'triangleUpperSet' )
    {

      var m = _.Matrix.Make([ 0, 3 ]);
      var exp = _.Matrix.Make([ 0, 0 ]);
      var r = m[ rname ]( _.Matrix.Make([ 0, 0 ]) );
      test.is( m === r );

      var m = _.Matrix.Make([ 0, 3 ]);
      var exp = _.Matrix.Make([ 0, 0 ]);
      var r = m[ rname ]( _.Matrix.Make([ 3, 0 ]) );
      test.is( m === r );

    }

    var m = _.Matrix.Make([ 0, 3 ]);
    var exp = _.Matrix.Make([ 0, 0 ]);
    var r = m[ rname ]( _.Matrix.Make([ 0, 3 ]) );
    test.is( m === r );

    /* */

    if( rname !== 'triangleLowerSet' )
    {
      var m = _.Matrix.Make([ 3, 0 ]);
      var exp = _.Matrix.Make([ 0, 0 ]);
      var r = m[ rname ]( _.Matrix.Make([ 0, 0 ]) );
      test.is( m === r );

      var m = _.Matrix.Make([ 3, 0 ]);
      var exp = _.Matrix.Make([ 0, 0 ]);
      var r = m[ rname ]( _.Matrix.Make([ 0, 3 ]) );
      test.is( m === r );
    }

    var m = _.Matrix.Make([ 3, 0 ]);
    var exp = _.Matrix.Make([ 0, 0 ]);
    var r = m[ rname ]( _.Matrix.Make([ 3, 0 ]) );
    test.is( m === r );

  }

  triangleSetNull( 'triangleLowerSet' );
  triangleSetNull( 'triangleUpperSet' );

  /* */

  test.case = 'bad arguments';

  function shouldThrowErrorOfAnyKind( name )
  {

    test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity( 3 )[ name ]( 1, 1 ) );
    test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity( 3 )[ name ]( '1' ) );
    test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity( 3 )[ name ]( undefined ) );
    test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity( 3 )[ name ]( '1', '3' ) );
    test.shouldThrowErrorSync( () => _.Matrix.MakeIdentity( 3 )[ name ]( [], [] ) );

  }

  if( Config.debug )
  {
    shouldThrowErrorOfAnyKind( 'zero' );
    shouldThrowErrorOfAnyKind( 'identity' );
    shouldThrowErrorOfAnyKind( 'diagonalSet' );
    shouldThrowErrorOfAnyKind( 'triangleLowerSet' );
    shouldThrowErrorOfAnyKind( 'triangleUpperSet' );
  }

}

//

function lineSwap( test )
{

  /* */

  test.case = 'rowsSwap';

  var m = _.Matrix.Make([ 4, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
    11, 22, 33,
  ]);

  var exp = _.Matrix.Make([ 4, 3 ]).copy
  ([
    1, 2, 3,
    7, 8, 9,
    4, 5, 6,
    11, 22, 33,
  ]);

  m.rowsSwap( 3, 0 ).rowsSwap( 0, 3 ).rowsSwap( 1, 2 ).rowsSwap( 0, 0 );
  test.identical( m, exp );

  /* */

  test.case = 'rowsSwap row with itself';

  m.rowsSwap( 0, 0 );
  test.identical( m, exp );

  /* */

  test.case = 'linesSwap';

  var m = _.Matrix.Make([ 4, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
    11, 22, 33,
  ]);

  var exp = _.Matrix.Make([ 4, 3 ]).copy
  ([
    1, 2, 3,
    7, 8, 9,
    4, 5, 6,
    11, 22, 33,
  ]);

  m.linesSwap( 0, 3, 0 ).linesSwap( 0, 0, 3 ).linesSwap( 0, 1, 2 ).linesSwap( 0, 0, 0 );
  test.identical( m, exp );

  /* */

  test.case = 'linesSwap row with itself';

  m.linesSwap( 0, 0, 0 );
  test.identical( m, exp );

  /* */

  test.case = 'colsSwap';

  var m = _.Matrix.Make([ 3, 4 ]).copy
  ([
    1, 2, 3, 4,
    5, 6, 7, 8,
    9, 10, 11, 12,
  ]);

  var exp = _.Matrix.Make([ 3, 4 ]).copy
  ([
    1, 3, 2, 4,
    5, 7, 6, 8,
    9, 11, 10, 12,
  ]);

  m.colsSwap( 0, 3 ).colsSwap( 3, 0 ).colsSwap( 1, 2 ).colsSwap( 0, 0 );
  test.identical( m, exp );

  /* */

  test.case = 'colsSwap row with itself';

  m.colsSwap( 0, 0 );
  test.identical( m, exp );

  /* */

  test.case = 'linesSwap';

  var m = _.Matrix.Make([ 3, 4 ]).copy
  ([
    1, 2, 3, 4,
    5, 6, 7, 8,
    9, 10, 11, 12,
  ]);

  var exp = _.Matrix.Make([ 3, 4 ]).copy
  ([
    1, 3, 2, 4,
    5, 7, 6, 8,
    9, 11, 10, 12,
  ]);

  m.linesSwap( 1, 0, 3 ).linesSwap( 1, 3, 0 ).linesSwap( 1, 1, 2 ).linesSwap( 0, 0, 0 );
  test.identical( m, exp );

  /* */

  test.case = 'linesSwap row with itself';

  m.linesSwap( 1, 0, 0 );
  test.identical( m, exp );

  /* */

  test.case = 'elementsSwap';

  var m = _.Matrix.Make([ 3, 4 ]).copy
  ([
    1, 2, 3, 4,
    5, 6, 7, 8,
    9, 10, 11, 12,
  ]);

  var exp = _.Matrix.Make([ 3, 4 ]).copy
  ([
    1, 3, 2, 4,
    5, 7, 6, 8,
    9, 11, 10, 12,
  ]);

  m.elementsSwap( 0, 3 ).elementsSwap( 3, 0 ).elementsSwap( 1, 2 ).elementsSwap( 0, 0 );
  test.identical( m, exp );

  /* */

  test.case = 'elementsSwap row with itself';

  m.elementsSwap( 0, 0 );
  test.identical( m, exp );

  /* */

  test.case = 'bad arguments';

  if( !Config.debug )
  return;

  function shouldThrowErrorOfAnyKind( rname, dims )
  {
    _.Matrix.Make( dims )[ rname ]( 0, 0 );
    test.shouldThrowErrorSync( () => _.Matrix.Make( dims )[ rname ]( -1, -1 ) );
    test.shouldThrowErrorSync( () => _.Matrix.Make( dims )[ rname ]( 4, 4 ) );
    test.shouldThrowErrorSync( () => _.Matrix.Make( dims )[ rname ]( 0, -1 ) );
    test.shouldThrowErrorSync( () => _.Matrix.Make( dims )[ rname ]( 0, 4 ) );
    test.shouldThrowErrorSync( () => _.Matrix.Make( dims )[ rname ]() );
    test.shouldThrowErrorSync( () => _.Matrix.Make( dims )[ rname ]( 1 ) );
    test.shouldThrowErrorSync( () => _.Matrix.Make( dims )[ rname ]( 1, 2, 3 ) );
  }

  shouldThrowErrorOfAnyKind( 'rowsSwap', [ 4, 3 ] );
  shouldThrowErrorOfAnyKind( 'colsSwap', [ 3, 4 ] );
  shouldThrowErrorOfAnyKind( 'elementsSwap', [ 3, 4 ] );

}

//

function permutate( test )
{

  /* */

  test.case = 'simple row permutate';

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    4, 5, 6,
    1, 2, 3,
  ]);

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  var original = m.clone();

  var permutates =
  [
    [ 1, 0 ],
    [ 0, 1, 2 ],
  ]

  var permutatesExpected =
  [
    [ 1, 0 ],
    [ 0, 1, 2 ],
  ]

  m.permutateForward( permutates );
  test.identical( m, exp );
  test.identical( permutates, permutatesExpected );

  m.permutateBackward( permutates );
  test.identical( m, original );
  test.identical( permutates, permutatesExpected );

  /* */

  test.case = 'complex row permutate';

  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
    5, 6,
    1, 2,
    3, 4,
  ]);

  var m = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1, 2,
    3, 4,
    5, 6,
  ]);

  var original = m.clone();

  var permutates =
  [
    [ 2, 0, 1 ],
    [ 0, 1 ],
  ]

  var permutatesExpected =
  [
    [ 2, 0, 1 ],
    [ 0, 1 ],
  ]

  m.permutateForward( permutates );
  test.identical( m, exp );
  test.identical( permutates, permutatesExpected );

  m.permutateBackward( permutates );
  test.identical( m, original );
  test.identical( permutates, permutatesExpected );

  /* */

  test.case = 'vectorPermutate matrix';

  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
    5, 6,
    1, 2,
    3, 4,
  ]);

  var m = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1, 2,
    3, 4,
    5, 6,
  ]);

  var original = m.clone();

  var permutate = [ 2, 0, 1 ];
  var permutateExpected = [ 2, 0, 1 ];

  _.Matrix.VectorPermutateForward( m, permutate );
  test.identical( m, exp );
  test.identical( permutate, permutateExpected );

  _.Matrix.PermutateBackward( m, permutate );
  test.identical( m, original );
  test.identical( permutate, permutateExpected );

  /* */

  test.case = 'vectorPermutate vector';

  var exp = _.vad.from([ 3, 1, 2 ]);
  var a = _.vad.from([ 1, 2, 3 ]);
  var original = a.clone();

  var permutate = [ 2, 0, 1 ];
  var permutateExpected = [ 2, 0, 1 ];

  _.Matrix.VectorPermutateForward( a, permutate );
  test.identical( a, exp );
  test.identical( permutate, permutateExpected );

  _.Matrix.PermutateBackward( a, permutate );
  test.identical( a, original );
  test.identical( permutate, permutateExpected );

  /* */

  test.case = 'vectorPermutate array';

  var exp = [ 3, 1, 2 ];
  var a = [ 1, 2, 3 ];
  var original = a.slice();

  var permutate = [ 2, 0, 1 ];
  var permutateExpected = [ 2, 0, 1 ];

  _.Matrix.VectorPermutateForward( a, permutate );
  test.identical( a, exp );
  test.identical( permutate, permutateExpected );

  _.Matrix.PermutateBackward( a, permutate );
  test.identical( a, original );
  test.identical( permutate, permutateExpected );

  /* */

  test.case = 'no permutates';

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  var original = m.clone();

  var permutates =
  [
    [ 0, 1 ],
    [ 0, 1, 2 ],
  ]

  m.permutateForward( permutates );
  test.identical( m, exp );

  m.permutateBackward( permutates );
  test.identical( m, original );

  /* */

  test.case = 'complex col permutate';

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    3, 1, 2,
    6, 4, 5,
  ]);

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  var original = m.clone();

  var permutates =
  [
    [ 0, 1 ],
    [ 2, 0, 1 ],
  ]

  m.permutateForward( permutates );
  test.identical( m, exp );

  m.permutateBackward( permutates );
  test.identical( m, original );

  /* */

  test.case = 'complex col permutate';

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    3, 2, 1,
    6, 5, 4,
  ]);

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  var original = m.clone();

  var permutates =
  [
    [ 0, 1 ],
    [ 2, 1, 0 ],
  ]

  m.permutateForward( permutates );
  test.identical( m, exp );

  m.permutateBackward( permutates );
  test.identical( m, original );

  /* */

  test.case = 'complex col permutate';

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    2, 3, 1,
    5, 6, 4,
  ]);

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  var original = m.clone();

  var permutates =
  [
    [ 0, 1 ],
    [ 1, 2, 0 ],
  ]

  m.permutateForward( permutates );
  test.identical( m, exp );

  m.permutateBackward( permutates );
  test.identical( m, original );

  /* */

  test.case = 'mixed permutate';

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    5, 6, 4,
    2, 3, 1,
  ]);

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  var original = m.clone();

  var permutates =
  [
    [ 1, 0 ],
    [ 1, 2, 0 ],
  ]

  var permutatesExpected =
  [
    [ 1, 0 ],
    [ 1, 2, 0 ],
  ]

  m.permutateForward( permutates );
  test.identical( m, exp );
  test.identical( permutates, permutatesExpected );

  m.permutateBackward( permutates );
  test.identical( m, original );
  test.identical( permutates, permutatesExpected );

  /* */

  test.case = 'partially defined permutate';

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    4, 5, 6,
    1, 2, 3,
  ]);

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  var original = m.clone();

  var permutates =
  [
    [ 1, 0 ],
    null,
  ]

  var permutatesExpected =
  [
    [ 1, 0 ],
    null,
  ]

  m.permutateForward( permutates );
  test.identical( m, exp );
  test.identical( permutates, permutatesExpected );

  m.permutateBackward( permutates );
  test.identical( m, original );
  test.identical( permutates, permutatesExpected );

}

//

function _PermutateLineRookWithoutOptionY( test )
{
  test.case = '3x3, npermutations:0 nRowPermutations:0 nColPermutations:0';

  var buffer = new I32x
  ([
    9, 1, 2,
    3, 9, 4,
    5, 6, 9
  ]);
  var m = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  var o =
  {
    m,
    y : null,
    permutates : [ [ 0, 1, 2 ], [ 0, 1, 2 ] ],
    lineIndex : 0,
    npermutations : 0,
    nRowPermutations : 0,
    nColPermutations : 0,
  };
  var got = _.Matrix._PermutateLineRook( o );
  test.identical( o.permutates, [ [ 0, 1, 2 ], [ 0, 1, 2 ] ] );
  test.identical( o.npermutations, 0 );
  test.identical( o.nRowPermutations, 0 );
  test.identical( o.nColPermutations, 0 );

  o.lineIndex = 1;

  var got = _.Matrix._PermutateLineRook( o );
  test.identical( o.permutates, [ [ 0, 1, 2 ], [ 0, 1, 2 ] ] );
  test.identical( o.npermutations, 0 );
  test.identical( o.nRowPermutations, 0 );
  test.identical( o.nColPermutations, 0 );

  o.lineIndex = 2;

  var got = _.Matrix._PermutateLineRook( o );
  test.identical( o.permutates, [ [ 0, 1, 2 ], [ 0, 1, 2 ] ] );
  test.identical( o.npermutations, 0 );
  test.identical( o.nRowPermutations, 0 );
  test.identical( o.nColPermutations, 0 );

  var buffer = new I32x
  ([
    9, 1, 2,
    3, 9, 4,
    5, 6, 9
  ]);
  var exp = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  test.identical( m, exp );

  /* */

  test.case = '3x3, npermutations:1 nRowPermutations:1 nColPermutations:0';

  var buffer = new I32x
  ([
    9,  1,  2,
    3,  9,  4,
    10, 6,  9
  ]);
  var m = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  var o =
  {
    m,
    y : null,
    permutates : [ [ 0, 1, 2 ], [ 0, 1, 2 ] ],
    lineIndex : 0,
    npermutations : 0,
    nRowPermutations : 0,
    nColPermutations : 0,
  };
  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.permutates, [ [ 2, 1, 0 ], [ 0, 1, 2 ] ] );
  test.identical( o.npermutations, 1 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 0 );

  o.lineIndex = 1;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, false );
  test.identical( o.permutates, [ [ 2, 1, 0 ], [ 0, 1, 2 ] ] );
  test.identical( o.npermutations, 1 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 0 );

  o.lineIndex = 2;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, false );
  test.identical( o.permutates, [ [ 2, 1, 0 ], [ 0, 1, 2 ] ] );
  test.identical( o.npermutations, 1 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 0 );

  var buffer = new I32x
  ([
    10, 6,  9,
    3,  9,  4,
    9,  1,  2,
  ]);
  var exp = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  test.identical( m, exp );

  /* */

  test.case = '3x3, npermutations:2 nRowPermutations:2 nColPermutations:0';

  var buffer = new I32x
  ([
    9,  1,  2,
    10, 9,  4,
    3,  10, 9
  ]);
  var m = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  var o =
  {
    m,
    y : null,
    permutates : [ [ 0, 1, 2 ], [ 0, 1, 2 ] ],
    lineIndex : 0,
    npermutations : 0,
    nRowPermutations : 0,
    nColPermutations : 0,
  };
  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.permutates, [ [ 1, 0, 2 ], [ 0, 1, 2 ] ] );
  test.identical( o.npermutations, 1 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 0 );


  o.lineIndex = 1;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.permutates, [ [ 1, 2, 0 ], [ 0, 1, 2 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 2 );
  test.identical( o.nColPermutations, 0 );

  o.lineIndex = 2;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, false );
  test.identical( o.permutates, [ [ 1, 2, 0 ], [ 0, 1, 2 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 2 );
  test.identical( o.nColPermutations, 0 );

  var buffer = new I32x
  ([
    10, 9,  4,
    3,  10, 9,
    9,  1,  2,
  ]);
  var exp = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  test.identical( m, exp );

  /* */

  test.case = '3x3, npermutations:1 nRowPermutations:0 nColPermutations:1';

  var buffer = new I32x
  ([
    9,  10, 2,
    3,  9,  4,
    5,  6,  9
  ]);
  var m = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  var o =
  {
    m,
    y : null,
    permutates : [ [ 0, 1, 2 ], [ 0, 1, 2 ] ],
    lineIndex : 0,
    npermutations : 0,
    nRowPermutations : 0,
    nColPermutations : 0,
  };
  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.permutates, [ [ 0, 1, 2 ], [ 1, 0, 2 ] ] );
  test.identical( o.npermutations, 1 );
  test.identical( o.nRowPermutations, 0 );
  test.identical( o.nColPermutations, 1 );

  o.lineIndex = 1;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.permutates, [ [ 0, 2, 1 ], [ 1, 0, 2 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 1 );

  o.lineIndex = 2;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, false );
  test.identical( o.permutates, [ [ 0, 2, 1 ], [ 1, 0, 2 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 1 );

  var buffer = new I32x
  ([
    10, 9,  2,
    6,  5,  9,
    9,  3,  4,
  ]);
  var exp = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  test.identical( m, exp );


  /* */

  test.case = '3x3, npermutations:2 nRowPermutations:0 nColPermutations:2';

  var buffer = new I32x
  ([
    9,  10, 2,
    3,  9,  10,
    5,  6,  9
  ]);
  var m = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  var o =
  {
    m,
    y : null,
    permutates : [ [ 0, 1, 2 ], [ 0, 1, 2 ] ],
    lineIndex : 0,
    npermutations : 0,
    nRowPermutations : 0,
    nColPermutations : 0,
  };
  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.permutates, [ [ 0, 1, 2 ], [ 1, 0, 2 ] ] );
  test.identical( o.npermutations, 1 );
  test.identical( o.nRowPermutations, 0 );
  test.identical( o.nColPermutations, 1 );

  o.lineIndex = 1;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.permutates, [ [ 0, 1, 2 ], [ 1, 2, 0 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 0 );
  test.identical( o.nColPermutations, 2 );

  o.lineIndex = 2;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, false );
  test.identical( o.permutates, [ [ 0, 1, 2 ], [ 1, 2, 0 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 0 );
  test.identical( o.nColPermutations, 2 );

  var buffer = new I32x
  ([
    10, 2,  9,
    9,  10, 3,
    6,  9,  5,
  ]);
  var exp = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  test.identical( m, exp );
  /* */

  test.case = '3x3, npermutations:2 nRowPermutations:1 nColPermutations:1';

  var buffer = new I32x
  ([
    9,  11, 2,
    3,  9,  4,
    10, 6,  9,
  ]);
  var m = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  var o =
  {
    m,
    y : null,
    permutates : [ [ 0, 1, 2 ], [ 0, 1, 2 ] ],
    lineIndex : 0,
    npermutations : 0,
    nRowPermutations : 0,
    nColPermutations : 0,
  };
  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.permutates, [ [ 0, 1, 2 ], [ 1, 0, 2 ] ] );
  test.identical( o.npermutations, 1 );
  test.identical( o.nRowPermutations, 0 );
  test.identical( o.nColPermutations, 1 );

  o.lineIndex = 1;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.permutates, [ [ 0, 2, 1 ], [ 1, 0, 2 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 1 );

  o.lineIndex = 2;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, false );
  test.identical( o.permutates, [ [ 0, 2, 1 ], [ 1, 0, 2 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 1 );

  var buffer = new I32x
  ([
    11, 9,  2,
    6,  10, 9,
    9,  3,  4,
  ]);
  var exp = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  test.identical( m, exp );

  /* */

  test.case = '3x3 matrix, negative numbers are bigger than positive';

  var buffer = new I32x
  ([
    15, -42, -61,
    43, 57,  19,
    45, 81,  25,
  ]);

  var m = new _.Matrix
  ({
    buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  var o =
  {
    m,
    y : null,
    permutates : [ [ 0, 1, 2 ], [ 0, 1, 2 ] ],
    lineIndex : 0,
    npermutations : 0,
    nRowPermutations : 0,
    nColPermutations : 0,
  };
  var got = _.Matrix._PermutateLineRook( o );
  test.identical( got, true );
  test.identical( o.permutates, [ [ 0, 1, 2 ], [ 2, 1, 0 ] ] );
  test.identical( o.npermutations, 1 );
  test.identical( o.nRowPermutations, 0 );
  test.identical( o.nColPermutations, 1 );

  o.lineIndex = 1;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.permutates, [ [ 0, 2, 1 ], [ 2, 1, 0 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 1 );

  o.lineIndex = 2;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, false );
  test.identical( o.permutates, [ [ 0, 2, 1 ], [ 2, 1, 0 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 1 );

  var buffer = new I32x
  ([
    -61, -42, 15,
    25,  81,  45,
    19,  57,  43,
  ]);
  var exp = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  test.identical( m, exp );

  /* */

  test.case = '4x4, permutating required';

  var buffer = new I32x
  ([
    1,  1,  4,  1,
    2,  2,  10, 6,
    3,  9,  21, 17,
    5,  11, 29, 23,
  ]);

  var m = new _.Matrix
  ({
    buffer,
    dims : [ 4, 4 ],
    inputRowMajor : 1,
  });

  var o =
  {
    m,
    y : null,
    permutates : [ [ 0, 1, 2, 3 ], [ 0, 1, 2, 3 ] ],
    lineIndex : 0,
    npermutations : 0,
    nRowPermutations : 0,
    nColPermutations : 0,
  };
  var got = _.Matrix._PermutateLineRook( o );
  test.identical( got, true );
  test.identical( o.permutates, [ [ 3, 1, 2, 0 ], [ 0, 1, 2, 3 ] ] );
  test.identical( o.npermutations, 1 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 0 );

  o.lineIndex = 1;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.permutates, [ [ 3, 1, 2, 0 ], [ 0, 2, 1, 3 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 1 );

  o.lineIndex = 2;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.permutates, [ [ 3, 1, 2, 0 ], [ 0, 2, 3, 1 ] ] );
  test.identical( o.npermutations, 3 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 2 );

  o.lineIndex = 3;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, false );
  test.identical( o.permutates, [ [ 3, 1, 2, 0 ], [ 0, 2, 3, 1 ] ] );
  test.identical( o.npermutations, 3 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 2 );

  var buffer = new I32x
  ([
    5,  29, 23, 11,
    2,  10, 6,  2,
    3,  21, 17, 9,
    1,  4,  1,  1,
  ]);
  var exp = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 4, 4 ],
    inputRowMajor : 1,
  });

  test.identical( m, exp );

  /* */

  test.case = '4x3, permutating required';

  var buffer = new I32x
  ([
    1,  1,  4,  1,
    2,  2,  10, 6,
    5,  11, 29, 23,
  ]);

  var m = new _.Matrix
  ({
    buffer,
    dims : [ 3, 4 ],
    inputRowMajor : 1,
  });

  var o =
  {
    m,
    y : null,
    permutates : [ [ 0, 1, 2 ], [ 0, 1, 2, 3 ] ],
    lineIndex : 0,
    npermutations : 0,
    nRowPermutations : 0,
    nColPermutations : 0,
  };
  var got = _.Matrix._PermutateLineRook( o );
  test.identical( got, true );
  test.identical( o.permutates, [ [ 2, 1, 0 ], [ 0, 1, 2, 3 ] ] );
  test.identical( o.npermutations, 1 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 0 );

  o.lineIndex = 1;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.permutates, [ [ 2, 1, 0 ], [ 0, 2, 1, 3 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 1 );

  o.lineIndex = 2;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, false );
  test.identical( o.permutates, [ [ 2, 1, 0 ], [ 0, 2, 1, 3 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 1 );

  var buffer = new I32x
  ([
    5,  29, 11, 23,
    2,  10, 2,  6,
    1,  4,  1,  1,
  ]);
  var exp = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 4 ],
    inputRowMajor : 1,
  });

  test.identical( m, exp );
}

//

function _PermutateLineRookWithOptionX( test )
{

  /* */

  test.case = '3x3, npermutations:0 nRowPermutations:0 nColPermutations:0';

  var buffer = new I32x
  ([
    9, 1, 2,
    3, 9, 4,
    5, 6, 9
  ]);
  var m = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });
  var x = _.Matrix.MakeCol([ 1, 2, 3 ]);

  var o =
  {
    m,
    x,
    permutates : [ [ 0, 1, 2 ], [ 0, 1, 2 ] ],
    lineIndex : 0,
    npermutations : 0,
    nRowPermutations : 0,
    nColPermutations : 0,
  };
  var got = _.Matrix._PermutateLineRook( o );
  test.identical( o.x.buffer, [ 1, 2, 3 ] );
  test.identical( o.permutates, [ [ 0, 1, 2 ], [ 0, 1, 2 ] ] );
  test.identical( o.npermutations, 0 );
  test.identical( o.nRowPermutations, 0 );
  test.identical( o.nColPermutations, 0 );

  o.lineIndex = 1;

  var got = _.Matrix._PermutateLineRook( o );
  test.identical( o.x.buffer, [ 1, 2, 3 ] );
  test.identical( o.permutates, [ [ 0, 1, 2 ], [ 0, 1, 2 ] ] );
  test.identical( o.npermutations, 0 );
  test.identical( o.nRowPermutations, 0 );
  test.identical( o.nColPermutations, 0 );

  o.lineIndex = 2;

  var got = _.Matrix._PermutateLineRook( o );
  test.identical( o.x.buffer, [ 1, 2, 3 ] );
  test.identical( o.permutates, [ [ 0, 1, 2 ], [ 0, 1, 2 ] ] );
  test.identical( o.npermutations, 0 );
  test.identical( o.nRowPermutations, 0 );
  test.identical( o.nColPermutations, 0 );

  var buffer = new I32x
  ([
    9, 1, 2,
    3, 9, 4,
    5, 6, 9
  ]);
  var exp = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  test.identical( m, exp );

  /* */

  test.case = '3x3, npermutations:1 nRowPermutations:1 nColPermutations:0';

  var buffer = new I32x
  ([
    9,  1,  2,
    3,  9,  4,
    10, 6,  9
  ]);
  var m = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });
  var x = _.Matrix.MakeCol([ 1, 2, 3 ]);

  var o =
  {
    m,
    x,
    permutates : [ [ 0, 1, 2 ], [ 0, 1, 2 ] ],
    lineIndex : 0,
    npermutations : 0,
    nRowPermutations : 0,
    nColPermutations : 0,
  };
  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.x.buffer, [ 3, 2, 1 ] );
  test.identical( o.permutates, [ [ 2, 1, 0 ], [ 0, 1, 2 ] ] );
  test.identical( o.npermutations, 1 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 0 );

  o.lineIndex = 1;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, false );
  test.identical( o.x.buffer, [ 3, 2, 1 ] );
  test.identical( o.permutates, [ [ 2, 1, 0 ], [ 0, 1, 2 ] ] );
  test.identical( o.npermutations, 1 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 0 );

  o.lineIndex = 2;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, false );
  test.identical( o.x.buffer, [ 3, 2, 1 ] );
  test.identical( o.permutates, [ [ 2, 1, 0 ], [ 0, 1, 2 ] ] );
  test.identical( o.npermutations, 1 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 0 );

  var buffer = new I32x
  ([
    10, 6,  9,
    3,  9,  4,
    9,  1,  2,
  ]);
  var exp = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  test.identical( m, exp );

  /* */

  test.case = '3x3, npermutations:2 nRowPermutations:2 nColPermutations:0';

  var buffer = new I32x
  ([
    9,  1,  2,
    10, 9,  4,
    3,  10, 9
  ]);
  var m = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });
  var x = _.Matrix.MakeCol([ 1, 2, 3 ]);

  var o =
  {
    m,
    x,
    permutates : [ [ 0, 1, 2 ], [ 0, 1, 2 ] ],
    lineIndex : 0,
    npermutations : 0,
    nRowPermutations : 0,
    nColPermutations : 0,
  };
  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.x.buffer, [ 2, 1, 3 ] );
  test.identical( o.permutates, [ [ 1, 0, 2 ], [ 0, 1, 2 ] ] );
  test.identical( o.npermutations, 1 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 0 );

  o.lineIndex = 1;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.x.buffer, [ 2, 3, 1 ] );
  test.identical( o.permutates, [ [ 1, 2, 0 ], [ 0, 1, 2 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 2 );
  test.identical( o.nColPermutations, 0 );

  o.lineIndex = 2;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, false );
  test.identical( o.x.buffer, [ 2, 3, 1 ] );
  test.identical( o.permutates, [ [ 1, 2, 0 ], [ 0, 1, 2 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 2 );
  test.identical( o.nColPermutations, 0 );

  var buffer = new I32x
  ([
    10, 9,  4,
    3,  10, 9,
    9,  1,  2,
  ]);
  var exp = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  test.identical( m, exp );

  /* */

  test.case = '3x3, npermutations:1 nRowPermutations:0 nColPermutations:1';

  var buffer = new I32x
  ([
    9,  10, 2,
    3,  9,  4,
    5,  6,  9
  ]);
  var m = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });
  var x = _.Matrix.MakeCol([ 1, 2, 3 ]);

  var o =
  {
    m,
    x,
    permutates : [ [ 0, 1, 2 ], [ 0, 1, 2 ] ],
    lineIndex : 0,
    npermutations : 0,
    nRowPermutations : 0,
    nColPermutations : 0,
  };
  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.x.buffer, [ 1, 2, 3 ] );
  test.identical( o.permutates, [ [ 0, 1, 2 ], [ 1, 0, 2 ] ] );
  test.identical( o.npermutations, 1 );
  test.identical( o.nRowPermutations, 0 );
  test.identical( o.nColPermutations, 1 );

  o.lineIndex = 1;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.x.buffer, [ 1, 3, 2 ] );
  test.identical( o.permutates, [ [ 0, 2, 1 ], [ 1, 0, 2 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 1 );

  o.lineIndex = 2;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, false );
  test.identical( o.x.buffer, [ 1, 3, 2 ] );
  test.identical( o.permutates, [ [ 0, 2, 1 ], [ 1, 0, 2 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 1 );

  var buffer = new I32x
  ([
    10, 9,  2,
    6,  5,  9,
    9,  3,  4,
  ]);
  var exp = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  test.identical( m, exp );


  /* */

  test.case = '3x3, npermutations:2 nRowPermutations:0 nColPermutations:2';

  var buffer = new I32x
  ([
    9,  10, 2,
    3,  9,  10,
    5,  6,  9
  ]);
  var m = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });
  var x = _.Matrix.MakeCol([ 1, 2, 3 ]);

  var o =
  {
    m,
    x,
    permutates : [ [ 0, 1, 2 ], [ 0, 1, 2 ] ],
    lineIndex : 0,
    npermutations : 0,
    nRowPermutations : 0,
    nColPermutations : 0,
  };
  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.x.buffer, [ 1, 2, 3 ] );
  test.identical( o.permutates, [ [ 0, 1, 2 ], [ 1, 0, 2 ] ] );
  test.identical( o.npermutations, 1 );
  test.identical( o.nRowPermutations, 0 );
  test.identical( o.nColPermutations, 1 );

  o.lineIndex = 1;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.x.buffer, [ 1, 2, 3 ] );
  test.identical( o.permutates, [ [ 0, 1, 2 ], [ 1, 2, 0 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 0 );
  test.identical( o.nColPermutations, 2 );

  o.lineIndex = 2;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, false );
  test.identical( o.x.buffer, [ 1, 2, 3 ] );
  test.identical( o.permutates, [ [ 0, 1, 2 ], [ 1, 2, 0 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 0 );
  test.identical( o.nColPermutations, 2 );

  var buffer = new I32x
  ([
    10, 2,  9,
    9,  10, 3,
    6,  9,  5,
  ]);
  var exp = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  test.identical( m, exp );
  /* */

  test.case = '3x3, npermutations:2 nRowPermutations:1 nColPermutations:1';

  var buffer = new I32x
  ([
    9,  11, 2,
    3,  9,  4,
    10, 6,  9,
  ]);
  var m = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });
  var x = _.Matrix.MakeCol([ 1, 2, 3 ]);

  var o =
  {
    m,
    x,
    permutates : [ [ 0, 1, 2 ], [ 0, 1, 2 ] ],
    lineIndex : 0,
    npermutations : 0,
    nRowPermutations : 0,
    nColPermutations : 0,
  };
  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.x.buffer, [ 1, 2, 3 ] );
  test.identical( o.permutates, [ [ 0, 1, 2 ], [ 1, 0, 2 ] ] );
  test.identical( o.npermutations, 1 );
  test.identical( o.nRowPermutations, 0 );
  test.identical( o.nColPermutations, 1 );

  o.lineIndex = 1;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.x.buffer, [ 1, 3, 2 ] );
  test.identical( o.permutates, [ [ 0, 2, 1 ], [ 1, 0, 2 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 1 );

  o.lineIndex = 2;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, false );
  test.identical( o.x.buffer, [ 1, 3, 2 ] );
  test.identical( o.permutates, [ [ 0, 2, 1 ], [ 1, 0, 2 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 1 );

  var buffer = new I32x
  ([
    11, 9,  2,
    6,  10, 9,
    9,  3,  4,
  ]);
  var exp = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  test.identical( m, exp );

  /* */

  test.case = '3x3 matrix, negative numbers are bigger than positive';

  var buffer = new I32x
  ([
    15, -42, -61,
    43, 57,  19,
    45, 81,  25,
  ]);

  var m = new _.Matrix
  ({
    buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });
  var x = _.Matrix.MakeCol([ 1, 2, 3 ]);

  var o =
  {
    m,
    x,
    permutates : [ [ 0, 1, 2 ], [ 0, 1, 2 ] ],
    lineIndex : 0,
    npermutations : 0,
    nRowPermutations : 0,
    nColPermutations : 0,
  };
  var got = _.Matrix._PermutateLineRook( o );
  test.identical( got, true );
  test.identical( o.x.buffer, [ 1, 2, 3 ] );
  test.identical( o.permutates, [ [ 0, 1, 2 ], [ 2, 1, 0 ] ] );
  test.identical( o.npermutations, 1 );
  test.identical( o.nRowPermutations, 0 );
  test.identical( o.nColPermutations, 1 );

  o.lineIndex = 1;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.x.buffer, [ 1, 3, 2 ] );
  test.identical( o.permutates, [ [ 0, 2, 1 ], [ 2, 1, 0 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 1 );

  o.lineIndex = 2;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, false );
  test.identical( o.x.buffer, [ 1, 3, 2 ] );
  test.identical( o.permutates, [ [ 0, 2, 1 ], [ 2, 1, 0 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 1 );

  var buffer = new I32x
  ([
    -61, -42, 15,
    25,  81,  45,
    19,  57,  43,
  ]);
  var exp = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  test.identical( m, exp );

  /* */

  test.case = '4x4, permutating required';

  var buffer = new I32x
  ([
    1,  1,  4,  1,
    2,  2,  10, 6,
    3,  9,  21, 17,
    5,  11, 29, 23,
  ]);

  var m = new _.Matrix
  ({
    buffer,
    dims : [ 4, 4 ],
    inputRowMajor : 1,
  });
  var x = _.Matrix.MakeCol([ 1, 2, 3, 4 ]);

  var o =
  {
    m,
    x,
    permutates : [ [ 0, 1, 2, 3 ], [ 0, 1, 2, 3 ] ],
    lineIndex : 0,
    npermutations : 0,
    nRowPermutations : 0,
    nColPermutations : 0,
  };
  var got = _.Matrix._PermutateLineRook( o );
  test.identical( got, true );
  test.identical( o.x.buffer, [ 4, 2, 3, 1 ] );
  test.identical( o.permutates, [ [ 3, 1, 2, 0 ], [ 0, 1, 2, 3 ] ] );
  test.identical( o.npermutations, 1 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 0 );

  o.lineIndex = 1;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.x.buffer, [ 4, 2, 3, 1 ] );
  test.identical( o.permutates, [ [ 3, 1, 2, 0 ], [ 0, 2, 1, 3 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 1 );

  o.lineIndex = 2;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.x.buffer, [ 4, 2, 3, 1 ] );
  test.identical( o.permutates, [ [ 3, 1, 2, 0 ], [ 0, 2, 3, 1 ] ] );
  test.identical( o.npermutations, 3 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 2 );

  o.lineIndex = 3;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, false );
  test.identical( o.x.buffer, [ 4, 2, 3, 1 ] );
  test.identical( o.permutates, [ [ 3, 1, 2, 0 ], [ 0, 2, 3, 1 ] ] );
  test.identical( o.npermutations, 3 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 2 );

  var buffer = new I32x
  ([
    5,  29, 23, 11,
    2,  10, 6,  2,
    3,  21, 17, 9,
    1,  4,  1,  1,
  ]);
  var exp = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 4, 4 ],
    inputRowMajor : 1,
  });

  test.identical( m, exp );

  /* */

  test.case = '4x3, permutating required';

  var buffer = new I32x
  ([
    1,  1,  4,  1,
    2,  2,  10, 6,
    5,  11, 29, 23,
  ]);

  var m = new _.Matrix
  ({
    buffer,
    dims : [ 3, 4 ],
    inputRowMajor : 1,
  });
  var x = _.Matrix.MakeCol([ 1, 2, 3, 4 ]);

  var o =
  {
    m,
    x,
    permutates : [ [ 0, 1, 2 ], [ 0, 1, 2, 3 ] ],
    lineIndex : 0,
    npermutations : 0,
    nRowPermutations : 0,
    nColPermutations : 0,
  };
  var got = _.Matrix._PermutateLineRook( o );
  test.identical( got, true );
  test.identical( o.x.buffer, [ 3, 2, 1, 4 ] );
  test.identical( o.permutates, [ [ 2, 1, 0 ], [ 0, 1, 2, 3 ] ] );
  test.identical( o.npermutations, 1 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 0 );

  o.lineIndex = 1;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, true );
  test.identical( o.x.buffer, [ 3, 2, 1, 4 ] );
  test.identical( o.permutates, [ [ 2, 1, 0 ], [ 0, 2, 1, 3 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 1 );

  o.lineIndex = 2;

  var got = _.Matrix._PermutateLineRook( o );
  test.equivalent( got, false );
  test.identical( o.x.buffer, [ 3, 2, 1, 4 ] );
  test.identical( o.permutates, [ [ 2, 1, 0 ], [ 0, 2, 1, 3 ] ] );
  test.identical( o.npermutations, 2 );
  test.identical( o.nRowPermutations, 1 );
  test.identical( o.nColPermutations, 1 );

  var buffer = new I32x
  ([
    5,  29, 11, 23,
    2,  10, 2,  6,
    1,  4,  1,  1,
  ]);
  var exp = new _.Matrix
  ({
    buffer : buffer,
    dims : [ 3, 4 ],
    inputRowMajor : 1,
  });

  test.identical( m, exp );


  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.Matrix._PermutateLineRook() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () =>
  {
    var m = _.Matrix.Make([ 2, 2 ]).copy([ 1, 2, 3, 4 ]);
    var o =
    {
      m,
      x : null,
      permutates : [ [ 0, 1 ], [ 0, 1 ] ],
      lineIndex : 0,
      npermutations : 0,
      nRowPermutations : 0,
      nColPermutations : 0,
    };
    var got = _.Matrix._PermutateLineRook( o, o );
  });

  test.case = 'wrong value in o.lineIndex';
  test.shouldThrowErrorSync( () =>
  {
    var m = _.Matrix.Make([ 2, 2 ]).copy([ 1, 2, 3, 4 ]);
    var o =
    {
      m,
      x : null,
      permutates : [ [ 0, 1 ], [ 0, 1 ] ],
      lineIndex : -1,
      npermutations : 0,
      nRowPermutations : 0,
      nColPermutations : 0,
    };
    var got = _.Matrix._PermutateLineRook( o );
  });

  test.case = 'wrong type of o.m';
  test.shouldThrowErrorSync( () =>
  {
    var o =
    {
      m : {},
      x : null,
      permutates : [ [ 0, 1 ], [ 0, 1 ] ],
      lineIndex : 0,
      npermutations : 0,
      nRowPermutations : 0,
      nColPermutations : 0,
    };
    var got = _.Matrix._PermutateLineRook( o );
  });

  test.case = 'wrong type of o.x';
  test.shouldThrowErrorSync( () =>
  {
    var m = _.Matrix.Make([ 2, 2 ]).copy([ 1, 2, 3, 4 ]);
    var o =
    {
      m,
      x : [ 1, 2 ],
      permutates : [ [ 0, 1 ], [ 0, 1 ] ],
      lineIndex : 0,
      npermutations : 0,
      nRowPermutations : 0,
      nColPermutations : 0,
    };
    var got = _.Matrix._PermutateLineRook( o );
  });
}

//

function submatrix( test )
{
  let context = this;

  var o = Object.create( null );
  o.test = test;

  o.offset = 0;
  o.inputRowMajor = 0;
  _submatrix( o )

  o.offset = 0;
  o.inputRowMajor = 1;
  _submatrix( o )

  o.offset = 10;
  o.inputRowMajor = 0;
  _submatrix( o )

  o.offset = 10;
  o.inputRowMajor = 1;
  _submatrix( o )

  /* */

  function _submatrix( o )
  {
    var test = o.test;

    /* */

    test.case = 'verification';

    var exp = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +2, +3, +4,
      +5, +6, +7, +8,
      +9, +10, +11, +12,
    ]);

    var m = make();
    test.identical( m, exp );
    test.identical( m.offset, o.offset );

    /* */

    test.case = 'simple submatrix';

    var m = make();
    var c1 = m.submatrix( _.all, 0 );
    var c2 = m.submatrix( _.all, 3 );
    var r1 = m.submatrix( 0, _.all );
    var r2 = m.submatrix( 2, _.all );

    var exp = _.Matrix.MakeCol([ 1, 5, 9 ]);
    test.equivalent( c1, exp );

    var exp = _.Matrix.MakeCol([ 4, 8, 12 ]);
    test.equivalent( c2, exp );

    var exp = _.Matrix.MakeRow([ 1, 2, 3, 4 ]);
    test.equivalent( r1, exp );

    var exp = _.Matrix.MakeRow([ 9, 10, 11, 12 ]);
    test.equivalent( r2, exp );

    var exp = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +11, +3, +4, +401,
      +50, +6, +7, +800,
      +93, +13, +14, +1203,
    ]);

    c1.mul( 10 );
    c2.mul( 100 );
    r1.add( 1 );
    r2.add( 3 );

    test.identical( m, exp );

    /* */

    test.case = 'submatrix [ 1, 2 ], null';

    var m = make();
    var exp = _.Matrix.Make([ 2, 4 ]).copy
    ([
      +5, +6, +7, +8,
      +9, +10, +11, +12,
    ]);

    var sub = m.submatrix( [ 1, 2 ], null );
    test.identical( sub, exp );

    var exp = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +2, +3, +4,
      +50, +60, +70, +80,
      +90, +100, +110, +120,
    ]);

    sub.mul( 10 );
    test.identical( m, exp );

    /* */

    test.case = 'submatrix [ 1, 2 ], _.all';

    var m = make();
    var exp = _.Matrix.Make([ 2, 4 ]).copy
    ([
      +5, +6, +7, +8,
      +9, +10, +11, +12,
    ]);

    var sub = m.submatrix( [ 1, 2 ], _.all );
    test.identical( sub, exp );

    var exp = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +2, +3, +4,
      +50, +60, +70, +80,
      +90, +100, +110, +120,
    ]);

    sub.mul( 10 );
    test.identical( m, exp );

    /* */

    test.case = 'submatrix null, [ 1, 2 ]';

    var m = make();
    var exp = _.Matrix.Make([ 3, 2 ]).copy
    ([
      +2, +3,
      +6, +7,
      +10, +11,
    ]);

    var sub = m.submatrix( null, [ 1, 2 ] );
    test.identical( sub, exp );

    var exp = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +20, +30, +4,
      +5, +60, +70, +8,
      +9, +100, +110, +12,
    ]);

    sub.mul( 10 );
    test.identical( m, exp );

    /* */

    test.case = 'submatrix _.all, [ 1, 2 ]';

    var m = make();
    var exp = _.Matrix.Make([ 3, 2 ]).copy
    ([
      +2, +3,
      +6, +7,
      +10, +11,
    ]);

    var sub = m.submatrix( _.all, [ 1, 2 ] );
    test.identical( sub, exp );

    var exp = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +20, +30, +4,
      +5, +60, +70, +8,
      +9, +100, +110, +12,
    ]);

    sub.mul( 10 );
    test.identical( m, exp );

    /* */

    test.case = 'columns [ 1, 2 ]';

    var m = make();
    var exp = _.Matrix.Make([ 3, 2 ]).copy
    ([
      +2, +3,
      +6, +7,
      +10, +11,
    ]);

    var sub = m.submatrix( _.all, [ 1, 2 ] );
    test.identical( sub, exp );

    var exp = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +20, +30, +4,
      +5, +60, +70, +8,
      +9, +100, +110, +12,
    ]);

    sub.mul( 10 );
    test.identical( m, exp );

    /* */

    test.case = 'columns [ 2, 3 ]';

    var m = make();
    var exp = _.Matrix.Make([ 3, 2 ]).copy
    ([
      +3, +4,
      +7, +8,
      +11, +12,
    ]);

    var sub = m.submatrix( _.all, [ 2, 3 ] );
    test.identical( sub, exp );

    var exp = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +2, +30, +40,
      +5, +6, +70, +80,
      +9, +10, +110, +120,
    ]);

    sub.mul( 10 );
    test.identical( m, exp );

    /* */

    test.case = 'columns [ 0, 1 ]';

    var m = make();
    var exp = _.Matrix.Make([ 3, 2 ]).copy
    ([
      +1, +2,
      +5, +6,
      +9, +10,
    ]);

    var sub = m.submatrix( _.all, [ 0, 1 ] );
    test.identical( sub, exp );

    var exp = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +10, +20, +3, +4,
      +50, +60, +7, +8,
      +90, +100, +11, +12,
    ]);

    sub.mul( 10 );
    test.identical( m, exp );

    /* */

    test.case = 'rows [ 0, 1 ]';

    var m = make();
    var exp = _.Matrix.Make([ 2, 4 ]).copy
    ([
      +1, +2, +3, +4,
      +5, +6, +7, +8,
    ]);

    var sub = m.submatrix( [ 0, 1 ], _.all );
    test.identical( sub, exp );

    var exp = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +10, +20, +30, +40,
      +50, +60, +70, +80,
      +9, +10, +11, +12,
    ]);

    sub.mul( 10 );
    test.identical( m, exp );

    /* */

    test.case = 'rows [ 1, 2 ]';

    var m = make();
    var exp = _.Matrix.Make([ 2, 4 ]).copy
    ([
      +5, +6, +7, +8,
      +9, +10, +11, +12,
    ]);


    var sub = m.submatrix( [ 1, 2 ], _.all );
    test.identical( sub, exp );

    var exp = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +2, +3, +4,
      +50, +60, +70, +80,
      +90, +100, +110, +120,
    ]);

    sub.mul( 10 );
    test.identical( m, exp );

    /* */

    test.case = 'rows [ 1, 1 ]';

    var m = make();
    var exp = _.Matrix.Make([ 1, 4 ]).copy
    ([
      +5, +6, +7, +8,
    ]);

    var sub = m.submatrix( [ 1, 1 ], _.all );
    test.identical( sub, exp );

    var exp = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +2, +3, +4,
      +50, +60, +70, +80,
      +9, +10, +11, +12,
    ]);

    sub.mul( 10 );
    test.identical( m, exp );

    /* */

    test.case = 'submatrix [ 0, 1 ], [ 0, 1 ] ';

    var m = make();
    var exp = _.Matrix.Make([ 2, 2 ]).copy
    ([
      +1, +2,
      +5, +6,
    ]);

    var sub = m.submatrix( [ 0, 1 ], [ 0, 1 ] );
    test.identical( sub, exp );

    var exp = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +10, +20, +3, +4,
      +50, +60, +7, +8,
      +9, +10, +11, +12,
    ]);

    sub.mul( 10 );
    test.identical( m, exp );

    /* */

    test.case = 'submatrix [ 0, 1 ], [ 2, 3 ] ';

    var m = make();
    var exp = _.Matrix.Make([ 2, 2 ]).copy
    ([
      +3, +4,
      +7, +8,
    ]);

    var sub = m.submatrix( [ 0, 1 ], [ 2, 3 ] );
    test.identical( sub, exp );

    var exp = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +2, +30, +40,
      +5, +6, +70, +80,
      +9, +10, +11, +12,
    ]);

    sub.mul( 10 );
    test.identical( m, exp );

    /* */

    test.case = 'submatrix [ 1, 2 ], [ 0, 1 ] ';

    var m = make();
    var exp = _.Matrix.Make([ 2, 2 ]).copy
    ([
      +5, +6,
      +9, +10,
    ]);

    var sub = m.submatrix( [ 1, 2 ], [ 0, 1 ] );
    test.identical( sub, exp );

    var exp = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +2, +3, +4,
      +50, +60, +7, +8,
      +90, +100, +11, +12,
    ]);

    sub.mul( 10 );
    test.identical( m, exp );

    /* */

    test.case = 'submatrix [ 1, 2 ], [ 2, 3 ] ';

    var m = make();
    var exp = _.Matrix.Make([ 2, 2 ]).copy
    ([
      +7, +8,
      +11, +12,
    ]);

    var sub = m.submatrix( [ 1, 2 ], [ 2, 3 ] );
    test.identical( sub, exp );

    var exp = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +2, +3, +4,
      +5, +6, +70, +80,
      +9, +10, +110, +120,
    ]);

    sub.mul( 10 );
    test.identical( m, exp );

    /* */

    function make()
    {

      var b = new F32x
      ([
        +1, +2, +3, +4,
        +5, +6, +7, +8,
        +9, +10, +11, +12,
      ]);

      if( !o.inputRowMajor )
      b = new F32x
      ([
        +1, +5, +9,
        +2, +6, +10,
        +3, +7, +11,
        +4, +8, +12,
      ]);

      var m = context.makeWithOffset
      ({
        buffer : b,
        dims : [ 3, 4 ],
        offset : o.offset,
        inputRowMajor : o.inputRowMajor,
      })

      return m;
    }

  }

}

//

function submatrixSelectLast( test )
{

  /* */

  test.case = 'middle';

  var m = new _.Matrix
  ({
    dims : [ 3, 8, 2, 3, 4 ],
    inputRowMajor : 0,
  });
  m.scalarEach( ( it ) =>
  {
    m.scalarSet( it.indexNd, it.indexLogical );
  });
  logger.log( m.toStr() );

  test.identical( m.dims, [ 3, 8, 2, 3, 4 ] );
  test.identical( m.dimsEffective, [ 3, 8, 2, 3, 4 ] );
  test.identical( m.strides, null );
  test.identical( m.stridesEffective, [ 1, 3, 24, 48, 144 ] );
  test.identical( m.scalarsPerCol, 3 );
  test.identical( m.scalarsPerElement, 144 );
  test.identical( m.scalarsPerMatrix, 576 );
  test.identical( m.scalarsPerRow, 8 );
  test.identical( m.scalarsPerLayer, 24 );
  test.identical( m.length, 4 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideInRow, 3 );

  var submatrix = m.submatrix( null, null, 1, 1, 1 );
  logger.log( '' );
  logger.log( submatrix.toStr() );

  var exp = _.Matrix
  ({
    buffer :
    [
      +216, +219, +222, +225, +228, +231, +234, +237,
      +217, +220, +223, +226, +229, +232, +235, +238,
      +218, +221, +224, +227, +230, +233, +236, +239,
    ],
    dims : [ 3, 8 ],
    inputRowMajor : 1,
  });
  test.equivalent( submatrix, exp );

  test.identical( submatrix.dims, [ 3, 8, 1, 1, 1 ] );
  test.identical( submatrix.dimsEffective, [ 3, 8 ] );
  test.identical( submatrix.strides, [ 1, 3, 24, 48, 144 ] );
  test.identical( submatrix.stridesEffective, [ 1, 3 ] );
  test.identical( submatrix.scalarsPerCol, 3 );
  test.identical( submatrix.scalarsPerElement, 24 );
  test.identical( submatrix.scalarsPerMatrix, 24 );
  test.identical( submatrix.scalarsPerRow, 8 );
  test.identical( submatrix.scalarsPerLayer, 24 );
  test.identical( submatrix.length, 1 );
  test.identical( submatrix.strideInCol, 1 );
  test.identical( submatrix.strideInRow, 3 );

  /* */

  test.case = 'begin';

  var m = new _.Matrix
  ({
    dims : [ 3, 8, 2, 3, 4 ],
    inputRowMajor : 0,
  });
  m.scalarEach( ( it ) =>
  {
    m.scalarSet( it.indexNd, it.indexLogical );
  });
  logger.log( m.toStr() );

  test.identical( m.dims, [ 3, 8, 2, 3, 4 ] );
  test.identical( m.dimsEffective, [ 3, 8, 2, 3, 4 ] );
  test.identical( m.strides, null );
  test.identical( m.stridesEffective, [ 1, 3, 24, 48, 144 ] );
  test.identical( m.scalarsPerCol, 3 );
  test.identical( m.scalarsPerElement, 144 );
  test.identical( m.scalarsPerMatrix, 576 );
  test.identical( m.scalarsPerRow, 8 );
  test.identical( m.scalarsPerLayer, 24 );
  test.identical( m.length, 4 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideInRow, 3 );

  var submatrix = m.submatrix( null, null, 0, 0, 0 );
  logger.log( '' );
  logger.log( submatrix.toStr() );

  var exp = _.Matrix
  ({
    buffer :
    [
      +0, +3, +6, +9, +12, +15, +18, +21,
      +1, +4, +7, +10, +13, +16, +19, +22,
      +2, +5, +8, +11, +14, +17, +20, +23,
    ],
    dims : [ 3, 8 ],
    inputRowMajor : 1,
  });
  test.equivalent( submatrix, exp );

  test.identical( submatrix.dims, [ 3, 8, 1, 1, 1 ] );
  test.identical( submatrix.dimsEffective, [ 3, 8 ] );
  test.identical( submatrix.strides, [ 1, 3, 24, 48, 144 ] );
  test.identical( submatrix.stridesEffective, [ 1, 3 ] );
  test.identical( submatrix.scalarsPerCol, 3 );
  test.identical( submatrix.scalarsPerElement, 24 );
  test.identical( submatrix.scalarsPerMatrix, 24 );
  test.identical( submatrix.scalarsPerRow, 8 );
  test.identical( submatrix.scalarsPerLayer, 24 );
  test.identical( submatrix.length, 1 );
  test.identical( submatrix.strideInCol, 1 );
  test.identical( submatrix.strideInRow, 3 );

  /* */

  test.case = 'end';

  var m = new _.Matrix
  ({
    dims : [ 3, 8, 2, 3, 4 ],
    inputRowMajor : 0,
  });
  m.scalarEach( ( it ) =>
  {
    m.scalarSet( it.indexNd, it.indexLogical );
  });
  logger.log( m.toStr() );

  test.identical( m.dims, [ 3, 8, 2, 3, 4 ] );
  test.identical( m.dimsEffective, [ 3, 8, 2, 3, 4 ] );
  test.identical( m.strides, null );
  test.identical( m.stridesEffective, [ 1, 3, 24, 48, 144 ] );
  test.identical( m.scalarsPerCol, 3 );
  test.identical( m.scalarsPerElement, 144 );
  test.identical( m.scalarsPerMatrix, 576 );
  test.identical( m.scalarsPerRow, 8 );
  test.identical( m.scalarsPerLayer, 24 );
  test.identical( m.length, 4 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideInRow, 3 );

  var submatrix = m.submatrix( null, null, 1, 2, 3 );
  logger.log( '' );
  logger.log( submatrix.toStr() );

  var exp = _.Matrix
  ({
    buffer :
    [
      +552, +555, +558, +561, +564, +567, +570, +573,
      +553, +556, +559, +562, +565, +568, +571, +574,
      +554, +557, +560, +563, +566, +569, +572, +575,
    ],
    dims : [ 3, 8 ],
    inputRowMajor : 1,
  });
  test.equivalent( submatrix, exp );

  test.identical( submatrix.dims, [ 3, 8, 1, 1, 1 ] );
  test.identical( submatrix.dimsEffective, [ 3, 8 ] );
  test.identical( submatrix.strides, [ 1, 3, 24, 48, 144 ] );
  test.identical( submatrix.stridesEffective, [ 1, 3 ] );
  test.identical( submatrix.scalarsPerCol, 3 );
  test.identical( submatrix.scalarsPerElement, 24 );
  test.identical( submatrix.scalarsPerMatrix, 24 );
  test.identical( submatrix.scalarsPerRow, 8 );
  test.identical( submatrix.scalarsPerLayer, 24 );
  test.identical( submatrix.length, 1 );
  test.identical( submatrix.strideInCol, 1 );
  test.identical( submatrix.strideInRow, 3 );

  /* */

  test.case = 'unity';

  var m = new _.Matrix
  ({
    dims : [ 3, 8, 1, 1, 1 ],
    inputRowMajor : 0,
  });
  m.scalarEach( ( it ) =>
  {
    m.scalarSet( it.indexNd, it.indexLogical );
  });
  logger.log( m.toStr() );

  test.identical( m.dims, [ 3, 8, 1, 1, 1 ] );
  test.identical( m.dimsEffective, [ 3, 8 ] );
  test.identical( m.strides, null );
  test.identical( m.stridesEffective, [ 1, 3 ] );
  test.identical( m.scalarsPerCol, 3 );
  test.identical( m.scalarsPerElement, 24 );
  test.identical( m.scalarsPerMatrix, 24 );
  test.identical( m.scalarsPerRow, 8 );
  test.identical( m.scalarsPerLayer, 24 );
  test.identical( m.length, 1 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideInRow, 3 );

  var submatrix = m.submatrix( null, null, 0, 0, 0 );
  logger.log( '' );
  logger.log( submatrix.toStr() );

  var exp = _.Matrix
  ({
    buffer :
    [
      +0, +3, +6, +9, +12, +15, +18, +21,
      +1, +4, +7, +10, +13, +16, +19, +22,
      +2, +5, +8, +11, +14, +17, +20, +23,
    ],
    dims : [ 3, 8 ],
    inputRowMajor : 1,
  });
  test.equivalent( submatrix, exp );

  test.identical( submatrix.dims, [ 3, 8, 1, 1, 1 ] );
  test.identical( submatrix.dimsEffective, [ 3, 8 ] );
  test.identical( submatrix.strides, [ 1, 3, 0, 0, 0 ] );
  test.identical( submatrix.stridesEffective, [ 1, 3 ] );
  test.identical( submatrix.scalarsPerCol, 3 );
  test.identical( submatrix.scalarsPerElement, 24 );
  test.identical( submatrix.scalarsPerMatrix, 24 );
  test.identical( submatrix.scalarsPerRow, 8 );
  test.identical( submatrix.scalarsPerLayer, 24 );
  test.identical( submatrix.length, 1 );
  test.identical( submatrix.strideInCol, 1 );
  test.identical( submatrix.strideInRow, 3 );

  /* */

}

//

function subspace( test )
{

  /* */

  test.case = 'inputRowMajor : 1';

  var buffer = [];
  var dims = [ 1, 3, 1, 3, 1, 3 ];
  var inputRowMajor = 1;

  var matrix = _.Matrix({ dims, inputRowMajor }).copy
  ([
    +0, +1, +2,
    +3, +4, +5,
    +6, +7, +8,
    +9, +10, +11,
    +12, +13, +14,
    +15, +16, +17,
    +18, +19, +20,
    +21, +22, +23,
    +24, +25, +26,
  ]);

  console.log( matrix.toStr() );
  console.log( '' );

  var subspace = matrix.subspace( 0, 1, 0, 1, 0, 1 );
  test.is( matrix.buffer === subspace.buffer );
  test.identical( subspace.dims, [ 3, 3, 3 ] );
  test.identical( subspace.stridesEffective, [ 1, 3, 9 ] );

  var exp = _.Matrix.Make([ 3, 3, 3 ]).copy
  ([
    +0, +3, +6,
    +1, +4, +7,
    +2, +5, +8,
    +9, +12, +15,
    +10, +13, +16,
    +11, +14, +17,
    +18, +21, +24,
    +19, +22, +25,
    +20, +23, +26,
  ]);
  test.identical( subspace, exp );

  console.log( subspace.toStr() );
  console.log( '' );

  /* */

}

// --
// operation
// --

function mul( test )
{
  /* data */

  var buffer = new I32x
  ([
    +2, +2, -2,
    -2, -3, +4,
    +4, +3, -2,
  ]);

  var matrix3 = new _.Matrix
  ({
    buffer,
    dims : [ 3, 3 ],
    inputRowMajor : 1,
  });

  var matrix3A = _.Matrix.MakeSquare
  ([
    1, 3, 5,
    2, 4, 6,
    3, 6, 8,
  ]);

  var matrix3B = _.Matrix.MakeSquare
  ([
    1, 2, 3,
    1, 3, 5,
    1, 5, 10,
  ]);

  var colA = _.Matrix.MakeCol([ 1, 2, 3 ]);
  var rowA = _.Matrix.MakeRow([ 1, 2, 3 ]);

  /* tests */

  test.case = 'matrix3 * matrix3';
  var mul = _.Matrix.Mul( null, [ matrix3, matrix3 ] );
  var exp = _.Matrix.MakeSquare( 3 );
  exp.buffer = new I32x
  ([
    -8, +18, -6,
    -8, +17, -7,
    +8, -16, +8
  ]);
  test.equivalent( mul, exp );

  test.case = 'matrix3 * matrix3 * matrix3';
  var mul = _.Matrix.Mul( null, [ matrix3, matrix3, matrix3 ] );
  var exp = _.Matrix.MakeSquare
  ( new I32x([
    +32, +32, -32,
    -62, -63, +64,
    +34, +33, -32,
  ]));
  test.equivalent( mul, exp );

  test.case = 'matrix3A * matrix3B';
  var mul = _.Matrix.Mul( null, [ matrix3A, matrix3B ] );
  var exp = _.Matrix.MakeSquare
  ([
    9,  36, 68,
    12, 46, 86,
    17, 64, 119,
  ]);
  test.equivalent( mul, exp );

  test.case = 'matrix3 * matrix3A * matrix3B';
  var mul = _.Matrix.Mul( null, [ matrix3, matrix3A, matrix3B ] );
  var exp = _.Matrix.MakeSquare
  ([
    +8,  +36,  +70,
    +14, +46,  +82,
    +38, +154, +292,
  ]);
  test.equivalent( mul, exp );

  /* - */

  test.case = 'identity * colA';
  var identity = _.Matrix.MakeIdentity( 3 );
  var mul = _.Matrix.Mul( null, [ identity, colA ] );
  var exp = _.Matrix.MakeCol([ 1, 2, 3 ]);
  test.equivalent( mul, exp );

  test.case = 'rowA * identity';
  var identity = _.Matrix.MakeIdentity( 3 );
  var mul = _.Matrix.Mul( null, [ rowA, identity ] );
  var exp = _.Matrix.MakeRow([ 1, 2, 3 ]);
  test.equivalent( mul, exp );

  test.case = 'matrix3 * colA';
  var mul = _.Matrix.Mul( null, [ matrix3, colA ] );
  var exp = _.Matrix.MakeCol([ 0, 4, 4 ]);
  test.equivalent( mul, exp );

  test.case = 'rowA * matrix3';
  var mul = _.Matrix.Mul( null, [ rowA, matrix3 ] );
  var exp = _.Matrix.MakeRow([ 10, 5, 0 ]);
  exp.buffer = new I32x([ 10, 5, 0 ]);
  test.equivalent( mul, exp );

  /* */

  test.case = 'rowA * colA';
  var mul = _.Matrix.Mul( null, [ rowA, colA ] );
  var exp = _.Matrix.MakeRow([ 14 ]);
  test.equivalent( mul, exp );

  test.case = 'colA * rowA';
  var mul = _.Matrix.Mul( null, [ colA, rowA ] );
  var exp = _.Matrix.MakeSquare
  ([
    1, 2, 3,
    2, 4, 6,
    3, 6, 9,
  ]);
  test.equivalent( mul, exp );

  /* data */

  var matrix3x4 = _.Matrix.Make([ 4, 3 ]).copy
  ([
    +2, +0, +1,
    -1, +1, +0,
    +1, +3, +1,
    -1, +1, +1,
  ]);

  var matrix4x3 = _.Matrix.Make([ 3, 4 ]).copy
  ([
    +2, +1, +2, +1,
    +0, +1, +0, +1,
    +1, +0, +1, +0,
  ]);
  var t1 = matrix3x4.clone().transpose();
  var t2 = matrix4x3.clone().transpose();

  /* */

  test.case = '4x3 * 3x4';
  var exp = _.Matrix.Make([ 4, 4 ]).copy
  ([
    +5, +2, +5, +2,
    -2, +0, -2, +0,
    +3, +4, +3, +4,
    -1, +0, -1, +0,
  ]);

  var mul = _.Matrix.Mul( null, [ matrix3x4, matrix4x3 ] );
  test.equivalent( mul, exp );

  test.case = '3x4 * 4x3';
  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +4, +8, +5,
    -2, +2, +1,
    +3, +3, +2,
  ]);
  var mul = _.Matrix.Mul( null, [ matrix4x3, matrix3x4 ] );
  test.equivalent( mul, exp );

  test.case = '3x4 * 4x3';
  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +4, -2, +3,
    +8, +2, +3,
    +5, +1, +2,
  ]);
  var mul = _.Matrix.Mul( null, [ t1, t2 ] );
  test.equivalent( mul, exp );

  test.case = '4x3 * 4x3t';
  var exp = _.Matrix.Make([ 4, 4 ]).copy
  ([
    +5, -2, +3, -1,
    -2, +2, +2, +2,
    +3, +2, +11, +3,
    -1, +2, +3, +3,
  ]);
  var mul = _.Matrix.Mul( null, [ matrix3x4, t1 ] );
  test.equivalent( mul, exp );

  /* */

  test.case = 'mul itself';
  var m = matrix3B.clone();
  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +6, +23, +43,
    +9, +36, +68,
    +16, +67, +128,
  ]);
  var mul = _.Matrix.Mul( m, [ m, m ] );
  test.equivalent( mul, exp );
  test.is( mul === m );

  test.case = 'mul itself 2 times';
  var m = matrix3B.clone();
  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +72, +296, +563,
    +113, +466, +887,
    +211, +873, +1663,
  ]);
  var mul = _.Matrix.Mul( m, [ m, m, m ] );
  test.equivalent( mul, exp );
  test.is( mul === m );

  test.case = 'mul itself 3 times';
  var m = matrix3B.clone();
  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +931, +3847, +7326,
    +1466, +6059, +11539,
    +2747, +11356, +21628,
  ]);
  var mul = _.Matrix.Mul( m, [ m, m, m, m ] );
  test.equivalent( mul, exp );
  test.is( mul === m );

  test.case = 'mul 3 matrices with dst === src';
  var matrix3x4 = matrix3A.clone();
  var matrix4x3 = matrix3B.clone();
  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +113, +466, +887,
    +144, +592, +1126,
    +200, +821, +1561,
  ]);
  var mul = _.Matrix.Mul( matrix3x4, [ matrix3x4, matrix4x3, matrix4x3 ] );
  test.equivalent( mul, exp );
  test.is( mul === matrix3x4 );

  test.case = 'mul 3 matrices with dst === src';
  var matrix3x4 = matrix3A.clone();
  var matrix4x3 = matrix3B.clone();
  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +113, +466, +887,
    +144, +592, +1126,
    +200, +821, +1561,
  ]);
  var mul = _.Matrix.Mul( matrix4x3, [ matrix3x4, matrix4x3, matrix4x3 ] );
  test.equivalent( mul, exp );
  test.is( mul === matrix4x3 );

  test.case = 'mul 4 matrices with dst === src';
  var matrix3x4 = matrix3A.clone();
  var matrix4x3 = matrix3B.clone();
  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +3706, +7525, +10457,
    +4706, +9556, +13280,
    +6525, +13250, +18414,
  ]);
  var mul = _.Matrix.Mul( matrix3x4, [ matrix3x4, matrix4x3, matrix4x3, matrix3x4 ] );
  test.equivalent( mul, exp );
  test.is( mul === matrix3x4 );

  test.case = 'mul 4 matrices with dst === src';
  var matrix3x4 = matrix3A.clone();
  var matrix4x3 = matrix3B.clone();
  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +3706, +7525, +10457,
    +4706, +9556, +13280,
    +6525, +13250, +18414,
  ]);
  var mul = _.Matrix.Mul( matrix4x3, [ matrix3x4, matrix4x3, matrix4x3, matrix3x4 ] );
  test.equivalent( mul, exp );
  test.is( mul === matrix4x3 );

  test.case = '_.Matrix array multiplication';
  var m = matrix3A.clone();
  var v = [ 1, 2, 3 ];
  var exp = [ 22 , 28 , 39 ];
  var mul = _.Matrix.Mul( v, [ m, v ] );
  test.equivalent( mul, exp );
  test.is( v === mul );

  test.case = '_.Matrix vector multiplication';
  var m = matrix3A.clone();
  var v = _.vad.from([ 1, 2, 3 ]);
  var exp = _.vad.from([ 22 , 28 , 39 ]);
  var mul = _.Matrix.Mul( v, [ m, v ] );
  test.equivalent( mul, exp );
  test.is( v === mul );

  test.case = '_.Matrix array _.Matrix multiplication';
  var m = matrix3A.clone();
  var v = [ 1, 2, 3 ];
  var row = _.Matrix.MakeRow([ 3, 4, 5 ]);
  var exp = [ 8206 , 10444 , 14547 ];
  var mul = _.Matrix.Mul( v, [ m, v, row, m, v ] );
  test.equivalent( mul, exp );
  test.is( v === mul );

  test.case = '_.Matrix array _.Matrix multiplication';
  var m = matrix3A.clone();
  var v = [ 1, 2, 3 ];
  var row = _.Matrix.MakeRow([ 3, 4, 5 ]);
  var exp = [ 82060 , 104440 , 145470 ];
  var mul = _.Matrix.Mul( v, [ m, v, row, m, v, [ 10 ] ] );
  test.equivalent( mul, exp );
  test.is( v === mul );

  /* - */

  if( !Config.debug )
  return;

  /* */

  test.case = 'bad arguments';
  test.shouldThrowErrorSync( () => _.Matrix.Mul( null ) );
  test.shouldThrowErrorSync( () => _.Matrix.Mul( null, null ) );
  test.shouldThrowErrorSync( () => _.Matrix.Mul( null, [] ) );
  test.shouldThrowErrorSync( () => _.Matrix.Mul( null, [ _.Matrix.Make([ 3, 3 ]) ] ) );
  test.shouldThrowErrorSync( () => _.Matrix.Mul( null, [ _.Matrix.Make([ 3, 3 ]), _.Matrix.Make([ 1, 4 ]) ] ) );
  test.shouldThrowErrorSync( () => _.Matrix.Mul( null, [ _.Matrix.Make([ 4, 1 ]), _.Matrix.Make([ 3, 3 ]) ] ) );

}

//

function MulBasic( test )
{

  /* */

  test.case = 'matrix1 mul matrix2';
  var matrix1 = _.Matrix.Make([ 3, 2 ]).copy
  ([
     1,  4,
    -2, -5,
     3,  6,
  ]);
  var matrix2 = _.Matrix.Make([ 2, 3 ]).copy
  ([
     10, -20, 30,
     40, -50, 60,
  ]);
  var got = _.Matrix.Mul( null, [ matrix1, matrix2 ] );
  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +170, -220, +270,
    -220, +290, -360,
    +270, -360, +450,
  ]);
  test.identical( got, exp );
  var original = _.Matrix.Make([ 3, 2 ]).copy
  ([
     1,  4,
    -2, -5,
     3,  6,
  ]);
  test.identical( matrix1, original );
  var original = _.Matrix.Make([ 2, 3 ]).copy
  ([
     10, -20, 30,
     40, -50, 60,
  ]);
  test.identical( matrix2, original );

  /* */

  test.case = 'empty matrix1 mul empty matrix2';
  var matrix1 = _.Matrix.Make([ 0, 2 ]).copy
  ([
  ]);
  var matrix2 = _.Matrix.Make([ 2, 0 ]).copy
  ([
  ]);
  var got = _.Matrix.Mul( null, [ matrix1, matrix2 ] );
  var exp = _.Matrix.Make([ 0, 0 ]).copy
  ([
  ]);
  test.identical( got, exp );
  var original = _.Matrix.Make([ 0, 2 ]).copy
  ([
  ]);
  test.identical( matrix1, original );
  var original = _.Matrix.Make([ 2, 0 ]).copy
  ([
  ]);
  test.identical( matrix2, original );

  /* */

  test.case = 'matrix mul scalar';
  var matrix = _.Matrix.Make([ 3, 2 ]).copy
  ([
     1,  4,
    -2, -5,
     3,  6,
  ]);
  console.log( matrix.toStr() );
  var got = _.Matrix.Mul( null, [ matrix, 2 ] );
  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
     2,  8,
    -4, -10,
     6,  12,
  ]);
  test.identical( got, exp );
  var original = _.Matrix.Make([ 3, 2 ]).copy
  ([
     1,  4,
    -2, -5,
     3,  6,
  ]);
  test.identical( matrix, original );

  /* */

  test.case = 'scalar mul matrix';
  var matrix = _.Matrix.Make([ 3, 2 ]).copy
  ([
     1,  4,
    -2, -5,
     3,  6,
  ]);
  console.log( matrix.toStr() );
  var got = _.Matrix.Mul( null, [ 2, matrix ] );
  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
     2,  8,
    -4, -10,
     6,  12,
  ]);
  test.identical( got, exp );
  test.identical( got, exp );
  var original = _.Matrix.Make([ 3, 2 ]).copy
  ([
     1,  4,
    -2, -5,
     3,  6,
  ]);
  test.identical( matrix, original );

  /* */

  test.case = 'matrix mul vector';
  var matrix = _.Matrix.Make([ 3, 2 ]).copy
  ([
     1,  4,
    -2, -5,
     3,  6,
  ]);
  console.log( matrix.toStr() );
  var vector = new F32x([ 1, 2 ]);
  var got = _.Matrix.Mul( null, [ matrix, vector ] );
  var exp = new F32x
  ([
     9,
    -12,
     15,
  ]);
  test.identical( got, exp );
  var original = _.Matrix.Make([ 3, 2 ]).copy
  ([
     1,  4,
    -2, -5,
     3,  6,
  ]);
  test.identical( matrix, original );
  var original = new F32x([ 1, 2 ]);
  test.identical( vector, original );

  /* */

  test.case = 'vector mul matrix';
  var matrix = _.Matrix.Make([ 1, 2 ]).copy
  ([
     1,  2,
  ]);
  console.log( matrix.toStr() );
  var vector = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix.Mul( null, [ vector, matrix ] );
  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
     1, 2,
     2, 4,
     3, 6,
  ]);
  test.identical( got, exp );
  var original = _.Matrix.Make([ 1, 2 ]).copy
  ([
     1,  2,
  ]);
  test.identical( matrix, original );
  var original = new F32x([ 1, 2, 3 ]);
  test.identical( vector, original );

  /* */

  test.case = 'vector mul vector';
  var vector1 = new F32x([ 1, 2, 3 ]);
  var vector2 = new F32x([ 2 ]);
  var got = _.Matrix.Mul( null, [ vector1, vector2 ] );
  var exp = new F32x
  ([
     2,
     4,
     6,
  ]);
  test.identical( got, exp );
  var original = new F32x([ 1, 2, 3 ]);
  test.identical( vector1, original );
  var original = new F32x([ 2 ]);
  test.identical( vector2, original );

  /* */

  test.case = 'vector mul scalar';
  var vector = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix.Mul( null, [ vector, 2 ] );
  var exp = _.Matrix.Make([ 3, 1 ]).copy
  ([
     2,
     4,
     6,
  ]);
  test.identical( got, exp );
  var original = new F32x([ 1, 2, 3 ]);
  test.identical( vector, original );

  /* */

  test.case = 'scalar mul vector';
  var vector = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix.Mul( null, [ 2, vector ] );
  var exp = new F32x
  ([
     2,
     4,
     6,
  ]);
  test.identical( got, exp );
  var original = new F32x([ 1, 2, 3 ]);
  test.identical( vector, original );

  /* */

  test.case = 'scalar mul scalar';
  var got = _.Matrix.Mul( null, [ 2, 3 ] );
  var exp = _.Matrix.Make([ 1, 1 ]).copy
  ([
     6
  ]);
  test.identical( got, exp );

  /* */

}

//

function MulSubmatirices( test )
{

  var matrix = _.Matrix
  ({
    buffer : new F32x([ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]),
    strides : [ 3, 1 ],
    dims : [ 3, 3 ],
  });

  var sub1 = matrix.submatrix( [ 0, 1 ], [ 0, 1 ] );
  sub1.mul( [ sub1, 2 ] );

  var exp = _.Matrix.MakeSquare
  ([
    2, 4,
    8, 10
  ]);

  test.equivalent( sub1, exp );

}

//

function MulSeveral( test )
{

  /**/

  test.case = 'mul several matrices with different dimensions';
  var matrix1 = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, -3,
    3, 4, -2,
  ]);
  var matrix2 = _.Matrix.Make([ 3, 2 ]).copy
  ([
    4,  3,
    2,  1,
    -1, -2,
  ]);
  var matrix3 = _.Matrix.Make([ 2, 1 ]).copy
  ([
    -4,
    5,
  ]);

  var got = _.Matrix.Mul( null, [ matrix1, matrix2, matrix3 ] );
  var exp = _.Matrix.MakeCol
  ([
    11,
    -3
  ]);
  test.equivalent( got, exp );

  /**/

}

//

function AddBasic( test )
{

  /* */

  test.case = 'matrix mul matrix';
  var matrix1 = _.Matrix.Make([ 3, 2 ]).copy
  ([
     1,  4,
    -2, -5,
     3,  6,
  ]);
  var matrix2 = _.Matrix.Make([ 3, 2 ]).copy
  ([
     10,  40,
    -20, -50,
     30,  60,
  ]);
  var got = _.Matrix.Add( null, [ matrix1, matrix2 ] );
  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
     11,  44,
    -22, -55,
     33,  66,
  ]);
  test.identical( got, exp );
  var original = _.Matrix.Make([ 3, 2 ]).copy
  ([
     1,  4,
    -2, -5,
     3,  6,
  ]);
  test.identical( matrix1, original );
  var original = _.Matrix.Make([ 3, 2 ]).copy
  ([
     10,  40,
    -20, -50,
     30,  60,
  ]);
  test.identical( matrix2, original );

  /* */

  test.case = 'empty matrix1 add empty matrix2';
  var matrix1 = _.Matrix.Make([ 0, 0 ]).copy
  ([
  ]);
  var matrix2 = _.Matrix.Make([ 0, 0 ]).copy
  ([
  ]);
  var got = _.Matrix.Add( null, [ matrix1, matrix2 ] );
  var exp = _.Matrix.Make([ 0, 0 ]).copy
  ([
  ]);
  test.identical( got, exp );
  var original = _.Matrix.Make([ 0, 0 ]).copy
  ([
  ]);
  test.identical( matrix1, original );
  var original = _.Matrix.Make([ 0, 0 ]).copy
  ([
  ]);
  test.identical( matrix2, original );

  /* */

  test.case = 'matrix add scalar';
  var matrix = _.Matrix.Make([ 3, 2 ]).copy
  ([
     1,  4,
    -2, -5,
     3,  6,
  ]);
  console.log( matrix.toStr() );
  var got = _.Matrix.Add( null, [ matrix, 2 ] );
  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
     3,  6,
     0, -3,
     5,  8,
  ]);
  test.identical( got, exp );
  var original = _.Matrix.Make([ 3, 2 ]).copy
  ([
     1,  4,
    -2, -5,
     3,  6,
  ]);
  test.identical( matrix, original );

  /* */

  test.case = 'scalar add matrix';
  var matrix = _.Matrix.Make([ 3, 2 ]).copy
  ([
     1,  4,
    -2, -5,
     3,  6,
  ]);
  console.log( matrix.toStr() );
  var got = _.Matrix.Add( null, [ 2, matrix ] );
  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
     3,  6,
     0, -3,
     5,  8,
  ]);
  test.identical( got, exp );
  test.identical( got, exp );
  var original = _.Matrix.Make([ 3, 2 ]).copy
  ([
     1,  4,
    -2, -5,
     3,  6,
  ]);
  test.identical( matrix, original );

  /* */

  test.case = 'matrix add vector';
  var matrix = _.Matrix.Make([ 3, 1 ]).copy
  ([
     1,
    -2,
     3,
  ]);
  console.log( matrix.toStr() );
  var vector = new F32x([ 3, 4, 5 ]);
  var got = _.Matrix.Add( null, [ matrix, vector ] );
  var exp = new F32x
  ([
     4,
     2,
     8,
  ]);
  test.identical( got, exp );
  var original = _.Matrix.Make([ 3, 1 ]).copy
  ([
     1,
    -2,
     3,
  ]);
  test.identical( matrix, original );
  var original = new F32x([ 3, 4, 5 ]);
  test.identical( vector, original );

  /* */

  test.case = 'vector add matrix';
  var matrix = _.Matrix.Make([ 3, 1 ]).copy
  ([
     1,
    -2,
     3,
  ]);
  console.log( matrix.toStr() );
  var vector = new F32x([ 3, 4, 5 ]);
  var got = _.Matrix.Add( null, [ vector, matrix ] );
  var exp = _.Matrix.Make([ 3, 1 ]).copy
  ([
     4,
     2,
     8,
  ]);
  test.identical( got, exp );
  var original = _.Matrix.Make([ 3, 1 ]).copy
  ([
     1,
    -2,
     3,
  ]);
  test.identical( matrix, original );
  var original = new F32x([ 3, 4, 5 ]);
  test.identical( vector, original );

  /* */

  test.case = 'vector add vector';
  var vector1 = new F32x([ 1, 2, 3 ]);
  var vector2 = new F32x([ 2, 3, 4 ]);
  var got = _.Matrix.Add( null, [ vector1, vector2 ] );
  var exp = new F32x
  ([
     3,
     5,
     7,
  ]);
  test.identical( got, exp );
  var original = new F32x([ 1, 2, 3 ]);
  test.identical( vector1, original );
  var original = new F32x([ 2, 3, 4 ]);
  test.identical( vector2, original );

  /* */

  test.case = 'vector add scalar';
  var vector = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix.Add( null, [ vector, 2 ] );
  var exp = _.Matrix.Make([ 3, 1 ]).copy
  ([
     3,
     4,
     5,
  ]);
  test.identical( got, exp );
  var original = new F32x([ 1, 2, 3 ]);
  test.identical( vector, original );

  /* */

  test.case = 'scalar add vector';
  var vector = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix.Add( null, [ 2, vector ] );
  var exp = new F32x
  ([
     3,
     4,
     5,
  ]);
  test.identical( got, exp );
  var original = new F32x([ 1, 2, 3 ]);
  test.identical( vector, original );

  /* */

  test.case = 'scalar add scalar';
  var got = _.Matrix.Add( null, [ 2, 3 ] );
  var exp = _.Matrix.Make([ 1, 1 ]).copy
  ([
     5
  ]);
  test.identical( got, exp );

  /* */

}

//

function addScalarWise( test )
{

  var m1, m2, m3, m4, m5, v1, a1; /* qqq : split variables */
  function remake() /* qqq : remove subroutine */
  {

    m1 = _.Matrix.Make([ 2, 3 ]).copy
    ([
      +1, +2, +3,
      +4, +5, +6,
    ]);

    m2 = _.Matrix.Make([ 2, 3 ]).copy
    ([
      +10, +20, +30,
      +40, +50, +60,
    ]);

    m3 = _.Matrix.Make([ 2, 3 ]).copy
    ([
      +100, +200, +300,
      +400, +500, +600,
    ]);

    m4 = _.Matrix.Make([ 2, 1 ]).copy
    ([
      1,
      2,
    ]);

    m5 = _.Matrix.Make([ 2, 1 ]).copy
    ([
      3,
      4,
    ]);

    v1 = _.vad.fromLong([ 9, 8 ]);
    a1 = [ 6, 5 ];

  }

  /* */

  test.case = 'addScalarWise 2 matrixs';

  remake();

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    +11, +22, +33,
    +44, +55, +66,
  ]);

  var r = _.Matrix.addScalarWise( m1, m2 );
  test.equivalent( r, exp );
  test.is( r === m1 );

  /* */

  test.case = 'addScalarWise 2 matrixs with null';

  remake();

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    +11, +22, +33,
    +44, +55, +66,
  ]);

  var r = _.Matrix.addScalarWise( null, m1, m2 );
  test.equivalent( r, exp );
  test.is( r !== m1 );

  /* */

  test.case = 'addScalarWise 3 matrixs into the first src';

  remake();

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    +111, +222, +333,
    +444, +555, +666,
  ]);

  var r = _.Matrix.addScalarWise( null, m1, m2, m3 );
  test.equivalent( r, exp );
  test.is( r !== m1 );

  /* */

  test.case = 'addScalarWise 3 matrixs into the first src';

  remake();

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    +111, +222, +333,
    +444, +555, +666,
  ]);

  var r = _.Matrix.addScalarWise( m1, m2, m3 );
  test.equivalent( r, exp );
  test.is( r === m1 );

  /* */

  test.case = 'addScalarWise matrix and scalar';

  remake();

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    +11, +12, +13,
    +14, +15, +16,
  ]);

  var r = _.Matrix.addScalarWise( null, m1, 10 );
  test.equivalent( r, exp );
  test.is( r !== m1 );

  /* */

  test.case = 'addScalarWise _.all sort of arguments';

  remake();

  var exp = _.Matrix.Make([ 2, 1 ]).copy
  ([
    13,
    14,
  ]);

  var r = _.Matrix.addScalarWise( null, m5, 10 );
  test.equivalent( r, exp );
  test.is( r !== m5 );

  var exp = _.Matrix.Make([ 2, 1 ]).copy
  ([
    22,
    22,
  ]);

  var r = _.Matrix.addScalarWise( null, m5, 10, v1 );
  test.equivalent( r, exp );
  test.is( r !== m5 );

  var exp = _.Matrix.Make([ 2, 1 ]).copy
  ([
    28,
    27,
  ]);

  var r = _.Matrix.addScalarWise( null, m5, 10, v1, a1 );
  test.equivalent( r, exp );
  test.is( r !== m5 );

  /* */

  test.case = 'addScalarWise _.all sort of arguments';

  remake();

  var exp = _.Matrix.Make([ 2, 1 ]).copy
  ([
    22,
    22,
  ]);

  var r = _.Matrix.addScalarWise( m5, 10, v1 );
  test.equivalent( r, exp );
  test.is( r === m5 );

  remake();

  var exp = _.Matrix.Make([ 2, 1 ]).copy
  ([
    28,
    27,
  ]);

  var r = _.Matrix.addScalarWise( m5, 10, v1, a1 );
  test.equivalent( r, exp );
  test.is( r === m5 );

  remake();

  var exp = _.Matrix.Make([ 2, 1 ]).copy
  ([
    29,
    29,
  ]);

  var r = _.Matrix.addScalarWise( m5, 10, v1, a1, m4 );
  test.equivalent( r, exp );
  test.is( r === m5 );

  /* */

  test.case = 'addScalarWise rewriting src argument';

  remake();

  var exp = _.Matrix.Make([ 2, 1 ]).copy
  ([
    27,
    27,
  ]);

  var r = _.Matrix.addScalarWise( m4, 10, v1, a1, m4 );
  test.equivalent( r, exp );
  test.is( r === m4 );

  /* */

}

//

function subScalarWise( test )
{

  var m1, m2, m3, m4, m5, v1, a1;
  function remake()
  {

    m1 = _.Matrix.Make([ 2, 3 ]).copy
    ([
      +1, +2, +3,
      +4, +5, +6,
    ]);

    m2 = _.Matrix.Make([ 2, 3 ]).copy
    ([
      +10, +20, +30,
      +40, +50, +60,
    ]);

    m3 = _.Matrix.Make([ 2, 3 ]).copy
    ([
      +100, +200, +300,
      +400, +500, +600,
    ]);

    m4 = _.Matrix.Make([ 2, 1 ]).copy
    ([
      1,
      2,
    ]);

    m5 = _.Matrix.Make([ 2, 1 ]).copy
    ([
      3,
      4,
    ]);

    v1 = _.vad.fromLong([ 9, 8 ]);
    a1 = [ 6, 5 ];

  }

  /* */

  test.case = '2 matrixs';

  remake();

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    -9, -18, -27,
    -36, -45, -54,
  ]);

  var r = _.Matrix.subScalarWise( m1, m2 );
  test.equivalent( r, exp );
  test.is( r === m1 );

  /* */

  test.case = '2 matrixs with null';

  remake();

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    -9, -18, -27,
    -36, -45, -54,
  ]);

  var r = _.Matrix.subScalarWise( null, m1, m2 );
  test.equivalent( r, exp );
  test.is( r !== m1 );

  /* */

  test.case = '3 matrixs into the first src';

  remake();

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    -109, -218, -327,
    -436, -545, -654,
  ]);

  var r = _.Matrix.subScalarWise( null, m1, m2, m3 );
  test.equivalent( r, exp );
  test.is( r !== m1 );

  /* */

  test.case = '3 matrixs into the first src';

  remake();

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    -109, -218, -327,
    -436, -545, -654,
  ]);

  var r = _.Matrix.subScalarWise( m1, m2, m3 );
  test.equivalent( r, exp );
  test.is( r === m1 );

  /* */

  test.case = 'matrix and scalar';

  remake();

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    -9, -8, -7,
    -6, -5, -4,
  ]);

  var r = _.Matrix.subScalarWise( null, m1, 10 );
  test.equivalent( r, exp );
  test.is( r !== m1 );

  /* */

  test.case = '_.all sort of arguments';

  remake();

  var exp = _.Matrix.Make([ 2, 1 ]).copy
  ([
    -7,
    -6,
  ]);

  var r = _.Matrix.subScalarWise( null, m5, 10 );
  test.equivalent( r, exp );
  test.is( r !== m5 );

  var exp = _.Matrix.Make([ 2, 1 ]).copy
  ([
    -16,
    -14,
  ]);

  var r = _.Matrix.subScalarWise( null, m5, 10, v1 );
  test.equivalent( r, exp );
  test.is( r !== m5 );

  var exp = _.Matrix.Make([ 2, 1 ]).copy
  ([
    -22,
    -19,
  ]);

  var r = _.Matrix.subScalarWise( null, m5, 10, v1, a1 );
  test.equivalent( r, exp );
  test.is( r !== m5 );

  /* */

  test.case = '_.all sort of arguments';

  remake();

  var exp = _.Matrix.Make([ 2, 1 ]).copy
  ([
    -16,
    -14,
  ]);

  var r = _.Matrix.subScalarWise( m5, 10, v1 );
  test.equivalent( r, exp );
  test.is( r === m5 );

  remake();

  var exp = _.Matrix.Make([ 2, 1 ]).copy
  ([
    -22,
    -19,
  ]);

  var r = _.Matrix.subScalarWise( m5, 10, v1, a1 );
  test.equivalent( r, exp );
  test.is( r === m5 );

  remake();

  var exp = _.Matrix.Make([ 2, 1 ]).copy
  ([
    -23,
    -21,
  ]);

  var r = _.Matrix.subScalarWise( m5, 10, v1, a1, m4 );
  test.equivalent( r, exp );
  test.is( r === m5 );

  /* */

  test.case = 'rewriting src argument';

  remake();

  var exp = _.Matrix.Make([ 2, 1 ]).copy
  ([
    -25,
    -23,
  ]);

  var r = _.Matrix.subScalarWise( m4, 10, v1, a1, m4 );
  test.equivalent( r, exp );
  test.is( r === m4 );

}

function reduceToMeanRowWise( test )
{

  /* */

  test.case = 'no dst';
  var m1 = _.Matrix.Make([ 3, 2 ]).copy
  ([
     1,  4,
     2,  5,
     3,  6,
  ]);
  var got = m1.reduceToMeanRowWise();
  test.identical( got, _.vad.from([ 2.5, 3.5, 4.5 ]) );

  /* */

  test.case = 'dst';
  var m1 = _.Matrix.Make([ 3, 2 ]).copy
  ([
     1,  4,
     2,  5,
     3,  6,
  ]);
  var dst = [ 1, 1, 1 ];
  var got = m1.reduceToMeanRowWise( dst );
  test.identical( dst, [ 2.5, 3.5, 4.5 ] );
  test.identical( got, _.vad.from([ 2.5, 3.5, 4.5 ]) );
  test.is( got._vectorBuffer === dst );

  /* */

  test.case = 'control mulRowWise';
  var m1 = _.Matrix.Make([ 3, 2 ]).copy
  ([
     1,  4,
     2,  5,
     3,  6,
  ]);
  var x = [ 1, 3 ];
  m1.mulRowWise( x );
  var exp = _.Matrix.Make([ 3, 2 ]).copy
  ([
     1,  12,
     2,  15,
     3,  18,
  ]);
  test.identical( m1, exp );

  /* */

  test.case = 'control distributionRangeSummaryValueRowWise';
  var m1 = _.Matrix.Make([ 3, 2 ]).copy
  ([
     1,  4,
     2,  5,
     3,  6,
  ]);

  var exp =
  [
    [ 1, 4 ],
    [ 2, 5 ],
    [ 3, 6 ],
  ]
  var got = m1.distributionRangeSummaryValueRowWise();
  test.identical( got, exp );

  /* */

}

//

function colRowWiseOperations( test )  /* qqq2 : split test routine appropriately and extend each */
{

  /* */

  test.case = 'data';

  var buffer = new I32x
  ([
    1, 2, 3, 4, 5, 6
  ]);

  var m32 = new _.Matrix
  ({
    buffer,
    dims : [ 3, 2 ],
    inputRowMajor : 0,
  });

  var empty1 = _.Matrix.Make([ 2, 0 ]);
  empty1.buffer = new F64x();
  test.identical( empty1.dims, [ 2, 0 ] );
  test.identical( empty1.stridesEffective, [ 1, 2 ] );

  var empty2 = _.Matrix.Make([ 0, 2 ]);
  test.identical( empty2.dims, [ 0, 2 ] );
  test.identical( empty2.stridesEffective, [ 1, 0 ] );
  empty2.buffer = new F64x();
  test.identical( empty2.dims, [ 0, 2 ] );
  test.identical( empty2.stridesEffective, [ 1, 0 ] );

  var matrix1 = new _.Matrix
  ({
    dims : [ 4, 3 ],
    inputRowMajor : 1,
    buffer : new F64x
    ([
      0, 0, 0,
      1, 2, 3,
      10, 20, 30,
      1, 111, 11,
    ]),
  });

  var matrix2 = new _.Matrix
  ({
    dims : [ 4, 3 ],
    inputRowMajor : 1,
    buffer : new F64x
    ([
      10, 0, 3,
      1, 20, 0,
      0, 2, 30,
      5, 10, 20,
    ]),
  });

  matrix2.bufferNormalize();

  /* */

  test.case = 'reduceToMean';

  var c = m32.reduceToMeanRowWise();
  var r = m32.reduceToMeanColWise();
  var a = m32.reduceToMeanScalarWise();

  test.identical( c, _.vad.from([ 2.5, 3.5, 4.5 ]) );
  test.identical( r, _.vad.from([ 2, 5 ]) );
  test.identical( a, 3.5 );

  /* */

  test.case = 'reduceToMean with output argument';

  var c2 = [ 1, 1, 1 ];
  var r2 = [ 1 ];
  m32.reduceToMeanRowWise( c2 );
  m32.reduceToMeanColWise( r2 );

  test.identical( c, _.vad.from( c2 ) );
  test.identical( r, _.vad.from( r2 ) );

  /* */

  test.case = 'reduceToMean with empty matrixs';

  var c = empty1.reduceToMeanRowWise();
  var r = empty1.reduceToMeanColWise();
  var a = empty1.reduceToMeanScalarWise();

  test.identical( c, _.vad.from([ NaN, NaN ]) );
  test.identical( r, _.vad.from([]) );
  test.identical( a, NaN );

  /* */

  test.case = 'reduceToMean bad arguments';

  function simpleShouldThrowError( f )
  {
    test.shouldThrowErrorSync( () => m[ f ]( 1 ) );
    test.shouldThrowErrorSync( () => m[ f ]( null ) );
    test.shouldThrowErrorSync( () => m[ f ]( 'x' ) );
    test.shouldThrowErrorSync( () => m[ f ]( [], 1 ) );
    test.shouldThrowErrorSync( () => m[ f ]( [], [] ) );
    test.shouldThrowErrorSync( () => m[ f ]( matrix1.clone() ) );
  }

  if( Config.debug )
  {

    simpleShouldThrowError( 'reduceToMeanRowWise' );
    simpleShouldThrowError( 'reduceToMeanColWise' );
    simpleShouldThrowError( 'reduceToMeanScalarWise' );

  }

  /* */

  test.case = 'distributionRangeSummaryColWise';

  var exp =
  [
    {
      min : { value : 0, index : 0 },
      max : { value : 10, index : 2 },
    },
    {
      min : { value : 0, index : 0 },
      max : { value : 111, index : 3 },
    },
    {
      min : { value : 0, index : 0 },
      max : { value : 30, index : 2 },
    },
  ]

  var r = matrix1.distributionRangeSummaryColWise();
  test.contains( r, exp );

  var exp =
  [
  ]

  var r = empty1.distributionRangeSummaryColWise();
  test.identical( r, exp );

  var exp =
  [
    {
      min : { value : NaN, index : -1, container : null },
      max : { value : NaN, index : -1, container : null },
      median : NaN,
    },
    {
      min : { value : NaN, index : -1, container : null },
      max : { value : NaN, index : -1, container : null },
      median : NaN,
    },
  ]

  var r = empty2.distributionRangeSummaryColWise();
  test.identical( r, exp );

  /* */

  test.case = 'minmaxColWise';

  var exp =
  {
    min : new F64x([ 0, 0, 0 ]),
    max : new F64x([ 10, 111, 30 ]),
  }
  var r = matrix1.minmaxColWise();
  test.identical( r, exp );

  var exp =
  {
    min : new F64x([]),
    max : new F64x([]),
  }

  var r = empty1.minmaxColWise();
  test.identical( r, exp );

  var exp =
  {
    min : new F64x([ NaN, NaN ]),
    max : new F64x([ NaN, NaN ]),
  }

  var r = empty2.minmaxColWise();
  var identical = _.entityIdentical( r, exp );
  test.identical( r, exp );

  /* */

  test.case = 'distributionRangeSummaryRowWise';

  var exp =
  [
    {
      min : { value : 0, index : 0 },
      max : { value : 0, index : 0 },
    },
    {
      min : { value : 1, index : 0 },
      max : { value : 3, index : 2 },
    },
    {
      min : { value : 10, index : 0 },
      max : { value : 30, index : 2 },
    },
    {
      min : { value : 1, index : 0 },
      max : { value : 111, index : 1 },
    },
  ]

  var r = matrix1.distributionRangeSummaryRowWise();
  test.contains( r, exp );

  var exp =
  [
    {
      min : { value : NaN, index : -1, container : null },
      max : { value : NaN, index : -1, container : null },
      median : NaN,
    },
    {
      min : { value : NaN, index : -1, container : null },
      max : { value : NaN, index : -1, container : null },
      median : NaN,
    },
  ]

  var r = empty1.distributionRangeSummaryRowWise();
  test.identical( r, exp );

  var exp =
  [
  ]

  var r = empty2.distributionRangeSummaryRowWise();
  test.identical( r, exp );

  /* */

  test.case = 'minmaxRowWise';

  var exp =
  {
    min : new F64x([ 0, 1, 10, 1 ]),
    max : new F64x([ 0, 3, 30, 111 ]),
  }
  var r = matrix1.minmaxRowWise();
  test.identical( r, exp );

  var exp =
  {
    min : new F64x([ NaN, NaN ]),
    max : new F64x([ NaN, NaN ]),
  }

  var r = empty1.minmaxRowWise();
  test.identical( r, exp );

  var exp =
  {
    min : new F64x([]),
    max : new F64x([]),
  }

  var r = empty2.minmaxRowWise();
  test.identical( r, exp );

  /* */

  test.case = 'reduceToSumColWise';

  var sum = matrix1.reduceToSumColWise();
  test.identical( sum, _.vad.from([ 12, 133, 44 ]) );
  var sum = matrix2.reduceToSumColWise();
  test.identical( sum, _.vad.from([ 16, 32, 53 ]) );
  var sum = empty1.reduceToSumColWise();
  test.identical( sum, _.vad.from([]) );
  var sum = empty2.reduceToSumColWise();
  test.identical( sum, _.vad.from([ 0, 0 ]) );

  /* */

  test.case = 'reduceToSumRowWise';

  var sum = matrix1.reduceToSumRowWise();
  test.identical( sum, _.vad.from([ 0, 6, 60, 123 ]) );
  var sum = matrix2.reduceToSumRowWise();
  test.identical( sum, _.vad.from([ 13, 21, 32, 35 ]) );
  var sum = empty1.reduceToSumRowWise();
  test.identical( sum, _.vad.from([ 0, 0 ]) );
  var sum = empty2.reduceToSumRowWise();
  test.identical( sum, _.vad.from([]) );

  /* */

  test.case = 'reduceToMaxColWise';

  var max = matrix1.reduceToMaxColWise();
  max = _.select( max, '*/value' );
  test.identical( max, [ 10, 111, 30 ] );
  var max = matrix2.reduceToMaxColWise();
  max = _.select( max, '*/value' );
  test.identical( max, [ 10, 20, 30 ] );

  var max = empty1.reduceToMaxColWise();
  max = _.select( max, '*/value' );
  test.identical( max, [] );
  var max = empty2.reduceToMaxColWise();
  max = _.select( max, '*/value' );
  test.identical( max, [ -Infinity, -Infinity ] );

  /* */

  test.case = 'reduceToMaxValueColWise';

  var max = matrix1.reduceToMaxValueColWise();
  test.identical( max, _.vad.from([ 10, 111, 30 ]) );
  var max = matrix2.reduceToMaxValueColWise();
  test.identical( max, _.vad.from([ 10, 20, 30 ]) );
  var max = empty1.reduceToMaxValueColWise();
  test.identical( max, _.vad.from([]) );
  var max = empty2.reduceToMaxValueColWise();
  test.identical( max, _.vad.from([ -Infinity, -Infinity ]) );

  /* */

  test.case = 'reduceToMaxRowWise';

  var max = matrix1.reduceToMaxRowWise();
  max = _.select( max, '*/value' );
  test.identical( max, [ 0, 3, 30, 111 ] );
  var max = matrix2.reduceToMaxRowWise();
  max = _.select( max, '*/value' );
  test.identical( max, [ 10, 20, 30, 20 ] );

  var max = empty1.reduceToMaxRowWise();
  max = _.select( max, '*/value' );
  test.identical( max, [ -Infinity, -Infinity ] );
  var max = empty2.reduceToMaxRowWise();
  max = _.select( max, '*/value' );
  test.identical( max, [] );

  /* */

  test.case = 'reduceToMaxValueRowWise';

  var max = matrix1.reduceToMaxValueRowWise();
  test.identical( max, _.vad.from([ 0, 3, 30, 111 ]) );
  var max = matrix2.reduceToMaxValueRowWise();
  test.identical( max, _.vad.from([ 10, 20, 30, 20 ]) );
  var max = empty1.reduceToMaxValueRowWise();
  test.identical( max, _.vad.from([ -Infinity, -Infinity ]) );
  var max = empty2.reduceToMaxValueRowWise();
  test.identical( max, _.vad.from([]) );

/*
  var matrix1 = _.Matrix.Make([ 4, 3 ])
  .copy
  ( new F64x([
    0, 0, 0,
    1, 2, 3,
    10, 20, 30,
    1, 111, 11,
  ]));

  var matrix2 = _.Matrix.Make([ 4, 3 ])
  .copy
  ( new F64x([
    10, 0, 3,
    1, 20, 0,
    0, 2, 30,
    5, 10, 20,
  ]));
*/

}

//

function mulColWise( test )
{

  /* */

  test.case = 'basic';

  var x = [ 1, 3 ];
  var m = _.Matrix.Make([ 2, 4 ]).copy
  ([
    1, 2, 3, 4,
    5, 6, 7, 8,
  ]);

  m.mulColWise( x );

  var exp = [ 1, 3 ];
  test.identical( x, exp );

  var exp = _.Matrix.Make([ 2, 4 ]).copy
  ([
    1, 2, 3, 4,
    15, 18, 21, 24,
  ]);
  test.identical( m, exp );

  /* */

}

//

function mulRowWise( test )
{

  /* */

  test.case = 'basic';

  var x = [ 0, 1, 2, 3 ];
  var m = _.Matrix.Make([ 2, 4 ]).copy
  ([
    1, 2, 3, 4,
    5, 6, 7, 8,
  ]);

  m.mulRowWise( x );

  var exp = [ 0, 1, 2, 3 ];
  test.identical( x, exp );

  var exp = _.Matrix.Make([ 2, 4 ]).copy
  ([
    0, 2, 6, 12,
    0, 6, 14, 24,
  ]);
  test.identical( m, exp );

  /* */

}

//

function mulScalarWise( test )
{

  /* */

  test.case = 'basic';

  var x = 2;
  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  m.mulScalarWise( x );

  var exp = _.Matrix.Make([ 2, 3 ]).copy
  ([
    2, 4, 6,
    8, 10, 12,
  ]);
  test.identical( m, exp );

  /* */

}

//

function furthestClosest( test )
{

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  /* */

  test.case = 'simplest furthest';

  var exp = { index : 2, distance : sqrt( sqr( 3 ) + sqr( 6 ) ) };
  var got = m.furthest([ 0, 0 ]);
  test.equivalent( got, exp );

  var exp = { index : 0, distance : sqrt( sqr( 9 ) + sqr( 6 ) ) };
  var got = m.furthest([ 10, 10 ]);
  test.equivalent( got, exp );

  var exp = { index : 2, distance : 3 };
  var got = m.furthest([ 3, 3 ]);
  test.equivalent( got, exp );

  var exp = { index : 0, distance : sqrt( 2 ) };
  var got = m.furthest([ 2, 5 ]);
  test.equivalent( got, exp );

  /* */

  test.case = 'simplest closest';

  var exp = { index : 0, distance : sqrt( sqr( 1 ) + sqr( 4 ) ) };
  var got = m.closest([ 0, 0 ]);
  test.equivalent( got, exp );

  var exp = { index : 2, distance : sqrt( sqr( 7 ) + sqr( 4 ) ) };
  var got = m.closest([ 10, 10 ]);
  test.equivalent( got, exp );

  var exp = { index : 0, distance : sqrt( 1 + sqr( 2 ) ) };
  var got = m.closest([ 3, 3 ]);
  test.equivalent( got, exp );

  var exp = { index : 1, distance : sqrt( 2 ) };
  var got = m.closest([ 3, 4 ]);
  test.equivalent( got, exp );

  if( !Config.debug )
  return;

}

//

function matrixHomogenousApply( test )
{

  /* */

  test.case = 'matrixHomogenousApply 2d';

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    4, 0, 1,
    0, 5, 2,
    0, 0, 1,
  ]);

  var position = [ 0, 0 ];
  m.matrixHomogenousApply( position );
  test.equivalent( position, [ 1, 2 ] );

  var position = [ 1, 1 ];
  m.matrixHomogenousApply( position );
  test.equivalent( position, [ 5, 7 ] );

  /* */

  test.case = 'fromTransformations';

  var m = _.Matrix.Make([ 4, 4 ]);

  var position = [ 1, 2, 3 ];
  var quaternion = [ 0, 0, 0, 1 ];
  var scale = [ 1, 1, 1 ];
  m.fromTransformations( position, quaternion, scale );

  var got = [ 0, 0, 0 ];
  m.matrixHomogenousApply( got );
  test.equivalent( got, position );

}

//

function determinant( test )
{

  act( 'determinantWithPermutation', 0 );
  act( 'determinantWithPermutation', 1 );
  act( 'determinantWithLu', 0 );
  act( 'determinantWithLu', 1 );
  act( 'determinantWithBareiss', 0 );
  act( 'determinantWithBareiss', 1 );
  act( 'determinant', 0 );
  act( 'determinant', 1 );
  act( 'determinant' );

  function act( r, smalling )
  {

    test.open( `${r} smalling:${smalling}` );

    /* */

    test.case = 'zero 1x1';
    var m = _.Matrix.MakeZero( 1 );
    var d = m[ r ]({ smalling });
    test.equivalent( d, 0 );

    /* */

    test.case = 'zero 2x2';
    var m = _.Matrix.MakeZero( 2 );
    var d = m[ r ]({ smalling });
    test.equivalent( d, 0 );

    /* */

    test.case = 'zero 3x3';
    var m = _.Matrix.MakeZero( 3 );
    var d = m[ r ]({ smalling });
    test.equivalent( d, 0 );

    /* */

    test.case = 'zero 4x4';
    var m = _.Matrix.MakeZero( 4 );
    var d = m[ r ]({ smalling });
    test.equivalent( d, 0 );

    /* */

    test.case = 'empty';

    var m = new _.Matrix
    ({
      buffer : new I32x([]),
      dims : [ 0, 0 ],
      inputRowMajor : 1,
    });

    var d = m[ r ]({ smalling });
    test.equivalent( d, 0 );

    /* */

    test.case = 'empty 3x0';

    var m = new _.Matrix
    ({
      buffer : new I32x([]),
      dims : [ 3, 0 ],
      inputRowMajor : 1,
    });

    var d = m[ r ]({ smalling });
    test.equivalent( d, 0 );

    /* */

    test.case = 'empty 0x3';

    var m = new _.Matrix
    ({
      buffer : new I32x([]),
      dims : [ 0, 3 ],
      inputRowMajor : 1,
    });

    var d = m[ r ]({ smalling });
    test.equivalent( d, 0 );

    /* */

    test.case = '1x1';

    var m = new _.Matrix
    ({
      buffer : new I32x([ 3 ]),
      dims : [ 1, 1 ],
      inputRowMajor : 1,
    });

    var d = m[ r ]({ smalling });
    test.equivalent( d, 3 );

    /* */

    test.case = '3x1';

    var m = new _.Matrix
    ({
      buffer : new I32x([ 1, 2, 3 ]),
      dims : [ 3, 1 ],
      inputRowMajor : 1,
    });

    var d = m[ r ]({ smalling });
    test.equivalent( d, 0 );

    /* */

    test.case = '1x3';

    var m = new _.Matrix
    ({
      buffer : new I32x([ 1, 2, 3 ]),
      dims : [ 1, 3 ],
      inputRowMajor : 1,
    });

    var d = m[ r ]({ smalling });
    test.equivalent( d, 0 );

    /* */

    test.case = '2x2, simplest determinant';

    var m = new _.Matrix
    ({
      buffer : new I32x([ 1, 2, 3, 4 ]),
      dims : [ 2, 2 ],
      inputRowMajor : 1,
    });

    var d = m[ r ]({ smalling });
    test.equivalent( d, -2 );

    /* */

    test.case = '2x2 matrix with -2 determinant, column first';

    var m = new _.Matrix
    ({
      buffer : new I32x( _.longFromRange([ 1, 5 ]) ),
      dims : [ 2, 2 ],
      inputRowMajor : 0,
    });

    var d = m[ r ]({ smalling });
    test.equivalent( d, -2 );

    /* */

    test.case = '3x3, npermutations:0 nRowPermutations:0 nColPermutations:0';

    var buffer = new I32x
    ([
      1, 3, 5,
      0, 5, 1,
      6, 5, 0,
    ]);
    var m = new _.Matrix
    ({
      buffer : buffer,
      dims : [ 3, 3 ],
      inputRowMajor : 1,
    });

    var d = m[ r ]({ smalling });
    test.equivalent( d, -137 );

    /* */

    test.case = '3x3, npermutations:0 nRowPermutations:0 nColPermutations:0';

    var buffer = new I32x
    ([
      9, 1, 2,
      3, 9, 4,
      5, 6, 9
    ]);
    var m = new _.Matrix
    ({
      buffer : buffer,
      dims : [ 3, 3 ],
      inputRowMajor : 1,
    });

    var d = m[ r ]({ smalling });
    test.equivalent( d, 452 );

    /* */

    test.case = '3x3, npermutations:1 nRowPermutations:1 nColPermutations:0';

    var buffer = new I32x
    ([
      9, 1, 2,
      3, 9, 4,
      10, 6, 9
    ]);
    var m = new _.Matrix
    ({
      buffer : buffer,
      dims : [ 3, 3 ],
      inputRowMajor : 1,
    });

    var d = m[ r ]({ smalling });
    test.equivalent( d, 382 );

    /* */

    test.case = '3x3, npermutations:2 nRowPermutations:2 nColPermutations:0';

    var buffer = new I32x
    ([
      9, 1, 2,
      3, 9, 4,
      10, 10, 9
    ]);
    var m = new _.Matrix
    ({
      buffer : buffer,
      dims : [ 3, 3 ],
      inputRowMajor : 1,
    });

    var d = m[ r ]({ smalling });
    test.equivalent( d, 262 );

    /* */

    test.case = '3x3, npermutations:1 nRowPermutations:0 nColPermutations:1';

    var buffer = new I32x
    ([
      9, 10, 2,
      3, 9, 4,
      5, 6, 9
    ]);
    var m = new _.Matrix
    ({
      buffer : buffer,
      dims : [ 3, 3 ],
      inputRowMajor : 1,
    });

    var d = m[ r ]({ smalling });
    test.equivalent( d, 389 );

    /* */

    test.case = '3x3, npermutations:2 nRowPermutations:0 nColPermutations:2';

    var buffer = new I32x
    ([
      9, 10, 2,
      3, 9, 10,
      5, 6, 9
    ]);
    var m = new _.Matrix
    ({
      buffer : buffer,
      dims : [ 3, 3 ],
      inputRowMajor : 1,
    });

    var d = m[ r ]({ smalling });
    test.equivalent( d, 365 );

    /* */

    test.case = '3x3, npermutations:2 nRowPermutations:1 nColPermutations:1';

    var buffer = new I32x
    ([
      9, 11, 2,
      3, 9, 4,
      10, 6, 9
    ]);
    var m = new _.Matrix
    ({
      buffer : buffer,
      dims : [ 3, 3 ],
      inputRowMajor : 1,
    });

    var d = m[ r ]({ smalling });
    test.equivalent( d, 512 );

    /* */

    test.case = '3x3 with negative determinant';

    var m = new _.Matrix
    ({
      buffer : new I32x
      ([
        +2, -2, +4,
        +2, -3, +3,
        -2, +4, +2,
      ]),
      dims : [ 3, 3 ],
      inputRowMajor : 1,
    });

    var d = m[ r ]({ smalling });
    test.equivalent( d, -8 );

    /* */

    test.case = '3x3 with zero determinant';

    var buffer = new I32x
    ([
      +2, +2, -2,
      -2, -3, +4,
      +4, +3, -2,
    ]);
    var m = new _.Matrix
    ({
      buffer,
      dims : [ 3, 3 ],
      inputRowMajor : 1,
    });

    var d = m[ r ]({ smalling });

    test.equivalent( d, 0 );
    test.identical( m.dims, [ 3, 3 ] );
    test.identical( m.stridesEffective, [ 3, 1 ] );

    /* */

    test.case = '3x3 with negative determinant';

    var m = new _.Matrix
    ({
      buffer : new I32x
      ([
        +2, -2, +4,
        +2, -3, +3,
        -2, +4, +2,
      ]),
      dims : [ 3, 3 ],
      inputRowMajor : 1,
    });

    var d = m[ r ]({ smalling });
    test.equivalent( d, -8 );

    /* */

    test.case = '3x3 matrix with -30 determinant';

    var buffer = new I32x
    ([
      11, 2, 3,
       4, 5, 6,
       7, 8, 9,
    ]);
    var m = new _.Matrix
    ({
      buffer,
      dims : [ 3, 3 ],
      inputRowMajor : 1,
    });

    var d = m[ r ]({ smalling });

    test.equivalent( d, -30 );

    /* */

    test.case = '3x3 matrix';

    var buffer = new I32x
    ([
      15, -42, -61,
      43, 57, 19,
      45, 81, 25,
    ]);

    var m = new _.Matrix
    ({
      buffer,
      dims : [ 3, 3 ],
      inputRowMajor : 1,
    });

    var d = m[ r ]();
    test.equivalent( d, -48468 );

    var m = new _.Matrix
    ({
      buffer,
      dims : [ 3, 3 ],
      inputRowMajor : 0,
    });

    var d = m[ r ]({ smalling });
    test.equivalent( d, -48468 );

    /* */

    test.case = '4x4, permutating required';

    var buffer = new I32x
    ([
      1, 1, 4, 1,
      2, 2, 10, 6,
      3, 9, 21, 17,
      5, 11, 29, 23,
    ]);

    var m = new _.Matrix
    ({
      buffer,
      dims : [ 4, 4 ],
      inputRowMajor : 1,
    });

    var d = m[ r ]({ smalling });
    test.equivalent( d, -48 );

    /* */

    test.close( `${r} smalling:${smalling}` );

  }

}

determinant.accuracy = [ 1e-2, 1e-1 ];

//

function determinantWithLuBig( test )
{

  /* */

  test.case = 'identity 250x250';
  var m = _.Matrix.MakeIdentity( 250 );
  var d = m.determinantWithLu();
  test.equivalent( d, 1 );

  /* */

}

determinantWithLuBig.rapidity = -1;
determinantWithLuBig.timeOut = 300000;

//

function determinantWithBareissBig( test )
{

  /* */

  test.case = 'identity 250x250';
  var m = _.Matrix.MakeIdentity( 250 );
  var d = m.determinantWithBareiss();
  test.equivalent( d, 1 );

  /* */

}

determinantWithBareissBig.rapidity = -1;
determinantWithBareissBig.timeOut = 300000;

//

// qqq : cover static routine OuterProductOfVectors
// qqq : cover routine outerProductOfVectors
// qqq : repair this test please
//
// function outerProductOfVectors( test )
// {
//
//   var matrix = _.Matrix.Make( [ 2, 2 ] );
//
//   /* */
//
//   test.description = 'Vectors remains unchanged';
//
//   var v1 = _.vectorAdapter.from( [ 0, 1, 2 ] );
//   var v2 = _.vectorAdapter.from( [ 3, 3, 3 ] );
//
//   var gotMatrix = matrix.outerProductOfVectors( v1, v2 );
//
//   var oldV1 =  _.vectorAdapter.from( [ 0, 1, 2 ] );
//   test.equivalent( v1, oldV1 );
//   var oldV2 =  _.vectorAdapter.from( [ 3, 3, 3 ] );
//   test.equivalent( v2, oldV2 );
//
//   /* */
//
//   test.description = '1x1 matrix';
//
//   var v1 = _.vectorAdapter.from( [ 2 ] );
//   var v2 = _.vectorAdapter.from( [ 3 ] );
//
//   var gotMatrix = matrix.outerProductOfVectors( v1, v2 );
//
//   var expected =  _.Matrix.Make( [ 1, 1 ] ).copy
//   ([
//     6
//   ]);
//
//   test.equivalent( gotMatrix, expected );
//
//   /* */
//
//   test.description = '2x1 matrix';
//
//   var v1 = _.vectorAdapter.from( [ 2, 2 ] );
//   var v2 = _.vectorAdapter.from( [ 3 ] );
//
//   var gotMatrix = matrix.outerProductOfVectors( v1, v2 );
//
//   var expected =  _.Matrix.Make( [ 2, 1 ] ).copy
//   ([
//     6,
//     6
//   ]);
//
//   test.equivalent( gotMatrix, expected );
//
//   /* */
//
//   test.description = '1x2 matrix';
//
//   var v1 = _.vectorAdapter.from( [ 2 ] );
//   var v2 = _.vectorAdapter.from( [ 3, 3 ] );
//
//   var gotMatrix = matrix.outerProductOfVectors( v1, v2 );
//
//   var expected =  _.Matrix.Make( [ 1, 2 ] ).copy
//   ([
//     6, 6
//   ]);
//
//   test.equivalent( gotMatrix, expected );
//
//   /* */
//
//   test.description = '2x2 matrix';
//
//   var v1 = _.vectorAdapter.from( [ 1, 2 ] );
//   var v2 = _.vectorAdapter.from( [ 3, 4 ] );
//
//   var gotMatrix = matrix.outerProductOfVectors( v1, v2 );
//
//   var expected =  _.Matrix.Make( [ 2, 2 ] ).copy
//   ([
//     3, 4,
//     6, 8
//   ]);
//
//   test.equivalent( gotMatrix, expected );
//
//   /* */
//
//   test.description = '3x2 matrix';
//
//   var v1 = _.vectorAdapter.from( [ 1, 2, 3 ] );
//   var v2 = _.vectorAdapter.from( [ 3, 4 ] );
//
//   var gotMatrix = matrix.outerProductOfVectors( v1, v2 );
//
//   var expected =  _.Matrix.Make( [ 3, 2 ] ).copy
//   ([
//     3, 4,
//     6, 8,
//     9, 12
//   ]);
//
//   test.equivalent( gotMatrix, expected );
//
//   /* */
//
//   test.description = '2x3 matrix';
//
//   var v1 = _.vectorAdapter.from( [ 1, 2 ] );
//   var v2 = _.vectorAdapter.from( [ 3, 4, 5 ] );
//
//   var gotMatrix = matrix.outerProductOfVectors( v1, v2 );
//
//   var expected =  _.Matrix.Make( [ 2, 3 ] ).copy
//   ([
//     3, 4, 5,
//     6, 8, 10
//   ]);
//
//   test.equivalent( gotMatrix, expected );
//
//   /* */
//
//   test.description = '3x3 matrix';
//
//   var v1 = _.vectorAdapter.from( [ 1, 2, 3 ] );
//   var v2 = _.vectorAdapter.from( [ 3, 4, 5 ] );
//
//   var gotMatrix = matrix.outerProductOfVectors( v1, v2 );
//   var expected =  _.Matrix.Make( [ 3, 3 ] ).copy
//   ([
//     3, 4, 5,
//     6, 8, 10,
//     9, 12, 15
//   ]);
//
//   test.equivalent( gotMatrix, expected );
//
//   /* */
//
//   test.description = '4x4 matrix';
//
//   var v1 = _.vectorAdapter.from( [ 1, 2, 3, 4 ] );
//   var v2 = _.vectorAdapter.from( [ 3, 4, 5, 6 ] );
//
//   var gotMatrix = matrix.outerProductOfVectors( v1, v2 );
//   var expected =  _.Matrix.Make( [ 4, 4 ] ).copy
//   ([
//     3, 4, 5, 6,
//     6, 8, 10, 12,
//     9, 12, 15, 18,
//     12, 16, 20, 24
//   ]);
//
//   test.equivalent( gotMatrix, expected );
//
//   /* */
//
//   if( !Config.debug )
//   return;
//
//   var v1 = _.vectorAdapter.from( [ 1, 2, 3, 4 ] );
//   var v2 = _.vectorAdapter.from( [ 3, 4, 5, 6 ] );
//
//   var matrix = 'matrix';
//   test.shouldThrowErrorSync( () => matrix.outerProductOfVectors( v1, v2 ) );
//   var matrix = NaN;
//   test.shouldThrowErrorSync( () => matrix.outerProductOfVectors( v1, v2 ) );
//   var matrix = null;
//   test.shouldThrowErrorSync( () => matrix.outerProductOfVectors( v1, v2 ) );
//   var matrix = [ 0, 0, 0 ];
//   test.shouldThrowErrorSync( () => matrix.outerProductOfVectors( v1, v2 ) );
//   var matrix = _.vectorAdapter.from( [ 0, 0, 0 ] );
//   test.shouldThrowErrorSync( () => matrix.outerProductOfVectors( v1, v2 ) );
//   var matrix = _.Matrix.Make( [ 2, 2 ] );
//   test.shouldThrowErrorSync( () => matrix.outerProductOfVectors( 'v1', v2 ) );
//   test.shouldThrowErrorSync( () => matrix.outerProductOfVectors( v1, 'v2' ) );
//   test.shouldThrowErrorSync( () => matrix.outerProductOfVectors( null, v2 ) );
//   test.shouldThrowErrorSync( () => matrix.outerProductOfVectors( v1, null ) );
//   test.shouldThrowErrorSync( () => matrix.outerProductOfVectors( NaN, 2 ) );
//   test.shouldThrowErrorSync( () => matrix.outerProductOfVectors( v1, NaN ) );
//   test.shouldThrowErrorSync( () => matrix.outerProductOfVectors( undefined, v2 ) );
//   test.shouldThrowErrorSync( () => matrix.outerProductOfVectors( v1, undefined ) );
//
// }

// --
// solver
// --

function triangulateGausian( test )
{

  _.Matrix.ContextsForTesting( act );

  function act( op )
  {

    /* */

    test.case = `m : 0x0`;

    var mexpected = _.Matrix.Make([ 0, 0 ])
    var m = _.Matrix.Make([ 0, 0 ]);

    var triangulated = m.triangulateGausian();
    test.equivalent( m, mexpected );

    test.identical( triangulated.x, null );
    test.identical( triangulated.ox, null );
    test.identical( triangulated.y, null );
    test.identical( triangulated.oy, null );

    /* */

    test.case = `m : 0x0, y : ${op.format}.0x${op.dup}`;

    var mexpected = _.Matrix.Make([ 0, 0 ])
    var m = _.Matrix.Make([ 0, 0 ]);

    var y = op.containerMake([]);

    var triangulated = m.triangulateGausian( y );
    test.equivalent( m, mexpected );

    var expected = op.matrixMake([]);
    test.identical( triangulated.x, expected );
    var expected = op.containerMake([]);
    test.identical( triangulated.ox, expected );
    var expected = op.containerMake([]);
    test.identical( triangulated.y, expected );
    var expected = op.containerMake([]);
    test.identical( triangulated.oy, expected );
    test.is( y === triangulated.oy );

    /* */

    test.case = `m : 0x2`;

    var mexpected = _.Matrix.Make([ 0, 2 ])
    var m = _.Matrix.Make([ 0, 2 ]);

    var triangulated = m.triangulateGausian();
    test.equivalent( m, mexpected );

    test.identical( triangulated.x, null );
    test.identical( triangulated.ox, null );
    test.identical( triangulated.y, null );
    test.identical( triangulated.oy, null );

    /* */

    test.case = `m : 0x2, y : ${op.format}.0x${op.dup}`;

    var mexpected = _.Matrix.Make([ 0, 2 ])
    var m = _.Matrix.Make([ 0, 2 ]);

    var y = op.containerMake([]);

    var triangulated = m.triangulateGausian( y );
    test.equivalent( m, mexpected );

    var expected = op.matrixMake([ 0, 0 ]);
    test.identical( triangulated.x, expected );
    var expected = op.containerMake([ 0, 0 ]);
    test.identical( triangulated.ox, expected );
    var expected = op.containerMake([]);
    test.identical( triangulated.y, expected );
    var expected = op.containerMake([]);
    test.identical( triangulated.oy, expected );
    test.is( y === triangulated.oy );

    /* */

    test.case = `m : 2x0`;

    var mexpected = _.Matrix.Make([ 2, 0 ])
    var m = _.Matrix.Make([ 2, 0 ]);

    var triangulated = m.triangulateGausian();
    test.equivalent( m, mexpected );

    test.identical( triangulated.x, null );
    test.identical( triangulated.ox, null );
    test.identical( triangulated.y, null );
    test.identical( triangulated.oy, null );

    /* */

    test.case = `m : 2x0, y : ${op.format}.0x${op.dup}`;

    var mexpected = _.Matrix.Make([ 2, 0 ])
    var m = _.Matrix.Make([ 2, 0 ]);

    var y = op.containerMake([ 1, 2 ]);

    var triangulated = m.triangulateGausian( y );
    test.equivalent( m, mexpected );

    var expected = op.matrixMake([ 1, 2 ]);
    test.identical( triangulated.x, expected );
    var expected = op.containerMake([ 1, 2 ]);
    test.identical( triangulated.ox, expected );
    var expected = op.containerMake([ 1, 2 ]);
    test.identical( triangulated.y, expected );
    var expected = op.containerMake([ 1, 2 ]);
    test.identical( triangulated.oy, expected );
    test.is( y === triangulated.oy );

    /* */

    test.case = 'm : 3x3';

    var mexpected = _.Matrix.Make([ 3, 3 ]).copy
    ([
      +1, -2, +2,
      +0, -5, -2,
      +0, +0, -1,
    ]);

    var m = _.Matrix.Make([ 3, 3 ]).copy
    ([
      +1, -2, +2,
      +5, -15, +8,
      -2, -11, -11,
    ]);

    var triangulated = m.triangulateGausian();
    test.equivalent( m, mexpected );

    test.identical( triangulated.x, null );
    test.identical( triangulated.ox, null );
    test.identical( triangulated.y, null );
    test.identical( triangulated.oy, null );

    /* */

    test.case = `m : 3x3, y : ${op.format}.3x${op.dup}`;

    var mexpected = _.Matrix.Make([ 3, 3 ]).copy
    ([
      +1, -2, +2,
      +0, -5, -2,
      +0, +0, -1,
    ]);

    var m = _.Matrix.Make([ 3, 3 ]).copy
    ([
      +1, -2, +2,
      +5, -15, +8,
      -2, -11, -11,
    ]);

    var y = op.containerMake([ 1, 1, 1 ]);

    var triangulated = m.triangulateGausian( y );
    test.equivalent( m, mexpected );

    var expected = op.matrixMake([ +1, -4, +15 ]);
    test.identical( triangulated.x, expected );
    var expected = op.containerMake([ +1, -4, +15 ]);
    test.identical( triangulated.ox, expected );
    var expected = op.containerMake([ 1, 1, 1 ]);
    test.identical( triangulated.y, expected );
    var expected = op.containerMake([ 1, 1, 1 ]);
    test.identical( triangulated.oy, expected );
    test.is( y === triangulated.oy );

    /* */

    test.case = 'm : 3x4';

    var m = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +1, +2, -1,
      +3, +1, +7, -7,
      +1, +7, +1, +7,
    ]);

    var exp = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +1, +2, -1,
      +0, -2, +1, -4,
      +0, +0, +2, -4,
    ]);

    var triangulated = m.triangulateGausian();
    test.equivalent( m, exp );

    test.identical( triangulated.x, null );
    test.identical( triangulated.ox, null );
    test.identical( triangulated.y, null );
    test.identical( triangulated.oy, null );

    /* */

    test.case = `m : 3x4, y : ${op.format}.3x${op.dup}`;

    var m = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, -2, +2, 1,
      +5, -15, +8, 1,
      -2, -11, -11, 1,
    ]);

    var exp = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, -2, +2, +1,
      +0, -5, -2, -4,
      +0, +0, -1, +15,
    ]);

    var y = op.containerMake([ 1, 2, 3 ]);
    var triangulated = m.triangulateGausian( y );
    test.equivalent( m, exp );

    var expected = op.matrixMake([ +1, -3, +14, +0 ]);
    test.identical( triangulated.x, expected );
    var expected = op.containerMake([ +1, -3, +14, +0 ]);
    test.identical( triangulated.ox, expected );
    var expected = op.containerMake([ 1, 2, 3 ]);
    test.identical( triangulated.y, expected );
    var expected = op.containerMake([ 1, 2, 3 ]);
    test.identical( triangulated.oy, expected );
    test.is( y === triangulated.oy );

    /* */

    test.case = `m : 4x3`;

    var mexpected = _.Matrix.Make([ 4, 3 ]).copy
    ([
      +1, -2, +4,
      +0, +2, -4,
      +0, +0, +8,
      +0, +0, +0,
    ]);

    var m = _.Matrix.Make([ 4, 3 ]).copy
    ([
      +1, -2, +4,
      +1, +0, +0,
      +1, +2, +4,
      +1, +4, +16,
    ]);

    var triangulated = m.triangulateGausian();
    test.equivalent( m, mexpected );

    test.identical( triangulated.x, null );
    test.identical( triangulated.ox, null );
    test.identical( triangulated.y, null );
    test.identical( triangulated.oy, null );

    /* */

    test.case = `m : 4x3, y : ${op.format}.3x${op.dup}`;

    var mexpected = _.Matrix.Make([ 4, 3 ]).copy
    ([
      +1, -2, +4,
      +0, +2, -4,
      +0, +0, +8,
      +0, +0, +0,
    ]);

    var m = _.Matrix.Make([ 4, 3 ]).copy
    ([
      +1, -2, +4,
      +1, +0, +0,
      +1, +2, +4,
      +1, +4, +16,
    ]);

    var y = op.containerMake([ -1, +2, +3, +2 ]);

    var triangulated = m.triangulateGausian( y );
    test.equivalent( m, mexpected );

    var expected = op.matrixMake([ -1, +3, -2, +0 ]);
    test.identical( triangulated.x, expected );
    var expected = op.containerMake([ -1, +3, -2, +0 ]);
    test.identical( triangulated.ox, expected );
    var expected = op.containerMake([ -1, +2, +3, +2 ]);
    test.identical( triangulated.y, expected );
    var expected = op.containerMake([ -1, +2, +3, +2 ]);
    test.identical( triangulated.oy, expected );
    test.is( y === triangulated.oy );

    /* */

  }

}

//

function triangulateGausianNormalizing( test )
{

  /* */

  test.case = 'triangulateGausianNormalizing simple1';

  var m = _.Matrix.Make([ 3, 4 ]).copy
  ([
    +1, +1, +2, -1,
    +3, +1, +7, -7,
    +1, +7, +1, +7,
  ]);

  var exp = _.Matrix.Make([ 3, 4 ]).copy
  ([
    +1, +1, +2, -1,
    +0, +1, -0.5, +2,
    +0, +0, +1, -2,
  ]);

  m.triangulateGausianNormalizing();
  test.equivalent( m, exp );

  /* */

  test.case = 'triangulateGausianNormalizing simple2';

  var m = _.Matrix.Make([ 3, 4 ]).copy
  ([
    +1, -2, +2, 1,
    +5, -15, +8, 1,
    -2, -11, -11, 1,
  ]);

  var exp = _.Matrix.Make([ 3, 4 ]).copy
  ([
    +1, -2, +2, +1.0,
    +0, +1, 0.4, +0.8,
    +0, +0, 1, -15,
  ]);

  var triangulated = m.triangulateGausianNormalizing();
  test.equivalent( m, exp );

  /* */

  test.case = 'triangulateGausianNormalizing with y argument';

  var mexpected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +0, +1, 0.4,
    +0, +0, 1,
  ]);

  var yexpected = _.Matrix.MakeCol([ +1, +0.8, -15 ]);

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +5, -15, +8,
    -2, -11, -11,
  ]);

  var y = _.Matrix.MakeCol([ 1, 1, 1 ]);

  var triangulated = m.triangulateGausianNormalizing( y );
  test.equivalent( m, mexpected );
  test.equivalent( triangulated.ox, yexpected );

  /* */

  test.case = 'triangulateGausianNormalizing ( nrow < ncol ) with y argument';

  var mexpected = _.Matrix.Make([ 4, 3 ]).copy
  ([
    +1, -2, +4,
    +0, +1, -2,
    +0, +0, +1,
    +0, +0, +0,
  ]);

  var yexpected = _.Matrix.MakeCol([ -1, +1.5, -0.25, +0 ]);

  var m = _.Matrix.Make([ 4, 3 ]).copy
  ([
    +1, -2, +4,
    +1, +0, +0,
    +1, +2, +4,
    +1, +4, +16,
  ]);

  var y = _.Matrix.MakeCol([ -1, +2, +3, +2 ]);

  var triangulated = m.triangulateGausianNormalizing( y );
  test.equivalent( m, mexpected );
  test.equivalent( triangulated.ox, yexpected );

  /* */

}

triangulateGausianNormalizing.accuracy = [ _.accuracy * 1e+2, 1e-1 ];

//

function triangulateGausianPermutating( test )
{

  /* */

  test.case = '3x4';

  var m = _.Matrix.Make([ 3, 4 ]).copy
  ([
    +1, +3, +1, +2,
    +2, +6, +4, +8,
    +0, +0, +2, +4,
  ]);

  var om = m.clone();
  var y = _.Matrix.MakeCol([ +1, +3, +1 ]);
  var triangulated = _.Matrix.TriangulateGausianPermutating({ m, y, repermutatingSolution : 0 });

  // logger.log( 'm', m );
  // logger.log( 'x', x );
  // logger.log( 'y', y );
  // logger.log( 'permutates', _.toStr( permutates, { levels : 2 } ) );

  var em = _.Matrix.Make([ 3, 4 ]).copy
  ([
    +3, +2, +1, +1,
    +0, +4, +2, +0,
    +0, +0, +0, +0,
  ]);
  test.identical( m, em );

  var ey = _.Matrix.MakeCol([ 1, 1, 0, 0 ]);
  test.identical( triangulated.ox, ey );

  var epermutates = [ [ 0, 1, 2 ], [ 1, 3, 2, 0 ] ]
  test.identical( triangulated.permutates, epermutates );

  m.permutateBackward( triangulated.permutates );
  _.Matrix.PermutateBackward( y, triangulated.permutates[ 0 ] );

  // logger.log( 'm', m );
  // logger.log( 'x', x );
  // logger.log( 'y', y );
  // logger.log( 'permutates', _.toStr( permutates, { levels : 2 } ) );

  var em = _.Matrix.Make([ 3, 4 ]).copy
  ([
    +1, +3, +1, +2,
    +0, +0, +2, +4,
    +0, +0, +0, +0,
  ]);
  test.identical( m, em );

  var exp = _.Matrix.MakeCol([ 1, 1, 0, 0 ]);
  test.identical( triangulated.ox, exp );

  /* */

  // test.case = '3x3 comparison';
  //
  // var y = _.Matrix.MakeCol([ 1, 2, 3 ]);
  // var m = _.Matrix.Make([ 3, 3 ]).copy
  // ([
  //   +4, +2, +4,
  //   +5, +3, +2,
  //   +6, +1, +9,
  // ]);
  //
  // var om = m.clone();
  //
  // var determinant = m.determinant();
  // logger.log( 'determinant', determinant );
  //
  // var m1 = m.clone();
  // var y1 = y.clone();
  // var triangulated1 = m1.triangulateGausian( y1 );
  // var y11 = _.Matrix.Mul( null, [ m1, triangulated1.x ] );
  // let last1 = triangulated1.x.scalarGet([ 2, 0 ]) / m1.scalarGet([ 2, 2 ])
  //
  // var m2 = m.clone();
  // var y2 = y.clone();
  // var triangulated2 = m2.triangulateGausianPermutating( y2 );
  // var y22 = _.Matrix.Mul( null, [ m2.clone().permutateBackward( triangulated2.permutates ), triangulated2.y ] );
  // let last2 = triangulated1.x.scalarGet([ 2, 0 ]) / m2.scalarGet([ 2, 2 ]);
  //
  // test.equivalent( last1, last2 ); debugger; /* zzz */

  /* */

  test.case = '3x3';

  var y = _.Matrix.MakeCol([ 1, 2, 3 ]);
  var yoriginal = y.clone();
  // var yexpected = _.Matrix.MakeCol([ 1, 1, 2.5 ]);
  var yexpected = _.Matrix.MakeCol([ 1, 2.5, 1 ]);

  var mexpected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +4, +4, +2,
    +0, -2, +0,
    +0, +0, +1,
  ]);

  var munpermutateedExpected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +4, +2, +4,
    +0, +0, -2,
    +0, +1, +0,
  ]);

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +4, +2, +4,
    +4, +2, +2,
    +2, +2, +2,
  ]);

  var om = m.clone();

  var determinant = m.determinant();
  logger.log( 'determinant', determinant );

  var m1 = m.clone();
  var triangulated1 = m1.triangulateGausian( y );
  logger.log( 'ordinary triangulation', m );

  // m = om.clone();
  var m2 = m.clone();
  var triangulated2 = m2.triangulateGausianPermutating( y );

  // test.equivalent( triangulated1.x, triangulated2.x );

  var munpermutateed = m2.clone().permutateBackward( triangulated2.permutates );
  // var munpermutateed = m.clone();
  var x = _.Matrix.SolveTriangleUpper( null, m2, triangulated2.x );
  var y2 = _.Matrix.Mul( null, [ m2, x ] );

  var x3 = _.Matrix.From( x.clone() ).permutateBackward([ triangulated2.permutates[ 1 ], null ]);
  // var x3 = _.Matrix.From( x.clone() );
  var y3 = _.Matrix.Mul( null, [ om, x3 ] );

  var permutatesExpected = [ [ 0, 1, 2 ], [ 0, 2, 1 ] ];
  test.equivalent( triangulated2.permutates, permutatesExpected );
  test.equivalent( munpermutateed, munpermutateedExpected );
  test.equivalent( m2, mexpected );
  // test.equivalent( triangulated2.x, yexpected ); // yyy
  test.equivalent( y2, yexpected );
  // test.equivalent( y3, yoriginal ); /* */

  logger.log( 'm', m );
  logger.log( 'x', x );
  logger.log( 'y', y );
  logger.log( 'permutates', _.toStr( triangulated2.permutates, { levels : 2 } ) );

  logger.log( 'om', om );
  logger.log( 'x3', x3 );
  logger.log( 'y3', y3 );

  /* */

}

//

function triangulateLuBasic( test )
{

  /* */

  test.case = 'triangulateLu . 3x3';

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +2, +4, -2,
    +4, -2, +6,
    +6, -4, +2,
  ]);

  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +2, +4, -2,
    +2, -10, +10,
    +3, +1.6, -8,
  ]);

  var om = m.clone();
  m.triangulateLu();
  test.equivalent( m, exp );

  var l = m.clone().triangleUpperSet( 0 ).diagonalSet( 1 );
  var u = m.clone().triangleLowerSet( 0 );

  var ll = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, +0, +0,
    +2, +1, +0,
    +3, +1.6, +1,
  ]);

  var uu = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +2, +4, -2,
    +0, -10, +10,
    +0, +0, -8,
  ]);

  var got = _.Matrix.Mul( null, [ l, u ] );
  test.equivalent( got, om );
  test.equivalent( l, ll );
  test.equivalent( u, uu );

  /* */

  test.case = 'triangulateLuNormalizing . 3x3';

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +2, +4, -2,
    +4, -2, +6,
    +6, -4, +2,
  ]);

  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +2, +2, -1,
    +4, -10, -1,
    +6, -16, -8,
  ]);

  var om = m.clone();
  m.triangulateLuNormalizing();
  test.equivalent( m, exp );

  var l = m.clone().triangleUpperSet( 0 );
  var u = m.clone().triangleLowerSet( 0 ).diagonalSet( 1 );

  var ll = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +2, +0, +0,
    +4, -10, +0,
    +6, -16, -8,
  ]);

  var uu = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, +2, -1,
    +0, +1, -1,
    +0, +0, +1,
  ]);

  var got = _.Matrix.Mul( null, [ l, u ] );
  test.equivalent( got, om );
  test.equivalent( l, ll );
  test.equivalent( u, uu );

  /* */

}

triangulateLuBasic.accuracy = [ _.accuracy * 1e+1, 1e-1 ];

//

function triangulateLu( test )
{

  /* */

  test.case = '3x3';

  var exp = _.Matrix.MakeSquare
  ([
    +1, -1, +2,
    +2, +2, -2,
    -2, -1, -2,
  ]);

  var m = _.Matrix.MakeSquare
  ([
    +1, -1, +2,
    +2, +0, +2,
    -2, +0, -4,
  ]);

  m.triangulateLu();
  logger.log( 'm', m );
  test.identical( m, exp )

  /* */

  test.case = 'triangulateLu';

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +5, -15, +8,
    -2, -11, -11,
  ]);

  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +5, -5, -2,
    -2, +3, -1,
  ]);

  var original = m.clone();
  m.triangulateLu();
  test.equivalent( m, exp );

  var l = m.clone().triangleUpperSet( 0 ).diagonalSet( 1 );
  var u = m.clone().triangleLowerSet( 0 );

  var ll = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, +0, +0,
    +5, +1, +0,
    -2, +3, +1,
  ]);

  var uu = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +0, -5, -2,
    +0, +0, -1,
  ]);

  var got = _.Matrix.Mul( null, [ l, u ] );
  test.equivalent( got, original );
  test.equivalent( l, ll );
  test.equivalent( u, uu );

  /* */

  test.case = 'triangulateLu ( nrow < ncol ) with y argument';

  var mexpected = _.Matrix.Make([ 4, 3 ]).copy
  ([
    +1, -2, +4,
    +1, +2, -4,
    +1, +2, +8,
    +1, +3, +3,
  ]);

  var yexpected = _.Matrix.MakeCol([ -1, +3, -2, +0 ]);

  var m = _.Matrix.Make([ 4, 3 ]).copy
  ([
    +1, -2, +4,
    +1, +0, +0,
    +1, +2, +4,
    +1, +4, +16,
  ]);

  var original = m.clone();

  m.triangulateLu();
  test.equivalent( m, mexpected );

  var l = m.clone().triangleUpperSet( 0 ).diagonalSet( 1 );
  var u = m.clone().triangleLowerSet( 0 );

  logger.log( 'l', l );
  logger.log( 'u', u );

  var ll = _.Matrix.Make([ 4, 3 ]).copy
  ([
    +1, +0, +0,
    +1, +1, +0,
    +1, +2, +1,
    +1, +3, +3,
  ]);

  var uu = _.Matrix.Make([ 4, 3 ]).copy
  ([
    +1, -2, +4,
    +0, +2, -4,
    +0, +0, +8,
    +0, +0, +0,
  ]);

  test.case = 'l and u should be';

  test.equivalent( l, ll );
  test.equivalent( u, uu );

  test.case = 'l*u should be same as original m';

  u = u.submatrix( [ 0, 2 ], _.all );
  var mul = _.Matrix.Mul( null, [ l, u ] );
  test.equivalent( mul, original );

  /* */

  test.case = 'triangulateLu ( nrow > ncol )';

  var mexpected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    +1, -2, +4,
    +1, +2, -4,
  ]);

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    +1, -2, +4,
    +1, +0, +0,
  ]);

  var original = m.clone();

  m.triangulateLu();
  test.equivalent( m, mexpected );

  var l = m.clone().triangleUpperSet( 0 ).diagonalSet( 1 );
  var u = m.clone().triangleLowerSet( 0 );

  logger.log( 'l', l );
  logger.log( 'u', u );

  var ll = _.Matrix.Make([ 2, 3 ]).copy
  ([
    +1, +0, +0,
    +1, +1, +0,
  ]);

  var uu = _.Matrix.Make([ 2, 3 ]).copy
  ([
    +1, -2, +4,
    +0, +2, -4,
  ]);

  test.description = 'l and u should be';

  test.equivalent( l, ll );
  test.equivalent( u, uu );

  test.description = 'l*u should be same as original m';

  u = u.expand([ [ 0, 1 ], null ]);
  var mul = _.Matrix.Mul( null, [ l, u ] );
  test.equivalent( mul, original );

  /* */

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    -1, +2, +0,
    -6, +6, +0,
    +0, +0, +3,
  ]);

  var om = m.clone();
  m.triangulateLu();

  var l = m.clone().triangleUpperSet( 0 ).diagonalSet( 1 );
  var u = m.clone().triangleLowerSet( 0 );
  var mul = _.Matrix.Mul( null, [ l, u ] );
  test.equivalent( mul, om );

  /* */

}

triangulateLu.accuracy = [ _.accuracy * 1e+1, 1e-1 ];

//

function triangulateLuNormalizing( test )
{

  /* */

  test.case = 'triangulateLuNormalizing';

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +2, +4, -2,
    +4, -2, +6,
    +6, -4, +2,
  ]);

  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +2, +2, -1,
    +4, -10, -1,
    +6, -16, -8,
  ]);

  var original = m.clone();
  m.triangulateLuNormalizing();
  test.equivalent( m, exp );

  /* */

  var l = m.clone().triangleUpperSet( 0 );
  var u = m.clone().triangleLowerSet( 0 ).diagonalSet( 1 );

  var ll = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +2, +0, +0,
    +4, -10, +0,
    +6, -16, -8,
  ]);

  var uu = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, +2, -1,
    +0, +1, -1,
    +0, +0, +1,
  ]);

  var got = _.Matrix.Mul( null, [ l, u ] );
  test.equivalent( got, original );
  test.equivalent( l, ll );
  test.equivalent( u, uu );

  /* */

  test.case = 'triangulateLuNormalizing';

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +5, -15, +8,
    -2, -11, -11,
  ]);
  var om = m.clone();

  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +5, -5, +0.4,
    -2, -15, -1,
  ]);

  m.triangulateLuNormalizing();
  test.equivalent( m, exp );

  var l = m.clone().triangleUpperSet( 0 );
  var u = m.clone().triangleLowerSet( 0 ).diagonalSet( 1 );

  logger.log( 'l', l );
  logger.log( 'u', u );

  var ll = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, +0, +0,
    +5, -5, +0,
    -2, -15, -1,
  ]);

  var uu = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +0, +1, +0.4,
    +0, +0, +1,
  ]);

  var mul = _.Matrix.Mul( null, [ l, u ] );
  test.equivalent( mul, om );
  test.equivalent( l, ll );
  test.equivalent( u, uu );

  /* */

  test.case = 'triangulateLuNormalizing ( nrow < ncol )';

  var mexpected = _.Matrix.Make([ 4, 3 ]).copy
  ([
    +1, -2, +4,
    +1, +2, -2,
    +1, +4, +8,
    +1, +6, +24,
  ]);

  var m = _.Matrix.Make([ 4, 3 ]).copy
  ([
    +1, -2, +4,
    +1, +0, +0,
    +1, +2, +4,
    +1, +4, +16,
  ]);

  var original = m.clone();

  m.triangulateLuNormalizing();
  test.equivalent( m, mexpected );

  var l = m.clone().triangleUpperSet( 0 );
  var u = m.clone().triangleLowerSet( 0 ).diagonalSet( 1 );

  logger.log( 'l', l );
  logger.log( 'u', u );

  var ll = _.Matrix.Make([ 4, 3 ]).copy
  ([
    +1, +0, +0,
    +1, +2, +0,
    +1, +4, +8,
    +1, +6, +24,
  ]);

  var uu = _.Matrix.Make([ 4, 3 ]).copy
  ([
    +1, -2, +4,
    +0, +1, -2,
    +0, +0, +1,
    +0, +0, +0,
  ]);

  test.case = 'l and u should be';

  test.equivalent( l, ll );
  test.equivalent( u, uu );

  test.case = 'l*u should be same as original m';

  u = u.submatrix( [ 0, 2 ], _.all );
  var mul = _.Matrix.Mul( null, [ l, u ] );
  test.equivalent( mul, original );

  /* */

  test.case = 'triangulateLuNormalizing ( nrow > ncol )';

  var mexpected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    +1, -2, +4,
    +1, +2, -2,
  ]);

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    +1, -2, +4,
    +1, +0, +0,
  ]);

  var original = m.clone();

  m.triangulateLuNormalizing();
  test.equivalent( m, mexpected );

  var l = m.clone().triangleUpperSet( 0 );
  var u = m.clone().triangleLowerSet( 0 ).diagonalSet( 1 );

  logger.log( 'l', l );
  logger.log( 'u', u );

  var ll = _.Matrix.Make([ 2, 3 ]).copy
  ([
    +1, +0, +0,
    +1, +2, +0,
  ]);

  var uu = _.Matrix.Make([ 2, 3 ]).copy
  ([
    +1, -2, +4,
    +0, +1, -2,
  ]);

  test.case = 'l and u should be';

  test.equivalent( l, ll );
  test.equivalent( u, uu );

  test.case = 'l*u should be same as original m';

  u = u.expand([ [ 0, 1 ], null ]);
  var mul = _.Matrix.Mul( null, [ l, u ] );
  test.equivalent( mul, original );

  /* */

}

triangulateLuNormalizing.accuracy = [ _.accuracy * 1e+1, 1e-1 ];

//

function SolveTriangleLower( test )
{

  /* */

  test.case = 'basic';
  var m = _.Matrix.MakeSquare
  ([
    2, 0, 0,
    2, 3, 0,
    4, 5, 6,
  ]);
  var exp = _.Matrix.MakeCol([ 1, 0, 0 ]);
  var y = _.Matrix.MakeCol([ 2, 2, 4 ]);
  var x = _.Matrix.SolveTriangleLower( null, m, y );
  test.equivalent( x, exp );

  /* */

  test.case = 'with garbage';
  var m = _.Matrix.MakeSquare
  ([
    2, -99, -99,
    2, 3, -99,
    4, 5, 6,
  ]);
  var exp = _.Matrix.MakeCol([ 1, 0, 0 ]);
  var y = _.Matrix.MakeCol([ 2, 2, 4 ]);
  var x = _.Matrix.SolveTriangleLower( null, m, y );
  test.equivalent( x, exp );

  /* */

}

//

function SolveTriangleUpper( test )
{

  /* */

  test.case = 'basic';
  var m = _.Matrix.MakeSquare
  ([
    6, 5, 4,
    0, 3, 2,
    0, 0, 2,
  ]);

  var exp = _.Matrix.MakeCol([ 0, 0, 1 ]);
  var y = _.Matrix.MakeCol([ 4, 2, 2 ]);
  var x = _.Matrix.SolveTriangleUpper( null, m, y );
  test.equivalent( x, exp );

  /* */

  test.case = 'with garbage';
  var m = _.Matrix.MakeSquare
  ([
    6, 5, 4,
    -99, 3, 2,
    -99, -99, 2,
  ]);
  var exp = _.Matrix.MakeCol([ 0, 0, 1 ]);
  var y = _.Matrix.MakeCol([ 4, 2, 2 ]);
  var x = _.Matrix.SolveTriangleUpper( null, m, y );
  test.equivalent( x, exp );

  /* */

}

//

function SolveTriangleLowerNormalized( test )
{

  /* */

  test.case = 'basic';
  var m = _.Matrix.MakeSquare
  ([
    1, 0, 0,
    2, 1, 0,
    4, 5, 1,
  ]);

  var exp = _.Matrix.MakeCol([ 2, -2, 6 ]);
  var y = _.Matrix.MakeCol([ 2, 2, 4 ]);
  var x = _.Matrix.SolveTriangleLowerNormalized( null, m, y );
  test.equivalent( x, exp );

  /* */

  test.case = 'with garbage';
  var m = _.Matrix.MakeSquare
  ([
    -99, -99, -99,
    2, -99, -99,
    4, 5, -99,
  ]);
  var exp = _.Matrix.MakeCol([ 2, -2, 6 ]);
  var y = _.Matrix.MakeCol([ 2, 2, 4 ]);
  var x = _.Matrix.SolveTriangleLowerNormalized( null, m, y );
  test.equivalent( x, exp );

  /* */

}

//

function SolveTriangleUpperNormalized( test )
{

  /* */

  test.case = 'basic';
  var m = _.Matrix.MakeSquare
  ([
    1, 5, 4,
    0, 1, 2,
    0, 0, 1,
  ]);
  var exp = _.Matrix.MakeCol([ 6, -2, 2 ]);
  var y = _.Matrix.MakeCol([ 4, 2, 2 ]);
  var x = _.Matrix.SolveTriangleUpperNormalized( null, m, y );
  test.equivalent( x, exp );

  /* */

  test.case = 'with garbage';
  var m = _.Matrix.MakeSquare
  ([
    -99, 5, 4,
    -99, -99, 2,
    -99, -99, -99,
  ]);
  var exp = _.Matrix.MakeCol([ 6, -2, 2 ]);
  var y = _.Matrix.MakeCol([ 4, 2, 2 ]);
  var x = _.Matrix.SolveTriangleUpperNormalized( null, m, y );
  test.equivalent( x, exp );

  /* */

}

//

function SolveWithTriangles( test )
{

  /* */

  test.case = 'basic';
  var m = _.Matrix.MakeSquare
  ([
    1, 5, 4,
    0, 1, 2,
    0, 0, 1,
  ]);
  var exp = _.Matrix.MakeCol([ 6, -2, 2 ]);
  var y = _.Matrix.MakeCol([ 4, 2, 2 ]);
  var x = _.Matrix.SolveWithTriangles( null, m, y );
  test.equivalent( x, exp );

  /* */

  test.case = 'SolveWithTriangles u';

  var m = _.Matrix.MakeSquare
  ([
    -2, +1, +2,
    +4, -1, -5,
    +2, -3, -1,
  ]);
  var exp = _.Matrix.MakeCol([ -1, 2, -2 ]);
  var y = _.Matrix.MakeCol([ 0, 4, -6 ]);
  var x = _.Matrix.SolveWithTriangles( null, m, y );
  test.equivalent( x, exp );

  /* */

}

//

function SolveSimple( test, rname )
{

  act( 'Solve' );
  act( 'SolveWithGausian' );
  act( 'SolveWithGausianNormalizing' );
  act( 'SolveWithGausianPermutating' );
  act( 'SolveWithGausianNormalizingPermutating' );
  act( 'SolveWithGaussJordan' );
  act( 'SolveWithGaussJordanNormalizing' );
  act( 'SolveWithGaussJordanPermutating' );
  act( 'SolveWithGaussJordanNormalizingPermutating' );
  act( 'SolveWithTriangles' );
  act( 'SolveWithTrianglesNormalizing' );
  act( 'SolveWithTrianglesPermutating' );
  act( 'SolveWithTrianglesNormalizingPermutating' );

  /* - */

  function act( rname )
  {

    /**/

    test.case = rname + ' . y array . Solve 2x2 system . control';

    var m = _.Matrix.MakeSquare
    ([
      1, -2,
      3,  4
    ]);
    var om = m.clone();
    var y = [ -7, 39 ];
    var oy = y.slice();
    var x = _.Matrix.Solve( null, m, y );
    var ex = [ 5, 6 ];
    test.equivalent( x, ex );
    var y2 = _.Matrix.Mul( null, [ om, x ] );
    test.equivalent( y2, oy );
    test.identical( y, oy );

    /* */

    test.case = rname + ' . y array . Solve 3x3 system';

    var m = _.Matrix.MakeSquare
    ([
      +1, -1, +2,
      +2, +0, +2,
      -2, +0, -4,
    ]);

    var om = m.clone();
    var y = [ 7, 4, -10 ];
    var oy = y.slice();
    var x = _.Matrix[ rname ]( null, m, y );

    logger.log( 'm', m );
    logger.log( 'x', x );

    test.is( x !== y );
    test.identical( x, [ -1, -2, +3 ] );
    test.identical( y, oy );

    var y2 = _.Matrix.Mul( null, [ om, x ] );
    test.identical( y2, oy );

    /* */

    test.case = rname + ' . y vector . Solve 3x3 system';

    var m = _.Matrix.MakeSquare
    ([
      +1, -1, +2,
      +2, +0, +2,
      -2, +0, -4,
    ]);

    var om = m.clone();
    var y = _.vad.from([ 7, 4, -10 ]);
    var oy = y.clone();
    var x = _.Matrix[ rname ]( null, m, y );

    logger.log( 'm', m );
    logger.log( 'x', x );

    test.is( x !== y );
    test.identical( x, _.vad.from([ -1, -2, +3 ]) );
    test.identical( y, oy );

    var y2 = _.Matrix.Mul( null, [ om, x ] );
    test.identical( y2, y );

    /* */

    test.case = rname + ' . y matrix . Solve 3x3 system';

    var m = _.Matrix.MakeSquare
    ([
      +1, -1, +2,
      +2, +0, +2,
      -2, +0, -4,
    ]);

    var om = m.clone();
    var y = _.Matrix.MakeCol([ 7, 4, -10 ]);
    var oy = y.clone();
    var x = _.Matrix[ rname ]( null, m, y );

    logger.log( 'm', m );
    logger.log( 'x', x );

    test.is( x !== y );
    test.identical( x, _.Matrix.MakeCol([ -1, -2, +3 ]) );
    test.identical( y, oy );

    var y2 = _.Matrix.Mul( null, [ om, x ] );
    test.identical( y2, y );

    /* */

    test.case = rname + ' . x array . Solve 3x3 system';

    var m = _.Matrix.MakeSquare
    ([
      +1, -1, +2,
      +2, +0, +2,
      -2, +0, -4,
    ]);

    var om = m.clone();
    var y = _.vad.from([ 7, 4, -10 ]);
    var oy = y.clone();
    var ox = [ 0, 0, 0 ];
    var x = _.Matrix[ rname ]( ox, m, y );

    logger.log( 'm', m );
    logger.log( 'x', x );

    test.is( x !== y );
    test.is( x === ox );
    test.identical( x, [ -1, -2, +3 ] );
    test.identical( y, oy );

    var y2 = _.Matrix.Mul( null, [ om, x ] );
    test.identical( y2, [ 7, 4, -10 ] );

    /* */

    test.case = rname + ' . x vector . Solve 3x3 system';

    var m = _.Matrix.MakeSquare
    ([
      +1, -1, +2,
      +2, +0, +2,
      -2, +0, -4,
    ]);

    var om = m.clone();
    var y = [ 7, 4, -10 ];
    var oy = y.slice();
    var ox = _.vad.from([ 0, 0, 0 ]);
    var x = _.Matrix[ rname ]( ox, m, y );

    logger.log( 'm', m );
    logger.log( 'x', x );

    test.is( x !== y );
    test.is( x === ox );
    test.identical( x, _.vad.from([ -1, -2, +3 ]) );
    test.identical( y, oy );

    var y2 = _.Matrix.Mul( null, [ om, x ] );
    test.identical( y2, _.vad.from([ 7, 4, -10 ]) );

    /* */

    test.case = rname + ' . x matrix . Solve 3x3 system';

    var m = _.Matrix.MakeSquare
    ([
      +1, -1, +2,
      +2, +0, +2,
      -2, +0, -4,
    ]);

    var om = m.clone();
    var y = [ 7, 4, -10 ];
    var oy = y.slice();
    var ox = _.Matrix.MakeCol([ 0, 0, 0 ]);
    var x = _.Matrix[ rname ]( ox, m, y );

    logger.log( 'm', m );
    logger.log( 'x', x );

    test.is( x !== y );
    test.is( x === ox );
    test.identical( x, _.Matrix.MakeCol([ -1, -2, +3 ]) );
    test.identical( y, oy );

    var y2 = _.Matrix.Mul( null, [ om, x ] );
    test.identical( y2, _.Matrix.MakeCol([ 7, 4, -10 ]) );

    /* */

    test.case = rname + ' . y 3x2 matrix . Solve 3x3 system';

    var m = _.Matrix.MakeSquare
    ([
      +1, -1, +2,
      +2, +0, +2,
      -2, +0, -4,
    ]);

    var om = m.clone();
    var y = _.Matrix.Make([ 3, 2 ]).copy
    ([
      7, 3,
      4, 2,
      -10, 6,
    ]);
    var oy = y.clone();
    var x = _.Matrix[ rname ]( null, m, y );

    logger.log( 'm', m );
    logger.log( 'x', x );

    var xEpxpected = _.Matrix.Make([ 3, 2 ]).copy
    ([
      -1, +5,
      -2, -6,
      +3, -4,
    ]);

    test.is( x !== y );
    test.identical( x, xEpxpected );
    test.identical( y, oy );

    var y2 = _.Matrix.Mul( null, [ om, x ] );
    test.identical( y2, y );

    /* */

    test.case = rname + ' . y 0x2 matrix . Solve 0x0 system';

    var m = _.Matrix.MakeSquare([]);
    m.toStr();

    var om = m.clone();
    var y = _.Matrix.Make([ 0, 2 ]).copy([]);
    var oy = y.clone();
    var x = _.Matrix[ rname ]( null, m, y );

    logger.log( 'm', m );
    logger.log( 'x', x );

    var xEpxpected = _.Matrix.Make([ 0, 2 ]).copy([]);

    test.is( x !== y );
    test.identical( x, xEpxpected );
    test.identical( y, oy );

    var y2 = _.Matrix.Mul( null, [ om, x ] );
    test.identical( y2, y );

  }

}

SolveSimple.accuracy = _.accuracy*1e+1;

//

function SolvePermutating( test )
{

  act( 'Solve' );
  act( 'SolveWithGausianPermutating' );
  act( 'SolveWithGausianNormalizingPermutating' );
  act( 'SolveWithGaussJordanPermutating' );
  act( 'SolveWithGaussJordanNormalizingPermutating' );
  act( 'SolveWithTrianglesPermutating' );
  act( 'SolveWithTrianglesNormalizingPermutating' );

  function act( rname )
  {

    /* */

    test.case = rname + ' . y array . 3x3';

    var m = _.Matrix.MakeSquare
    ([
      +4, +2, +4,
      +4, +2, +2,
      +2, +2, +2,
    ]);

    var om = m.clone();
    var y = [ 1, 2, 3 ];
    var oy = y.slice();
    var x = _.Matrix[ rname ]( null, m, y );

    test.is( x !== y );
    test.identical( x, [ -0.5, +2.5, -0.5 ] );
    test.identical( y, oy );

    var y2 = _.Matrix.Mul( null, [ om, x ] );
    test.identical( y2, y );

    /* */

  }

}

SolvePermutating.accuracy = [ _.accuracy * 1e+1, 1e-1 ];

//

function SolveAccuracyProblem( test )
{

  act( 'Solve', true );
  act( 'SolveWithGausian' );
  act( 'SolveWithGausianNormalizing' );
  act( 'SolveWithGausianPermutating' );
  act( 'SolveWithGausianNormalizingPermutating' );
  act( 'SolveWithGaussJordan' );
  act( 'SolveWithGaussJordanNormalizing' );
  act( 'SolveWithGaussJordanPermutating' );
  act( 'SolveWithGaussJordanNormalizingPermutating' );
  act( 'SolveWithTriangles', true );
  act( 'SolveWithTrianglesNormalizing', true );
  act( 'SolveWithTrianglesPermutating', true );
  act( 'SolveWithTrianglesNormalizingPermutating', true );

  function act( rname, isLu )
  {

    /* */

    test.case = rname + ' . y array . 2x2 rank:1 . accuracy problem . no x';

    var m = _.Matrix.Make([ 2, 2 ]).copy
    ([
      +18, -6,
      +45, -15,
    ]);

    var om = m.clone();
    var o = { m }
    var x = _.Matrix[ rname ]( o );

    test.is( x === null );
    test.is( o.x === null );
    test.is( o.ox === null );
    test.is( o.y === null );
    test.is( o.oy === null );

    if( isLu )
    {
      test.equivalent( m.scalarGet([ 1, 1 ]), 0 );
    }
    else
    {
      test.equivalent( o.m.rowGet( 1 ), [ 0, 0 ] );
    }

    /* */

    // test.case = rname + ' . y array . 2x2 rank:1 . accuracy problem . with x';
    //
    // var m = _.Matrix.Make([ 2, 2 ]).copy
    // ([
    //   +18, -6,
    //   +45, -15,
    // ]);
    //
    // var y = [ 2, 5 ]
    // var oy = y.slice();
    // var om = m.clone();
    // var o = { m, y }
    // var x = _.Matrix[ rname ]( o );
    //
    // test.equivalent( x, [ 1 / 9, 0 ] );
    // test.is( x !== null );
    // test.is( o.x !== x );
    // test.equivalent( o.x, x );
    // test.is( o.ox === x );
    // test.equivalent( y, oy );
    // test.is( o.y === y );
    // test.is( o.y === o.oy );
    // test.is( o.y !== x );
    //
    // if( isLu )
    // {
    //   test.equivalent( m.scalarGet([ 1, 1 ]), 0 );
    // }
    // else
    // {
    //   test.equivalent( o.m.rowGet( 1 ), [ 0, 0 ] );
    // }
    //
    // var y2 = _.Matrix.Mul( null, [ om, x ] );
    // test.equivalent( y2, oy );

    /* */

  }

}

SolveAccuracyProblem.accuracy = [ _.accuracy * 1e+1, 1e-1 ];

//

function SolveGeneral( test )
{

  _.Matrix.ContextsForTesting({ onEach : eachAbstractCase, dups : [ 1 ] });

  specificCases();

  /* */

  function eachAbstractCase( op )
  {

    op.permutating = 0;
    op.withoutY = 0;
    abstractCases( op );

    op.permutating = 0;
    op.withoutY = 1;
    abstractCases( op );

    op.permutating = 1;
    op.withoutY = 1;
    abstractCases( op );

    op.permutating = 1;
    op.withoutY = 1;
    abstractCases( op );

  }

  /* */

  function abstractCases( op )
  {

    test.open( `permutating:${op.permutating}, format:${op.format}, withoutY:${op.withoutY}, dup:${op.dup}` );

    /* */

    test.case = `3x3, nkernel:0, nsolutions:1`;

    var exp =
    {
      nsolutions : 1,
      nkernel : 0,
      permutating : op.permutating,
      repermutatingSolution : 1,
      repermutatingTransformation : 0,
    }

    op.m = _.Matrix.Make([ 3, 3 ]).copy
    ([
      -1, +2, +0,
      -6, +6, +0,
      +0, +0, +3,
    ]);

    op.om = op.m.clone();

    op.y =  op.withoutY ? null : op.containerMake([ 1, 2, 3 ]);
    op.r = _.Matrix.SolveGeneral({ m : op.m, y : op.y, permutating : op.permutating });
    test.contains( op.r, exp );
    abstractCheck( op );

    // test.close( `permutating:${op.permutating}, format:${op.format}, withoutY:${op.withoutY}, dup:${op.dup}` );
    // debugger; return;

    /* */

    test.case = `3x3, nkernel:3, all zero, permutation required`;

    var exp =
    {
      nsolutions : Infinity,
      nkernel : 3,
      permutating : op.permutating,
      repermutatingSolution : 1,
      repermutatingTransformation : 0,
    }

    op.m = _.Matrix.MakeZero([ 3, 3 ]);

    op.om = op.m.clone();

    op.y =  op.withoutY ? null : op.containerMake([ 0, 0, 0 ]);
    op.r = _.Matrix.SolveGeneral({ m : op.m, y : op.y, permutating : op.permutating });
    test.contains( op.r, exp );
    abstractCheck( op );

    /* */

    if( op.permutating )
    {

      test.case = `3x3, nkernel:0, nsolutions:1, permutation required`;

      var exp =
      {
        nsolutions : 1,
        nkernel : 0,
        permutating : op.permutating,
        repermutatingSolution : 1,
        repermutatingTransformation : 0,
      }

      op.m = _.Matrix.Make([ 3, 3 ]).copy
      ([
        +4, +2, +4,
        +4, +2, +2,
        +2, +2, +2,
      ]);

      op.om = op.m.clone();

      op.y =  op.withoutY ? null : op.containerMake([ 1, 2, 3 ]);
      op.r = _.Matrix.SolveGeneral({ m : op.m, y : op.y, permutating : op.permutating });
      test.contains( op.r, exp );
      abstractCheck( op );

    }

    /* */

    test.case = `4x4, nkernel:3`;

    var exp =
    {
      nsolutions : Infinity,
      nkernel : 3,
      permutating : op.permutating,
      repermutatingSolution : 1,
      repermutatingTransformation : 0,
    }

    op.m = _.Matrix.Make([ 4, 4 ]).copy
    ([
      +4, +2, +1, +0,
      +0, +0, +0, +0,
      +0, +0, +0, +0,
      +0, +0, +0, +0,
    ]);

    op.om = op.m.clone();

    op.y =  op.withoutY ? null : op.containerMake([ 1, 0, 0, 0 ]);
    op.r = _.Matrix.SolveGeneral({ m : op.m, y : op.y, permutating : op.permutating });
    test.contains( op.r, exp );
    abstractCheck( op );

    /* */

    test.case = `1x4, nkernel:3, y:empty`;

    var exp =
    {
      nsolutions : Infinity,
      nkernel : 3,
      permutating : op.permutating,
      repermutatingSolution : 1,
      repermutatingTransformation : 0,
    }

    op.m = _.Matrix.Make([ 1, 4 ]).copy
    ([
      +4, +2, +1, +0,
    ]);

    op.om = op.m.clone();

    op.y =  op.withoutY ? null : op.containerMake([]);
    op.r = _.Matrix.SolveGeneral({ m : op.m, y : op.y, permutating : op.permutating });
    test.contains( op.r, exp );
    abstractCheck( op );

    /* */

    if( !op.withoutY )
    {

      test.case = `4x4, nkernel:0`;

      var exp =
      {
        nsolutions : 0,
        nkernel : 0,
        permutating : op.permutating,
        repermutatingSolution : 1,
        repermutatingTransformation : 0,
      }

      op.m = _.Matrix.Make([ 4, 4 ]).copy
      ([
        +4, +2, +1, +0,
        +0, +0, +0, +0,
        +0, +0, +0, +0,
        +0, +0, +0, +0,
      ]);

      op.om = op.m.clone();

      op.y =  op.withoutY ? null : op.containerMake([ 1, 2, 0, 0 ]);
      op.r = _.Matrix.SolveGeneral({ m : op.m, y : op.y, permutating : op.permutating });
      test.contains( op.r, exp );
      abstractCheck( op );

    }

    /* */

    test.case = `2x4, nkernel:2`;

    var exp =
    {
      nsolutions : Infinity,
      nkernel : 2,
      permutating : op.permutating,
      repermutatingSolution : 1,
      repermutatingTransformation : 0,
    }

    op.m = _.Matrix.Make([ 2, 4 ]).copy
    ([
      +1, +2, +2, +6,
      +0, +2, +4, +4,
    ]);

    op.om = op.m.clone();

    op.y =  op.withoutY ? null : op.containerMake([ 1, 2 ]);
    op.r = _.Matrix.SolveGeneral({ m : op.m, y : op.y, permutating : op.permutating });
    test.contains( op.r, exp );
    abstractCheck( op );

    /* */

    test.close( `permutating:${op.permutating}, format:${op.format}, withoutY:${op.withoutY}, dup:${op.dup}` );

  }

  /* */

  function specificCases()
  {

    /* */

    test.case = '2x4, nkernel : 1, permutating : 0, no y';

    var exp =
    {
      nsolutions : Infinity,
      nkernel : 1,
      okernel : 1,
      kernel : _.Matrix.Make([ 2, 1 ]).copy
      ([
        1 / 3,
        1,
      ]),
      m : _.Matrix.Make([ 2, 2 ]).copy
      ([
        +1, -1/3,
        +0, 0,
      ]),
      y : null,
      oy : null,
      x : null,
      ox : null,
      permutates : null,
      permutating : 0,
      normalizing : 1,
      repermutatingSolution : 1,
      repermutatingTransformation : 0,
      onPermutate : null,
      onPermutatePre : null,
    }

    var m = _.Matrix.Make([ 2, 2 ]).copy
    ([
      +18, -6,
      +45, -15,
    ]);

    var om = m.clone();

    var r = _.Matrix.SolveGeneral({ m, permutating : 0 });
    test.equivalent( r, exp );

    check( om, null, r );

    /* */

    test.case = '2x4, nkernel : 1, permutating : 0, no y, specified kernel and okernel';

    var exp =
    {
      nsolutions : Infinity,
      nkernel : 1,
      okernel : 2,
      kernel : _.Matrix.Make([ 2, 5 ]).copy
      ([
        0, 1 / 3, 0, 0, 0,
        0, 1    , 0, 0, 0,
      ]),
      m : _.Matrix.Make([ 2, 2 ]).copy
      ([
        +1, -1/3,
        +0, 0,
      ]),
      y : null,
      oy : null,
      x : null,
      ox : null,
      permutates : null,
      permutating : 0,
      normalizing : 1,
      repermutatingSolution : 1,
      repermutatingTransformation : 0,
      onPermutate : null,
      onPermutatePre : null,
    }

    var m = _.Matrix.Make([ 2, 2 ]).copy
    ([
      +18, -6,
      +45, -15,
    ]);

    var om = m.clone();

    var r = _.Matrix.SolveGeneral({ m, permutating : 0, kernel : _.Matrix.MakeZero([ 2, 5 ]), okernel : 1 });
    test.equivalent( r, exp );

    check( om, null, r );

    /* */

    test.case = '2x4, nkernel : 2, permutating : 0, no y';

    var exp =
    {
      nsolutions : Infinity,
      nkernel : 2,
      okernel : 2,
      kernel : _.Matrix.Make([ 4, 2 ]).copy /* zzz : factories should use defaut scalar type ? */
      ([
        +2, -2,
        -2, -2,
        +1, +0,
        +0, +1,
      ]),
      m : _.Matrix.Make([ 2, 4 ]).copy
      ([
        +1, +0, -2, +2,
        +0, +1, +2, +2,
      ]),
      y : null,
      oy : null,
      x : null,
      ox : null,
      permutates : null,
      permutating : 0,
      normalizing : 1,
      repermutatingSolution : 1,
      repermutatingTransformation : 0,
      onPermutate : null,
      onPermutatePre : null,
    }

    var m = _.Matrix.Make([ 2, 4 ]).copy
    ([
      +1, +2, +2, +6,
      +0, +2, +4, +4
    ]);

    var om = m.clone();

    var r = _.Matrix.SolveGeneral({ m, permutating : 0 });
    test.equivalent( r, exp );

    check( om, null, r );

    /* */

    test.case = '2x4, nkernel : 2, permutating : 0';

    var exp =
    {
      nsolutions : Infinity,
      nkernel : 2,
      okernel : 2,
      kernel : _.Matrix.Make([ 4, 2 ]).copy
      ([
        +2, -2,
        -2, -2,
        +1, +0,
        +0, +1,
      ]),
      m : _.Matrix.Make([ 2, 4 ]).copy
      ([
        +1, +0, -2, +2,
        +0, +1, +2, +2,
      ]),
      y : _.Matrix.MakeCol([ 1, 2, ]),
      oy : _.Matrix.MakeCol([ 1, 2, ]),
      x : _.Matrix.MakeCol([ -1, +1, +0, +0, ]),
      ox : _.Matrix.MakeCol([ -1, +1, +0, +0, ]),
      permutates : null,
      permutating : 0,
      normalizing : 1,
      repermutatingSolution : 1,
      repermutatingTransformation : 0,
      onPermutate : null,
      onPermutatePre : null,
    }

    var m = _.Matrix.Make([ 2, 4 ]).copy
    ([
      +1, +2, +2, +6,
      +0, +2, +4, +4
    ]);

    var om = m.clone();

    var y = _.Matrix.MakeCol([ 1, 2 ]);
    var r = _.Matrix.SolveGeneral({ m, y, permutating : 0 });
    test.equivalent( r, exp );
    test.equivalent( r.y, r.oy );
    test.is( y === r.y );
    test.is( y === r.oy );
    test.is( y !== r.x );
    test.is( y !== r.ox );

    check( om, y, r );

    /* */

    test.case = '2x4, nkernel : 2, permutating : 1';

    var exp =
    {
      nsolutions : Infinity,
      nkernel : 2,
      okernel : 2,
      kernel : _.Matrix.Make([ 4, 2 ]).copy
      ([
        +0.000, +1.000,
        +1.000, +0.000,
        -0.250, +0.250,
        -0.250, -0.250,
      ]),
      m : _.Matrix.Make([ 2, 4 ]).copy
      ([
        1.000, +0.000, +0.250, +0.250,
        0.000, +1.000, +0.250, -0.250,
      ]),
      y : _.Matrix.MakeCol([ 1, 2, ]),
      oy : _.Matrix.MakeCol([ 1, 2, ]),
      x : _.Matrix.MakeCol([ 0, 0, +0.5, 0, ]),
      ox : _.Matrix.MakeCol([ 0, 0, +0.5, 0, ]),
      permutates : [ [ 0, 1 ], [ 3, 2, 1, 0 ] ],
      permutating : 1,
      normalizing : 1,
      repermutatingSolution : 1,
      repermutatingTransformation : 0,
      onPermutate : _.Matrix._PermutateLineRook.body,
      onPermutatePre : _.Matrix._PermutateLineRook.pre,
      lineIndex : 1.00,
      npermutations : 2.00,
      nRowPermutations : 0.00,
      nColPermutations : 2.00
    }

    var m = _.Matrix.Make([ 2, 4 ]).copy
    ([
      +1, +2, +2, +6,
      +0, +2, +4, +4
    ]);

    var om = m.clone();

    var y = _.Matrix.MakeCol([ 1, 2 ]);
    var r = _.Matrix.SolveGeneral({ m, y, permutating : 1 });
    test.equivalent( r, exp );
    test.equivalent( r.y, r.oy );
    test.is( y === r.y );
    test.is( y === r.oy );
    test.is( y !== r.x );
    test.is( y !== r.ox );

    var nullspace = om.nullspace();
    test.identical( r.kernel, nullspace );

    check( om, y, r );

    /* */

    test.case = '3x4, nkernel : 0, permutating : 0';

    var exp =
    {
      nsolutions : 0,
      nkernel : 0,
      okernel : 0,
      kernel : _.Matrix.Make([ 4, 0 ]),
      m : _.Matrix.Make([ 3, 4 ]).copy
      ([
        +1, +0, -2, +2,
        +0, +1, +2, +2,
        +0, +0, +0, +0,
      ]),
      y : _.Matrix.MakeCol([ 1, 2, 3, ]),
      oy : _.Matrix.MakeCol([ 1, 2, 3 ]),
      x : _.Matrix.MakeCol([ -1, +1, +3, +0, ]),
      ox : _.Matrix.MakeCol([ -1, +1, +3, +0, ]),
      permutates : null,
      permutating : 0,
      normalizing : 1,
      repermutatingSolution : 1,
      repermutatingTransformation : 0,
      onPermutate : null,
      onPermutatePre : null,
    }

    var m = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +2, +2, +6,
      +0, +2, +4, +4,
      +0, +0, +0, +0,
    ]);

    var om = m.clone();

    var y = _.Matrix.MakeCol([ 1, 2, 3 ]);
    var r = _.Matrix.SolveGeneral({ m, y, permutating : 0 });
    test.equivalent( r, exp );
    test.equivalent( r.y, r.oy );
    test.is( y === r.y );
    test.is( y === r.oy );
    test.is( y !== r.x );
    test.is( y !== r.ox );

    check( om, y, r );

    /* */

  }

  /* */

  function specialSolutionCheck( m, y, r )
  {

    if( r.x === null )
    return;

    if( r.nsolutions === 0 )
    return;

    logger.log( `` );
    logger.log( `specialSolutionCheck` );
    test.description = `specialSolutionCheck`;

    var x2 = r.x;
    var y2 = _.Matrix.Mul( null, [ m, x2 ] );
    test.equivalent( y2, y );

    logger.log( `m * x2 = y2` );
    logger.log( 'm', m );
    logger.log( 'x2', x2 );
    logger.log( 'y2', y2 );
    logger.log( `` );

  }

  /* */

  function kernelCheck( m, r )
  {

    logger.log( `` );
    logger.log( `kernelCheck` );
    test.description = `kernelCheck`;

    var x2 = r.kernel;
    var y2 = _.Matrix.Mul( null, [ m, x2 ] );
    var exp = _.Matrix.MakeZero( y2.dims )
    test.equivalent( y2, exp );

    logger.log( `m * x2 = y2` );
    logger.log( 'm', m );
    logger.log( 'x2', x2 );
    logger.log( 'y2', y2 );
    logger.log( `` );

  }

  /* */

  function combinedSolutionCheck( m, y, r, d )
  {

    logger.log( `` );
    logger.log( `combinedSolutionCheck ${d}` );

    test.description = `combinedSolutionCheck ${d} - single`;
    let x2 = r.kernel.colGet( d ).clone();
    if( r.x !== null )
    x2.add( r.x.toVad() );
    let y2 = _.Matrix.Mul( null, [ m, x2 ] );
    test.equivalent( y2, y );

    let combination = _.dup( 1, r.kernel.ncol );
    combination[ d ] *= 10;
    test.description = `combinedSolutionCheck ${combination.join( ' ' )}`;
    let x3 = r.kernel.clone().mulRowWise( combination );
    if( r.x !== null )
    x3.add( r.x.toLong() );
    let y3 = _.Matrix.Mul( null, [ m, x3 ] );
    test.equivalent( y2, y );

    logger.log( `` );

  }

  /* */

  function check( m, y, r )
  {

    if( y === null )
    y = _.Matrix.MakeZero([ m.dims[ 0 ], 1 ]);
    else if( _.Matrix.DimsOf( y )[ 0 ] < m.dims[ 0 ] )
    y = _.Matrix.CopyTo( _.Matrix.MakeZero([ m.dims[ 0 ], 1 ]), y );

    kernelCheck( m, r );
    specialSolutionCheck( m, y, r );
    for( var d = 0 ; d < r.kernel.ncol ; d++ )
    {
      combinedSolutionCheck( m, y, r, d );
    }
  }

  /* */

  function abstractCheck( op )
  {

    test.equivalent( op.r.y, op.r.oy );
    test.is( op.y === op.r.y );
    test.is( op.y === op.r.oy );
    test.is( op.r.oy === null || op.containerIs( op.r.oy ) );
    if( !op.withoutY )
    {
      test.is( op.y !== op.r.x );
      test.is( op.y !== op.r.ox );
    }

    check( op.om, op.y, op.r );

  }

  /* */

}

SolveGeneral.accuracy = [ _.accuracy * 1e+2, 1e-1 ];

//

function invert( test )
{

  /* */

  test.case = 'inverted';

  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +0, -0.5, -0.5,
    -7, -3, +2,
    -3, -1, +1,
  ]);

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    -2, +2, -5,
    +2, -3, +7,
    -4, +3, -7,
  ]);

  var om = m.clone();
  var determinant = m.determinant();
  var inverted = m.invert( null );

  test.identical( m, om );
  test.equivalent( inverted, exp );
  test.equivalent( m.determinant(), determinant );

  /* */

  test.case = 'inverted';

  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +5/3, +1, -1/3,
    -11, -6, +5,
    +2, +1, -1,
  ]);

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +3, +2, +9,
    -3, -3, -14,
    +3, +1, +3,
  ]);

  var om = m.clone();
  var determinant = m.determinant();
  var inverted = m.invert( null );

  test.identical( m, om );
  test.equivalent( inverted, exp );
  test.equivalent( m.determinant(), determinant );

  /* */

  test.case = 'inverted';

  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    -1.5, +0.5, +0.5,
    +0, +3, -1,
    +1, +2, -1,
  ]);

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +2, -3, +4,
    +2, -2, +3,
    +6, -7, +9,
  ]);

  var om = m.clone();
  var determinant = m.determinant();
  var inverted = m.invert( null );

  test.equivalent( inverted, exp );
  test.equivalent( m.determinant(), determinant );

  /* */

  test.case = 'invert';

  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    -1.5, +0.5, +0.5,
    +0, +3, -1,
    +1, +2, -1,
  ]);

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +2, -3, +4,
    +2, -2, +3,
    +6, -7, +9,
  ]);

  var determinant = m.determinant();
  m.invert();

  test.equivalent( m, exp );
  test.equivalent( m.determinant(), 1/determinant );

}

invert.accuracy = [ _.accuracy * 1e+2, 1e-1 ];

//

function eigen( test )
{

  /* */

  test.case = '0x0';
  var op = {};
  var m = _.Matrix.Make([ 0, 0 ]);
  op.m = m.clone();
  op.determinant = m.determinant();
  test.equivalent( op.determinant, 0 );

  var exp = [];
  op.vals = m.eigenVals();
  test.equivalent( op.vals, exp );

  var exp = _.Matrix.Make([ 0, 0 ]);
  op.vectors = m.eigenVectors();
  test.equivalent( op.vectors, exp );
  test.is( _.Matrix.EquivalentColumnSpace( op.vectors, exp ) );
  check( op );

  /* */

  test.case = '1x1';
  var op = {};
  var m = _.Matrix.Make([ 1, 1 ]).copy
  ([
    13
  ]);
  op.m = m.clone();
  op.determinant = m.determinant();
  test.equivalent( op.determinant, 13 );

  var exp = [ 13 ];
  op.vals = m.eigenVals();
  test.equivalent( op.vals, exp );
  test.equivalent( _.vector.reduceToProduct( op.vals ), op.determinant );

  var exp = _.Matrix.Make([ 1, 1 ]).copy
  ([
    1
  ]);
  op.vectors = m.eigenVectors();
  test.equivalent( op.vectors, exp );
  test.is( _.Matrix.EquivalentColumnSpace( op.vectors, exp ) );
  check( op );

  /* */

  test.case = '2x2';
  var op = {};
  var m = _.Matrix.Make([ 2, 2 ]).copy
  ([
    +17, -6,
    +45, -16,
  ]);
  op.m = m.clone();
  op.determinant = m.determinant();
  test.equivalent( op.determinant, -2 );

  var exp = [ -1, +2 ];
  op.vals = m.eigenVals();
  test.equivalent( op.vals, exp );
  test.equivalent( _.vector.reduceToProduct( op.vals ), op.determinant );

  var exp = _.Matrix.Make([ 2, 2 ]).copy
  ([
    +1/3, +4/10,
    +1, +1,
  ]);
  op.vectors = m.eigenVectors();
  test.equivalent( op.vectors, exp );
  test.is( _.Matrix.EquivalentColumnSpace( op.vectors, exp ) );
  check( op );

  /* */

  test.case = '3x3'
  var op = {};
  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +5, +2, +0,
    +2, +5, +0,
    -3, +4, +6,
  ]);
  op.m = m.clone();
  op.determinant = m.determinant();
  test.equivalent( op.determinant, 126 );

  var exp = [ 3, 6, 7 ];
  op.vals = m.eigenVals();
  test.equivalent( op.vals, exp );
  test.equivalent( _.vector.reduceToProduct( op.vals ), op.determinant );

  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +0.4285714328289032, +0.000, +1.000,
    -0.4285714328289032, +0.000, +1.000,
    +1.000, +1.000, +1.000,
  ]);
  op.vectors = m.eigenVectors();
  test.equivalent( op.vectors, exp );
  test.is( _.Matrix.EquivalentColumnSpace( op.vectors, exp ) );
  check( op );

  /* */

  test.case = '3x3 - multiplicity 2'
  var op = {};
  op.generalizating = 0;
  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    -1, +2, +0,
    -6, +6, +0,
    +0, +0, +3,
  ]);
  op.m = m.clone();
  op.determinant = m.determinant();
  test.equivalent( op.determinant, 18 );

  var exp = [ 2, 3, 3 ];
  op.vals = m.eigenVals();
  test.equivalent( op.vals, exp );
  test.equivalent( _.vector.reduceToProduct( op.vals ), op.determinant );

  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    2/3, 0.5, 0.0,
    1.0, 1.0, 0.0,
    0.0, 0.0, 1.0,
  ]);
  op.vectors = m.eigenVectors({ generalizating : op.generalizating });
  test.equivalent( op.vectors, exp );
  test.is( _.Matrix.EquivalentColumnSpace( op.vectors, exp ) );
  check( op );

  /* */

  test.case = '2x2 - deffective, generalizating:0'
  var op = {};
  op.generalizating = 0;
  var m = _.Matrix.Make([ 2, 2 ]).copy
  ([
    +3, +2,
    +0, +3,
  ]);
  op.m = m.clone();
  op.determinant = m.determinant();
  test.equivalent( op.determinant, 9 );

  var exp = [ 3, 3 ];
  op.vals = m.eigenVals();
  test.equivalent( op.vals, exp );
  test.equivalent( _.vector.reduceToProduct( op.vals ), op.determinant );

  var exp = _.Matrix.Make([ 2, 2 ]).copy
  ([
    1, 0,
    0, 0,
  ]);
  op.vectors = m.eigenVectors({ generalizating : 0 });
  test.equivalent( op.vectors, exp );
  test.is( _.Matrix.EquivalentColumnSpace( op.vectors, exp ) );
  check( op );

  /* */

  test.case = '2x2 - deffective, generalizating:1'
  var op = {};
  op.generalizating = 1;
  var m = _.Matrix.Make([ 2, 2 ]).copy
  ([
    +3, +2,
    +0, +3,
  ]);
  op.m = m.clone();
  op.determinant = m.determinant();
  test.equivalent( op.determinant, 9 );

  var exp = [ 3, 3 ];
  op.vals = m.eigenVals();
  test.equivalent( op.vals, exp );
  test.equivalent( _.vector.reduceToProduct( op.vals ), op.determinant );

  var exp = _.Matrix.Make([ 2, 2 ]).copy
  ([
    1, 0,
    0, 0.5,
  ]);
  op.vectors = m.eigenVectors({ generalizating : 1 });
  test.equivalent( op.vectors, exp );
  test.is( _.Matrix.EquivalentColumnSpace( op.vectors, exp ) );
  check( op );

  /* */

  test.case = '3x3 - deffective, generalizating:0'
  var op = {};
  op.generalizating = 0;
  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +6, -2, -1,
    +3, +1, -1,
    +2, -1, +2,
  ]);
  op.m = m.clone();
  op.determinant = m.determinant();
  test.equivalent( op.determinant, 27 );

  var exp = [ 3, 3, 3 ];
  op.vals = m.eigenVals();
  test.equivalent( op.vals, exp );
  test.equivalent( _.vector.reduceToProduct( op.vals ), op.determinant );

  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, +0, +0,
    +1, +0, +0,
    +1, +0, +0,
  ]);
  op.vectors = m.eigenVectors({ generalizating : 0 });
  test.equivalent( op.vectors, exp );
  test.is( _.Matrix.EquivalentColumnSpace( op.vectors, exp ) );

  /* */

  test.case = '3x3 - deffective, generalizating:1'
  var op = {};
  op.generalizating = 1;
  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +6, -2, -1,
    +3, +1, -1,
    +2, -1, +2,
  ]);
  op.m = m.clone();
  op.determinant = m.determinant();
  test.equivalent( op.determinant, 27 );

  var exp = [ 3, 3, 3 ];
  op.vals = m.eigenVals();
  test.equivalent( op.vals, exp );
  test.equivalent( _.vector.reduceToProduct( op.vals ), op.determinant );

  var exp = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, +1, -1,
    +1, +1, -2,
    +1, +0, -0,
  ]);
  op.vectors = m.eigenVectors({ generalizating : 1 });
  test.equivalent( op.vectors, exp );
  test.is( _.Matrix.EquivalentColumnSpace( op.vectors, exp ) );
  check( op );

  /* */

  function check( op )
  {
    for( let i = 0 ; i < op.vectors.ncol ; i++ )
    {
      var vector = op.vectors.colGet( i );
      if( !op.generalizating || i === 0 )
      {
        var y1 = _.Matrix.Mul( null, [ op.m, vector ] );
        var y2 = vector.clone().mul( op.vals[ i ] );
        test.equivalent( y1, y2 );
      }
    }
    if( !op.generalizating )
    return;
    let m2 = op.m.clone();
    m2.diagonalGet().sub( op.vals[ 0 ] );
    for( let i = 1 ; i < op.vectors.ncol ; i++ )
    {
      var vector = op.vectors.colGet( i );
      var y = _.Matrix.Mul( null, [ m2, vector ] );
      var count = 0;
      op.vectors.lineEach( 0, ( it ) => it.line.equivalentWith( y, { accuracy : test.accuracy } ) ? count += 1 : undefined );
      test.ge( count, 1 );
    }
  }

}

eigen.accuracy = [ _.accuracy * 1e+1, 1e-1 ];

// --
// advanced
// --

function PolynomExactFor( test )
{

  function checkPolynom( polynom , f )
  {

    if( _.arrayIs( points ) )
    {
      for( var i = 0 ; i < f.length ; i++ )
      test.equivalent( _.avector.polynomApply( polynom , points[ i ][ 0 ] ) , points[ i ][ 1 ] );
      return;
    }

    var x = 0;
    test.equivalent( _.avector.polynomApply( polynom , x ) , f( x ) , 1e-3 );

    var x = 1;
    test.equivalent( _.avector.polynomApply( polynom , x ) , f( x ) , 1e-3 );

    var x = 5;
    test.equivalent( _.avector.polynomApply( polynom , x ) , f( x ) , 1e-3 );

    var x = 10;
    test.equivalent( _.avector.polynomApply( polynom , x ) , f( x ) , 1e-3 );

  }

  /* */

  test.case = 'PolynomExactFor for E( n )';

  /*
    1, 2, 6, 10, 15, 21, 28, 36
    E = c0 + c1*n + c2*n**2
    E = 0 + 0.5*n + 0.5*n**2
    E = ( n + n**2 ) * 0.5
  */

  var f = function( x )
  {
    var r = 0;
    for( var i = 0 ; i < x ; i++ )
    r += i;
    return r;
  }

  var polynom = _.Matrix.PolynomExactFor
  ({
    order : 3,
    domain : [ 1, 4 ],
    onFunction : f,
  });

  logger.log( polynom );
  test.equivalent( polynom, [ 0, -0.5, +0.5 ] );
  checkPolynom( polynom , f );

  /* */

  test.case = 'PolynomExactFor for E( n*n )';

  f = function( x )
  {
    var r = 0;
    for( var i = 0 ; i < x ; i++ )
    r += i*i;
    return r;
  }

  var polynom = _.Matrix.PolynomExactFor
  ({
    order : 4,
    domain : [ 1, 5 ],
    onFunction : f,
  });

  logger.log( polynom );
  test.equivalent( polynom, [ 0, 1/6, -1/2, 1/3 ] );
  checkPolynom( polynom , f );

  /* */

  test.case = 'PolynomExactFor for parabola';

  var points = [ [ -2, -1 ], [ 0, 2 ], [ 2, 3 ] ];

  var polynom = _.Matrix.PolynomExactFor
  ({
    order : 3,
    points,
  });

  logger.log( polynom );
  test.equivalent( polynom, [ 2, 1, -1/4 ] );
  checkPolynom( polynom , points );

}

PolynomExactFor.accuracy = [ _.accuracy * 1e+2, 1e-1 ];

//

function PolynomClosestFor( test )
{

  /* */

  test.case = 'PolynomClosestFor for E( i )';

  var polynom = _.Matrix.PolynomClosestFor
  ({
    order : 2,
    points : [ [ 1, 0.5 ], [ 2, 2.25 ], [ 3, 2 ] ],
  });

  logger.log( polynom );
  test.equivalent( polynom, [ 1/12, 3/4 ] );

}

PolynomClosestFor.accuracy = [ _.accuracy * 1e+1, 1e-1 ];

// --
// experiment
// --

function experiment( test )
{

  /* */

  test.case = 'basic';

  var exp =
  {
    nsolutions : 1,
    nkernel : 0,
    base : _.Matrix.MakeCol([ 0, 0, 0 ]),
    kernel : _.Matrix.MakeSquare
    ([
      +0, +0, +0,
      +0, +0, +0,
      +0, +0, +0,
    ]),
  }

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    -1, +2, +0,
    -6, +6, +0,
    +0, +0, +3,
  ]);

  var om = m.clone();
  var m2 = m.clone();
  // debugger;
  // m2.triangulateLu();
  // console.log( m );
  // console.log( m2 );
  // debugger;

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    -4, +2, +0,
    -6, +3, +0,
    +0, +0, +0,
  ]);

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +4, +2, +0,
    -6, -3, +0,
    +0, +0, +0,
  ]);

  var om = m.clone();
  var m2 = m.clone();

  var y = _.Matrix.MakeCol([ 0, 0, 0 ]);
  var r = _.Matrix.SolveGeneral({ m, y, permutating : 0 });
  logger.log( r );

  /* */

}

experiment.experimental = 1;

function equivalentBug( test )
{

  /* */

  test.case = 'Must be not equal, but it is... Matrix Matrix';

  var m1 = _.Matrix.Make([ 3, 3 ]).copy
  ([
    -1, +2, +0,
    -6, +6, +0,
    +0, +0, +3,
  ]);

  var m2 = _.Matrix.Make([ 0, 0 ])
  console.log(m1)
  console.log(m2)
  test.notEquivalent( m1, m2 )

  /* */

  test.case = 'Must be not equal, but it is... Matrix Long';

  var m1 = _.Matrix.Make([ 3, 3 ]).copy
  ([
    -1, +2, +0,
    -6, +6, +0,
    +0, +0, +3,
  ]);

  var m2 = []
  console.log(m1)
  console.log(m2)
  test.notEquivalent( m1, m2 )

  /* */

}

equivalentBug.experimental = 1;

function permutateFails( test )
{

  /* */

  test.case = 'permutateBackward fail';

  var exp = _.Matrix.Make([ 4, 2 ]).copy
  ([
    3, 4,
    5, 6,
    7, 8,
    1, 2,
  ]);

  var m = _.Matrix.Make([ 4, 2 ]).copy
  ([
    1, 2,
    3, 4,
    5, 6,
    7, 8
  ]);

  var original = m.clone();

  var permutates =
  [
    [ 1, 2, 3, 0 ],
    [ 0, 1 ],
  ]

  var permutatesExpected =
  [
    [ 1, 2, 3, 0 ],
    [ 0, 1 ],
  ]

  m.permutateForward( permutates );
  test.identical( m, exp );
  test.identical( permutates, permutatesExpected );

  m.permutateBackward( permutates );
  test.identical( m, original );
  test.identical( permutates, permutatesExpected );

  /* */

  test.case = 'permutateForward fail';

  var exp = _.Matrix.Make([ 4, 2 ]).copy
  ([
    7, 8,
    1, 2,
    3, 4,
    5, 6
  ]);

  var m = _.Matrix.Make([ 4, 2 ]).copy
  ([
    1, 2,
    3, 4,
    5, 6,
    7, 8
  ]);

  var original = m.clone();

  var permutates =
  [
    [ 3, 0, 1, 2 ],
    [ 0, 1 ],
  ]

  var permutatesExpected =
  [
    [ 3, 0, 1, 2 ],
    [ 0, 1 ],
  ]

  m.permutateForward( permutates );
  test.identical( m, exp );
  test.identical( permutates, permutatesExpected );

  m.permutateBackward( permutates );
  test.identical( m, original );
  test.identical( permutates, permutatesExpected );

  /* */

}

permutateFails.experimental = 1;

function myPermutate( test )
{

  /* */

  test.case = 'permutateBackward2 don\'t fail';

  var exp = _.Matrix.Make([ 4, 2 ]).copy
  ([
    3, 4,
    5, 6,
    7, 8,
    1, 2,
  ]);

  var m = _.Matrix.Make([ 4, 2 ]).copy
  ([
    1, 2,
    3, 4,
    5, 6,
    7, 8
  ]);

  var original = m.clone();

  var permutates =
  [
    [ 1, 2, 3, 0 ],
    [ 0, 1 ],
  ]

  var permutatesExpected =
  [
    [ 1, 2, 3, 0 ],
    [ 0, 1 ],
  ]

  m.permutateForward2( permutates );
  test.identical( m, exp );
  test.identical( permutates, permutatesExpected );

  m.permutateBackward2( permutates );
  test.identical( m, original );
  test.identical( permutates, permutatesExpected );

  /* */

  test.case = 'permutateForward2 don\'t fail';

  var exp = _.Matrix.Make([ 4, 2 ]).copy
  ([
    7, 8,
    1, 2,
    3, 4,
    5, 6
  ]);

  var m = _.Matrix.Make([ 4, 2 ]).copy
  ([
    1, 2,
    3, 4,
    5, 6,
    7, 8
  ]);

  var original = m.clone();

  var permutates =
  [
    [ 3, 0, 1, 2 ],
    [ 0, 1 ],
  ]

  var permutatesExpected =
  [
    [ 3, 0, 1, 2 ],
    [ 0, 1 ],
  ]

  m.permutateForward2( permutates );
  test.identical( m, exp );
  test.identical( permutates, permutatesExpected );

  m.permutateBackward2( permutates );
  test.identical( m, original );
  test.identical( permutates, permutatesExpected );

  /* */

}

myPermutate.experimental = 1;

// --
// declare
// --

let Self =
{

  name : 'Tools.Math.Matrix',
  silencing : 1,
  enabled : 1,
  routineTimeOut : 60000,

  context :
  {

    makeWithOffset,

  },

  tests :
  {

    // checker

    matrixIs,
    constructorIsMatrix,
    isDiagonal,
    isUpperTriangle,
    isSymmetric,
    EquivalentSpace,

    // equaler

    compareMatrices,
    compareMatrixAndVector,
    compareMatrixAndNot,

    // accessors

    scalarGet,
    scalarSet,
    eGet,
    eSet,

    // maker

    MakeChangeDimsLength,
    MakeChangeDimsType,
    MakeSquareChangeBufferLength,
    MakeSquareChangeBufferType,
    MakeZeroChangeDimsLength,
    MakeZeroChangeDimsType,
    MakeIdentityChangeDimsLength,
    MakeIdentityChangeDimsType,
    MakeIdentity2,
    MakeIdentity3,
    MakeIdentity4,
    MakeDiagonal,
    MakeSimilarMIsMatrixWithoutDims,
    MakeSimilarMIsMatrixWithDims,
    MakeSimilarDifferentBufferTypes,
    MakeSimilarWithVectors,
    MakeSimilarExperiment,
    MakeLineOptionZeroing0,
    MakeLineOptionZeroing1,
    MakeCol,
    MakeColZeroed,
    MakeRow,
    MakeRowZeroed,

    // constructor

    ConvertToClassSrcIsMatrix,
    ConvertToClassSrcIsNotMatrix,

    FromVector,
    FromScalarChangeDimsLength,
    FromScalarChangeDimsType,
    FromScalarForReadingChangeDimsLength,
    FromScalarForReadingChangeDimsType,
    FromSrcNullChangeDimsLength,
    FromExperiment,
    FromSrcNullChangeDimsType,
    FromSrcMatrix,
    FromSrcScalarChangeDimsLength,
    FromSrcScalarChangeDimsType,
    FromSrcVector,
    FromForReadingSrcMatrix,
    FromForReadingSrcScalarChangeDimsLength,
    FromForReadingSrcScalarChangeDimsType,
    ColFrom,
    RowFrom,

    make,
    makeHelper,
    makeMultyMatrix,
    from,
    bufferSetLarger,
    constructTransposing,
    constructWithInfinity,
    constructWithScalarsPerElement,
    constructWithoutBuffer,
    constructWithoutDims,
    constructDeducing,

    // exporter

    copyTransposing,
    copyClone,
    CopyToSrcIsNotMatrix,
    CopyToSrcIsMatrix,
    copy,
    copySubmatrix,
    copyInstanceInstance,
    clone,
    cloneSerializing,
    exportStructureToStructure,

    bufferExportDstBufferNullFullUsedMatrix,
    bufferExportDstBufferNullMatrixWithOffset,
    bufferExportDstBufferFullUsedMatrix,
    bufferExportDstBufferMatrixWithOffset,

    bufferImportOptionsReplacing1AndDims,
    bufferImportOptionsReplacing1WithoutDims,
    bufferImportOptionsReplacing0AndDims,
    bufferImportOptionsReplacing0WithoutDims,

    toStr,
    toStrStandard,
    toLong, /* qqq : extend, please */
    // log, /* zzz : implement later */
    // zzz : storage of options is requried for logging

    // setting

    bufferSetBasic,
    bufferSetResetOffset,
    bufferSetEmpty,
    bufferSetFromVectorAdapter,

    // utils

    StridesFromDimensions,
    TempBorrow,

    // structural

    offset,
    stride,
    strideNegative, /* qqq : extend */
    /* qqq : implement perfect coverage for field stride */
    bufferNormalize,
    expand,
    vectorToMatrix,
    accessors,
    lineNdGet, /* qqq : add 4d cases */
    lineNdGetIterate,

    /* iterators */

    scalarWhile,
    scalarWhileCheckingFields, 
    scalarEach,
    scalarEachCheckingFields,
    layerEach,
    layerEachCheckFields,
    lineEachStandardStrides,
    lineEachNonStandardStrides,
    lineEachCheckFields,

    partialAccessors,
    lineSwap,
    permutate,
    _PermutateLineRookWithoutOptionY,
    _PermutateLineRookWithOptionX,
    submatrix,
    submatrixSelectLast,
    subspace, /* qqq : extend, please */

    // operation

    mul,
    MulBasic, /* qqq : extend. add extreme cases. give me a link, please */
    MulSubmatirices,
    MulSeveral,
    AddBasic, /* qqq : extend. add extreme cases */

    addScalarWise,
    subScalarWise,
    reduceToMeanRowWise,
    colRowWiseOperations,
    mulColWise,
    mulRowWise,
    mulScalarWise,

    furthestClosest,
    matrixHomogenousApply,
    determinant,
    determinantWithLuBig,
    determinantWithBareissBig,
    // outerProductOfVectors,

    // solver

    triangulateGausian, /* qqq2 : write very similar test for methods of solver :

    TriangulateGausian,
    TriangulateGausianNormalizing,

    triangulateLu,
    triangulateLuNormalizing,

    SolveWithGausian,

    SolveWithGaussJordan,

    SolveWithTriangles,

    SolveTriangleLower,
    SolveTriangleLowerNormalized,
    SolveTriangleUpper,
    SolveTriangleUpperNormalized,

    qqq : don't delete old test routines for those routines

    */

    triangulateGausianNormalizing,
    triangulateGausianPermutating,
    triangulateLuBasic,
    triangulateLu,
    triangulateLuNormalizing,

    SolveTriangleLower,
    SolveTriangleUpper,
    SolveTriangleLowerNormalized,
    SolveTriangleUpperNormalized,
    SolveWithTriangles,

    SolveSimple,
    SolvePermutating,
    SolveAccuracyProblem,
    SolveGeneral,
    invert,

    eigen,

    // advanced

    PolynomExactFor,
    PolynomClosestFor,

    // experiments

    experiment,
    equivalentBug,
    permutateFails,
    myPermutate

  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_global_.wTester.test( Self.name );

})();
