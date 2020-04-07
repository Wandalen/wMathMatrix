( function _Matrix_test_s_( ) {

'use strict';

/*
*/

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../dwtools/Tools.s' );

  _.include( 'wTesting' );

  require( '../l5_matrix/Include.s' );

}

//

var _ = _global_.wTools.withDefaultLong.Fx;
var matrix = _.Matrix;
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

  var m = new matrix
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

  var m = matrix.makeSquare
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

  debugger;
  test.case = 'instance of _.Matrix';
  var src = new _.Matrix
  ({
    buffer : new F32x( [ 0, 1, 2, 3, 4, 5, 6, 7 ] ),
    offset : 1,
    atomsPerElement : 3,
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
    buffer : new F32x( [ 0, 1, 2, 3, 4, 5, 6, 7 ] ),
    offset : 1,
    atomsPerElement : 3,
    inputTransposing : 0,
    strides : [ 2, 6 ],
    dims : [ 3, 1 ],
  });
  var got = _.constructorIsMatrix( src );
  test.identical( got, false );

  test.case = '_.Matrix';
  var got = _.constructorIsMatrix( matrix );
  test.identical( got, true );
}

function isDiagonal( test )
{

  /* */

  test.description = 'Matrix remains unchanged';

  var matrix =  _.Matrix.make( [ 4, 6 ] ).copy
  ([
    0,   0,   0,   0, - 1,   1,
    1, - 1,   0,   0,   0,   0,
    0,   0,   1, - 1,   0,   0,
    - 1,   0, - 1,   0,   0, - 1
  ]);
  var expected = false;

  var gotBool = matrix.isDiagonal( );
  test.identical( gotBool, expected );

  var oldMatrix =  _.Matrix.make( [ 4, 6 ] ).copy
  ([
    0,   0,   0,   0, - 1,   1,
    1, - 1,   0,   0,   0,   0,
    0,   0,   1, - 1,   0,   0,
    - 1,   0, - 1,   0,   0, - 1
  ]);
  test.identical( matrix, oldMatrix );

  /* */

  test.description = 'Matrix Not diagonal - square';

  var matrix =  _.Matrix.make( [ 4, 4 ] ).copy
  ([
    0,   0,   0,   0,
    1, - 1,   0,   0,
    0,   0,   1, - 1,
    - 1, 0,  - 1,  0
  ]);
  var expected = false;

  var gotBool = matrix.isDiagonal( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Not diagonal - Upper Triangular';

  var matrix =  _.Matrix.make( [ 4, 4 ] ).copy
  ([
    1,   0,   3,   4,
    0, - 1,   2,   0,
    0,   0,   1, - 1,
    0,   0,   0,  0.5
  ]);
  var expected = false;

  var gotBool = matrix.isDiagonal( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Not diagonal - Lower Triangular';

  var matrix =  _.Matrix.make( [ 4, 4 ] ).copy
  ([
    0.5,  0,   0,  0,
    1,  - 1,   0,  0,
    2,    0,   1,  0,
    - 1, 3.4, - 1, 2
  ]);
  var expected = false;

  var gotBool = matrix.isDiagonal( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix not square';

  var matrix =  _.Matrix.make( [ 4, 2 ] ).copy
  ([
    0.5,  0,
    1,  - 1,
    2,    0,
    - 1, 3.4
  ]);
  var expected = false;

  var gotBool = matrix.isDiagonal( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Diagonal';

  var matrix =  _.Matrix.make( [ 4, 4 ] ).copy
  ([
    0.5, 0, 0, 0,
    0, - 1, 0, 0,
    0,  0,  1, 0,
    0,  0, -0, 2
  ]);
  var expected = true;

  var gotBool = matrix.isDiagonal( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Diagonal 6x6';

  var matrix =  _.Matrix.make( [ 6, 6 ] ).copy
  ([
    0.5, 0, 0, 0, 0, 0,
    0, - 1, 0, 0, 0, 0,
    0,  0,  1, 0, 0, 0,
    0,  0, -0, 2, 0, 0,
    0,  0,  0, 0, 3, 0,
    0,  0,  0, 0, 0, - 1
  ]);
  var expected = true;

  var gotBool = matrix.isDiagonal( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Diagonal not square';

  var matrix =  _.Matrix.make( [ 4, 3 ] ).copy
  ([
    0.5, 0, 0,
    0, - 1, 0,
    0,  0,  1,
    0,  0, -0
  ]);
  var expected = true;

  var gotBool = matrix.isDiagonal( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Zero matrix ';

  var matrix =  _.Matrix.make( [ 4, 4 ] ).copy
  ([
    0,  0, 0, 0,
    0,  0, 0, 0,
    0,  0,  0, 0,
    0,  0, -0, 0
  ]);
  var expected = true;

  var gotBool = matrix.isDiagonal( );
  test.identical( gotBool, expected );

  /* */

  if( !Config.debug )
  return;

  var matrix =  'matrix';
  test.shouldThrowErrorSync( () => matrix.isDiagonal( matrix ));
  var matrix =  null;
  test.shouldThrowErrorSync( () => matrix.isDiagonal( matrix ));
  var matrix =  NaN;
  test.shouldThrowErrorSync( () => matrix.isDiagonal( matrix ));
  var matrix =  [ 0, 0, 0 ];
  test.shouldThrowErrorSync( () => matrix.isDiagonal( matrix ));
  var matrix =  _.vectorAdapter.from( [ 0, 0, 0 ] );
  test.shouldThrowErrorSync( () => matrix.isDiagonal( matrix ));

}

//

function isUpperTriangle( test )
{

  /* */

  test.description = 'Matrix remains unchanged';

  var matrix =  _.Matrix.make( [ 4, 6 ] ).copy
  ([
    0,   0,   0,   0, - 1,   1,
    1, - 1,   0,   0,   0,   0,
    0,   0,   1, - 1,   0,   0,
    - 1,   0, - 1,   0,   0, - 1
  ]);
  var expected = false;

  var gotBool = matrix.isUpperTriangle( );
  test.identical( gotBool, expected );

  var oldMatrix =  _.Matrix.make( [ 4, 6 ] ).copy
  ([
    0,   0,   0,   0, - 1,   1,
    1, - 1,   0,   0,   0,   0,
    0,   0,   1, - 1,   0,   0,
    - 1,   0, - 1,   0,   0, - 1
  ]);
  test.identical( matrix, oldMatrix );

  /* */

  test.description = 'Matrix Not triangular - square';

  var matrix =  _.Matrix.make( [ 4, 4 ] ).copy
  ([
    0,   0,   0,   0,
    1, - 1,   0,   0,
    0,   0,   1, - 1,
    - 1, 0,  - 1,  0
  ]);
  var expected = false;

  var gotBool = matrix.isUpperTriangle( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Not diagonal - Lower Triangular';

  var matrix =  _.Matrix.make( [ 4, 4 ] ).copy
  ([
    0.5,  0,   0,  0,
    1,  - 1,   0,  0,
    2,    0,   1,  0,
    - 1, 3.4, - 1, 2
  ]);
  var expected = false;

  var gotBool = matrix.isUpperTriangle( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix not square';

  var matrix =  _.Matrix.make( [ 4, 2 ] ).copy
  ([
    0.5,  0,
    1,  - 1,
    2,    0,
    - 1, 3.4
  ]);
  var expected = false;

  var gotBool = matrix.isUpperTriangle( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Upper Triangular';

  var matrix =  _.Matrix.make( [ 4, 4 ] ).copy
  ([
    1,   0,   3,   4,
    0, - 1,   2,   0,
    0,   0,   1, - 1,
    0,   0,   0,  0.5
  ]);
  var expected = true;

  var gotBool = matrix.isUpperTriangle( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Diagonal';

  var matrix =  _.Matrix.make( [ 4, 4 ] ).copy
  ([
    0.5, 0, 0, 0,
    0, - 1, 0, 0,
    0,  0,  1, 0,
    0,  0, -0, 2
  ]);
  var expected = true;

  var gotBool = matrix.isUpperTriangle( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Upper Triangular 6x6';

  var matrix =  _.Matrix.make( [ 6, 6 ] ).copy
  ([
    0.5, 5, 8, 0, 3, -0.5,
    0, - 1, 0, 8, 0, 2,
    0,  0,  1, 0, 3, 2.2,
    0,  0, -0, 2, 0, 0,
    0,  0,  0, 0, 3, 7,
    0,  0,  0, 0, 0, - 1
  ]);
  var expected = true;

  var gotBool = matrix.isUpperTriangle( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Upper Triangular not square';

  var matrix =  _.Matrix.make( [ 4, 3 ] ).copy
  ([
    0.5, 0, 0,
    0, - 1, 0,
    0,  0,  1,
    0,  0, -0
  ]);
  var expected = true;

  var gotBool = matrix.isUpperTriangle( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Zero matrix ';

  var matrix =  _.Matrix.make( [ 4, 4 ] ).copy
  ([
    0,  0, 0, 0,
    0,  0, 0, 0,
    0,  0,  0, 0,
    0,  0, -0, 0
  ]);
  var expected = true;

  var gotBool = matrix.isUpperTriangle( );
  test.identical( gotBool, expected );

  /* */

  if( !Config.debug )
  return;

  var matrix = 'matrix';
  test.shouldThrowErrorSync( () => matrix.isUpperTriangle( ));
  var matrix = NaN;
  test.shouldThrowErrorSync( () => matrix.isUpperTriangle( ));
  var matrix = null;
  test.shouldThrowErrorSync( () => matrix.isUpperTriangle( ));
  var matrix = [ 0, 0, 0 ];
  test.shouldThrowErrorSync( () => matrix.isUpperTriangle( ));
  var matrix = _.vectorAdapter.from( [ 0, 0, 0 ] );
  test.shouldThrowErrorSync( () => matrix.isUpperTriangle( ));

}

//

function isSymmetric( test )
{

  /* */

  test.description = 'Matrix remains unchanged';

  var matrix =  _.Matrix.make( [ 4, 4 ] ).copy
  ([
    0,   0,   0,   0,
    1, - 1,   0,   0,
    0,   0,   1, - 1,
    - 1,   0, - 1, 0
  ]);
  var expected = false;

  var gotBool = matrix.isSymmetric( );
  test.identical( gotBool, expected );

  var oldMatrix =  _.Matrix.make( [ 4, 4 ] ).copy
  ([
    0,   0,   0,   0,
    1, - 1,   0,   0,
    0,   0,   1, - 1,
    - 1,   0, - 1, 0
  ]);
  test.identical( matrix, oldMatrix );

  /* */

  test.description = 'Matrix Not Symmetric';

  var matrix =  _.Matrix.make( [ 4, 4 ] ).copy
  ([
    0,   0,   2,   0,
    1, - 1,   0,   0,
    0,   0,   1, - 1,
    - 1, 0,  - 1,  0
  ]);
  var expected = false;

  var gotBool = matrix.isSymmetric( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Lower Triangular';

  var matrix =  _.Matrix.make( [ 4, 4 ] ).copy
  ([
    0.5,  0,   0,  0,
    1,  - 1,   0,  0,
    2,    0,   1,  0,
    - 1, 3.4, - 1, 2
  ]);
  var expected = false;

  var gotBool = matrix.isSymmetric( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Upper Triangular';

  var matrix =  _.Matrix.make( [ 4, 4 ] ).copy
  ([
    1,   0,   3,   4,
    0, - 1,   2,   0,
    0,   0,   1, - 1,
    0,   0,   0,  0.5
  ]);
  var expected = false;

  var gotBool = matrix.isSymmetric( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Not Squared';

  var matrix =  _.Matrix.make( [ 3, 4 ] ).copy
  ([
    1,   0,   3,   4,
    0, - 1,   2,   0,
    3,   2,   1, - 1,
  ]);
  var expected = false;

  var gotBool = matrix.isSymmetric( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Diagonal';

  var matrix =  _.Matrix.make( [ 4, 4 ] ).copy
  ([
    0.5, 0, 0, 0,
    0, - 1, 0, 0,
    0,  0,  1, 0,
    0,  0, -0, 2
  ]);
  var expected = true;

  var gotBool = matrix.isSymmetric( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Matrix Symmetric';

  var matrix =  _.Matrix.make( [ 4, 4 ] ).copy
  ([
    0.5, 5, 8, 0.1,
    5, - 1, 2, 8,
    8,  2,  1, 0,
    0.1,  8, -0, 2
  ]);
  var expected = true;

  var gotBool = matrix.isSymmetric( );
  test.identical( gotBool, expected );

  /* */

  test.description = 'Zero matrix ';

  var matrix =  _.Matrix.make( [ 4, 4 ] ).copy
  ([
    0,  0, 0, 0,
    0,  0, 0, 0,
    0,  0,  0, 0,
    0,  0, -0, 0
  ]);
  var expected = true;

  var gotBool = matrix.isSymmetric( );
  test.identical( gotBool, expected );

  /* */

  if( !Config.debug )
  return;

  var matrix = 'matrix';
  test.shouldThrowErrorSync( () => matrix.isSymmetric( ));
  var matrix = NaN;
  test.shouldThrowErrorSync( () => matrix.isSymmetric( ));
  var matrix = null;
  test.shouldThrowErrorSync( () => matrix.isSymmetric( ));
  var matrix = [ 0, 0, 0 ];
  test.shouldThrowErrorSync( () => matrix.isSymmetric( ));
  var matrix = _.vectorAdapter.from( [ 0, 0, 0 ] );
  test.shouldThrowErrorSync( () => matrix.isSymmetric( ));

}

// --
//
// --

function env( test )
{

  test.is( _.routineIs( matrix ) );
  test.is( _.objectIs( vad ) );
  test.is( _.objectIs( avector ) );

}

//

function clone( test )
{

  test.case = 'make'; /* */

  var buffer = new F32x([ 1, 2, 3, 4, 5, 6 ]);
  var a = new _.Matrix
  ({
    buffer,
    dims : [ 3, 2 ],
    inputTransposing : 0,
  });

  test.case = 'clone'; /* */

  debugger;
  var b = a.clone();
  test.identical( a, b );
  debugger;
  test.is( a.buffer !== b.buffer );
  test.is( a.buffer === buffer );

  test.identical( a.size, 24 );
  test.identical( a.sizeOfElementStride, 12 );
  test.identical( a.sizeOfElement, 12 );
  test.identical( a.sizeOfCol, 12 );
  test.identical( a.sizeOfRow, 8 );
  test.identical( a.dims, [ 3, 2 ] );
  test.identical( a.length, 2 );

  test.identical( a._stridesEffective, [ 1, 3 ] );
  test.identical( a.strideOfElement, 3 );
  test.identical( a.strideOfCol, 3 );
  test.identical( a.strideInCol, 1 );
  test.identical( a.strideOfRow, 1 );
  test.identical( a.strideInRow, 3 );

  test.case = 'set buffer'; /* */

  a.buffer = new F32x([ 11, 12, 13 ]);

  test.identical( a.size, 12 );
  test.identical( a.sizeOfElementStride, 12 );
  test.identical( a.sizeOfElement, 12 );
  test.identical( a.sizeOfCol, 12 );
  test.identical( a.sizeOfRow, 4 );
  test.identical( a.dims, [ 3, 1 ] );
  test.identical( a.length, 1 );

  test.identical( a._stridesEffective, [ 1, 3 ] );
  test.identical( a.strideOfElement, 3 );
  test.identical( a.strideOfCol, 3 );
  test.identical( a.strideInCol, 1 );
  test.identical( a.strideOfRow, 1 );
  test.identical( a.strideInRow, 3 );

  logger.log( a );

  test.case = 'set dimension'; /* */

  a.dims = [ 1, 3 ];

  test.identical( a.size, 12 );
  test.identical( a.sizeOfElementStride, 4 );
  test.identical( a.sizeOfElement, 4 );
  test.identical( a.sizeOfCol, 4 );
  test.identical( a.sizeOfRow, 12 );
  test.identical( a.dims, [ 1, 3 ] );
  test.identical( a.length, 3 );

  test.identical( a._stridesEffective, [ 1, 1 ] );
  test.identical( a.strideOfElement, 1 );
  test.identical( a.strideOfCol, 1 );
  test.identical( a.strideInCol, 1 );
  test.identical( a.strideOfRow, 1 );
  test.identical( a.strideInRow, 1 );

  logger.log( a );

  test.case = 'copy buffer and dims'; /* */

  a.dims = [ 1, 3 ];
  a.copyResetting({ buffer : new F32x([ 3, 4, 5 ]), dims : [ 3, 1 ] });

  test.identical( a.size, 12 );
  test.identical( a.sizeOfElementStride, 12 );
  test.identical( a.sizeOfElement, 12 );
  test.identical( a.sizeOfCol, 12 );
  test.identical( a.sizeOfRow, 4 );
  test.identical( a.dims, [ 3, 1 ] );
  test.identical( a.length, 1 );

  test.identical( a._stridesEffective, [ 1, 3 ] );
  test.identical( a.strideOfElement, 3 );
  test.identical( a.strideOfCol, 3 );
  test.identical( a.strideInCol, 1 );
  test.identical( a.strideOfRow, 1 );
  test.identical( a.strideInRow, 3 );

  logger.log( a );

  test.case = 'copy dims and buffer'; /* */

  a.dims = [ 1, 3 ];
  a.copyResetting({ dims : [ 3, 1 ], buffer : new F32x([ 3, 4, 5 ]) });

  test.identical( a.size, 12 );
  test.identical( a.sizeOfElementStride, 12 );
  test.identical( a.sizeOfElement, 12 );
  test.identical( a.sizeOfCol, 12 );
  test.identical( a.sizeOfRow, 4 );
  test.identical( a.dims, [ 3, 1 ] );
  test.identical( a.length, 1 );

  test.identical( a._stridesEffective, [ 1, 3 ] );
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

  test.case = 'creating'; /* */

  var a = new _.Matrix
  ({
    buffer : new F32x([ 0, 1, 2, 3, 4, 5, 6, 7 ]),
    offset : 1,
    atomsPerElement : 3,
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

  test.identical( a._stridesEffective, [ 2, 6 ] );
  test.identical( a.strideOfElement, 6 );
  test.identical( a.strideOfCol, 6 );
  test.identical( a.strideInCol, 2 );
  test.identical( a.strideOfRow, 2 );
  test.identical( a.strideInRow, 6 );

  test.case = 'serializing clone'; /* */

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
        "sizeOfAtom" : 4,
        "offset" : 0,
        "size" : 12,
        "index" : 0
      }
    },
    "buffer" : ( new U8x([ 0x0, 0x0, 0x80, 0x3f, 0x0, 0x0, 0x40, 0x40, 0x0, 0x0, 0xa0, 0x40 ]) ).buffer
  }

  test.identical( cloned, expected );

  test.case = 'deserializing clone'; /* */

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
  test.identical( a._stridesEffective, [ 2, 6 ] );
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
  test.identical( b._stridesEffective, [ 1, 3 ] );
  test.identical( b.strideOfElement, 3 );
  test.identical( b.strideOfCol, 3 );
  test.identical( b.strideInCol, 1 );
  test.identical( b.strideOfRow, 1 );
  test.identical( b.strideInRow, 3 );

  test.case = 'creating'; /* */

  var a = new _.Matrix
  ({
    buffer : new F32x([ 0, 1, 2, 3, 4, 5, 6, 7 ]),
    offset : 1,
    atomsPerElement : 3,
    inputTransposing : 1,
    strides : [ 2, 6 ],
    // dims : [ 3, 1 ],
  });

  logger.log( a );

  test.identical( a.size, 12 );
  test.identical( a.sizeOfElementStride, 24 );
  test.identical( a.sizeOfElement, 12 );
  test.identical( a.sizeOfCol, 12 );
  test.identical( a.sizeOfRow, 4 );
  test.identical( a.dims, [ 3, 1 ] );
  test.identical( a.length, 1 );

  test.identical( a._stridesEffective, [ 2, 6 ] );
  test.identical( a.strideOfElement, 6 );
  test.identical( a.strideOfCol, 6 );
  test.identical( a.strideInCol, 2 );
  test.identical( a.strideOfRow, 2 );
  test.identical( a.strideInRow, 6 );

  test.case = 'serializing clone'; /* */

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
        "sizeOfAtom" : 4,
        "offset" : 0,
        "size" : 12,
        "index" : 0
      }
    },
    "buffer" : ( new U8x([ 0x0, 0x0, 0x80, 0x3f, 0x0, 0x0, 0x40, 0x40, 0x0, 0x0, 0xa0, 0x40 ]) ).buffer
  }

  test.identical( cloned, expected );

  test.case = 'deserializing clone'; /* */

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
  test.identical( a._stridesEffective, [ 2, 6 ] );
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
  test.identical( b._stridesEffective, [ 1, 1 ] );
  test.identical( b.strideOfElement, 1 );
  test.identical( b.strideOfCol, 1 );
  test.identical( b.strideInCol, 1 );
  test.identical( b.strideOfRow, 1 );
  test.identical( b.strideInRow, 1 );

}

//

function make( test )
{

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
  this._make( test, o );

  o.offset = undefined;
  this._make( test, o );

  o.offset = 13;
  this._make( test, o );

}

make.timeOut = 30000;

//

function _make( test, o )
{

  test.case = 'matrix with dimensions without stride, transposing'; /* */

  var m = new matrix
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

  test.identical( m._stridesEffective, [ 3, 1 ] );
  test.identical( m.strideOfElement, 1 );
  test.identical( m.strideOfCol, 1 );
  test.identical( m.strideInCol, 3 );
  test.identical( m.strideOfRow, 3 );
  test.identical( m.strideInRow, 1 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 2 );
  var c2 = m.lineVectorGet( 0, 2 );
  var e = m.eGet( 2 );
  var a1 = m.atomFlatGet( 5 );
  var a2 = m.atomGet([ 1, 1 ]);

  test.identical( r1, o.vec([ 4, 5, 6 ]) );
  test.identical( r1, r2 );
  test.identical( c1, o.vec([ 3, 6 ]) );
  test.identical( c1, c2 );
  test.identical( e, o.vec([ 3, 6 ]) );
  test.identical( a1, 6 );
  test.identical( a2, 5 );
  test.identical( m.reduceToSumAtomWise(), 21 );
  test.identical( m.reduceToProductAtomWise(), 720 );

  test.case = 'matrix with dimensions without stride, non transposing'; /* */

  var m = new matrix
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

  test.identical( m._stridesEffective, [ 1, 2 ] );
  test.identical( m.strideOfElement, 2 );
  test.identical( m.strideOfCol, 2 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 2 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 2 );
  var c2 = m.lineVectorGet( 0, 2 );
  var e = m.eGet( 2 );
  var a1 = m.atomFlatGet( 5 );
  var a2 = m.atomGet([ 1, 1 ]);

  test.identical( r1, o.vec([ 2, 4, 6 ]) );
  test.identical( r1, r2 );
  test.identical( c1, o.vec([ 5, 6 ]) );
  test.identical( c1, c2 );
  test.identical( e, o.vec([ 5, 6 ]) );
  test.identical( a1, 6 );
  test.identical( a2, 4 );
  test.identical( m.reduceToSumAtomWise(), 21 );
  test.identical( m.reduceToProductAtomWise(), 720 );

  test.case = 'column with dimensions without stride, transposing'; /* */

  var m = new matrix
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

  test.identical( m._stridesEffective, [ 1, 1 ] );
  test.identical( m.strideOfElement, 1 );
  test.identical( m.strideOfCol, 1 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 1 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 0 );
  var c2 = m.lineVectorGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.atomFlatGet( 2 );
  var a2 = m.atomGet([ 1, 0 ]);

  test.identical( r1, o.vec([ 2 ]) );
  test.identical( r1, r2 );
  test.identical( c1, o.vec([ 1, 2, 3 ]) );
  test.identical( c1, c2 );
  test.identical( e, o.vec([ 1, 2, 3 ]) );
  test.identical( a1, 3 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 6 );
  test.identical( m.reduceToProductAtomWise(), 6 );

  test.case = 'column with dimensions without stride, non transposing'; /* */

  var m = new matrix
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

  test.identical( m._stridesEffective, [ 1, 3 ] );
  test.identical( m.strideOfElement, 3 );
  test.identical( m.strideOfCol, 3 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 3 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 0 );
  var c2 = m.lineVectorGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.atomFlatGet( 2 );
  var a2 = m.atomGet([ 1, 0 ]);

  test.identical( r1, o.vec([ 2 ]) );
  test.identical( r1, r2 );
  test.identical( c1, o.vec([ 1, 2, 3 ]) );
  test.identical( c1, c2 );
  test.identical( e, o.vec([ 1, 2, 3 ]) );
  test.identical( a1, 3 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 6 );
  test.identical( m.reduceToProductAtomWise(), 6 );

  test.case = 'matrix with breadth, transposing'; /* */

  var m = new matrix
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

  test.identical( m._stridesEffective, [ 3, 1 ] );
  test.identical( m.strideOfElement, 1 );
  test.identical( m.strideOfCol, 1 );
  test.identical( m.strideInCol, 3 );
  test.identical( m.strideOfRow, 3 );
  test.identical( m.strideInRow, 1 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 2 );
  var c2 = m.lineVectorGet( 0, 2 );
  var e = m.eGet( 2 );
  var a1 = m.atomFlatGet( 5 );
  var a2 = m.atomGet([ 1, 1 ]);

  test.identical( r1, o.vec([ 4, 5, 6 ]) );
  test.identical( r1, r2 );
  test.identical( c1, o.vec([ 3, 6 ]) );
  test.identical( c1, c2 );
  test.identical( e, o.vec([ 3, 6 ]) );
  test.identical( a1, 6 );
  test.identical( a2, 5 );
  test.identical( m.reduceToSumAtomWise(), 21 );
  test.identical( m.reduceToProductAtomWise(), 720 );

  test.case = 'matrix with breadth, non transposing'; /* */

  var m = new matrix
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

  test.identical( m._stridesEffective, [ 1, 2 ] );
  test.identical( m.strideOfElement, 2 );
  test.identical( m.strideOfCol, 2 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 2 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 2 );
  var c2 = m.lineVectorGet( 0, 2 );
  var e = m.eGet( 2 );
  var a1 = m.atomFlatGet( 5 );
  var a2 = m.atomGet([ 1, 1 ]);

  test.identical( r1, o.vec([ 2, 4, 6 ]) );
  test.identical( r1, r2 );
  test.identical( c1, o.vec([ 5, 6 ]) );
  test.identical( c1, c2 );
  test.identical( e, o.vec([ 5, 6 ]) );
  test.identical( a1, 6 );
  test.identical( a2, 4 );
  test.identical( m.reduceToSumAtomWise(), 21 );
  test.identical( m.reduceToProductAtomWise(), 720 );

  test.case = 'construct empty matrix with dims defined'; /* */

  var m = new matrix({ buffer : o.arrayMake(), offset : o.offset, inputTransposing : 0, dims : [ 1, 0 ] });

  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 0 );
  test.identical( m.sizeOfElement, 4 );
  test.identical( m.sizeOfCol, 4 );
  test.identical( m.sizeOfRow, 0 );
  test.identical( m.dims, [ 1, 0 ] );
  test.identical( m.length, 0 );

  test.identical( m._stridesEffective, [ 1, 1 ] );
  test.identical( m.strideOfElement, 1 );
  test.identical( m.strideOfCol, 1 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 1 );

  var r1 = m.rowVectorGet( 0 );
  var r2 = m.lineVectorGet( 1, 0 );

  console.log( r1.toStr() );
  console.log( o.vec([]) );

  test.identical( r1, o.vec([]) );
  test.identical( r1, r2 );
  test.identical( m.reduceToSumAtomWise(), 0 );
  test.identical( m.reduceToProductAtomWise(), 1 );

  test.case = 'construct empty matrix'; /* */

  var m = new matrix({ buffer : o.arrayMake(), offset : o.offset, inputTransposing : 0/*, dims : [ 1, 0 ]*/ });

  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 0 );
  test.identical( m.sizeOfElement, 4 );
  test.identical( m.sizeOfCol, 4 );
  test.identical( m.sizeOfRow, 0 );
  test.identical( m.dims, [ 1, 0 ] );
  test.identical( m.length, 0 );

  test.identical( m._stridesEffective, [ 1, 1 ] );
  test.identical( m.strideOfElement, 1 );
  test.identical( m.strideOfCol, 1 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 1 );

  var r1 = m.rowVectorGet( 0 );
  var r2 = m.lineVectorGet( 1, 0 );

  console.log( r1.toStr() );
  console.log( o.vec([]) );

  test.identical( r1, o.vec([]) );
  test.identical( r1, r2 );
  test.identical( m.reduceToSumAtomWise(), 0 );
  test.identical( m.reduceToProductAtomWise(), 1 );

  if( Config.debug )
  {

    test.shouldThrowErrorSync( () => m.colVectorGet( 0 ) );
    test.shouldThrowErrorSync( () => m.lineVectorGet( 0, 0 ) );
    test.shouldThrowErrorSync( () => m.eGet( 0 ) );

    test.shouldThrowErrorSync( () => m.rowVectorGet( 1 ) );
    test.shouldThrowErrorSync( () => m.colVectorGet( 1 ) );
    test.shouldThrowErrorSync( () => m.eGet( 1 ) );
    test.shouldThrowErrorSync( () => m.atomFlatGet( 1 ) );
    test.shouldThrowErrorSync( () => m.atomGet( 1 ) );

  }

  test.case = 'construct empty matrix with long column, non transposing'; /* */

  function checkEmptyMatrixWithLongColNonTransposing( m )
  {

    test.identical( m.size, 0 );
    test.identical( m.sizeOfElement, 12 );
    test.identical( m.sizeOfCol, 12 );
    test.identical( m.sizeOfRow, 0 );
    test.identical( m.dims, [ 3, 0 ] );
    test.identical( m.breadth, [ 3 ] );
    test.identical( m.length, 0 );

    test.identical( m._stridesEffective, [ 1, 3 ] );
    test.identical( m.strideOfElement, 3 );
    test.identical( m.strideOfCol, 3 );
    test.identical( m.strideInCol, 1 );
    test.identical( m.strideOfRow, 1 );
    test.identical( m.strideInRow, 3 );

    var r1 = m.rowVectorGet( 0 );
    var r2 = m.rowVectorGet( 1 );
    var r3 = m.lineVectorGet( 1, 0 );

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
      test.shouldThrowErrorSync( () => m.colVectorGet( 0 ) );
      test.shouldThrowErrorSync( () => m.lineVectorGet( 0, 0 ) );
      test.shouldThrowErrorSync( () => m.eGet( 0 ) );
      test.shouldThrowErrorSync( () => m.colVectorGet( 1 ) );
      test.shouldThrowErrorSync( () => m.eGet( 1 ) );
      test.shouldThrowErrorSync( () => m.atomFlatGet( 1 ) );
      test.shouldThrowErrorSync( () => m.atomGet( 1 ) );
    }

  }

  var m = new matrix
  ({
    buffer : o.arrayMake(),
    offset : o.offset,
    /* strides : [ 1, 3 ], */
    inputTransposing : 0,
    dims : [ 3, 0 ],
  });
  logger.log( 'm\n' + _.toStr( m ) );
  // checkEmptyMatrixWithLongColNonTransposing( m ); xxx

  var m = matrix.make([ 3, 0 ]);
  logger.log( 'm\n' + _.toStr( m ) );
  checkEmptyMatrixWithLongColNonTransposing( m );
  test.identical( m.strides, null );

  test.case = 'change by empty buffer of empty matrix with long column, non transposing'; /* */

  m.buffer = new I32x();
  logger.log( 'm\n' + _.toStr( m ) );
  checkEmptyMatrixWithLongColNonTransposing( m );

  test.case = 'change by empty buffer of empty matrix with long column, non transposing, with copy'; /* */

  m.copy({ buffer : o.arrayMake(), offset : o.offset });
  logger.log( 'm\n' + _.toStr( m ) );
  checkEmptyMatrixWithLongColNonTransposing( m );

  test.case = 'change buffer of empty matrix with long column, non transposing'; /* */

  m.copy({ buffer : o.arrayMake([ 1, 2, 3 ]), offset : o.offset });
  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 12 );
  test.identical( m.sizeOfElement, 12 );
  test.identical( m.sizeOfCol, 12 );
  test.identical( m.sizeOfRow, 4 );
  test.identical( m.dims, [ 3, 1 ] );
  test.identical( m.length, 1 );

  test.identical( m._stridesEffective, [ 1, 3 ] );
  test.identical( m.strideOfElement, 3 );
  test.identical( m.strideOfCol, 3 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 3 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 0 );
  var c2 = m.lineVectorGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 1, 0 ]);

  test.identical( r1, o.vec([ 2 ]) );
  test.identical( r1, r2 );
  test.identical( c1, o.vec([ 1, 2, 3 ]) );
  test.identical( c1, c2 );
  test.identical( e, o.vec([ 1, 2, 3 ]) );
  test.identical( a1, 2 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 6 );
  test.identical( m.reduceToProductAtomWise(), 6 );

  test.case = 'change buffer of not empty matrix with long column, non transposing'; /* */

  m.copy({ buffer : o.arrayMake([ 1, 2, 3, 4, 5, 6 ]), offset : o.offset });
  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 24 );
  test.identical( m.sizeOfElement, 12 );
  test.identical( m.sizeOfCol, 12 );
  test.identical( m.sizeOfRow, 8 );
  test.identical( m.dims, [ 3, 2 ] );
  test.identical( m.length, 2 );

  test.identical( m._stridesEffective, [ 1, 3 ] );
  test.identical( m.strideOfElement, 3 );
  test.identical( m.strideOfCol, 3 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 3 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 0 );
  var c2 = m.lineVectorGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 1, 0 ]);

  test.identical( r1, o.vec([ 2, 5 ]) );
  test.identical( r1, r2 );
  test.identical( c1, o.vec([ 1, 2, 3 ]) );
  test.identical( c1, c2 );
  test.identical( e, o.vec([ 1, 2, 3 ]) );
  test.identical( a1, 2 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 21 );
  test.identical( m.reduceToProductAtomWise(), 720 );

  test.case = 'construct empty matrix with long column, transposing'; /* */

  function checkEmptyMatrixWithLongColTransposing( m )
  {

    test.identical( m.size, 0 );
    test.identical( m.sizeOfElement, 12 );
    test.identical( m.sizeOfCol, 12 );
    test.identical( m.sizeOfRow, 0 );
    test.identical( m.dims, [ 3, 0 ] );
    test.identical( m.length, 0 );

    test.identical( m._stridesEffective, [ 0, 1 ] );
    test.identical( m.strideOfElement, 1 );
    test.identical( m.strideOfCol, 1 );
    test.identical( m.strideInCol, 0 );
    test.identical( m.strideOfRow, 0 );
    test.identical( m.strideInRow, 1 );

    var r1 = m.rowVectorGet( 0 );
    var r2 = m.rowVectorGet( 1 );
    var r3 = m.lineVectorGet( 1, 0 );

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
      test.shouldThrowErrorSync( () => m.colVectorGet( 0 ) );
      test.shouldThrowErrorSync( () => m.lineVectorGet( 0, 0 ) );
      test.shouldThrowErrorSync( () => m.eGet( 0 ) );
      test.shouldThrowErrorSync( () => m.colVectorGet( 1 ) );
      test.shouldThrowErrorSync( () => m.eGet( 1 ) );
      test.shouldThrowErrorSync( () => m.atomFlatGet( 1 ) );
      test.shouldThrowErrorSync( () => m.atomGet( 1 ) );
    }

  }

  var m = new matrix
  ({
    buffer : o.arrayMake(),
    offset : o.offset,
    /* strides : [ 1, 3 ], */
    inputTransposing : 1,
    dims : [ 3, 0 ],
  });

  logger.log( 'm\n' + _.toStr( m ) );
  checkEmptyMatrixWithLongColTransposing( m );

  test.case = 'change by empty buffer of empty matrix with long column, transposing'; /* */

  var m = new matrix
  ({
    buffer : new I32x(),
    inputTransposing : 1,
    dims : [ 3, 0 ],
  });
  m.buffer = new I32x();
  logger.log( 'm\n' + _.toStr( m ) );
  checkEmptyMatrixWithLongColTransposing( m );

  test.case = 'change by empty buffer of empty matrix with long column, transposing, by copy'; /* */

  m.copy({ buffer : o.arrayMake([]), offset : o.offset });
  logger.log( 'm\n' + _.toStr( m ) );
  checkEmptyMatrixWithLongColTransposing( m );

  test.case = 'change buffer of empty matrix with long column, transposing'; /* */

  m.copy({ buffer : o.arrayMake([ 1, 2, 3 ]), offset : o.offset });
  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 12 );
  test.identical( m.sizeOfElement, 12 );
  test.identical( m.sizeOfCol, 12 );
  test.identical( m.sizeOfRow, 4 );
  test.identical( m.dims, [ 3, 1 ] );
  test.identical( m.length, 1 );

  test.identical( m._stridesEffective, [ 1, 1 ] );
  test.identical( m.strideOfElement, 1 );
  test.identical( m.strideOfCol, 1 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 1 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 0 );
  var c2 = m.lineVectorGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 1, 0 ]);

  test.identical( r1, o.vec([ 2 ]) );
  test.identical( r1, r2 );
  test.identical( c1, o.vec([ 1, 2, 3 ]) );
  test.identical( c1, c2 );
  test.identical( e, o.vec([ 1, 2, 3 ]) );
  test.identical( a1, 2 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 6 );
  test.identical( m.reduceToProductAtomWise(), 6 );

  test.case = 'change buffer of empty matrix with long column, transposing'; /* */

  m.copy({ buffer : o.arrayMake([ 1, 2, 3, 4, 5, 6 ]), offset : o.offset });
  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 24 );
  test.identical( m.sizeOfElement, 12 );
  test.identical( m.sizeOfCol, 12 );
  test.identical( m.sizeOfRow, 8 );
  test.identical( m.dims, [ 3, 2 ] );
  test.identical( m.length, 2 );

  test.identical( m._stridesEffective, [ 2, 1 ] );
  test.identical( m.strideOfElement, 1 );
  test.identical( m.strideOfCol, 1 );
  test.identical( m.strideInCol, 2 );
  test.identical( m.strideOfRow, 2 );
  test.identical( m.strideInRow, 1 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 0 );
  var c2 = m.lineVectorGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 0, 1 ]);

  test.identical( r1, o.vec([ 3, 4 ]) );
  test.identical( r1, r2 );
  test.identical( c1, o.vec([ 1, 3, 5 ]) );
  test.identical( c1, c2 );
  test.identical( e, o.vec([ 1, 3, 5 ]) );
  test.identical( a1, 2 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 21 );
  test.identical( m.reduceToProductAtomWise(), 720 );

  test.case = 'construct empty matrix with long row, transposing'; /* */

  function checkEmptyMatrixWithLongRowTransposing( m )
  {

    test.identical( m.size, 0 );
    test.identical( m.sizeOfElement, 0 );
    test.identical( m.sizeOfCol, 0 );
    test.identical( m.sizeOfRow, 12 );
    test.identical( m.dims, [ 0, 3 ] );
    test.identical( m.length, 3 );

    test.identical( m._stridesEffective, [ 3, 1 ] );
    test.identical( m.strideOfElement, 1 );
    test.identical( m.strideOfCol, 1 );
    test.identical( m.strideInCol, 3 );
    test.identical( m.strideOfRow, 3 );
    test.identical( m.strideInRow, 1 );

    var c1 = m.colVectorGet( 0 );
    var c2 = m.colVectorGet( 1 );
    var c3 = m.lineVectorGet( 0, 0 );
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

      test.shouldThrowErrorSync( () => m.rowVectorGet( 0 ) );
      test.shouldThrowErrorSync( () => m.lineVectorGet( 1, 0 ) );

      test.shouldThrowErrorSync( () => m.eGet( 3 ) );
      test.shouldThrowErrorSync( () => m.colVectorGet( 3 ) );

      test.shouldThrowErrorSync( () => m.atomFlatGet( 1 ) );
      test.shouldThrowErrorSync( () => m.atomGet( 1 ) );

    }

  }

  var m = new matrix
  ({
    buffer : o.arrayMake(),
    offset : o.offset,
    /* strides : [ 3, 0 ], */
    inputTransposing : 1,
    dims : [ 0, 3 ],
  });
  logger.log( 'm\n' + _.toStr( m ) );
  checkEmptyMatrixWithLongRowTransposing( m );
  test.shouldThrowErrorSync( () => m.buffer = new I32x() );

  test.case = 'change by empty buffer of empty matrix with long row, transposing'; /* */

  var m = new matrix
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

  test.case = 'change by non empty buffer of empty matrix with long row, transposing'; /* */

  m.copy({ buffer : o.arrayMake([ 1, 2, 3 ]), offset : o.offset });
  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 12 );
  test.identical( m.sizeOfElement, 4 );
  test.identical( m.sizeOfCol, 4 );
  test.identical( m.sizeOfRow, 12 );
  test.identical( m.dims, [ 1, 3 ] );
  test.identical( m.length, 3 );

  test.identical( m._stridesEffective, [ 3, 1 ] );
  test.identical( m.strideOfElement, 1 );
  test.identical( m.strideOfCol, 1 );
  test.identical( m.strideInCol, 3 );
  test.identical( m.strideOfRow, 3 );
  test.identical( m.strideInRow, 1 );

  var r1 = m.rowVectorGet( 0 );
  var r2 = m.lineVectorGet( 1, 0 );
  var c1 = m.colVectorGet( 1 );
  var c2 = m.lineVectorGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 0, 1 ]);

  test.identical( r1, o.vec([ 1, 2, 3 ]) );
  test.identical( r1, r2 );
  test.identical( c1, o.vec([ 2 ]) );
  test.identical( c1, c2 );
  test.identical( e, o.vec([ 2 ]) );
  test.identical( a1, 2 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 6 );
  test.identical( m.reduceToProductAtomWise(), 6 );

  test.case = 'change by non empty buffer of non empty matrix with long row, transposing'; /* */

  m.copy({ buffer : o.arrayMake([ 1, 2, 3, 4, 5, 6 ]), offset : o.offset });
  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 24 );
  test.identical( m.sizeOfElement, 8 );
  test.identical( m.sizeOfCol, 8 );
  test.identical( m.sizeOfRow, 12 );
  test.identical( m.dims, [ 2, 3 ] );
  test.identical( m.length, 3 );

  test.identical( m._stridesEffective, [ 3, 1 ] );
  test.identical( m.strideOfElement, 1 );
  test.identical( m.strideOfCol, 1 );
  test.identical( m.strideInCol, 3 );
  test.identical( m.strideOfRow, 3 );
  test.identical( m.strideInRow, 1 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 1 );
  var c2 = m.lineVectorGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 0, 1 ]);

  test.identical( r1, o.vec([ 4, 5, 6 ]) );
  test.identical( r1, r2 );
  test.identical( c1, o.vec([ 2, 5 ]) );
  test.identical( c1, c2 );
  test.identical( e, o.vec([ 2, 5 ]) );
  test.identical( a1, 2 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 21 );
  test.identical( m.reduceToProductAtomWise(), 720 );

  test.case = 'construct empty matrix with long row, non transposing'; /* */

  function checkEmptyMatrixWithLongRowNonTransposing( m )
  {

    test.identical( m.size, 0 );
    test.identical( m.sizeOfElement, 0 );
    test.identical( m.sizeOfCol, 0 );
    test.identical( m.sizeOfRow, 12 );
    test.identical( m.dims, [ 0, 3 ] );
    test.identical( m.length, 3 );

    test.identical( m._stridesEffective, [ 1, 0 ] );
    test.identical( m.strideOfElement, 0 );
    test.identical( m.strideOfCol, 0 );
    test.identical( m.strideInCol, 1 );
    test.identical( m.strideOfRow, 1 );
    test.identical( m.strideInRow, 0 );

    var c1 = m.colVectorGet( 0 );
    var c2 = m.colVectorGet( 1 );
    var c3 = m.lineVectorGet( 0, 0 );
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

      test.shouldThrowErrorSync( () => m.rowVectorGet( 0 ) );
      test.shouldThrowErrorSync( () => m.lineVectorGet( 1, 0 ) );

      test.shouldThrowErrorSync( () => m.eGet( 3 ) );
      test.shouldThrowErrorSync( () => m.colVectorGet( 3 ) );

      test.shouldThrowErrorSync( () => m.atomFlatGet( 1 ) );
      test.shouldThrowErrorSync( () => m.atomGet( 1 ) );

    }

  }

  var m = new matrix
  ({
    buffer : o.arrayMake(),
    offset : o.offset,
    /* strides : [ 3, 0 ], */
    inputTransposing : 0,
    dims : [ 0, 3 ],
  });
  logger.log( 'm\n' + _.toStr( m ) );
  checkEmptyMatrixWithLongRowNonTransposing( m );

  var m = matrix.make([ 0, 3 ]);
  logger.log( 'm\n' + _.toStr( m ) );
  checkEmptyMatrixWithLongRowNonTransposing( m );
  test.identical( m.strides, null );

  var m = matrix.make([ 0, 3 ]);
  test.shouldThrowErrorSync( () => m.buffer = new I32x() );

  test.case = 'change by empty buffer of empty matrix with long row, non transposing'; /* */

  var m = matrix.make([ 0, 3 ]);
  m.growingDimension = 0;
  m.buffer = new I32x();
  logger.log( 'm\n' + _.toStr( m ) );
  checkEmptyMatrixWithLongRowNonTransposing( m );

  test.case = 'change by empty buffer of empty matrix with long row, non transposing, by copy'; /* */

  m.copy({ buffer : o.arrayMake([]), offset : o.offset });
  logger.log( 'm\n' + _.toStr( m ) );
  checkEmptyMatrixWithLongRowNonTransposing( m );

  test.case = 'change by non empty buffer of empty matrix with long row, non transposing'; /* */

  m.growingDimension = 0;
  m.copy({ buffer : o.arrayMake([ 1, 2, 3 ]), offset : o.offset });
  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 12 );
  test.identical( m.sizeOfElement, 4 );
  test.identical( m.sizeOfCol, 4 );
  test.identical( m.sizeOfRow, 12 );
  test.identical( m.dims, [ 1, 3 ] );
  test.identical( m.length, 3 );

  test.identical( m._stridesEffective, [ 1, 1 ] );
  test.identical( m.strideOfElement, 1 );
  test.identical( m.strideOfCol, 1 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 1 );

  var r1 = m.rowVectorGet( 0 );
  var r2 = m.lineVectorGet( 1, 0 );
  var c1 = m.colVectorGet( 1 );
  var c2 = m.lineVectorGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 0, 1 ]);

  test.identical( r1, o.vec([ 1, 2, 3 ]) );
  test.identical( r1, r2 );
  test.identical( c1, o.vec([ 2 ]) );
  test.identical( c1, c2 );
  test.identical( e, o.vec([ 2 ]) );
  test.identical( a1, 2 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 6 );
  test.identical( m.reduceToProductAtomWise(), 6 );

  test.case = 'change by non empty buffer of non empty matrix with long row, non transposing'; /* */

  m.growingDimension = 0;
  m.copy({ buffer : o.arrayMake([ 1, 2, 3, 4, 5, 6 ]), offset : o.offset });
  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 24 );
  test.identical( m.sizeOfElement, 8 );
  test.identical( m.sizeOfCol, 8 );
  test.identical( m.sizeOfRow, 12 );
  test.identical( m.dims, [ 2, 3 ] );
  test.identical( m.length, 3 );

  test.identical( m._stridesEffective, [ 1, 2 ] );
  test.identical( m.strideOfElement, 2 );
  test.identical( m.strideOfCol, 2 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 2 );

  var r1 = m.rowVectorGet( 0 );
  var r2 = m.lineVectorGet( 1, 0 );
  var c1 = m.colVectorGet( 1 );
  var c2 = m.lineVectorGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 1, 0 ]);

  test.identical( r1, o.vec([ 1, 3, 5 ]) );
  test.identical( r1, r2 );
  test.identical( c1, o.vec([ 3, 4 ]) );
  test.identical( c1, c2 );
  test.identical( e, o.vec([ 3, 4 ]) );
  test.identical( a1, 2 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 21 );
  test.identical( m.reduceToProductAtomWise(), 720 );

  test.case = 'construct matrix with only buffer'; /* */

  var m = new matrix
  ({
    buffer : o.arrayMake([ 1, 2, 3 ]),
    offset : o.offset,
  });
  logger.log( 'm\n' + _.toStr( m ) );


  test.identical( m.atomsPerMatrix, 3 );
  test.identical( m.size, 12 );
  test.identical( m.sizeOfElement, 12 );
  test.identical( m.sizeOfCol, 12 );
  test.identical( m.sizeOfRow, 4 );
  test.identical( m.dims, [ 3, 1 ] );
  test.identical( m.length, 1 );

  test.identical( m._stridesEffective, [ 1, 3 ] );
  test.identical( m.strideOfElement, 3 );
  test.identical( m.strideOfCol, 3 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 3 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 0 );
  var c2 = m.lineVectorGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 1, 0 ]);

  test.identical( r1, o.vec([ 2 ]) );
  test.identical( r1, r2 );
  test.identical( c1, o.vec([ 1, 2, 3 ]) );
  test.identical( c1, c2 );
  test.identical( e, o.vec([ 1, 2, 3 ]) );
  test.identical( a1, 2 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 6 );
  test.identical( m.reduceToProductAtomWise(), 6 );

  test.case = 'construct matrix without buffer'; /* */

  if( Config.debug )
  {

    test.shouldThrowErrorSync( () => new matrix({ offset : o.offset, }) );

  }

  test.case = 'construct matrix with buffer and strides'; /* */

  if( Config.debug )
  {

    var buffer = new I32x
    ([
      1, 2, 3,
      4, 5, 6,
    ]);
    test.shouldThrowErrorSync( () => new matrix({ buffer, strides : [ 1, 3 ] }) );

  }

  test.case = 'construct empty matrix with dimensions, non transposing'; /* */

  var m = new matrix
  ({
    buffer : o.arrayMake(),
    dims : [ 3, 0 ],
    inputTransposing : 0,
    offset : o.offset,
  });
  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.atomsPerMatrix, 0 );
  test.identical( m.size, 0 );
  test.identical( m.sizeOfElement, 12 );
  test.identical( m.sizeOfCol, 12 );
  test.identical( m.sizeOfRow, 0 );
  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m.length, 0 );

  test.identical( m._stridesEffective, [ 1, 3 ] );
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

  test.identical( m._stridesEffective, [ 1, 3 ] );
  test.identical( m.strideOfElement, 3 );
  test.identical( m.strideOfCol, 3 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 3 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 1 );
  var c2 = m.lineVectorGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.atomFlatGet( 4 );
  var a2 = m.atomGet([ 1, 1 ]);

  test.identical( r1, o.vec([ 2, 5 ]) );
  test.identical( r1, r2 );
  test.identical( c1, o.vec([ 4, 5, 6 ]) );
  test.identical( c1, c2 );
  test.identical( e, o.vec([ 4, 5, 6 ]) );
  test.identical( a1, 5 );
  test.identical( a2, 5 );
  test.identical( m.reduceToSumAtomWise(), 21 );
  test.identical( m.reduceToProductAtomWise(), 720 );

  test.case = 'construct empty matrix with dimensions, transposing'; /* */

  var m = new matrix
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

  test.identical( m._stridesEffective, [ 0, 1 ] );
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

  test.identical( m._stridesEffective, [ 2, 1 ] );
  test.identical( m.strideOfElement, 1 );
  test.identical( m.strideOfCol, 1 );
  test.identical( m.strideInCol, 2 );
  test.identical( m.strideOfRow, 2 );
  test.identical( m.strideInRow, 1 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 1 );
  var c2 = m.lineVectorGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.atomFlatGet( 3 );
  var a2 = m.atomGet([ 1, 1 ]);

  test.identical( r1, o.vec([ 3, 4 ]) );
  test.identical( r1, r2 );
  test.identical( c1, o.vec([ 2, 4, 6 ]) );
  test.identical( c1, c2 );
  test.identical( e, o.vec([ 2, 4, 6 ]) );
  test.identical( a1, 4 );
  test.identical( a2, 4 );
  test.identical( m.reduceToSumAtomWise(), 21 );
  test.identical( m.reduceToProductAtomWise(), 720 );

  test.case = 'make then copy'; /* */

  var m = matrix.make([ 2, 3 ]).copy
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

  test.identical( m._stridesEffective, [ 1, 2 ] );
  test.identical( m.strideOfElement, 2 );
  test.identical( m.strideOfCol, 2 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 2 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 1 );
  var c2 = m.lineVectorGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.atomFlatGet( 3 );
  var a2 = m.atomGet([ 1, 1 ]);

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

  test.case = 'copy buffer from scalar'; /* */

  var m = matrix.makeSquare([ 1, 2, 3, 4 ]);
  var expected = matrix.makeSquare([ 13, 13, 13, 13 ]);

  m.copy( 13 );
  test.identical( m, expected );

  var m = matrix.makeSquare([]);
  var expected = matrix.makeSquare([]);

  m.copy( 13 );
  test.identical( m, expected );

  test.case = 'copy buffer of different type'; /* */

  var b = new F32x
  ([
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
  ]);

  var m = makeWithOffset
  ({
    buffer : b,
    dims : [ 3, 3 ],
    offset : o.offset||0,
    inputTransposing : 1,
  });

  test.is( m.buffer.length-( o.offset||0 ) === 9 );
  test.is( m.buffer instanceof F32x );

  var expected = matrix.make([ 3, 3 ]).copy
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

  test.case = 'bad buffer'; /* */

  test.shouldThrowErrorSync( function()
  {
    new matrix
    ({
      buffer : _.longFromRange([ 1, 5 ]),
      dims : [ 3, 3 ],
    });
  });

  test.shouldThrowErrorSync( function()
  {
    var m = matrix.make([ 2, 3 ]).copy
    ([
      1, 2, 3,
      4, 5, 6,
      7, 8, 9,
    ]);
  });

}

//

function makeHelper( test )
{

  test.case = 'make'; /* */

  var m = matrix.make([ 3, 2 ]);

  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 24 );
  test.identical( m.sizeOfElement, 12 );
  test.identical( m.sizeOfCol, 12 );
  test.identical( m.sizeOfRow, 8 );
  test.identical( m.dims, [ 3, 2 ] );
  test.identical( m.length, 2 );

  test.identical( m._stridesEffective, [ 1, 3 ] );
  test.identical( m.strideOfElement, 3 );
  test.identical( m.strideOfCol, 3 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 3 );

  test.identical( m.strides, null );
  test.is( m.buffer instanceof F32x );

  test.case = 'square with buffer'; /* */

  var buffer =
  [
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
  ];
  debugger;
  var m = matrix.makeSquare( buffer );
  debugger;

  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 36 );
  test.identical( m.sizeOfElement, 12 );
  test.identical( m.sizeOfCol, 12 );
  test.identical( m.sizeOfRow, 12 );
  test.identical( m.dims, [ 3, 3 ] );
  test.identical( m.length, 3 );

  test.identical( m._stridesEffective, [ 3, 1 ] );
  test.identical( m.strideOfElement, 1 );
  test.identical( m.strideOfCol, 1 );
  test.identical( m.strideInCol, 3 );
  test.identical( m.strideOfRow, 3 );
  test.identical( m.strideInRow, 1 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 1 );
  var c2 = m.lineVectorGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.atomFlatGet( 4 );
  var a2 = m.atomGet([ 1, 1 ]);

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
  var m = matrix.makeSquare( buffer );
  test.identical( m.determinant(), 0 );
  test.is( m.buffer instanceof U32x );

  test.case = 'square with length'; /* */

  var m = matrix.makeSquare( 3 );

  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 36 );
  test.identical( m.sizeOfElement, 12 );
  test.identical( m.sizeOfCol, 12 );
  test.identical( m.sizeOfRow, 12 );
  test.identical( m.dims, [ 3, 3 ] );
  test.identical( m.length, 3 );

  test.identical( m._stridesEffective, [ 1, 3 ] );
  test.identical( m.strideOfElement, 3 );
  test.identical( m.strideOfCol, 3 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 3 );

  test.is( m.buffer instanceof F32x );
  test.identical( m.strides, null );

  test.case = 'diagonal'; /* */

  debugger;
  var m = matrix.makeDiagonal([ 1, 2, 3 ]);
  debugger;

  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 36 );
  test.identical( m.sizeOfElement, 12 );
  test.identical( m.sizeOfCol, 12 );
  test.identical( m.sizeOfRow, 12 );
  test.identical( m.dims, [ 3, 3 ] );
  test.identical( m.length, 3 );

  test.identical( m._stridesEffective, [ 1, 3 ] );
  test.identical( m.strideOfElement, 3 );
  test.identical( m.strideOfCol, 3 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 3 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 1 );
  var c2 = m.lineVectorGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.atomFlatGet( 4 );
  var a2 = m.atomGet([ 1, 1 ]);

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

  test.case = 'identity'; /* */

  m = matrix.makeIdentity( 3 );

  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 36 );
  test.identical( m.sizeOfElement, 12 );
  test.identical( m.sizeOfCol, 12 );
  test.identical( m.sizeOfRow, 12 );
  test.identical( m.dims, [ 3, 3 ] );
  test.identical( m.length, 3 );

  test.identical( m._stridesEffective, [ 1, 3 ] );
  test.identical( m.strideOfElement, 3 );
  test.identical( m.strideOfCol, 3 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 3 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 1 );
  var c2 = m.lineVectorGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.atomFlatGet( 4 );
  var a2 = m.atomGet([ 1, 1 ]);

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

  test.case = 'identity, not square, 2x3'; /* */

  m = matrix.makeIdentity([ 2, 3 ]);

  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 24 );
  test.identical( m.sizeOfElement, 8 );
  test.identical( m.sizeOfCol, 8 );
  test.identical( m.sizeOfRow, 12 );
  test.identical( m.dims, [ 2, 3 ] );
  test.identical( m.length, 3 );

  test.identical( m._stridesEffective, [ 1, 2 ] );
  test.identical( m.strideOfElement, 2 );
  test.identical( m.strideOfCol, 2 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 2 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 1 );
  var c2 = m.lineVectorGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.atomFlatGet( 3 );
  var a2 = m.atomGet([ 1, 1 ]);

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

  test.case = 'identity, not square, 3x2'; /* */

  m = matrix.makeIdentity([ 3, 2 ]);

  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 24 );
  test.identical( m.sizeOfElement, 12 );
  test.identical( m.sizeOfCol, 12 );
  test.identical( m.sizeOfRow, 8 );
  test.identical( m.dims, [ 3, 2 ] );
  test.identical( m.length, 2 );

  test.identical( m._stridesEffective, [ 1, 3 ] );
  test.identical( m.strideOfElement, 3 );
  test.identical( m.strideOfCol, 3 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 3 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 1 );
  var c2 = m.lineVectorGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.atomFlatGet( 4 );
  var a2 = m.atomGet([ 1, 1 ]);

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

  test.case = 'zeroed'; /* */

  m = matrix.makeZero( 3 );

  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 36 );
  test.identical( m.sizeOfElement, 12 );
  test.identical( m.sizeOfCol, 12 );
  test.identical( m.sizeOfRow, 12 );
  test.identical( m.dims, [ 3, 3 ] );
  test.identical( m.length, 3 );

  test.identical( m._stridesEffective, [ 1, 3 ] );
  test.identical( m.strideOfElement, 3 );
  test.identical( m.strideOfCol, 3 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 3 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 1 );
  var c2 = m.lineVectorGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.atomFlatGet( 4 );
  var a2 = m.atomGet([ 1, 1 ]);

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

    test.identical( m._stridesEffective, [ 1, 0 ] );
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

      test.shouldThrowErrorSync( () => m.colVectorGet( 0 ) );
      test.shouldThrowErrorSync( () => m.lineVectorGet( 0, 0 ) );
      test.shouldThrowErrorSync( () => m.eGet( 0 ) );
      test.shouldThrowErrorSync( () => m.rowVectorGet( 0 ) );
      test.shouldThrowErrorSync( () => m.colVectorGet( 0 ) );
      test.shouldThrowErrorSync( () => m.eGet( 0 ) );
      test.shouldThrowErrorSync( () => m.atomFlatGet( 0 ) );
      test.shouldThrowErrorSync( () => m.atomGet( 0 ) );

    }

  }

  test.case = 'square null with buffer'; /* */

  var m = matrix.makeSquare([]);
  checkNull( m );

  test.case = 'square null with length'; /* */

  var m = matrix.makeSquare( 0 );
  checkNull( m );

  test.case = 'zeroed null'; /* */

  var m = matrix.makeZero([ 0, 0 ]);
  checkNull( m );

  test.case = 'identity null'; /* */

  var m = matrix.makeIdentity([ 0, 0 ]);
  checkNull( m );

  test.case = 'diagonal null'; /* */

  var m = matrix.makeDiagonal([]);
  checkNull( m );

}

//

function makeLine( test )
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

    test.identical( m._stridesEffective, [ 1, 3 ] );
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

    test.identical( m._stridesEffective, [ 1, 1 ] );
    test.identical( m.strideOfElement, 1 );
    test.identical( m.strideOfCol, 1 );
    test.identical( m.strideInCol, 1 );
    test.identical( m.strideOfRow, 1 );
    test.identical( m.strideInRow, 1 );

    test.identical( m.strides, null );
    test.is( m.buffer instanceof F32x );

  }

  test.case = 'make col'; /* */

  var m = matrix.makeCol( 3 );

  checkCol( m );

  var m = matrix.makeLine
  ({
    dimension : 0,
    buffer : 3,
  });

  checkCol( m );

  var m = matrix.makeLine
  ({
    dimension : 0,
    buffer : new F32x([ 1, 2, 3 ]),
  });

  checkCol( m );

  test.case = 'make col from buffer'; /* */

  var m = matrix.makeCol([ 1, 2, 3 ]);

  checkCol( m );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 0 );
  var c2 = m.lineVectorGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 1, 0 ]);

  test.identical( r1, fvec([ 2 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 1, 2, 3 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 1, 2, 3 ]) );
  test.identical( a1, 2 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 6 );
  test.identical( m.reduceToProductAtomWise(), 6 );

  test.case = 'make col from vector with Array'; /* */

  var v = vad.fromLongLrangeAndStride( [ -1, 1, -1, 2, -1, 3, -1 ], 1, 3, 2 );
  var m = matrix.makeCol( v );

  checkCol( m );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 0 );
  var c2 = m.lineVectorGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 1, 0 ]);

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

  test.case = 'make col from vector with F32x'; /* */

  var v = vad.fromLongLrangeAndStride( new F32x([ -1, 1, -1, 2, -1, 3, -1 ]), 1, 3, 2 );
  var m = matrix.makeCol( v );

  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 12 );
  test.identical( m.sizeOfElement, 12 );
  test.identical( m.sizeOfCol, 12 );
  test.identical( m.sizeOfRow, 4 );
  test.identical( m.dims, [ 3, 1 ] );
  test.identical( m.length, 1 );

  test.identical( m._stridesEffective, [ 2, 2 ] );
  test.identical( m.strideOfElement, 2 );
  test.identical( m.strideOfCol, 2 );
  test.identical( m.strideInCol, 2 );
  test.identical( m.strideOfRow, 2 );
  test.identical( m.strideInRow, 2 );

  test.identical( m.strides, [ 2, 2 ] );
  test.is( m.buffer instanceof F32x );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 0 );
  var c2 = m.lineVectorGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.atomFlatGet( 2 );
  var a2 = m.atomGet([ 1, 0 ]);

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

  test.case = 'make col zeroed'; /* */

  var m = matrix.makeColZeroed( 3 );

  checkCol( m );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 0 );
  var c2 = m.lineVectorGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 1, 0 ]);

  test.identical( r1, fvec([ 0 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 0, 0, 0 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 0, 0, 0 ]) );
  test.identical( a1, 0 );
  test.identical( a2, 0 );
  test.identical( m.reduceToSumAtomWise(), 0 );
  test.identical( m.reduceToProductAtomWise(), 0 );

  test.case = 'make col zeroed from buffer'; /* */

  var m = matrix.makeColZeroed([ 1, 2, 3 ]);

  checkCol( m );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 0 );
  var c2 = m.lineVectorGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 1, 0 ]);

  test.identical( r1, fvec([ 0 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 0, 0, 0 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 0, 0, 0 ]) );
  test.identical( a1, 0 );
  test.identical( a2, 0 );
  test.identical( m.reduceToSumAtomWise(), 0 );
  test.identical( m.reduceToProductAtomWise(), 0 );

  test.case = 'make col zeroed from vector'; /* */

  var v = vad.fromLongLrangeAndStride( new F32x([ -1, 1, -1, 2, -1, 3, -1 ]), 1, 3, 2 );
  var m = matrix.makeColZeroed( v );

  checkCol( m );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 0 );
  var c2 = m.lineVectorGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 1, 0 ]);

  test.identical( r1, fvec([ 0 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 0, 0, 0 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 0, 0, 0 ]) );
  test.identical( a1, 0 );
  test.identical( a2, 0 );
  test.identical( m.reduceToSumAtomWise(), 0 );
  test.identical( m.reduceToProductAtomWise(), 0 );

  test.case = 'make col from col'; /* */

  var om = matrix.makeCol([ 1, 2, 3 ]);
  var m = matrix.makeCol( om );

  checkCol( m );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 0 );
  var c2 = m.lineVectorGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 1, 0 ]);

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

  test.case = 'make col zeroed from col'; /* */

  var om = matrix.makeCol([ 1, 2, 3 ]);
  var m = matrix.makeColZeroed( om );

  checkCol( m );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 0 );
  var c2 = m.lineVectorGet( 0, 0 );
  var e = m.eGet( 0 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 1, 0 ]);

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

  test.case = 'make row'; /* */

  var m = matrix.makeRow( 3 );

  checkRow( m );

  var m = matrix.makeLine
  ({
    dimension : 1,
    buffer : 3,
  });

  checkRow( m );

  var m = matrix.makeLine
  ({
    dimension : 1,
    buffer : new F32x([ 1, 2, 3 ]),
  });

  checkRow( m );

  test.case = 'make row from buffer'; /* */

  var m = matrix.makeRow([ 1, 2, 3 ]);

  checkRow( m );

  var r1 = m.rowVectorGet( 0 );
  var r2 = m.lineVectorGet( 1, 0 );
  var c1 = m.colVectorGet( 1 );
  var c2 = m.lineVectorGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 0, 1 ]);

  test.identical( r1, fvec([ 1, 2, 3 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 2 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 2 ]) );
  test.identical( a1, 2 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 6 );
  test.identical( m.reduceToProductAtomWise(), 6 );

  test.case = 'make row from vector with Array'; /* */

  var v = vad.fromLongLrangeAndStride( [ -1, 1, -1, 2, -1, 3, -1 ], 1, 3, 2 );
  var m = matrix.makeRow( v );

  checkRow( m );

  var r1 = m.rowVectorGet( 0 );
  var r2 = m.lineVectorGet( 1, 0 );
  var c1 = m.colVectorGet( 1 );
  var c2 = m.lineVectorGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 0, 1 ]);

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

  test.case = 'make row from vector with F32x'; /* */

  var v = vad.fromLongLrangeAndStride( new F32x([ -1, 1, -1, 2, -1, 3, -1 ]), 1, 3, 2 );
  var m = matrix.makeRow( v );

  logger.log( 'm\n' + _.toStr( m ) );

  test.identical( m.size, 12 );
  test.identical( m.sizeOfElement, 4 );
  test.identical( m.sizeOfCol, 4 );
  test.identical( m.sizeOfRow, 12 );
  test.identical( m.dims, [ 1, 3 ] );
  test.identical( m.length, 3 );

  test.identical( m._stridesEffective, [ 2, 2 ] );
  test.identical( m.strideOfElement, 2 );
  test.identical( m.strideOfCol, 2 );
  test.identical( m.strideInCol, 2 );
  test.identical( m.strideOfRow, 2 );
  test.identical( m.strideInRow, 2 );

  test.identical( m.strides, [ 2, 2 ] );
  test.is( m.buffer instanceof F32x );

  var r1 = m.rowVectorGet( 0 );
  var r2 = m.lineVectorGet( 1, 0 );
  var c1 = m.colVectorGet( 1 );
  var c2 = m.lineVectorGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.atomFlatGet( 2 );
  var a2 = m.atomGet([ 0, 1 ]);

  test.identical( r1, fvec([ 1, 2, 3 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 2 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 2 ]) );
  test.identical( a1, 2 );
  test.identical( a2, 2 );
  test.identical( m.reduceToSumAtomWise(), 6 );
  test.identical( m.reduceToProductAtomWise(), 6 );

  test.case = 'make row zeroed'; /* */

  var m = matrix.makeRowZeroed( 3 );

  checkRow( m );

  var r1 = m.rowVectorGet( 0 );
  var r2 = m.lineVectorGet( 1, 0 );
  var c1 = m.colVectorGet( 1 );
  var c2 = m.lineVectorGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 0, 1 ]);

  test.identical( r1, fvec([ 0, 0, 0 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 0 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 0 ]) );
  test.identical( a1, 0 );
  test.identical( a2, 0 );
  test.identical( m.reduceToSumAtomWise(), 0 );
  test.identical( m.reduceToProductAtomWise(), 0 );

  test.case = 'make row zeroed from buffer'; /* */

  var m = matrix.makeRowZeroed([ 1, 2, 3 ]);

  checkRow( m );

  var r1 = m.rowVectorGet( 0 );
  var r2 = m.lineVectorGet( 1, 0 );
  var c1 = m.colVectorGet( 1 );
  var c2 = m.lineVectorGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 0, 1 ]);

  test.identical( r1, fvec([ 0, 0, 0 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 0 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 0 ]) );
  test.identical( a1, 0 );
  test.identical( a2, 0 );
  test.identical( m.reduceToSumAtomWise(), 0 );
  test.identical( m.reduceToProductAtomWise(), 0 );

  test.case = 'make row zeroed from vector'; /* */

  var v = vad.fromLongLrangeAndStride( new F32x([ -1, 1, -1, 2, -1, 3, -1 ]), 1, 3, 2 );
  var m = matrix.makeRowZeroed( v );

  checkRow( m );

  var r1 = m.rowVectorGet( 0 );
  var r2 = m.lineVectorGet( 1, 0 );
  var c1 = m.colVectorGet( 1 );
  var c2 = m.lineVectorGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 0, 1 ]);

  test.identical( r1, fvec([ 0, 0, 0 ]) );
  test.identical( r1, r2 );
  test.identical( c1, fvec([ 0 ]) );
  test.identical( c1, c2 );
  test.identical( e, fvec([ 0 ]) );
  test.identical( a1, 0 );
  test.identical( a2, 0 );
  test.identical( m.reduceToSumAtomWise(), 0 );
  test.identical( m.reduceToProductAtomWise(), 0 );

  test.case = 'make row from row'; /* */

  var om = matrix.makeRow([ 1, 2, 3 ]);
  var m = matrix.makeRow( om );

  checkRow( m );

  var r1 = m.rowVectorGet( 0 );
  var r2 = m.lineVectorGet( 1, 0 );
  var c1 = m.colVectorGet( 1 );
  var c2 = m.lineVectorGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 0, 1 ]);

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

  test.case = 'make row zeroed from row'; /* */

  var om = matrix.makeRow([ 1, 2, 3 ]);
  var m = matrix.makeRowZeroed( om );

  checkRow( m );

  var r1 = m.rowVectorGet( 0 );
  var r2 = m.lineVectorGet( 1, 0 );
  var c1 = m.colVectorGet( 1 );
  var c2 = m.lineVectorGet( 0, 1 );
  var e = m.eGet( 1 );
  var a1 = m.atomFlatGet( 1 );
  var a2 = m.atomGet([ 0, 1 ]);

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

function _makeSimilar( test, o )
{

  test.case = o.name + ' . simplest from matrix'; //

  var m = matrix.make([ 2, 3 ]);
  m.buffer = o.arrayMake([ 1, 2, 3, 4, 5, 6 ]);

  var got = m.makeSimilar();
  test.is( got.buffer.constructor === m.buffer.constructor );
  test.identical( got.dims, m.dims );
  test.identical( got._stridesEffective, [ 1, 2 ] );
  test.identical( got.strides, null );

  var got = matrix.makeSimilar( m );
  test.is( got.buffer.constructor === m.buffer.constructor );
  test.identical( got.dims, m.dims );
  test.identical( got._stridesEffective, [ 1, 2 ] );
  test.identical( got.strides, null );

  test.case = o.name + ' . from matrix with offset and stride'; //

  var buffer = o.arrayMake
  ([
    -1,
    1, -1, 2, -1,
    3, -1, 4, -4,
    -1,
  ]);

  var m = matrix
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
  test.identical( got._stridesEffective, [ 1, 2 ] );
  test.identical( got.strides, null );

  var got = matrix.makeSimilar( m );
  test.is( got.buffer.constructor === m.buffer.constructor );
  test.identical( got.dims, m.dims );
  test.identical( got._stridesEffective, [ 1, 2 ] );
  test.identical( got.strides, null );

  test.case = o.name + ' . from matrix with dims, offset and stride'; //

  var buffer = o.arrayMake
  ([
    -1,
    1, -1, 2, -1,
    3, -1, 4, -4,
    -1,
  ]);

  var m = matrix
  ({
    dims : [ 2, 2 ],
    inputTransposing : 1,
    offset : 1,
    buffer,
    strides : [ 2, 2 ],
  });

  var got = m.makeSimilar( [ 3, 4 ] );
  test.is( got.buffer.constructor === m.buffer.constructor );
  test.identical( got.dims, [ 3, 4 ] );
  test.identical( got._stridesEffective, [ 1, 3 ] );
  test.identical( got.strides, null );

  var got = matrix.makeSimilar( m, [ 3, 4 ] );
  test.is( got.buffer.constructor === m.buffer.constructor );
  test.identical( got.dims, [ 3, 4 ] );
  test.identical( got._stridesEffective, [ 1, 3 ] );
  test.identical( got.strides, null );

  test.case = o.name + ' . from array'; //

  var src = o.arrayMake([ 1, 2, 3 ]);
  var got = matrix.makeSimilar( src );
  test.is( got.constructor === src.constructor );
  test.identical( got.length , src.length );

  test.case = o.name + ' . from array with dims'; //

  var src = o.arrayMake([ 1, 2, 3 ]);
  var got = matrix.makeSimilar( src, [ 5, 1 ] );
  test.is( got.constructor === src.constructor );
  test.identical( got.length , 5 );

  test.case = o.name + ' . from vector'; //

  var src = vad.from( o.arrayMake([ 1, 2, 3 ]) );
  var got = matrix.makeSimilar( src );
  test.is( _.vectorAdapterIs( src ) );
  test.identical( got.length , src.length );

  var src = vad.fromLongLrangeAndStride( o.arrayMake([ -1, 1, -1, 2, -1, 3, -1 ]), 1, 3, 1 );
  var got = matrix.makeSimilar( src );
  test.is( _.vectorAdapterIs( src ) );
  test.identical( got.length , src.length );

  test.case = o.name + ' . from vector with dims'; //

  var src = vad.from( o.arrayMake([ 1, 2, 3 ]) );
  var got = matrix.makeSimilar( src, [ 5, 1 ] );
  test.is( _.vectorAdapterIs( src ) );
  test.identical( got.length , 5 );

  var src = vad.fromLongLrangeAndStride( o.arrayMake([ -1, 1, -1, 2, -1, 3, -1 ]), 1, 3, 1 );
  var got = matrix.makeSimilar( src, [ 5, 1 ] );
  test.is( _.vectorAdapterIs( src ) );
  test.identical( got.length , 5 );

  test.case = o.name + ' . special'; //

  var exp = o.arrayMake( 4 );
  var got = matrix.makeSimilar( o.arrayMake([ 1, 2, 3 ]), [ 4, 1 ] ); /* xxx */
  test.identical( got, exp );

  var exp = o.arrayMake( 3 );
  var got = matrix.makeSimilar( o.arrayMake([ 1, 2, 3 ]), [ null, 1 ] ); /* xxx */
  test.identical( got, exp );

  test.case = o.name + ' . bad arguments'; //

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () => matrix.makeSimilar() );
  test.shouldThrowErrorSync( () => matrix.makeSimilar( null ) );
  test.shouldThrowErrorSync( () => matrix.makeSimilar( null, [ 1, 1 ] ) );

  test.shouldThrowErrorSync( () => matrix.makeSimilar( o.arrayMake([ 1, 2, 3 ]), 1 ) );
  test.shouldThrowErrorSync( () => matrix.makeSimilar( matrix.make([ 2, 2 ]), 1 ) );
  test.shouldThrowErrorSync( () => matrix.makeSimilar( vec( o.arrayMake([ 1, 2, 3 ]) ), 1 ) );

  test.shouldThrowErrorSync( () => matrix.makeSimilar( o.arrayMake([ 1, 2, 3 ]), [ 3, 2 ] ) );
  test.shouldThrowErrorSync( () => matrix.makeSimilar( vec( o.arrayMake([ 1, 2, 3 ]) ), [ 3, 2 ] ) );

  test.shouldThrowErrorSync( () => matrix.makeSimilar( vec( o.arrayMake([ 1, 2, 3 ]) ), [ null, 1 ] ) );
  test.shouldThrowErrorSync( () => matrix.makeSimilar( matrix.make([ 2, 2 ]), [ null, 1 ] ) );

  test.shouldThrowErrorSync( () => matrix.makeSimilar( o.arrayMake([ 1, 2, 3 ]), [ 3, 1, 1 ] ) );
  test.shouldThrowErrorSync( () => matrix.makeSimilar( vec( o.arrayMake([ 1, 2, 3 ]) ), [ 3, 1, 1 ] ) );
  test.shouldThrowErrorSync( () => matrix.makeSimilar( matrix.make([ 2, 2 ]), [ null, 1 ] ) );

}

//

function makeSimilar( test )
{

  var o = Object.create( null );
  o.name = 'Array';
  o.arrayMake = function( a ){ return _.longMake( Array, a ) };
  this._makeSimilar( test, o );

  var o = Object.create( null );
  o.name = 'F32x';
  o.arrayMake = function( a ){ return _.longMake( F32x, a ) };
  this._makeSimilar( test, o );

  var o = Object.create( null );
  o.name = 'U32x';
  o.arrayMake = function( a ){ return _.longMake( U32x, a ) };
  this._makeSimilar( test, o );

}

//

function from( test )
{

  test.case = '_BufferFrom from array'; /* */

  var expected = new F32x([ 1, 2, 3 ]);
  var got = matrix._BufferFrom([ 1, 2, 3 ]);
  test.identical( got, expected );

  test.case = '_BufferFrom from vector with Array'; /* */

  var v = vad.fromLongLrangeAndStride( [ -1, 1, -1, 2, -1, 3, -1 ], 1, 3, 2 );
  var expected = new F32x([ 1, 2, 3 ]);
  var got = matrix._BufferFrom( v );
  test.identical( got, expected );

  test.case = '_BufferFrom from vector with F32x'; /* */

  var v = vad.fromLongLrangeAndStride( new F32x([ -1, 1, -1, 2, -1, 3, -1 ]), 1, 3, 2 );
  var got = matrix._BufferFrom( v );
  test.is( got === v );

  test.case = 'fromScalarForReading scalar'; /* */

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    1, 1, 1,
    1, 1, 1,
  ]);

  var m = matrix.fromScalarForReading( 1, [ 2, 3 ] );
  m.toStr();
  logger.log( m );

  test.identical( m, expected );
  test.identical( m.dims, [ 2, 3 ] );
  test.identical( m._stridesEffective, [ 0, 0 ] )

  test.case = 'empty matrix fromScalarForReading scalar'; /* */

  var expected = matrix.make([ 0, 3 ]);
  var m = matrix.fromScalarForReading( 1, [ 0, 3 ] );
  test.identical( m, expected )
  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m._stridesEffective, [ 0, 0 ] )

  var expected = matrix.make([ 3, 0 ]);
  var m = matrix.fromScalarForReading( 1, [ 3, 0 ] );
  test.identical( m, expected );
  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m._stridesEffective, [ 0, 0 ] )
  logger.log( m );

  test.case = 'fromForReading scalar'; /* */

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    1, 1, 1,
    1, 1, 1,
  ]);

  var m = matrix.fromForReading( 1, [ 2, 3 ] );
  m.toStr();
  logger.log( m );

  test.identical( m, expected );
  test.identical( m.dims, [ 2, 3 ] );
  test.identical( m._stridesEffective, [ 0, 0 ] )

  test.case = 'empty matrix fromForReading scalar'; /* */

  var expected = matrix.make([ 0, 3 ]);
  var m = matrix.fromForReading( 1, [ 0, 3 ] );
  test.identical( m, expected )
  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m._stridesEffective, [ 0, 0 ] )

  var expected = matrix.make([ 3, 0 ]);
  var m = matrix.fromForReading( 1, [ 3, 0 ] );
  test.identical( m, expected )
  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m._stridesEffective, [ 0, 0 ] )
  logger.log( m );

  test.case = 'from scalar'; /* */

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    1, 1, 1,
    1, 1, 1,
  ]);

  var m = matrix.from( 1, [ 2, 3 ] );
  m.toStr();
  logger.log( m );

  test.identical( m, expected );
  test.identical( m.dims, [ 2, 3 ] );
  test.identical( m._stridesEffective, [ 1, 2 ] )

  test.case = 'empty matrix from scalar'; /* */

  var expected = matrix.make([ 0, 3 ]);
  var m = matrix.from( 1, [ 0, 3 ] );
  test.identical( m, expected )
  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m._stridesEffective, [ 1, 0 ] )

  var expected = matrix.make([ 3, 0 ]);
  var m = matrix.from( 1, [ 3, 0 ] );
  test.identical( m, expected )
  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m._stridesEffective, [ 1, 3 ] )

  logger.log( m );

  test.case = 'fromScalar scalar'; /* */

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    1, 1, 1,
    1, 1, 1,
  ]);

  var m = matrix.fromScalar( 1, [ 2, 3 ] );
  m.toStr();
  logger.log( m );

  test.identical( m, expected );
  test.identical( m.dims, [ 2, 3 ] );
  test.identical( m._stridesEffective, [ 1, 2 ] )

  test.case = 'empty matrix fromScalar scalar'; /* */

  var expected = matrix.make([ 0, 3 ]);
  var m = matrix.fromScalar( 1, [ 0, 3 ] );
  test.identical( m, expected )
  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m._stridesEffective, [ 1, 0 ] )

  var expected = matrix.make([ 3, 0 ]);
  var m = matrix.fromScalar( 1, [ 3, 0 ] );
  test.identical( m, expected )
  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m._stridesEffective, [ 1, 3 ] )

  logger.log( m );

  test.case = 'from matrix'; /* */

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    1, 1, 1,
    1, 1, 1,
  ]);

  var m = matrix.make([ 2, 3 ]).copy
  ([
    1, 1, 1,
    1, 1, 1,
  ]);

  var got = matrix.from( m, [ 2, 3 ] );
  test.identical( got, expected );

  var got = matrix.from( m );
  test.identical( got, expected );

  test.case = 'from array'; /* */

  var expected = matrix.make([ 3, 1 ]);
  expected.buffer = [ 1, 2, 3, ];

  var a = [ 1, 2, 3 ];

  var got = matrix.from( a );
  test.identical( got, expected );

  var got = matrix.from( a, [ 3, 1 ] );
  test.identical( got, expected );

  test.case = 'from vector'; /* */

  var expected = matrix.make([ 3, 1 ]);
  expected.buffer = [ 1, 2, 3, ];

  var a = vec([ 1, 2, 3 ]);

  var got = matrix.from( a );
  test.identical( got, expected );

  var got = matrix.from( a, [ 3, 1 ] );
  test.identical( got, expected );

  test.case = 'bad arguments'; /* */

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
  test.shouldThrowErrorSync( () => m.from( matrix.make([ 3, 3 ]), matrix.make([ 3, 3 ]) ) );
  test.shouldThrowErrorSync( () => m.from( matrix.make([ 2, 3 ]), [ 2, 4 ] ) );
  test.shouldThrowErrorSync( () => m.from( matrix.make([ 3, 2 ]), [ 3, 2 ] ) );

}

//

function tempBorrow( test )
{

  test.case = 'should give same temp'; /* */

  var m = matrix.make([ 3, 2 ]);
  var t1 = m.tempBorrow();

  test.identical( t1.dims, [ 3, 2 ] )
  test.identical( t1._stridesEffective, [ 1, 3 ] )

  var t2 = m.tempBorrow();
  var t3 = matrix.tempBorrow( m );
  var t3 = matrix.tempBorrow( m.dims );

  test.is( t1 === t2 );
  test.is( t1 === t3 );

  test.is( t1.buffer.constructor === F32x );
  test.is( t2.buffer.constructor === F32x );
  test.is( t3.buffer.constructor === F32x );

  test.case = 'should give another temp'; /* */

  var m = matrix.make([ 3, 2 ]);
  m.buffer = new I32x( 6 );
  var t2 = m.tempBorrow();

  test.identical( t2.dims, [ 3, 2 ] )
  test.identical( t2._stridesEffective, [ 1, 3 ] )

  var t3 = m.tempBorrow();
  var t4 = matrix.tempBorrow( m );
  var t5 = matrix.tempBorrow( m.dims );

  test.is( t1 !== t2 );
  test.is( t2 === t3 );
  test.is( t2 === t4 );
  test.is( t1 === t5 );

  test.is( t2.buffer.constructor === I32x );
  test.is( t3.buffer.constructor === I32x );
  test.is( t4.buffer.constructor === I32x );
  test.is( t5.buffer.constructor === F32x );

  test.case = 'with dims'; /* */

  var m = matrix.make([ 3, 2 ]);
  m.buffer = new I32x( 6 );
  var t1 = matrix._tempBorrow( m, [ 4, 4 ], 0 );
  var t2 = matrix._tempBorrow( m, [ 4, 4 ], 1 );

  test.identical( t1.dims, [ 4, 4 ] );
  test.identical( t2.dims, [ 4, 4 ] );
  test.is( t1.buffer.constructor === I32x );
  test.is( t2.buffer.constructor === I32x );
  test.is( t1 !== t2 );

  test.case = 'with dims from matrix'; /* */

  var m = matrix.make([ 3, 2 ]);
  m.buffer = new I32x( 6 );
  var m2 = matrix.make([ 4, 4 ]);
  var t1 = matrix._tempBorrow( m, m2, 0 );
  var t2 = matrix._tempBorrow( m, m2, 1 );

  test.identical( t1.dims, [ 4, 4 ] );
  test.identical( t2.dims, [ 4, 4 ] );
  test.is( t1.buffer.constructor === I32x );
  test.is( t2.buffer.constructor === I32x );
  test.is( t1 !== t2 );

  test.case = 'without dims'; /* */

  var m = matrix.make([ 3, 2 ]);
  m.buffer = new I32x( 6 );
  var t1 = matrix._tempBorrow( m, null, 0 );
  var t2 = matrix._tempBorrow( m, null, 1 );

  test.identical( t1.dims, [ 3, 2 ] );
  test.identical( t2.dims, [ 3, 2 ] );
  test.is( t1.buffer.constructor === I32x );
  test.is( t2.buffer.constructor === I32x );
  test.is( t1 !== t2 );

  test.case = 'without matrix'; /* */

  var t1 = matrix._tempBorrow( null, [ 4, 4 ], 0 );
  var t2 = matrix._tempBorrow( null, [ 4, 4 ], 1 );

  test.identical( t1.dims, [ 4, 4 ] );
  test.identical( t2.dims, [ 4, 4 ] );
  test.is( t1.buffer.constructor === F32x );
  test.is( t2.buffer.constructor === F32x );
  test.is( t1 !== t2 );

}

//

function copyClone( test )
{

  test.case = 'clone 3x3'; /* */

  var m1 = matrix.makeIdentity([ 3, 3 ]);
  m2 = m1.clone();

  test.identical( m1, m2 );
  test.is( m1.buffer !== m2.buffer );

  test.case = 'clone 0x0'; /* */

  var m1 = matrix.makeIdentity([ 0, 0 ]);
  m2 = m1.clone();

  test.identical( m2.dims, [ 0, 0 ] );
  test.identical( m1, m2 );
  test.is( m1.buffer !== m2.buffer );

  test.case = 'clone 3x0'; /* */

  var m1 = matrix.makeIdentity([ 3, 0 ]);
  m2 = m1.clone();

  test.identical( m2.dims, [ 3, 0 ] );
  test.identical( m1, m2 );
  test.is( m1.buffer !== m2.buffer );

  test.case = 'clone 0x3'; /* */

  var m1 = matrix.makeIdentity([ 0, 3 ]);
  m2 = m1.clone();

  test.identical( m2.dims, [ 0, 3 ] );
  test.identical( m1, m2 );
  test.is( m1.buffer !== m2.buffer );

  test.case = 'copy 3x3'; /* */

  var m1 = matrix.makeIdentity([ 3, 3 ]);
  var m2 = matrix.makeZero([ 3, 3 ]);
  m2.copy( m1 );

  test.identical( m1, m2 );
  test.is( m1.buffer !== m2.buffer );

  test.case = 'copy 3x3 itself'; /* */

  var expected = matrix.makeIdentity([ 3, 3 ]);
  var m1 = matrix.makeIdentity([ 3, 3 ]);
  m1.copy( m1 );

  test.identical( m1, expected );

  test.case = 'copy 0x0'; /* */

  var m1 = matrix.makeIdentity([ 0, 0 ]);
  var m2 = matrix.makeZero([ 0, 0 ]);
  m2.copy( m1 );

  test.identical( m2.dims, [ 0, 0 ] );
  test.identical( m1, m2 );
  test.is( m1.buffer !== m2.buffer );

  test.case = 'copy 3x0'; /* */

  var m1 = matrix.makeIdentity([ 3, 0 ]);
  var m2 = matrix.makeZero([ 3, 0 ]);
  m2.copy( m1 );

  test.identical( m2.dims, [ 3, 0 ] );
  test.identical( m1, m2 );
  test.is( m1.buffer !== m2.buffer );

  test.case = 'copy 0x3'; /* */

  var m1 = matrix.makeIdentity([ 0, 3 ]);
  var m2 = matrix.makeZero([ 0, 3 ]);
  m2.copy( m1 );

  test.identical( m2.dims, [ 0, 3 ] );
  test.identical( m1, m2 );
  test.is( m1.buffer !== m2.buffer );

  test.case = 'copy 0x0 itself'; /* */

  var expected = matrix.makeIdentity([ 0, 0 ]);
  var m1 = matrix.makeIdentity([ 0, 0 ]);
  m1.copy( m1 );

  test.identical( m1, expected );
  test.identical( m1.dims, [ 0, 0 ] );

}

//

function _convertToClass( test, o )
{

  test.case = o.name + ' . ' + 'matrix to matrix with class'; //

  var src = matrix.make([ 2, 2 ]);
  matrix.buffer = o.arrayMake([ 1, 2, 3, 4 ]);
  var got = matrix.convertToClass( matrix, src );
  test.is( got === src );

  test.case = o.name + ' . ' + 'matrix to vector with class'; //

  var src = matrix.makeCol( 3 );
  src.buffer = o.arrayMake([ 1, 2, 3 ]);
  var got = matrix.convertToClass( vad.fromLong( o.arrayMake([]) ).constructor, src );
  var expected = vad.fromLong( o.arrayMake([ 1, 2, 3 ]) );
  test.identical( got, expected );

  test.case = o.name + ' . ' + 'matrix to array with class'; //

  var src = matrix.makeCol( o.arrayMake([ 1, 2, 3 ]) );
  var got = matrix.convertToClass( o.arrayMake([]).constructor, src );
  var expected = o.arrayMake([ 1, 2, 3 ]);
  test.identical( got, expected );

  test.case = o.name + ' . ' + 'array to matrix with class'; //

  var src = o.arrayMake([ 1, 2, 3 ]);
  var expected = matrix.make([ 3, 1 ]);
  expected.buffer = o.arrayMake([ 1, 2, 3 ]);
  var got = matrix.convertToClass( matrix, src );
  test.identical( got, expected );

  test.case = o.name + ' . ' + 'array to vector with class'; //

  var src = o.arrayMake([ 1, 2, 3 ]);
  var expected = vec( o.arrayMake([ 1, 2, 3 ]) );
  var got = matrix.convertToClass( vec([]).constructor, src );
  test.identical( got, expected );

  test.case = o.name + ' . ' + 'array to array with class'; //

  var src = o.arrayMake([ 1, 2, 3 ]);
  var expected = o.arrayMake([ 1, 2, 3 ]);
  var got = matrix.convertToClass( o.arrayMake([]).constructor, src );
  test.identical( got, expected );
  test.is( got === src );

  test.case = o.name + ' . ' + 'vector to matrix with class'; //

  var src = vec( o.arrayMake([ 1, 2, 3 ]) );
  var expected = matrix.make([ 3, 1 ]);
  expected.buffer = o.arrayMake([ 1, 2, 3 ]);
  var got = matrix.convertToClass( matrix, src );
  test.identical( got, expected );

  test.case = o.name + ' . ' + 'vector to vector with class'; //

  var src = vec( o.arrayMake([ 1, 2, 3 ]) );
  var expected = vec( o.arrayMake([ 1, 2, 3 ]) );
  var got = matrix.convertToClass( vec([]).constructor, src );
  test.identical( got, expected );
  test.is( got === src );

  test.case = o.name + ' . ' + 'vector to array with class'; //

  var src = vec( o.arrayMake([ 1, 2, 3 ]) );
  var expected = o.arrayMake([ 1, 2, 3 ]);
  var got = matrix.convertToClass( o.arrayMake([]).constructor, src );
  test.identical( got, expected );

  test.case = o.name + ' . ' + 'bad arguments'; //

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () => matrix.make([ 2, 1 ]).convertToClass() );
  test.shouldThrowErrorSync( () => matrix.make([ 2, 1 ]).convertToClass( [].constructor ) );
  test.shouldThrowErrorSync( () => matrix.make([ 2, 1 ]).convertToClass( vec([]).constructor ) );

  test.shouldThrowErrorSync( () => matrix.convertToClass( [].constructor, matrix.make([ 2, 1 ]), 1 ) );
  test.shouldThrowErrorSync( () => matrix.convertToClass( [].constructor ) );
  test.shouldThrowErrorSync( () => matrix.convertToClass( [].constructor, null ) );
  test.shouldThrowErrorSync( () => matrix.convertToClass( null, matrix.make([ 2, 1 ]) ) );
  test.shouldThrowErrorSync( () => matrix.convertToClass( [].constructor, 1 ) );

}

//

function convertToClass( test )
{

  var o = Object.create( null );
  o.name = 'Array';
  o.arrayMake = function( a ){ return _.longMake( Array, a ) };
  this._convertToClass( test, o );

  var o = Object.create( null );
  o.name = 'F32x';
  o.arrayMake = function( a ){ return _.longMake( F32x, a ) };
  this._convertToClass( test, o );

  var o = Object.create( null );
  o.name = 'U32x';
  o.arrayMake = function( a ){ return _.longMake( U32x, a ) };
  this._convertToClass( test, o );

}

//

function _copyTo( test, o )
{

  test.case = o.name + ' . ' + 'matrix to array'; //

  var src = matrix.makeCol( o.arrayMake([ 1, 2, 3 ]) );
  var dst = o.arrayMake([ 0, 0, 0 ]);
  var expected = o.arrayMake([ 1, 2, 3 ]);

  var got = matrix.CopyTo( dst, src );
  test.identical( got, expected ); debugger;
  test.is( dst === got );

  test.case = o.name + ' . ' + 'matrix to vector'; //

  var src = matrix.makeCol( o.arrayMake([ 1, 2, 3 ]) );
  var dst = vec( o.arrayMake([ 0, 0, 0 ]) );
  var expected = vec( o.arrayMake([ 1, 2, 3 ]) );

  var got = matrix.CopyTo( dst, src );
  test.identical( got, expected );
  test.is( dst === got );

  test.case = o.name + ' . ' + 'matrix to matrix'; //

  var src = matrix.makeCol( o.arrayMake([ 1, 2, 3 ]) );
  var dst = matrix.makeCol( o.arrayMake([ 0, 0, 0 ]) );
  var expected = matrix.makeCol( o.arrayMake([ 1, 2, 3 ]) );

  var got = matrix.CopyTo( dst, src );
  test.identical( got, expected );
  test.is( dst === got );

  test.case = o.name + ' . ' + 'vector to array'; //

  var src = vec( o.arrayMake([ 1, 2, 3 ]) );
  var dst = o.arrayMake([ 0, 0, 0 ]);
  var expected = o.arrayMake([ 1, 2, 3 ]);

  var got = matrix.CopyTo( dst, src );
  test.identical( got, expected );
  test.is( dst === got );

  test.case = o.name + ' . ' + 'vector to vector'; //

  var src = vec( o.arrayMake([ 1, 2, 3 ]) );
  var dst = vec( o.arrayMake([ 0, 0, 0 ]) );
  var expected = vec( o.arrayMake([ 1, 2, 3 ]) );

  var got = matrix.CopyTo( dst, src );
  test.identical( got, expected );
  test.is( dst === got );

  test.case = o.name + ' . ' + 'vector to matrix'; //

  var src = vec( o.arrayMake([ 1, 2, 3 ]) );
  var dst = matrix.makeCol( o.arrayMake([ 0, 0, 0 ]) );
  var expected = matrix.makeCol( o.arrayMake([ 1, 2, 3 ]) );

  var got = matrix.CopyTo( dst, src );
  test.identical( got, expected );
  test.is( dst === got );

  test.case = o.name + ' . ' + 'array to array'; //

  var src = o.arrayMake([ 1, 2, 3 ]);
  var dst = o.arrayMake([ 0, 0, 0 ]);
  var expected = o.arrayMake([ 1, 2, 3 ]);

  var got = matrix.CopyTo( dst, src );
  test.identical( got, expected );
  test.is( dst === got );

  test.case = o.name + ' . ' + 'array to vector'; //

  var src = o.arrayMake([ 1, 2, 3 ]);
  var dst = vec( o.arrayMake([ 0, 0, 0 ]) );
  var expected = vec( o.arrayMake([ 1, 2, 3 ]) );

  var got = matrix.CopyTo( dst, src );
  test.identical( got, expected );
  test.is( dst === got );

  test.case = o.name + ' . ' + 'array to matrix'; //

  var src = o.arrayMake([ 1, 2, 3 ]);
  var dst = matrix.makeCol( o.arrayMake([ 0, 0, 0 ]) );
  var expected = matrix.makeCol( o.arrayMake([ 1, 2, 3 ]) );

  var got = matrix.CopyTo( dst, src );
  test.identical( got, expected );
  test.is( dst === got );

  test.case = o.name + ' . ' + 'matrix to itself'; //

  var src = matrix.makeCol( o.arrayMake([ 1, 2, 3 ]) );
  var expected = matrix.makeCol( o.arrayMake([ 1, 2, 3 ]) );

  var got = matrix.CopyTo( src, src );
  test.identical( got, expected );
  test.is( src === got );

  test.case = o.name + ' . ' + 'vector to itself'; //

  var src = vec( o.arrayMake([ 1, 2, 3 ]) );
  var expected = vec( o.arrayMake([ 1, 2, 3 ]) );

  var got = matrix.CopyTo( src, src );
  test.identical( got, expected );
  test.is( src === got );

  test.case = o.name + ' . ' + 'array to itself'; //

  var src = o.arrayMake([ 1, 2, 3 ]);
  var expected = o.arrayMake([ 1, 2, 3 ]);

  var got = matrix.CopyTo( src, src );
  test.identical( got, expected );
  test.is( src === got );

  test.case = o.name + ' . ' + 'bad arguments'; //

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () => matrix.CopyTo() );
  test.shouldThrowErrorSync( () => matrix.makeCol( o.arrayMake([ 1 ]) ).CopyTo() );
  test.shouldThrowErrorSync( () => matrix.makeCol( o.arrayMake([ 1 ]) ).CopyTo( [ 3 ], null ) );

  test.shouldThrowErrorSync( () => matrix.CopyTo( matrix.makeCol( o.arrayMake([ 1 ]) ) ) );
  test.shouldThrowErrorSync( () => matrix.CopyTo( o.arrayMake([ 1 ]) ) );
  test.shouldThrowErrorSync( () => matrix.CopyTo( vec( o.arrayMake([ 1 ]) ) ) );

  test.shouldThrowErrorSync( () => matrix.CopyTo( matrix.makeCol( o.arrayMake([ 1 ]) ), null ) );
  test.shouldThrowErrorSync( () => matrix.CopyTo( o.arrayMake([ 1 ]), null ) );
  test.shouldThrowErrorSync( () => matrix.CopyTo( vec( o.arrayMake([ 1 ]) ), null ) );

  test.shouldThrowErrorSync( () => matrix.CopyTo( matrix.makeCol( o.arrayMake([ 1 ]) ), [ 3 ], null ) );
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

  test.case = 'copy buffer without copying strides and offset'; /* */

  dst.copy( src );

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
  test.identical( src._stridesEffective, [ 2, 4 ] );
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
  test.identical( dst._stridesEffective, [ 3, 1 ] );
  test.identical( dst.strideOfElement, 1 );
  test.identical( dst.strideOfCol, 1 );
  test.identical( dst.strideInCol, 3 );
  test.identical( dst.strideOfRow, 3 );
  test.identical( dst.strideInRow, 1 );

  test.case = 'no buffer move'; /* */

  var src = matrix.make([ 3, 2 ]).copy
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);
  var dst = matrix.make([ 3, 2 ]).copy
  ([
    10, 40,
    20, 50,
    30, 60,
  ]);

  var srcBuffer = src.buffer;
  var dstBuffer = dst.buffer;

  var expected = matrix.make([ 3, 2 ]).copy
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

  test.case = 'copy null matrix'; /* */

  var src = matrix.make([ 0, 0 ]);
  var dst = matrix.make([ 0, 0 ]);

  var srcBuffer = src.buffer;
  var dstBuffer = dst.buffer;

  var expected = matrix.make([ 0, 0 ]);

  dst.copy( src );
  test.identical( dst, expected );
  test.is( src.buffer === srcBuffer );
  test.is( dst.buffer === dstBuffer );
  test.is( src.buffer !== dst.buffer );

  test.case = 'converting constructor and copy itself'; /* */

  var src = matrix.make([ 3, 2 ]).copy
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);

  var srcBuffer = src.buffer;

  var dst = matrix( src );

  var expected = matrix.make([ 3, 2 ]).copy
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


  test.case = 'copy via constructor with instance'; /* */

  var src = matrix.make([ 3, 2 ]).copy
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);

  var dst = new matrix( src );

  var srcBuffer = src.buffer;
  var dstBuffer = dst.buffer;

  var expected = matrix.make([ 3, 2 ]).copy
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

  test.case = 'copy via constructor with map'; /* */

  var buffer = new F32x
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);
  var dst = matrix({ buffer, dims : [ 3, 2 ], inputTransposing : 1 });
  var dstBuffer = dst.buffer;

  var expected = matrix.make([ 3, 2 ]).copy
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);

  test.identical( dst, expected );
  test.is( dst.buffer === buffer );

  test.case = 'copy from matrix with different srides'; /* */

  var src1 = matrix.make([ 3, 2 ]).copy
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);

  var src2 = src1.submatrix([ [ 0, src1.dims[ 0 ]-1 ], [ 0, src1.dims[ 1 ]-1 ] ]);

  var dst = matrix.make([ 2, 1 ]).copy
  ([
    11,
    22,
  ]);

  test.identical( src1._stridesEffective, [ 1, 3 ] );
  test.identical( src2._stridesEffective, [ 1, 3 ] );
  test.identical( dst._stridesEffective, [ 1, 2 ] );

  test.identical( src1.dims, [ 3, 2 ] );
  test.identical( src2.dims, [ 2, 1 ] );
  test.identical( dst.dims, [ 2, 1 ] );

  console.log( 'src1', src1.toStr() );
  console.log( 'src2', src2.toStr() );
  console.log( 'dst', dst.toStr() );

  dst.copy( src2 ); /* xxx */

  test.identical( src1._stridesEffective, [ 1, 3 ] );
  test.identical( src2._stridesEffective, [ 1, 3 ] );
  test.identical( dst._stridesEffective, [ 1, 2 ] );

  test.identical( src1.dims, [ 3, 2 ] );
  test.identical( src2.dims, [ 2, 1 ] );
  test.identical( dst.dims, [ 2, 1 ] );

  console.log( 'src1', src1.toStr() );
  console.log( 'src2', src2.toStr() );

  test.case = 'copy different size'; /* */

  var src = matrix.make([ 3, 2 ]).copy
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);

  var dst = matrix.make([ 2, 1 ]).copy
  ([
    11,
    22,
  ]);

  dst.copy( src );

  test.identical( dst.buffer, src.buffer );
  test.identical( dst.dims, src.dims );
  test.identical( dst.strides, src.strides );
  test.identical( dst._stridesEffective, src._stridesEffective );

  test.is( dst.buffer !== src.buffer );
  test.is( dst.dims !== src.dims );
  test.is( dst.strides === null );
  test.is( dst._stridesEffective !== src._stridesEffective );

  test.case = 'copy different size, empty'; /* */

  var src = matrix.make([ 3, 2 ]).copy
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);

  var dst = matrix.make([ 0, 0 ]);

  dst.copy( src );

  test.identical( dst.buffer, src.buffer );
  test.identical( dst.dims, src.dims );
  test.identical( dst.strides, src.strides );
  test.identical( dst._stridesEffective, src._stridesEffective );

  test.is( dst.buffer !== src.buffer );
  test.is( dst.dims !== src.dims );
  test.is( dst.strides === null );
  test.is( dst._stridesEffective !== src._stridesEffective );

  /* */

  if( !Config.debug )
  return;

  test.case = 'inconsistant sizes'; /* */

  test.shouldThrowErrorSync( () => matrix.make([ 3, 2 ]).copy( 'x' ) );

  // test.shouldThrowErrorSync( () => matrix.make([ 3, 2 ]).copy( matrix.make([ 2, 2 ]) ) );
  // test.shouldThrowErrorSync( () => matrix.make([ 3, 2 ]).copy( matrix.make([ 3, 1 ]) ) );
  // test.shouldThrowErrorSync( () => matrix.make([ 3, 2 ]).copy( matrix.make([ 0, 0 ]) ) );

}

//

function offset( test )
{

  test.case = 'init'; /* */

  var buffer =
  [
    -1, -1,
    1, 2,
    3, 4,
    5, 6,
    11, 11,
  ]

  var m = matrix.make([ 3, 2 ]);

  m.copy
  ({
    buffer,
    offset : 2,
    strides : [ 1, 3 ],
    dims : [ 3, 2 ],
  });

  test.is( m.buffer instanceof Array );

  test.case = 'atomGet'; /* */

  test.identical( m.atomGet([ 0, 0 ]), 1 );
  test.identical( m.atomGet([ 2, 1 ]), 6 );

  test.case = 'atomFlatGet'; /* */

  test.identical( m.atomFlatGet( 0 ), 1 );
  test.identical( m.atomFlatGet( 5 ), 6 );

  test.case = 'atomSet, atomFlatSet'; /* */

  var expected = matrix.make([ 3, 2 ]).copy
  ({
    buffer : [ 101, 102, 3, 4, 105, 106 ],
  });

  console.log( m.toStr() );
  console.log( expected.toStr() );

  m.atomSet([ 0, 0 ], 101 );
  m.atomSet([ 2, 1 ], 106 );
  m.atomFlatSet( 1, 102 );
  m.atomFlatSet( 4, 105 );

  test.identical( m, expected );

  test.case = 'bad arguments'; /* */

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () => m.atomFlatGet() );
  test.shouldThrowErrorSync( () => m.atomFlatGet( '' ) );
  test.shouldThrowErrorSync( () => m.atomFlatGet( '0' ) );
  test.shouldThrowErrorSync( () => m.atomFlatGet( -1 ) );
  test.shouldThrowErrorSync( () => m.atomFlatGet( 6 ) );

  test.shouldThrowErrorSync( () => m.atomFlatSet( -1, -1 ) );
  test.shouldThrowErrorSync( () => m.atomFlatSet( 6, -1 ) );

  test.shouldThrowErrorSync( () => m.atomGet() );
  test.shouldThrowErrorSync( () => m.atomGet( '' ) );
  test.shouldThrowErrorSync( () => m.atomGet( '0' ) );
  test.shouldThrowErrorSync( () => m.atomGet( [] ) );
  test.shouldThrowErrorSync( () => m.atomGet( [ 0, 0, 0 ] ) );
  test.shouldThrowErrorSync( () => m.atomGet( [ 3, 0 ] ) );
  test.shouldThrowErrorSync( () => m.atomGet( [ 0, 2 ] ) );

  test.shouldThrowErrorSync( () => m.atomSet( [ 3, 0 ], -1 ) );
  test.shouldThrowErrorSync( () => m.atomSet( [ 0, 2 ], -1 ) );

}

//

function stride( test )
{

  test.case = '2x2 same strides'; /* */

  var buffer = new F32x
  ([
    -1,
    1, -1, 2, -1,
    3, -1, 4, -1,
    -1,
  ]);

  var m = matrix
  ({
    dims : [ 2, 2 ],
    inputTransposing : 1,
    offset : 1,
    buffer,
    strides : [ 2, 2 ],
  });

  var expected = matrix.make([ 2, 2 ]).copy
  ([
    1, 2,
    2, 3,
  ]);

  test.identical( m.occupiedRange, [ 1, 6 ] );
  test.identical( m, expected );
  test.identical( m.strides, [ 2, 2 ] );
  test.identical( m._stridesEffective, [ 2, 2 ] );
  logger.log( m );

  test.case = '2x3 same strides'; /* */

  var buffer = new F32x
  ([
    -1,
    1, -1, 2, -1, 3, -1,
    4, -1, 5, -1, 6, -1,
    -1,
  ]);

  var m = matrix
  ({
    dims : [ 2, 3 ],
    inputTransposing : 1,
    offset : 1,
    buffer,
    strides : [ 2, 2 ],
  });

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    2, 3, 4,
  ]);

  test.identical( m, expected );
  test.identical( m.strides, [ 2, 2 ] );
  test.identical( m._stridesEffective, [ 2, 2 ] );
  logger.log( m );

}

//

function _bufferNormalize( o )
{
  var test = o.test;

  test.case = 'trivial'; /* */

  var buffer = new F64x
  ([
    1, 2, 3,
    4, 5, 6,
  ]);
  var m = makeWithOffset
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

  test.identical( m._stridesEffective, [ 1, 2 ] );
  test.identical( m.strideOfElement, 2 );
  test.identical( m.strideOfCol, 2 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 2 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 2 );
  var c2 = m.lineVectorGet( 0, 2 );
  var e = m.eGet( 2 );
  var a1 = m.atomFlatGet( 5 );
  var a2 = m.atomGet([ 1, 1 ]);

  test.identical( r1, vec( new F64x([ 4, 5, 6 ]) ) );
  test.identical( r1, r2 );
  test.identical( c1, vec( new F64x([ 3, 6 ]) ) );
  test.identical( c1, c2 );
  test.identical( e, vec( new F64x([ 3, 6 ]) ) );
  test.identical( a1, 6 );
  test.identical( a2, 5 );
  test.identical( m.reduceToSumAtomWise(), 21 );
  test.identical( m.reduceToProductAtomWise(), 720 );

  test.case = 'not transposed'; /* */

  var buffer = new F64x
  ([
    1, 4,
    2, 5,
    3, 6,
  ]);
  var m = makeWithOffset
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

  test.identical( m._stridesEffective, [ 1, 2 ] );
  test.identical( m.strideOfElement, 2 );
  test.identical( m.strideOfCol, 2 );
  test.identical( m.strideInCol, 1 );
  test.identical( m.strideOfRow, 1 );
  test.identical( m.strideInRow, 2 );

  var r1 = m.rowVectorGet( 1 );
  var r2 = m.lineVectorGet( 1, 1 );
  var c1 = m.colVectorGet( 2 );
  var c2 = m.lineVectorGet( 0, 2 );
  var e = m.eGet( 2 );
  var a1 = m.atomFlatGet( 5 );
  var a2 = m.atomGet([ 1, 1 ]);

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

  test.case = 'left grow'; /* */

  var expected = matrix.make([ 3, 5 ]).copy
  ([
    0, 0, 0, 0, 0,
    0, 0, 1, 2, 3,
    0, 0, 3, 4, 5,
  ]);

  var m = matrix.make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    3, 4, 5,
  ]);

  m.expand([ [ 1, null ], [ 2, null ] ]);
  test.identical( m, expected );

  test.case = 'right grow'; /* */

  var expected = matrix.make([ 3, 5 ]).copy
  ([
    1, 2, 3, 0, 0,
    3, 4, 5, 0, 0,
    0, 0, 0, 0, 0,
  ]);

  var m = matrix.make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    3, 4, 5,
  ]);

  m.expand([ [ null, 1 ], [ null, 2 ] ]);
  test.identical( m, expected );

  test.case = 'left shrink'; /* */

  var expected = matrix.make([ 1, 2 ]).copy
  ([
    4, 5,
  ]);

  var m = matrix.make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    3, 4, 5,
  ]);

  m.expand([ [ -1, null ], [ -1, null ] ]);
  test.identical( m, expected );

  test.case = 'right shrink'; /* */

  var expected = matrix.make([ 1, 2 ]).copy
  ([
    1, 2,
  ]);

  var m = matrix.make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    3, 4, 5,
  ]);

  m.expand([ [ null, -1 ], [ null, -1 ] ]);
  test.identical( m, expected );

  test.case = 'no expand'; /* */

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    3, 4, 5,
  ]);

  var m = matrix.make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    3, 4, 5,
  ]);

  var buffer = m.buffer;

  m.expand([ null, null ]);
  test.identical( m, expected );
  test.is( buffer === m.buffer );

  test.case = 'number as argument'; /* */

  var expected = matrix.make([ 5, 1 ]).copy
  ([
    0,
    2,
    4,
    0,
    0,
  ]);

  var m = matrix.make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    3, 4, 5,
  ]);

  var buffer = m.buffer;
  m.expand([ [ 1, 2 ], -1 ]);
  test.identical( m, expected );

  test.case = 'add rows to empty matrix'; /* */

  var expected = matrix.make([ 3, 3 ]).copy
  ([
    0, 0, 0,
    0, 0, 0,
    0, 0, 0,
  ]);

  var m = matrix.make([ 0, 3 ]);
  m.expand([ [ 2, 1 ], [ 0, 0 ] ]);
  test.identical( m, expected );

  var expected = matrix.make([ 3, 0 ]);
  var m = matrix.make([ 0, 0 ]);
  m.expand([ [ 2, 1 ], [ 0, 0 ] ]);
  test.identical( m, expected );

  var expected = matrix.make([ 6, 0 ]);
  var m = matrix.make([ 3, 0 ]);
  m.expand([ [ 2, 1 ], [ 0, 0 ] ]);
  test.identical( m, expected );

  test.case = 'add cols to empty matrix'; /* */

  var expected = matrix.make([ 3, 3 ]).copy
  ([
    0, 0, 0,
    0, 0, 0,
    0, 0, 0,
  ]);

  var m = matrix.make([ 3, 0 ]);
  m.expand([ [ 0, 0 ], [ 2, 1 ] ]);
  test.identical( m, expected );

  var expected = matrix.make([ 0, 3 ]);
  var m = matrix.make([ 0, 0 ]);
  m.expand([ [ 0, 0 ], [ 2, 1 ] ]);
  test.identical( m, expected );

  var expected = matrix.make([ 0, 6 ]);
  var m = matrix.make([ 0, 3 ]);
  m.expand([ [ 0, 0 ], [ 2, 1 ] ]);
  test.identical( m, expected );

  test.case = 'bad arguments'; /* */

  matrix.make([ 3, 2 ]).expand([ [ 1, 1 ], [ 1, 1 ] ]);
  test.shouldThrowErrorSync( () => matrix.make([ 3, 2 ]).expand() );
  test.shouldThrowErrorSync( () => matrix.make([ 3, 2 ]).expand( [ '1', '1' ] ) );
  test.shouldThrowErrorSync( () => matrix.make([ 3, 2 ]).expand( [ 1, 1, 1 ] ) );
  test.shouldThrowErrorSync( () => matrix.make([ 3, 2 ]).expand( [ 1, 1 ], [ 1, 1 ] ) );
  test.shouldThrowErrorSync( () => matrix.make([ 3, 2 ]).expand([ [ 1, 1 ] ]) );
  test.shouldThrowErrorSync( () => matrix.make([ 3, 2 ]).expand([ [ 1, 1 ], [ 1, 1 ], [ 1, 1 ] ]) );
  test.shouldThrowErrorSync( () => matrix.make([ 3, 2 ]).expand([ [ 1, 1 ], [ 1, 1, 1 ] ]) );

  test.shouldThrowErrorSync( () => matrix.make([ 3, 2 ]).expand([ [ 1, 1 ], '1' ]) );
  test.shouldThrowErrorSync( () => matrix.make([ 3, 2 ]).expand([ '1', [ 1, 1 ] ]) );
  test.shouldThrowErrorSync( () => matrix.make([ 3, 2 ]).expand([ [ 1, 1 ], [ 1, 1 ], 1 ]) );

  test.shouldThrowErrorSync( () => matrix.make([ 3, 2 ]).expand([ [ -4, 1 ], [ 1, 1 ] ]) );
  test.shouldThrowErrorSync( () => matrix.make([ 3, 2 ]).expand([ [ 1, 1 ], [ 1, -3 ] ]) );
  test.shouldThrowErrorSync( () => matrix.make([ 3, 2 ]).expand([ [ 1, -4 ], [ -4, 1 ] ]) );
  test.shouldThrowErrorSync( () => matrix.make([ 3, 2 ]).expand([ [ 1, 1 ], [ 1, -3 ] ]) );

}

//

function vectorToMatrix( test )
{

  /* */

  test.case = 'vector to matrix'; /* */
  var v = _.vectorAdapter.from([ 1, 2, 3 ]);
  var got = v.to( _.Matrix );
  var expected = _.Matrix.makeCol([ 1, 2, 3 ]);
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

    m32 = matrix
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

    m23 = matrix
    ({
      dims : [ 2, 3 ],
      inputTransposing : 1,
      offset : 1,
      buffer,
    });

  }

  test.case = 'eGet'; /* */

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

  test.case = 'eSet'; /* */

  remake();

  var expected = matrix.make([ 3, 2 ]).copy
  ([
    10, 40,
    20, 50,
    30, 60,
  ]);

  m32.eSet( 0, [ 10, 20, 30 ] );
  m32.eSet( 1, [ 40, 50, 60 ] );
  test.identical( m32, expected );

  var expected = matrix.make([ 2, 3 ]).copy
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

  test.case = 'eSet vector'; /* */

  remake();

  var expected = matrix.make([ 3, 2 ]).copy
  ([
    10, 40,
    20, 50,
    30, 60,
  ]);

  m32.eSet( 0, ivec([ 10, 20, 30 ]) );
  m32.eSet( 1, ivec([ 40, 50, 60 ]) );
  test.identical( m32, expected );

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    10, 0, 30,
    40, 0, 60,
  ]);

  m23.eSet( 0, ivec([ 10, 40 ]) );
  m23.eSet( 1, 0 );
  m23.eSet( 2, ivec([ 30, 60 ]) );
  test.identical( m23, expected );

  test.case = 'colVectorGet'; /* */

  remake();

  test.identical( m32.colVectorGet( 0 ), fvec([ 1, 3, 5 ]) );
  test.identical( m32.colVectorGet( 1 ), fvec([ 2, 4, 6 ]) );
  test.identical( m23.colVectorGet( 0 ), fvec([ 1, 4 ]) );
  test.identical( m23.colVectorGet( 2 ), fvec([ 3, 6 ]) );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m23.colVectorGet() );
    test.shouldThrowErrorSync( () => m32.colVectorGet( -1 ) );
    test.shouldThrowErrorSync( () => m32.colVectorGet( 2 ) );
    test.shouldThrowErrorSync( () => m23.colVectorGet( -1 ) );
    test.shouldThrowErrorSync( () => m23.colVectorGet( 3 ) );
    test.shouldThrowErrorSync( () => m23.colVectorGet( 0, 0 ) );
    test.shouldThrowErrorSync( () => m23.colVectorGet( [ 0 ] ) );
  }

  test.case = 'lineVectorGet col'; /* */

  remake();

  test.identical( m32.lineVectorGet( 0, 0 ), fvec([ 1, 3, 5 ]) );
  test.identical( m32.lineVectorGet( 0, 1 ), fvec([ 2, 4, 6 ]) );
  test.identical( m23.lineVectorGet( 0, 0 ), fvec([ 1, 4 ]) );
  test.identical( m23.lineVectorGet( 0, 2 ), fvec([ 3, 6 ]) );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m23.lineVectorGet( 0 ) );
    test.shouldThrowErrorSync( () => m32.lineVectorGet( 0, -1 ) );
    test.shouldThrowErrorSync( () => m32.lineVectorGet( 0, 2 ) );
    test.shouldThrowErrorSync( () => m23.lineVectorGet( 0, -1 ) );
    test.shouldThrowErrorSync( () => m23.lineVectorGet( 0, 3 ) );
    test.shouldThrowErrorSync( () => m23.lineVectorGet( 0, 0, 0 ) );
    test.shouldThrowErrorSync( () => m23.lineVectorGet( 0, [ 0 ] ) );
    test.shouldThrowErrorSync( () => m23.lineVectorGet( [ 0 ] ) );
  }

  test.case = 'colSet'; /* */

  remake();

  var expected = matrix.make([ 3, 2 ]).copy
  ([
    10, 40,
    20, 50,
    30, 60,
  ]);

  m32.colSet( 0, [ 10, 20, 30 ] );
  m32.colSet( 1, [ 40, 50, 60 ] );
  test.identical( m32, expected );

  var expected = matrix.make([ 2, 3 ]).copy
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

  test.case = 'colSet vector'; /* */

  remake();

  var expected = matrix.make([ 3, 2 ]).copy
  ([
    10, 40,
    20, 50,
    30, 60,
  ]);

  m32.colSet( 0, ivec([ 10, 20, 30 ]) );
  m32.colSet( 1, ivec([ 40, 50, 60 ]) );
  test.identical( m32, expected );

  var expected = matrix.make([ 2, 3 ]).copy
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

  test.case = 'lineSet col'; /* */

  remake();

  var expected = matrix.make([ 3, 2 ]).copy
  ([
    10, 40,
    20, 50,
    30, 60,
  ]);

  m32.lineSet( 0, 0, [ 10, 20, 30 ] );
  m32.lineSet( 0, 1, [ 40, 50, 60 ] );
  test.identical( m32, expected );

  var expected = matrix.make([ 2, 3 ]).copy
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

  test.case = 'rowVectorGet'; /* */

  remake();

  test.identical( m23.rowVectorGet( 0 ), fvec([ 1, 2, 3 ]) );
  test.identical( m23.rowVectorGet( 1 ), fvec([ 4, 5, 6 ]) );
  test.identical( m32.rowVectorGet( 0 ), fvec([ 1, 2 ]) );
  test.identical( m32.rowVectorGet( 2 ), fvec([ 5, 6 ]) );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m23.rowVectorGet() );
    test.shouldThrowErrorSync( () => m23.rowVectorGet( -1 ) );
    test.shouldThrowErrorSync( () => m23.rowVectorGet( 2 ) );

    test.shouldThrowErrorSync( () => m32.rowVectorGet( -1 ) );
    test.shouldThrowErrorSync( () => m32.rowVectorGet( 3 ) );
    test.shouldThrowErrorSync( () => m32.rowVectorGet( 0, 0 ) );
    test.shouldThrowErrorSync( () => m32.rowVectorGet( [ 0 ] ) );
  }

  test.case = 'lineVectorGet row'; /* */

  remake();

  test.identical( m23.lineVectorGet( 1, 0 ), fvec([ 1, 2, 3 ]) );
  test.identical( m23.lineVectorGet( 1, 1 ), fvec([ 4, 5, 6 ]) );
  test.identical( m32.lineVectorGet( 1, 0 ), fvec([ 1, 2 ]) );
  test.identical( m32.lineVectorGet( 1, 2 ), fvec([ 5, 6 ]) );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m23.lineVectorGet() );
    test.shouldThrowErrorSync( () => m23.lineVectorGet( 1 ) );
    test.shouldThrowErrorSync( () => m23.lineVectorGet( 1, -1 ) );
    test.shouldThrowErrorSync( () => m23.lineVectorGet( 1, 2 ) );
    test.shouldThrowErrorSync( () => m32.lineVectorGet( 1, -1 ) );
    test.shouldThrowErrorSync( () => m32.lineVectorGet( 1, 3 ) );
    test.shouldThrowErrorSync( () => m32.lineVectorGet( 1, 0, 0 ) );
    test.shouldThrowErrorSync( () => m32.lineVectorGet( 1, [ 0 ] ) );
  }

  test.case = 'rowSet'; /* */

  remake();

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    10, 20, 30,
    40, 50, 60,
  ]);

  m23.rowSet( 0, [ 10, 20, 30 ] );
  m23.rowSet( 1, [ 40, 50, 60 ] );
  test.identical( m23, expected );

  var expected = matrix.make([ 3, 2 ]).copy
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

  test.case = 'rowSet vector'; /* */

  remake();

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    10, 20, 30,
    40, 50, 60,
  ]);

  m23.rowSet( 0, ivec([ 10, 20, 30 ]) );
  m23.rowSet( 1, ivec([ 40, 50, 60 ]) );
  test.identical( m23, expected );

  var expected = matrix.make([ 3, 2 ]).copy
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

  test.case = 'lineSet row'; /* */

  remake();

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    10, 20, 30,
    40, 50, 60,
  ]);

  m23.lineSet( 1, 0, [ 10, 20, 30 ] );
  m23.lineSet( 1, 1, [ 40, 50, 60 ] );
  test.identical( m23, expected );

  var expected = matrix.make([ 3, 2 ]).copy
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

  test.case = 'atomGet'; /* */

  remake();

  test.identical( m23.atomGet([ 0, 0 ]), 1 );
  test.identical( m23.atomGet([ 1, 2 ]), 6 );
  test.identical( m32.atomGet([ 0, 0 ]), 1 );
  test.identical( m32.atomGet([ 2, 1 ]), 6 );

  if( Config.debug )
  {

    test.shouldThrowErrorSync( () => m23.atomGet() );
    test.shouldThrowErrorSync( () => m23.atomGet( 0 ) );
    test.shouldThrowErrorSync( () => m23.atomGet( 0, 0 ) );
    test.shouldThrowErrorSync( () => m23.atomGet( [ 0, 0 ], 0 ) );
    test.shouldThrowErrorSync( () => m23.atomGet( [ 0, undefined ] ) );
    test.shouldThrowErrorSync( () => m23.atomGet( [ undefined, 0 ] ) );

    test.shouldThrowErrorSync( () => m23.atomGet( [ 2, 2 ] ) );
    test.shouldThrowErrorSync( () => m23.atomGet( [ 1, 3 ] ) );
    test.shouldThrowErrorSync( () => m32.atomGet( [ 2, 2 ] ) );
    test.shouldThrowErrorSync( () => m32.atomGet( [ 3, 1 ] ) );

  }

  test.case = 'atomSet'; /* */

  remake();

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    10, 2, 3,
    4, 5, 60,
  ]);

  m23.atomSet( [ 0, 0 ], 10 );
  m23.atomSet( [ 1, 2 ], 60 );
  test.identical( m23, expected );

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => m23.atomSet() );
    test.shouldThrowErrorSync( () => m23.atomSet( 0 ) );
    test.shouldThrowErrorSync( () => m23.atomSet( 0, 0) );
    test.shouldThrowErrorSync( () => m23.atomSet( 0, 0, 0 ) );
    test.shouldThrowErrorSync( () => m23.atomSet( [ 0, 0 ], undefined ) );
    test.shouldThrowErrorSync( () => m23.atomSet( [ 0, 0 ], 0, 0 ) );
    test.shouldThrowErrorSync( () => m23.atomSet( [ 0, 0 ], [ 0 ] ) );
  }

}

//

function partialAccessors( test )
{

  test.case = 'mul'; /* */

  var u = matrix.make([ 3, 3 ]).copy
  ([
    +1, +2, +3,
    +0, +4, +5,
    +0, +0, +6,
  ]);

  var l = matrix.make([ 3, 3 ]).copy
  ([
    +1, +0, +0,
    +2, +4, +0,
    +3, +5, +6,
  ]);

  var expected = matrix.make([ 3, 3 ]).copy
  ([
    +14, +23, +18,
    +23, +41, +30,
    +18, +30, +36,
  ]);

  var uxl = matrix.mul( null, [ u, l ] );
  logger.log( uxl );
  test.identical( uxl, expected );

  test.case = 'zero'; /* */

  var m = matrix.make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    0, 0, 0,
    0, 0, 0,
  ]);

  m.zero();
  test.identical( m, expected );

  test.case = 'zero empty'; /* */

  var m = matrix.make([ 0, 0 ]);
  var expected = matrix.make([ 0, 0 ]);
  var r = m.zero();
  test.identical( m, expected );
  test.is( m === r );

  test.case = 'zero bad arguments'; /* */

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => matrix.makeIdentity( 3 ).zero( 1 ) );
    test.shouldThrowErrorSync( () => matrix.makeIdentity( 3 ).zero( [ 1, 1 ] ) );
    test.shouldThrowErrorSync( () => matrix.makeIdentity( 3 ).zero( matrix.makeIdentity( 3 ) ) );
  }

  test.case = 'diagonalVectorGet 3x4 transposed'; /* */

  var buffer =
  [
    -1,
    1, 2, 3, 4,
    5, 6, 7, 8,
    9, 10, 11, 12,
    -1,
  ]

  var m = matrix
  ({
    dims : [ 3, 4 ],
    inputTransposing : 1,
    offset : 1,
    buffer,
  });

  var expected = vec([ 1, 6, 11 ]);
  var diagonal = m.diagonalVectorGet();
  test.identical( diagonal, expected );

  test.case = 'diagonalVectorGet 3x4 not transposed'; /* */

  var buffer =
  [
    -1,
    1, 5, 9,
    2, 6, 10,
    3, 7, 11,
    4, 8, 12,
    -1,
  ]

  var m = matrix
  ({
    dims : [ 3, 4 ],
    inputTransposing : 0,
    offset : 1,
    buffer,
  });

  var expected = vec([ 1, 6, 11 ]);
  var diagonal = m.diagonalVectorGet();
  test.identical( diagonal, expected );

  test.case = 'diagonalVectorGet null row'; /* */

  var m = matrix.make([ 0, 4 ]);
  var expected = fvec([]);
  var diagonal = m.diagonalVectorGet();
  test.identical( diagonal, expected );

  test.case = 'diagonalVectorGet 4x3 transposed'; /* */

  var buffer =
  [
    -1,
    1, 5, 9,
    2, 6, 10,
    3, 7, 11,
    4, 8, 12,
    -1,
  ]

  var m = matrix
  ({
    dims : [ 4, 3 ],
    inputTransposing : 1,
    offset : 1,
    buffer,
  });

  var expected = vec([ 1, 6, 11 ]);
  var diagonal = m.diagonalVectorGet();
  test.identical( diagonal, expected );

  test.case = 'diagonalVectorGet 4x3 not transposed'; /* */

  var buffer =
  [
    -1,
    1, 2, 3, 4,
    5, 6, 7, 8,
    9, 10, 11, 12,
    -1,
  ]

  var m = matrix
  ({
    dims : [ 4, 3 ],
    inputTransposing : 0,
    offset : 1,
    buffer,
  });

  var expected = vec([ 1, 6, 11 ]);
  var diagonal = m.diagonalVectorGet();
  test.identical( diagonal, expected );

  test.case = 'diagonalVectorGet null column'; /* */

  var m = matrix.make([ 4, 0 ]);
  var expected = fvec([]);
  var diagonal = m.diagonalVectorGet();
  test.identical( diagonal, expected );

  test.case = 'diagonalVectorGet bad arguments'; /* */

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => matrix.makeIdentity( 3 ).diagonalVectorGet( 1 ) );
    test.shouldThrowErrorSync( () => matrix.makeIdentity( 3 ).diagonalVectorGet( [ 1, 1 ] ) );
    test.shouldThrowErrorSync( () => matrix.makeIdentity( 3 ).diagonalVectorGet( matrix.makeIdentity( 3 ) ) );
  }

  test.case = 'diagonalSet vector'; /* */

  var m = matrix.make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    11, 2, 3,
    4, 22, 6,
  ]);

  m.diagonalSet( ivec([ 11, 22 ]) );
  test.identical( m, expected );

  test.case = 'diagonalSet 2x3'; /* */

  var m = matrix.make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    11, 2, 3,
    4, 22, 6,
  ]);

  m.diagonalSet([ 11, 22 ]);
  test.identical( m, expected );

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    0, 2, 3,
    4, 0, 6,
  ]);

  m.diagonalSet( 0 );
  test.identical( m, expected );

  test.case = 'diagonalSet 3x2'; /* */

  var m = matrix.make([ 3, 2 ]).copy
  ([
    1, 2,
    3, 4,
    5, 6,
  ]);

  var expected = matrix.make([ 3, 2 ]).copy
  ([
    11, 2,
    3, 22,
    5, 6,
  ]);

  m.diagonalSet([ 11, 22 ]);
  test.identical( m, expected );

  var expected = matrix.make([ 3, 2 ]).copy
  ([
    0, 2,
    3, 0,
    5, 6,
  ]);

  m.diagonalSet( 0 );
  test.identical( m, expected );

  test.case = 'diagonalSet from another matrix'; /* */

  var m1 = matrix.make([ 3, 4 ]).copy
  ([
    1, 2, 3, 4,
    5, 6, 7, 8,
    9, 10, 11, 12,
  ]);

  var m2 = matrix.make([ 3, 3 ]).copy
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

  var expected = matrix.make([ 3, 4 ]).copy
  ([
    10, 2, 3, 4,
    5, 20, 7, 8,
    9, 10, 30, 12,
  ]);

  m1.diagonalSet( m2 );
  test.identical( m1, expected );

  var m1 = matrix.make([ 4, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
    10, 11, 12,
  ]);

  var m2 = matrix.make([ 3, 3 ]).copy
  ([
    +10, -1, -1,
    -1, +20, -1,
    -1, -1, +30,
  ]);

  var expected = matrix.make([ 4, 3 ]).copy
  ([
    10, 2, 3,
    4, 20, 6,
    7, 8, 30,
    10, 11, 12,
  ]);

  m1.diagonalSet( m2 );
  test.identical( m1, expected );

  test.case = 'diagonalSet 0x0'; /* */

  var m = matrix.make([ 0, 0 ]);
  var r = m.diagonalSet( 0 );
  test.identical( m.dims, [ 0, 0 ] );
  test.identical( m._stridesEffective, [ 1, 0 ] );
  test.is( m === r );

  var m = matrix.make([ 0, 0 ]);
  var r = m.diagonalSet( matrix.make([ 0, 3 ]) );
  test.identical( m.dims, [ 0, 0 ] );
  test.identical( m._stridesEffective, [ 1, 0 ] );
  test.is( m === r );

  var m = matrix.make([ 0, 0 ]);
  var r = m.diagonalSet( matrix.make([ 3, 0 ]) );
  test.identical( m.dims, [ 0, 0 ] );
  test.identical( m._stridesEffective, [ 1, 0 ] );
  test.is( m === r );

  test.case = 'diagonalSet bad arguments'; /* */

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => matrix.makeIdentity( 3 ).diagonalSet() );
    test.shouldThrowErrorSync( () => matrix.makeIdentity( 3 ).diagonalSet( [ 1, 1 ] ) );
    test.shouldThrowErrorSync( () => matrix.makeIdentity( 3 ).diagonalSet( matrix.makeIdentity( 2 ) ) );
  }

  test.case = 'identity 3x2'; /* */

  var m = matrix.makeZero([ 3, 2 ]);

  var expected = matrix.make([ 3, 2 ]).copy
  ([
    1, 0,
    0, 1,
    0, 0,
  ]);

  m.identity();
  test.identical( m, expected );

  test.case = 'identity 2x3'; /* */

  var m = matrix.makeZero([ 2, 3 ]);

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    1, 0, 0,
    0, 1, 0,
  ]);

  m.identity();
  test.identical( m, expected );

  test.case = 'identity 0x0'; /* */

  var m = matrix.makeZero([ 0, 3 ]);
  var r = m.identity();
  test.identical( m.dims, [ 0, 3 ] );
  test.identical( m._stridesEffective, [ 1, 0 ] );
  test.is( m === r );

  var m = matrix.makeZero([ 3, 0 ]);
  var r = m.identity();
  test.identical( m.dims, [ 3, 0 ] );
  test.identical( m._stridesEffective, [ 1, 3 ] );
  test.is( m === r );

  test.case = 'identity bad arguments'; /* */

  if( Config.debug )
  {
    test.shouldThrowErrorSync( () => matrix.makeIdentity( 3 ).identity( 1 ) );
    test.shouldThrowErrorSync( () => matrix.makeIdentity( 3 ).identity( [ 1, 1 ] ) );
  }

  test.case = 'triangleLowerSet 3x4'; /* */

  var expected = matrix.make([ 3, 4 ]).copy
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

  var m = matrix
  ({
    dims : [ 3, 4 ],
    inputTransposing : 1,
    offset : 1,
    buffer,
  });

  m.triangleLowerSet( 0 );
  test.identical( m, expected );

  var expected = matrix.make([ 3, 4 ]).copy
  ([
    1 , 2, 3, 4,
    10, 6, 7, 8,
    20, 30, 11, 12,
  ]);

  var m2 = matrix.make([ 3, 2 ]).copy
  ([
    -1, -1,
    +10, -1,
    +20, +30,
  ]);

  m.triangleLowerSet( m2 );
  test.identical( m, expected );

  test.case = 'triangleLowerSet 4x3'; /* */

  var expected = matrix.make([ 4, 3 ]).copy
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

  var m = matrix
  ({
    dims : [ 4, 3 ],
    inputTransposing : 1,
    offset : 1,
    buffer,
  });

  m.triangleLowerSet( 0 );
  test.identical( m, expected );

  var expected = matrix.make([ 4, 3 ]).copy
  ([
    1, 5, 9,
    10, 6, 10,
    20, 40, 11,
    30, 50, 60,
  ]);

  var m2 = matrix.make([ 4, 3 ]).copy
  ([
    -1, -1, -1,
    +10, -1, -1,
    +20, +40, -1,
    +30, +50, +60,
  ]);

  m.triangleLowerSet( m2 );
  test.identical( m, expected );

  test.case = 'triangleLowerSet 4x1'; /* */

  var buffer = new F32x
  ([
    -1,
    1,
    2,
    3,
    4,
    -1,
  ]);

  var m = matrix
  ({
    dims : [ 4, 1 ],
    inputTransposing : 1,
    offset : 1,
    buffer,
  });

  var expected = matrix.make([ 4, 1 ]).copy
  ([
    1,
    10,
    20,
    30,
  ]);

  var m2 = matrix.make([ 4, 1 ]).copy
  ([
    -1,
    +10,
    +20,
    +30,
  ]);

  m.triangleLowerSet( m2 );
  test.identical( m, expected );

  test.case = 'triangleLowerSet 1x4'; /* */

  var buffer = new F32x
  ([
    -1,
    1, 2, 3, 4,
    -1,
  ]);

  var m = matrix
  ({
    dims : [ 1, 4 ],
    inputTransposing : 1,
    offset : 1,
    buffer,
  });

  var expected = matrix.make([ 1, 4 ]).copy
  ([
    1, 2, 3, 4,
  ]);

  var m2 = matrix.make([ 1, 1 ]).copy
  ([
    -10,
  ]);

  m.triangleLowerSet( m2 );
  test.identical( m, expected );

  test.case = 'triangleLowerSet bad arguments'; /* */

  if( Config.debug )
  {

    test.shouldThrowErrorSync( () => matrix.make([ 3, 4 ]).triangleLowerSet( matrix.make([ 2, 4 ]) ) );
    test.shouldThrowErrorSync( () => matrix.make([ 3, 4 ]).triangleLowerSet( matrix.make([ 3, 1 ]) ) );
    test.shouldThrowErrorSync( () => matrix.make([ 4, 3 ]).triangleLowerSet( matrix.make([ 3, 3 ]) ) );
    test.shouldThrowErrorSync( () => matrix.make([ 4, 3 ]).triangleLowerSet( matrix.make([ 4, 2 ]) ) );

    test.shouldThrowErrorSync( () => matrix.make([ 3, 0 ]).triangleLowerSet( matrix.make([ 0, 0 ]) ) );
    test.shouldThrowErrorSync( () => matrix.make([ 3, 0 ]).triangleLowerSet( matrix.make([ 2, 0 ]) ) );
    test.shouldThrowErrorSync( () => matrix.make([ 3, 0 ]).triangleLowerSet( matrix.make([ 0, 3 ]) ) );
    test.shouldThrowErrorSync( () => matrix.make([ 3, 0 ]).triangleLowerSet( matrix.make([ 0, 4 ]) ) );

  }

  test.case = 'triangleUpperSet 4x3'; /* */

  var expected = matrix.make([ 4, 3 ]).copy
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

  var m = matrix
  ({
    dims : [ 4, 3 ],
    inputTransposing : 1,
    offset : 1,
    buffer,
  });

  m.triangleUpperSet( 0 );
  test.identical( m, expected );

  var expected = matrix.make([ 4, 3 ]).copy
  ([
    1, 10, 20,
    2, 6, 30,
    3, 7, 11,
    4, 8, 12,
  ]);

  var m2 = matrix.make([ 2, 3 ]).copy
  ([
    -1, +10, +20,
    -1, -1, +30,
  ]);

  m.triangleUpperSet( m2 );
  test.identical( m, expected );

  test.case = 'triangleUpperSet 3x4'; /* */

  var expected = matrix.make([ 3, 4 ]).copy
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

  var m = matrix
  ({
    dims : [ 3, 4 ],
    inputTransposing : 1,
    offset : 1,
    buffer,
  });

  m.triangleUpperSet( 0 );
  test.identical( m, expected );

  var m2 = matrix.make([ 3, 4 ]).copy
  ([
    -1, 10, 20, 30,
    -1, -1, 40, 50,
    -1, -1, -1, 60,
  ]);

  var expected = matrix.make([ 3, 4 ]).copy
  ([
    1, 10, 20, 30,
    5, 6, 40, 50,
    9, 10, 11, 60,
  ]);

  m.triangleUpperSet( m2 );
  test.identical( m, expected );

  test.case = 'triangleUpperSet 1x4'; /* */

  var buffer = new F32x
  ([
    -1,
    1, 2, 3, 4,
    -1,
  ]);

  var m = matrix
  ({
    dims : [ 1, 4 ],
    inputTransposing : 1,
    offset : 1,
    buffer,
  });

  var m2 = matrix.make([ 1, 4 ]).copy
  ([
    -1, 10, 20, 30,
  ]);

  var expected = matrix.make([ 1, 4 ]).copy
  ([
    1, 10, 20, 30,
  ]);

  m.triangleUpperSet( m2 );
  test.identical( m, expected );

  test.case = 'triangleUpperSet 4x1'; /* */

  var buffer = new F32x
  ([
    -1,
    1,
    2,
    3,
    4,
    -1,
  ]);

  var m = matrix
  ({
    dims : [ 4, 1 ],
    inputTransposing : 1,
    offset : 1,
    buffer,
  });

  var m2 = matrix.make([ 1, 1 ]).copy
  ([
    -1,
  ]);

  var expected = matrix.make([ 4, 1 ]).copy
  ([
    1,
    2,
    3,
    4,
  ]);

  m.triangleUpperSet( m2 );
  test.identical( m, expected );

  test.case = 'triangleUpperSet bad arguments'; /* */

  if( Config.debug )
  {

    test.shouldThrowErrorSync( () => matrix.make([ 4, 3 ]).triangleUpperSet( matrix.make([ 4, 2 ]) ) );
    test.shouldThrowErrorSync( () => matrix.make([ 4, 3 ]).triangleUpperSet( matrix.make([ 1, 3 ]) ) );
    test.shouldThrowErrorSync( () => matrix.make([ 3, 4 ]).triangleUpperSet( matrix.make([ 3, 3 ]) ) );
    test.shouldThrowErrorSync( () => matrix.make([ 3, 4 ]).triangleUpperSet( matrix.make([ 2, 4 ]) ) );

    test.shouldThrowErrorSync( () => matrix.make([ 0, 3 ]).triangleUpperSet( matrix.make([ 0, 0 ]) ) );
    test.shouldThrowErrorSync( () => matrix.make([ 0, 3 ]).triangleUpperSet( matrix.make([ 0, 2 ]) ) );
    test.shouldThrowErrorSync( () => matrix.make([ 0, 3 ]).triangleUpperSet( matrix.make([ 3, 0 ]) ) );
    test.shouldThrowErrorSync( () => matrix.make([ 0, 3 ]).triangleUpperSet( matrix.make([ 4, 0 ]) ) );

  }

  test.case = 'triangleSet null matrix'; /* */

  function triangleSetNull( rname )
  {

    test.case = rname + ' null matrix by scalar'; /* */

    var m = matrix.make([ 0, 3 ]);
    var expected = matrix.make([ 0, 0 ]);
    var r = m[ rname ]( 0 );
    test.identical( m.dims, [ 0, 3 ] );
    test.is( m === r );

    var m = matrix.make([ 3, 0 ]);
    var expected = matrix.make([ 0, 0 ]);
    var r = m[ rname ]( 0 );
    test.identical( m.dims, [ 3, 0 ] );
    test.is( m === r );

    test.case = rname + ' null matrix by null matrix'; /* */

    var m = matrix.make([ 0, 0 ]);
    var expected = matrix.make([ 0, 0 ]);
    var r = m[ rname ]( matrix.make([ 0, 0 ]) );
    test.is( m === r );

    var m = matrix.make([ 0, 0 ]);
    var expected = matrix.make([ 0, 0 ]);
    var r = m[ rname ]( matrix.make([ 0, 3 ]) );
    test.is( m === r );

    var m = matrix.make([ 0, 0 ]);
    var expected = matrix.make([ 0, 0 ]);
    var r = m[ rname ]( matrix.make([ 3, 0 ]) );
    test.is( m === r );

    /* */

    if( rname !== 'triangleUpperSet' )
    {

      var m = matrix.make([ 0, 3 ]);
      var expected = matrix.make([ 0, 0 ]);
      var r = m[ rname ]( matrix.make([ 0, 0 ]) );
      test.is( m === r );

      var m = matrix.make([ 0, 3 ]);
      var expected = matrix.make([ 0, 0 ]);
      var r = m[ rname ]( matrix.make([ 3, 0 ]) );
      test.is( m === r );

    }

    var m = matrix.make([ 0, 3 ]);
    var expected = matrix.make([ 0, 0 ]);
    var r = m[ rname ]( matrix.make([ 0, 3 ]) );
    test.is( m === r );

    /* */

    if( rname !== 'triangleLowerSet' )
    {
      var m = matrix.make([ 3, 0 ]);
      var expected = matrix.make([ 0, 0 ]);
      var r = m[ rname ]( matrix.make([ 0, 0 ]) );
      test.is( m === r );

      var m = matrix.make([ 3, 0 ]);
      var expected = matrix.make([ 0, 0 ]);
      var r = m[ rname ]( matrix.make([ 0, 3 ]) );
      test.is( m === r );
    }

    var m = matrix.make([ 3, 0 ]);
    var expected = matrix.make([ 0, 0 ]);
    var r = m[ rname ]( matrix.make([ 3, 0 ]) );
    test.is( m === r );

  }

  triangleSetNull( 'triangleLowerSet' );
  triangleSetNull( 'triangleUpperSet' );

  test.case = 'bad arguments'; /* */

  function shouldThrowErrorOfAnyKind( name )
  {

    test.shouldThrowErrorSync( () => matrix.makeIdentity( 3 )[ name ]( 1, 1 ) );
    test.shouldThrowErrorSync( () => matrix.makeIdentity( 3 )[ name ]( '1' ) );
    test.shouldThrowErrorSync( () => matrix.makeIdentity( 3 )[ name ]( undefined ) );
    test.shouldThrowErrorSync( () => matrix.makeIdentity( 3 )[ name ]( '1', '3' ) );
    test.shouldThrowErrorSync( () => matrix.makeIdentity( 3 )[ name ]( [], [] ) );

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

  test.case = 'rowsSwap'; /* */

  var m = matrix.make([ 4, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
    11, 22, 33,
  ]);

  var expected = matrix.make([ 4, 3 ]).copy
  ([
    1, 2, 3,
    7, 8, 9,
    4, 5, 6,
    11, 22, 33,
  ]);

  m.rowsSwap( 3, 0 ).rowsSwap( 0, 3 ).rowsSwap( 1, 2 ).rowsSwap( 0, 0 );
  test.identical( m, expected );

  test.case = 'rowsSwap row with itself'; /* */

  m.rowsSwap( 0, 0 );
  test.identical( m, expected );

  test.case = 'linesSwap'; /* */

  var m = matrix.make([ 4, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
    7, 8, 9,
    11, 22, 33,
  ]);

  var expected = matrix.make([ 4, 3 ]).copy
  ([
    1, 2, 3,
    7, 8, 9,
    4, 5, 6,
    11, 22, 33,
  ]);

  m.linesSwap( 0, 3, 0 ).linesSwap( 0, 0, 3 ).linesSwap( 0, 1, 2 ).linesSwap( 0, 0, 0 );
  test.identical( m, expected );

  test.case = 'linesSwap row with itself'; /* */

  m.linesSwap( 0, 0, 0 );
  test.identical( m, expected );

  test.case = 'colsSwap'; /* */

  var m = matrix.make([ 3, 4 ]).copy
  ([
    1, 2, 3, 4,
    5, 6, 7, 8,
    9, 10, 11, 12,
  ]);

  var expected = matrix.make([ 3, 4 ]).copy
  ([
    1, 3, 2, 4,
    5, 7, 6, 8,
    9, 11, 10, 12,
  ]);

  m.colsSwap( 0, 3 ).colsSwap( 3, 0 ).colsSwap( 1, 2 ).colsSwap( 0, 0 );
  test.identical( m, expected );

  test.case = 'colsSwap row with itself'; /* */

  m.colsSwap( 0, 0 );
  test.identical( m, expected );

  test.case = 'linesSwap'; /* */

  var m = matrix.make([ 3, 4 ]).copy
  ([
    1, 2, 3, 4,
    5, 6, 7, 8,
    9, 10, 11, 12,
  ]);

  var expected = matrix.make([ 3, 4 ]).copy
  ([
    1, 3, 2, 4,
    5, 7, 6, 8,
    9, 11, 10, 12,
  ]);

  m.linesSwap( 1, 0, 3 ).linesSwap( 1, 3, 0 ).linesSwap( 1, 1, 2 ).linesSwap( 0, 0, 0 );
  test.identical( m, expected );

  test.case = 'linesSwap row with itself'; /* */

  m.linesSwap( 1, 0, 0 );
  test.identical( m, expected );

  test.case = 'elementsSwap'; /* */

  var m = matrix.make([ 3, 4 ]).copy
  ([
    1, 2, 3, 4,
    5, 6, 7, 8,
    9, 10, 11, 12,
  ]);

  var expected = matrix.make([ 3, 4 ]).copy
  ([
    1, 3, 2, 4,
    5, 7, 6, 8,
    9, 11, 10, 12,
  ]);

  m.elementsSwap( 0, 3 ).elementsSwap( 3, 0 ).elementsSwap( 1, 2 ).elementsSwap( 0, 0 );
  test.identical( m, expected );

  test.case = 'elementsSwap row with itself'; /* */

  m.elementsSwap( 0, 0 );
  test.identical( m, expected );

  test.case = 'bad arguments'; /* */

  if( !Config.debug )
  return;

  function shouldThrowErrorOfAnyKind( rname, dims )
  {
    matrix.make( dims )[ rname ]( 0, 0 );
    test.shouldThrowErrorSync( () => matrix.make( dims )[ rname ]( -1, -1 ) );
    test.shouldThrowErrorSync( () => matrix.make( dims )[ rname ]( 4, 4 ) );
    test.shouldThrowErrorSync( () => matrix.make( dims )[ rname ]( 0, -1 ) );
    test.shouldThrowErrorSync( () => matrix.make( dims )[ rname ]( 0, 4 ) );
    test.shouldThrowErrorSync( () => matrix.make( dims )[ rname ]() );
    test.shouldThrowErrorSync( () => matrix.make( dims )[ rname ]( 1 ) );
    test.shouldThrowErrorSync( () => matrix.make( dims )[ rname ]( 1, 2, 3 ) );
  }

  shouldThrowErrorOfAnyKind( 'rowsSwap', [ 4, 3 ] );
  shouldThrowErrorOfAnyKind( 'colsSwap', [ 3, 4 ] );
  shouldThrowErrorOfAnyKind( 'elementsSwap', [ 3, 4 ] );

}

//

function pivot( test )
{

  test.case = 'simple row pivot'; /* */

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    4, 5, 6,
    1, 2, 3,
  ]);

  var m = matrix.make([ 2, 3 ]).copy
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

  test.case = 'complex row pivot'; /* */

  var expected = matrix.make([ 3, 2 ]).copy
  ([
    5, 6,
    1, 2,
    3, 4,
  ]);

  var m = matrix.make([ 3, 2 ]).copy
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

  test.case = 'vectorPivot matrix'; /* */

  var expected = matrix.make([ 3, 2 ]).copy
  ([
    5, 6,
    1, 2,
    3, 4,
  ]);

  var m = matrix.make([ 3, 2 ]).copy
  ([
    1, 2,
    3, 4,
    5, 6,
  ]);

  var original = m.clone();

  var pivot = [ 2, 0, 1 ];
  var pivotExpected = [ 2, 0, 1 ];

  matrix.VectorPivotForward( m, pivot );
  test.identical( m, expected );
  test.identical( pivot, pivotExpected );

  matrix.VectorPivotBackward( m, pivot );
  test.identical( m, original );
  test.identical( pivot, pivotExpected );

  test.case = 'vectorPivot vector'; /* */

  var expected = vec([ 3, 1, 2 ]);
  var a = vec([ 1, 2, 3 ]);
  var original = a.clone();

  var pivot = [ 2, 0, 1 ];
  var pivotExpected = [ 2, 0, 1 ];

  matrix.VectorPivotForward( a, pivot );
  test.identical( a, expected );
  test.identical( pivot, pivotExpected );

  matrix.VectorPivotBackward( a, pivot );
  test.identical( a, original );
  test.identical( pivot, pivotExpected );

  test.case = 'vectorPivot array'; /* */

  var expected = [ 3, 1, 2 ];
  var a = [ 1, 2, 3 ];
  var original = a.slice();

  var pivot = [ 2, 0, 1 ];
  var pivotExpected = [ 2, 0, 1 ];

  matrix.VectorPivotForward( a, pivot );
  test.identical( a, expected );
  test.identical( pivot, pivotExpected );

  matrix.VectorPivotBackward( a, pivot );
  test.identical( a, original );
  test.identical( pivot, pivotExpected );

  test.case = 'no pivots'; /* */

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  var m = matrix.make([ 2, 3 ]).copy
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

  test.case = 'complex col pivot'; /* */

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    3, 1, 2,
    6, 4, 5,
  ]);

  var m = matrix.make([ 2, 3 ]).copy
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

  test.case = 'complex col pivot'; /* */

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    3, 2, 1,
    6, 5, 4,
  ]);

  var m = matrix.make([ 2, 3 ]).copy
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

  test.case = 'complex col pivot'; /* */

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    2, 3, 1,
    5, 6, 4,
  ]);

  var m = matrix.make([ 2, 3 ]).copy
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

  test.case = 'mixed pivot'; /* */

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    5, 6, 4,
    2, 3, 1,
  ]);

  var m = matrix.make([ 2, 3 ]).copy
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

  test.case = 'partially defined pivot'; /* */

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    4, 5, 6,
    1, 2, 3,
  ]);

  var m = matrix.make([ 2, 3 ]).copy
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

function _submatrix( o )
{

  var test = o.test;
  var m;
  function make()
  {

    var b = new F32x
    ([
      +1, +2, +3, +4,
      +5, +6, +7, +8,
      +9, +10, +11, +12,
    ]);
    if( !o.transposing )
    b = new F32x
    ([
      +1, +5, +9,
      +2, +6, +10,
      +3, +7, +11,
      +4, +8, +12,
    ]);

    var m = makeWithOffset
    ({
      buffer : b,
      dims : o.dims,
      offset : o.offset,
      inputTransposing : o.transposing,
    })

    return m;
  }

  var expected = matrix.make([ 3, 4 ]).copy
  ([
    +1, +2, +3, +4,
    +5, +6, +7, +8,
    +9, +10, +11, +12,
  ]);

  var m = make();
  test.identical( m, expected )
  test.identical( m.offset, o.offset );

  test.case = 'simple submatrix'; /* */

  var m = make();
  var c1 = m.submatrix([ _.all, 0 ]);
  var c2 = m.submatrix([ _.all, 3 ]);
  var r1 = m.submatrix([ 0, _.all ]);
  var r2 = m.submatrix([ 2, _.all ]);

  var expected = matrix.makeCol([ 1, 5, 9 ]);
  test.identical( c1, expected );

  var expected = matrix.makeCol([ 4, 8, 12 ]);
  test.identical( c2, expected );

  var expected = matrix.makeRow([ 1, 2, 3, 4 ]);
  test.identical( r1, expected );

  var expected = matrix.makeRow([ 9, 10, 11, 12 ]);
  test.identical( r2, expected );

  test.case = 'modify submatrixs'; /* */

  var expected = matrix.make([ 3, 4 ]).copy
  ([
    +11, +3, +4, +401,
    +50, +6, +7, +800,
    +93, +13, +14, +1203,
  ]);

  c1.mul( 10 );
  c2.mul( 100 );
  r1.add( 1 );
  r2.add( 3 );

  // c1.mulScalar( 10 );
  // c2.mulScalar( 100 );
  // r1.addScalar( 1 );
  // r2.addScalar( 3 );

  test.identical( m, expected );

  test.case = 'submatrix several columns'; /* */

  var m = make();
  var expected = matrix.make([ 3, 2 ]).copy
  ([
    +2, +3,
    +6, +7,
    +10, +11,
  ]);

  var sub = m.submatrix([ _.all, [ 1, 3 ] ]);
  test.identical( sub, expected );

    test.case = 'modify submatrixs'; /* */

  var expected = matrix.make([ 3, 4 ]).copy
  ([
    +1, +20, +30, +4,
    +5, +60, +70, +8,
    +9, +100, +110, +12,
  ]);

  sub.mul( 10 );
  test.identical( m, expected );

  test.case = 'submatrix several columns'; /* */

  var m = make();
  var expected = matrix.make([ 3, 2 ]).copy
  ([
    +3, +4,
    +7, +8,
    +11, +12,
  ]);

  var sub = m.submatrix([ _.all, [ 2, 4 ] ]);
  test.identical( sub, expected );

    test.case = 'modify submatrixs'; /* */

  var expected = matrix.make([ 3, 4 ]).copy
  ([
    +1, +2, +30, +40,
    +5, +6, +70, +80,
    +9, +10, +110, +120,
  ]);

  sub.mul( 10 );
  test.identical( m, expected );

  test.case = 'submatrix several rows'; /* */

  var m = make();
  var expected = matrix.make([ 2, 4 ]).copy
  ([
    +1, +2, +3, +4,
    +5, +6, +7, +8,
  ]);

  var sub = m.submatrix([ [ 0, 2 ], _.all ]);
  test.identical( sub, expected );

  test.case = 'modify submatrixs'; /* */

  var expected = matrix.make([ 3, 4 ]).copy
  ([
    +10, +20, +30, +40,
    +50, +60, +70, +80,
    +9, +10, +11, +12,
  ]);

  sub.mul( 10 );
  test.identical( m, expected );

  test.case = 'submatrix several rows'; /* */

  var m = make();
  var expected = matrix.make([ 2, 4 ]).copy
  ([
    +5, +6, +7, +8,
    +9, +10, +11, +12,
  ]);

  var sub = m.submatrix([ [ 1, 3 ], _.all ]);
  test.identical( sub, expected );

  test.case = 'modify submatrix'; /* */

  var expected = matrix.make([ 3, 4 ]).copy
  ([
    +1, +2, +3, +4,
    +50, +60, +70, +80,
    +90, +100, +110, +120,
  ]);

  sub.mul( 10 );
  test.identical( m, expected );

  test.case = 'complex submatrix'; /* */

  var m = make();
  var expected = matrix.make([ 2, 2 ]).copy
  ([
    +1, +2,
    +5, +6,
  ]);

  var sub = m.submatrix([ [ 0, 2 ], [ 0, 2 ] ]);
  test.identical( sub, expected );

  test.case = 'modify complex submatrix'; /* */

  var expected = matrix.make([ 3, 4 ]).copy
  ([
    +10, +20, +3, +4,
    +50, +60, +7, +8,
    +9, +10, +11, +12,
  ]);

  sub.mul( 10 );
  test.identical( m, expected );

  test.case = 'complex submatrix'; /* */

  var m = make();
  var expected = matrix.make([ 2, 2 ]).copy
  ([
    +7, +8,
    +11, +12,
  ]);

  var sub = m.submatrix([ [ 2, 4 ], [ 1, 3 ] ]);
  test.identical( sub, expected );

  test.case = 'modify complex submatrix'; /* */

  var expected = matrix.make([ 3, 4 ]).copy
  ([
    +1, +2, +3, +4,
    +5, +6, +70, +80,
    +9, +10, +110, +120,
  ]);

  sub.mul( 10 );
  test.identical( m, expected );

}

//

function submatrix( test )
{

  var o = Object.create( null );
  o.test = test;

  o.offset = 0;
  o.transposing = 0;
  this._submatrix( o )

  o.offset = 0;
  o.transposing = 1;
  this._submatrix( o )

  o.offset = 10;
  o.transposing = 0;
  this._submatrix( o )

  o.offset = 10;
  o.transposing = 1;
  this._submatrix( o )

}

// --
// etc
// --

function addAtomWise( test )
{

  var m1, m2, m3, m4, m5, v1, a1;
  function remake()
  {

    m1 = matrix.make([ 2, 3 ]).copy
    ([
      +1, +2, +3,
      +4, +5, +6,
    ]);

    m2 = matrix.make([ 2, 3 ]).copy
    ([
      +10, +20, +30,
      +40, +50, +60,
    ]);

    m3 = matrix.make([ 2, 3 ]).copy
    ([
      +100, +200, +300,
      +400, +500, +600,
    ]);

    m4 = matrix.make([ 2, 1 ]).copy
    ([
      1,
      2,
    ]);

    m5 = matrix.make([ 2, 1 ]).copy
    ([
      3,
      4,
    ]);

    v1 = vad.fromLong([ 9, 8 ]);
    a1 = [ 6, 5 ];

  }

  test.case = 'addAtomWise 2 matrixs'; /* */

  remake();

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    +11, +22, +33,
    +44, +55, +66,
  ]);

  var r = matrix.addAtomWise( m1, m2 );
  test.equivalent( r, expected );
  test.is( r === m1 );

  test.case = 'addAtomWise 2 matrixs with null'; /* */

  remake();

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    +11, +22, +33,
    +44, +55, +66,
  ]);

  var r = matrix.addAtomWise( null, m1, m2 );
  test.equivalent( r, expected );
  test.is( r !== m1 );

  test.case = 'addAtomWise 3 matrixs into the first src'; /* */

  remake();

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    +111, +222, +333,
    +444, +555, +666,
  ]);

  var r = matrix.addAtomWise( null, m1, m2, m3 );
  test.equivalent( r, expected );
  test.is( r !== m1 );

  test.case = 'addAtomWise 3 matrixs into the first src'; /* */

  remake();

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    +111, +222, +333,
    +444, +555, +666,
  ]);

  var r = matrix.addAtomWise( m1, m2, m3 );
  test.equivalent( r, expected );
  test.is( r === m1 );

  test.case = 'addAtomWise matrix and scalar'; /* */

  remake();

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    +11, +12, +13,
    +14, +15, +16,
  ]);

  var r = matrix.addAtomWise( null, m1, 10 );
  test.equivalent( r, expected );
  test.is( r !== m1 );

  test.case = 'addAtomWise _.all sort of arguments'; /* */

  remake();

  var expected = matrix.make([ 2, 1 ]).copy
  ([
    13,
    14,
  ]);

  var r = matrix.addAtomWise( null, m5, 10 );
  test.equivalent( r, expected );
  test.is( r !== m5 );

  var expected = matrix.make([ 2, 1 ]).copy
  ([
    22,
    22,
  ]);

  var r = matrix.addAtomWise( null, m5, 10, v1 );
  test.equivalent( r, expected );
  test.is( r !== m5 );

  var expected = matrix.make([ 2, 1 ]).copy
  ([
    28,
    27,
  ]);

  var r = matrix.addAtomWise( null, m5, 10, v1, a1 );
  test.equivalent( r, expected );
  test.is( r !== m5 );

  test.case = 'addAtomWise _.all sort of arguments'; /* */

  remake();

  var expected = matrix.make([ 2, 1 ]).copy
  ([
    22,
    22,
  ]);

  var r = matrix.addAtomWise( m5, 10, v1 );
  test.equivalent( r, expected );
  test.is( r === m5 );

  remake();

  var expected = matrix.make([ 2, 1 ]).copy
  ([
    28,
    27,
  ]);

  var r = matrix.addAtomWise( m5, 10, v1, a1 );
  test.equivalent( r, expected );
  test.is( r === m5 );

  remake();

  var expected = matrix.make([ 2, 1 ]).copy
  ([
    29,
    29,
  ]);

  var r = matrix.addAtomWise( m5, 10, v1, a1, m4 );
  test.equivalent( r, expected );
  test.is( r === m5 );

  test.case = 'addAtomWise rewriting src argument'; /* */

  remake();

  var expected = matrix.make([ 2, 1 ]).copy
  ([
    27,
    27,
  ]);

  var r = matrix.addAtomWise( m4, 10, v1, a1, m4 );
  test.equivalent( r, expected );
  test.is( r === m4 );

}

//

function subAtomWise( test )
{

  var m1, m2, m3, m4, m5, v1, a1;
  function remake()
  {

    m1 = matrix.make([ 2, 3 ]).copy
    ([
      +1, +2, +3,
      +4, +5, +6,
    ]);

    m2 = matrix.make([ 2, 3 ]).copy
    ([
      +10, +20, +30,
      +40, +50, +60,
    ]);

    m3 = matrix.make([ 2, 3 ]).copy
    ([
      +100, +200, +300,
      +400, +500, +600,
    ]);

    m4 = matrix.make([ 2, 1 ]).copy
    ([
      1,
      2,
    ]);

    m5 = matrix.make([ 2, 1 ]).copy
    ([
      3,
      4,
    ]);

    v1 = vad.fromLong([ 9, 8 ]);
    a1 = [ 6, 5 ];

  }

  test.case = '2 matrixs'; /* */

  remake();

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    -9, -18, -27,
    -36, -45, -54,
  ]);

  var r = matrix.subAtomWise( m1, m2 );
  test.equivalent( r, expected );
  test.is( r === m1 );

  test.case = '2 matrixs with null'; /* */

  remake();

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    -9, -18, -27,
    -36, -45, -54,
  ]);

  var r = matrix.subAtomWise( null, m1, m2 );
  test.equivalent( r, expected );
  test.is( r !== m1 );

  test.case = '3 matrixs into the first src'; /* */

  remake();

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    -109, -218, -327,
    -436, -545, -654,
  ]);

  var r = matrix.subAtomWise( null, m1, m2, m3 );
  test.equivalent( r, expected );
  test.is( r !== m1 );

  test.case = '3 matrixs into the first src'; /* */

  remake();

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    -109, -218, -327,
    -436, -545, -654,
  ]);

  var r = matrix.subAtomWise( m1, m2, m3 );
  test.equivalent( r, expected );
  test.is( r === m1 );

  test.case = 'matrix and scalar'; /* */

  remake();

  var expected = matrix.make([ 2, 3 ]).copy
  ([
    -9, -8, -7,
    -6, -5, -4,
  ]);

  var r = matrix.subAtomWise( null, m1, 10 );
  test.equivalent( r, expected );
  test.is( r !== m1 );

  test.case = '_.all sort of arguments'; /* */

  remake();

  var expected = matrix.make([ 2, 1 ]).copy
  ([
    -7,
    -6,
  ]);

  var r = matrix.subAtomWise( null, m5, 10 );
  test.equivalent( r, expected );
  test.is( r !== m5 );

  var expected = matrix.make([ 2, 1 ]).copy
  ([
    -16,
    -14,
  ]);

  var r = matrix.subAtomWise( null, m5, 10, v1 );
  test.equivalent( r, expected );
  test.is( r !== m5 );

  var expected = matrix.make([ 2, 1 ]).copy
  ([
    -22,
    -19,
  ]);

  var r = matrix.subAtomWise( null, m5, 10, v1, a1 );
  test.equivalent( r, expected );
  test.is( r !== m5 );

  test.case = '_.all sort of arguments'; /* */

  remake();

  var expected = matrix.make([ 2, 1 ]).copy
  ([
    -16,
    -14,
  ]);

  var r = matrix.subAtomWise( m5, 10, v1 );
  test.equivalent( r, expected );
  test.is( r === m5 );

  remake();

  var expected = matrix.make([ 2, 1 ]).copy
  ([
    -22,
    -19,
  ]);

  var r = matrix.subAtomWise( m5, 10, v1, a1 );
  test.equivalent( r, expected );
  test.is( r === m5 );

  remake();

  var expected = matrix.make([ 2, 1 ]).copy
  ([
    -23,
    -21,
  ]);

  var r = matrix.subAtomWise( m5, 10, v1, a1, m4 );
  test.equivalent( r, expected );
  test.is( r === m5 );

  test.case = 'rewriting src argument'; /* */

  remake();

  var expected = matrix.make([ 2, 1 ]).copy
  ([
    -25,
    -23,
  ]);

  var r = matrix.subAtomWise( m4, 10, v1, a1, m4 );
  test.equivalent( r, expected );
  test.is( r === m4 );

}

//

// function homogeneousWithScalarRoutines( test )
// {
//
//   function make()
//   {
//     var m = matrix.make([ 3, 2 ]).copy
//     ([
//       +1, +2,
//       +3, +4,
//       +5, +6,
//     ]);
//     return m;
//   }
//
//   test.case = 'assignScalar'; /* */
//
//   var m = make();
//   var expected = matrix.make([ 3, 2 ]).copy
//   ([
//     +5, +5,
//     +5, +5,
//     +5, +5,
//   ]);
//
//   // m.assignScalar( 5 );
//   m.assign( 5 );
//   test.identical( m, expected );
//
//   test.case = 'addScalar'; /* */
//
//   var m = make();
//   var expected = matrix.make([ 3, 2 ]).copy
//   ([
//     +6, +7,
//     +8, +9,
//     +10, +11,
//   ]);
//
//   m.addScalar( 5 );
//   test.identical( m, expected );
//
//   test.case = 'subScalar'; /* */
//
//   var m = make();
//   var expected = matrix.make([ 3, 2 ]).copy
//   ([
//     -4, -3,
//     -2, -1,
//     +0, +1,
//   ]);
//
//   m.subScalar( 5 );
//   test.identical( m, expected );
//
//   test.case = 'mulScalar'; /* */
//
//   var m = make();
//   var expected = matrix.make([ 3, 2 ]).copy
//   ([
//     +5, +10,
//     +15, +20,
//     +25, +30,
//   ]);
//
//   m.mulScalar( 5 );
//   test.identical( m, expected );
//
//   test.case = 'divScalar'; /* */
//
//   var m = make();
//   var expected = matrix.make([ 3, 2 ]).copy
//   ([
//     +1/5, +2/5,
//     +3/5, +4/5,
//     +5/5, +6/5,
//   ]);
//
//   m.divScalar( 5 );
//   test.identical( m, expected );
//
//   test.case = 'bad arguments'; /* */
//
//   function shouldThrowErrorOfAnyKind( name )
//   {
//
//     test.shouldThrowErrorSync( () => make()[ name ]() );
//     test.shouldThrowErrorSync( () => make()[ name ]( '1' ) );
//     test.shouldThrowErrorSync( () => make()[ name ]( undefined ) );
//     test.shouldThrowErrorSync( () => make()[ name ]( 1, 3 ) );
//     test.shouldThrowErrorSync( () => make()[ name ]( '1', '3' ) );
//     test.shouldThrowErrorSync( () => make()[ name ]( [], [] ) );
//     test.shouldThrowErrorSync( () => make()[ name ]( [], 1, 3 ) );
//     test.shouldThrowErrorSync( () => make()[ name ]( [], 1, undefined ) );
//     test.shouldThrowErrorSync( () => make()[ name ]( [], undefined ) );
//
//   }
//
//   // if( Config.debug )
//   // {
//   //   shouldThrowErrorOfAnyKind( 'assignScalar' );
//   //   shouldThrowErrorOfAnyKind( 'addScalar' );
//   //   shouldThrowErrorOfAnyKind( 'subScalar' );
//   //   shouldThrowErrorOfAnyKind( 'mulScalar' );
//   //   shouldThrowErrorOfAnyKind( 'divScalar' );
//   // }
//
// }

//

function colRowWiseOperations( test )
{

  test.case = 'data'; /* */

  var buffer = new I32x
  ([
    1, 2, 3, 4, 5, 6
  ]);

  var m32 = new matrix
  ({
    buffer,
    dims : [ 3, 2 ],
    inputTransposing : 0,
  });

  var empty1 = matrix.make([ 2, 0 ]);
  empty1.buffer = new F64x();
  test.identical( empty1.dims, [ 2, 0 ] );
  test.identical( empty1._stridesEffective, [ 1, 2 ] );

  var empty2 = matrix.make([ 0, 2 ]);
  test.identical( empty2.dims, [ 0, 2 ] );
  test.identical( empty2._stridesEffective, [ 1, 0 ] );
  empty2.growingDimension = 0;
  empty2.buffer = new F64x();
  test.identical( empty2.dims, [ 0, 2 ] );
  test.identical( empty2._stridesEffective, [ 1, 0 ] );

  var matrix1 = new matrix
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

  var matrix2 = new matrix
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

  test.case = 'reduceToMean'; /* */

  var c = m32.reduceToMeanRowWise();
  var r = m32.reduceToMeanColWise();
  var a = m32.reduceToMeanAtomWise();

  test.identical( c, vec([ 2.5, 3.5, 4.5 ]) );
  test.identical( r, vec([ 2, 5 ]) );
  test.identical( a, 3.5 );

  test.case = 'reduceToMean with output argument'; /* */

  var c2 = [ 1, 1, 1 ];
  var r2 = [ 1 ];
  m32.reduceToMeanRowWise( c2 );
  m32.reduceToMeanColWise( r2 );

  test.identical( c, vec( c2 ) );
  test.identical( r, vec( r2 ) );

  test.case = 'reduceToMean with empty matrixs'; /* */

  var c = empty1.reduceToMeanRowWise();
  var r = empty1.reduceToMeanColWise();
  var a = empty1.reduceToMeanAtomWise();

  test.identical( c, vec([ NaN, NaN ]) );
  test.identical( r, vec([]) );
  test.identical( a, NaN );

  test.case = 'reduceToMean bad arguments'; /* */

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

  test.case = 'distributionRangeSummaryColWise'; /* */

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

  test.case = 'minmaxColWise'; /* */

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

  test.case = 'distributionRangeSummaryRowWise'; /* */

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

  test.case = 'minmaxRowWise'; /* */

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

  test.case = 'reduceToSumColWise'; /* */

  var sum = matrix1.reduceToSumColWise();
  test.identical( sum, vec([ 12, 133, 44 ]) );
  var sum = matrix2.reduceToSumColWise();
  test.identical( sum, vec([ 16, 32, 53 ]) );
  var sum = empty1.reduceToSumColWise();
  test.identical( sum, vec([]) );
  var sum = empty2.reduceToSumColWise();
  test.identical( sum, vec([ 0, 0 ]) );

  test.case = 'reduceToSumRowWise'; /* */

  var sum = matrix1.reduceToSumRowWise();
  test.identical( sum, vec([ 0, 6, 60, 123 ]) );
  var sum = matrix2.reduceToSumRowWise();
  test.identical( sum, vec([ 13, 21, 32, 35 ]) );
  var sum = empty1.reduceToSumRowWise();
  test.identical( sum, vec([ 0, 0 ]) );
  var sum = empty2.reduceToSumRowWise();
  test.identical( sum, vec([]) );

  test.case = 'reduceToMaxColWise'; /* */

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

  test.case = 'reduceToMaxValueColWise'; /* */

  var max = matrix1.reduceToMaxValueColWise();
  test.identical( max, vec([ 10, 111, 30 ]) );
  var max = matrix2.reduceToMaxValueColWise();
  test.identical( max, vec([ 10, 20, 30 ]) );
  var max = empty1.reduceToMaxValueColWise();
  test.identical( max, vec([]) );
  var max = empty2.reduceToMaxValueColWise();
  test.identical( max, vec([ -Infinity, -Infinity ]) );

  test.case = 'reduceToMaxRowWise'; /* */

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

  test.case = 'reduceToMaxValueRowWise'; /* */

  var max = matrix1.reduceToMaxValueRowWise();
  test.identical( max, vec([ 0, 3, 30, 111 ]) );
  var max = matrix2.reduceToMaxValueRowWise();
  test.identical( max, vec([ 10, 20, 30, 20 ]) );
  var max = empty1.reduceToMaxValueRowWise();
  test.identical( max, vec([ -Infinity, -Infinity ]) );
  var max = empty2.reduceToMaxValueRowWise();
  test.identical( max, vec([]) );

/*
  var matrix1 = matrix.make([ 4, 3 ])
  .copy
  ( new F64x([
    0, 0, 0,
    1, 2, 3,
    10, 20, 30,
    1, 111, 11,
  ]));

  var matrix2 = matrix.make([ 4, 3 ])
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

  test.case = 'data'; /* */

  var buffer = new I32x
  ([
    +2, +2, -2,
    -2, -3, +4,
    +4, +3, -2,
  ]);

  var m3 = new matrix
  ({
    buffer,
    dims : [ 3, 3 ],
    inputTransposing : 1,
  });

  test.case = 'm3';
  test.identical( m3.determinant(), 0 );

  var m3a = matrix.makeSquare
  ([
    1, 3, 5,
    2, 4, 6,
    3, 6, 8,
  ]);

  test.case = 'm3a';
  test.identical( m3a.determinant(), 2 );

  var m3b = matrix.makeSquare
  ([
    1, 2, 3,
    1, 3, 5,
    1, 5, 10,
  ]);
  test.identical( m3b.determinant(), 1 );

  var ca = matrix.makeCol([ 1, 2, 3 ]);
  var ra = matrix.makeRow([ 1, 2, 3 ]);
  var cb = ra.clone().transpose();
  var rb = ca.clone().transpose();

  test.case = 'm3 mul m3'; /* */

  var mul = matrix.mul( null, [ m3, m3 ] );
  logger.log( 'mul\n' + _.toStr( mul ) );

  var expected = matrix.makeSquare( 3 );
  expected.buffer = new I32x
  ([
    -8, +18, -6,
    -8, +17, -7,
    +8, -16, +8
  ]);

  test.equivalent( mul, expected );

  test.case = 'm3a * m3b'; /* */

  var mul = matrix.mul( null, [ m3a, m3b ] );
  logger.log( 'mul\n' + _.toStr( mul ) );

  var expected = matrix.makeSquare
  ([
    9, 36, 68,
    12, 46, 86,
    17, 64, 119,
  ]);

  test.equivalent( mul, expected );

  //

  function identityMuled( mul, m )
  {
    test.identical( mul.reduceToSumAtomWise(), 6 );
    test.identical( mul.reduceToProductAtomWise(), 6 );
    test.identical( m.reduceToSumAtomWise(), 3 );
    test.identical( m.reduceToProductAtomWise(), 0 );
  }

  test.case = 'identity * ca'; /* */

  var identity = matrix.makeIdentity( 3 );
  var mul = matrix.mul( null, [ identity, ca ] );
  var expected = matrix.makeCol([ 1, 2, 3 ]);
  test.equivalent( mul, expected );
  identityMuled( mul, identity );

  test.case = 'identity * cb'; /* */

  var identity = matrix.makeIdentity( 3 );
  var mul = matrix.mul( null, [ identity, cb ] );
  var expected = matrix.makeCol([ 1, 2, 3 ]);
  test.equivalent( mul, expected );
  identityMuled( mul, identity );

  test.case = 'ra * identity'; /* */

  var identity = matrix.makeIdentity( 3 );
  var mul = matrix.mul( null, [ ra, identity ] );
  var expected = matrix.makeRow([ 1, 2, 3 ]);
  test.equivalent( mul, expected );
  identityMuled( mul, identity );

  test.case = 'rb * identity'; /* */

  var identity = matrix.makeIdentity( 3 );
  var mul = matrix.mul( null, [ rb, identity ] );
  var expected = matrix.makeRow([ 1, 2, 3 ]);
  test.equivalent( mul, expected );
  identityMuled( mul, identity );

  test.case = 'm3 * ca'; /* */

  var mul = matrix.mul( null, [ m3, ca ] );
  var expected = matrix.makeCol([ 0, 4, 4 ]);
  test.equivalent( mul, expected );
  test.identical( mul.reduceToSumAtomWise(), 8 );
  test.identical( mul.reduceToProductAtomWise(), 0 );
  test.identical( m3.reduceToSumAtomWise(), 6 );
  test.identical( m3.reduceToProductAtomWise(), 4608 );

  test.case = 'm3 * ca'; /* */

  var mul = matrix.mul( null, [ m3, cb ] );
  var expected = matrix.makeCol([ 0, 4, 4 ]);
  test.equivalent( mul, expected );
  test.identical( mul.reduceToSumAtomWise(), 8 );
  test.identical( mul.reduceToProductAtomWise(), 0 );
  test.identical( m3.reduceToSumAtomWise(), 6 );
  test.identical( m3.reduceToProductAtomWise(), 4608 );

  test.case = 'ra * m3'; /* */

  var mul = matrix.mul( null, [ ra, m3 ] );
  var expected = matrix.makeRow([ 10, 5, 0 ]);
  expected.buffer = new I32x([ 10, 5, 0 ]);
  test.equivalent( mul, expected );
  test.identical( mul.reduceToSumAtomWise(), 15 );
  test.identical( mul.reduceToProductAtomWise(), 0 );
  test.identical( m3.reduceToSumAtomWise(), 6 );
  test.identical( m3.reduceToProductAtomWise(), 4608 );

  test.case = 'rb * m3'; /* */

  var mul = matrix.mul( null, [ rb, m3 ] );
  var expected = matrix.makeRow([ 10, 5, 0 ]);
  expected.buffer = new I32x([ 10, 5, 0 ]);
  test.equivalent( mul, expected );
  test.identical( mul.reduceToSumAtomWise(), 15 );
  test.identical( mul.reduceToProductAtomWise(), 0 );
  test.identical( m3.reduceToSumAtomWise(), 6 );
  test.identical( m3.reduceToProductAtomWise(), 4608 );

  //

  var expected = matrix.makeRow([ 14 ]);

  test.case = 'ra * ca';

  var mul = matrix.mul( null, [ ra, ca ] );
  test.equivalent( mul, expected );

  test.case = 'ra * cb';

  var mul = matrix.mul( null, [ ra, cb ] );
  test.equivalent( mul, expected );

  test.case = 'rb * ca';

  var mul = matrix.mul( null, [ rb, ca ] );
  test.equivalent( mul, expected );

  test.case = 'rb * cb';

  var mul = matrix.mul( null, [ rb, cb ] );
  test.equivalent( mul, expected );

  //

  var expected = matrix.makeSquare
  ([
    1, 2, 3,
    2, 4, 6,
    3, 6, 9,
  ]);

  test.case = 'ca * ra';
  var mul = matrix.mul( null, [ ca, ra ] );
  test.equivalent( mul, expected );

  test.case = 'ca * rb';
  var mul = matrix.mul( null, [ ca, rb ] );
  test.equivalent( mul, expected );

  test.case = 'cb * ra';
  var mul = matrix.mul( null, [ cb, ra ] );
  test.equivalent( mul, expected );

  test.case = 'cb * rb';
  var mul = matrix.mul( null, [ cb, rb ] );
  test.equivalent( mul, expected );

  test.case = 'data'; /* */

  var m1 = matrix.make([ 4, 3 ]).copy
  ([
    +2, +0, +1,
    -1, +1, +0,
    +1, +3, +1,
    -1, +1, +1,
  ]);

  var m2 = matrix.make([ 3, 4 ]).copy
  ([
    +2, +1, +2, +1,
    +0, +1, +0, +1,
    +1, +0, +1, +0,
  ]);
  var t1 = m1.clone().transpose();
  var t2 = m2.clone().transpose();

  test.case = '4x3 * 3x4'; /* */

  var expected = matrix.make([ 4, 4 ]).copy
  ([
    +5, +2, +5, +2,
    -2, +0, -2, +0,
    +3, +4, +3, +4,
    -1, +0, -1, +0,
  ]);

  var mul = matrix.mul( null, [ m1, m2 ] );
  logger.log( mul );
  test.equivalent( mul, expected );

  test.case = '3x4 * 4x3'; /* */

  var expected = matrix.make([ 3, 3 ]).copy
  ([
    +4, +8, +5,
    -2, +2, +1,
    +3, +3, +2,
  ]);

  var mul = matrix.mul( null, [ m2, m1 ] );
  logger.log( mul );
  test.equivalent( mul, expected );

  test.case = '3x4 * 4x3'; /* */

  var expected = matrix.make([ 3, 3 ]).copy
  ([
    +4, -2, +3,
    +8, +2, +3,
    +5, +1, +2,
  ]);

  var mul = matrix.mul( null, [ t1, t2 ] );
  logger.log( mul );
  test.equivalent( mul, expected );

  test.case = '4x3 * 4x3t'; /* */

  var expected = matrix.make([ 4, 4 ]).copy
  ([
    +5, -2, +3, -1,
    -2, +2, +2, +2,
    +3, +2, +11, +3,
    -1, +2, +3, +3,
  ]);

  var mul = matrix.mul( null, [ m1, t1 ] );
  logger.log( mul );
  test.equivalent( mul, expected );

  test.case = 'mul itself'; /* */

  var m = m3b.clone();

  var expected = matrix.make([ 3, 3 ]).copy
  ([
    +6, +23, +43,
    +9, +36, +68,
    +16, +67, +128,
  ]);

  var mul = matrix.mul( m, [ m, m ] );
  logger.log( mul );
  test.equivalent( mul, expected );
  test.is( mul === m );

  test.case = 'mul itself 2 times'; /* */

  var m = m3b.clone();

  var expected = matrix.make([ 3, 3 ]).copy
  ([
    +72, +296, +563,
    +113, +466, +887,
    +211, +873, +1663,
  ]);

  var mul = matrix.mul( m, [ m, m, m ] );
  logger.log( mul );
  test.equivalent( mul, expected );
  test.is( mul === m );

  test.case = 'mul itself 3 times'; /* */

  var m = m3b.clone();

  var expected = matrix.make([ 3, 3 ]).copy
  ([
    +931, +3847, +7326,
    +1466, +6059, +11539,
    +2747, +11356, +21628,
  ]);

  var mul = matrix.mul( m, [ m, m, m, m ] );
  logger.log( mul );
  test.equivalent( mul, expected );
  test.is( mul === m );

  test.case = 'mul 3 matrices with dst === src'; /* */

  var m1 = m3a.clone();
  var m2 = m3b.clone();

  var expected = matrix.make([ 3, 3 ]).copy
  ([
    +113, +466, +887,
    +144, +592, +1126,
    +200, +821, +1561,
  ]);

  var mul = matrix.mul( m1, [ m1, m2, m2 ] );
  logger.log( mul );
  test.equivalent( mul, expected );
  test.is( mul === m1 );

  test.case = 'mul 3 matrices with dst === src'; /* */

  var m1 = m3a.clone();
  var m2 = m3b.clone();

  var expected = matrix.make([ 3, 3 ]).copy
  ([
    +113, +466, +887,
    +144, +592, +1126,
    +200, +821, +1561,
  ]);

  var mul = matrix.mul( m2, [ m1, m2, m2 ] );
  logger.log( mul );
  test.equivalent( mul, expected );
  test.is( mul === m2 );

  test.case = 'mul 4 matrices with dst === src'; /* */

  var m1 = m3a.clone();
  var m2 = m3b.clone();

  var expected = matrix.make([ 3, 3 ]).copy
  ([
    +3706, +7525, +10457,
    +4706, +9556, +13280,
    +6525, +13250, +18414,
  ]);

  var mul = matrix.mul( m1, [ m1, m2, m2, m1 ] );
  logger.log( mul );
  test.equivalent( mul, expected );
  test.is( mul === m1 );

  test.case = 'mul 4 matrices with dst === src'; /* */

  var m1 = m3a.clone();
  var m2 = m3b.clone();

  var expected = matrix.make([ 3, 3 ]).copy
  ([
    +3706, +7525, +10457,
    +4706, +9556, +13280,
    +6525, +13250, +18414,
  ]);

  var mul = matrix.mul( m2, [ m1, m2, m2, m1 ] );
  logger.log( mul );
  test.equivalent( mul, expected );
  test.is( mul === m2 );

  test.case = 'matrix array multiplication'; /* */

  var m = m3a.clone();
  var v = [ 1, 2, 3 ];
  var expected = [ 22 , 28 , 39 ];
  var mul = matrix.mul( v, [ m, v ] );
  logger.log( mul );
  test.equivalent( mul, expected );
  test.is( v === mul );

  test.case = 'matrix vector multiplication'; /* */

  var m = m3a.clone();
  var v = vec([ 1, 2, 3 ]);
  var expected = vec([ 22 , 28 , 39 ]);
  var mul = matrix.mul( v, [ m, v ] );
  logger.log( mul );
  test.equivalent( mul, expected );
  test.is( v === mul );

  test.case = 'matrix array matrix multiplication'; /* */

  var m = m3a.clone();
  var v = [ 1, 2, 3 ];
  var row = matrix.makeRow([ 3, 4, 5 ]);
  var expected = [ 8206 , 10444 , 14547 ];
  var mul = matrix.mul( v, [ m, v, row, m, v ] );
  logger.log( mul );
  test.equivalent( mul, expected );
  test.is( v === mul );

  test.case = 'matrix array matrix multiplication'; /* */

  var m = m3a.clone();
  var v = [ 1, 2, 3 ];
  var row = matrix.makeRow([ 3, 4, 5 ]);
  var expected = [ 82060 , 104440 , 145470 ];
  var mul = matrix.mul( v, [ m, v, row, m, v, [ 10 ] ] );
  logger.log( mul );
  test.equivalent( mul, expected );
  test.is( v === mul );

  test.case = 'bad arguments'; /* */

  if( !Config.debug )
  return;

  test.shouldThrowErrorSync( () => matrix.mul( null ) );
  test.shouldThrowErrorSync( () => matrix.mul( null, null ) );
  test.shouldThrowErrorSync( () => matrix.mul( null, [] ) );
  test.shouldThrowErrorSync( () => matrix.mul( null, [ matrix.make([ 3, 3 ]) ] ) );
  test.shouldThrowErrorSync( () => matrix.mul( null, [ matrix.make([ 3, 3 ]), matrix.make([ 1, 4 ]) ] ) );
  test.shouldThrowErrorSync( () => matrix.mul( null, [ matrix.make([ 4, 1 ]), matrix.make([ 3, 3 ]) ] ) );

    // 1, 3, 5,
    // 2, 4, 6,
    // 3, 6, 8,

    // 1, 2, 3,
    // 1, 3, 5,
    // 1, 5, 10,

}

//

function furthestClosest( test )
{

  var m = matrix.make([ 2, 3 ]).copy
  ([
    1, 2, 3,
    4, 5, 6,
  ]);

  test.case = 'simplest furthest'; /* */

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

  test.case = 'simplest closest'; /* */

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

  test.case = 'matrixHomogenousApply 2d'; /* */

  var m = matrix.make([ 3, 3 ]).copy
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

  test.case = 'fromTransformations'; /* */

  var m = matrix.make([ 4, 4 ]);

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

  test.case = 'simplest determinant'; /* */

  var m = new matrix
  ({
    buffer : new I32x([ 1, 2, 3, 4 ]),
    dims : [ 2, 2 ],
    inputTransposing : 1,
  });

  var d = m.determinant();
  test.identical( d, -2 );
  test.identical( m.dims, [ 2, 2 ] );
  test.identical( m._stridesEffective, [ 2, 1 ] );

  test.case = 'matrix with zero determinant'; /* */

  var buffer = new I32x
  ([
    +2, +2, -2,
    -2, -3, +4,
    +4, +3, -2,
  ]);
  var m = new matrix
  ({
    buffer,
    dims : [ 3, 3 ],
    inputTransposing : 1,
  });

  var d = m.determinant();

  test.identical( d, 0 );
  test.identical( m.dims, [ 3, 3 ] );
  test.identical( m._stridesEffective, [ 3, 1 ] );

  /* */

  test.case = 'matrix with negative determinant'; /* */

  var m = new matrix
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
  var m = new matrix
  ({
    buffer,
    dims : [ 3, 3 ],
    inputTransposing : 1,
  });

  var d = m.determinant();

  test.identical( d, -30 );

  test.case = '2x2 matrix with -2 determinant, column first' //

  var m = new matrix
  ({
    buffer : _.longFromRange([ 1, 5 ]),
    dims : [ 2, 2 ],
    inputTransposing : 0,
  });

  var d = m.determinant();
  test.identical( d, -2 );

    test.case = '2x2 matrix with -2 determinant, row first' //

  var m = new matrix
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

  var m = new matrix
  ({
    buffer,
    dims : [ 3, 3 ],
    inputTransposing : 1,
  });

  var d = m.determinant();
  test.identical( d, -48468 );

  var m = new matrix
  ({
    buffer,
    dims : [ 3, 3 ],
    inputTransposing : 0,
  });

  var d = m.determinant();
  test.identical( d, -48468 );

}

//

function triangulate( test )
{

  test.case = 'triangulateGausian simple1'; /* */

  var m = matrix.make([ 3, 4 ]).copy
  ([
    +1, +1, +2, -1,
    +3, +1, +7, -7,
    +1, +7, +1, +7,
  ]);

  var expected = matrix.make([ 3, 4 ]).copy
  ([
    +1, +1, +2, -1,
    +0, -2, +1, -4,
    +0, +0, +2, -4,
  ]);

  test.equivalent( 1, 1 );

  m.triangulateGausian();
  test.equivalent( m, expected );

  test.case = 'triangulateGausianNormal simple1'; /* */

  var m = matrix.make([ 3, 4 ]).copy
  ([
    +1, +1, +2, -1,
    +3, +1, +7, -7,
    +1, +7, +1, +7,
  ]);

  var expected = matrix.make([ 3, 4 ]).copy
  ([
    +1, +1, +2, -1,
    +0, +1, -0.5, +2,
    +0, +0, +1, -2,
  ]);

  m.triangulateGausianNormal();
  test.equivalent( m, expected );

  test.case = 'triangulateGausianNormal simple2'; /* */

  var m = matrix.make([ 3, 4 ]).copy
  ([
    +1, -2, +2, 1,
    +5, -15, +8, 1,
    -2, -11, -11, 1,
  ]);

  var expected = matrix.make([ 3, 4 ]).copy
  ([
    +1, -2, +2, +1.0,
    +0, +1, 0.4, +0.8,
    +0, +0, 1, -15,
  ]);

  m.triangulateGausianNormal();
  test.equivalent( m, expected );

  test.case = 'triangulateGausian simple2'; /* */

  var m = matrix.make([ 3, 4 ]).copy
  ([
    +1, -2, +2, 1,
    +5, -15, +8, 1,
    -2, -11, -11, 1,
  ]);

  var expected = matrix.make([ 3, 4 ]).copy
  ([
    +1, -2, +2, +1,
    +0, -5, -2, -4,
    +0, +0, -1, +15,
  ]);

  m.triangulateGausian();
  test.equivalent( m, expected );

  test.case = 'triangulateGausian with y argument'; /* */

  var mexpected = matrix.make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +0, -5, -2,
    +0, +0, -1,
  ]);

  var yexpected = matrix.makeCol([ +1, -4, +15 ]);

  var m = matrix.make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +5, -15, +8,
    -2, -11, -11,
  ]);

  var y = matrix.makeCol([ 1, 1, 1 ]);

  m.triangulateGausian( y );
  test.equivalent( m, mexpected );
  test.equivalent( y, yexpected );

  test.case = 'triangulateGausianNormal with y argument'; /* */

  var mexpected = matrix.make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +0, +1, 0.4,
    +0, +0, 1,
  ]);

  var yexpected = matrix.makeCol([ +1, +0.8, -15 ]);

  var m = matrix.make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +5, -15, +8,
    -2, -11, -11,
  ]);

  var y = matrix.makeCol([ 1, 1, 1 ]);

  m.triangulateGausianNormal( y );
  test.equivalent( m, mexpected );
  test.equivalent( y, yexpected );

  test.case = 'triangulateGausian with y argument'; /* */

  var mexpected = matrix.make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +0, -5, -2,
    +0, +0, -1,
  ]);

  var yexpected = matrix.makeCol([ +1, -4, +15 ]);

  var m = matrix.make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +5, -15, +8,
    -2, -11, -11,
  ]);

  var y = matrix.makeCol([ 1, 1, 1 ]);

  m.triangulateGausian( y );
  test.equivalent( m, mexpected );
  test.equivalent( y, yexpected );

  test.case = 'triangulateGausian ( nrow < ncol ) with y argument'; /* */

  var mexpected = matrix.make([ 4, 3 ]).copy
  ([
    +1, -2, +4,
    +0, +2, -4,
    +0, +0, +8,
    +0, +0, +0,
  ]);

  var yexpected = matrix.makeCol([ -1, +3, -2, +0 ]);

  var m = matrix.make([ 4, 3 ]).copy
  ([
    +1, -2, +4,
    +1, +0, +0,
    +1, +2, +4,
    +1, +4, +16,
  ]);

  var y = matrix.makeCol([ -1, +2, +3, +2 ]);

  m.triangulateGausian( y );
  test.equivalent( m, mexpected );
  test.equivalent( y, yexpected );

  test.case = 'triangulateGausianNormal ( nrow < ncol ) with y argument'; /* */

  var mexpected = matrix.make([ 4, 3 ]).copy
  ([
    +1, -2, +4,
    +0, +1, -2,
    +0, +0, +1,
    +0, +0, +0,
  ]);

  var yexpected = matrix.makeCol([ -1, +1.5, -0.25, +0 ]);

  var m = matrix.make([ 4, 3 ]).copy
  ([
    +1, -2, +4,
    +1, +0, +0,
    +1, +2, +4,
    +1, +4, +16,
  ]);

  var y = matrix.makeCol([ -1, +2, +3, +2 ]);

  m.triangulateGausianNormal( y );
  test.equivalent( m, mexpected );
  test.equivalent( y, yexpected );

  test.case = 'triangulateLu'; /* */

  var m = matrix.make([ 3, 3 ]).copy
  ([
    +2, +4, -2,
    +4, -2, +6,
    +6, -4, +2,
  ]);

  var expected = matrix.make([ 3, 3 ]).copy
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

  var ll = matrix.make([ 3, 3 ]).copy
  ([
    +1, +0, +0,
    +2, +1, +0,
    +3, +1.6, +1,
  ]);

  var uu = matrix.make([ 3, 3 ]).copy
  ([
    +2, +4, -2,
    +0, -10, +10,
    +0, +0, -8,
  ]);

  var got = matrix.mul( null, [ l, u ] );
  test.equivalent( got, original );
  test.equivalent( l, ll );
  test.equivalent( u, uu );

  test.case = 'triangulateLuNormal'; /* */

  var m = matrix.make([ 3, 3 ]).copy
  ([
    +2, +4, -2,
    +4, -2, +6,
    +6, -4, +2,
  ]);

  var expected = matrix.make([ 3, 3 ]).copy
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

  var ll = matrix.make([ 3, 3 ]).copy
  ([
    +2, +0, +0,
    +4, -10, +0,
    +6, -16, -8,
  ]);

  var uu = matrix.make([ 3, 3 ]).copy
  ([
    +1, +2, -1,
    +0, +1, -1,
    +0, +0, +1,
  ]);

  var got = matrix.mul( null, [ l, u ] );
  test.equivalent( got, original );
  test.equivalent( l, ll );
  test.equivalent( u, uu );

  test.case = 'triangulateLu'; /* */

  var m = matrix.make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +5, -15, +8,
    -2, -11, -11,
  ]);

  var expected = matrix.make([ 3, 3 ]).copy
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

  var ll = matrix.make([ 3, 3 ]).copy
  ([
    +1, +0, +0,
    +5, +1, +0,
    -2, +3, +1,
  ]);

  var uu = matrix.make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +0, -5, -2,
    +0, +0, -1,
  ]);

  var got = matrix.mul( null, [ l, u ] );
  test.equivalent( got, original );
  test.equivalent( l, ll );
  test.equivalent( u, uu );

  test.case = 'triangulateLuNormal'; /* */

  var m = matrix.make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +5, -15, +8,
    -2, -11, -11,
  ]);

  var expected = matrix.make([ 3, 3 ]).copy
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

  var ll = matrix.make([ 3, 3 ]).copy
  ([
    +1, +0, +0,
    +5, -5, +0,
    -2, -15, -1,
  ]);

  var uu = matrix.make([ 3, 3 ]).copy
  ([
    +1, -2, +2,
    +0, +1, +0.4,
    +0, +0, +1,
  ]);

  var mul = matrix.mul( null, [ l, u ] );
  test.equivalent( mul, original );
  test.equivalent( l, ll );
  test.equivalent( u, uu );

  test.case = 'triangulateLu ( nrow < ncol ) with y argument'; /* */

  var mexpected = matrix.make([ 4, 3 ]).copy
  ([
    +1, -2, +4,
    +1, +2, -4,
    +1, +2, +8,
    +1, +3, +3,
  ]);

  var yexpected = matrix.makeCol([ -1, +3, -2, +0 ]);

  var m = matrix.make([ 4, 3 ]).copy
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

  var ll = matrix.make([ 4, 3 ]).copy
  ([
    +1, +0, +0,
    +1, +1, +0,
    +1, +2, +1,
    +1, +3, +3,
  ]);

  var uu = matrix.make([ 4, 3 ]).copy
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

  u = u.submatrix([ [ 0, 3 ], _.all ]);
  var mul = matrix.mul( null, [ l, u ] );
  test.equivalent( mul, original );

  test.case = 'triangulateLuNormal ( nrow < ncol )'; /* */

  var mexpected = matrix.make([ 4, 3 ]).copy
  ([
    +1, -2, +4,
    +1, +2, -2,
    +1, +4, +8,
    +1, +6, +24,
  ]);

  var m = matrix.make([ 4, 3 ]).copy
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

  var ll = matrix.make([ 4, 3 ]).copy
  ([
    +1, +0, +0,
    +1, +2, +0,
    +1, +4, +8,
    +1, +6, +24,
  ]);

  var uu = matrix.make([ 4, 3 ]).copy
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

  u = u.submatrix([ [ 0, 3 ], _.all ]);
  var mul = matrix.mul( null, [ l, u ] );
  test.equivalent( mul, original );

  test.case = 'triangulateLu ( nrow > ncol )'; /* */

  var mexpected = matrix.make([ 2, 3 ]).copy
  ([
    +1, -2, +4,
    +1, +2, -4,
  ]);

  var m = matrix.make([ 2, 3 ]).copy
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

  var ll = matrix.make([ 2, 3 ]).copy
  ([
    +1, +0, +0,
    +1, +1, +0,
  ]);

  var uu = matrix.make([ 2, 3 ]).copy
  ([
    +1, -2, +4,
    +0, +2, -4,
  ]);

  test.case = 'l and u should be';

  test.equivalent( l, ll );
  test.equivalent( u, uu );

  test.case = 'l*u should be same as original m';

  u = u.expand([ [ 0, 1 ], null ]);
  var mul = matrix.mul( null, [ l, u ] );
  test.equivalent( mul, original );

  test.case = 'triangulateLuNormal ( nrow > ncol )'; /* */

  var mexpected = matrix.make([ 2, 3 ]).copy
  ([
    +1, -2, +4,
    +1, +2, -2,
  ]);

  var m = matrix.make([ 2, 3 ]).copy
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

  var ll = matrix.make([ 2, 3 ]).copy
  ([
    +1, +0, +0,
    +1, +2, +0,
  ]);

  var uu = matrix.make([ 2, 3 ]).copy
  ([
    +1, -2, +4,
    +0, +1, -2,
  ]);

  test.case = 'l and u should be';

  test.equivalent( l, ll );
  test.equivalent( u, uu );

  test.case = 'l*u should be same as original m';

  u = u.expand([ [ 0, 1 ], null ]);
  var mul = matrix.mul( null, [ l, u ] );
  test.equivalent( mul, original );

}

triangulate.accuracy = [ _.accuracy * 1e+2, 1e-1 ];

//

function solveTriangulated( test )
{

  test.case = 'solveTriangleLower'; /* */

  var m = matrix.makeSquare
  ([
    2, 0, 0,
    2, 3, 0,
    4, 5, 6,
  ]);

  var expected = matrix.makeCol([ 1, 0, 0 ]);
  var y = matrix.makeCol([ 2, 2, 4 ]);
  var x = matrix.solveTriangleLower( null, m, y );

  test.equivalent( x, expected );

  var m = matrix.makeSquare
  ([
    2, -99, -99,
    2, 3, -99,
    4, 5, 6,
  ]);
  var x = matrix.solveTriangleLower( null, m, y );
  test.equivalent( x, expected );

  test.case = 'solveTriangleUpper'; /* */

  var m = matrix.makeSquare
  ([
    6, 5, 4,
    0, 3, 2,
    0, 0, 2,
  ]);

  var expected = matrix.makeCol([ 0, 0, 1 ]);
  var y = matrix.makeCol([ 4, 2, 2 ]);
  var x = matrix.solveTriangleUpper( null, m, y );

  test.equivalent( x, expected );

  var m = matrix.makeSquare
  ([
    6, 5, 4,
    -99, 3, 2,
    -99, -99, 2,
  ]);
  var x = matrix.solveTriangleUpper( null, m, y );
  test.equivalent( x, expected );

  test.case = 'solveTriangleLowerNormal'; /* */

  var m = matrix.makeSquare
  ([
    1, 0, 0,
    2, 1, 0,
    4, 5, 1,
  ]);

  var expected = matrix.makeCol([ 2, -2, 6 ]);
  var y = matrix.makeCol([ 2, 2, 4 ]);
  var x = matrix.solveTriangleLowerNormal( null, m, y );

  test.equivalent( x, expected );

  var m = matrix.makeSquare
  ([
    -99, -99, -99,
    2, -99, -99,
    4, 5, -99,
  ]);
  var x = matrix.solveTriangleLowerNormal( null, m, y );
  test.equivalent( x, expected );

  test.case = 'solveTriangleUpperNormal'; /* */

  var m = matrix.makeSquare
  ([
    1, 5, 4,
    0, 1, 2,
    0, 0, 1,
  ]);

  var expected = matrix.makeCol([ 6, -2, 2 ]);
  var y = matrix.makeCol([ 4, 2, 2 ]);
  var x = matrix.solveTriangleUpperNormal( null, m, y );

  test.equivalent( x, expected );

  var m = matrix.makeSquare
  ([
    -99, 5, 4,
    -99, -99, 2,
    -99, -99, -99,
  ]);

  var x = matrix.solveTriangleUpperNormal( null, m, y );

  test.equivalent( x, expected );

  test.case = 'solveWithTriangles u'; /* */

  var m = matrix.makeSquare
  ([
    1, 5, 4,
    0, 1, 2,
    0, 0, 1,
  ]);

  var expected = matrix.makeCol([ 6, -2, 2 ]);
  var y = matrix.makeCol([ 4, 2, 2 ]);
  var x = matrix.solveWithTriangles( null, m, y );

  test.equivalent( x, expected );

  test.case = 'solveWithTriangles u'; /* */

  var m = matrix.makeSquare
  ([
    -2, +1, +2,
    +4, -1, -5,
    +2, -3, -1,
  ]);

  var expected = matrix.makeCol([ -1, 2, -2 ]);
  var y = matrix.makeCol([ 0, 4, -6 ]);
  var x = matrix.solveWithTriangles( null, m, y );

  test.equivalent( x, expected );

  test.case = 'system triangulateLu'; /* */

  var expected = matrix.makeSquare
  ([
    +1, -1, +2,
    +2, +2, -2,
    -2, -1, -2,
  ]);

  var m = matrix.makeSquare
  ([
    +1, -1, +2,
    +2, +0, +2,
    -2, +0, -4,
  ]);

  m.triangulateLu();
  logger.log( 'm', m );
  test.identical( m, expected )

  test.case = 'system solve'; /* */

  var m = matrix.makeSquare
  ([
    +1, -1, +2,
    +2, +0, +2,
    -2, +0, -4,
  ]);

  var y = [ 7, 4, -10 ];
  var x = matrix.solve( null, m, y );

  logger.log( 'm', m );
  logger.log( 'x', x );

  test.identical( x, [ -1, -2, +3 ] );

}

//

function _solveSimple( test, rname )
{

  test.case = rname + ' . y array . solve 3x3 system'; //

  var m = matrix.makeSquare
  ([
    +1, -1, +2,
    +2, +0, +2,
    -2, +0, -4,
  ]);

  var om = m.clone();
  var y = [ 7, 4, -10 ];
  var oy = y.slice();
  var x = matrix[ rname ]( null, m, y );

  logger.log( 'm', m );
  logger.log( 'x', x );

  test.is( x !== y );
  test.identical( x, [ -1, -2, +3 ] );
  test.identical( y, oy );

  var y2 = matrix.mul( null, [ om, x ] );
  test.identical( y2, oy );

  // return;
  test.case = rname + ' . y vector . solve 3x3 system'; //

  var m = matrix.makeSquare
  ([
    +1, -1, +2,
    +2, +0, +2,
    -2, +0, -4,
  ]);

  var om = m.clone();
  var y = vec([ 7, 4, -10 ]);
  var oy = y.clone();
  var x = matrix[ rname ]( null, m, y );

  logger.log( 'm', m );
  logger.log( 'x', x );

  test.is( x !== y );
  test.identical( x, vec([ -1, -2, +3 ]) );
  test.identical( y, oy );

  var y2 = matrix.mul( null, [ om, x ] );
  test.identical( y2, y );

  test.case = rname + ' . y matrix . solve 3x3 system'; //

  var m = matrix.makeSquare
  ([
    +1, -1, +2,
    +2, +0, +2,
    -2, +0, -4,
  ]);

  var om = m.clone();
  var y = matrix.makeCol([ 7, 4, -10 ]);
  var oy = y.clone();
  var x = matrix[ rname ]( null, m, y );

  logger.log( 'm', m );
  logger.log( 'x', x );

  test.is( x !== y );
  test.identical( x, matrix.makeCol([ -1, -2, +3 ]) );
  test.identical( y, oy );

  var y2 = matrix.mul( null, [ om, x ] );
  test.identical( y2, y );

  test.case = rname + ' . x array . solve 3x3 system'; //

  var m = matrix.makeSquare
  ([
    +1, -1, +2,
    +2, +0, +2,
    -2, +0, -4,
  ]);

  var om = m.clone();
  var y = vec([ 7, 4, -10 ]);
  var oy = y.clone();
  var ox = [ 0, 0, 0 ];
  var x = matrix[ rname ]( ox, m, y );

  logger.log( 'm', m );
  logger.log( 'x', x );

  test.is( x !== y );
  test.is( x === ox );
  test.identical( x, [ -1, -2, +3 ] );
  test.identical( y, oy );

  var y2 = matrix.mul( null, [ om, x ] );
  test.identical( y2, [ 7, 4, -10 ] );

  test.case = rname + ' . x vector . solve 3x3 system'; //

  var m = matrix.makeSquare
  ([
    +1, -1, +2,
    +2, +0, +2,
    -2, +0, -4,
  ]);

  var om = m.clone();
  var y = [ 7, 4, -10 ];
  var oy = y.slice();
  var ox = vec([ 0, 0, 0 ]);
  var x = matrix[ rname ]( ox, m, y );

  logger.log( 'm', m );
  logger.log( 'x', x );

  test.is( x !== y );
  test.is( x === ox );
  test.identical( x, vec([ -1, -2, +3 ]) );
  test.identical( y, oy );

  var y2 = matrix.mul( null, [ om, x ] );
  test.identical( y2, vec([ 7, 4, -10 ]) );

  test.case = rname + ' . x matrix . solve 3x3 system'; //

  var m = matrix.makeSquare
  ([
    +1, -1, +2,
    +2, +0, +2,
    -2, +0, -4,
  ]);

  var om = m.clone();
  var y = [ 7, 4, -10 ];
  var oy = y.slice();
  var ox = matrix.makeCol([ 0, 0, 0 ]);
  var x = matrix[ rname ]( ox, m, y );

  logger.log( 'm', m );
  logger.log( 'x', x );

  test.is( x !== y );
  test.is( x === ox );
  test.identical( x, matrix.makeCol([ -1, -2, +3 ]) );
  test.identical( y, oy );

  var y2 = matrix.mul( null, [ om, x ] );
  test.identical( y2, matrix.makeCol([ 7, 4, -10 ]) );

  test.case = rname + ' . y 3x2 matrix . solve 3x3 system'; //

  var m = matrix.makeSquare
  ([
    +1, -1, +2,
    +2, +0, +2,
    -2, +0, -4,
  ]);

  var om = m.clone();
  var y = matrix.make([ 3, 2 ]).copy
  ([
    7, 3,
    4, 2,
    -10, 6,
  ]);
  var oy = y.clone();
  var x = matrix[ rname ]( null, m, y );

  logger.log( 'm', m );
  logger.log( 'x', x );

  var xEpxpected = matrix.make([ 3, 2 ]).copy
  ([
    -1, +5,
    -2, -6,
    +3, -4,
  ]);

  test.is( x !== y );
  test.identical( x, xEpxpected );
  test.identical( y, oy );

  var y2 = matrix.mul( null, [ om, x ] );
  test.identical( y2, y );

  test.case = rname + ' . y 0x2 matrix . solve 0x0 system'; //

  var m = matrix.makeSquare([]);
  m.toStr();

  var om = m.clone();
  var y = matrix.make([ 0, 2 ]).copy([]);
  var oy = y.clone();
  var x = matrix[ rname ]( null, m, y );

  logger.log( 'm', m );
  logger.log( 'x', x );

  var xEpxpected = matrix.make([ 0, 2 ]).copy([]);

  test.is( x !== y );
  test.identical( x, xEpxpected );
  test.identical( y, oy );

  var y2 = matrix.mul( null, [ om, x ] );
  test.identical( y2, y );

}

//

function solveSimple( test, rname )
{

  this._solveSimple( test, 'solve' );
  this._solveSimple( test, 'solveWithGausian' );
  this._solveSimple( test, 'solveWithGausianPivoting' );
  this._solveSimple( test, 'solveWithGaussJordan' );
  this._solveSimple( test, 'solveWithGaussJordanPivoting' );
  this._solveSimple( test, 'solveWithTriangles' );
  this._solveSimple( test, 'solveWithTrianglesPivoting' );

}

//

function _solveComplicated( test, rname )
{

  test.case = rname + ' . y array . solve 3x3 system1'; //

  var m = matrix.makeSquare
  ([
    +4, +2, +4,
    +4, +2, +2,
    +2, +2, +2,
  ]);

  var om = m.clone();
  var y = [ 1, 2, 3 ];
  var oy = y.slice();
  var x = matrix[ rname ]( null, m, y );

  logger.log( 'm', m );
  logger.log( 'x', x );

  test.is( x !== y );
  test.identical( x, [ -0.5, +2.5, -0.5 ] );
  test.identical( y, oy );

  var y2 = matrix.mul( null, [ om, x ] );
  test.identical( y2, y );

}

//

function solveComplicated( test, rname )
{

  this._solveComplicated( test, 'solve' );
  this._solveComplicated( test, 'solveWithGausianPivoting' );
  this._solveComplicated( test, 'solveWithGaussJordanPivoting' );
  this._solveComplicated( test, 'solveWithTrianglesPivoting' );

}

//

function solveWithPivoting( test )
{

  test.case = 'triangulateGausianPivoting 3x4'; /* */

  var m = matrix.make([ 3, 4 ]).copy
  ([
    +1, +3, +1, +2,
    +2, +6, +4, +8,
    +0, +0, +2, +4,
  ]);

  var om = m.clone();
  var y = matrix.makeCol([ +1, +3, +1 ]);
  var pivots = m.triangulateGausianPivoting( y );

  logger.log( 'm', m );
  logger.log( 'x', x );
  logger.log( 'y', y );
  logger.log( 'pivots', _.toStr( pivots, { levels : 2 } ) );

  var em = matrix.make([ 3, 4 ]).copy
  ([
    +3, +2, +1, +1,
    +0, +4, +2, +0,
    +0, +0, +0, +0,
  ]);
  test.identical( m, em );

  var ey = matrix.makeCol([ 1, 1, 0 ]);
  test.identical( y, ey );

  var epivots = [ [ 0, 1, 2 ], [ 1, 3, 2, 0 ] ]
  test.identical( pivots, epivots );

  /* */

  m.pivotBackward( pivots );
  matrix.VectorPivotBackward( y, pivots[ 0 ] );

  logger.log( 'm', m );
  logger.log( 'x', x );
  logger.log( 'y', y );
  logger.log( 'pivots', _.toStr( pivots, { levels : 2 } ) );

  var em = matrix.make([ 3, 4 ]).copy
  ([
    +1, +3, +1, +2,
    +0, +0, +2, +4,
    +0, +0, +0, +0,
  ]);
  test.identical( m, em );

  var ey = matrix.makeCol([ 1, 1, 0 ]);
  test.identical( y, ey );

  test.case = 'triangulateGausianPivoting'; /* */

  var y = matrix.makeCol([ 1, 2, 3 ]);
  var yoriginal = y.clone();
  var yexpected = matrix.makeCol([ 1, 1, 2.5 ]);

  var pivotsExpected = [ [ 0, 1, 2 ], [ 0, 2, 1 ] ];

  var mexpected = matrix.make([ 3, 3 ]).copy
  ([
    +4, +4, +2,
    +0, -2, +0,
    +0, +0, +1,
  ]);

  var munpivotedExpected = matrix.make([ 3, 3 ]).copy
  ([
    +4, +2, +4,
    +0, +0, -2,
    +0, +1, +0,
  ]);

  var m = matrix.make([ 3, 3 ]).copy
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
  var x = matrix.solveTriangleUpper( null, m, y );
  var y2 = matrix.mul( null, [ m, x ] );

  var x3 = matrix.from( x.clone() ).pivotBackward([ pivots[ 1 ], null ]);
  var y3 = matrix.mul( null, [ om, x3 ] );

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

function solveGeneral( test )
{

  // return; // xxx

  function checkNull( m, r, d )
  {

    var param = _.dup( 0, m.dims[ 1 ] );
    param[ d ] = 1;
    var x2 = matrix.mul( null, [ r.kernel, matrix.makeCol( param ) ] );
    var y2 = matrix.mul( null, [ m, x2 ] );

    if( y2.dims[ 0 ] < m.dims[ 1 ] )
    y2 = y2.expand([ [ null, m.dims[ 1 ]-y2.dims[ 0 ] ], null ]);
    test.equivalent( y2, matrix.makeZero([ m.dims[ 1 ], 1 ]) );

    logger.log( 'm', m );
    logger.log( 'x2', x2 );
    logger.log( 'y2', y2 );

  }

  function checkDimension( m, y, r, d, factor )
  {

    var param = _.dup( 0, m.dims[ 1 ] );
    param[ d ] = factor;
    var x2 = matrix.mul( null, [ r.kernel, matrix.makeCol( param ) ] );
    x2 = matrix.addAtomWise( x2, r.base, x2 );
    var y2 = matrix.mul( null, [ m, x2 ] );

    if( y2.dims[ 0 ] < m.dims[ 1 ] )
    y2 = y2.expand([ [ null, m.dims[ 1 ]-y2.dims[ 0 ] ], null ]);
    test.equivalent( y2, y );

    logger.log( 'param', param );
    logger.log( 'kernel', r.kernel );

    logger.log( 'm', m );
    logger.log( 'x2', x2 );
    logger.log( 'y2', y2 );

  }

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

  test.case = 'simple without pivoting'; /* */

  var re =
  {
    nsolutions : Infinity,
    base : matrix.makeCol([ +3, -3, +0 ]),
    nkernel : 1,
    kernel : matrix.makeSquare
    ([
      +0, +0, -1,
      +0, +0, +2,
      +0, +0, +1,
    ]),
  }

  var m = matrix.makeSquare
  ([
    +2, +2, -2,
    -2, -3, +4,
    +4, +3, -2,
  ]);

  var me = matrix.makeSquare
  ([
    +1, +0, +1,
    +0, +1, -2,
    +0, +0, +0,
  ]);

  var mo = m.clone();
  var y = matrix.makeCol([ 0, 3, 3 ]);
  var yo = y.clone();
  var r = matrix.solveGeneral({ m, y, pivoting : 0 });

  test.equivalent( r, re );
  test.equivalent( m, me );
  test.equivalent( y, yo );

  logger.log( 'r.base', r.base );
  logger.log( 'r.kernel', r.kernel );
  logger.log( 'm', m );

  check( mo, yo, r );

  test.case = 'simple with pivoting'; /* */

  // var re =
  // {
  //   nsolutions : Infinity,
  //   base : matrix.makeCol([ +1.5, 0, +1.5 ]),
  //   nkernel : 1,
  //   kernel : matrix.makeSquare
  //   ([
  //     +0, +0, -0.5,
  //     +0, +0, +1,
  //     +0, +0, +0.5,
  //   ]),
  // }

  var re =
  {
    nsolutions : Infinity,
    base : matrix.makeCol([ 1.5, 0, 1.5 ]),
    nkernel : 1,
    kernel : matrix.makeSquare
    ([
      -0.5, +0, +0,
      +1, +0, +0,
      +0.5, +0, +0,
    ]),
  }

  var m = matrix.makeSquare
  ([
    +2, +2, -2,
    -2, -3, +4,
    +4, +3, -2,
  ]);

  // var me = matrix.makeSquare
  // ([
  //   +1, +0.5, +0,
  //   +0, -0.5, +1,
  //   +0, +0, +0,
  // ]);

  var me = matrix.makeSquare
  ([
    +0, +0, +0,
    +0, -0.5, +1,
    +1, +0.5, +0,
  ]);

  var mo = m.clone();
  var y = matrix.makeCol([ 0, 3, 3 ]);
  var yo = y.clone();
  var r = matrix.solveGeneral({ m, y, pivoting : 1 });

  test.equivalent( r, re );
  test.equivalent( m, me );
  test.equivalent( y, yo );

  logger.log( 'r.base', r.base );
  logger.log( 'r.kernel', r.kernel );
  logger.log( 'm', m );

  check( mo, yo, r );

  test.case = 'simple2'; /* */

  var expected =
  {
    nsolutions : Infinity,
    base : matrix.makeCol([ +1, -1, +0 ]),
    nkernel : 1,
    kernel : matrix.makeSquare
    ([
      +0, +0, +2,
      +0, +0, +0,
      +0, +0, +1,
    ]),
  }

  var m = matrix.makeSquare
  ([
    +2, -2, -4,
    -2, +1, +4,
    +2, +0, -4,
  ]);

  var mo = m.clone();

  var y = matrix.makeCol([ +4, -3, +2 ]);
  var r = matrix.solveGeneral({ m, y });
  /*test.equivalent( r, expected );*/

  logger.log( 'r.base', r.base );
  logger.log( 'r.kernel', r.kernel );
  logger.log( 'm', m );

  check( mo, y, r );

  test.case = 'simple3'; /* */

  var expected =
  {
    nsolutions : Infinity,
    base : matrix.makeCol([ +1, +0, -1 ]),
    nkernel : 1,
    kernel : matrix.makeSquare
    ([
      +0, +2, +0,
      +0, +1, +0,
      +0, +0, +0,
    ]),
  }

  var m = matrix.makeSquare
  ([
    +2, -4, -2,
    -2, +4, +1,
    +2, -4, +0,
  ]);

  var mo = m.clone();

  var y = matrix.makeCol([ +4, -3, +2 ]);
  var r = matrix.solveGeneral({ m , y });
  /*test.equivalent( r, expected );*/

  logger.log( 'r.base', r.base );
  logger.log( 'r.kernel', r.kernel );
  logger.log( 'm', m );

  check( mo, y, r );

  test.case = 'missing rows'; /* */

  var expected =
  {
    nsolutions : Infinity,
    base : matrix.makeCol([ -2, +0, -0.25 ]),
    nkernel : 1,
    kernel : matrix.makeSquare
    ([
      +0, +0, +0,
      +0, +0, +1,
      +0, +0, +0.5,
    ]),
  }

  var m = matrix.make([ 2, 3 ]).copy
  ([
    -1, -2, +4,
    +1, +0, +0,
  ]);

  var mo = m.clone();

  var y = matrix.makeCol([ +1, -2 ]);
  var r = matrix.solveGeneral({ m , y });
  test.equivalent( r, expected );
  /*test.equivalent( r, expected );*/

  logger.log( 'r.base', r.base );
  logger.log( 'r.kernel', r.kernel );
  logger.log( 'm', m );

  check( mo, y, r );

  test.case = 'complicated system'; /* */

  var expected =
  {
    nsolutions : 1,
    base : matrix.makeCol([ -0.5, +2.5, -0.5 ]),
    nkernel : 0,
    kernel : matrix.makeSquare
    ([
      0, 0, 0,
      0, 0, 0,
      0, 0, 0,
    ]),
  }

  var m = matrix.make([ 3, 3 ]).copy
  ([
    +4, +2, +4,
    +4, +2, +2,
    +2, +2, +2,
  ]);

  var mo = m.clone();

  var y = matrix.makeCol([ 1, 2, 3 ]);
  var r = matrix.solveGeneral({ m, y });
  test.equivalent( r, expected );

  logger.log( 'r.base', r.base );
  logger.log( 'r.kernel', r.kernel );
  logger.log( 'm', m );

  check( mo, y, r );

  test.case = 'missing rows'; /* */

  var expected =
  {
    nsolutions : Infinity,
    base : matrix.makeCol([ 0, +1/6, 0, 0.25 ]),
    nkernel : 2,
    kernel : matrix.makeSquare
    ([
      +0, +0, +1, +0,
      +0, +0, -1/3, +0,
      +0, +0, +0, +1,
      +0, +0, +0, -0.5,
    ]),
  }

  var m = matrix.make([ 3, 4 ]).copy
  ([
    +1, +3, +1, +2,
    +2, +6, +4, +8,
    +0, +0, +2, +4,
  ]);

  var mo = m.clone();

  var y = matrix.makeCol([ +1, +3, +1 ]);
  var r = matrix.solveGeneral({ m, y });
  test.equivalent( r, expected );

  logger.log( 'r.base', r.base );
  logger.log( 'r.kernel', r.kernel );
  logger.log( 'm', m );

  check( mo, y, r );

}

solveGeneral.accuracy = [ _.accuracy * 1e+2, 1e-1 ];

//

function invert( test )
{

  test.case = 'invertingClone'; /* */

  var expected = matrix.make([ 3, 3 ]).copy
  ([
    +0, -0.5, -0.5,
    -7, -3, +2,
    -3, -1, +1,
  ]);

  var m = matrix.make([ 3, 3 ]).copy
  ([
    -2, +2, -5,
    +2, -3, +7,
    -4, +3, -7,
  ]);

  var determinant = m.determinant();
  var inverted = m.invertingClone();

  test.equivalent( inverted, expected );
  test.equivalent( m.determinant(), determinant );

  test.case = 'invertingClone'; /* */

  var expected = matrix.make([ 3, 3 ]).copy
  ([
    +5/3, +1, -1/3,
    -11, -6, +5,
    +2, +1, -1,
  ]);

  var m = matrix.make([ 3, 3 ]).copy
  ([
    +3, +2, +9,
    -3, -3, -14,
    +3, +1, +3,
  ]);

  var determinant = m.determinant();
  var inverted = m.invertingClone();

  test.equivalent( inverted, expected );
  test.equivalent( m.determinant(), determinant );

  test.case = 'invertingClone'; /* */

  var expected = matrix.make([ 3, 3 ]).copy
  ([
    -1.5, +0.5, +0.5,
    +0, +3, -1,
    +1, +2, -1,
  ]);

  var m = matrix.make([ 3, 3 ]).copy
  ([
    +2, -3, +4,
    +2, -2, +3,
    +6, -7, +9,
  ]);

  var determinant = m.determinant();
  var inverted = m.invertingClone();

  test.equivalent( inverted, expected );
  test.equivalent( m.determinant(), determinant );

  test.case = 'invert'; /* */

  var expected = matrix.make([ 3, 3 ]).copy
  ([
    -1.5, +0.5, +0.5,
    +0, +3, -1,
    +1, +2, -1,
  ]);

  var m = matrix.make([ 3, 3 ]).copy
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

function polynomExactFor( test )
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

  test.case = 'polynomExactFor for E( n )'; /* */

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

  var polynom = matrix.polynomExactFor
  ({
    order : 3,
    domain : [ 1, 4 ],
    onFunction : f,
  });

  logger.log( polynom );
  test.equivalent( polynom, [ 0, -0.5, +0.5 ] );
  checkPolynom( polynom , f );

  test.case = 'polynomExactFor for E( n*n )'; /* */

  f = function( x )
  {
    var r = 0;
    for( var i = 0 ; i < x ; i++ )
    r += i*i;
    return r;
  }

  var polynom = matrix.polynomExactFor
  ({
    order : 4,
    domain : [ 1, 5 ],
    onFunction : f,
  });

  logger.log( polynom );
  test.equivalent( polynom, [ 0, 1/6, -1/2, 1/3 ] );
  checkPolynom( polynom , f );

  test.case = 'polynomExactFor for parabola'; /* */

  var points = [ [ -2, -1 ], [ 0, 2 ], [ 2, 3 ] ];

  var polynom = matrix.polynomExactFor
  ({
    order : 3,
    points,
  });

  logger.log( polynom );
  test.equivalent( polynom, [ 2, 1, -1/4 ] );
  checkPolynom( polynom , points );

}

polynomExactFor.accuracy = [ _.accuracy * 1e+2, 1e-1 ];

//

function polynomClosestFor( test )
{

  test.case = 'polynomClosestFor for E( i )'; /* */

  var polynom = matrix.polynomClosestFor
  ({
    order : 2,
    points : [ [ 1, 0.5 ], [ 2, 2.25 ], [ 3, 2 ] ],
  });

  logger.log( polynom );
  test.equivalent( polynom, [ 1/12, 3/4 ] );

}

//

function identical( test )
{

  test.case = 'trivial';

  var m1 = matrix.makeIdentity([ 3, 3 ]);
  var m2 = matrix.makeIdentity([ 3, 3 ]);
  var got = m1.identicalWith( m2 );
  test.identical( got, true );

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

  var got = m1.identicalWith( m2 );
  test.identical( got, true );

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

  var got = m1.identicalWith( m2 );
  test.identical( got, true );

}

// --
// declare
// --

var Self =
{

  name : 'Tools.Math.Matrix',
  silencing : 1,
  enabled : 1,
  // routine : 'construct',
  // verbosity : 7,

  context :
  {

    makeWithOffset,

    _make,
    _makeSimilar,
    _convertToClass,
    _copyTo,
    _submatrix,
    _bufferNormalize,
    _solveSimple,
    _solveComplicated,

  },

  tests :
  {

    /* experiment */

    experiment,

    /* checker */

    matrixIs,
    constructorIsMatrix,
    isDiagonal,
    isUpperTriangle,
    isSymmetric,

    /* maker */

    env,
    clone,
    construct,
    make,
    makeHelper,
    makeLine,
    makeSimilar,
    from,
    tempBorrow,
    copyClone,
    convertToClass,
    copyTo,
    copy,

    /* structural */

    offset,
    stride,
    bufferNormalize,
    expand,
    vectorToMatrix,
    accessors,
    partialAccessors,
    lineSwap,
    pivot,

    // submatrix, /* xxx : not ready */

    /* etc */

    addAtomWise,
    subAtomWise,

    // homogeneousWithScalarRoutines,

    colRowWiseOperations,
    mul,
    furthestClosest,
    matrixHomogenousApply,

    determinant,
    triangulate,
    solveTriangulated,
    solveSimple,
    solveComplicated,
    solveWithPivoting,
    solveGeneral,
    invert,

    polynomExactFor,
    polynomClosestFor,

    identical,

    /* */

  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_global_.wTester.test( Self.name );

})();
