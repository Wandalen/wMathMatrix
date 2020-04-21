( function _Matrix_test_s_( ) {

'use strict';

/*
*/

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../dwtools/Tools.s' );

  _.include( 'wTesting' );

  require( '../l5_matrix/module/full/Include.s' );

}

//

var _ = _global_.wTools.withDefaultLong.Fx;
var vad = _.vectorAdapter;
var vec = _.vectorAdapter.fromLong;
var fvec = function( src ){ return _.vectorAdapter.fromLong( new F32x( src ) ) }
var ivec = function( src ){ return _.vectorAdapter.fromLong( new I32x( src ) ) }
var avector = _.avector;

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
    inputTransposing : o.inputTransposing,
  });

  return m;
}

// --
// experiment
// --

function experiment( test )
{
  test.case = 'experiment';
  test.identical( 1, 1 );

  var m = _.Matrix.MakeSquare
  ([
    +3, +2, +10,
    -3, -3, -14,
    +3, +1, +3,
  ]);

}

experiment.experimental = 1;

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
    inputTransposing : 0,
    strides : [ 2, 6 ],
    dims : [ 3, 1 ],
  });
  var got = _.matrixIs( src );
  test.identical( got, true );
  var got = _.Matrix.Is( src );
  test.identical( got, true );

  /* */

}

//

function constructorIsMatrix( test )
{
  test.case = 'instance of _.Matrix';
  var src = new _.Matrix
  ({
    buffer : new F32x([ 0, 1, 2, 3, 4, 5, 6, 7 ]),
    offset : 1,
    scalarsPerElement : 3,
    inputTransposing : 0,
    strides : [ 2, 6 ],
    dims : [ 3, 1 ],
  });
  var got = _.constructorIsMatrix( src );
  test.identical( got, false );

  test.case = '_.Matrix';
  var got = _.constructorIsMatrix( _.Matrix );
  test.identical( got, true );
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
  var expected = false;

  var gotBool = m1.isDiagonal( );
  test.identical( gotBool, expected );

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
  var expected = false;

  var gotBool = m1.isDiagonal( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Not diagonal - Upper Triangular';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    1,   0,   3,   4,
    0, - 1,   2,   0,
    0,   0,   1, - 1,
    0,   0,   0,  0.5
  ]);
  var expected = false;

  var gotBool = m1.isDiagonal( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Not diagonal - Lower Triangular';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0.5,  0,   0,  0,
    1,  - 1,   0,  0,
    2,    0,   1,  0,
    - 1, 3.4, - 1, 2
  ]);
  var expected = false;

  var gotBool = m1.isDiagonal( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix not square';

  var m1 = _.Matrix.Make([ 4, 2 ]).copy
  ([
    0.5,  0,
    1,  - 1,
    2,    0,
    - 1, 3.4
  ]);
  var expected = false;

  var gotBool = m1.isDiagonal( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Diagonal';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0.5, 0, 0, 0,
    0, - 1, 0, 0,
    0,  0,  1, 0,
    0,  0, -0, 2
  ]);
  var expected = true;

  var gotBool = m1.isDiagonal( );
  test.identical( gotBool, expected );

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
  var expected = true;

  var gotBool = m1.isDiagonal( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Diagonal not square';

  var m1 = _.Matrix.Make([ 4, 3 ]).copy
  ([
    0.5, 0, 0,
    0, - 1, 0,
    0,  0,  1,
    0,  0, -0
  ]);
  var expected = true;

  var gotBool = m1.isDiagonal( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Zero matrix ';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0,  0, 0, 0,
    0,  0, 0, 0,
    0,  0,  0, 0,
    0,  0, -0, 0
  ]);
  var expected = true;

  var gotBool = m1.isDiagonal( );
  test.identical( gotBool, expected );

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
  var expected = false;

  var gotBool = m1.isUpperTriangle( );
  test.identical( gotBool, expected );

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
  var expected = false;

  var gotBool = m1.isUpperTriangle( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Not diagonal - Lower Triangular';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0.5,  0,   0,  0,
    1,  - 1,   0,  0,
    2,    0,   1,  0,
    - 1, 3.4, - 1, 2
  ]);
  var expected = false;

  var gotBool = m1.isUpperTriangle( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix not square';

  var m1 = _.Matrix.Make([ 4, 2 ]).copy
  ([
    0.5,  0,
    1,  - 1,
    2,    0,
    - 1, 3.4
  ]);
  var expected = false;

  var gotBool = m1.isUpperTriangle( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Upper Triangular';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    1,   0,   3,   4,
    0, - 1,   2,   0,
    0,   0,   1, - 1,
    0,   0,   0,  0.5
  ]);
  var expected = true;

  var gotBool = m1.isUpperTriangle( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Diagonal';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0.5, 0, 0, 0,
    0, - 1, 0, 0,
    0,  0,  1, 0,
    0,  0, -0, 2
  ]);
  var expected = true;

  var gotBool = m1.isUpperTriangle( );
  test.identical( gotBool, expected );

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
  var expected = true;

  var gotBool = m1.isUpperTriangle( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Upper Triangular not square';

  var m1 = _.Matrix.Make([ 4, 3 ]).copy
  ([
    0.5, 0, 0,
    0, - 1, 0,
    0,  0,  1,
    0,  0, -0
  ]);
  var expected = true;

  var gotBool = m1.isUpperTriangle( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Zero matrix ';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0,  0, 0, 0,
    0,  0, 0, 0,
    0,  0,  0, 0,
    0,  0, -0, 0
  ]);
  var expected = true;

  var gotBool = m1.isUpperTriangle( );
  test.identical( gotBool, expected );

  /* */

  if( !Config.debug )
  return;

  var m1 = 'matrix';
  test.shouldThrowErrorSync( () => m1.isUpperTriangle( ));
  var m1 = NaN;
  test.shouldThrowErrorSync( () => m1.isUpperTriangle( ));
  var m1 = null;
  test.shouldThrowErrorSync( () => m1.isUpperTriangle( ));
  var m1 = [ 0, 0, 0 ];
  test.shouldThrowErrorSync( () => m1.isUpperTriangle( ));
  var m1 = _.vectorAdapter.from([ 0, 0, 0 ]);
  test.shouldThrowErrorSync( () => m1.isUpperTriangle( ));

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
  var expected = false;

  var gotBool = m1.isSymmetric( );
  test.identical( gotBool, expected );

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
  var expected = false;

  var gotBool = m1.isSymmetric( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Lower Triangular';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0.5,  0,   0,  0,
    1,  - 1,   0,  0,
    2,    0,   1,  0,
    - 1, 3.4, - 1, 2
  ]);
  var expected = false;

  var gotBool = m1.isSymmetric( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Upper Triangular';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    1,   0,   3,   4,
    0, - 1,   2,   0,
    0,   0,   1, - 1,
    0,   0,   0,  0.5
  ]);
  var expected = false;

  var gotBool = m1.isSymmetric( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Not Squared';

  var m1 = _.Matrix.Make([ 3, 4 ]).copy
  ([
    1,   0,   3,   4,
    0, - 1,   2,   0,
    3,   2,   1, - 1,
  ]);
  var expected = false;

  var gotBool = m1.isSymmetric( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Diagonal';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0.5, 0, 0, 0,
    0, - 1, 0, 0,
    0,  0,  1, 0,
    0,  0, -0, 2
  ]);
  var expected = true;

  var gotBool = m1.isSymmetric( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Symmetric';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0.5, 5, 8, 0.1,
    5, - 1, 2, 8,
    8,  2,  1, 0,
    0.1,  8, -0, 2
  ]);
  var expected = true;

  var gotBool = m1.isSymmetric( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Zero matrix ';

  var m1 = _.Matrix.Make([ 4, 4 ]).copy
  ([
    0,  0, 0, 0,
    0,  0, 0, 0,
    0,  0,  0, 0,
    0,  0, -0, 0
  ]);
  var expected = true;

  var gotBool = m1.isSymmetric( );
  test.identical( gotBool, expected );

  /* */

  if( !Config.debug )
  return;

  var m1 = 'matrix';
  test.shouldThrowErrorSync( () => m1.isSymmetric( ));
  var m1 = NaN;
  test.shouldThrowErrorSync( () => m1.isSymmetric( ));
  var m1 = null;
  test.shouldThrowErrorSync( () => m1.isSymmetric( ));
  var m1 = [ 0, 0, 0 ];
  test.shouldThrowErrorSync( () => m1.isSymmetric( ));
  var m1 = _.vectorAdapter.from([ 0, 0, 0 ]);
  test.shouldThrowErrorSync( () => m1.isSymmetric( ));

}

// --
//
// --

function env( test )
{

  test.is( _.routineIs( _.Matrix ) );
  test.is( _.objectIs( vad ) );
  test.is( _.objectIs( avector ) );

}

//

function clone( test )
{

  /* */

  test.case = 'make';

  var buffer = new F32x([ 1, 2, 3, 4, 5, 6 ]);
  var a = new _.Matrix
  ({
    buffer,
    dims : [ 3, 2 ],
    inputTransposing : 0,
  });

  /* */

  test.case = 'clone';

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

  test.case = 'set buffer';

  a.buffer = new F32x([ 11, 12, 13 ]);

  test.identical( a.size, 12 );
  test.identical( a.sizeOfElementStride, 12 );
  test.identical( a.sizeOfElement, 12 );
  test.identical( a.sizeOfCol, 12 );
  test.identical( a.sizeOfRow, 4 );
  test.identical( a.dims, [ 3, 1 ] );
  test.identical( a.length, 1 );

  test.identical( a.stridesEffective, [ 1, 3 ] );
  test.identical( a.strideOfElement, 3 );
  test.identical( a.strideOfCol, 3 );
  test.identical( a.strideInCol, 1 );
  test.identical( a.strideOfRow, 1 );
  test.identical( a.strideInRow, 3 );

  logger.log( a );

  /* */

  test.case = 'set dimension';

  a.dims = [ 1, 3 ];

  test.identical( a.size, 12 );
  test.identical( a.sizeOfElementStride, 4 );
  test.identical( a.sizeOfElement, 4 );
  test.identical( a.sizeOfCol, 4 );
  test.identical( a.sizeOfRow, 12 );
  test.identical( a.dims, [ 1, 3 ] );
  test.identical( a.length, 3 );

  test.identical( a.stridesEffective, [ 1, 1 ] );
  test.identical( a.strideOfElement, 1 );
  test.identical( a.strideOfCol, 1 );
  test.identical( a.strideInCol, 1 );
  test.identical( a.strideOfRow, 1 );
  test.identical( a.strideInRow, 1 );

  logger.log( a );

  /* */

  test.case = 'copy buffer and dims';

  a.dims = [ 1, 3 ];
  a.copy({ buffer : new F32x([ 3, 4, 5 ]), dims : [ 3, 1 ] });

  test.identical( a.size, 12 );
  test.identical( a.sizeOfElementStride, 12 );
  test.identical( a.sizeOfElement, 12 );
  test.identical( a.sizeOfCol, 12 );
  test.identical( a.sizeOfRow, 4 );
  test.identical( a.dims, [ 3, 1 ] );
  test.identical( a.length, 1 );

  test.identical( a.stridesEffective, [ 1, 3 ] );
  test.identical( a.strideOfElement, 3 );
  test.identical( a.strideOfCol, 3 );
  test.identical( a.strideInCol, 1 );
  test.identical( a.strideOfRow, 1 );
  test.identical( a.strideInRow, 3 );

  logger.log( a );

  /* */

  test.case = 'copy dims and buffer';

  a.dims = [ 1, 3 ];
  a.copy({ dims : [ 3, 1 ], buffer : new F32x([ 3, 4, 5 ]) });

  test.identical( a.size, 12 );
  test.identical( a.sizeOfElementStride, 12 );
  test.identical( a.sizeOfElement, 12 );
  test.identical( a.sizeOfCol, 12 );
  test.identical( a.sizeOfRow, 4 );
  test.identical( a.dims, [ 3, 1 ] );
  test.identical( a.length, 1 );

  test.identical( a.stridesEffective, [ 1, 3 ] );
  test.identical( a.strideOfElement, 3 );
  test.identical( a.strideOfCol, 3 );
  test.identical( a.strideInCol, 1 );
  test.identical( a.strideOfRow, 1 );
  test.identical( a.strideInRow, 3 );

  logger.log( a );
}

//

function construct( test )
{

  /* */

  test.case = 'creating';

  var a = new _.Matrix
  ({
    buffer : new F32x([ 0, 1, 2, 3, 4, 5, 6, 7 ]),
    offset : 1,
    scalarsPerElement : 3,
    inputTransposing : 0,
    strides : [ 2, 6 ],
    dims : [ 3, 1 ],
  });

  logger.log( a );

  test.identical( a.size, 12 );
  test.identical( a.sizeOfElementStride, 24 );
  test.identical( a.sizeOfElement, 12 );
  test.identical( a.sizeOfCol, 12 );
  test.identical( a.sizeOfRow, 4 );
  test.identical( a.dims, [ 3, 1 ] );
  test.identical( a.length, 1 );

  test.identical( a.stridesEffective, [ 2, 6 ] );
  test.identical( a.strideOfElement, 6 );
  test.identical( a.strideOfCol, 6 );
  test.identical( a.strideInCol, 2 );
  test.identical( a.strideOfRow, 2 );
  test.identical( a.strideInRow, 6 );

  /* */

  test.case = 'serializing clone';

  var cloned = a.cloneSerializing();

  test.identical( cloned.data.inputTransposing, 0 );

  var expected =
  {
    "data" :
    {
      "dims" : [ 3, 1 ],
      "growingDimension" : 1,
      "inputTransposing" : 0,
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

  test.identical( cloned, expected );

  /* */

  test.case = 'deserializing clone';

  var b = new _.Matrix({ buffer : new F32x(), inputTransposing : true });
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

  test.case = 'creating';

  var a = new _.Matrix
  ({
    buffer : new F32x([ 0, 1, 2, 3, 4, 5, 6, 7 ]),
    offset : 1,
    scalarsPerElement : 3,
    inputTransposing : 1,
    strides : [ 2, 6 ],
  });

  logger.log( a );

  test.identical( a.size, 12 );
  test.identical( a.sizeOfElementStride, 24 );
  test.identical( a.sizeOfElement, 12 );
  test.identical( a.sizeOfCol, 12 );
  test.identical( a.sizeOfRow, 4 );
  test.identical( a.dims, [ 3, 1 ] );
  test.identical( a.length, 1 );

  test.identical( a.stridesEffective, [ 2, 6 ] );
  test.identical( a.strideOfElement, 6 );
  test.identical( a.strideOfCol, 6 );
  test.identical( a.strideInCol, 2 );
  test.identical( a.strideOfRow, 2 );
  test.identical( a.strideInRow, 6 );

  /* */

  test.case = 'serializing clone';

  var cloned = a.cloneSerializing();

  test.identical( cloned.data.inputTransposing, 1 );

  var expected =
  {
    "data" :
    {
      "dims" : [ 3, 1 ],
      "growingDimension" : 1,
      "inputTransposing" : 1,
      "buffer" : `--buffer-->0<--buffer--`,
      "offset" : 0,
      "strides" : [ 1, 1 ]
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

  test.identical( cloned, expected );

  /* */

  test.case = 'deserializing clone';

  var b = new _.Matrix({ buffer : new F32x(), inputTransposing : true });
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

  test.identical( b.strides, [ 1, 1 ] );
  test.identical( b.stridesEffective, [ 1, 1 ] );
  test.identical( b.strideOfElement, 1 );
  test.identical( b.strideOfCol, 1 );
  test.identical( b.strideInCol, 1 );
  test.identical( b.strideOfRow, 1 );
  test.identical( b.strideInRow, 1 );

  /* */

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
      inputTransposing : 1,
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
    test.identical( m.reduceToSumAtomWise(), 21 );
    test.identical( m.reduceToProductAtomWise(), 720 );

    /* */

    test.case = 'matrix with dimensions without stride, non transposing';

    var m = new _.Matrix
    ({
      inputTransposing : 0,
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
    test.identical( m.reduceToSumAtomWise(), 21 );
    test.identical( m.reduceToProductAtomWise(), 720 );

    /* */

    test.case = 'column with dimensions without stride, transposing';

    var m = new _.Matrix
    ({
      inputTransposing : 1,
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
    test.identical( m.reduceToSumAtomWise(), 6 );
    test.identical( m.reduceToProductAtomWise(), 6 );

    /* */

    test.case = 'column with dimensions without stride, non transposing';

    var m = new _.Matrix
    ({
      inputTransposing : 0,
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
    test.identical( m.reduceToSumAtomWise(), 6 );
    test.identical( m.reduceToProductAtomWise(), 6 );

    /* */

    test.case = 'matrix with breadth, transposing';

    var m = new _.Matrix
    ({
      inputTransposing : 1,
      breadth : [ 2 ],
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
    test.identical( m.reduceToSumAtomWise(), 21 );
    test.identical( m.reduceToProductAtomWise(), 720 );

    /* */

    test.case = 'matrix with breadth, non transposing';

    var m = new _.Matrix
    ({
      inputTransposing : 0,
      breadth : [ 2 ],
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
    test.identical( m.reduceToSumAtomWise(), 21 );
    test.identical( m.reduceToProductAtomWise(), 720 );

    /* */

    test.case = 'construct empty matrix with dims defined';

    var m = new _.Matrix({ buffer : o.arrayMake(), offset : o.offset, inputTransposing : 0, dims : [ 1, 0 ] });

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
    test.identical( m.reduceToSumAtomWise(), 0 );
    test.identical( m.reduceToProductAtomWise(), 1 );

    /* */

    test.case = 'construct empty matrix';

    var m = new _.Matrix({ buffer : o.arrayMake(), offset : o.offset, inputTransposing : 0 });

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
    test.identical( m.reduceToSumAtomWise(), 0 );
    test.identical( m.reduceToProductAtomWise(), 1 );

    if( Config.debug )
    {

      test.shouldThrowErrorSync( () => m.colGet( 0 ) );
      test.shouldThrowErrorSync( () => m.lineGet( 0, 0 ) );
      test.shouldThrowErrorSync( () => m.eGet( 0 ) );

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
      test.identical( m.breadth, [ 3 ] );
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

      test.identical( r1, vec( new m.buffer.constructor([]) ) );
      test.identical( r1, r2 );
      test.identical( r1, r3 );
      test.identical( m.reduceToSumAtomWise(), 0 );
      test.identical( m.reduceToProductAtomWise(), 1 );
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
      inputTransposing : 0,
      dims : [ 3, 0 ],
    });
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongColNonTransposing( m );

    var m = _.Matrix.Make([ 3, 0 ]);
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongColNonTransposing( m );
    test.identical( m.strides, null );

    test.description = 'change by empty buffer of empty matrix with long column, non transposing';

    m.buffer = new I32x();
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongColNonTransposing( m );

    test.description = 'change by empty buffer of empty matrix with long column, non transposing, with copy';

    m.copy({ buffer : o.arrayMake(), offset : o.offset });
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongColNonTransposing( m );

    test.description = 'change buffer of empty matrix with long column, non transposing';

    m.copy({ buffer : o.arrayMake([ 1, 2, 3 ]), offset : o.offset });
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
    test.identical( m.reduceToSumAtomWise(), 6 );
    test.identical( m.reduceToProductAtomWise(), 6 );

    test.description = 'change buffer of not empty matrix with long column, non transposing';

    m.copy({ buffer : o.arrayMake([ 1, 2, 3, 4, 5, 6 ]), offset : o.offset });
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
    test.identical( m.reduceToSumAtomWise(), 21 );
    test.identical( m.reduceToProductAtomWise(), 720 );

    /* */

    test.case = 'construct empty matrix with long column, transposing';

    function checkEmptyMatrixWithLongColTransposing( m )
    {

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

      var r1 = m.rowGet( 0 );
      var r2 = m.rowGet( 1 );
      var r3 = m.lineGet( 1, 0 );

      console.log( r1.toStr() );
      console.log( o.vec([]) );

      test.identical( r1, o.vec([]) );
      test.identical( r1, r2 );
      test.identical( r1, r3 );
      test.identical( m.reduceToSumAtomWise(), 0 );
      test.identical( m.reduceToProductAtomWise(), 1 );
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
      inputTransposing : 1,
      dims : [ 3, 0 ],
    });

    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongColTransposing( m );

    /* */

    test.description = 'change by empty buffer of empty matrix with long column, transposing';

    var m = new _.Matrix
    ({
      buffer : new I32x(),
      inputTransposing : 1,
      dims : [ 3, 0 ],
    });
    m.buffer = new I32x();
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongColTransposing( m );

    /* */

    test.description = 'change by empty buffer of empty matrix with long column, transposing, by copy';

    m.copy({ buffer : o.arrayMake([]), offset : o.offset });
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongColTransposing( m );

    /* */

    test.description = 'change buffer of empty matrix with long column, transposing';

    m.copy({ buffer : o.arrayMake([ 1, 2, 3 ]), offset : o.offset });
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
    test.identical( m.reduceToSumAtomWise(), 6 );
    test.identical( m.reduceToProductAtomWise(), 6 );

    test.description = 'change buffer of empty matrix with long column, transposing';

    m.copy({ buffer : o.arrayMake([ 1, 2, 3, 4, 5, 6 ]), offset : o.offset });
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
    test.identical( m.reduceToSumAtomWise(), 21 );
    test.identical( m.reduceToProductAtomWise(), 720 );

    /* */

    test.case = 'construct empty matrix with long row, transposing';

    function checkEmptyMatrixWithLongRowTransposing( m )
    {

      test.identical( m.size, 0 );
      test.identical( m.sizeOfElement, 0 );
      test.identical( m.sizeOfCol, 0 );
      test.identical( m.sizeOfRow, 12 );
      test.identical( m.dims, [ 0, 3 ] );
      test.identical( m.length, 3 );

      test.identical( m.stridesEffective, [ 3, 1 ] );
      test.identical( m.strideOfElement, 1 );
      test.identical( m.strideOfCol, 1 );
      test.identical( m.strideInCol, 3 );
      test.identical( m.strideOfRow, 3 );
      test.identical( m.strideInRow, 1 );

      var c1 = m.colGet( 0 );
      var c2 = m.colGet( 1 );
      var c3 = m.lineGet( 0, 0 );
      var e = m.eGet( 2 );

      test.identical( c1, o.vec([]) );
      test.identical( c1, c2 );
      test.identical( c1, c3 );
      test.identical( e, o.vec([]) );
      test.identical( m.reduceToSumAtomWise(), 0 );
      test.identical( m.reduceToProductAtomWise(), 1 );
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
      inputTransposing : 1,
      dims : [ 0, 3 ],
    });
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongRowTransposing( m );
    test.shouldThrowErrorSync( () => m.buffer = new I32x() );

    /* */

    test.case = 'change by empty buffer of empty matrix with long row, transposing';

    var m = new _.Matrix
    ({
      buffer : o.arrayMake(),
      inputTransposing : 1,
      growingDimension : 0,
      dims : [ 0, 3 ],
    });

    m.buffer = new I32x();
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongRowTransposing( m );

    m.copy({ buffer : o.arrayMake([]), offset : o.offset });
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongRowTransposing( m );

    test.description = 'change by non empty buffer of empty matrix with long row, transposing';

    m.copy({ buffer : o.arrayMake([ 1, 2, 3 ]), offset : o.offset });
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
    test.identical( m.reduceToSumAtomWise(), 6 );
    test.identical( m.reduceToProductAtomWise(), 6 );

    test.description = 'change by non empty buffer of non empty matrix with long row, transposing';

    m.copy({ buffer : o.arrayMake([ 1, 2, 3, 4, 5, 6 ]), offset : o.offset });
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
    test.identical( m.reduceToSumAtomWise(), 21 );
    test.identical( m.reduceToProductAtomWise(), 720 );

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

      test.identical( c1, vec( new m.buffer.constructor([]) ) );
      test.identical( c1, c2 );
      test.identical( c1, c3 );
      test.identical( e, vec( new m.buffer.constructor([]) ) );
      test.identical( m.reduceToSumAtomWise(), 0 );
      test.identical( m.reduceToProductAtomWise(), 1 );
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
      inputTransposing : 0,
      dims : [ 0, 3 ],
    });
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongRowNonTransposing( m );

    var m = _.Matrix.Make([ 0, 3 ]);
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongRowNonTransposing( m );
    test.identical( m.strides, null );

    var m = _.Matrix.Make([ 0, 3 ]);
    test.shouldThrowErrorSync( () => m.buffer = new I32x() );

    /* */

    test.case = 'change by empty buffer of empty matrix with long row, non transposing';

    var m = _.Matrix.Make([ 0, 3 ]);
    m.growingDimension = 0;
    m.buffer = new I32x();
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongRowNonTransposing( m );

    test.description = 'change by empty buffer of empty matrix with long row, non transposing, by copy';

    m.copy({ buffer : o.arrayMake([]), offset : o.offset });
    logger.log( 'm\n' + _.toStr( m ) );
    checkEmptyMatrixWithLongRowNonTransposing( m );

    test.description = 'change by non empty buffer of empty matrix with long row, non transposing';

    m.growingDimension = 0;
    m.copy({ buffer : o.arrayMake([ 1, 2, 3 ]), offset : o.offset });
    logger.log( 'm\n' + _.toStr( m ) );

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
    test.identical( m.reduceToSumAtomWise(), 6 );
    test.identical( m.reduceToProductAtomWise(), 6 );

    test.description = 'change by non empty buffer of non empty matrix with long row, non transposing';

    m.growingDimension = 0;
    m.copy({ buffer : o.arrayMake([ 1, 2, 3, 4, 5, 6 ]), offset : o.offset });
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
    test.identical( m.reduceToSumAtomWise(), 21 );
    test.identical( m.reduceToProductAtomWise(), 720 );

    /* */

    test.case = 'construct matrix with only buffer';

    var m = new _.Matrix
    ({
      buffer : o.arrayMake([ 1, 2, 3 ]),
      offset : o.offset,
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
    test.identical( m.reduceToSumAtomWise(), 6 );
    test.identical( m.reduceToProductAtomWise(), 6 );

    /* */

    test.case = 'construct matrix without buffer';

    if( Config.debug )
    {

      test.shouldThrowErrorSync( () => new _.Matrix({ offset : o.offset, }) );

    }

    /* */

    test.case = 'construct matrix with buffer and strides';

    if( Config.debug )
    {

      var buffer = new I32x
      ([
        1, 2, 3,
        4, 5, 6,
      ]);
      test.shouldThrowErrorSync( () => new _.Matrix({ buffer, strides : [ 1, 3 ] }) );

    }

    /* */

    test.case = 'construct empty matrix with dimensions, non transposing';

    var m = new _.Matrix
    ({
      buffer : o.arrayMake(),
      dims : [ 3, 0 ],
      inputTransposing : 0,
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
    test.identical( m.reduceToSumAtomWise(), 0 );
    test.identical( m.reduceToProductAtomWise(), 1 );

    m.copy({ buffer : o.arrayMake([ 1, 2, 3, 4, 5, 6 ]), offset : o.offset });
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
    test.identical( m.reduceToSumAtomWise(), 21 );
    test.identical( m.reduceToProductAtomWise(), 720 );

    /* */

    test.case = 'construct empty matrix with dimensions, transposing';

    var m = new _.Matrix
    ({
      buffer : o.arrayMake(),
      dims : [ 3, 0 ],
      inputTransposing : 1,
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

    m.copy({ buffer : o.arrayMake([ 1, 2, 3, 4, 5, 6 ]), offset : o.offset });
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
    test.identical( m.reduceToSumAtomWise(), 21 );
    test.identical( m.reduceToProductAtomWise(), 720 );

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

    test.identical( r1, vec( new F32x([ 4, 5, 6 ]) ) );
    test.identical( r1, r2 );
    test.identical( c1, vec( new F32x([ 2, 5 ]) ) );
    test.identical( c1, c2 );
    test.identical( e, vec( new F32x([ 2, 5 ]) ) );
    test.identical( a1, 5 );
    test.identical( a2, 5 );
    test.identical( m.reduceToSumAtomWise(), 21 );
    test.identical( m.reduceToProductAtomWise(), 720 );

    test.identical( m.strides, null );
    test.is( m.buffer instanceof F32x );

    /* */

    test.case = 'copy buffer from scalar';

    var m = _.Matrix.MakeSquare([ 1, 2, 3, 4 ]);
    var expected = _.Matrix.MakeSquare([ 13, 13, 13, 13 ]);

    m.copy( 13 );
    test.identical( m, expected );

    var m = _.Matrix.MakeSquare([]);
    var expected = _.Matrix.MakeSquare([]);

    m.copy( 13 );
    test.identical( m, expected );

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
      inputTransposing : 1,
    });

    test.is( m.buffer.length-( o.offset||0 ) === 9 );
    test.is( m.buffer instanceof F32x );

    var expected = _.Matrix.Make([ 3, 3 ]).copy
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

    test.identical( m, expected );
    test.is( m.buffer.length === 9+( o.offset||0 ) );
    test.is( m.buffer instanceof F32x );

    m.copy
    ( new U32x([
      1, 2, 3,
      4, 5, 6,
      7, 8, 9,
    ]));

    test.identical( m, expected );
    test.is( m.buffer.length === 9+( o.offset||0 ) );
    test.is( m.offset === ( o.offset||0 ) );
    test.is( m.buffer instanceof F32x );

    m.copy
    ({
      offset : 0,
      buffer : new U32x
      ([
        1, 2, 3,
        4, 5, 6,
        7, 8, 9,
      ]),
    });

    test.notIdentical( m, expected );
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

  test.identical( m.strides, null );
  test.is( m.buffer instanceof F32x );

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

  test.identical( m.size, 36 );
  test.identical( m.sizeOfElement, 12 );
  test.identical( m.sizeOfCol, 12 );
  test.identical( m.sizeOfRow, 12 );
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

  test.identical( r1, fvec([ 4, 5, 6 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 2, 5, 8 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 2, 5, 8 ]) );
  test.identical( a1, 5 );
  test.identical( a2, 5 );
  test.identical( m.reduceToSumAtomWise(), 45 );
  test.identical( m.reduceToProductAtomWise(), 362880 );
  test.identical( m.determinant(), 0 );

  test.is( m.buffer instanceof F32x );
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
  test.identical( m.reduceToSumAtomWise(), 6 );
  test.identical( m.reduceToProductAtomWise(), 0 );
  test.identical( m.determinant(), 6 );

  test.is( m.buffer instanceof F32x );
  test.identical( m.strides, null );

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
  test.identical( m.reduceToSumAtomWise(), 3 );
  test.identical( m.reduceToProductAtomWise(), 0 );
  test.identical( m.determinant(), 1 );

  test.is( m.buffer instanceof F32x );
  test.identical( m.strides, null );

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
  test.identical( m.reduceToSumAtomWise(), 2 );
  test.identical( m.reduceToProductAtomWise(), 0 );

  test.is( m.buffer instanceof F32x );
  test.identical( m.strides, null );

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
  test.identical( m.reduceToSumAtomWise(), 2 );
  test.identical( m.reduceToProductAtomWise(), 0 );

  test.is( m.buffer instanceof F32x );
  test.identical( m.strides, null );

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
  test.identical( m.reduceToSumAtomWise(), 0 );
  test.identical( m.reduceToProductAtomWise(), 0 );
  test.identical( m.determinant(), 0 );

  test.is( m.buffer instanceof F32x );
  test.identical( m.strides, null );

  //

  function checkNull( m )
  {

    logger.log( 'm\n' + _.toStr( m ) );

    test.identical( m.size, 0 );
    test.identical( m.sizeOfElement, 0 );
    test.identical( m.sizeOfCol, 0 );
    test.identical( m.sizeOfRow, 0 );
    test.identical( m.dims, [ 0, 0 ] );
    test.identical( m.length, 0 );

    test.identical( m.stridesEffective, [ 1, 0 ] );
    test.identical( m.strideOfElement, 0 );
    test.identical( m.strideOfCol, 0 );
    test.identical( m.strideInCol, 1 );
    test.identical( m.strideOfRow, 1 );
    test.identical( m.strideInRow, 0 );

    test.identical( m.reduceToSumAtomWise(), 0 );
    test.identical( m.reduceToProductAtomWise(), 1 );
    test.identical( m.determinant(), 0 );
    test.is( m.buffer instanceof F32x );

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

function MakeLine( test )
{

  function checkCol( m )
  {

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

    test.identical( m.strides, null );
    test.is( m.buffer instanceof F32x );

  }

  function checkRow( m )
  {

    logger.log( 'm\n' + _.toStr( m ) );

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

    test.identical( m.strides, null );
    test.is( m.buffer instanceof F32x );

  }

  /* */

  test.case = 'make col';

  var m = _.Matrix.MakeCol( 3 );

  checkCol( m );

  var m = _.Matrix.MakeLine
  ({
    dimension : 0,
    buffer : 3,
  });

  checkCol( m );

  var m = _.Matrix.MakeLine
  ({
    dimension : 0,
    buffer : new F32x([ 1, 2, 3 ]),
  });

  checkCol( m );

  /* */

  test.case = 'make col from buffer';

  var m = _.Matrix.MakeCol([ 1, 2, 3 ]);

  checkCol( m );

  var r1 = m.rowGet( 1 );
  var r2 = m.lineGet( 1, 1 );
  var c1 = m.colGet( 0 );
  var c2 = m.lineGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.scalarFlatGet( 1 );
  var a2 = m.scalarGet([ 1, 0 ]);

  test.identical( r1, fvec([ 2 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 1, 2, 3 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 1, 2, 3 ]) );
  test.identical( a1, 2 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 6 );
  test.identical( m.reduceToProductAtomWise(), 6 );

  /* */

  test.case = 'make col from vector with Array';

  var v = vad.fromLongLrangeAndStride( [ -1, 1, -1, 2, -1, 3, -1 ], 1, 3, 2 );
  var m = _.Matrix.MakeCol( v );

  checkCol( m );

  var r1 = m.rowGet( 1 );
  var r2 = m.lineGet( 1, 1 );
  var c1 = m.colGet( 0 );
  var c2 = m.lineGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.scalarFlatGet( 1 );
  var a2 = m.scalarGet([ 1, 0 ]);

  test.identical( r1, fvec([ 2 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 1, 2, 3 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 1, 2, 3 ]) );
  test.identical( a1, 2 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 6 );
  test.identical( m.reduceToProductAtomWise(), 6 );

  test.is( v._vectorBuffer !== m.buffer );

  /* */

  test.case = 'make col from vector with F32x';

  var v = vad.fromLongLrangeAndStride( new F32x([ -1, 1, -1, 2, -1, 3, -1 ]), 1, 3, 2 );
  var m = _.Matrix.MakeCol( v );

  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 12 );
  test.identical( m.sizeOfElement, 12 );
  test.identical( m.sizeOfCol, 12 );
  test.identical( m.sizeOfRow, 4 );
  test.identical( m.dims, [ 3, 1 ] );
  test.identical( m.length, 1 );

  test.identical( m.stridesEffective, [ 2, 2 ] );
  test.identical( m.strideOfElement, 2 );
  test.identical( m.strideOfCol, 2 );
  test.identical( m.strideInCol, 2 );
  test.identical( m.strideOfRow, 2 );
  test.identical( m.strideInRow, 2 );

  test.identical( m.strides, [ 2, 2 ] );
  test.is( m.buffer instanceof F32x );

  var r1 = m.rowGet( 1 );
  var r2 = m.lineGet( 1, 1 );
  var c1 = m.colGet( 0 );
  var c2 = m.lineGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.scalarFlatGet( 2 );
  var a2 = m.scalarGet([ 1, 0 ]);

  test.identical( r1, fvec([ 2 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 1, 2, 3 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 1, 2, 3 ]) );
  test.identical( a1, 2 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 6 );
  test.identical( m.reduceToProductAtomWise(), 6 );

  test.is( v._vectorBuffer === m.buffer );

  /* */

  test.case = 'make col zeroed';

  var m = _.Matrix.MakeColZeroed( 3 );

  checkCol( m );

  var r1 = m.rowGet( 1 );
  var r2 = m.lineGet( 1, 1 );
  var c1 = m.colGet( 0 );
  var c2 = m.lineGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.scalarFlatGet( 1 );
  var a2 = m.scalarGet([ 1, 0 ]);

  test.identical( r1, fvec([ 0 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 0, 0, 0 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 0, 0, 0 ]) );
  test.identical( a1, 0 );
  test.identical( a2, 0 );
  test.identical( m.reduceToSumAtomWise(), 0 );
  test.identical( m.reduceToProductAtomWise(), 0 );

  /* */

  test.case = 'make col zeroed from buffer';

  var m = _.Matrix.MakeColZeroed([ 1, 2, 3 ]);

  checkCol( m );

  var r1 = m.rowGet( 1 );
  var r2 = m.lineGet( 1, 1 );
  var c1 = m.colGet( 0 );
  var c2 = m.lineGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.scalarFlatGet( 1 );
  var a2 = m.scalarGet([ 1, 0 ]);

  test.identical( r1, fvec([ 0 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 0, 0, 0 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 0, 0, 0 ]) );
  test.identical( a1, 0 );
  test.identical( a2, 0 );
  test.identical( m.reduceToSumAtomWise(), 0 );
  test.identical( m.reduceToProductAtomWise(), 0 );

  /* */

  test.case = 'make col zeroed from vector';

  var v = vad.fromLongLrangeAndStride( new F32x([ -1, 1, -1, 2, -1, 3, -1 ]), 1, 3, 2 );
  var m = _.Matrix.MakeColZeroed( v );

  checkCol( m );

  var r1 = m.rowGet( 1 );
  var r2 = m.lineGet( 1, 1 );
  var c1 = m.colGet( 0 );
  var c2 = m.lineGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.scalarFlatGet( 1 );
  var a2 = m.scalarGet([ 1, 0 ]);

  test.identical( r1, fvec([ 0 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 0, 0, 0 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 0, 0, 0 ]) );
  test.identical( a1, 0 );
  test.identical( a2, 0 );
  test.identical( m.reduceToSumAtomWise(), 0 );
  test.identical( m.reduceToProductAtomWise(), 0 );

  /* */

  test.case = 'make col from col';

  var om = _.Matrix.MakeCol([ 1, 2, 3 ]);
  var m = _.Matrix.MakeCol( om );

  checkCol( m );

  var r1 = m.rowGet( 1 );
  var r2 = m.lineGet( 1, 1 );
  var c1 = m.colGet( 0 );
  var c2 = m.lineGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.scalarFlatGet( 1 );
  var a2 = m.scalarGet([ 1, 0 ]);

  test.identical( r1, fvec([ 2 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 1, 2, 3 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 1, 2, 3 ]) );
  test.identical( a1, 2 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 6 );
  test.identical( m.reduceToProductAtomWise(), 6 );
  test.is( m === om );

  /* */

  test.case = 'make col zeroed from col';

  var om = _.Matrix.MakeCol([ 1, 2, 3 ]);
  var m = _.Matrix.MakeColZeroed( om );

  checkCol( m );

  var r1 = m.rowGet( 1 );
  var r2 = m.lineGet( 1, 1 );
  var c1 = m.colGet( 0 );
  var c2 = m.lineGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.scalarFlatGet( 1 );
  var a2 = m.scalarGet([ 1, 0 ]);

  test.identical( r1, fvec([ 0 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 0, 0, 0 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 0, 0, 0 ]) );
  test.identical( a1, 0 );
  test.identical( a2, 0 );
  test.identical( m.reduceToSumAtomWise(), 0 );
  test.identical( m.reduceToProductAtomWise(), 0 );

  test.is( m !== om );

  /* */

  test.case = 'make row';

  var m = _.Matrix.MakeRow( 3 );

  checkRow( m );

  var m = _.Matrix.MakeLine
  ({
    dimension : 1,
    buffer : 3,
  });

  checkRow( m );

  var m = _.Matrix.MakeLine
  ({
    dimension : 1,
    buffer : new F32x([ 1, 2, 3 ]),
  });

  checkRow( m );

  /* */

  test.case = 'make row from buffer';

  var m = _.Matrix.MakeRow([ 1, 2, 3 ]);

  checkRow( m );

  var r1 = m.rowGet( 0 );
  var r2 = m.lineGet( 1, 0 );
  var c1 = m.colGet( 1 );
  var c2 = m.lineGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.scalarFlatGet( 1 );
  var a2 = m.scalarGet([ 0, 1 ]);

  test.identical( r1, fvec([ 1, 2, 3 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 2 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 2 ]) );
  test.identical( a1, 2 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 6 );
  test.identical( m.reduceToProductAtomWise(), 6 );

  /* */

  test.case = 'make row from vector with Array';

  var v = vad.fromLongLrangeAndStride( [ -1, 1, -1, 2, -1, 3, -1 ], 1, 3, 2 );
  var m = _.Matrix.MakeRow( v );

  checkRow( m );

  var r1 = m.rowGet( 0 );
  var r2 = m.lineGet( 1, 0 );
  var c1 = m.colGet( 1 );
  var c2 = m.lineGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.scalarFlatGet( 1 );
  var a2 = m.scalarGet([ 0, 1 ]);

  test.identical( r1, fvec([ 1, 2, 3 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 2 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 2 ]) );
  test.identical( a1, 2 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 6 );
  test.identical( m.reduceToProductAtomWise(), 6 );

  test.is( v._vectorBuffer !== m.buffer );

  /* */

  test.case = 'make row from vector with F32x';

  var v = vad.fromLongLrangeAndStride( new F32x([ -1, 1, -1, 2, -1, 3, -1 ]), 1, 3, 2 );
  var m = _.Matrix.MakeRow( v );

  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 12 );
  test.identical( m.sizeOfElement, 4 );
  test.identical( m.sizeOfCol, 4 );
  test.identical( m.sizeOfRow, 12 );
  test.identical( m.dims, [ 1, 3 ] );
  test.identical( m.length, 3 );

  test.identical( m.stridesEffective, [ 2, 2 ] );
  test.identical( m.strideOfElement, 2 );
  test.identical( m.strideOfCol, 2 );
  test.identical( m.strideInCol, 2 );
  test.identical( m.strideOfRow, 2 );
  test.identical( m.strideInRow, 2 );

  test.identical( m.strides, [ 2, 2 ] );
  test.is( m.buffer instanceof F32x );

  var r1 = m.rowGet( 0 );
  var r2 = m.lineGet( 1, 0 );
  var c1 = m.colGet( 1 );
  var c2 = m.lineGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.scalarFlatGet( 2 );
  var a2 = m.scalarGet([ 0, 1 ]);

  test.identical( r1, fvec([ 1, 2, 3 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 2 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 2 ]) );
  test.identical( a1, 2 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 6 );
  test.identical( m.reduceToProductAtomWise(), 6 );

  /* */

  test.case = 'make row zeroed';

  var m = _.Matrix.MakeRowZeroed( 3 );

  checkRow( m );

  var r1 = m.rowGet( 0 );
  var r2 = m.lineGet( 1, 0 );
  var c1 = m.colGet( 1 );
  var c2 = m.lineGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.scalarFlatGet( 1 );
  var a2 = m.scalarGet([ 0, 1 ]);

  test.identical( r1, fvec([ 0, 0, 0 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 0 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 0 ]) );
  test.identical( a1, 0 );
  test.identical( a2, 0 );
  test.identical( m.reduceToSumAtomWise(), 0 );
  test.identical( m.reduceToProductAtomWise(), 0 );

  /* */

  test.case = 'make row zeroed from buffer';

  var m = _.Matrix.MakeRowZeroed([ 1, 2, 3 ]);

  checkRow( m );

  var r1 = m.rowGet( 0 );
  var r2 = m.lineGet( 1, 0 );
  var c1 = m.colGet( 1 );
  var c2 = m.lineGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.scalarFlatGet( 1 );
  var a2 = m.scalarGet([ 0, 1 ]);

  test.identical( r1, fvec([ 0, 0, 0 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 0 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 0 ]) );
  test.identical( a1, 0 );
  test.identical( a2, 0 );
  test.identical( m.reduceToSumAtomWise(), 0 );
  test.identical( m.reduceToProductAtomWise(), 0 );

  /* */

  test.case = 'make row zeroed from vector';

  var v = vad.fromLongLrangeAndStride( new F32x([ -1, 1, -1, 2, -1, 3, -1 ]), 1, 3, 2 );
  var m = _.Matrix.MakeRowZeroed( v );

  checkRow( m );

  var r1 = m.rowGet( 0 );
  var r2 = m.lineGet( 1, 0 );
  var c1 = m.colGet( 1 );
  var c2 = m.lineGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.scalarFlatGet( 1 );
  var a2 = m.scalarGet([ 0, 1 ]);

  test.identical( r1, fvec([ 0, 0, 0 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 0 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 0 ]) );
  test.identical( a1, 0 );
  test.identical( a2, 0 );
  test.identical( m.reduceToSumAtomWise(), 0 );
  test.identical( m.reduceToProductAtomWise(), 0 );

  /* */

  test.case = 'make row from row';

  var om = _.Matrix.MakeRow([ 1, 2, 3 ]);
  var m = _.Matrix.MakeRow( om );

  checkRow( m );

  var r1 = m.rowGet( 0 );
  var r2 = m.lineGet( 1, 0 );
  var c1 = m.colGet( 1 );
  var c2 = m.lineGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.scalarFlatGet( 1 );
  var a2 = m.scalarGet([ 0, 1 ]);

  test.identical( r1, fvec([ 1, 2, 3 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 2 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 2 ]) );
  test.identical( a1, 2 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 6 );
  test.identical( m.reduceToProductAtomWise(), 6 );

  test.is( m === om );

  /* */

  test.case = 'make row zeroed from row';

  var om = _.Matrix.MakeRow([ 1, 2, 3 ]);
  var m = _.Matrix.MakeRowZeroed( om );

  checkRow( m );

  var r1 = m.rowGet( 0 );
  var r2 = m.lineGet( 1, 0 );
  var c1 = m.colGet( 1 );
  var c2 = m.lineGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.scalarFlatGet( 1 );
  var a2 = m.scalarGet([ 0, 1 ]);

  test.identical( r1, fvec([ 0, 0, 0 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 0 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 0 ]) );
  test.identical( a1, 0 );
  test.identical( a2, 0 );
  test.identical( m.reduceToSumAtomWise(), 0 );
  test.identical( m.reduceToProductAtomWise(), 0 );

  test.is( m !== om );

}

//

function MakeSimilar( test )
{

  var o = Object.create( null );
  o.name = 'Array';
  o.arrayMake = function( a ){ return _.longMake( Array, a ) };
  _MakeSimilar( test, o );

  var o = Object.create( null );
  o.name = 'F32x';
  o.arrayMake = function( a ){ return _.longMake( F32x, a ) };
  _MakeSimilar( test, o );

  var o = Object.create( null );
  o.name = 'U32x';
  o.arrayMake = function( a ){ return _.longMake( U32x, a ) };
  _MakeSimilar( test, o );

  /* - */

  function _MakeSimilar( test, o )
  {

    /* */

    test.case = o.name + ' . simplest from matrix';

    var m = _.Matrix.Make([ 2, 3 ]);
    m.buffer = o.arrayMake([ 1, 2, 3, 4, 5, 6 ]);

    var got = m.makeSimilar();
    test.is( got.buffer.constructor === m.buffer.constructor );
    test.identical( got.dims, m.dims );
    test.identical( got.stridesEffective, [ 1, 2 ] );
    test.identical( got.strides, null );

    var got = _.Matrix.MakeSimilar( m );
    test.is( got.buffer.constructor === m.buffer.constructor );
    test.identical( got.dims, m.dims );
    test.identical( got.stridesEffective, [ 1, 2 ] );
    test.identical( got.strides, null );

    /* */

    test.case = o.name + ' . from matrix with offset and stride';

    var buffer = o.arrayMake
    ([
      -1,
      1, -1, 2, -1,
      3, -1, 4, -4,
      -1,
    ]);

    var m = _.Matrix
    ({
      dims : [ 2, 2 ],
      inputTransposing : 1,
      offset : 1,
      buffer,
      strides : [ 2, 2 ],
    });

    var got = m.makeSimilar();
    test.is( got.buffer.constructor === m.buffer.constructor );
    test.identical( got.dims, m.dims );
    test.identical( got.stridesEffective, [ 1, 2 ] );
    test.identical( got.strides, null );

    var got = _.Matrix.MakeSimilar( m );
    test.is( got.buffer.constructor === m.buffer.constructor );
    test.identical( got.dims, m.dims );
    test.identical( got.stridesEffective, [ 1, 2 ] );
    test.identical( got.strides, null );

    /* */

    test.case = o.name + ' . from matrix with dims, offset and stride';

    var buffer = o.arrayMake
    ([
      -1,
      1, -1, 2, -1,
      3, -1, 4, -4,
      -1,
    ]);

    var m = _.Matrix
    ({
      dims : [ 2, 2 ],
      inputTransposing : 1,
      offset : 1,
      buffer,
      strides : [ 2, 2 ],
    });

    var got = m.makeSimilar([ 3, 4 ]);
    test.is( got.buffer.constructor === m.buffer.constructor );
    test.identical( got.dims, [ 3, 4 ] );
    test.identical( got.stridesEffective, [ 1, 3 ] );
    test.identical( got.strides, null );

    var got = _.Matrix.MakeSimilar( m, [ 3, 4 ] );
    test.is( got.buffer.constructor === m.buffer.constructor );
    test.identical( got.dims, [ 3, 4 ] );
    test.identical( got.stridesEffective, [ 1, 3 ] );
    test.identical( got.strides, null );

    /* */

    test.case = o.name + ' . from array';

    var src = o.arrayMake([ 1, 2, 3 ]);
    var got = _.Matrix.MakeSimilar( src );
    test.is( got.constructor === src.constructor );
    test.identical( got.length , src.length );

    /* */

    test.case = o.name + ' . from array with dims';

    var src = o.arrayMake([ 1, 2, 3 ]);
    var got = _.Matrix.MakeSimilar( src, [ 5, 1 ] );
    test.is( got.constructor === src.constructor );
    test.identical( got.length , 5 );

    /* */

    test.case = o.name + ' . from vector';

    var src = vad.from( o.arrayMake([ 1, 2, 3 ]) );
    var got = _.Matrix.MakeSimilar( src );
    test.is( _.vectorAdapterIs( src ) );
    test.identical( got.length , src.length );

    var src = vad.fromLongLrangeAndStride( o.arrayMake([ -1, 1, -1, 2, -1, 3, -1 ]), 1, 3, 1 );
    var got = _.Matrix.MakeSimilar( src );
    test.is( _.vectorAdapterIs( src ) );
    test.identical( got.length , src.length );

    /* */

    test.case = o.name + ' . from vector with dims';

    var src = vad.from( o.arrayMake([ 1, 2, 3 ]) );
    var got = _.Matrix.MakeSimilar( src, [ 5, 1 ] );
    test.is( _.vectorAdapterIs( src ) );
    test.identical( got.length , 5 );

    var src = vad.fromLongLrangeAndStride( o.arrayMake([ -1, 1, -1, 2, -1, 3, -1 ]), 1, 3, 1 );
    var got = _.Matrix.MakeSimilar( src, [ 5, 1 ] );
    test.is( _.vectorAdapterIs( src ) );
    test.identical( got.length , 5 );

    /* */

    test.case = o.name + ' . special';

    var exp = o.arrayMake( 4 );
    var got = _.Matrix.MakeSimilar( o.arrayMake([ 1, 2, 3 ]), [ 4, 1 ] );
    test.identical( got, exp );

    var exp = o.arrayMake( 3 );
    var got = _.Matrix.MakeSimilar( o.arrayMake([ 1, 2, 3 ]), [ null, 1 ] );
    test.identical( got, exp );

    /* */

    test.case = o.name + ' . bad arguments';

    if( !Config.debug )
    return;

    test.shouldThrowErrorSync( () => _.Matrix.MakeSimilar() );
    test.shouldThrowErrorSync( () => _.Matrix.MakeSimilar( null ) );
    test.shouldThrowErrorSync( () => _.Matrix.MakeSimilar( null, [ 1, 1 ] ) );

    test.shouldThrowErrorSync( () => _.Matrix.MakeSimilar( o.arrayMake([ 1, 2, 3 ]), 1 ) );
    test.shouldThrowErrorSync( () => _.Matrix.MakeSimilar( _.Matrix.Make([ 2, 2 ]), 1 ) );
    test.shouldThrowErrorSync( () => _.Matrix.MakeSimilar( vec( o.arrayMake([ 1, 2, 3 ]) ), 1 ) );

    test.shouldThrowErrorSync( () => _.Matrix.MakeSimilar( o.arrayMake([ 1, 2, 3 ]), [ 3, 2 ] ) );
    test.shouldThrowErrorSync( () => _.Matrix.MakeSimilar( vec( o.arrayMake([ 1, 2, 3 ]) ), [ 3, 2 ] ) );

    test.shouldThrowErrorSync( () => _.Matrix.MakeSimilar( vec( o.arrayMake([ 1, 2, 3 ]) ), [ null, 1 ] ) );
    test.shouldThrowErrorSync( () => _.Matrix.MakeSimilar( _.Matrix.Make([ 2, 2 ]), [ null, 1 ] ) );

    test.shouldThrowErrorSync( () => _.Matrix.MakeSimilar( o.arrayMake([ 1, 2, 3 ]), [ 3, 1, 1 ] ) );
    test.shouldThrowErrorSync( () => _.Matrix.MakeSimilar( vec( o.arrayMake([ 1, 2, 3 ]) ), [ 3, 1, 1 ] ) );
    test.shouldThrowErrorSync( () => _.Matrix.MakeSimilar( _.Matrix.Make([ 2, 2 ]), [ null, 1 ] ) );

  }

}

//

function from( test )
{

  /* */

  test.case = '_BufferFrom from array';

  var expected = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix._BufferFrom([ 1, 2, 3 ]);
  test.identical( got, expected );

  /* */

  test.case = '_BufferFrom from vector with Array';

  var v = vad.fromLongLrangeAndStride( [ -1, 1, -1, 2, -1, 3, -1 ], 1, 3, 2 );
  var expected = new F32x([ 1, 2, 3 ]);
  var got = _.Matrix._BufferFrom( v );
  test.identical( got, expected );

  /* */

  test.case = '_BufferFrom from vector with F32x';

  var v = vad.fromLongLrangeAndStride( new F32x([ -1, 1, -1, 2, -1, 3, -1 ]), 1, 3, 2 );
  var got = _.Matrix._BufferFrom( v );
  test.is( got === v );

  /* */

  test.case = 'FromScalarForReading scalar';

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 1, 1,
    1, 1, 1,
  ]);

  var m = _.Matrix.FromScalarForReading( 1, [ 2, 3 ] );
  m.toStr();
  logger.log( m );

  test.identical( m, expected );
  test.identical( m.dims, [ 2, 3 ] );
  test.identical( m.stridesEffective, [ 0, 0 ] )

  /* */

  test.case = 'empty matrix FromScalarForReading scalar';

  var expected = _.Matrix.Make([ 0, 3 ]);
  var m = _.Matrix.FromScalarForReading( 1, [ 0, 3 ] );
  test.identical( m, expected )
  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.stridesEffective, [ 0, 0 ] )

  var expected = _.Matrix.Make([ 3, 0 ]);
  var m = _.Matrix.FromScalarForReading( 1, [ 3, 0 ] );
  test.identical( m, expected );
  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m.stridesEffective, [ 0, 0 ] )
  logger.log( m );

  /* */

  test.case = 'FromForReading scalar';

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 1, 1,
    1, 1, 1,
  ]);

  var m = _.Matrix.FromForReading( 1, [ 2, 3 ] );
  m.toStr();
  logger.log( m );

  test.identical( m, expected );
  test.identical( m.dims, [ 2, 3 ] );
  test.identical( m.stridesEffective, [ 0, 0 ] )

  /* */

  test.case = 'empty matrix FromForReading scalar';

  var expected = _.Matrix.Make([ 0, 3 ]);
  var m = _.Matrix.FromForReading( 1, [ 0, 3 ] );
  test.identical( m, expected )
  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.stridesEffective, [ 0, 0 ] )

  var expected = _.Matrix.Make([ 3, 0 ]);
  var m = _.Matrix.FromForReading( 1, [ 3, 0 ] );
  test.identical( m, expected )
  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m.stridesEffective, [ 0, 0 ] )
  logger.log( m );

  /* */

  test.case = 'from scalar';

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 1, 1,
    1, 1, 1,
  ]);

  var m = _.Matrix.From( 1, [ 2, 3 ] );
  m.toStr();
  logger.log( m );

  test.identical( m, expected );
  test.identical( m.dims, [ 2, 3 ] );
  test.identical( m.stridesEffective, [ 1, 2 ] )

  /* */

  test.case = 'empty matrix from scalar';

  var expected = _.Matrix.Make([ 0, 3 ]);
  var m = _.Matrix.From( 1, [ 0, 3 ] );
  test.identical( m, expected )
  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.stridesEffective, [ 1, 0 ] )

  var expected = _.Matrix.Make([ 3, 0 ]);
  var m = _.Matrix.From( 1, [ 3, 0 ] );
  test.identical( m, expected )
  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m.stridesEffective, [ 1, 3 ] )

  logger.log( m );

  /* */

  test.case = 'FromScalar scalar';

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 1, 1,
    1, 1, 1,
  ]);

  var m = _.Matrix.FromScalar( 1, [ 2, 3 ] );
  m.toStr();
  logger.log( m );

  test.identical( m, expected );
  test.identical( m.dims, [ 2, 3 ] );
  test.identical( m.stridesEffective, [ 1, 2 ] )

  /* */

  test.case = 'empty matrix FromScalar scalar';

  var expected = _.Matrix.Make([ 0, 3 ]);
  var m = _.Matrix.FromScalar( 1, [ 0, 3 ] );
  test.identical( m, expected )
  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m.stridesEffective, [ 1, 0 ] )

  var expected = _.Matrix.Make([ 3, 0 ]);
  var m = _.Matrix.FromScalar( 1, [ 3, 0 ] );
  test.identical( m, expected )
  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m.stridesEffective, [ 1, 3 ] )

  logger.log( m );

  /* */

  test.case = 'from matrix';

  var expected = _.Matrix.Make([ 2, 3 ]).copy
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
  test.identical( got, expected );

  var got = _.Matrix.From( m );
  test.identical( got, expected );

  /* */

  test.case = 'from array';

  var expected = _.Matrix.Make([ 3, 1 ]);
  expected.buffer = [ 1, 2, 3, ];

  var a = [ 1, 2, 3 ];

  var got = _.Matrix.From( a );
  test.identical( got, expected );

  var got = _.Matrix.From( a, [ 3, 1 ] );
  test.identical( got, expected );

  /* */

  test.case = 'from vector';

  var expected = _.Matrix.Make([ 3, 1 ]);
  expected.buffer = [ 1, 2, 3, ];

  var a = vec([ 1, 2, 3 ]);

  var got = _.Matrix.From( a );
  test.identical( got, expected );

  var got = _.Matrix.From( a, [ 3, 1 ] );
  test.identical( got, expected );

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
  test.shouldThrowErrorSync( () => m.from( vec([ 1, 2, 3 ]), [ 2, 1 ] ) );
  test.shouldThrowErrorSync( () => m.from( vec([ 1, 2, 3 ]), [ 4, 1 ] ) );
  test.shouldThrowErrorSync( () => m.from( vec([ 1, 2, 3 ]), [ 3, 2 ] ) );
  test.shouldThrowErrorSync( () => m.from( _.Matrix.Make([ 3, 3 ]), _.Matrix.Make([ 3, 3 ]) ) );
  test.shouldThrowErrorSync( () => m.from( _.Matrix.Make([ 2, 3 ]), [ 2, 4 ] ) );
  test.shouldThrowErrorSync( () => m.from( _.Matrix.Make([ 3, 2 ]), [ 3, 2 ] ) );

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

//

function constructWithInfinity( test )
{

  /* */

  test.case = 'dims : [ 3, Infinity ] ; inputTransposing : 0';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 2, 3 ]),
    inputTransposing : 0,
    dims : [ 3, Infinity ],
  });

  test.identical( m1.dims, [ 3, Infinity ] );
  test.identical( m1.dimsEffective, [ 3, 1 ] );
  test.identical( m1.strides, null );
  test.identical( m1.stridesEffective, [ 1, 0 ] );
  console.log( m1.toStr() );

  /* */

  test.case = 'dims : [ 3, Infinity ] ; inputTransposing : 1';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 2, 3 ]),
    inputTransposing : 1,
    dims : [ 3, Infinity ],
  });

  test.identical( m1.dims, [ 3, Infinity ] );
  test.identical( m1.dimsEffective, [ 3, 1 ] );
  test.identical( m1.strides, null );
  test.identical( m1.stridesEffective, [ 1, 0 ] );
  console.log( m1.toStr() );

  /* */

  test.case = 'dims : [ Infinity, 3 ] ; inputTransposing : 0';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 2, 3 ]),
    inputTransposing : 0,
    dims : [ Infinity, 3 ],
  });

  test.identical( m1.dims, [ Infinity, 3 ] );
  test.identical( m1.dimsEffective, [ 1, 3 ] );
  test.identical( m1.strides, null );
  test.identical( m1.stridesEffective, [ 0, 1 ] );
  console.log( m1.toStr() );

  /* */

  test.case = 'dims : [ Infinity, 3 ] ; inputTransposing : 1';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 2, 3 ]),
    inputTransposing : 1,
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

  test.case = 'non empty, inputTransposing : 0';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 2, 3, 4, 5, 6 ]),
    inputTransposing : 0,
    scalarsPerElement : 3,
  });

  test.identical( m1.dims, [ 3, 2 ] );
  test.identical( m1.dimsEffective, [ 3, 2 ] );
  test.identical( m1.strides, null );
  test.identical( m1.stridesEffective, [ 1, 3 ] );
  console.log( m1.toStr() );

  /* */

  test.case = 'non empty, inputTransposing : 1';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 2, 3, 4, 5, 6 ]),
    inputTransposing : 1,
    scalarsPerElement : 3,
  });

  test.identical( m1.dims, [ 3, 2 ] );
  test.identical( m1.dimsEffective, [ 3, 2 ] );
  test.identical( m1.strides, null );
  test.identical( m1.stridesEffective, [ 2, 1 ] );
  console.log( m1.toStr() );

  /* */

  test.case = 'empty, inputTransposing : 0';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([]),
    inputTransposing : 0,
    scalarsPerElement : 3,
  });

  test.identical( m1.dims, [ 3, 0 ] );
  test.identical( m1.dimsEffective, [ 3, 0 ] );
  test.identical( m1.strides, null );
  test.identical( m1.stridesEffective, [ 1, 3 ] );
  console.log( m1.toStr() );

  /* */

  test.case = 'empty, inputTransposing : 1';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([]),
    inputTransposing : 1,
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
      inputTransposing : 1,
      atomsPerElement : 3,
    });
  });

  /* */

//   "dims" : [ 1, Infinity ],
//   "name" : ``,
//   "divisor" : 0,
//   "isDerived" : false,
//   "isDynamic" : false,
//   "_webgl" : null,
//   "growingDimension" : 1,
//   "inputTransposing" : 0,
//   "buffer" : ( new Float32Array([ 1 ]) ),
//   "offset" : 0,
//   "strides" : [ 1, 1 ]

}

//

function constructWithBreadth( test )
{

  /* */

  test.case = 'matrix with breadth, transposing';

  var m = new _.Matrix
  ({
    inputTransposing : 1,
    breadth : [ 2 ],
    buffer :
    [
      1, 2, 3,
      4, 5, 6,
    ],
  });

  logger.log( 'm\n' + _.toStr( m ) );

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

  test.identical( r1, _.vectorAdapter.from([ 4, 5, 6 ]) );
  test.identical( r1, r2 );
  test.identical( c1, _.vectorAdapter.from([ 3, 6 ]) );
  test.identical( c1, c2 );
  test.identical( e, _.vectorAdapter.from([ 3, 6 ]) );
  test.identical( a1, 6 );
  test.identical( a2, 5 );
  test.identical( m.reduceToSumAtomWise(), 21 );
  test.identical( m.reduceToProductAtomWise(), 720 );

  /* */

  test.case = 'matrix with breadth, non transposing';

  var m = new _.Matrix
  ({
    inputTransposing : 0,
    breadth : [ 2 ],
    buffer :
    [
      1, 2, 3,
      4, 5, 6,
    ],
  });

  logger.log( 'm\n' + _.toStr( m ) );

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

  test.identical( r1, _.vectorAdapter.from([ 2, 4, 6 ]) );
  test.identical( r1, r2 );
  test.identical( c1, _.vectorAdapter.from([ 5, 6 ]) );
  test.identical( c1, c2 );
  test.identical( e, _.vectorAdapter.from([ 5, 6 ]) );
  test.identical( a1, 6 );
  test.identical( a2, 4 );
  test.identical( m.reduceToSumAtomWise(), 21 );
  test.identical( m.reduceToProductAtomWise(), 720 );

  /* */

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

function constructWithoutBuffer( test )
{

  /* */

  var exp =
  {
    'inputTransposing' : 0,
    'growingDimension' : 1,
    'dims' : [ 3, 2 ],
    'buffer' : ( new Float32Array([ 0, 0, 0, 0, 0, 0 ]) ),
    'offset' : 0,
    'strides' : [ 1, 3 ]
  }
  var inputTransposing = 0;
  var dims = [ 3, 2 ];
  var matrix = _.Matrix({ dims, inputTransposing });
  var exported = matrix.exportStructure({ dst : {} });
  test.identical( exported, exp );

  var exp =
  {
    'inputTransposing' : 0,
    'growingDimension' : 1,
    'dims' : [ 3, 2 ],
    'buffer' : ( new Float32Array([ 1, 3, 5, 2, 4, 6 ]) ),
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

// --
// exporter
// --


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

  var expected = _.Matrix.MakeIdentity([ 3, 3 ]);
  var m1 = _.Matrix.MakeIdentity([ 3, 3 ]);
  m1.copy( m1 );

  test.identical( m1, expected );

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

  var expected = _.Matrix.MakeIdentity([ 0, 0 ]);
  var m1 = _.Matrix.MakeIdentity([ 0, 0 ]);
  m1.copy( m1 );

  test.identical( m1, expected );
  test.identical( m1.dims, [ 0, 0 ] );

}

//

function _ConvertToClass( test, o )
{

  test.case = o.name + ' . ' + 'matrix to matrix with class'; //

  var src = _.Matrix.Make([ 2, 2 ]);
  src.buffer = o.arrayMake([ 1, 2, 3, 4 ]);
  var got = _.Matrix.ConvertToClass( _.Matrix, src );
  test.is( got === src );

  test.case = o.name + ' . ' + 'matrix to vector with class'; //

  var src = _.Matrix.MakeCol( 3 );
  src.buffer = o.arrayMake([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( vad.fromLong( o.arrayMake([]) ).constructor, src );
  var expected = vad.fromLong( o.arrayMake([ 1, 2, 3 ]) );
  test.identical( got, expected );

  test.case = o.name + ' . ' + 'matrix to array with class'; //

  var src = _.Matrix.MakeCol( o.arrayMake([ 1, 2, 3 ]) );
  var got = _.Matrix.ConvertToClass( o.arrayMake([]).constructor, src );
  var expected = o.arrayMake([ 1, 2, 3 ]);
  test.identical( got, expected );

  test.case = o.name + ' . ' + 'array to matrix with class'; //

  var src = o.arrayMake([ 1, 2, 3 ]);
  var expected = _.Matrix.Make([ 3, 1 ]);
  expected.buffer = o.arrayMake([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( _.Matrix, src );
  test.identical( got, expected );

  test.case = o.name + ' . ' + 'array to vector with class'; //

  var src = o.arrayMake([ 1, 2, 3 ]);
  var expected = vec( o.arrayMake([ 1, 2, 3 ]) );
  var got = _.Matrix.ConvertToClass( vec([]).constructor, src );
  test.identical( got, expected );

  test.case = o.name + ' . ' + 'array to array with class'; //

  var src = o.arrayMake([ 1, 2, 3 ]);
  var expected = o.arrayMake([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( o.arrayMake([]).constructor, src );
  test.identical( got, expected );
  test.is( got === src );

  test.case = o.name + ' . ' + 'vector to matrix with class'; //

  var src = vec( o.arrayMake([ 1, 2, 3 ]) );
  var expected = _.Matrix.Make([ 3, 1 ]);
  expected.buffer = o.arrayMake([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( _.Matrix, src );
  test.identical( got, expected );

  test.case = o.name + ' . ' + 'vector to vector with class'; //

  var src = vec( o.arrayMake([ 1, 2, 3 ]) );
  var expected = vec( o.arrayMake([ 1, 2, 3 ]) );
  var got = _.Matrix.ConvertToClass( vec([]).constructor, src );
  test.identical( got, expected );
  test.is( got === src );

  test.case = o.name + ' . ' + 'vector to array with class'; //

  var src = vec( o.arrayMake([ 1, 2, 3 ]) );
  var expected = o.arrayMake([ 1, 2, 3 ]);
  var got = _.Matrix.ConvertToClass( o.arrayMake([]).constructor, src );
  test.identical( got, expected );

  test.case = o.name + ' . ' + 'bad arguments'; //

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () => _.Matrix.Make([ 2, 1 ]).ConvertToClass() );
  test.shouldThrowErrorSync( () => _.Matrix.Make([ 2, 1 ]).ConvertToClass( [].constructor ) );
  test.shouldThrowErrorSync( () => _.Matrix.Make([ 2, 1 ]).ConvertToClass( vec([]).constructor ) );

  test.shouldThrowErrorSync( () => matrix.ConvertToClass( [].constructor, _.Matrix.Make([ 2, 1 ]), 1 ) );
  test.shouldThrowErrorSync( () => matrix.ConvertToClass( [].constructor ) );
  test.shouldThrowErrorSync( () => matrix.ConvertToClass( [].constructor, null ) );
  test.shouldThrowErrorSync( () => matrix.ConvertToClass( null, _.Matrix.Make([ 2, 1 ]) ) );
  test.shouldThrowErrorSync( () => matrix.ConvertToClass( [].constructor, 1 ) );

}

//

function ConvertToClass( test )
{

  var o = Object.create( null );
  o.name = 'Array';
  o.arrayMake = function( a ){ return _.longMake( Array, a ) };
  this._ConvertToClass( test, o );

  var o = Object.create( null );
  o.name = 'F32x';
  o.arrayMake = function( a ){ return _.longMake( F32x, a ) };
  this._ConvertToClass( test, o );

  var o = Object.create( null );
  o.name = 'U32x';
  o.arrayMake = function( a ){ return _.longMake( U32x, a ) };
  this._ConvertToClass( test, o );

}

//

function _copyTo( test, o )
{

  test.case = o.name + ' . ' + 'matrix to array'; //

  var src = _.Matrix.MakeCol( o.arrayMake([ 1, 2, 3 ]) );
  var dst = o.arrayMake([ 0, 0, 0 ]);
  var expected = o.arrayMake([ 1, 2, 3 ]);

  var got = _.Matrix.CopyTo( dst, src );
  test.identical( got, expected );
  test.is( dst === got );

  test.case = o.name + ' . ' + 'matrix to vector'; //

  var src = _.Matrix.MakeCol( o.arrayMake([ 1, 2, 3 ]) );
  var dst = vec( o.arrayMake([ 0, 0, 0 ]) );
  var expected = vec( o.arrayMake([ 1, 2, 3 ]) );

  var got = _.Matrix.CopyTo( dst, src );
  test.identical( got, expected );
  test.is( dst === got );

  test.case = o.name + ' . ' + 'matrix to matrix'; //

  var src = _.Matrix.MakeCol( o.arrayMake([ 1, 2, 3 ]) );
  var dst = _.Matrix.MakeCol( o.arrayMake([ 0, 0, 0 ]) );
  var expected = _.Matrix.MakeCol( o.arrayMake([ 1, 2, 3 ]) );

  var got = _.Matrix.CopyTo( dst, src );
  test.identical( got, expected );
  test.is( dst === got );

  test.case = o.name + ' . ' + 'vector to array'; //

  var src = vec( o.arrayMake([ 1, 2, 3 ]) );
  var dst = o.arrayMake([ 0, 0, 0 ]);
  var expected = o.arrayMake([ 1, 2, 3 ]);

  var got = _.Matrix.CopyTo( dst, src );
  test.identical( got, expected );
  test.is( dst === got );

  test.case = o.name + ' . ' + 'vector to vector'; //

  var src = vec( o.arrayMake([ 1, 2, 3 ]) );
  var dst = vec( o.arrayMake([ 0, 0, 0 ]) );
  var expected = vec( o.arrayMake([ 1, 2, 3 ]) );

  var got = _.Matrix.CopyTo( dst, src );
  test.identical( got, expected );
  test.is( dst === got );

  test.case = o.name + ' . ' + 'vector to matrix'; //

  var src = vec( o.arrayMake([ 1, 2, 3 ]) );
  var dst = _.Matrix.MakeCol( o.arrayMake([ 0, 0, 0 ]) );
  var expected = _.Matrix.MakeCol( o.arrayMake([ 1, 2, 3 ]) );

  var got = _.Matrix.CopyTo( dst, src );
  test.identical( got, expected );
  test.is( dst === got );

  test.case = o.name + ' . ' + 'array to array'; //

  var src = o.arrayMake([ 1, 2, 3 ]);
  var dst = o.arrayMake([ 0, 0, 0 ]);
  var expected = o.arrayMake([ 1, 2, 3 ]);

  var got = _.Matrix.CopyTo( dst, src );
  test.identical( got, expected );
  test.is( dst === got );

  test.case = o.name + ' . ' + 'array to vector'; //

  var src = o.arrayMake([ 1, 2, 3 ]);
  var dst = vec( o.arrayMake([ 0, 0, 0 ]) );
  var expected = vec( o.arrayMake([ 1, 2, 3 ]) );

  var got = _.Matrix.CopyTo( dst, src );
  test.identical( got, expected );
  test.is( dst === got );

  test.case = o.name + ' . ' + 'array to matrix'; //

  var src = o.arrayMake([ 1, 2, 3 ]);
  var dst = _.Matrix.MakeCol( o.arrayMake([ 0, 0, 0 ]) );
  var expected = _.Matrix.MakeCol( o.arrayMake([ 1, 2, 3 ]) );

  var got = _.Matrix.CopyTo( dst, src );
  test.identical( got, expected );
  test.is( dst === got );

  test.case = o.name + ' . ' + 'matrix to itself'; //

  var src = _.Matrix.MakeCol( o.arrayMake([ 1, 2, 3 ]) );
  var expected = _.Matrix.MakeCol( o.arrayMake([ 1, 2, 3 ]) );

  var got = _.Matrix.CopyTo( src, src );
  test.identical( got, expected );
  test.is( src === got );

  test.case = o.name + ' . ' + 'vector to itself'; //

  var src = vec( o.arrayMake([ 1, 2, 3 ]) );
  var expected = vec( o.arrayMake([ 1, 2, 3 ]) );

  var got = _.Matrix.CopyTo( src, src );
  test.identical( got, expected );
  test.is( src === got );

  test.case = o.name + ' . ' + 'array to itself'; //

  var src = o.arrayMake([ 1, 2, 3 ]);
  var expected = o.arrayMake([ 1, 2, 3 ]);

  var got = _.Matrix.CopyTo( src, src );
  test.identical( got, expected );
  test.is( src === got );

  test.case = o.name + ' . ' + 'bad arguments'; //

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () => matrix.CopyTo() );
  test.shouldThrowErrorSync( () => _.Matrix.MakeCol( o.arrayMake([ 1 ]) ).CopyTo() );
  test.shouldThrowErrorSync( () => _.Matrix.MakeCol( o.arrayMake([ 1 ]) ).CopyTo( [ 3 ], null ) );

  test.shouldThrowErrorSync( () => matrix.CopyTo( _.Matrix.MakeCol( o.arrayMake([ 1 ]) ) ) );
  test.shouldThrowErrorSync( () => matrix.CopyTo( o.arrayMake([ 1 ]) ) );
  test.shouldThrowErrorSync( () => matrix.CopyTo( vec( o.arrayMake([ 1 ]) ) ) );

  test.shouldThrowErrorSync( () => matrix.CopyTo( _.Matrix.MakeCol( o.arrayMake([ 1 ]) ), null ) );
  test.shouldThrowErrorSync( () => matrix.CopyTo( o.arrayMake([ 1 ]), null ) );
  test.shouldThrowErrorSync( () => matrix.CopyTo( vec( o.arrayMake([ 1 ]) ), null ) );

  test.shouldThrowErrorSync( () => matrix.CopyTo( _.Matrix.MakeCol( o.arrayMake([ 1 ]) ), [ 3 ], null ) );
  test.shouldThrowErrorSync( () => matrix.CopyTo( o.arrayMake([ 1 ]), [ 3 ], null ) );
  test.shouldThrowErrorSync( () => matrix.CopyTo( vec( o.arrayMake([ 1 ]) ), [ 3 ], null ) );

}

//

function copyTo( test )
{

  var o = Object.create( null );
  o.name = 'Array';
  o.arrayMake = function( a ){ return _.longMake( Array, a ) };
  this._copyTo( test, o );

  var o = Object.create( null );
  o.name = 'F32x';
  o.arrayMake = function( a ){ return _.longMake( F32x, a ) };
  this._copyTo( test, o );

  var o = Object.create( null );
  o.name = 'U32x';
  o.arrayMake = function( a ){ return _.longMake( U32x, a ) };
  this._copyTo( test, o );

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
    inputTransposing : 1,
  });

  var dst = new _.Matrix
  ({
    buffer : b2,
    dims : [ 2, 3 ],
    offset : 2,
    inputTransposing : 0,
  });

  logger.log( 'src', src );
  logger.log( 'dst', dst );

  test.identical( src.stridesEffective, [ 2, 4 ] );
  test.identical( dst.stridesEffective, [ 1, 2 ] );
  test.identical( src.inputTransposing, 1 );
  test.identical( dst.inputTransposing, 0 );

  dst.copy( src );

  test.identical( src.stridesEffective, [ 2, 4 ] );
  test.identical( dst.stridesEffective, [ 3, 1 ] );
  test.identical( src.inputTransposing, 1 );
  test.identical( dst.inputTransposing, 1 );

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
  test.identical( dst.sizeOfElementStride, 4 );
  test.identical( dst.sizeOfElement, 8 );
  test.identical( dst.sizeOfCol, 8 );
  test.identical( dst.sizeOfRow, 12 );
  test.identical( dst.dims, [ 2, 3 ] );
  test.identical( dst.length, 3 );

  test.identical( dst.strides, null );
  test.identical( dst.stridesEffective, [ 3, 1 ] );
  test.identical( dst.strideOfElement, 1 );
  test.identical( dst.strideOfCol, 1 );
  test.identical( dst.strideInCol, 3 );
  test.identical( dst.strideOfRow, 3 );
  test.identical( dst.strideInRow, 1 );

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

  var expected = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);

  dst.copy( src );
  test.identical( dst, expected );
  test.is( src.buffer === srcBuffer );
  test.is( dst.buffer === dstBuffer );
  test.is( src.buffer !== dst.buffer );

  /* */

  test.case = 'copy null matrix';

  var src = _.Matrix.Make([ 0, 0 ]);
  var dst = _.Matrix.Make([ 0, 0 ]);

  var srcBuffer = src.buffer;
  var dstBuffer = dst.buffer;

  var expected = _.Matrix.Make([ 0, 0 ]);

  dst.copy( src );
  test.identical( dst, expected );
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

  var expected = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);

  test.identical( dst, expected );
  test.is( src.buffer === srcBuffer );
  test.is( dst.buffer === srcBuffer );
  test.is( src === dst );

  dst.copy( src );

  test.identical( dst, expected );
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

  var expected = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);

  dst.copy( src );
  test.identical( dst, expected );
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
  var dst = _.Matrix({ buffer, dims : [ 3, 2 ], inputTransposing : 1 });
  var dstBuffer = dst.buffer;

  var expected = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);

  test.identical( dst, expected );
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

  dst.copy( src );

  test.identical( dst.buffer, src.buffer );
  test.identical( dst.dims, src.dims );
  test.identical( dst.strides, src.strides );
  test.identical( dst.stridesEffective, src.stridesEffective );

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

  test.identical( dst.buffer, src.buffer );
  test.identical( dst.dims, src.dims );
  test.identical( dst.strides, src.strides );
  test.identical( dst.stridesEffective, src.stridesEffective );

  test.is( dst.buffer !== src.buffer );
  test.is( dst.dims !== src.dims );
  test.is( dst.strides === null );
  test.is( dst.stridesEffective !== src.stridesEffective );

  /* */

  if( !Config.debug )
  return;

  /* */

  test.case = 'inconsistant sizes';

  test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 2 ]).copy( 'x' ) );

  // test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 2 ]).copy( _.Matrix.Make([ 2, 2 ]) ) );
  // test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 2 ]).copy( _.Matrix.Make([ 3, 1 ]) ) );
  // test.shouldThrowErrorSync( () => _.Matrix.Make([ 3, 2 ]).copy( _.Matrix.Make([ 0, 0 ]) ) );

}

//

function exportStructureToStructure( test )
{

  /* */

  test.case = 'basic';
  var exp =
  {
    'inputTransposing' : 0,
    'growingDimension' : 1,
    'dims' : [ 2, 3 ],
    'buffer' : ( new Float32Array([ 1, 4, 2, 5, 3, 6 ]) ),
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

}

//

function toStr( test )
{

  test.case = 'empty matrix, 2D';
  var matrix = _.Matrix.Make([ 0, 0 ]);
  var exp = '';
  var got = matrix.toStr();
  test.identical( got, exp );

  test.case = 'empty matrix, two rows';
  var matrix = _.Matrix.Make([ 2, 0 ]);
  var exp = '  \n  ';
  var got = matrix.toStr();
  test.identical( got, exp );

  test.case = 'empty matrix, two columns';
  var matrix = _.Matrix.Make([ 0, 2 ]);
  var exp = '';
  var got = matrix.toStr();
  test.identical( got, exp );

  /* */

  test.case = 'a row 1x3';
  var matrix = _.Matrix.Make([ 1, 3 ]);
  var exp = '  +0 +0 +0 ';
  var got = matrix.toStr();
  test.identical( got, exp );

  test.case = 'a columt 1x3';
  var matrix = _.Matrix.Make([ 3, 1 ]);
  var exp =
`
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
+0 +1
... ...
`
  var got = matrix.toStr();
  test.equivalent( got, exp );

  /* - */

  test.case = 'empty matrix, 3d';
  var matrix = _.Matrix.Make([ 0, 0, 0 ]);
  var exp = '';
  var got = matrix.toStr();
  test.identical( got, exp );

  test.case = 'empty matrix, 4d';
  var matrix = _.Matrix.Make([ 0, 0, 0, 0 ]);
  var exp = '';
  var got = matrix.toStr();
  test.identical( got, exp );

  test.case = 'empty matrix, 4d';
  var matrix = _.Matrix.Make([ 0, 0, 0, 1 ]);
  var exp = '';
  var got = matrix.toStr();
  test.identical( got, exp );

  test.case = 'empty matrix, 4d';
  var matrix = _.Matrix.Make([ 0, 0, 1, 0 ]);
  var exp = '';
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
`
Matrix 0
  +1 +2 +3
  +4 +5 +6
Matrix 1
  +7 +8 +9
  +10 +11 +12
Matrix 2
  +13 +14 +15
  +16 +17 +18
Matrix 3
  +19 +20 +21
  +22 +23 +24
`
  var got = matrix.toStr();
  test.equivalent( got, exp );

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
Matrix 0 0 0
  +1
Matrix 1 0 0
  +2
Matrix 0 1 0
  +3
Matrix 1 1 0
  +4
Matrix 0 2 0
  +5
Matrix 1 2 0
  +6
Matrix 0 0 1
  +7
Matrix 1 0 1
  +8
Matrix 0 1 1
  +9
Matrix 1 1 1
  +10
Matrix 0 2 1
  +11
Matrix 1 2 1
  +12
Matrix 0 0 2
  +13
Matrix 1 0 2
  +14
Matrix 0 1 2
  +15
Matrix 1 1 2
  +16
Matrix 0 2 2
  +17
Matrix 1 2 2
  +18
Matrix 0 0 3
  +19
Matrix 1 0 3
  +20
Matrix 0 1 3
  +21
Matrix 1 1 3
  +22
Matrix 0 2 3
  +23
Matrix 1 2 3
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
Matrix
  +1 +2 +3
  +4 +5 +6
`
  var got = matrix.toStr();
  test.equivalent( got, exp );

  /* */

}

//

function toLong( test )
{

  /* */

  test.case = '2x3x4';
  var matrix = _.Matrix
  ({
    dims : [ 2, 3, 4 ],
    inputTransposing : 0,
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
    strides : [ 1, 3 ],
    dims : [ 3, 2 ],
  });

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

  var expected = _.Matrix.Make([ 3, 2 ]).copy
  ({
    buffer : [ 101, 102, 3, 4, 105, 106 ],
  });

  console.log( m.toStr() );
  console.log( expected.toStr() );

  m.scalarSet([ 0, 0 ], 101 );
  m.scalarSet([ 2, 1 ], 106 );
  m.scalarFlatSet( 1, 102 );
  m.scalarFlatSet( 4, 105 );

  test.identical( m, expected );

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
  // test.shouldThrowErrorSync( () => m.scalarGet([ 0, 0, 0 ]) );
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
    inputTransposing : 1,
    offset : 1,
    buffer,
    strides : [ 2, 2 ],
  });

  var expected = _.Matrix.Make([ 2, 2 ]).copy
  ([
    1, 2,
    2, 3,
  ]);

  test.identical( m.occupiedRange, [ 1, 6 ] );
  test.identical( m, expected );
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
    inputTransposing : 1,
    offset : 1,
    buffer,
    strides : [ 2, 2 ],
  });

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    2, 3, 4,
  ]);

  test.identical( m, expected );
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
  var expected = _.Matrix.MakeSquare
  ([
    9, 7,
    8, 6,
  ]);
  test.identical( matrix, expected );
}

//

function _bufferNormalize( o )
{
  let context = this;
  var test = o.test;

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
    inputTransposing : 1,
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

  test.identical( r1, vec( new F64x([ 4, 5, 6 ]) ) );
  test.identical( r1, r2 );
  test.identical( c1, vec( new F64x([ 3, 6 ]) ) );
  test.identical( c1, c2 );
  test.identical( e, vec( new F64x([ 3, 6 ]) ) );
  test.identical( a1, 6 );
  test.identical( a2, 5 );
  test.identical( m.reduceToSumAtomWise(), 21 );
  test.identical( m.reduceToProductAtomWise(), 720 );

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
    inputTransposing : 0,
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

  test.identical( r1, vec( new F64x([ 4, 5, 6 ]) ) );
  test.identical( r1, r2 );
  test.identical( c1, vec( new F64x([ 3, 6 ]) ) );
  test.identical( c1, c2 );
  test.identical( e, vec( new F64x([ 3, 6 ]) ) );
  test.identical( a1, 6 );
  test.identical( a2, 5 );
  test.identical( m.reduceToSumAtomWise(), 21 );
  test.identical( m.reduceToProductAtomWise(), 720 );

}

//

function bufferNormalize( test )
{

  var o = Object.create( null );
  o.test = test;

  o.offset = 0;
  this._bufferNormalize( o );

  o.offset = 10;
  this._bufferNormalize( o );

}

//

function expand( test )
{

  /* */

  test.case = 'left grow';

  var expected = _.Matrix.Make([ 3, 5 ]).copy
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
  test.identical( m, expected );

  /* */

  test.case = 'right grow';

  var expected = _.Matrix.Make([ 3, 5 ]).copy
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
  test.identical( m, expected );

  /* */

  test.case = 'left shrink';

  var expected = _.Matrix.Make([ 1, 2 ]).copy
  ([
    4, 5,
  ]);

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    3, 4, 5,
  ]);

  m.expand([ [ -1, null ], [ -1, null ] ]);
  test.identical( m, expected );

  /* */

  test.case = 'right shrink';

  var expected = _.Matrix.Make([ 1, 2 ]).copy
  ([
    1, 2,
  ]);

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    3, 4, 5,
  ]);

  m.expand([ [ null, -1 ], [ null, -1 ] ]);
  test.identical( m, expected );

  /* */

  test.case = 'no expand';

  var expected = _.Matrix.Make([ 2, 3 ]).copy
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
  test.identical( m, expected );
  test.is( buffer === m.buffer );

  /* */

  test.case = 'number as argument';

  var expected = _.Matrix.Make([ 5, 1 ]).copy
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
  test.identical( m, expected );

  /* */

  test.case = 'add rows to empty matrix';

  var expected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    0, 0, 0,
    0, 0, 0,
    0, 0, 0,
  ]);

  var m = _.Matrix.Make([ 0, 3 ]);
  m.expand([ [ 2, 1 ], [ 0, 0 ] ]);
  test.identical( m, expected );

  var expected = _.Matrix.Make([ 3, 0 ]);
  var m = _.Matrix.Make([ 0, 0 ]);
  m.expand([ [ 2, 1 ], [ 0, 0 ] ]);
  test.identical( m, expected );

  var expected = _.Matrix.Make([ 6, 0 ]);
  var m = _.Matrix.Make([ 3, 0 ]);
  m.expand([ [ 2, 1 ], [ 0, 0 ] ]);
  test.identical( m, expected );

  /* */

  test.case = 'add cols to empty matrix';

  var expected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    0, 0, 0,
    0, 0, 0,
    0, 0, 0,
  ]);

  var m = _.Matrix.Make([ 3, 0 ]);
  m.expand([ [ 0, 0 ], [ 2, 1 ] ]);
  test.identical( m, expected );

  var expected = _.Matrix.Make([ 0, 3 ]);
  var m = _.Matrix.Make([ 0, 0 ]);
  m.expand([ [ 0, 0 ], [ 2, 1 ] ]);
  test.identical( m, expected );

  var expected = _.Matrix.Make([ 0, 6 ]);
  var m = _.Matrix.Make([ 0, 3 ]);
  m.expand([ [ 0, 0 ], [ 2, 1 ] ]);
  test.identical( m, expected );

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
  var expected = _.Matrix.MakeCol([ 1, 2, 3 ]);
  test.identical( got, expected );

  /* */

}

//

function accessors( test )
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
      inputTransposing : 1,
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
      inputTransposing : 1,
      offset : 1,
      buffer,
    });

  }

  /* */

  test.case = 'eGet';

  remake();

  test.identical( m32.eGet( 0 ), fvec([ 1, 3, 5 ]) );
  test.identical( m32.eGet( 1 ), fvec([ 2, 4, 6 ]) );
  test.identical( m23.eGet( 0 ), fvec([ 1, 4 ]) );
  test.identical( m23.eGet( 2 ), fvec([ 3, 6 ]) );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m23.eGet() );
    test.shouldThrowErrorSync( () => m32.eGet( -1 ) );
    test.shouldThrowErrorSync( () => m32.eGet( 2 ) );
    test.shouldThrowErrorSync( () => m23.eGet( -1 ) );
    test.shouldThrowErrorSync( () => m23.eGet( 3 ) );
    test.shouldThrowErrorSync( () => m23.eGet( 0, 0 ) );
    test.shouldThrowErrorSync( () => m23.eGet( [ 0 ] ) );
  }

  /* */

  test.case = 'eSet';

  remake();

  var expected = _.Matrix.Make([ 3, 2 ]).copy
  ([
    10, 40,
    20, 50,
    30, 60,
  ]);

  m32.eSet( 0, [ 10, 20, 30 ] );
  m32.eSet( 1, [ 40, 50, 60 ] );
  test.identical( m32, expected );

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    10, 0, 30,
    40, 0, 60,
  ]);

  m23.eSet( 0, [ 10, 40 ] );
  m23.eSet( 1, 0 );
  m23.eSet( 2, [ 30, 60 ] );
  test.identical( m23, expected );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m32.eSet() );
    test.shouldThrowErrorSync( () => m32.eSet( 0 ) );
    test.shouldThrowErrorSync( () => m32.eSet( 0, 0, 0 ) );
    test.shouldThrowErrorSync( () => m32.eSet( 0, [ 10, 20 ] ) );
    test.shouldThrowErrorSync( () => m32.eSet( 0, [ 10, 20, 30 ], 0 ) );
    test.shouldThrowErrorSync( () => m32.eSet( [ 0 ], [ 10, 20, 30 ] ) );
  }

  /* */

  test.case = 'eSet vector';

  remake();

  var expected = _.Matrix.Make([ 3, 2 ]).copy
  ([
    10, 40,
    20, 50,
    30, 60,
  ]);

  m32.eSet( 0, ivec([ 10, 20, 30 ]) );
  m32.eSet( 1, ivec([ 40, 50, 60 ]) );
  test.identical( m32, expected );

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    10, 0, 30,
    40, 0, 60,
  ]);

  m23.eSet( 0, ivec([ 10, 40 ]) );
  m23.eSet( 1, 0 );
  m23.eSet( 2, ivec([ 30, 60 ]) );
  test.identical( m23, expected );

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

  var expected = _.Matrix.Make([ 3, 2 ]).copy
  ([
    10, 40,
    20, 50,
    30, 60,
  ]);

  m32.colSet( 0, [ 10, 20, 30 ] );
  m32.colSet( 1, [ 40, 50, 60 ] );
  test.identical( m32, expected );

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    10, 0, 30,
    40, 0, 60,
  ]);

  m23.colSet( 0, [ 10, 40 ] );
  m23.colSet( 1, 0 );
  m23.colSet( 2, [ 30, 60 ] );
  test.identical( m23, expected );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m32.colSet() );
    test.shouldThrowErrorSync( () => m32.colSet( 0 ) );
    test.shouldThrowErrorSync( () => m32.colSet( 0, 0, 0 ) );
    test.shouldThrowErrorSync( () => m32.colSet( 0, [ 10, 20 ] ) );
    test.shouldThrowErrorSync( () => m32.colSet( 0, [ 10, 20, 30 ], 0 ) );
    test.shouldThrowErrorSync( () => m32.colSet( [ 0 ], [ 10, 20, 30 ] ) );
  }

  /* */

  test.case = 'colSet vector';

  remake();

  var expected = _.Matrix.Make([ 3, 2 ]).copy
  ([
    10, 40,
    20, 50,
    30, 60,
  ]);

  m32.colSet( 0, ivec([ 10, 20, 30 ]) );
  m32.colSet( 1, ivec([ 40, 50, 60 ]) );
  test.identical( m32, expected );

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    10, 0, 30,
    40, 0, 60,
  ]);

  m23.colSet( 0, ivec([ 10, 40 ]) );
  m23.colSet( 1, 0 );
  m23.colSet( 2, ivec([ 30, 60 ]) );
  test.identical( m23, expected );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m32.colSet() );
    test.shouldThrowErrorSync( () => m32.colSet( 0 ) );
    test.shouldThrowErrorSync( () => m32.colSet( 0, 0, 0 ) );
    test.shouldThrowErrorSync( () => m32.colSet( 0, ivec([ 10, 20 ]) ) );
    test.shouldThrowErrorSync( () => m32.colSet( 0, ivec([ 10, 20, 30 ]), 0 ) );
    test.shouldThrowErrorSync( () => m32.colSet( [ 0 ], ivec([ 10, 20, 30 ]) ) );
  }

  /* */

  test.case = 'lineSet col';

  remake();

  var expected = _.Matrix.Make([ 3, 2 ]).copy
  ([
    10, 40,
    20, 50,
    30, 60,
  ]);

  m32.lineSet( 0, 0, [ 10, 20, 30 ] );
  m32.lineSet( 0, 1, [ 40, 50, 60 ] );
  test.identical( m32, expected );

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    10, 0, 30,
    40, 0, 60,
  ]);

  m23.lineSet( 0, 0, [ 10, 40 ] );
  m23.lineSet( 0, 1, 0 );
  m23.lineSet( 0, 2, [ 30, 60 ] );
  test.identical( m23, expected );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m32.lineSet() );
    test.shouldThrowErrorSync( () => m32.lineSet( 0 ) );
    test.shouldThrowErrorSync( () => m32.lineSet( 0, 0 ) );
    test.shouldThrowErrorSync( () => m32.lineSet( 0, 0, 0, 0 ) );
    test.shouldThrowErrorSync( () => m32.lineSet( 0, 0, [ 10, 20 ] ) );
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

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    10, 20, 30,
    40, 50, 60,
  ]);

  m23.rowSet( 0, [ 10, 20, 30 ] );
  m23.rowSet( 1, [ 40, 50, 60 ] );
  test.identical( m23, expected );

  var expected = _.Matrix.Make([ 3, 2 ]).copy
  ([
    10, 20,
    0, 0,
    50, 60,
  ]);

  m32.rowSet( 0, [ 10, 20 ] );
  m32.rowSet( 1, 0 );
  m32.rowSet( 2, [ 50, 60 ] );
  test.identical( m32, expected );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m23.rowSet() );
    test.shouldThrowErrorSync( () => m23.rowSet( 0 ) );
    test.shouldThrowErrorSync( () => m23.rowSet( 0, 0, 0 ) );
    test.shouldThrowErrorSync( () => m23.rowSet( 0, [ 10, 20 ] ) );
    test.shouldThrowErrorSync( () => m23.rowSet( 0, [ 10, 20, 30 ], 0 ) );
    test.shouldThrowErrorSync( () => m23.rowSet( [ 0 ], [ 10, 20, 30 ] ) );
  }

  /* */

  test.case = 'rowSet vector';

  remake();

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    10, 20, 30,
    40, 50, 60,
  ]);

  m23.rowSet( 0, ivec([ 10, 20, 30 ]) );
  m23.rowSet( 1, ivec([ 40, 50, 60 ]) );
  test.identical( m23, expected );

  var expected = _.Matrix.Make([ 3, 2 ]).copy
  ([
    10, 20,
    0, 0,
    50, 60,
  ]);

  m32.rowSet( 0, ivec([ 10, 20 ]) );
  m32.rowSet( 1, 0 );
  m32.rowSet( 2, ivec([ 50, 60 ]) );
  test.identical( m32, expected );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m23.rowSet() );
    test.shouldThrowErrorSync( () => m23.rowSet( 0 ) );
    test.shouldThrowErrorSync( () => m23.rowSet( 0, 0, 0 ) );
    test.shouldThrowErrorSync( () => m23.rowSet( 0, ivec([ 10, 20 ]) ) );
    test.shouldThrowErrorSync( () => m23.rowSet( 0, ivec([ 10, 20, 30 ]), 0 ) );
    test.shouldThrowErrorSync( () => m23.rowSet( [ 0 ], ivec([ 10, 20, 30 ]) ) );
  }

  /* */

  test.case = 'lineSet row';

  remake();

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    10, 20, 30,
    40, 50, 60,
  ]);

  m23.lineSet( 1, 0, [ 10, 20, 30 ] );
  m23.lineSet( 1, 1, [ 40, 50, 60 ] );
  test.identical( m23, expected );

  var expected = _.Matrix.Make([ 3, 2 ]).copy
  ([
    10, 20,
    0, 0,
    50, 60,
  ]);

  m32.lineSet( 1, 0, [ 10, 20 ] );
  m32.lineSet( 1, 1, 0 );
  m32.lineSet( 1, 2, [ 50, 60 ] );
  test.identical( m32, expected );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m23.lineSet() );
    test.shouldThrowErrorSync( () => m23.lineSet( 1, 0 ) );
    test.shouldThrowErrorSync( () => m23.lineSet( 1, 0 ) );
    test.shouldThrowErrorSync( () => m23.lineSet( 1, 0, 0, 0 ) );
    test.shouldThrowErrorSync( () => m23.lineSet( 1, 0, [ 10, 20 ] ) );
    test.shouldThrowErrorSync( () => m23.lineSet( 1, 0, [ 10, 20, 30 ], 0 ) );
    test.shouldThrowErrorSync( () => m23.lineSet( 1, [ 0 ], [ 10, 20, 30 ] ) );
  }

  /* */

  test.case = 'scalarGet';

  remake();

  test.identical( m23.scalarGet([ 0, 0 ]), 1 );
  test.identical( m23.scalarGet([ 1, 2 ]), 6 );
  test.identical( m32.scalarGet([ 0, 0 ]), 1 );
  test.identical( m32.scalarGet([ 2, 1 ]), 6 );

  if( Config.debug )
  {

    test.shouldThrowErrorSync( () => m23.scalarGet() );
    test.shouldThrowErrorSync( () => m23.scalarGet( 0 ) );
    test.shouldThrowErrorSync( () => m23.scalarGet( 0, 0 ) );
    test.shouldThrowErrorSync( () => m23.scalarGet( [ 0, 0 ], 0 ) );
    test.shouldThrowErrorSync( () => m23.scalarGet( [ 0, undefined ] ) );
    test.shouldThrowErrorSync( () => m23.scalarGet( [ undefined, 0 ] ) );

    test.shouldThrowErrorSync( () => m23.scalarGet([ 2, 2 ]) );
    test.shouldThrowErrorSync( () => m23.scalarGet([ 1, 3 ]) );
    test.shouldThrowErrorSync( () => m32.scalarGet([ 2, 2 ]) );
    test.shouldThrowErrorSync( () => m32.scalarGet([ 3, 1 ]) );

  }

  /* */

  test.case = 'scalarSet';

  remake();

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    10, 2, 3,
    4, 5, 60,
  ]);

  m23.scalarSet( [ 0, 0 ], 10 );
  m23.scalarSet( [ 1, 2 ], 60 );
  test.identical( m23, expected );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m23.scalarSet() );
    test.shouldThrowErrorSync( () => m23.scalarSet( 0 ) );
    test.shouldThrowErrorSync( () => m23.scalarSet( 0, 0) );
    test.shouldThrowErrorSync( () => m23.scalarSet( 0, 0, 0 ) );
    test.shouldThrowErrorSync( () => m23.scalarSet( [ 0, 0 ], undefined ) );
    test.shouldThrowErrorSync( () => m23.scalarSet( [ 0, 0 ], 0, 0 ) );
    test.shouldThrowErrorSync( () => m23.scalarSet( [ 0, 0 ], [ 0 ] ) );
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

function partialAccessors( test )
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

  var expected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +14, +23, +18,
    +23, +41, +30,
    +18, +30, +36,
  ]);

  var uxl = _.Matrix.Mul( null, [ u, l ] );
  logger.log( uxl );
  test.identical( uxl, expected );

  /* */

  test.case = 'zero';

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    0, 0, 0,
    0, 0, 0,
  ]);

  m.zero();
  test.identical( m, expected );

  /* */

  test.case = 'zero empty';

  var m = _.Matrix.Make([ 0, 0 ]);
  var expected = _.Matrix.Make([ 0, 0 ]);
  var r = m.zero();
  test.identical( m, expected );
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
    inputTransposing : 1,
    offset : 1,
    buffer,
  });

  var expected = vec([ 1, 6, 11 ]);
  var diagonal = m.diagonalGet();
  test.identical( diagonal, expected );

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
    inputTransposing : 0,
    offset : 1,
    buffer,
  });

  var expected = vec([ 1, 6, 11 ]);
  var diagonal = m.diagonalGet();
  test.identical( diagonal, expected );

  /* */

  test.case = 'diagonalGet null row';

  var m = _.Matrix.Make([ 0, 4 ]);
  var expected = fvec([]);
  var diagonal = m.diagonalGet();
  test.identical( diagonal, expected );

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
    inputTransposing : 1,
    offset : 1,
    buffer,
  });

  var expected = vec([ 1, 6, 11 ]);
  var diagonal = m.diagonalGet();
  test.identical( diagonal, expected );

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
    inputTransposing : 0,
    offset : 1,
    buffer,
  });

  var expected = vec([ 1, 6, 11 ]);
  var diagonal = m.diagonalGet();
  test.identical( diagonal, expected );

  /* */

  test.case = 'diagonalGet null column';

  var m = _.Matrix.Make([ 4, 0 ]);
  var expected = fvec([]);
  var diagonal = m.diagonalGet();
  test.identical( diagonal, expected );

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

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    11, 2, 3,
    4, 22, 6,
  ]);

  m.diagonalSet( ivec([ 11, 22 ]) );
  test.identical( m, expected );

  /* */

  test.case = 'diagonalSet 2x3';

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    11, 2, 3,
    4, 22, 6,
  ]);

  m.diagonalSet([ 11, 22 ]);
  test.identical( m, expected );

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    0, 2, 3,
    4, 0, 6,
  ]);

  m.diagonalSet( 0 );
  test.identical( m, expected );

  /* */

  test.case = 'diagonalSet 3x2';

  var m = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1, 2,
    3, 4,
    5, 6,
  ]);

  var expected = _.Matrix.Make([ 3, 2 ]).copy
  ([
    11, 2,
    3, 22,
    5, 6,
  ]);

  m.diagonalSet([ 11, 22 ]);
  test.identical( m, expected );

  var expected = _.Matrix.Make([ 3, 2 ]).copy
  ([
    0, 2,
    3, 0,
    5, 6,
  ]);

  m.diagonalSet( 0 );
  test.identical( m, expected );

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

  var expected = _.Matrix.Make([ 3, 4 ]).copy
  ([
    10, 2, 3, 4,
    5, 20, 7, 8,
    9, 10, 30, 12,
  ]);

  m1.diagonalSet( m2 );
  test.identical( m1, expected );

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

  var expected = _.Matrix.Make([ 4, 3 ]).copy
  ([
    10, 2, 3,
    4, 20, 6,
    7, 8, 30,
    10, 11, 12,
  ]);

  m1.diagonalSet( m2 );
  test.identical( m1, expected );

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

  var expected = _.Matrix.Make([ 3, 2 ]).copy
  ([
    1, 0,
    0, 1,
    0, 0,
  ]);

  m.identity();
  test.identical( m, expected );

  /* */

  test.case = 'identity 2x3';

  var m = _.Matrix.MakeZero([ 2, 3 ]);

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    1, 0, 0,
    0, 1, 0,
  ]);

  m.identity();
  test.identical( m, expected );

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

  var expected = _.Matrix.Make([ 3, 4 ]).copy
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
    inputTransposing : 1,
    offset : 1,
    buffer,
  });

  m.triangleLowerSet( 0 );
  test.identical( m, expected );

  var expected = _.Matrix.Make([ 3, 4 ]).copy
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
  test.identical( m, expected );

  /* */

  test.case = 'triangleLowerSet 4x3';

  var expected = _.Matrix.Make([ 4, 3 ]).copy
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
    inputTransposing : 1,
    offset : 1,
    buffer,
  });

  m.triangleLowerSet( 0 );
  test.identical( m, expected );

  var expected = _.Matrix.Make([ 4, 3 ]).copy
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
  test.identical( m, expected );

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
    inputTransposing : 1,
    offset : 1,
    buffer,
  });

  var expected = _.Matrix.Make([ 4, 1 ]).copy
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
  test.identical( m, expected );

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
    inputTransposing : 1,
    offset : 1,
    buffer,
  });

  var expected = _.Matrix.Make([ 1, 4 ]).copy
  ([
    1, 2, 3, 4,
  ]);

  var m2 = _.Matrix.Make([ 1, 1 ]).copy
  ([
    -10,
  ]);

  m.triangleLowerSet( m2 );
  test.identical( m, expected );

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

  var expected = _.Matrix.Make([ 4, 3 ]).copy
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
    inputTransposing : 1,
    offset : 1,
    buffer,
  });

  m.triangleUpperSet( 0 );
  test.identical( m, expected );

  var expected = _.Matrix.Make([ 4, 3 ]).copy
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
  test.identical( m, expected );

  /* */

  test.case = 'triangleUpperSet 3x4';

  var expected = _.Matrix.Make([ 3, 4 ]).copy
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
    inputTransposing : 1,
    offset : 1,
    buffer,
  });

  m.triangleUpperSet( 0 );
  test.identical( m, expected );

  var m2 = _.Matrix.Make([ 3, 4 ]).copy
  ([
    -1, 10, 20, 30,
    -1, -1, 40, 50,
    -1, -1, -1, 60,
  ]);

  var expected = _.Matrix.Make([ 3, 4 ]).copy
  ([
    1, 10, 20, 30,
    5, 6, 40, 50,
    9, 10, 11, 60,
  ]);

  m.triangleUpperSet( m2 );
  test.identical( m, expected );

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
    inputTransposing : 1,
    offset : 1,
    buffer,
  });

  var m2 = _.Matrix.Make([ 1, 4 ]).copy
  ([
    -1, 10, 20, 30,
  ]);

  var expected = _.Matrix.Make([ 1, 4 ]).copy
  ([
    1, 10, 20, 30,
  ]);

  m.triangleUpperSet( m2 );
  test.identical( m, expected );

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
    inputTransposing : 1,
    offset : 1,
    buffer,
  });

  var m2 = _.Matrix.Make([ 1, 1 ]).copy
  ([
    -1,
  ]);

  var expected = _.Matrix.Make([ 4, 1 ]).copy
  ([
    1,
    2,
    3,
    4,
  ]);

  m.triangleUpperSet( m2 );
  test.identical( m, expected );

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
    var expected = _.Matrix.Make([ 0, 0 ]);
    var r = m[ rname ]( 0 );
    test.identical( m.dims, [ 0, 3 ] );
    test.is( m === r );

    var m = _.Matrix.Make([ 3, 0 ]);
    var expected = _.Matrix.Make([ 0, 0 ]);
    var r = m[ rname ]( 0 );
    test.identical( m.dims, [ 3, 0 ] );
    test.is( m === r );

    /* */

    test.case = rname + ' null matrix by null matrix';

    var m = _.Matrix.Make([ 0, 0 ]);
    var expected = _.Matrix.Make([ 0, 0 ]);
    var r = m[ rname ]( _.Matrix.Make([ 0, 0 ]) );
    test.is( m === r );

    var m = _.Matrix.Make([ 0, 0 ]);
    var expected = _.Matrix.Make([ 0, 0 ]);
    var r = m[ rname ]( _.Matrix.Make([ 0, 3 ]) );
    test.is( m === r );

    var m = _.Matrix.Make([ 0, 0 ]);
    var expected = _.Matrix.Make([ 0, 0 ]);
    var r = m[ rname ]( _.Matrix.Make([ 3, 0 ]) );
    test.is( m === r );

    /* */

    if( rname !== 'triangleUpperSet' )
    {

      var m = _.Matrix.Make([ 0, 3 ]);
      var expected = _.Matrix.Make([ 0, 0 ]);
      var r = m[ rname ]( _.Matrix.Make([ 0, 0 ]) );
      test.is( m === r );

      var m = _.Matrix.Make([ 0, 3 ]);
      var expected = _.Matrix.Make([ 0, 0 ]);
      var r = m[ rname ]( _.Matrix.Make([ 3, 0 ]) );
      test.is( m === r );

    }

    var m = _.Matrix.Make([ 0, 3 ]);
    var expected = _.Matrix.Make([ 0, 0 ]);
    var r = m[ rname ]( _.Matrix.Make([ 0, 3 ]) );
    test.is( m === r );

    /* */

    if( rname !== 'triangleLowerSet' )
    {
      var m = _.Matrix.Make([ 3, 0 ]);
      var expected = _.Matrix.Make([ 0, 0 ]);
      var r = m[ rname ]( _.Matrix.Make([ 0, 0 ]) );
      test.is( m === r );

      var m = _.Matrix.Make([ 3, 0 ]);
      var expected = _.Matrix.Make([ 0, 0 ]);
      var r = m[ rname ]( _.Matrix.Make([ 0, 3 ]) );
      test.is( m === r );
    }

    var m = _.Matrix.Make([ 3, 0 ]);
    var expected = _.Matrix.Make([ 0, 0 ]);
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

  var expected = _.Matrix.Make([ 4, 3 ]).copy
  ([
    1, 2, 3,
    7, 8, 9,
    4, 5, 6,
    11, 22, 33,
  ]);

  m.rowsSwap( 3, 0 ).rowsSwap( 0, 3 ).rowsSwap( 1, 2 ).rowsSwap( 0, 0 );
  test.identical( m, expected );

  /* */

  test.case = 'rowsSwap row with itself';

  m.rowsSwap( 0, 0 );
  test.identical( m, expected );

  /* */

  test.case = 'linesSwap';

  var m = _.Matrix.Make([ 4, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
    11, 22, 33,
  ]);

  var expected = _.Matrix.Make([ 4, 3 ]).copy
  ([
    1, 2, 3,
    7, 8, 9,
    4, 5, 6,
    11, 22, 33,
  ]);

  m.linesSwap( 0, 3, 0 ).linesSwap( 0, 0, 3 ).linesSwap( 0, 1, 2 ).linesSwap( 0, 0, 0 );
  test.identical( m, expected );

  /* */

  test.case = 'linesSwap row with itself';

  m.linesSwap( 0, 0, 0 );
  test.identical( m, expected );

  /* */

  test.case = 'colsSwap';

  var m = _.Matrix.Make([ 3, 4 ]).copy
  ([
    1, 2, 3, 4,
    5, 6, 7, 8,
    9, 10, 11, 12,
  ]);

  var expected = _.Matrix.Make([ 3, 4 ]).copy
  ([
    1, 3, 2, 4,
    5, 7, 6, 8,
    9, 11, 10, 12,
  ]);

  m.colsSwap( 0, 3 ).colsSwap( 3, 0 ).colsSwap( 1, 2 ).colsSwap( 0, 0 );
  test.identical( m, expected );

  /* */

  test.case = 'colsSwap row with itself';

  m.colsSwap( 0, 0 );
  test.identical( m, expected );

  /* */

  test.case = 'linesSwap';

  var m = _.Matrix.Make([ 3, 4 ]).copy
  ([
    1, 2, 3, 4,
    5, 6, 7, 8,
    9, 10, 11, 12,
  ]);

  var expected = _.Matrix.Make([ 3, 4 ]).copy
  ([
    1, 3, 2, 4,
    5, 7, 6, 8,
    9, 11, 10, 12,
  ]);

  m.linesSwap( 1, 0, 3 ).linesSwap( 1, 3, 0 ).linesSwap( 1, 1, 2 ).linesSwap( 0, 0, 0 );
  test.identical( m, expected );

  /* */

  test.case = 'linesSwap row with itself';

  m.linesSwap( 1, 0, 0 );
  test.identical( m, expected );

  /* */

  test.case = 'elementsSwap';

  var m = _.Matrix.Make([ 3, 4 ]).copy
  ([
    1, 2, 3, 4,
    5, 6, 7, 8,
    9, 10, 11, 12,
  ]);

  var expected = _.Matrix.Make([ 3, 4 ]).copy
  ([
    1, 3, 2, 4,
    5, 7, 6, 8,
    9, 11, 10, 12,
  ]);

  m.elementsSwap( 0, 3 ).elementsSwap( 3, 0 ).elementsSwap( 1, 2 ).elementsSwap( 0, 0 );
  test.identical( m, expected );

  /* */

  test.case = 'elementsSwap row with itself';

  m.elementsSwap( 0, 0 );
  test.identical( m, expected );

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

function pivot( test )
{

  /* */

  test.case = 'simple row pivot';

  var expected = _.Matrix.Make([ 2, 3 ]).copy
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

  var pivots =
  [
    [ 1, 0 ],
    [ 0, 1, 2 ],
  ]

  var pivotsExpected =
  [
    [ 1, 0 ],
    [ 0, 1, 2 ],
  ]

  m.pivotForward( pivots );
  test.identical( m, expected );
  test.identical( pivots, pivotsExpected );

  m.pivotBackward( pivots );
  test.identical( m, original );
  test.identical( pivots, pivotsExpected );

  /* */

  test.case = 'complex row pivot';

  var expected = _.Matrix.Make([ 3, 2 ]).copy
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

  var pivots =
  [
    [ 2, 0, 1 ],
    [ 0, 1 ],
  ]

  var pivotsExpected =
  [
    [ 2, 0, 1 ],
    [ 0, 1 ],
  ]

  m.pivotForward( pivots );
  test.identical( m, expected );
  test.identical( pivots, pivotsExpected );

  m.pivotBackward( pivots );
  test.identical( m, original );
  test.identical( pivots, pivotsExpected );

  /* */

  test.case = 'vectorPivot matrix';

  var expected = _.Matrix.Make([ 3, 2 ]).copy
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

  var pivot = [ 2, 0, 1 ];
  var pivotExpected = [ 2, 0, 1 ];

  _.Matrix.VectorPivotForward( m, pivot );
  test.identical( m, expected );
  test.identical( pivot, pivotExpected );

  _.Matrix.VectorPivotBackward( m, pivot );
  test.identical( m, original );
  test.identical( pivot, pivotExpected );

  /* */

  test.case = 'vectorPivot vector';

  var expected = vec([ 3, 1, 2 ]);
  var a = vec([ 1, 2, 3 ]);
  var original = a.clone();

  var pivot = [ 2, 0, 1 ];
  var pivotExpected = [ 2, 0, 1 ];

  _.Matrix.VectorPivotForward( a, pivot );
  test.identical( a, expected );
  test.identical( pivot, pivotExpected );

  _.Matrix.VectorPivotBackward( a, pivot );
  test.identical( a, original );
  test.identical( pivot, pivotExpected );

  /* */

  test.case = 'vectorPivot array';

  var expected = [ 3, 1, 2 ];
  var a = [ 1, 2, 3 ];
  var original = a.slice();

  var pivot = [ 2, 0, 1 ];
  var pivotExpected = [ 2, 0, 1 ];

  _.Matrix.VectorPivotForward( a, pivot );
  test.identical( a, expected );
  test.identical( pivot, pivotExpected );

  _.Matrix.VectorPivotBackward( a, pivot );
  test.identical( a, original );
  test.identical( pivot, pivotExpected );

  /* */

  test.case = 'no pivots';

  var expected = _.Matrix.Make([ 2, 3 ]).copy
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

  var pivots =
  [
    [ 0, 1 ],
    [ 0, 1, 2 ],
  ]

  m.pivotForward( pivots );
  test.identical( m, expected );

  m.pivotBackward( pivots );
  test.identical( m, original );

  /* */

  test.case = 'complex col pivot';

  var expected = _.Matrix.Make([ 2, 3 ]).copy
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

  var pivots =
  [
    [ 0, 1 ],
    [ 2, 0, 1 ],
  ]

  m.pivotForward( pivots );
  test.identical( m, expected );

  m.pivotBackward( pivots );
  test.identical( m, original );

  /* */

  test.case = 'complex col pivot';

  var expected = _.Matrix.Make([ 2, 3 ]).copy
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

  var pivots =
  [
    [ 0, 1 ],
    [ 2, 1, 0 ],
  ]

  m.pivotForward( pivots );
  test.identical( m, expected );

  m.pivotBackward( pivots );
  test.identical( m, original );

  /* */

  test.case = 'complex col pivot';

  var expected = _.Matrix.Make([ 2, 3 ]).copy
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

  var pivots =
  [
    [ 0, 1 ],
    [ 1, 2, 0 ],
  ]

  m.pivotForward( pivots );
  test.identical( m, expected );

  m.pivotBackward( pivots );
  test.identical( m, original );

  /* */

  test.case = 'mixed pivot';

  var expected = _.Matrix.Make([ 2, 3 ]).copy
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

  var pivots =
  [
    [ 1, 0 ],
    [ 1, 2, 0 ],
  ]

  var pivotsExpected =
  [
    [ 1, 0 ],
    [ 1, 2, 0 ],
  ]

  m.pivotForward( pivots );
  test.identical( m, expected );
  test.identical( pivots, pivotsExpected );

  m.pivotBackward( pivots );
  test.identical( m, original );
  test.identical( pivots, pivotsExpected );

  /* */

  test.case = 'partially defined pivot';

  var expected = _.Matrix.Make([ 2, 3 ]).copy
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

  var pivots =
  [
    [ 1, 0 ],
    null,
  ]

  var pivotsExpected =
  [
    [ 1, 0 ],
    null,
  ]

  m.pivotForward( pivots );
  test.identical( m, expected );
  test.identical( pivots, pivotsExpected );

  m.pivotBackward( pivots );
  test.identical( m, original );
  test.identical( pivots, pivotsExpected );

}

//

function submatrix( test )
{
  let context = this;

  var o = Object.create( null );
  o.test = test;

  o.offset = 0;
  o.inputTransposing = 0;
  _submatrix( o )

  o.offset = 0;
  o.inputTransposing = 1;
  _submatrix( o )

  o.offset = 10;
  o.inputTransposing = 0;
  _submatrix( o )

  o.offset = 10;
  o.inputTransposing = 1;
  _submatrix( o )

  /* */

  function _submatrix( o )
  {
    var test = o.test;

    /* */

    test.case = 'verification';

    var expected = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +2, +3, +4,
      +5, +6, +7, +8,
      +9, +10, +11, +12,
    ]);

    var m = make();
    test.identical( m, expected );
    test.identical( m.offset, o.offset );
    test.identical( m.inputTransposing, o.inputTransposing );

    /* */

    test.case = 'simple submatrix';

    var m = make();
    var c1 = m.submatrix( _.all, 0 );
    var c2 = m.submatrix( _.all, 3 );
    var r1 = m.submatrix( 0, _.all );
    var r2 = m.submatrix( 2, _.all );

    var expected = _.Matrix.MakeCol([ 1, 5, 9 ]);
    test.identical( c1, expected );

    var expected = _.Matrix.MakeCol([ 4, 8, 12 ]);
    test.identical( c2, expected );

    var expected = _.Matrix.MakeRow([ 1, 2, 3, 4 ]);
    test.identical( r1, expected );

    var expected = _.Matrix.MakeRow([ 9, 10, 11, 12 ]);
    test.identical( r2, expected );

    var expected = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +11, +3, +4, +401,
      +50, +6, +7, +800,
      +93, +13, +14, +1203,
    ]);

    c1.mul( 10 );
    c2.mul( 100 );
    r1.add( 1 );
    r2.add( 3 );

    test.identical( m, expected );
    test.identical( c1.inputTransposing, o.inputTransposing );
    test.identical( c2.inputTransposing, o.inputTransposing );
    test.identical( r1.inputTransposing, o.inputTransposing );
    test.identical( r2.inputTransposing, o.inputTransposing );

    /* */

    test.case = 'submatrix [ 1, 2 ], null';

    var m = make();
    var expected = _.Matrix.Make([ 2, 4 ]).copy
    ([
      +5, +6, +7, +8,
      +9, +10, +11, +12,
    ]);

    var sub = m.submatrix( [ 1, 2 ], null );
    test.identical( sub, expected );
    test.identical( sub.inputTransposing, o.inputTransposing );

    var expected = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +2, +3, +4,
      +50, +60, +70, +80,
      +90, +100, +110, +120,
    ]);

    sub.mul( 10 );
    test.identical( m, expected );

    /* */

    test.case = 'submatrix [ 1, 2 ], _.all';

    var m = make();
    var expected = _.Matrix.Make([ 2, 4 ]).copy
    ([
      +5, +6, +7, +8,
      +9, +10, +11, +12,
    ]);

    var sub = m.submatrix( [ 1, 2 ], _.all );
    test.identical( sub, expected );
    test.identical( sub.inputTransposing, o.inputTransposing );

    var expected = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +2, +3, +4,
      +50, +60, +70, +80,
      +90, +100, +110, +120,
    ]);

    sub.mul( 10 );
    test.identical( m, expected );

    /* */

    test.case = 'submatrix null, [ 1, 2 ]';

    var m = make();
    var expected = _.Matrix.Make([ 3, 2 ]).copy
    ([
      +2, +3,
      +6, +7,
      +10, +11,
    ]);

    var sub = m.submatrix( null, [ 1, 2 ] );
    test.identical( sub, expected );
    test.identical( sub.inputTransposing, o.inputTransposing );

    var expected = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +20, +30, +4,
      +5, +60, +70, +8,
      +9, +100, +110, +12,
    ]);

    sub.mul( 10 );
    test.identical( m, expected );

    /* */

    test.case = 'submatrix _.all, [ 1, 2 ]';

    var m = make();
    var expected = _.Matrix.Make([ 3, 2 ]).copy
    ([
      +2, +3,
      +6, +7,
      +10, +11,
    ]);

    var sub = m.submatrix( _.all, [ 1, 2 ] );
    test.identical( sub, expected );
    test.identical( sub.inputTransposing, o.inputTransposing );

    var expected = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +20, +30, +4,
      +5, +60, +70, +8,
      +9, +100, +110, +12,
    ]);

    sub.mul( 10 );
    test.identical( m, expected );

    /* */

    test.case = 'columns [ 1, 2 ]';

    var m = make();
    var expected = _.Matrix.Make([ 3, 2 ]).copy
    ([
      +2, +3,
      +6, +7,
      +10, +11,
    ]);

    var sub = m.submatrix( _.all, [ 1, 2 ] );
    test.identical( sub, expected );
    test.identical( sub.inputTransposing, o.inputTransposing );

    var expected = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +20, +30, +4,
      +5, +60, +70, +8,
      +9, +100, +110, +12,
    ]);

    sub.mul( 10 );
    test.identical( m, expected );

    /* */

    test.case = 'columns [ 2, 3 ]';

    var m = make();
    var expected = _.Matrix.Make([ 3, 2 ]).copy
    ([
      +3, +4,
      +7, +8,
      +11, +12,
    ]);

    var sub = m.submatrix( _.all, [ 2, 3 ] );
    test.identical( sub, expected );
    test.identical( sub.inputTransposing, o.inputTransposing );

    var expected = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +2, +30, +40,
      +5, +6, +70, +80,
      +9, +10, +110, +120,
    ]);

    sub.mul( 10 );
    test.identical( m, expected );

    /* */

    test.case = 'columns [ 0, 1 ]';

    var m = make();
    var expected = _.Matrix.Make([ 3, 2 ]).copy
    ([
      +1, +2,
      +5, +6,
      +9, +10,
    ]);

    var sub = m.submatrix( _.all, [ 0, 1 ] );
    test.identical( sub, expected );
    test.identical( sub.inputTransposing, o.inputTransposing );

    var expected = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +10, +20, +3, +4,
      +50, +60, +7, +8,
      +90, +100, +11, +12,
    ]);

    sub.mul( 10 );
    test.identical( m, expected );

    /* */

    test.case = 'rows [ 0, 1 ]';

    var m = make();
    var expected = _.Matrix.Make([ 2, 4 ]).copy
    ([
      +1, +2, +3, +4,
      +5, +6, +7, +8,
    ]);

    var sub = m.submatrix( [ 0, 1 ], _.all );
    test.identical( sub, expected );
    test.identical( sub.inputTransposing, o.inputTransposing );

    var expected = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +10, +20, +30, +40,
      +50, +60, +70, +80,
      +9, +10, +11, +12,
    ]);

    sub.mul( 10 );
    test.identical( m, expected );

    /* */

    test.case = 'rows [ 1, 2 ]';

    var m = make();
    var expected = _.Matrix.Make([ 2, 4 ]).copy
    ([
      +5, +6, +7, +8,
      +9, +10, +11, +12,
    ]);


    var sub = m.submatrix( [ 1, 2 ], _.all );
    test.identical( sub, expected );
    test.identical( sub.inputTransposing, o.inputTransposing );

    var expected = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +2, +3, +4,
      +50, +60, +70, +80,
      +90, +100, +110, +120,
    ]);

    sub.mul( 10 );
    test.identical( m, expected );

    /* */

    test.case = 'rows [ 1, 1 ]';

    var m = make();
    var expected = _.Matrix.Make([ 1, 4 ]).copy
    ([
      +5, +6, +7, +8,
    ]);

    var sub = m.submatrix( [ 1, 1 ], _.all );
    test.identical( sub, expected );
    test.identical( sub.inputTransposing, o.inputTransposing );

    var expected = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +2, +3, +4,
      +50, +60, +70, +80,
      +9, +10, +11, +12,
    ]);

    sub.mul( 10 );
    test.identical( m, expected );

    /* */

    test.case = 'submatrix [ 0, 1 ], [ 0, 1 ] ';

    var m = make();
    var expected = _.Matrix.Make([ 2, 2 ]).copy
    ([
      +1, +2,
      +5, +6,
    ]);

    var sub = m.submatrix( [ 0, 1 ], [ 0, 1 ] );
    test.identical( sub, expected );
    test.identical( sub.inputTransposing, o.inputTransposing );

    var expected = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +10, +20, +3, +4,
      +50, +60, +7, +8,
      +9, +10, +11, +12,
    ]);

    sub.mul( 10 );
    test.identical( m, expected );

    /* */

    test.case = 'submatrix [ 0, 1 ], [ 2, 3 ] ';

    var m = make();
    var expected = _.Matrix.Make([ 2, 2 ]).copy
    ([
      +3, +4,
      +7, +8,
    ]);

    var sub = m.submatrix( [ 0, 1 ], [ 2, 3 ] );
    test.identical( sub, expected );
    test.identical( sub.inputTransposing, o.inputTransposing );

    var expected = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +2, +30, +40,
      +5, +6, +70, +80,
      +9, +10, +11, +12,
    ]);

    sub.mul( 10 );
    test.identical( m, expected );

    /* */

    test.case = 'submatrix [ 1, 2 ], [ 0, 1 ] ';

    var m = make();
    var expected = _.Matrix.Make([ 2, 2 ]).copy
    ([
      +5, +6,
      +9, +10,
    ]);

    var sub = m.submatrix( [ 1, 2 ], [ 0, 1 ] );
    test.identical( sub, expected );
    test.identical( sub.inputTransposing, o.inputTransposing );

    var expected = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +2, +3, +4,
      +50, +60, +7, +8,
      +90, +100, +11, +12,
    ]);

    sub.mul( 10 );
    test.identical( m, expected );

    /* */

    test.case = 'submatrix [ 1, 2 ], [ 2, 3 ] ';

    var m = make();
    var expected = _.Matrix.Make([ 2, 2 ]).copy
    ([
      +7, +8,
      +11, +12,
    ]);

    var sub = m.submatrix( [ 1, 2 ], [ 2, 3 ] );
    test.identical( sub, expected );
    test.identical( sub.inputTransposing, o.inputTransposing );

    var expected = _.Matrix.Make([ 3, 4 ]).copy
    ([
      +1, +2, +3, +4,
      +5, +6, +70, +80,
      +9, +10, +110, +120,
    ]);

    sub.mul( 10 );
    test.identical( m, expected );

    /* */

    function make()
    {

      var b = new F32x
      ([
        +1, +2, +3, +4,
        +5, +6, +7, +8,
        +9, +10, +11, +12,
      ]);

      if( !o.inputTransposing )
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
        inputTransposing : o.inputTransposing,
      })

      return m;
    }

  }

}

//

function subspace( test )
{

  /* */

  test.case = 'inputTransposing : 1';

  var buffer = [];
  var dims = [ 1, 3, 1, 3, 1, 3 ];
  var inputTransposing = 1;
  for( let i = _.avector.reduceToProduct( dims )-1 ; i >= 0 ; i-- )
  buffer[ i ] = i;
  var matrix = _.Matrix({ dims, inputTransposing }).copy( buffer );
  console.log( matrix.toStr() );
  console.log( '' );

  var subspace = matrix.subspace( 0, 1, 0, 1, 0, 1 );
  test.is( matrix.buffer === subspace.buffer );
  test.identical( subspace.dims, [ 3, 3, 3 ] );
  test.identical( subspace.stridesEffective, [ 1, 3, 9 ] );
  test.identical( subspace.inputTransposing, matrix.inputTransposing );

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

  test.case = 'inputTransposing : 0';

  var buffer = [];
  var dims = [ 1, 3, 1, 3, 1, 3 ];
  var inputTransposing = 0;
  for( let i = _.avector.reduceToProduct( dims )-1 ; i >= 0 ; i-- )
  buffer[ i ] = i;
  var matrix = _.Matrix({ dims, inputTransposing }).copy( buffer );
  console.log( matrix.toStr() );
  console.log( '' );

  var subspace = matrix.subspace( 0, 1, 0, 1, 0, 1 );
  test.is( matrix.buffer === subspace.buffer );
  test.identical( subspace.dims, [ 3, 3, 3 ] );
  test.identical( subspace.stridesEffective, [ 1, 3, 9 ] );
  test.identical( subspace.inputTransposing, matrix.inputTransposing );

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

function colRowWiseOperations( test )
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
    inputTransposing : 0,
  });

  var empty1 = _.Matrix.Make([ 2, 0 ]);
  empty1.buffer = new F64x();
  test.identical( empty1.dims, [ 2, 0 ] );
  test.identical( empty1.stridesEffective, [ 1, 2 ] );

  var empty2 = _.Matrix.Make([ 0, 2 ]);
  test.identical( empty2.dims, [ 0, 2 ] );
  test.identical( empty2.stridesEffective, [ 1, 0 ] );
  empty2.growingDimension = 0;
  empty2.buffer = new F64x();
  test.identical( empty2.dims, [ 0, 2 ] );
  test.identical( empty2.stridesEffective, [ 1, 0 ] );

  var matrix1 = new _.Matrix
  ({
    dims : [ 4, 3 ],
    inputTransposing : 1,
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
    inputTransposing : 1,
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
  var a = m32.reduceToMeanAtomWise();

  test.identical( c, vec([ 2.5, 3.5, 4.5 ]) );
  test.identical( r, vec([ 2, 5 ]) );
  test.identical( a, 3.5 );

  /* */

  test.case = 'reduceToMean with output argument';

  var c2 = [ 1, 1, 1 ];
  var r2 = [ 1 ];
  m32.reduceToMeanRowWise( c2 );
  m32.reduceToMeanColWise( r2 );

  test.identical( c, vec( c2 ) );
  test.identical( r, vec( r2 ) );

  /* */

  test.case = 'reduceToMean with empty matrixs';

  var c = empty1.reduceToMeanRowWise();
  var r = empty1.reduceToMeanColWise();
  var a = empty1.reduceToMeanAtomWise();

  test.identical( c, vec([ NaN, NaN ]) );
  test.identical( r, vec([]) );
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
    simpleShouldThrowError( 'reduceToMeanAtomWise' );

  }

  /* */

  test.case = 'distributionRangeSummaryColWise';

  var expected =
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
  test.contains( r, expected );

  var expected =
  [
  ]

  var r = empty1.distributionRangeSummaryColWise();
  test.identical( r, expected );

  var expected =
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
  test.identical( r, expected );

  /* */

  test.case = 'minmaxColWise';

  var expected =
  {
    min : new F64x([ 0, 0, 0 ]),
    max : new F64x([ 10, 111, 30 ]),
  }
  var r = matrix1.minmaxColWise();
  test.identical( r, expected );

  var expected =
  {
    min : new F64x([]),
    max : new F64x([]),
  }

  var r = empty1.minmaxColWise();
  test.identical( r, expected );

  var expected =
  {
    min : new F64x([ NaN, NaN ]),
    max : new F64x([ NaN, NaN ]),
  }

  var r = empty2.minmaxColWise();
  var identical = _.entityIdentical( r, expected );
  test.identical( r, expected );

  /* */

  test.case = 'distributionRangeSummaryRowWise';

  var expected =
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
  test.contains( r, expected );

  var expected =
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
  test.identical( r, expected );

  var expected =
  [
  ]

  var r = empty2.distributionRangeSummaryRowWise();
  test.identical( r, expected );

  /* */

  test.case = 'minmaxRowWise';

  var expected =
  {
    min : new F64x([ 0, 1, 10, 1 ]),
    max : new F64x([ 0, 3, 30, 111 ]),
  }
  var r = matrix1.minmaxRowWise();
  test.identical( r, expected );

  var expected =
  {
    min : new F64x([ NaN, NaN ]),
    max : new F64x([ NaN, NaN ]),
  }

  var r = empty1.minmaxRowWise();
  test.identical( r, expected );

  var expected =
  {
    min : new F64x([]),
    max : new F64x([]),
  }

  var r = empty2.minmaxRowWise();
  test.identical( r, expected );

  /* */

  test.case = 'reduceToSumColWise';

  var sum = matrix1.reduceToSumColWise();
  test.identical( sum, vec([ 12, 133, 44 ]) );
  var sum = matrix2.reduceToSumColWise();
  test.identical( sum, vec([ 16, 32, 53 ]) );
  var sum = empty1.reduceToSumColWise();
  test.identical( sum, vec([]) );
  var sum = empty2.reduceToSumColWise();
  test.identical( sum, vec([ 0, 0 ]) );

  /* */

  test.case = 'reduceToSumRowWise';

  var sum = matrix1.reduceToSumRowWise();
  test.identical( sum, vec([ 0, 6, 60, 123 ]) );
  var sum = matrix2.reduceToSumRowWise();
  test.identical( sum, vec([ 13, 21, 32, 35 ]) );
  var sum = empty1.reduceToSumRowWise();
  test.identical( sum, vec([ 0, 0 ]) );
  var sum = empty2.reduceToSumRowWise();
  test.identical( sum, vec([]) );

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
  test.identical( max, vec([ 10, 111, 30 ]) );
  var max = matrix2.reduceToMaxValueColWise();
  test.identical( max, vec([ 10, 20, 30 ]) );
  var max = empty1.reduceToMaxValueColWise();
  test.identical( max, vec([]) );
  var max = empty2.reduceToMaxValueColWise();
  test.identical( max, vec([ -Infinity, -Infinity ]) );

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
  test.identical( max, vec([ 0, 3, 30, 111 ]) );
  var max = matrix2.reduceToMaxValueRowWise();
  test.identical( max, vec([ 10, 20, 30, 20 ]) );
  var max = empty1.reduceToMaxValueRowWise();
  test.identical( max, vec([ -Infinity, -Infinity ]) );
  var max = empty2.reduceToMaxValueRowWise();
  test.identical( max, vec([]) );

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
    inputTransposing : 1,
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
  var expected = _.Matrix.MakeSquare( 3 );
  expected.buffer = new I32x
  ([
    -8, +18, -6,
    -8, +17, -7,
    +8, -16, +8
  ]);
  test.equivalent( mul, expected );

  test.case = 'matrix3 * matrix3 * matrix3';
  var mul = _.Matrix.Mul( null, [ matrix3, matrix3, matrix3 ] );
  var expected = _.Matrix.MakeSquare
  ( new I32x([
    +32, +32, -32,
    -62, -63, +64,
    +34, +33, -32,
  ]));
  test.equivalent( mul, expected );

  test.case = 'matrix3A * matrix3B';
  var mul = _.Matrix.Mul( null, [ matrix3A, matrix3B ] );
  var expected = _.Matrix.MakeSquare
  ([
    9,  36, 68,
    12, 46, 86,
    17, 64, 119,
  ]);
  test.equivalent( mul, expected );

  test.case = 'matrix3 * matrix3A * matrix3B';
  var mul = _.Matrix.Mul( null, [ matrix3, matrix3A, matrix3B ] );
  var expected = _.Matrix.MakeSquare
  ([
    +8,  +36,  +70,
    +14, +46,  +82,
    +38, +154, +292,
  ]);
  test.equivalent( mul, expected );

  /* - */

  test.case = 'identity * colA';
  var identity = _.Matrix.MakeIdentity( 3 );
  var mul = _.Matrix.Mul( null, [ identity, colA ] );
  var expected = _.Matrix.MakeCol([ 1, 2, 3 ]);
  test.equivalent( mul, expected );

  test.case = 'rowA * identity';
  var identity = _.Matrix.MakeIdentity( 3 );
  var mul = _.Matrix.Mul( null, [ rowA, identity ] );
  var expected = _.Matrix.MakeRow([ 1, 2, 3 ]);
  test.equivalent( mul, expected );

  test.case = 'matrix3 * colA';
  var mul = _.Matrix.Mul( null, [ matrix3, colA ] );
  var expected = _.Matrix.MakeCol([ 0, 4, 4 ]);
  test.equivalent( mul, expected );

  test.case = 'rowA * matrix3';
  var mul = _.Matrix.Mul( null, [ rowA, matrix3 ] );
  var expected = _.Matrix.MakeRow([ 10, 5, 0 ]);
  expected.buffer = new I32x([ 10, 5, 0 ]);
  test.equivalent( mul, expected );

  /* */

  test.case = 'rowA * colA';
  var mul = _.Matrix.Mul( null, [ rowA, colA ] );
  var expected = _.Matrix.MakeRow([ 14 ]);
  test.equivalent( mul, expected );

  test.case = 'colA * rowA';
  var mul = _.Matrix.Mul( null, [ colA, rowA ] );
  var expected = _.Matrix.MakeSquare
  ([
    1, 2, 3,
    2, 4, 6,
    3, 6, 9,
  ]);
  test.equivalent( mul, expected );

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
  var expected = _.Matrix.Make([ 4, 4 ]).copy
  ([
    +5, +2, +5, +2,
    -2, +0, -2, +0,
    +3, +4, +3, +4,
    -1, +0, -1, +0,
  ]);

  var mul = _.Matrix.Mul( null, [ matrix3x4, matrix4x3 ] );
  test.equivalent( mul, expected );

  test.case = '3x4 * 4x3';
  var expected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +4, +8, +5,
    -2, +2, +1,
    +3, +3, +2,
  ]);
  var mul = _.Matrix.Mul( null, [ matrix4x3, matrix3x4 ] );
  test.equivalent( mul, expected );

  test.case = '3x4 * 4x3';
  var expected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +4, -2, +3,
    +8, +2, +3,
    +5, +1, +2,
  ]);
  var mul = _.Matrix.Mul( null, [ t1, t2 ] );
  test.equivalent( mul, expected );

  test.case = '4x3 * 4x3t';
  var expected = _.Matrix.Make([ 4, 4 ]).copy
  ([
    +5, -2, +3, -1,
    -2, +2, +2, +2,
    +3, +2, +11, +3,
    -1, +2, +3, +3,
  ]);
  var mul = _.Matrix.Mul( null, [ matrix3x4, t1 ] );
  test.equivalent( mul, expected );

  /* */

  test.case = 'mul itself';
  var m = matrix3B.clone();
  var expected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +6, +23, +43,
    +9, +36, +68,
    +16, +67, +128,
  ]);
  var mul = _.Matrix.Mul( m, [ m, m ] );
  test.equivalent( mul, expected );
  test.is( mul === m );

  test.case = 'mul itself 2 times';
  var m = matrix3B.clone();
  var expected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +72, +296, +563,
    +113, +466, +887,
    +211, +873, +1663,
  ]);
  var mul = _.Matrix.Mul( m, [ m, m, m ] );
  test.equivalent( mul, expected );
  test.is( mul === m );

  test.case = 'mul itself 3 times';
  var m = matrix3B.clone();
  var expected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +931, +3847, +7326,
    +1466, +6059, +11539,
    +2747, +11356, +21628,
  ]);
  var mul = _.Matrix.Mul( m, [ m, m, m, m ] );
  test.equivalent( mul, expected );
  test.is( mul === m );

  test.case = 'mul 3 matrices with dst === src';
  var matrix3x4 = matrix3A.clone();
  var matrix4x3 = matrix3B.clone();
  var expected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +113, +466, +887,
    +144, +592, +1126,
    +200, +821, +1561,
  ]);
  var mul = _.Matrix.Mul( matrix3x4, [ matrix3x4, matrix4x3, matrix4x3 ] );
  test.equivalent( mul, expected );
  test.is( mul === matrix3x4 );

  test.case = 'mul 3 matrices with dst === src';
  var matrix3x4 = matrix3A.clone();
  var matrix4x3 = matrix3B.clone();
  var expected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +113, +466, +887,
    +144, +592, +1126,
    +200, +821, +1561,
  ]);
  var mul = _.Matrix.Mul( matrix4x3, [ matrix3x4, matrix4x3, matrix4x3 ] );
  test.equivalent( mul, expected );
  test.is( mul === matrix4x3 );

  test.case = 'mul 4 matrices with dst === src';
  var matrix3x4 = matrix3A.clone();
  var matrix4x3 = matrix3B.clone();
  var expected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +3706, +7525, +10457,
    +4706, +9556, +13280,
    +6525, +13250, +18414,
  ]);
  var mul = _.Matrix.Mul( matrix3x4, [ matrix3x4, matrix4x3, matrix4x3, matrix3x4 ] );
  test.equivalent( mul, expected );
  test.is( mul === matrix3x4 );

  test.case = 'mul 4 matrices with dst === src';
  var matrix3x4 = matrix3A.clone();
  var matrix4x3 = matrix3B.clone();
  var expected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +3706, +7525, +10457,
    +4706, +9556, +13280,
    +6525, +13250, +18414,
  ]);
  var mul = _.Matrix.Mul( matrix4x3, [ matrix3x4, matrix4x3, matrix4x3, matrix3x4 ] );
  test.equivalent( mul, expected );
  test.is( mul === matrix4x3 );

  test.case = '_.Matrix array multiplication';
  var m = matrix3A.clone();
  var v = [ 1, 2, 3 ];
  var expected = [ 22 , 28 , 39 ];
  var mul = _.Matrix.Mul( v, [ m, v ] );
  test.equivalent( mul, expected );
  test.is( v === mul );

  test.case = '_.Matrix vector multiplication';
  var m = matrix3A.clone();
  var v = vec([ 1, 2, 3 ]);
  var expected = vec([ 22 , 28 , 39 ]);
  var mul = _.Matrix.Mul( v, [ m, v ] );
  test.equivalent( mul, expected );
  test.is( v === mul );

  test.case = '_.Matrix array _.Matrix multiplication';
  var m = matrix3A.clone();
  var v = [ 1, 2, 3 ];
  var row = _.Matrix.MakeRow([ 3, 4, 5 ]);
  var expected = [ 8206 , 10444 , 14547 ];
  var mul = _.Matrix.Mul( v, [ m, v, row, m, v ] );
  test.equivalent( mul, expected );
  test.is( v === mul );

  test.case = '_.Matrix array _.Matrix multiplication';
  var m = matrix3A.clone();
  var v = [ 1, 2, 3 ];
  var row = _.Matrix.MakeRow([ 3, 4, 5 ]);
  var expected = [ 82060 , 104440 , 145470 ];
  var mul = _.Matrix.Mul( v, [ m, v, row, m, v, [ 10 ] ] );
  test.equivalent( mul, expected );
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

  test.identical( sub1, exp );

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
  test.identical( got, exp );

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

function addAtomWise( test )
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

    v1 = vad.fromLong([ 9, 8 ]);
    a1 = [ 6, 5 ];

  }

  /* */

  test.case = 'addAtomWise 2 matrixs';

  remake();

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    +11, +22, +33,
    +44, +55, +66,
  ]);

  var r = _.Matrix.addAtomWise( m1, m2 );
  test.equivalent( r, expected );
  test.is( r === m1 );

  /* */

  test.case = 'addAtomWise 2 matrixs with null';

  remake();

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    +11, +22, +33,
    +44, +55, +66,
  ]);

  var r = _.Matrix.addAtomWise( null, m1, m2 );
  test.equivalent( r, expected );
  test.is( r !== m1 );

  /* */

  test.case = 'addAtomWise 3 matrixs into the first src';

  remake();

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    +111, +222, +333,
    +444, +555, +666,
  ]);

  var r = _.Matrix.addAtomWise( null, m1, m2, m3 );
  test.equivalent( r, expected );
  test.is( r !== m1 );

  /* */

  test.case = 'addAtomWise 3 matrixs into the first src';

  remake();

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    +111, +222, +333,
    +444, +555, +666,
  ]);

  var r = _.Matrix.addAtomWise( m1, m2, m3 );
  test.equivalent( r, expected );
  test.is( r === m1 );

  /* */

  test.case = 'addAtomWise matrix and scalar';

  remake();

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    +11, +12, +13,
    +14, +15, +16,
  ]);

  var r = _.Matrix.addAtomWise( null, m1, 10 );
  test.equivalent( r, expected );
  test.is( r !== m1 );

  /* */

  test.case = 'addAtomWise _.all sort of arguments';

  remake();

  var expected = _.Matrix.Make([ 2, 1 ]).copy
  ([
    13,
    14,
  ]);

  var r = _.Matrix.addAtomWise( null, m5, 10 );
  test.equivalent( r, expected );
  test.is( r !== m5 );

  var expected = _.Matrix.Make([ 2, 1 ]).copy
  ([
    22,
    22,
  ]);

  var r = _.Matrix.addAtomWise( null, m5, 10, v1 );
  test.equivalent( r, expected );
  test.is( r !== m5 );

  var expected = _.Matrix.Make([ 2, 1 ]).copy
  ([
    28,
    27,
  ]);

  var r = _.Matrix.addAtomWise( null, m5, 10, v1, a1 );
  test.equivalent( r, expected );
  test.is( r !== m5 );

  /* */

  test.case = 'addAtomWise _.all sort of arguments';

  remake();

  var expected = _.Matrix.Make([ 2, 1 ]).copy
  ([
    22,
    22,
  ]);

  var r = _.Matrix.addAtomWise( m5, 10, v1 );
  test.equivalent( r, expected );
  test.is( r === m5 );

  remake();

  var expected = _.Matrix.Make([ 2, 1 ]).copy
  ([
    28,
    27,
  ]);

  var r = _.Matrix.addAtomWise( m5, 10, v1, a1 );
  test.equivalent( r, expected );
  test.is( r === m5 );

  remake();

  var expected = _.Matrix.Make([ 2, 1 ]).copy
  ([
    29,
    29,
  ]);

  var r = _.Matrix.addAtomWise( m5, 10, v1, a1, m4 );
  test.equivalent( r, expected );
  test.is( r === m5 );

  /* */

  test.case = 'addAtomWise rewriting src argument';

  remake();

  var expected = _.Matrix.Make([ 2, 1 ]).copy
  ([
    27,
    27,
  ]);

  var r = _.Matrix.addAtomWise( m4, 10, v1, a1, m4 );
  test.equivalent( r, expected );
  test.is( r === m4 );

}

//

function subAtomWise( test )
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

    v1 = vad.fromLong([ 9, 8 ]);
    a1 = [ 6, 5 ];

  }

  /* */

  test.case = '2 matrixs';

  remake();

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    -9, -18, -27,
    -36, -45, -54,
  ]);

  var r = _.Matrix.subAtomWise( m1, m2 );
  test.equivalent( r, expected );
  test.is( r === m1 );

  /* */

  test.case = '2 matrixs with null';

  remake();

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    -9, -18, -27,
    -36, -45, -54,
  ]);

  var r = _.Matrix.subAtomWise( null, m1, m2 );
  test.equivalent( r, expected );
  test.is( r !== m1 );

  /* */

  test.case = '3 matrixs into the first src';

  remake();

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    -109, -218, -327,
    -436, -545, -654,
  ]);

  var r = _.Matrix.subAtomWise( null, m1, m2, m3 );
  test.equivalent( r, expected );
  test.is( r !== m1 );

  /* */

  test.case = '3 matrixs into the first src';

  remake();

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    -109, -218, -327,
    -436, -545, -654,
  ]);

  var r = _.Matrix.subAtomWise( m1, m2, m3 );
  test.equivalent( r, expected );
  test.is( r === m1 );

  /* */

  test.case = 'matrix and scalar';

  remake();

  var expected = _.Matrix.Make([ 2, 3 ]).copy
  ([
    -9, -8, -7,
    -6, -5, -4,
  ]);

  var r = _.Matrix.subAtomWise( null, m1, 10 );
  test.equivalent( r, expected );
  test.is( r !== m1 );

  /* */

  test.case = '_.all sort of arguments';

  remake();

  var expected = _.Matrix.Make([ 2, 1 ]).copy
  ([
    -7,
    -6,
  ]);

  var r = _.Matrix.subAtomWise( null, m5, 10 );
  test.equivalent( r, expected );
  test.is( r !== m5 );

  var expected = _.Matrix.Make([ 2, 1 ]).copy
  ([
    -16,
    -14,
  ]);

  var r = _.Matrix.subAtomWise( null, m5, 10, v1 );
  test.equivalent( r, expected );
  test.is( r !== m5 );

  var expected = _.Matrix.Make([ 2, 1 ]).copy
  ([
    -22,
    -19,
  ]);

  var r = _.Matrix.subAtomWise( null, m5, 10, v1, a1 );
  test.equivalent( r, expected );
  test.is( r !== m5 );

  /* */

  test.case = '_.all sort of arguments';

  remake();

  var expected = _.Matrix.Make([ 2, 1 ]).copy
  ([
    -16,
    -14,
  ]);

  var r = _.Matrix.subAtomWise( m5, 10, v1 );
  test.equivalent( r, expected );
  test.is( r === m5 );

  remake();

  var expected = _.Matrix.Make([ 2, 1 ]).copy
  ([
    -22,
    -19,
  ]);

  var r = _.Matrix.subAtomWise( m5, 10, v1, a1 );
  test.equivalent( r, expected );
  test.is( r === m5 );

  remake();

  var expected = _.Matrix.Make([ 2, 1 ]).copy
  ([
    -23,
    -21,
  ]);

  var r = _.Matrix.subAtomWise( m5, 10, v1, a1, m4 );
  test.equivalent( r, expected );
  test.is( r === m5 );

  /* */

  test.case = 'rewriting src argument';

  remake();

  var expected = _.Matrix.Make([ 2, 1 ]).copy
  ([
    -25,
    -23,
  ]);

  var r = _.Matrix.subAtomWise( m4, 10, v1, a1, m4 );
  test.equivalent( r, expected );
  test.is( r === m4 );

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

  var expected = { index : 2, distance : sqrt( sqr( 3 ) + sqr( 6 ) ) };
  var got = m.furthest([ 0, 0 ]);
  test.equivalent( got, expected );

  var expected = { index : 0, distance : sqrt( sqr( 9 ) + sqr( 6 ) ) };
  var got = m.furthest([ 10, 10 ]);
  test.equivalent( got, expected );

  var expected = { index : 2, distance : 3 };
  var got = m.furthest([ 3, 3 ]);
  test.equivalent( got, expected );

  var expected = { index : 0, distance : sqrt( 2 ) };
  var got = m.furthest([ 2, 5 ]);
  test.equivalent( got, expected );

  /* */

  test.case = 'simplest closest';

  var expected = { index : 0, distance : sqrt( sqr( 1 ) + sqr( 4 ) ) };
  var got = m.closest([ 0, 0 ]);
  test.equivalent( got, expected );

  var expected = { index : 2, distance : sqrt( sqr( 7 ) + sqr( 4 ) ) };
  var got = m.closest([ 10, 10 ]);
  test.equivalent( got, expected );

  var expected = { index : 0, distance : sqrt( 1 + sqr( 2 ) ) };
  var got = m.closest([ 3, 3 ]);
  test.equivalent( got, expected );

  var expected = { index : 1, distance : sqrt( 2 ) };
  var got = m.closest([ 3, 4 ]);
  test.equivalent( got, expected );

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

  /* */

  test.case = 'simplest determinant';

  var m = new _.Matrix
  ({
    buffer : new I32x([ 1, 2, 3, 4 ]),
    dims : [ 2, 2 ],
    inputTransposing : 1,
  });

  var d = m.determinant();
  test.identical( d, -2 );
  test.identical( m.dims, [ 2, 2 ] );
  test.identical( m.stridesEffective, [ 2, 1 ] );

  /* */

  test.case = 'matrix with zero determinant';

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
    inputTransposing : 1,
  });

  var d = m.determinant();

  test.identical( d, 0 );
  test.identical( m.dims, [ 3, 3 ] );
  test.identical( m.stridesEffective, [ 3, 1 ] );

  /* */

  /* */

  test.case = 'matrix with negative determinant';

  var m = new _.Matrix
  ({
    buffer : new I32x
    ([
      +2, -2, +4,
      +2, -3, +3,
      -2, +4, +2,
    ]),
    dims : [ 3, 3 ],
    inputTransposing : 1,
  });

  var d = m.determinant();
  test.identical( d, -8 );

  test.case = '3x3 matrix with -30 determinant' //

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
    inputTransposing : 1,
  });

  var d = m.determinant();

  test.identical( d, -30 );

  test.case = '2x2 matrix with -2 determinant, column first' //

  var m = new _.Matrix
  ({
    buffer : _.longFromRange([ 1, 5 ]),
    dims : [ 2, 2 ],
    inputTransposing : 0,
  });

  var d = m.determinant();
  test.identical( d, -2 );

    test.case = '2x2 matrix with -2 determinant, row first' //

  var m = new _.Matrix
  ({
    buffer : _.longFromRange([ 1, 5 ]),
    dims : [ 2, 2 ],
    inputTransposing : 0,
  });

  var d = m.determinant();
  test.identical( d, -2 );

  test.case = '3x3 matrix' //

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
    inputTransposing : 1,
  });

  var d = m.determinant();
  test.identical( d, -48468 );

  var m = new _.Matrix
  ({
    buffer,
    dims : [ 3, 3 ],
    inputTransposing : 0,
  });

  var d = m.determinant();
  test.identical( d, -48468 );

}

// --
// solver
// --

function triangulate( test )
{

  /* */

  test.case = 'triangulateGausian simple1';

  var m = _.Matrix.Make([ 3, 4 ]).copy
  ([
    +1, +1, +2, -1,
    +3, +1, +7, -7,
    +1, +7, +1, +7,
  ]);

  var expected = _.Matrix.Make([ 3, 4 ]).copy
  ([
    +1, +1, +2, -1,
    +0, -2, +1, -4,
    +0, +0, +2, -4,
  ]);

  test.equivalent( 1, 1 );

  m.triangulateGausian();
  test.equivalent( m, expected );

  /* */

  test.case = 'triangulateGausianNormal simple1';

  var m = _.Matrix.Make([ 3, 4 ]).copy
  ([
    +1, +1, +2, -1,
    +3, +1, +7, -7,
    +1, +7, +1, +7,
  ]);

  var expected = _.Matrix.Make([ 3, 4 ]).copy
  ([
    +1, +1, +2, -1,
    +0, +1, -0.5, +2,
    +0, +0, +1, -2,
  ]);

  m.triangulateGausianNormal();
  test.equivalent( m, expected );

  /* */

  test.case = 'triangulateGausianNormal simple2';

  var m = _.Matrix.Make([ 3, 4 ]).copy
  ([
    +1, -2, +2, 1,
    +5, -15, +8, 1,
    -2, -11, -11, 1,
  ]);

  var expected = _.Matrix.Make([ 3, 4 ]).copy
  ([
    +1, -2, +2, +1.0,
    +0, +1, 0.4, +0.8,
    +0, +0, 1, -15,
  ]);

  m.triangulateGausianNormal();
  test.equivalent( m, expected );

  /* */

  test.case = 'triangulateGausian simple2';

  var m = _.Matrix.Make([ 3, 4 ]).copy
  ([
    +1, -2, +2, 1,
    +5, -15, +8, 1,
    -2, -11, -11, 1,
  ]);

  var expected = _.Matrix.Make([ 3, 4 ]).copy
  ([
    +1, -2, +2, +1,
    +0, -5, -2, -4,
    +0, +0, -1, +15,
  ]);

  m.triangulateGausian();
  test.equivalent( m, expected );

  /* */

  test.case = 'triangulateGausian with y argument';

  var mexpected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +0, -5, -2,
    +0, +0, -1,
  ]);

  var yexpected = _.Matrix.MakeCol([ +1, -4, +15 ]);

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +5, -15, +8,
    -2, -11, -11,
  ]);

  var y = _.Matrix.MakeCol([ 1, 1, 1 ]);

  m.triangulateGausian( y );
  test.equivalent( m, mexpected );
  test.equivalent( y, yexpected );

  /* */

  test.case = 'triangulateGausianNormal with y argument';

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

  m.triangulateGausianNormal( y );
  test.equivalent( m, mexpected );
  test.equivalent( y, yexpected );

  /* */

  test.case = 'triangulateGausian with y argument';

  var mexpected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +0, -5, -2,
    +0, +0, -1,
  ]);

  var yexpected = _.Matrix.MakeCol([ +1, -4, +15 ]);

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +5, -15, +8,
    -2, -11, -11,
  ]);

  var y = _.Matrix.MakeCol([ 1, 1, 1 ]);

  m.triangulateGausian( y );
  test.equivalent( m, mexpected );
  test.equivalent( y, yexpected );

  /* */

  test.case = 'triangulateGausian ( nrow < ncol ) with y argument';

  var mexpected = _.Matrix.Make([ 4, 3 ]).copy
  ([
    +1, -2, +4,
    +0, +2, -4,
    +0, +0, +8,
    +0, +0, +0,
  ]);

  var yexpected = _.Matrix.MakeCol([ -1, +3, -2, +0 ]);

  var m = _.Matrix.Make([ 4, 3 ]).copy
  ([
    +1, -2, +4,
    +1, +0, +0,
    +1, +2, +4,
    +1, +4, +16,
  ]);

  var y = _.Matrix.MakeCol([ -1, +2, +3, +2 ]);

  m.triangulateGausian( y );
  test.equivalent( m, mexpected );
  test.equivalent( y, yexpected );

  /* */

  test.case = 'triangulateGausianNormal ( nrow < ncol ) with y argument';

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

  m.triangulateGausianNormal( y );
  test.equivalent( m, mexpected );
  test.equivalent( y, yexpected );

  /* */

  test.case = 'triangulateLu';

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +2, +4, -2,
    +4, -2, +6,
    +6, -4, +2,
  ]);

  var expected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +2, +4, -2,
    +2, -10, +10,
    +3, +1.6, -8,
  ]);

  var original = m.clone();
  m.triangulateLu();
  test.equivalent( m, expected );

  /* */

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
  test.equivalent( got, original );
  test.equivalent( l, ll );
  test.equivalent( u, uu );

  /* */

  test.case = 'triangulateLuNormal';

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +2, +4, -2,
    +4, -2, +6,
    +6, -4, +2,
  ]);

  var expected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +2, +2, -1,
    +4, -10, -1,
    +6, -16, -8,
  ]);

  var original = m.clone();
  m.triangulateLuNormal();
  test.equivalent( m, expected );

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

  test.case = 'triangulateLu';

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +5, -15, +8,
    -2, -11, -11,
  ]);

  var expected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +5, -5, -2,
    -2, +3, -1,
  ]);

  var original = m.clone();
  m.triangulateLu();
  test.equivalent( m, expected );

  /* */

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

  test.case = 'triangulateLuNormal';

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +5, -15, +8,
    -2, -11, -11,
  ]);

  var expected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +5, -5, +0.4,
    -2, -15, -1,
  ]);

  m.triangulateLuNormal();
  test.equivalent( m, expected );

  /* */

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
  test.equivalent( mul, original );
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

  test.case = 'triangulateLuNormal ( nrow < ncol )';

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

  m.triangulateLuNormal();
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

  test.case = 'l and u should be';

  test.equivalent( l, ll );
  test.equivalent( u, uu );

  test.case = 'l*u should be same as original m';

  u = u.expand([ [ 0, 1 ], null ]);
  var mul = _.Matrix.Mul( null, [ l, u ] );
  test.equivalent( mul, original );

  /* */

  test.case = 'triangulateLuNormal ( nrow > ncol )';

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

  m.triangulateLuNormal();
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

}

triangulate.accuracy = [ _.accuracy * 1e+2, 1e-1 ];

//

function SolveTriangulated( test )
{

  /* */

  test.case = 'SolveTriangleLower';

  var m = _.Matrix.MakeSquare
  ([
    2, 0, 0,
    2, 3, 0,
    4, 5, 6,
  ]);

  var expected = _.Matrix.MakeCol([ 1, 0, 0 ]);
  var y = _.Matrix.MakeCol([ 2, 2, 4 ]);
  var x = _.Matrix.SolveTriangleLower( null, m, y );

  test.equivalent( x, expected );

  var m = _.Matrix.MakeSquare
  ([
    2, -99, -99,
    2, 3, -99,
    4, 5, 6,
  ]);
  var x = _.Matrix.SolveTriangleLower( null, m, y );
  test.equivalent( x, expected );

  /* */

  test.case = 'SolveTriangleUpper';

  var m = _.Matrix.MakeSquare
  ([
    6, 5, 4,
    0, 3, 2,
    0, 0, 2,
  ]);

  var expected = _.Matrix.MakeCol([ 0, 0, 1 ]);
  var y = _.Matrix.MakeCol([ 4, 2, 2 ]);
  var x = _.Matrix.SolveTriangleUpper( null, m, y );

  test.equivalent( x, expected );

  var m = _.Matrix.MakeSquare
  ([
    6, 5, 4,
    -99, 3, 2,
    -99, -99, 2,
  ]);
  var x = _.Matrix.SolveTriangleUpper( null, m, y );
  test.equivalent( x, expected );

  /* */

  test.case = 'SolveTriangleLowerNormal';

  var m = _.Matrix.MakeSquare
  ([
    1, 0, 0,
    2, 1, 0,
    4, 5, 1,
  ]);

  var expected = _.Matrix.MakeCol([ 2, -2, 6 ]);
  var y = _.Matrix.MakeCol([ 2, 2, 4 ]);
  var x = _.Matrix.SolveTriangleLowerNormal( null, m, y );

  test.equivalent( x, expected );

  var m = _.Matrix.MakeSquare
  ([
    -99, -99, -99,
    2, -99, -99,
    4, 5, -99,
  ]);
  var x = _.Matrix.SolveTriangleLowerNormal( null, m, y );
  test.equivalent( x, expected );

  /* */

  test.case = 'SolveTriangleUpperNormal';

  var m = _.Matrix.MakeSquare
  ([
    1, 5, 4,
    0, 1, 2,
    0, 0, 1,
  ]);

  var expected = _.Matrix.MakeCol([ 6, -2, 2 ]);
  var y = _.Matrix.MakeCol([ 4, 2, 2 ]);
  var x = _.Matrix.SolveTriangleUpperNormal( null, m, y );

  test.equivalent( x, expected );

  var m = _.Matrix.MakeSquare
  ([
    -99, 5, 4,
    -99, -99, 2,
    -99, -99, -99,
  ]);

  var x = _.Matrix.SolveTriangleUpperNormal( null, m, y );

  test.equivalent( x, expected );

  /* */

  test.case = 'SolveWithTriangles u';

  var m = _.Matrix.MakeSquare
  ([
    1, 5, 4,
    0, 1, 2,
    0, 0, 1,
  ]);

  var expected = _.Matrix.MakeCol([ 6, -2, 2 ]);
  var y = _.Matrix.MakeCol([ 4, 2, 2 ]);
  var x = _.Matrix.SolveWithTriangles( null, m, y );

  test.equivalent( x, expected );

  /* */

  test.case = 'SolveWithTriangles u';

  var m = _.Matrix.MakeSquare
  ([
    -2, +1, +2,
    +4, -1, -5,
    +2, -3, -1,
  ]);

  var expected = _.Matrix.MakeCol([ -1, 2, -2 ]);
  var y = _.Matrix.MakeCol([ 0, 4, -6 ]);
  var x = _.Matrix.SolveWithTriangles( null, m, y );

  test.equivalent( x, expected );

  /* */

  test.case = 'system triangulateLu';

  var expected = _.Matrix.MakeSquare
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
  test.identical( m, expected )

  /* */

  test.case = 'system Solve';

  var m = _.Matrix.MakeSquare
  ([
    +1, -1, +2,
    +2, +0, +2,
    -2, +0, -4,
  ]);

  var y = [ 7, 4, -10 ];
  var x = _.Matrix.Solve( null, m, y );

  logger.log( 'm', m );
  logger.log( 'x', x );

  test.identical( x, [ -1, -2, +3 ] );

}

//

function SolveSimple( test, rname )
{

  _SolveSimple( test, 'Solve' );
  _SolveSimple( test, 'SolveWithGausian' );
  _SolveSimple( test, 'SolveWithGausianPivoting' );
  _SolveSimple( test, 'SolveWithGaussJordan' );
  _SolveSimple( test, 'SolveWithGaussJordanPivoting' );
  _SolveSimple( test, 'SolveWithTriangles' );
  _SolveSimple( test, 'SolveWithTrianglesPivoting' );

  /* - */

  function _SolveSimple( test, rname )
  {

    /**/

    test.case = rname + ' . y array . Solve 2x2 system';

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
    var y = vec([ 7, 4, -10 ]);
    var oy = y.clone();
    var x = _.Matrix[ rname ]( null, m, y );

    logger.log( 'm', m );
    logger.log( 'x', x );

    test.is( x !== y );
    test.identical( x, vec([ -1, -2, +3 ]) );
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
    var y = vec([ 7, 4, -10 ]);
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
    var ox = vec([ 0, 0, 0 ]);
    var x = _.Matrix[ rname ]( ox, m, y );

    logger.log( 'm', m );
    logger.log( 'x', x );

    test.is( x !== y );
    test.is( x === ox );
    test.identical( x, vec([ -1, -2, +3 ]) );
    test.identical( y, oy );

    var y2 = _.Matrix.Mul( null, [ om, x ] );
    test.identical( y2, vec([ 7, 4, -10 ]) );

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

function _SolveComplicated( test, rname )
{

  test.case = rname + ' . y array . Solve 3x3 system1'; //

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

  logger.log( 'm', m );
  logger.log( 'x', x );

  test.is( x !== y );
  test.identical( x, [ -0.5, +2.5, -0.5 ] );
  test.identical( y, oy );

  var y2 = _.Matrix.Mul( null, [ om, x ] );
  test.identical( y2, y );

}

//

function SolveComplicated( test, rname )
{

  this._SolveComplicated( test, 'Solve' );
  this._SolveComplicated( test, 'SolveWithGausianPivoting' );
  this._SolveComplicated( test, 'SolveWithGaussJordanPivoting' );
  this._SolveComplicated( test, 'SolveWithTrianglesPivoting' );

}

//

function SolveWithPivoting( test )
{

  /* */

  test.case = 'triangulateGausianPivoting 3x4';

  var m = _.Matrix.Make([ 3, 4 ]).copy
  ([
    +1, +3, +1, +2,
    +2, +6, +4, +8,
    +0, +0, +2, +4,
  ]);

  var om = m.clone();
  var y = _.Matrix.MakeCol([ +1, +3, +1 ]);
  var pivots = m.triangulateGausianPivoting( y );

  logger.log( 'm', m );
  logger.log( 'x', x );
  logger.log( 'y', y );
  logger.log( 'pivots', _.toStr( pivots, { levels : 2 } ) );

  var em = _.Matrix.Make([ 3, 4 ]).copy
  ([
    +3, +2, +1, +1,
    +0, +4, +2, +0,
    +0, +0, +0, +0,
  ]);
  test.identical( m, em );

  var ey = _.Matrix.MakeCol([ 1, 1, 0 ]);
  test.identical( y, ey );

  var epivots = [ [ 0, 1, 2 ], [ 1, 3, 2, 0 ] ]
  test.identical( pivots, epivots );

  /* */

  m.pivotBackward( pivots );
  _.Matrix.VectorPivotBackward( y, pivots[ 0 ] );

  logger.log( 'm', m );
  logger.log( 'x', x );
  logger.log( 'y', y );
  logger.log( 'pivots', _.toStr( pivots, { levels : 2 } ) );

  var em = _.Matrix.Make([ 3, 4 ]).copy
  ([
    +1, +3, +1, +2,
    +0, +0, +2, +4,
    +0, +0, +0, +0,
  ]);
  test.identical( m, em );

  var ey = _.Matrix.MakeCol([ 1, 1, 0 ]);
  test.identical( y, ey );

  /* */

  test.case = 'triangulateGausianPivoting';

  var y = _.Matrix.MakeCol([ 1, 2, 3 ]);
  var yoriginal = y.clone();
  var yexpected = _.Matrix.MakeCol([ 1, 1, 2.5 ]);

  var pivotsExpected = [ [ 0, 1, 2 ], [ 0, 2, 1 ] ];

  var mexpected = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +4, +4, +2,
    +0, -2, +0,
    +0, +0, +1,
  ]);

  var munpivotedExpected = _.Matrix.Make([ 3, 3 ]).copy
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

  m.triangulateGausian();
  logger.log( 'ordinary triangulation', m );

  m = om.clone();
  var pivots = m.triangulateGausianPivoting( y );

  var munpivoted = m.clone().pivotBackward( pivots );
  var x = _.Matrix.SolveTriangleUpper( null, m, y );
  var y2 = _.Matrix.Mul( null, [ m, x ] );

  var x3 = _.Matrix.From( x.clone() ).pivotBackward([ pivots[ 1 ], null ]);
  var y3 = _.Matrix.Mul( null, [ om, x3 ] );

  test.equivalent( pivots, pivotsExpected );
  test.equivalent( munpivoted, munpivotedExpected );
  test.equivalent( m, mexpected );
  test.equivalent( y, yexpected );
  test.equivalent( y2, yexpected );
  test.equivalent( y3, yoriginal ); /* */

  logger.log( 'm', m );
  logger.log( 'x', x );
  logger.log( 'y', y );
  logger.log( 'pivots', _.toStr( pivots, { levels : 2 } ) );

  logger.log( 'om', om );
  logger.log( 'x3', x3 );
  logger.log( 'y3', y3 );

}

//

function SolveGeneral( test )
{

  /* */

  test.case = 'simple without pivoting';

  var re =
  {
    nsolutions : Infinity,
    base : _.Matrix.MakeCol([ +3, -3, +0 ]),
    nkernel : 1,
    kernel : _.Matrix.MakeSquare
    ([
      +0, +0, -1,
      +0, +0, +2,
      +0, +0, +1,
    ]),
  }

  var m = _.Matrix.MakeSquare
  ([
    +2, +2, -2,
    -2, -3, +4,
    +4, +3, -2,
  ]);

  var me = _.Matrix.MakeSquare
  ([
    +1, +0, +1,
    +0, +1, -2,
    +0, +0, +0,
  ]);

  var mo = m.clone();
  var y = _.Matrix.MakeCol([ 0, 3, 3 ]);
  var yo = y.clone();
  var r = _.Matrix.SolveGeneral({ m, y, pivoting : 0 });

  test.equivalent( r, re );
  test.equivalent( m, me );
  test.equivalent( y, yo );

  logger.log( 'r.base', r.base );
  logger.log( 'r.kernel', r.kernel );
  logger.log( 'm', m );

  check( mo, yo, r );

  /* */

  test.case = 'simple with pivoting';

  var re =
  {
    nsolutions : Infinity,
    base : _.Matrix.MakeCol([ 1.5, 0, 1.5 ]),
    nkernel : 1,
    kernel : _.Matrix.MakeSquare
    ([
      -0.5, +0, +0,
      +1, +0, +0,
      +0.5, +0, +0,
    ]),
  }

  var m = _.Matrix.MakeSquare
  ([
    +2, +2, -2,
    -2, -3, +4,
    +4, +3, -2,
  ]);

  var me = _.Matrix.MakeSquare
  ([
    +0, +0, +0,
    +0, -0.5, +1,
    +1, +0.5, +0,
  ]);

  var mo = m.clone();
  var y = _.Matrix.MakeCol([ 0, 3, 3 ]);
  var yo = y.clone();
  var r = _.Matrix.SolveGeneral({ m, y, pivoting : 1 });

  test.equivalent( r, re );
  test.equivalent( m, me );
  test.equivalent( y, yo );

  logger.log( 'r.base', r.base );
  logger.log( 'r.kernel', r.kernel );
  logger.log( 'm', m );

  check( mo, yo, r );

  /* */

  test.case = 'simple2';

  var expected =
  {
    nsolutions : Infinity,
    base : _.Matrix.MakeCol([ +1, -1, +0 ]),
    nkernel : 1,
    kernel : _.Matrix.MakeSquare
    ([
      +0, +0, +2,
      +0, +0, +0,
      +0, +0, +1,
    ]),
  }

  var m = _.Matrix.MakeSquare
  ([
    +2, -2, -4,
    -2, +1, +4,
    +2, +0, -4,
  ]);

  var mo = m.clone();

  var y = _.Matrix.MakeCol([ +4, -3, +2 ]);
  var r = _.Matrix.SolveGeneral({ m, y });

  logger.log( 'r.base', r.base );
  logger.log( 'r.kernel', r.kernel );
  logger.log( 'm', m );

  check( mo, y, r );

  /* */

  test.case = 'simple3';

  var expected =
  {
    nsolutions : Infinity,
    base : _.Matrix.MakeCol([ +1, +0, -1 ]),
    nkernel : 1,
    kernel : _.Matrix.MakeSquare
    ([
      +0, +2, +0,
      +0, +1, +0,
      +0, +0, +0,
    ]),
  }

  var m = _.Matrix.MakeSquare
  ([
    +2, -4, -2,
    -2, +4, +1,
    +2, -4, +0,
  ]);

  var mo = m.clone();

  var y = _.Matrix.MakeCol([ +4, -3, +2 ]);
  var r = _.Matrix.SolveGeneral({ m , y });

  logger.log( 'r.base', r.base );
  logger.log( 'r.kernel', r.kernel );
  logger.log( 'm', m );

  check( mo, y, r );

  /* */

  test.case = 'missing rows';

  var expected =
  {
    nsolutions : Infinity,
    base : _.Matrix.MakeCol([ -2, +0, -0.25 ]),
    nkernel : 1,
    kernel : _.Matrix.MakeSquare
    ([
      +0, +0, +0,
      +0, +0, +1,
      +0, +0, +0.5,
    ]),
  }

  var m = _.Matrix.Make([ 2, 3 ]).copy
  ([
    -1, -2, +4,
    +1, +0, +0,
  ]);

  var mo = m.clone();

  var y = _.Matrix.MakeCol([ +1, -2 ]);
  var r = _.Matrix.SolveGeneral({ m , y });
  test.equivalent( r, expected );

  logger.log( 'r.base', r.base );
  logger.log( 'r.kernel', r.kernel );
  logger.log( 'm', m );

  check( mo, y, r );

  /* */

  test.case = 'complicated system';

  var expected =
  {
    nsolutions : 1,
    base : _.Matrix.MakeCol([ -0.5, +2.5, -0.5 ]),
    nkernel : 0,
    kernel : _.Matrix.MakeSquare
    ([
      0, 0, 0,
      0, 0, 0,
      0, 0, 0,
    ]),
  }

  var m = _.Matrix.Make([ 3, 3 ]).copy
  ([
    +4, +2, +4,
    +4, +2, +2,
    +2, +2, +2,
  ]);

  var mo = m.clone();

  var y = _.Matrix.MakeCol([ 1, 2, 3 ]);
  var r = _.Matrix.SolveGeneral({ m, y });
  test.equivalent( r, expected );

  logger.log( 'r.base', r.base );
  logger.log( 'r.kernel', r.kernel );
  logger.log( 'm', m );

  check( mo, y, r );

  /* */

  test.case = 'missing rows';

  var expected =
  {
    nsolutions : Infinity,
    base : _.Matrix.MakeCol([ 0, +1/6, 0, 0.25 ]),
    nkernel : 2,
    kernel : _.Matrix.MakeSquare
    ([
      +0, +0, +1, +0,
      +0, +0, -1/3, +0,
      +0, +0, +0, +1,
      +0, +0, +0, -0.5,
    ]),
  }

  var m = _.Matrix.Make([ 3, 4 ]).copy
  ([
    +1, +3, +1, +2,
    +2, +6, +4, +8,
    +0, +0, +2, +4,
  ]);

  var mo = m.clone();

  var y = _.Matrix.MakeCol([ +1, +3, +1 ]);
  var r = _.Matrix.SolveGeneral({ m, y });
  test.equivalent( r, expected );

  logger.log( 'r.base', r.base );
  logger.log( 'r.kernel', r.kernel );
  logger.log( 'm', m );

  check( mo, y, r );

  /* */

  function checkNull( m, r, d )
  {

    var param = _.dup( 0, m.dims[ 1 ] );
    param[ d ] = 1;
    var x2 = _.Matrix.Mul( null, [ r.kernel, _.Matrix.MakeCol( param ) ] );
    var y2 = _.Matrix.Mul( null, [ m, x2 ] );

    if( y2.dims[ 0 ] < m.dims[ 1 ] )
    y2 = y2.expand([ [ null, m.dims[ 1 ]-y2.dims[ 0 ] ], null ]);
    test.equivalent( y2, _.Matrix.MakeZero([ m.dims[ 1 ], 1 ]) );

    logger.log( 'm', m );
    logger.log( 'x2', x2 );
    logger.log( 'y2', y2 );

  }

  /* */

  function checkDimension( m, y, r, d, factor )
  {

    var param = _.dup( 0, m.dims[ 1 ] );
    param[ d ] = factor;
    var x2 = _.Matrix.Mul( null, [ r.kernel, _.Matrix.MakeCol( param ) ] );
    x2 = _.Matrix.addAtomWise( x2, r.base, x2 );
    var y2 = _.Matrix.Mul( null, [ m, x2 ] );

    if( y2.dims[ 0 ] < m.dims[ 1 ] )
    y2 = y2.expand([ [ null, m.dims[ 1 ]-y2.dims[ 0 ] ], null ]);
    test.equivalent( y2, y );

    logger.log( 'param', param );
    logger.log( 'kernel', r.kernel );

    logger.log( 'm', m );
    logger.log( 'x2', x2 );
    logger.log( 'y2', y2 );

  }

  /* */

  function check( m, y, r )
  {
    var description = test.case;

    for( var d = 0 ; d < m.dims[ 1 ] ; d++ )
    {
      test.case = description + ' . ' + 'check direction ' + d;
      checkDimension( m, y, r, d, 0 );
      checkDimension( m, y, r, d, +10 );
      checkDimension( m, y, r, d, -10 );
      checkNull( m, r, d );
    }

    test.case = description;
  }

  /* */

}

SolveGeneral.accuracy = [ _.accuracy * 1e+2, 1e-1 ];

//

function invert( test )
{

  /* */

  test.case = 'invertingClone';

  var expected = _.Matrix.Make([ 3, 3 ]).copy
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

  var determinant = m.determinant();
  var inverted = m.invertingClone();

  test.equivalent( inverted, expected );
  test.equivalent( m.determinant(), determinant );

  /* */

  test.case = 'invertingClone';

  var expected = _.Matrix.Make([ 3, 3 ]).copy
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

  var determinant = m.determinant();
  var inverted = m.invertingClone();

  test.equivalent( inverted, expected );
  test.equivalent( m.determinant(), determinant );

  /* */

  test.case = 'invertingClone';

  var expected = _.Matrix.Make([ 3, 3 ]).copy
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
  var inverted = m.invertingClone();

  test.equivalent( inverted, expected );
  test.equivalent( m.determinant(), determinant );

  /* */

  test.case = 'invert';

  var expected = _.Matrix.Make([ 3, 3 ]).copy
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

  test.equivalent( m, expected );
  test.equivalent( m.determinant(), 1/determinant );

}

invert.accuracy = [ _.accuracy * 1e+2, 1e-1 ];

//

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

// --
// equaler
// --

function compareMatrices( test )
{

  /* */

  test.case = 'trivial';

  var m1 = _.Matrix.MakeIdentity([ 3, 3 ]);
  var m2 = _.Matrix.MakeIdentity([ 3, 3 ]);

  test.identical( m1.identicalWith( m2 ), true );
  test.identical( m2.identicalWith( m1 ), true );
  test.identical( m1.equivalentWith( m2 ), true );
  test.identical( m2.equivalentWith( m1 ), true );
  test.identical( _.identical( m1, m2 ), true );
  test.identical( _.identical( m2, m1 ), true );
  test.identical( _.equivalent( m1, m2 ), true );
  test.identical( _.equivalent( m2, m1 ), true );
  test.identical( m1, m2 );
  test.identical( m2, m1 );
  test.equivalent( m1, m2 );
  test.equivalent( m2, m1 );

  /* */

  test.case = 'single 2d';

  var m1 = _.Matrix.MakeZero([ 1, 1 ]);
  var m2 = _.Matrix.MakeZero([ 1, 1 ]);

  test.identical( m1.identicalWith( m2 ), true );
  test.identical( m2.identicalWith( m1 ), true );
  test.identical( m1.equivalentWith( m2 ), true );
  test.identical( m2.equivalentWith( m1 ), true );
  test.identical( _.identical( m1, m2 ), true );
  test.identical( _.identical( m2, m1 ), true );
  test.identical( _.equivalent( m1, m2 ), true );
  test.identical( _.equivalent( m2, m1 ), true );
  test.identical( m1, m2 );
  test.identical( m2, m1 );
  test.equivalent( m1, m2 );
  test.equivalent( m2, m1 );

  /* */

  test.case = 'single 3d';

  var m1 = _.Matrix.MakeZero([ 1, 1, 1 ]);
  var m2 = _.Matrix.MakeZero([ 1, 1, 1 ]);

  test.identical( m1.identicalWith( m2 ), true );
  test.identical( m2.identicalWith( m1 ), true );
  test.identical( m1.equivalentWith( m2 ), true );
  test.identical( m2.equivalentWith( m1 ), true );
  test.identical( _.identical( m1, m2 ), true );
  test.identical( _.identical( m2, m1 ), true );
  test.identical( _.equivalent( m1, m2 ), true );
  test.identical( _.equivalent( m2, m1 ), true );
  test.identical( m1, m2 );
  test.identical( m2, m1 );
  test.equivalent( m1, m2 );
  test.equivalent( m2, m1 );

  /* */

  test.case = 'single 4d';

  var m1 = _.Matrix.MakeZero([ 1, 1, 1, 1 ]);
  var m2 = _.Matrix.MakeZero([ 1, 1, 1, 1 ]);

  test.identical( m1.identicalWith( m2 ), true );
  test.identical( m2.identicalWith( m1 ), true );
  test.identical( m1.equivalentWith( m2 ), true );
  test.identical( m2.equivalentWith( m1 ), true );
  test.identical( _.identical( m1, m2 ), true );
  test.identical( _.identical( m2, m1 ), true );
  test.identical( _.equivalent( m1, m2 ), true );
  test.identical( _.equivalent( m2, m1 ), true );
  test.identical( m1, m2 );
  test.identical( m2, m1 );
  test.equivalent( m1, m2 );
  test.equivalent( m2, m1 );

  /* */

  test.case = 'empty 0x1 - 0x1';

  var m1 = _.Matrix.MakeZero([ 0, 1 ]);
  var m2 = _.Matrix.MakeZero([ 0, 1 ]);

  test.identical( m1.identicalWith( m2 ), true );
  test.identical( m2.identicalWith( m1 ), true );
  test.identical( m1.equivalentWith( m2 ), true );
  test.identical( m2.equivalentWith( m1 ), true );
  test.identical( _.identical( m1, m2 ), true );
  test.identical( _.identical( m2, m1 ), true );
  test.identical( _.equivalent( m1, m2 ), true );
  test.identical( _.equivalent( m2, m1 ), true );
  test.identical( m1, m2 );
  test.identical( m2, m1 );
  test.equivalent( m1, m2 );
  test.equivalent( m2, m1 );

/* */

test.case = 'empty 1x0 - 1x0';

var m1 = _.Matrix.MakeZero([ 1, 0 ]);
var m2 = _.Matrix.MakeZero([ 1, 0 ]);

test.identical( m1.identicalWith( m2 ), true );
test.identical( m2.identicalWith( m1 ), true );
test.identical( m1.equivalentWith( m2 ), true );
test.identical( m2.equivalentWith( m1 ), true );
test.identical( _.identical( m1, m2 ), true );
test.identical( _.identical( m2, m1 ), true );
test.identical( _.equivalent( m1, m2 ), true );
test.identical( _.equivalent( m2, m1 ), true );
test.identical( m1, m2 );
test.identical( m2, m1 );
test.equivalent( m1, m2 );
test.equivalent( m2, m1 );

  /* */

  test.case = 'empty 0x1 - 1x0';

  var m1 = _.Matrix.MakeZero([ 0, 1 ]);
  var m2 = _.Matrix.MakeZero([ 1, 0 ]);

  test.identical( m1.identicalWith( m2 ), false );
  test.identical( m2.identicalWith( m1 ), false );
  test.identical( m1.equivalentWith( m2 ), true );
  test.identical( m2.equivalentWith( m1 ), true );
  test.identical( _.identical( m1, m2 ), false );
  test.identical( _.identical( m2, m1 ), false );
  test.identical( _.equivalent( m1, m2 ), true );
  test.identical( _.equivalent( m2, m1 ), true );
  test.ni( m1, m2 );
  test.ni( m2, m1 );
  test.equivalent( m1, m2 );
  test.equivalent( m2, m1 );

  test.case = 'empty 0x1 - 1x1x0';

  var m1 = _.Matrix.MakeZero([ 0, 1 ]);
  var m2 = _.Matrix.MakeZero([ 1, 1, 0 ]);

  test.identical( m1.identicalWith( m2 ), false );
  test.identical( m2.identicalWith( m1 ), false );
  test.identical( m1.equivalentWith( m2 ), true );
  test.identical( m2.equivalentWith( m1 ), true );
  test.identical( _.identical( m1, m2 ), false );
  test.identical( _.identical( m2, m1 ), false );
  test.identical( _.equivalent( m1, m2 ), true );
  test.identical( _.equivalent( m2, m1 ), true );
  test.ni( m1, m2 );
  test.ni( m2, m1 );
  test.equivalent( m1, m2 );
  test.equivalent( m2, m1 );

  test.case = 'empty 0x1 - 1x0x1';

  var m1 = _.Matrix.MakeZero([ 0, 1 ]);
  var m2 = _.Matrix.MakeZero([ 1, 0, 1 ]);

  test.identical( m1.identicalWith( m2 ), false );
  test.identical( m2.identicalWith( m1 ), false );
  test.identical( m1.equivalentWith( m2 ), true );
  test.identical( m2.equivalentWith( m1 ), true );
  test.identical( _.identical( m1, m2 ), false );
  test.identical( _.identical( m2, m1 ), false );
  test.identical( _.equivalent( m1, m2 ), true );
  test.identical( _.equivalent( m2, m1 ), true );
  test.ni( m1, m2 );
  test.ni( m2, m1 );
  test.equivalent( m1, m2 );
  test.equivalent( m2, m1 );

  test.case = 'empty 1x0 - 1x0x1';

  var m1 = _.Matrix.MakeZero([ 1, 0 ]);
  var m2 = _.Matrix.MakeZero([ 1, 0, 1 ]);

  test.identical( m1.identicalWith( m2 ), false );
  test.identical( m2.identicalWith( m1 ), false );
  test.identical( m1.equivalentWith( m2 ), true );
  test.identical( m2.equivalentWith( m1 ), true );
  test.identical( _.identical( m1, m2 ), false );
  test.identical( _.identical( m2, m1 ), false );
  test.identical( _.equivalent( m1, m2 ), true );
  test.identical( _.equivalent( m2, m1 ), true );
  test.ni( m1, m2 );
  test.ni( m2, m1 );
  test.equivalent( m1, m2 );
  test.equivalent( m2, m1 );

  test.case = 'empty 1x0 - 1x1x1x0';

  var m1 = _.Matrix.MakeZero([ 1, 0 ]);
  var m2 = _.Matrix.MakeZero([ 1, 1, 1, 0 ]);

  test.identical( m1.identicalWith( m2 ), false );
  test.identical( m2.identicalWith( m1 ), false );
  test.identical( m1.equivalentWith( m2 ), true );
  test.identical( m2.equivalentWith( m1 ), true );
  test.identical( _.identical( m1, m2 ), false );
  test.identical( _.identical( m2, m1 ), false );
  test.identical( _.equivalent( m1, m2 ), true );
  test.identical( _.equivalent( m2, m1 ), true );
  test.ni( m1, m2 );
  test.ni( m2, m1 );
  test.equivalent( m1, m2 );
  test.equivalent( m2, m1 );

  /* */

  test.case = 'row';

  var m1 = _.Matrix.MakeZero([ 1, 3 ]);
  var m2 = _.Matrix.MakeZero([ 1, 3 ]);

  test.identical( m1.identicalWith( m2 ), true );
  test.identical( m2.identicalWith( m1 ), true );
  test.identical( m1.equivalentWith( m2 ), true );
  test.identical( m2.equivalentWith( m1 ), true );
  test.identical( _.identical( m1, m2 ), true );
  test.identical( _.identical( m2, m1 ), true );
  test.identical( _.equivalent( m1, m2 ), true );
  test.identical( _.equivalent( m2, m1 ), true );
  test.identical( m1, m2 );
  test.identical( m2, m1 );
  test.equivalent( m1, m2 );
  test.equivalent( m2, m1 );

  /* */

  test.case = 'col';

  var m1 = _.Matrix.MakeZero([ 3, 1 ]);
  var m2 = _.Matrix.MakeZero([ 3, 1 ]);

  test.identical( m1.identicalWith( m2 ), true );
  test.identical( m2.identicalWith( m1 ), true );
  test.identical( m1.equivalentWith( m2 ), true );
  test.identical( m2.equivalentWith( m1 ), true );
  test.identical( _.identical( m1, m2 ), true );
  test.identical( _.identical( m2, m1 ), true );
  test.identical( _.equivalent( m1, m2 ), true );
  test.identical( _.equivalent( m2, m1 ), true );
  test.identical( m1, m2 );
  test.identical( m2, m1 );
  test.equivalent( m1, m2 );
  test.equivalent( m2, m1 );

  /* */

  test.case = 'different types';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 2, 3, 4 ]),
    dims : [ 2, 2 ],
    inputTransposing : 0,
  });

  var m2 = new _.Matrix
  ({
    buffer : new I32x([ 1, 2, 3, 4 ]),
    dims : [ 2, 2 ],
    inputTransposing : 0,
  });

  test.identical( _.identical( m1, m2 ), false );
  test.identical( _.identical( m2, m1 ), false );
  test.identical( _.equivalent( m1, m2 ), true );
  test.identical( _.equivalent( m2, m1 ), true );
  test.ni( m1, m2 );
  test.ni( m2, m1 );
  test.equivalent( m1, m2 );
  test.equivalent( m2, m1 );

  /* */

  test.case = 'with strides';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 3, 5 ]),
    dims : [ 3, 1 ],
    inputTransposing : 0,
  });

  var m2 = new _.Matrix
  ({
    buffer : new F32x([ 0, 1, 2, 3, 4, 5, 6, 7 ]),
    offset : 1,
    inputTransposing : 0,
    strides : [ 2, 6 ],
    dims : [ 3, 1 ],
  });

  test.identical( m1.identicalWith( m2 ), true );
  test.identical( m2.identicalWith( m1 ), true );
  test.identical( m1.equivalentWith( m2 ), true );
  test.identical( m2.equivalentWith( m1 ), true );
  test.identical( _.identical( m1, m2 ), true );
  test.identical( _.identical( m2, m1 ), true );
  test.identical( _.equivalent( m1, m2 ), true );
  test.identical( _.equivalent( m2, m1 ), true );
  test.identical( m1, m2 );
  test.identical( m2, m1 );
  test.equivalent( m1, m2 );
  test.equivalent( m2, m1 );

  /* */

  test.case = 'with infinity dim';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 3, 5 ]),
    dims : [ 3, Infinity ],
    inputTransposing : 0,
  });

  var m2 = new _.Matrix
  ({
    buffer : new F32x([ 1, 3, 5 ]),
    dims : [ 3, Infinity ],
    inputTransposing : 0,
  });

  test.identical( m1.identicalWith( m2 ), true );
  test.identical( m2.identicalWith( m1 ), true );
  test.identical( m1.equivalentWith( m2 ), true );
  test.identical( m2.equivalentWith( m1 ), true );
  test.identical( _.identical( m1, m2 ), true );
  test.identical( _.identical( m2, m1 ), true );
  test.identical( _.equivalent( m1, m2 ), true );
  test.identical( _.equivalent( m2, m1 ), true );
  test.identical( m1, m2 );
  test.identical( m2, m1 );
  test.equivalent( m1, m2 );
  test.equivalent( m2, m1 );

  /* */

  test.case = 'with different strides';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 2, 3, 4, 5, 6 ]),
    dims : [ 2, 3 ],
    strides : [ 1, 2 ],
  });

  var m2 = new _.Matrix
  ({
    buffer : new F32x([ 1, 3, 5, 2, 4, 6 ]),
    dims : [ 2, 3 ],
    strides : [ 3, 1 ],
  });

  test.identical( m1.identicalWith( m2 ), true );
  test.identical( m2.identicalWith( m1 ), true );
  test.identical( m1.equivalentWith( m2 ), true );
  test.identical( m2.equivalentWith( m1 ), true );
  test.identical( _.identical( m1, m2 ), true );
  test.identical( _.identical( m2, m1 ), true );
  test.identical( _.equivalent( m1, m2 ), true );
  test.identical( _.equivalent( m2, m1 ), true );
  test.identical( m1, m2 );
  test.identical( m2, m1 );
  test.equivalent( m1, m2 );
  test.equivalent( m2, m1 );

  /* */

  test.case = 'matrix 2x2x1, matrix 2x2';

  var m1 = _.Matrix.Make([ 2, 2 ]).copy
  ([
    1, 2,
    3, 4,
  ]);
  var m2 = _.Matrix.Make([ 2, 2, 1 ]).copy
  ([
    1, 2,
    3, 4,
  ]);

  test.identical( m1.identicalWith( m2 ), false );
  test.identical( m1.equivalentWith( m2 ), true );
  test.identical( _.identical( m1, m2 ), false );
  test.identical( _.identical( m2, m1 ), false );
  test.identical( _.equivalent( m1, m2 ), true );
  test.identical( _.equivalent( m2, m1 ), true );
  test.ni( m1, m2 );
  test.ni( m2, m1 );
  test.equivalent( m1, m2 );
  test.equivalent( m2, m1 );

  /* */

  test.case = 'matrix 2x3xInfinity and 2x3xInfinity';
  var m1 = _.Matrix.Make([ 2, 3, Infinity ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);
  var m2 = _.Matrix.Make([ 2, 3, Infinity ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  test.identical( m1.identicalWith( m2 ), true );
  test.identical( m2.identicalWith( m1 ), true );
  test.identical( m1.equivalentWith( m2 ), true );
  test.identical( m2.equivalentWith( m1 ), true );
  test.identical( _.identical( m1, m2 ), true );
  test.identical( _.identical( m2, m1 ), true );
  test.identical( _.equivalent( m1, m2 ), true );
  test.identical( _.equivalent( m2, m1 ), true );
  test.identical( m1, m2 );
  test.identical( m2, m1 );
  test.equivalent( m1, m2 );
  test.equivalent( m2, m1 );

  /* */

  test.case = 'matrix Infinityx1 and 1x1';
  var m1 = _.Matrix.Make([ Infinity, 1 ]).copy
  ([
    1
  ]);
  var m2 = _.Matrix.Make([ 1, 1 ]).copy
  ([
    1
  ]);

  test.identical( m1.identicalWith( m2 ), false );
  test.identical( m2.identicalWith( m1 ), false );
  test.identical( m1.equivalentWith( m2 ), false );
  test.identical( m2.equivalentWith( m1 ), false );
  test.identical( _.identical( m1, m2 ), false );
  test.identical( _.identical( m2, m1 ), false );
  test.identical( _.equivalent( m1, m2 ), false );
  test.identical( _.equivalent( m2, m1 ), false );
  test.ni( m1, m2 );
  test.ni( m2, m1 );
  test.ne( m1, m2 );
  test.ne( m2, m1 );

  /* */

  test.case = 'matrix 1xInfinity and 1x1';
  var m1 = _.Matrix.Make([ 1, Infinity ]).copy
  ([
    1
  ]);
  var m2 = _.Matrix.Make([ 1, 1 ]).copy
  ([
    1
  ]);

  test.identical( m1.identicalWith( m2 ), false );
  test.identical( m2.identicalWith( m1 ), false );
  test.identical( m1.equivalentWith( m2 ), false );
  test.identical( m2.equivalentWith( m1 ), false );
  test.identical( _.identical( m1, m2 ), false );
  test.identical( _.identical( m2, m1 ), false );
  test.identical( _.equivalent( m1, m2 ), false );
  test.identical( _.equivalent( m2, m1 ), false );
  test.ni( m1, m2 );
  test.ni( m2, m1 );
  test.ne( m1, m2 );
  test.ne( m2, m1 );

  /* */

  test.case = 'matrix 1x1xInfinity and 1x1x1';
  var m1 = _.Matrix.Make([ 1, 1, Infinity ]).copy
  ([
    1
  ]);
  var m2 = _.Matrix.Make([ 1, 1, 1 ]).copy
  ([
    1
  ]);

  test.identical( m1.identicalWith( m2 ), false );
  test.identical( m2.identicalWith( m1 ), false );
  test.identical( m1.equivalentWith( m2 ), false );
  test.identical( m2.equivalentWith( m1 ), false );
  test.identical( _.identical( m1, m2 ), false );
  test.identical( _.identical( m2, m1 ), false );
  test.identical( _.equivalent( m1, m2 ), false );
  test.identical( _.equivalent( m2, m1 ), false );
  test.ni( m1, m2 );
  test.ni( m2, m1 );
  test.ne( m1, m2 );
  test.ne( m2, m1 );

  /* */

}

//

function compareMatrixAndVector( test )
{

  /* */

  test.case = 'Matrix and BufferTyped';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 3, 5 ]),
    dims : [ 3, 1 ],
    inputTransposing : 0,
  });
  var v1 = new F32x([ 1, 3, 5 ]);

  test.identical( _.identical( m1, v1 ), false );
  test.identical( _.identical( v1, m1 ), false );
  test.identical( _.equivalent( m1, v1 ), true );
  test.identical( _.equivalent( v1, m1 ), true );
  test.ni( m1, v1 );
  test.ni( v1, m1 );
  test.equivalent( m1, v1 );
  test.equivalent( v1, m1 );

  /* */

  test.case = 'Matrix and Array';

  var m1 = new _.Matrix
  ({
    buffer : ([ 1, 3, 5 ]),
    dims : [ 3, 1 ],
    inputTransposing : 0,
  });
  var v1 = ([ 1, 3, 5 ]);

  test.identical( _.identical( m1, v1 ), false );
  test.identical( _.identical( v1, m1 ), false );
  test.identical( _.equivalent( m1, v1 ), true );
  test.identical( _.equivalent( v1, m1 ), true );
  test.ni( m1, v1 );
  test.ni( v1, m1 );
  test.equivalent( m1, v1 );
  test.equivalent( v1, m1 );

  /* */

  test.case = 'Matrix and Array different type';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 3, 5 ]),
    dims : [ 3, 1 ],
    inputTransposing : 0,
  });
  var v1 = ([ 1, 3, 5 ]);

  test.identical( _.identical( m1, v1 ), false );
  test.identical( _.identical( v1, m1 ), false );
  test.identical( _.equivalent( m1, v1 ), true );
  test.identical( _.equivalent( v1, m1 ), true );
  test.ni( m1, v1 );
  test.ni( v1, m1 );
  test.equivalent( m1, v1 );
  test.equivalent( v1, m1 );

  /* */

  test.case = 'Matrix and vadapter BufferTyped';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 3, 5 ]),
    dims : [ 3, 1 ],
    inputTransposing : 0,
  });
  var v1 = _.vectorAdapter.from( new F32x([ 1, 3, 5 ]) );

  test.identical( _.identical( m1, v1 ), false );
  test.identical( _.identical( v1, m1 ), false );
  test.identical( _.equivalent( m1, v1 ), true );
  test.identical( _.equivalent( v1, m1 ), true );
  test.ni( m1, v1 );
  test.ni( v1, m1 );
  test.equivalent( m1, v1 );
  test.equivalent( v1, m1 );

  /* */

  test.case = 'Matrix and vadapter Array';

  var m1 = new _.Matrix
  ({
    buffer : [ 1, 3, 5 ],
    dims : [ 3, 1 ],
    inputTransposing : 0,
  });
  var v1 = _.vectorAdapter.from([ 1, 3, 5 ]);

  test.identical( _.identical( m1, v1 ), false );
  test.identical( _.identical( v1, m1 ), false );
  test.identical( _.equivalent( m1, v1 ), true );
  test.identical( _.equivalent( v1, m1 ), true );
  test.ni( m1, v1 );
  test.ni( v1, m1 );
  test.equivalent( m1, v1 );
  test.equivalent( v1, m1 );

  /* */

  test.case = 'Matrix and vadapter Array different type';

  var m1 = new _.Matrix
  ({
    buffer : new F32x([ 1, 3, 5 ]),
    dims : [ 3, 1 ],
    inputTransposing : 0,
  });
  var v1 = _.vectorAdapter.from([ 1, 3, 5 ]);

  test.identical( _.identical( m1, v1 ), false );
  test.identical( _.identical( v1, m1 ), false );
  test.identical( _.equivalent( m1, v1 ), true );
  test.identical( _.equivalent( v1, m1 ), true );
  test.ni( m1, v1 );
  test.ni( v1, m1 );
  test.equivalent( m1, v1 );
  test.equivalent( v1, m1 );

}

// --
// declare
// --

var Self =
{

  name : 'Tools.Math.Matrix',
  silencing : 1,
  enabled : 1,

  context :
  {

    makeWithOffset,

    _ConvertToClass,
    _copyTo,
    _bufferNormalize,
    _SolveComplicated,

  },

  tests :
  {

    // experiment

    experiment,

    // checker

    matrixIs,
    constructorIsMatrix,
    isDiagonal,
    isUpperTriangle,
    isSymmetric,

    // maker

    env,
    construct,
    make,
    makeHelper,
    MakeLine,
    MakeSimilar,
    from,
    TempBorrow,
    constructWithInfinity,
    constructWithScalarsPerElement,
    constructWithBreadth,
    constructWithoutBuffer,
    makeMultyMatrix,

    // exporter

    copyClone,
    ConvertToClass,
    copyTo,
    copy,
    copySubmatrix,
    clone,
    exportStructureToStructure,

    toStr,
    toLong, /* qqq : extend, please */

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
    partialAccessors,
    lineSwap,
    pivot,
    submatrix,
    subspace, /* qqq : extend, please */

    // operation

    colRowWiseOperations,
    mul,
    MulBasic, /* qqq : extend. add extreme cases. give me a link, please */
    MulSubmatirices,
    MulSeveral,
    AddBasic, /* qqq : extend. add extreme cases */

    addAtomWise,
    subAtomWise,

    furthestClosest,
    matrixHomogenousApply,
    determinant,

    // solver

    triangulate,
    SolveTriangulated,
    SolveSimple,
    SolveComplicated,
    SolveWithPivoting,
    SolveGeneral,
    invert,

    PolynomExactFor,
    PolynomClosestFor,

    // equaler

    compareMatrices,
    compareMatrixAndVector,

  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_global_.wTester.test( Self.name );

})();
