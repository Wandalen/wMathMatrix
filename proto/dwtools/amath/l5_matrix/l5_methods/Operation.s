(function _Operations_s_() {

'use strict';

let _ = _global_.wTools;
let abs = Math.abs;
let min = Math.min;
let max = Math.max;
let pow = Math.pow;
let pi = Math.PI;
let sin = Math.sin;
let cos = Math.cos;
let sqrt = Math.sqrt;
let sqr = _.math.sqr;

let Parent = null;
let Self = _.Matrix;

_.assert( _.objectIs( _.vectorAdapter ) );
_.assert( _.routineIs( Self ), 'wMatrix is not defined, please include wMatrix.s first' );

// --
// add
// --

/**
 * The static routine Add() add matrices {-srcs-}.
 *
 * @example
 * var buffer = new I32x
 * ([
 *   2,  2, -2,
 *  -2, -3,  4,
 *   4,  3, -2,
 * ]);
 *
 * var m = new _.Matrix
 * ({
 *   buffer,
 *   dims : [ 3, 3 ],
 *   inputTransposing : 1,
 * });
 *
 * var got = _.Matrix.Add( null, [ m, m ] );
 * console.log( got.toStr() );
 * // log :  +4,  +4,  -2,
 * //        -2,  -6,  +8,
 * //        +8,  +6,  -4,
 *
 * @param { Null|Matrix } dst - The container for result.
 * @param { Array } srcs - Array with matrices.
 * @returns { Matrix } - Returns {-dst-}.
 * @function Add
 * @throws { Error } If (arguments.length) is not 2.
 * @throws { Error } If {-srcs-} is not an Array.
 * @throws { Error } If srcs.length is less then 2.
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
          // dstClone.strides = dstClone.stridesEffective; /* yyy */
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
 * The routine _Add2() add two matrices {-src1-} and {-src2-}.
 * The result of adding assigned to destination matrix {-dst-}.
 *
 * @example
 * var src1 = new _.Matrix
 * ({
 *   buffer : [ 2, 2, 2, 2, 3, 4, 4, 3, -2 ],
 *   dims : [ 3, 3 ],
 *   inputTransposing : 1,
 * });
 *
 * var src2 = new _.Matrix
 * ({
 *   buffer : [ 3, 2, 3, 4, 0, 2, 0, 0, 6 ],
 *   dims : [ 3, 3 ],
 *   inputTransposing : 1,
 * });
 *
 * var dst = new _.Matrix
 * ({
 *   buffer : new I32x( [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ),
 *   dims : [ 3, 3 ],
 *   inputTransposing : 1,
 * });
 *
 * var got = _.Matrix._Add2( dst, src1, src2 )
 * console.log( got )
 * // log : +14, +4, +22,
 * //       +18, +4, +36,
 * //       +24, +8,  +6,
 *
 * @param { Null|Matrix } dst - Destination matrix.
 * @param { Matrix } src1 - Source Matrix.
 * @param { Matrix } src2 - Source Matrix.
 * @returns { Matrix } - Returns {-dst-}.
 * @function _Add2
 * @throws { Error } If (arguments.length) is not 3.
 * @throws { Error } If {-dst-} is not a Matrix, not a Null.
 * @throws { Error } If {-src1-} or {-src2-} is not instance of Matrix.
 * @throws { Error } If src1.dims or src2.dims length is not 2.
 * @throws { Error } If {-dst-} and {-src1-} are the same instance of matrix.
 * @throws { Error } If {-dst-} and {-src2-} are the same instance of matrix.
 * @throws { Error } If src1.dims[ 1 ] is not equal to src2.dims[ 0 ].
 * @throws { Error } If src1.dims[ 0 ] is not equal to dst.dims[ 0 ].
 * @throws { Error } If src1.dims[ 1 ] is not equal to dst.dims[ 1 ].
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
 * var buffer = new I32x
 * ([
 *   2,  2, -2,
 *  -2, -3,  4,
 *   4,  3, -2,
 * ]);
 *
 * var m = new _.Matrix
 * ({
 *   buffer,
 *   dims : [ 3, 3 ],
 *   inputTransposing : 1,
 * });
 *
 * var got = m.add( [ m, m ] );
 * console.log( got.toStr() );
 * // log :  +4,  +4,  -2,
 * //        -2,  -6,  +8,
 * //        +8,  +6,  -4,
 *
 * @param { Array } srcs - Array with matrices.
 * @returns { Matrix } - Returns {-this-}.
 * @method add
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-srcs-} is not array.
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
 * The method pow() is short-cut matrixPow returns an instance of Matrix with exponentiation values of provided matrix,
 * takes destination matrix from context.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   3, 2, 3,
 *   4, 0, 2
 *   0, 0, 6,
 * ]);
 *
 * var got = matrix.pow( 2 );
 * console.log( got );
 * // log :  +17, +6, +31,
 * //        +12, +8, +24,
 * //        +0,  +0, +36,
 *
 * @param { Number } exponent - The power of elements.
 * @returns { Matrix } - Returns instance of Matrix.
 * @method pow
 * @throws { Error } If method called by not an instance of matrix constructor.
 * @throws { Error } If (arguments.length) is not 1.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

/* Dmytro : need clarification */

function matrixPow( exponent )
{

  _.assert( _.instanceIs( this ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let t = this.tempBorrow( this );

  _.assert( 0, 'not implemented' );

}

//

/**
 * The static routine Mul() returns the result of multiplication of matrices {-srcs-}.
 *
 * @example
 * var buffer = new I32x
 * ([
 *   2,  2, -2,
 *  -2, -3,  4,
 *   4,  3, -2,
 * ]);
 *
 * var m = new _.Matrix
 * ({
 *   buffer,
 *   dims : [ 3, 3 ],
 *   inputTransposing : 1,
 * });
 *
 * var got = _.Matrix.Mul( null, [ m, m ] );
 * console.log( got.toStr() );
 * // log :  -8,  -8,  +8,
 * //       +18, +17, -16,
 * //        -6,  -7,  +8,
 *
 * @param { Null|Matrix } dst - The container for result.
 * @param { Array } srcs - Array with matrices.
 * @returns { Matrix } - Returns {-dst-}.
 * @function Mul
 * @throws { Error } If (arguments.length) is not 2.
 * @throws { Error } If {-srcs-} is not an Array.
 * @throws { Error } If srcs.length is less then 2.
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
 * The routine _Mul2() multiply two matrices {-src1-} and {-src2-}.
 * The result of multiplication assigns to destination matrix {-dst-}.
 *
 * @example
 * var src1 = new _.Matrix
 * ({
 *   buffer : [ 2, 2, 2, 2, 3, 4, 4, 3, -2 ],
 *   dims : [ 3, 3 ],
 *   inputTransposing : 1,
 * });
 *
 * var src2 = new _.Matrix
 * ({
 *   buffer : [ 3, 2, 3, 4, 0, 2, 0, 0, 6 ],
 *   dims : [ 3, 3 ],
 *   inputTransposing : 1,
 * });
 *
 * var dst = new _.Matrix
 * ({
 *   buffer : new I32x( [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ),
 *   dims : [ 3, 3 ],
 *   inputTransposing : 1,
 * });
 *
 * var got = _.Matrix._Mul2( dst, src1, src2 )
 * console.log( got )
 * // log : +14, +4, +22,
 * //       +18, +4, +36,
 * //       +24, +8,  +6,
 *
 * @param { Null|Matrix } dst - Destination matrix.
 * @param { Matrix } src1 - Source Matrix.
 * @param { Matrix } src2 - Source Matrix.
 * @returns { Matrix } - Returns {-dst-}.
 * @function _Mul2
 * @throws { Error } If (arguments.length) is not 3.
 * @throws { Error } If {-dst-} is not a Matrix, not a Null.
 * @throws { Error } If {-src1-} or {-src2-} is not instance of Matrix.
 * @throws { Error } If src1.dims or src2.dims length is not 2.
 * @throws { Error } If {-dst-} and {-src1-} are the same instance of matrix.
 * @throws { Error } If {-dst-} and {-src2-} are the same instance of matrix.
 * @throws { Error } If src1.dims[ 1 ] is not equal to src2.dims[ 0 ].
 * @throws { Error } If src1.dims[ 0 ] is not equal to dst.dims[ 0 ].
 * @throws { Error } If src1.dims[ 1 ] is not equal to dst.dims[ 1 ].
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
 * The method mul() multiply matrices {-srcs-}.
 * The result of multiplication assigns to the current matrix.
 *
 * @example
 * var buffer = new I32x
 * ([
 *   2,  2, -2,
 *  -2, -3,  4,
 *   4,  3, -2,
 * ]);
 *
 * var m = new _.Matrix
 * ({
 *   buffer,
 *   dims : [ 3, 3 ],
 *   inputTransposing : 1,
 * });
 *
 * var got = m.mul( [ m, m ] );
 * console.log( got.toStr() );
 * // log :  -8,  -8,  +8,
 * //       +18, +17, -16,
 * //        -6,  -7,  +8,
 *
 * @param { Array } srcs - Array with matrices.
 * @returns { Matrix } - Returns {-this-}.
 * @method mul
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-srcs-} is not array.
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
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   1, 2, 3,
 *   0, 4, 5
 *   0, 0, 6,
 * ]);
 *
 * var src = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   1, 2, 3,
 *   4, 1, 2,
 *   0, 0, 1,
 * ]);
 *
 * var got = matrix.mulLeft( src );
 * console.log( matrix );
 * // log :  +9, +4, +10,
 * //       +16, +4, +13
 * //        +0, +0,  +6,
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
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   1, 2, 3,
 *   0, 4, 5
 *   0, 0, 6,
 * ]);
 *
 * var src = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   1, 2, 3,
 *   4, 1, 2,
 *   0, 0, 1,
 * ]);
 *
 * var got = matrix.mulRight( src );
 * console.log( got );
 * // log :  +9, +4, +10,
 * //       +16, +4, +13
 * //        +0, +0,  +6,
 *
 * @param { Matrix } src - Source Matrix.
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

// --
// reducer
// --

/**
 * The method closest() returns the closest element to provided element {-insElement-}.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
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
 * // log
 * {
 *  index: 1,
 *  distance: 2.23606797749979
 * }
 *
 * @param { VectorAdapter|Long } insElement - provided element, an instance of VectorAdapter or Long.
 * @returns { Map } - Returns index and distance of the closest element.
 * @method closest
 * @throws { Error } If {-insElement-} is not an instance of VectorAdapter or Long.
 * @throws { Error } If (arguments.length) is not 1.
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
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
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
 * // log
 * {
 *  index: 2,
 *  distance: 5.0990195135927845
 * }
 *
 * @param { VectorAdapter|Long } insElement - provided element, an instance of VectorAdapter or Long.
 * @returns { Map } - Returns index and distance of the furthest element.
 * @method furthest
 * @throws { Error } If {-insElement-} is not an instance of VectorAdapter or Long.
 * @throws { Error } If (arguments.length) is not 1.
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
 * The method elementMean() returns medium element values of provided matrix,
 * takes source from context.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   3, 2, 3,
 *   4, 0, 2,
 *   0, 0, 6,
 * ]);
 *
 * var got = matrix.elementMean( );
 * console.log( got )
 * // log 2.333, 0.666, 3.666
 *
 * @returns { Number } - Returns medium element values of provided matrix.
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
 * The method minmaxColWise() compares columns values of matrix and returns min and max buffer instance with these values,
 * takes source from context.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   +1, +2, +3,
 *   +0, +4, +5
 *   +0, +0, +6,
 * ]);
 *
 * var got = matrix.minmaxColWise();
 * console.log( got );
 * // log
 * {
 *   min: Float32Array [ 0, 0, 3 ],
 *   max: Float32Array [ 1, 4, 6 ]
 * }
 *
 * @returns { TypedArrays } - Returns two instances of F32x buffers.
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

  result.min = self.long.longMakeUndefined( self.buffer, minmax.length );
  result.max = self.long.longMakeUndefined( self.buffer, minmax.length );

  for( let i = 0 ; i < minmax.length ; i += 1 )
  {
    result.min[ i ] = minmax[ i ][ 0 ];
    result.max[ i ] = minmax[ i ][ 1 ];
  }

  return result;
}

//

/**
 * The method minmaxRowWise() compares rows values of matrix and returns min and max buffer instance with these values,
 * takes source from context.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   +1, +2, +3,
 *   +0, +4, +5
 *   +0, +0, +6,
 * ]);
 *
 * var got = matrix.minmaxRowWise();
 * console.log( got );
 * // log
 * {
 *   min: Float32Array [ 1, 0, 0 ],
 *   max: Float32Array [ 3, 5, 6 ]
 * }
 *
 * @returns { TypedArrays } - Returns two instances of F32x buffers.
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

  result.min = self.long.longMakeUndefined( self.buffer, minmax.length );
  result.max = self.long.longMakeUndefined( self.buffer, minmax.length );

  for( let i = 0 ; i < minmax.length ; i += 1 )
  {
    result.min[ i ] = minmax[ i ][ 0 ];
    result.max[ i ] = minmax[ i ][ 1 ];
  }

  return result;
}

//

/**
 * The method determinant() calculates a determinant of the provided matrix,
 * takes source from context.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   +1, +2, +3,
 *   +0, +4, +5
 *   +0, +0, +6,
 * ]);
 *
 * var got = matrix.determinant();
 * console.log( got );
 * // log 24
 *
 * @returns { Number } - Returns a determinant value of the provided matrix.
 * @method determinant
 * @throws { Error } If argument exist.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function determinant()
{
  let self = this;
  let l = self.length;

  if( l === 0 )
  return 0;

  let iterations = _.math.factorial( l );
  let result = 0;

  _.assert( l === self.scalarsPerElement );

  /* */

  let sign = 1;
  let index = [];
  for( let i = 0 ; i < l ; i += 1 )
  index[ i ] = i;

  /* */

  function add()
  {
    let r = 1;
    for( let i = 0 ; i < l ; i += 1 )
    r *= self.scalarGet([ index[ i ], i ]);
    r *= sign;
    // console.log( index );
    // console.log( r );
    result += r;
    return r;
  }

  /* */

  function swap( a, b )
  {
    let v = index[ a ];
    index[ a ] = index[ b ];
    index[ b ] = v;
    sign *= -1;
  }

  /* */

  let i = 0;
  while( i < iterations )
  {

    for( let s = 0 ; s < l-1 ; s++ )
    {
      let r = add();
      //console.log( 'add', i, index, r );
      swap( s, l-1 );
      i += 1;
    }

  }

  /* */

  // 00
  // 01
  //
  // 012
  // 021
  // 102
  // 120
  // 201
  // 210

  // console.log( 'determinant', result );

  return result;
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

  pow : matrixPow,

  Mul,
  _Mul2,
  mul,
  mulLeft,
  mulRight,

  // reducer

  closest,
  furthest,

  elementMean,

  minmaxColWise,
  minmaxRowWise,

  determinant,

  //

  Statics,

}

_.classExtend( Self, Extension );
_.assert( Self._Mul2 === _Mul2 );
_.assert( Self.prototype._Mul2 === _Mul2 );

})();
