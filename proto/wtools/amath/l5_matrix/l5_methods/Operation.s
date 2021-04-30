(function _Operations_s_() {

'use strict';

const _ = _global_.wTools;
const abs = Math.abs;
const min = Math.min;
const max = Math.max;
const pow = Math.pow;
const pi = Math.PI;
const sin = Math.sin;
const cos = Math.cos;
const sqrt = Math.sqrt;
const sqr = _.math.sqr;

const Parent = null;
const Self = _.Matrix;

_.assert( _.object.isBasic( _.vectorAdapter ) );

// --
// add
// --

/**
 * The static routine Add() adds matrices {-srcs-}.
 *
 * @example
 * var m = _.Matrix.MakeSquare
 * ([
 *   2,  2, -2,
 *  -2, -3,  4,
 *   4,  3, -2,
 * ]);
 *
 * var got = _.Matrix.Add( null, [ m, m ] );
 * console.log( got.toStr() );
 * // log :
 * // +4,  +4,  -4,
 * // -4,  -6,  +8,
 * // +8,  +6,  -4,
 *
 * @param { Null|Matrix } dst - The container for result.
 * @param { Array } srcs - Array with matrices.
 * @returns { Matrix } - Returns destination matrix.
 * @throws { Error } If arguments.length is not 2.
 * @throws { Error } If {-srcs-} is not an Array.
 * @throws { Error } If srcs.length is less then 2.
 * @static
 * @function Add
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function Add( dst, srcs )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.arrayIs( srcs ) );
  _.assert( srcs.length >= 2 );

  /* adjust srcs 1 */

  let osrcs = srcs;
  srcs = srcs.slice();

  let leftMatrix;
  for( let s = 0 ; s < srcs.length ; s++ )
  {
    let src = srcs[ s ]

    if( _.numberIs( src ) )
    {
      if( leftMatrix )
      {
        let dims = this.DimsOf( leftMatrix );
        src = srcs[ s ] = this.FromScalarForReading( src, dims );
      }
      else
      {
        let m = notScalarRight( s );
        if( !m && dst )
        m = dst;
        let dims = m ? this.DimsOf( m ) : [ 1, 1 ];
        src = srcs[ s ] = this.FromScalarForReading( src, dims );
      }
    }
    else
    {
      src = srcs[ s ] = this.From( src );
    }
    leftMatrix = src;

  }

  /* adjust dst */

  if( dst === null )
  {
    let dims = srcs[ 0 ];
    let src = _.numberIs( osrcs[ osrcs.length-1 ] ) ? srcs[ osrcs.length-1 ] : osrcs[ osrcs.length-1 ];
    dst = this.MakeSimilar( src, dims );
  }

  /* adjust srcs 2 */

  let odst = dst;
  dst = this.From( dst );

  /* */

  dst = this._Add2( dst , srcs[ 0 ] , srcs[ 1 ] );

  /* */

  if( srcs.length > 2 )
  {
    borrow();
    for( let s = 2 ; s < srcs.length ; s++ )
    {
      this._Add2( dst , dst , srcs[ s ] );
    }
  }

  this.CopyTo( odst, dst );

  /* */

  return odst;

  /* - */

  function borrow()
  {

    let dstClone = null;
    for( let s = 0 ; s < srcs.length ; s++ )
    {

      if( dst === srcs[ s ] || dst.buffer === srcs[ s ].buffer )
      {
        if( dstClone === null )
        {
          dstClone = dst.tempBorrow1();
          dstClone.copy( dst );
        }
        srcs[ s ] = dstClone;
      }

      _.assert( dst.buffer !== srcs[ s ].buffer );

    }

  }

  /* */

  function notScalarRight( current )
  {
    for( let s = current+1 ; s < srcs.length ; s++ )
    {
      let src = srcs[ s ];
      if( !_.numberIs( src ) )
      return src;
    }
  }

  /* */

}

//

/**
 * The static routine _Add2() add two matrices {-src1-} and {-src2-}.
 * The result of assigned to destination matrix {-dst-}.
 *
 * @example
 * var src1 = _.Matrix.MakeSquare
 * ([
 *   2, 2, 2,
 *   2, 3, 4,
 *   4, 3, -2
 * ]);
 *
 * var src2 = _.Matrix.MakeSquare
 * ([
 *   3, 2, 3,
 *   4, 0, 2,
 *   0, 0, 6
 * ]);
 *
 * var dst = _.Matrix.Make( [ 3, 3 ] );
 *
 * var got = _.Matrix._Add2( dst, src1, src2 )
 * console.log( got )
 * // log :
 * // +14, +4, +22,
 * // +18, +4, +36,
 * // +24, +8,  +6,
 *
 * @param { Null|Matrix } dst - Destination matrix.
 * @param { Matrix } src1 - Source Matrix.
 * @param { Matrix } src2 - Source Matrix.
 * @returns { Matrix } - Returns {-dst-}.
 * @throws { Error } If arguments.length is not 3.
 * @throws { Error } If {-dst-} is not a Matrix, not a Null.
 * @throws { Error } If {-src1-} or {-src2-} is not instance of Matrix.
 * @throws { Error } If matrices have different shapes.
 * @static
 * @function _Add2
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function _Add2( dst, src1, src2 )
{

  src1 = this.FromForReading( src1 );
  src2 = this.FromForReading( src2 );

  if( dst === null )
  {
    dst = this.Make( src1.dims );
  }

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  _.assert( dst instanceof Self );
  _.assert( src1 instanceof Self );
  _.assert( src2 instanceof Self );
  _.assert( this.ShapesAreSame( src1, src2 ), 'Shapes of matrices should be the same' );
  _.assert( this.ShapesAreSame( src1, dst ), 'Shapes of matrices should be the same' );

  dst.scalarEach( ( it ) =>
  {
    dst.scalarSet( it.indexNd, src1.scalarGet( it.indexNd ) + src2.scalarGet( it.indexNd ) );
  });

  return dst;
}

//

/**
 * The method add() add matrices {-srcs-}.
 * The result assigned to the current matrix.
 *
 * @example
 * var m = _.Matrix.MakeSquare
 * ([
 *   2,  2, -2,
 *  -2, -3,  4,
 *   4,  3, -2,
 * ]);
 *
 * var got = m.add( [ m, m ] );
 * console.log( got.toStr() );
 * // log :
 * // +4,  +4,  -4,
 * // -4,  -6,  +8,
 * // +8,  +6,  -4,
 *
 * @param { Array } srcs - Array with matrices.
 * @returns { Matrix } - Returns {-this-}.
 * @method add
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-srcs-} is not array and Matrix.
 * @throws { Error } If {-srcs-} is a Matrix, and current matrix and {-srcs-} have different shapes.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function add( srcs )
{
  let dst = this;

  if( !_.arrayIs( srcs ) )
  srcs = [ dst, srcs ]

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.arrayIs( srcs ) );

  return dst.Add( dst, srcs );
}

// --
// mul
// --

/**
 * The method matrixPowSlow() returns an instance of Matrix with exponentiation values of provided matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   3, 2, 3,
 *   4, 0, 2
 *   0, 0, 6,
 * ]);
 *
 * var got = matrix.matrixPowSlow( 2 );
 * console.log( got );
 * // log :
 * // +17, +6, +31,
 * // +12, +8, +24,
 * // +0,  +0, +36,
 *
 * @param { Number } exponent - The power of elements.
 * @returns { Matrix } - Returns the current matrix.
 * @method matrixPowSlow
 * @throws { Error } If arguments.length is not 1.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

/* Dmytro : need clarification */

function matrixPowSlow( exponent )
{

  _.assert( _.instanceIs( this ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let t = this.tempBorrow( this );

  _.assert( 0, 'not implemented' );

}

//

/**
 * The static routine Mul() multiplies matrices {-srcs-} and applies result to destination matrix {-dst-}.
 *
 * @example
 * var m = _.Matrix.MakeSquare
 * ([
 *   2,  2, -2,
 *  -2, -3,  4,
 *   4,  3, -2,
 * ]);
 *
 * var got = _.Matrix.Mul( null, [ m, m ] );
 * console.log( got.toStr() );
 * // log :
 * // -8,  -8,  +8,
 * // +18, +17, -16,
 * // -6,  -7,  +8,
 *
 * @param { Null|Matrix } dst - The container for result.
 * @param { Array } srcs - Array with matrices.
 * @returns { Matrix } - Returns destination matrix.
 * @throws { Error } If arguments.length is not 2.
 * @throws { Error } If {-srcs-} is not an Array.
 * @throws { Error } If srcs.length is less then 2.
 * @static
 * @function Mul
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function Mul( dst, srcs )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.arrayIs( srcs ) );
  _.assert( srcs.length >= 2 );

  /* adjust srcs 1 */

  let osrcs = srcs;
  srcs = srcs.slice();

  let leftMatrix;
  for( let s = 0 ; s < srcs.length ; s++ )
  {
    let src = srcs[ s ]

    if( _.numberIs( src ) )
    {
      if( leftMatrix )
      {
        let dims = this.DimsOf( leftMatrix );
        src = srcs[ s ] = this.MakeDiagonal( _.dup( src, dims[ 1 ] ) );
      }
      else
      {
        let m = notScalarRight( s );
        let dims = m ? this.DimsOf( m ) : [ 1, 1 ];
        src = srcs[ s ] = this.MakeDiagonal( _.dup( src, dims[ 0 ] ) );
      }
    }
    else
    {
      src = srcs[ s ] = this.From( src );
    }
    leftMatrix = src;

  }

  /* adjust dst */

  if( dst === null )
  {
    let dims = [ srcs[ 0 ].dims[ 0 ], srcs[ srcs.length-1 ].dims[ 1 ] ];
    let src = _.numberIs( osrcs[ osrcs.length-1 ] ) ? srcs[ osrcs.length-1 ] : osrcs[ osrcs.length-1 ];
    dst = this.MakeSimilar( src, dims );
  }

  /* adjust srcs 2 */

  let dstClone = null;

  let odst = dst;
  dst = this.From( dst );

  borrow();

  if( srcs.length === 2 )
  {
    dst = this._Mul2( dst , srcs[ 0 ] , srcs[ 1 ] );
    this.CopyTo( odst, dst );
  }
  else
  {

    let dst2 = null;
    let dst3 = dst.tempBorrow3([ srcs[ 0 ].dims[ 0 ], srcs[ 1 ].dims[ 1 ] ]);
    dst3 = this._Mul2( dst3 , srcs[ 0 ] , srcs[ 1 ] );

    for( let s = 2 ; s < srcs.length ; s++ )
    {
      let src = srcs[ s ];
      if( s % 2 === 0 )
      {
        dst2 = dst.tempBorrow2([ dst3.dims[ 0 ], src.dims[ 1 ] ]);
        this._Mul2( dst2 , dst3 , src );
      }
      else
      {
        dst3 = dst.tempBorrow3([ dst2.dims[ 0 ], src.dims[ 1 ] ]);
        this._Mul2( dst3 , dst2 , src );
      }
    }

    if( srcs.length % 2 === 0 )
    this.CopyTo( odst, dst3 );
    else
    this.CopyTo( odst, dst2 );

  }

  /* */

  return odst;

  /* - */

  function borrow()
  {

    let dstClone = null;
    for( let s = 0 ; s < srcs.length ; s++ )
    {

      if( dst === srcs[ s ] || dst.buffer === srcs[ s ].buffer )
      {
        if( dstClone === null )
        {
          dstClone = dst.tempBorrow1();
          dstClone.copy( dst );
        }
        srcs[ s ] = dstClone;
      }

      _.assert( dst.buffer !== srcs[ s ].buffer );

    }

  }

  /* - */

  function notScalarRight( current )
  {
    for( let s = current+1 ; s < srcs.length ; s++ )
    {
      let src = srcs[ s ];
      if( !_.numberIs( src ) )
      return src;
    }
  }

  /* - */

}

//

/**
 * The static routine _Mul2() multiplies two matrices {-src1-} and {-src2-}.
 * The result of multiplication assigns to destination matrix {-dst-}.
 *
 * @example
 * var src1 = _.Matrix.MakeSquare
 * ([
 *   2, 2, 2,
 *   2, 3, 4,
 *   4, 3, -2
 * ]);
 *
 * var src2 = _.Matrix.MakeSquare
 * ([
 *   3, 2, 3,
 *   4, 0, 2,
 *   0, 0, 6
 * ]);
 *
 * var dst = _.Matrix.Make([ 3, 3 ]);
 *
 * var got = _.Matrix._Mul2( dst, src1, src2 )
 * console.log( got )
 * // log :
 * // +14, +4, +22,
 * // +18, +4, +36,
 * // +24, +8,  +6,
 *
 * @param { Null|Matrix } dst - Destination matrix.
 * @param { Matrix } src1 - Source Matrix.
 * @param { Matrix } src2 - Source Matrix.
 * @returns { Matrix } - Returns destination matrix.
 * @throws { Error } If arguments.length is not 3.
 * @throws { Error } If {-dst-} is not a Matrix, not a Null.
 * @throws { Error } If {-src1-} or {-src2-} is not instance of Matrix.
 * @throws { Error } If src1.dims or src2.dims length is not 2.
 * @throws { Error } If {-dst-} and {-src1-} are the same instance of matrix.
 * @throws { Error } If {-dst-} and {-src2-} are the same instance of matrix.
 * @throws { Error } If src1.dims[ 1 ] is not equal to src2.dims[ 0 ].
 * @throws { Error } If src1.dims[ 0 ] is not equal to dst.dims[ 0 ].
 * @throws { Error } If src1.dims[ 1 ] is not equal to dst.dims[ 1 ].
 * @static
 * @function _Mul2
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function _Mul2( dst, src1, src2 )
{

  src1 = this.FromForReading( src1 );
  src2 = this.FromForReading( src2 );

  if( dst === null )
  {
    dst = this.Make([ src1.dims[ 0 ], src2.dims[ 1 ] ]);
  }

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  _.assert( src1.dims.length === 2 );
  _.assert( src2.dims.length === 2 );
  _.assert( dst instanceof Self );
  _.assert( src1 instanceof Self );
  _.assert( src2 instanceof Self );
  _.assert( dst !== src1 );
  _.assert( dst !== src2 );
  _.assert( src1.dims[ 1 ] === src2.dims[ 0 ], errMsg );
  _.assert( src1.dims[ 0 ] === dst.dims[ 0 ], errMsg );
  _.assert( src2.dims[ 1 ] === dst.dims[ 1 ], errMsg );

  let nrow = dst.nrow;
  let ncol = dst.ncol;

  for( let r = 0 ; r < nrow ; r++ )
  for( let c = 0 ; c < ncol ; c++ )
  {
    let row = src1.rowGet( r );
    let col = src2.colGet( c );
    let dot = this.vectorAdapter.dot( row, col );
    dst.scalarSet( [ r, c ], dot );
  }

  return dst;

  function errMsg()
  {
    return `Inconsistent dimensions : ${dst.dimsExportString()} = ${src1.dimsExportString()} * ${src2.dimsExportString()}`;
  }
}

//

/**
 * The method mul() multiplies matrices {-srcs-}.
 * The result of multiplication assigns to the current matrix.
 *
 * @example
 * var m = _.Matrix.MakeSquare
 * ([
 *   2,  2, -2,
 *  -2, -3,  4,
 *   4,  3, -2,
 * ]);
 *
 * var got = m.mul( [ m, m ] );
 * console.log( got.toStr() );
 * // log :
 * // -8,  -8,  +8,
 * // +18, +17, -16,
 * // -6,  -7,  +8,
 *
 * @param { Array } srcs - Array with matrices.
 * @returns { Matrix } - Returns {-this-}.
 * @method mul
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-srcs-} is not array or Matrix.
 * @throws { Error } If {-srcs-} is a Matrix, and {-srcs-} and current matrix have different shapes.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function mul( srcs )
{
  let dst = this;

  if( !_.arrayIs( srcs ) )
  srcs = [ dst, srcs ]

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.arrayIs( srcs ) );

  return dst.Self.Mul( dst, srcs );
}

//

/**
 * The method mulLeft() multiply the current matrix and source matrix {-src-}.
 * The result assigns to the current matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2, 3,
 *   0, 4, 5
 *   0, 0, 6,
 * ]);
 *
 * var src = _.Matrix.MakeSquare
 * ([
 *   1, 2, 3,
 *   4, 1, 2,
 *   0, 0, 1,
 * ]);
 *
 * var got = matrix.mulLeft( src );
 * console.log( matrix );
 * // log :
 * // +9,  +4, +10,
 * // +16, +4, +13
 * // +0,  +0, +6,
 *
 * @param { Matrix } src - Source Matrix.
 * @returns { Matrix } - Returns original matrix filled by result of multiplication.
 * @method mulLeft
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-src-} is not an instance of Matrix.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function mulLeft( src )
{
  let dst = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  // _.assert( 0, 'not tested' );

  dst.mul([ dst, src ])

  return dst;
}

//

/**
 * The method mulRight() multiply the source matrix {-src-} and the current matrix.
 * The result assigns to the current matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2, 3,
 *   0, 4, 5
 *   0, 0, 6,
 * ]);
 *
 * var src = _.Matrix.MakeSquare
 * ([
 *   1, 2, 3,
 *   4, 1, 2,
 *   0, 0, 1,
 * ]);
 *
 * var got = matrix.mulRight( src );
 * console.log( got );
 * // log :
 * // +9,  +4, +10,
 * // +16, +4, +13
 * // +0,  +0, +6,
 *
 * @param { Matrix } src - Source matrix.
 * @returns { Matrix } - Returns original matrix filled by result of multiplication.
 * @method mulRight
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-src-} is not an instance of Matrix.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function mulRight( src )
{
  let dst = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  // _.assert( 0, 'not tested' );

  dst.mul([ src, dst ]);

  return dst;
}

//
// etc
//

/**
 * Static routine OuterProductOfVectors() multiplies of two vectors. The result applies to a new Matrix.
 * Vectors stay unchanged.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   3, 4
 * ]);
 * var v1 = [ -1, 5 ];
 * var v2 = [ 2, -4 ];
 *
 * var got = _.Matrix.OuterProductOfVectors( v1, v2 );
 * console.log( got.toStr() );
 * // log :
 * // -2,  +4
 * // +10, -20
 *
 * @param { Long|VectorAdapter } v1 - The first source vector.
 * @param { Long|VectorAdapter } v2 - The second source vector.
 * @returns { Matrix } - Returns original matrix with result of operation.
 * @method OuterProductOfVectors
 * @throws { Error } If arguments.length is not 2.
 * @throws { Error } If {-v1-} is not a vector.
 * @throws { Error } If {-v2-} is not a vector.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function OuterProductOfVectors( v1, v2 )
{
  _.assert( arguments.length === 2 );
  let matrix = _.Matrix.Make([ v1.length, v2.length ]);
  matrix.outerProductOfVectors( ... arguments );
  return matrix;
}

//

/**
 * Method outerProductOfVectors() multiplies of two vectors. The result applies to current matrix.
 * Vectors stay unchanged.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   3, 4
 * ]);
 * var v1 = [ -1, 5 ];
 * var v2 = [ 2, -4 ];
 *
 * var got = matrix.outerProductOfVectors( v1, v2 );
 * console.log( got.toStr() );
 * // log :
 * // -2,  +4
 * // +10, -20
 *
 * @param { Long|VectorAdapter } v1 - The first source vector.
 * @param { Long|VectorAdapter } v2 - The second source vector.
 * @returns { Matrix } - Returns original matrix with result of operation.
 * @method outerProductOfVectors
 * @throws { Error } If arguments.length is not 2.
 * @throws { Error } If {-v1-} is not a vector.
 * @throws { Error } If {-v2-} is not a vector.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function outerProductOfVectors( v1, v2 )
{
  let self = this;

  _.assert( _.vectorIs( v1 ) );
  _.assert( _.vectorIs( v2 ) );
  _.assert( arguments.length === 2 );

  v1 = _.vectorAdapter.from( v1 );
  v2 = _.vectorAdapter.from( v2 );

  for( let i = 0; i < v1.length; i ++ )
  {
    for( let j = 0; j < v2.length; j ++ )
    {
      self.scalarSet( [ i, j ], v1.eGet( i )*v2.eGet( j ) );
    }
  }

  return self;
}

// --
// reducer
// --

/**
 * The method closest() returns the closest element to provided element {-insElement-}.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   3, 2, 3,
 *   4, 0, 2,
 *   0, 0, 6,
 * ]);
 *
 * var insElement = _.vectorAdapter.fromLong( [ 2, 2, 1 ] );
 *
 * var got = matrix.closest( insElement );
 * console.log( got )
 * // log :
 * // {
 * //  index: 1,
 * //  distance: 2.23606797749979
 * // }
 *
 * @param { VectorAdapter|Long } insElement - Source element, to find closest element.
 * @returns { Map } - Returns index and distance of the closest element.
 * @method closest
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-insElement-} is not an instance of VectorAdapter or Long.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function closest( insElement )
{
  let self = this;
  insElement = self.vectorAdapter.fromLong( insElement );
  let result =
  {
    index : null,
    distance : +Infinity,
  }

  _.assert( arguments.length === 1, 'Expects single argument' );

  for( let i = 0 ; i < self.length ; i += 1 )
  {

    let d = self.vectorAdapter.distanceSqr( insElement, self.eGet( i ) );
    if( d < result.distance )
    {
      result.distance = d;
      result.index = i;
    }

  }

  result.distance = sqrt( result.distance );

  return result;
}

//

/**
 * The method furthest() returns the furthest element to provided element {-insElement-}.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   3, 2, 3,
 *   4, 0, 2,
 *   0, 0, 6,
 * ]);
 *
 * var insElement = _.vectorAdapter.fromLong( [ 2, 2, 1 ] );
 *
 * var got = matrix.furthest( insElement );
 * console.log( got )
 * // log :
 * // {
 * //  index: 2,
 * //  distance: 5.0990195135927845
 * // }
 *
 * @param { VectorAdapter|Long } insElement - Source element, to find furthest element.
 * @returns { Map } - Returns index and distance of the furthest element.
 * @method furthest
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-insElement-} is not an instance of VectorAdapter or Long.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function furthest( insElement )
{
  let self = this;
  insElement = self.vectorAdapter.fromLong( insElement );
  let result =
  {
    index : null,
    distance : -Infinity,
  }

  _.assert( arguments.length === 1, 'Expects single argument' );

  for( let i = 0 ; i < self.length ; i += 1 )
  {

    let d = self.vectorAdapter.distanceSqr( insElement, self.eGet( i ) );
    if( d > result.distance )
    {
      result.distance = d;
      result.index = i;
    }

  }

  result.distance = sqrt( result.distance );

  return result;
}

//

/**
 * The method elementMean() returns medium element values of provided matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   3, 2, 3,
 *   4, 0, 2,
 *   0, 0, 6,
 * ]);
 *
 * var got = matrix.elementMean();
 * console.log( got )
 * // log : 2.333, 0.666, 3.666
 *
 * @returns { VectorAdapter } - Returns medium element values of current matrix.
 * @method elementMean
 * @throws { Error } If argument exist.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function elementMean()
{
  let self = this;

  let result = self.elementAdd();

  self.vectorAdapter.div( result, self.length );

  return result;
}

//

/**
 * The method minmaxColWise() calculates minimal and maximal distribution values of columns.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   +1, +2, +3,
 *   +0, +4, +5
 *   +0, +0, +6,
 * ]);
 *
 * var got = matrix.minmaxColWise();
 * console.log( got );
 * // log :
 * // {
 * //   min: Float32Array [ 0, 0, 3 ],
 * //   max: Float32Array [ 1, 4, 6 ]
 * // }
 *
 * @returns { Map } - Returns minimal and maximal distribution values of columns.
 * @method minmaxColWise
 * @throws { Error } If argument exist.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
   */

function minmaxColWise()
{
  let self = this;

  let minmax = self.distributionRangeSummaryValueColWise();
  let result = Object.create( null );

  result.min = self.longType.long.makeUndefined( self.buffer, minmax.length );
  result.max = self.longType.long.makeUndefined( self.buffer, minmax.length );

  for( let i = 0 ; i < minmax.length ; i += 1 )
  {
    result.min[ i ] = minmax[ i ][ 0 ];
    result.max[ i ] = minmax[ i ][ 1 ];
  }

  return result;
}

//

/**
 * The method minmaxRowWise() calculates minimal and maximal distribution values of rows.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   +1, +2, +3,
 *   +0, +4, +5
 *   +0, +0, +6,
 * ]);
 *
 * var got = matrix.minmaxRowWise();
 * console.log( got );
 * // log :
 * // {
 * //   min: Float32Array [ 1, 0, 0 ],
 * //   max: Float32Array [ 3, 5, 6 ]
 * // }
 *
 * @returns { Map } - Returns minimal and maximal distribution values of rows.
 * @method minmaxRowWise
 * @throws { Error } If argument exist.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function minmaxRowWise()
{
  let self = this;

  let minmax = self.distributionRangeSummaryValueRowWise();
  let result = Object.create( null );

  result.min = self.longType.long.makeUndefined( self.buffer, minmax.length );
  result.max = self.longType.long.makeUndefined( self.buffer, minmax.length );

  for( let i = 0 ; i < minmax.length ; i += 1 )
  {
    result.min[ i ] = minmax[ i ][ 0 ];
    result.max[ i ] = minmax[ i ][ 1 ];
  }

  return result;
}

//

function determinant1()
{
  let self = this;
  return self.scalarGet([ 0, 0 ]);
}

//

function determinant2()
{
  let self = this;
  let result =
    + self.scalarGet([ 0, 0 ]) * self.scalarGet([ 1, 1 ])
    - self.scalarGet([ 0, 1 ]) * self.scalarGet([ 1, 0 ])
    ;
  return result;
}

//

function determinant3()
{
  let self = this;
  let result =
    + self.scalarGet([ 0, 0 ]) * self.scalarGet([ 1, 1 ]) * self.scalarGet([ 2, 2 ])
    + self.scalarGet([ 0, 1 ]) * self.scalarGet([ 1, 2 ]) * self.scalarGet([ 2, 0 ])
    + self.scalarGet([ 0, 2 ]) * self.scalarGet([ 1, 0 ]) * self.scalarGet([ 2, 1 ])
    - self.scalarGet([ 2, 0 ]) * self.scalarGet([ 1, 1 ]) * self.scalarGet([ 0, 2 ])
    - self.scalarGet([ 2, 1 ]) * self.scalarGet([ 1, 2 ]) * self.scalarGet([ 0, 0 ])
    - self.scalarGet([ 2, 2 ]) * self.scalarGet([ 1, 0 ]) * self.scalarGet([ 0, 1 ])
    ;
  return result;
}

//

function determinantWithPermutation( o ) /* qqq : determinant is already documented, please document also determinantWithPermutation */
{
  let self = this;
  let l = self.dims[ 0 ];
  o = _.routine.options_( determinantWithPermutation, arguments );

  if( l === 0 )
  return 0;
  if( !self.isSquare() )
  return 0;

  /* */

  if( l <= 3 && o.smalling )
  {
    if( l === 3 )
    return self.determinant3();
    else if( l === 2 )
    return self.determinant2();
    else if( l === 1 )
    return self.determinant1();
  }
  else
  {
    return self._determinantWithPermutation();
  }

}

determinantWithPermutation.defaults =
{
  smalling : 1,
}

//

function _determinantWithPermutation()
{
  let self = this;
  let l = self.dims[ 0 ];
  let result = 0
  let sign = 0;

  /* */

  // _.eachPermutation({ onEach : onPermutation, container : l });
  _.permutation.eachPermutation({ onEach : onPermutation, sets : l });

  return result;

  /* */

  function onPermutation( permutation, iteration, left, right, swaps )
  {
    const index = [];
    sign = ( sign + swaps ) % 2;

    let r = sign === 0 ? 1 : -1;

    for( let i1 = 0 ; i1 < l ; i1 += 1 )
    {
      index[ 0 ] = i1;
      index[ 1 ] = permutation[ i1 ];
      r *= self.scalarGet( index );
    }

    result += r;
  }

  /* */

  function signEval( permutation )
  {
    let counter = _.permutation.swapsCount( permutation );
    return counter % 2;
  }

  /* */

}

  /*

== 2x2

  c = 2! = 2

  00 01
  10 11

  \/

  + 0 1
  - 1 0

== 3x3

  c = 3! = 6

= sarrus

  00 01 02 00 01
  10 11 12 10 11
  20 21 22 20 21

  \\\///

  + 0 1 2 . +0-1+2 = +1
  + 1 2 0 . +1-2+0 = -1
  + 2 0 1 . +2-0+1 = +3
  - 2 1 0 . -2+1-0 = -1
  - 0 2 1
  - 1 0 2

= log

  0 . 2..2 . + 0 1 2
  1 . 1..2 . - 0 2 1
  2 . 0..2 . + 1 2 0
  3 . 1..2 . - 1 0 2
  4 . 0..2 . + 2 0 1
  5 . 1..2 . - 2 1 0

= swaping

  + 0 1 2
  - 0 2 1
  + 2 0 1
  - 2 1 0
  + 1 2 0
  - 1 0 2

== 4x4

  c = 4! = 24

= sarrus

  00 01 02 03 00 01 02
  10 11 12 13 10 11 12
  20 21 22 23 20 21 22
  30 31 32 33 30 31 32

  + 0 1 2 3
  - 1 2 3 0
  + 2 3 0 1
  - 3 0 1 2

  + 3 2 1 0
  - 0 3 2 1
  + 1 0 3 2
  - 2 1 0 3

  00 01 03 02 00 01 03
  10 11 13 12 10 11 13
  20 21 23 22 20 21 23
  30 31 33 32 30 31 33

  - 0 1 3 2
  + 1 3 2 0
  - 3 2 0 1
  + 2 0 1 3

  - 2 3 1 0
  + 0 2 3 1
  - 1 0 2 3
  + 3 1 0 2

  00 02 01 03 00 02 01
  10 12 11 13 10 12 11
  20 22 21 23 20 22 21
  30 32 31 33 30 32 31

  - 0 2 1 3
  + 2 1 3 0
  - 1 3 0 2
  + 3 0 2 1

  - 3 1 2 0
  + 0 3 1 2
  - 2 0 3 1
  + 1 2 0 3

  \\\\////

= lines

  + 0 1 2 3
  - 0 1 3 2
  - 0 2 1 3

  + 3 2 1 0
  - 2 3 1 0
  - 3 1 2 0

= log1

  0 . 3..3 . + 0 1 2 3
  1 . 2..3 . - 0 1 3 2
  2 . 1..3 . + 0 2 3 1
  3 . 2..3 . - 0 2 1 3
  4 . 1..3 . + 0 3 1 2
  5 . 2..3 . - 0 3 2 1

  6 . 0..3 . - 1 2 3 0
  7 . 2..3 . + 1 2 0 3
  8 . 1..3 . - 1 3 0 2
  9 . 2..3 . + 1 3 2 0
  10 . 1..3 . - 1 0 2 3
  11 . 2..3 . + 1 0 3 2

  12 . 0..3 . + 2 3 0 1
  13 . 2..3 . - 2 3 1 0
  14 . 1..3 . + 2 0 1 3
  15 . 2..3 . - 2 0 3 1
  16 . 1..3 . + 2 1 3 0
  17 . 2..3 . - 2 1 0 3

  18 . 0..3 . - 3 0 1 2
  19 . 2..3 . + 3 0 2 1
  20 . 1..3 . - 3 1 2 0
  21 . 2..3 . + 3 1 0 2
  22 . 1..3 . - 3 2 0 1
  23 . 2..3 . + 3 2 1 0

= log2

  + 0 1 2 3
  - 0 1 3 2
  + 0 2 3 1
  - 0 2 1 3
  + 0 3 1 2
  - 0 3 2 1
  - 1 2 3 0
  + 1 2 0 3
  - 1 3 0 2
  + 1 3 2 0
  - 1 0 2 3
  + 1 0 3 2
  + 2 3 0 1
  - 2 3 1 0
  + 2 0 1 3
  - 2 0 3 1
  + 2 1 3 0
  - 2 1 0 3
  - 3 0 1 2
  + 3 0 2 1
  - 3 1 2 0
  + 3 1 0 2
  - 3 2 0 1
  + 3 2 1 0

*/

//

function determinantWithLu( o ) /* qqq : determinant is alread documented, please document also determinantWithPermutation */
{
  let self = this;
  let l = self.dims[ 0 ];
  o = _.routine.options_( determinantWithLu, arguments );

  if( l === 0 )
  return 0;
  if( !self.isSquare() )
  return 0;

  /* */

  if( l <= 3 && o.smalling )
  {
    if( l === 3 )
    return self.determinant3();
    else if( l === 2 )
    return self.determinant2();
    else if( l === 1 )
    return self.determinant1();
  }
  else
  {
    return self._determinantWithLu();
  }

}

determinantWithLu.defaults =
{
  smalling : 1,
}

//

function _determinantWithLu()
{
  let self = this;
  let l = self.dims[ 0 ];
  let clone = self.cloneExtending({ ... self.bufferExport({ asFloat : 1, dstObject : null, restriding : null }) });

  let triangulated = clone.triangulateLuPermutating();
  let result = clone.diagonalGet().reduceToProduct();

  if( isNaN( result ) )
  return 0;

  if( triangulated.npermutations % 2 === 1 )
  result *= -1;

  return result;
}

//

function determinantWithBareiss( o ) /* qqq : determinant is alread documented, please document also determinantWithPermutation */
{
  let self = this;
  let l = self.dims[ 0 ];
  o = _.routine.options_( determinantWithBareiss, arguments );

  if( l === 0 )
  return 0;
  if( !self.isSquare() )
  return 0;

  /* */

  if( l <= 3 && o.smalling )
  {
    if( l === 3 )
    return self.determinant3();
    else if( l === 2 )
    return self.determinant2();
    else if( l === 1 )
    return self.determinant1();
  }
  else
  {
    return self._determinantWithBareiss();
  }

}

determinantWithBareiss.defaults =
{
  smalling : 1,
}

//

function _determinantWithBareiss()
{
  let self = this;
  let l = self.dims[ 0 ];

  let clone = self.clone();
  let permutated = clone.permutateRook();

  iterate( 0, 1 );
  for( let k = 1 ; k < l-1 ; k++ )
  {
    let denom = clone.scalarGet([ k-1, k-1 ]);
    if( Math.abs( denom ) < self.accuracy )
    return 0;
    iterate( k, denom );
  }

  let result = clone.scalarGet([ l-1, l-1 ]);

  if( permutated.npermutations % 2 === 1 )
  result *= -1;

  return result;

  function iterate( k, denom )
  {
    for( let i = k + 1 ; i < l ; i++ )
    for( let j = k + 1 ; j < l ; j++ )
    {
      let nom = clone.scalarGet([ k, k ]) * clone.scalarGet([ i, j ]) - clone.scalarGet([ i, k ]) * clone.scalarGet([ k, j ]);
      clone.scalarSet( [ i, j ], nom / denom );
    }
  }
}

//

/**
 * The method determinant() calculates a determinant of the current matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   +1, +2, +3,
 *   +0, +4, +5
 *   +0, +0, +6,
 * ]);
 *
 * var got = matrix.determinant();
 * console.log( got );
 * // log : 24
 *
 * @returns { Number } - Returns a determinant of the matrix.
 * @method determinant
 * @throws { Error } If the matrix is not a square.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function determinant( o )
{
  let self = this;
  let l = self.dims[ 0 ];
  o = _.routine.options_( determinant, arguments );

  if( l === 0 )
  return 0;
  if( !self.isSquare() )
  return 0;

  /* */

  if( l <= 3 && o.smalling )
  {
    if( l === 3 )
    return self.determinant3();
    else if( l === 2 )
    return self.determinant2();
    else if( l === 1 )
    return self.determinant1();
  }
  else
  {
    // return self._determinantWithPermutation();
    return self._determinantWithLu();
    // return self._determinantWithBareiss();
  }

}

determinant.defaults =
{
  smalling : 1,
}

// --
// relations
// --

let Statics = /* qqq : split static routines. ask how */
{

  // add

  Add,
  _Add2,

  //

  Mul,
  _Mul2,

  OuterProductOfVectors,

}

/*
map
filter
reduce
zip
*/

// --
// declare
// --

let Extension =
{

  // add

  Add,
  _Add2,
  add,

  // mul

  pow : matrixPowSlow,

  Mul,
  _Mul2,
  mul,
  mulLeft,
  mulRight,

  // etc

  OuterProductOfVectors,
  outerProductOfVectors,

  // reducer

  closest,
  furthest,

  elementMean,

  minmaxColWise,
  minmaxRowWise,

  determinant1,
  determinant2,
  determinant3,
  determinantWithLu,
  _determinantWithLu,
  determinantWithPermutation,
  _determinantWithPermutation,
  determinantWithBareiss,
  _determinantWithBareiss,
  determinant,

  //

  Statics,

}

_.classExtend( Self, Extension );
_.assert( Self._Mul2 === _Mul2 );
_.assert( Self.prototype._Mul2 === _Mul2 );

})();
