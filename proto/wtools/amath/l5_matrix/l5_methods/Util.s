(function _Util_s_() {

'use strict';

const _ = _global_.wTools;
const Parent = null;
const Self = _.Matrix;

// --
// borrow
// --

function _TempBorrow( src, dims, index )
{
  let bufferConstructor;

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  _.assert( src instanceof Self || src === null );
  _.assert( _.arrayIs( dims ) || dims instanceof Self || dims === null );

  if( !src )
  {

    bufferConstructor = this.longType.long.default.InstanceConstructor;
    if( !dims )
    dims = src;

  }
  else
  {

    if( src.buffer )
    bufferConstructor = src.buffer.constructor;

    if( !dims )
    if( src.dims )
    dims = src.dims.slice();

  }

  if( dims instanceof Self )
  dims = dims.dims;

  _.assert( _.routineIs( bufferConstructor ) );
  _.assert( _.arrayIs( dims ) );
  _.assert( index <= 3 );
  _.assert( !!this._TempMatrices[ index ] );

  let key = bufferConstructor.name + '_' + dims.join( 'x' );

  if( this._TempMatrices[ index ][ key ] )
  return this._TempMatrices[ index ][ key ];

  let result = this._TempMatrices[ index ][ key ] = new Self
  ({
    dims,
    buffer : new bufferConstructor( this.ScalarsPerMatrixForDimensions( dims ) ),
    inputRowMajor : 0,
  });

  return result;
}

//

/**
 * Static routine TempBorrow0() provides temporary caching of source matrix {-src-}.
 * The cache has 4 containers with matrices. Each container has index, and the routine TempBorrow0() uses container with index 0.
 * If the cache has matrix with dimensions equivalent to {-src-}, then routine returns cached matrix, otherwise, it creates
 * new initialized matrix.
 *
 * @example
 * var src = _.Matrix.Make([ 2, 2 ]);
 * var cachedSrc = _.Matrix.TempBorrow0( src );
 * console.log( cachedSrc.toStr() );
 * // log :
 * // +0 +0
 * // +0 +0
 * cachedSrc.copy
 * ([
 *   1, 2,
 *   3, 4,
 * ]);
 *
 * var fromCache =  _.Matrix.TempBorrow0( src );
 * console.log( fromCache.toStr() );
 * // log :
 * // +1 +2
 * // +3 +4
 * console.log( src.toStr() );
 * // log :
 * // +0 +0
 * // +0 +0
 *
 * @param { Matrix|Long } src - Source matrix or dimensions.
 * @returns { Matrix } - Returns instance of cached matrix or creates new matrix.
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-src-} has not valid type.
 * @static
 * @function TempBorrow0
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function TempBorrow0( src )
{
  _.assert( arguments.length === 1 );
  if( src instanceof Self )
  return Self._TempBorrow( src, src, 0 );
  else
  return Self._TempBorrow( null, src, 0 );
}

//

/**
 * Method tempBorrow0() provides temporary caching of source matrix {-src-}.
 * The cache has 4 containers with matrices. Each container has index, and the routine tempBorrow0() uses container with index 0.
 * If the cache has matrix with dimensions equivalent to {-src-}, then routine returns cached matrix, otherwise, it creates
 * new initialized matrix.
 *
 * @example
 * var src = _.Matrix.Make([ 2, 2 ]);
 * var cachedSrc = src.tempBorrow0( src );
 * console.log( cachedSrc.toStr() );
 * // log :
 * // +0 +0
 * // +0 +0
 * cachedSrc.copy
 * ([
 *   1, 2,
 *   3, 4,
 * ]);
 *
 * var fromCache =  src.tempBorrow0( src );
 * console.log( fromCache.toStr() );
 * // log :
 * // +1 +2
 * // +3 +4
 * console.log( src.toStr() );
 * // log :
 * // +0 +0
 * // +0 +0
 *
 * @param { Undefined|Matrix|Long } src - Source matrix or dimensions.
 * @returns { Matrix } - Returns instance of cached matrix or creates new matrix.
 * @method tempBorrow0
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-src-} has not valid type.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function tempBorrow0( src )
{
  _.assert( arguments.length <= 1 );
  if( src === undefined )
  src = this;
  return Self._TempBorrow( this, src, 0 );
}

//

/**
 * Static routine TempBorrow1() provides temporary caching of source matrix {-src-}.
 * The cache has 4 containers with matrices. Each container has index, and the routine TempBorrow1() uses container with index 1.
 * If the cache has matrix with dimensions equivalent to {-src-}, then routine returns cached matrix, otherwise, it creates
 * new initialized matrix.
 *
 * @example
 * var src = _.Matrix.Make([ 2, 2 ]);
 * var cachedSrc = _.Matrix.TempBorrow1( src );
 * console.log( cachedSrc.toStr() );
 * // log :
 * // +0 +0
 * // +0 +0
 * cachedSrc.copy
 * ([
 *   1, 2,
 *   3, 4,
 * ]);
 *
 * var fromCache =  _.Matrix.TempBorrowr1( src );
 * console.log( fromCache.toStr() );
 * // log :
 * // +1 +2
 * // +3 +4
 * console.log( src.toStr() );
 * // log :
 * // +0 +0
 * // +0 +0
 *
 * @param { Matrix|Long } src - Source matrix or dimensions.
 * @returns { Matrix } - Returns instance of cached matrix or creates new matrix.
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-src-} has not valid type.
 * @static
 * @function TempBorrow1
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function TempBorrow1( src )
{
  _.assert( arguments.length === 1 );
  if( src instanceof Self )
  return Self._TempBorrow( src, src, 1 );
  else
  return Self._TempBorrow( null, src, 1 );
}

//

/**
 * Method tempBorrow1() provides temporary caching of source matrix {-src-}.
 * The cache has 4 containers with matrices. Each container has index, and the routine tempBorrow1() uses container with index 1.
 * If the cache has matrix with dimensions equivalent to {-src-}, then routine returns cached matrix, otherwise, it creates
 * new initialized matrix.
 *
 * @example
 * var src = _.Matrix.Make([ 2, 2 ]);
 * var cachedSrc = src.tempBorrow1( src );
 * console.log( cachedSrc.toStr() );
 * // log :
 * // +0 +0
 * // +0 +0
 * cachedSrc.copy
 * ([
 *   1, 2,
 *   3, 4,
 * ]);
 *
 * var fromCache =  src.tempBorrow1( src );
 * console.log( fromCache.toStr() );
 * // log :
 * // +1 +2
 * // +3 +4
 * console.log( src.toStr() );
 * // log :
 * // +0 +0
 * // +0 +0
 *
 * @param { Undefined|Matrix|Long } src - Source matrix or dimensions.
 * @returns { Matrix } - Returns instance of cached matrix or creates new matrix.
 * @method tempBorrow1
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-src-} has not valid type.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function tempBorrow1( src )
{
  _.assert( arguments.length <= 1 );
  if( src === undefined )
  src = this;
  return Self._TempBorrow( this, src, 1 );
}

//

/**
 * Static routine TempBorrow2() provides temporary caching of source matrix {-src-}.
 * The cache has 4 containers with matrices. Each container has index, and the routine TempBorrow2() uses container with index 2.
 * If the cache has matrix with dimensions equivalent to {-src-}, then routine returns cached matrix, otherwise, it creates
 * new initialized matrix.
 *
 * @example
 * var src = _.Matrix.Make([ 2, 2 ]);
 * var cachedSrc = _.Matrix.TempBorrow2( src );
 * console.log( cachedSrc.toStr() );
 * // log :
 * // +0 +0
 * // +0 +0
 * cachedSrc.copy
 * ([
 *   1, 2,
 *   3, 4,
 * ]);
 *
 * var fromCache =  _.Matrix.TempBorrowr2( src );
 * console.log( fromCache.toStr() );
 * // log :
 * // +1 +2
 * // +3 +4
 * console.log( src.toStr() );
 * // log :
 * // +0 +0
 * // +0 +0
 *
 * @param { Matrix|Long } src - Source matrix or dimensions.
 * @returns { Matrix } - Returns instance of cached matrix or creates new matrix.
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-src-} has not valid type.
 * @static
 * @function TempBorrow2
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function TempBorrow2( src )
{
  _.assert( arguments.length === 1 );
  if( src instanceof Self )
  return Self._TempBorrow( src, src, 2 );
  else
  return Self._TempBorrow( null, src, 2 );
}

//

/**
 * Method tempBorrow2() provides temporary caching of source matrix {-src-}.
 * The cache has 4 containers with matrices. Each container has index, and the routine tempBorrow2() uses container with index 2.
 * If the cache has matrix with dimensions equivalent to {-src-}, then routine returns cached matrix, otherwise, it creates
 * new initialized matrix.
 *
 * @example
 * var src = _.Matrix.Make([ 2, 2 ]);
 * var cachedSrc = src.tempBorrow2( src );
 * console.log( cachedSrc.toStr() );
 * // log :
 * // +0 +0
 * // +0 +0
 * cachedSrc.copy
 * ([
 *   1, 2,
 *   3, 4,
 * ]);
 *
 * var fromCache =  src.tempBorrow2( src );
 * console.log( fromCache.toStr() );
 * // log :
 * // +1 +2
 * // +3 +4
 * console.log( src.toStr() );
 * // log :
 * // +0 +0
 * // +0 +0
 *
 * @param { Undefined|Matrix|Long } src - Source matrix or dimensions.
 * @returns { Matrix } - Returns instance of cached matrix or creates new matrix.
 * @method tempBorrow2
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-src-} has not valid type.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function tempBorrow2( src )
{
  _.assert( arguments.length <= 1 );
  if( src === undefined )
  src = this;
  return Self._TempBorrow( this, src, 2 );
}

//

/**
 * Static routine TempBorrow3() provides temporary caching of source matrix {-src-}.
 * The cache has 4 containers with matrices. Each container has index, and the routine TempBorrow3() uses container with index 3.
 * If the cache has matrix with dimensions equivalent to {-src-}, then routine returns cached matrix, otherwise, it creates
 * new initialized matrix.
 *
 * @example
 * var src = _.Matrix.Make([ 2, 2 ]);
 * var cachedSrc = _.Matrix.TempBorrow3( src );
 * console.log( cachedSrc.toStr() );
 * // log :
 * // +0 +0
 * // +0 +0
 * cachedSrc.copy
 * ([
 *   1, 2,
 *   3, 4,
 * ]);
 *
 * var fromCache =  _.Matrix.TempBorrowr3( src );
 * console.log( fromCache.toStr() );
 * // log :
 * // +1 +2
 * // +3 +4
 * console.log( src.toStr() );
 * // log :
 * // +0 +0
 * // +0 +0
 *
 * @param { Matrix|Long } src - Source matrix or dimensions.
 * @returns { Matrix } - Returns instance of cached matrix or creates new matrix.
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-src-} has not valid type.
 * @static
 * @function TempBorrow3
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function TempBorrow3( src )
{
  _.assert( arguments.length === 1 );
  if( src instanceof Self )
  return Self._TempBorrow( src, src, 3 );
  else
  return Self._TempBorrow( null, src, 3 );
}

//

/**
 * Method tempBorrow3() provides temporary caching of source matrix {-src-}.
 * The cache has 4 containers with matrices. Each container has index, and the routine tempBorrow3() uses container with index 3.
 * If the cache has matrix with dimensions equivalent to {-src-}, then routine returns cached matrix, otherwise, it creates
 * new initialized matrix.
 *
 * @example
 * var src = _.Matrix.Make([ 2, 2 ]);
 * var cachedSrc = src.tempBorrow3( src );
 * console.log( cachedSrc.toStr() );
 * // log :
 * // +0 +0
 * // +0 +0
 * cachedSrc.copy
 * ([
 *   1, 2,
 *   3, 4,
 * ]);
 *
 * var fromCache =  src.tempBorrow3( src );
 * console.log( fromCache.toStr() );
 * // log :
 * // +1 +2
 * // +3 +4
 * console.log( src.toStr() );
 * // log :
 * // +0 +0
 * // +0 +0
 *
 * @param { Undefined|Matrix|Long } src - Source matrix or dimensions.
 * @returns { Matrix } - Returns instance of cached matrix or creates new matrix.
 * @method tempBorrow3
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-src-} has not valid type.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function tempBorrow3( src )
{
  _.assert( arguments.length <= 1 );
  if( src === undefined )
  src = this;
  return Self._TempBorrow( this, src , 3 );
}

// --
//
// --

function ContextsForTesting( o )
{
  if( _.routineIs( arguments[ 0 ] ) )
  o = { onEach : arguments[ 0 ] };
  _.routine.options_( ContextsForTesting, o );

  if( o.formats === null )
  o.formats = [ 'Matrix', 'Vad', 'Long' ];

  if( o.dups === null )
  o.dups = [ 1, 2, 5 ];

  if( !o.dups )
  o.dups = [ 1 ];

  o.formats = _.array.as( o.formats );
  o.dups = _.array.as( o.dups );

  _.assert( _.longHasAll( o.formats, [ 'Matrix', 'Vad', 'Long' ] ) );
  _.assert( _.longIs( o.dups ) );

  let op = o;
  op.matrixMake = matrixMake;
  op.vadMake = vadMake;
  op.longMake = longMake;

  if( _.longHas( o.formats, 'Matrix' ) )
  for( let d = 0 ; d < o.dups.length ; d++ )
  {
    op.dup = o.dups[ d ];
    op.format = 'Matrix';
    op.containerMake = matrixMake;
    op.containerIs = _.matrixIs;
    op.onEach( op );
  }

  if( _.longHas( o.formats, 'Vad' ) )
  {
    op.dup = 1;
    op.format = 'Vad';
    op.containerMake = vadMake;
    op.containerIs = _.vadIs;
    op.onEach( op );
  }

  if( _.longHas( o.formats, 'Long' ) )
  {
    op.dup = 1;
    op.format = 'Long';
    op.containerMake = longMake;
    op.containerIs = _.longIs;
    op.onEach( op );
  }

  function matrixMake( src )
  {
    return _.Matrix.MakeColDup( src, op.dup );
  }

  function vadMake( src )
  {
    return _.vad.from( src );
  }

  function longMake( src )
  {
    return src;
  }

}

ContextsForTesting.defaults =
{
  onEach : null,
  formats : null,
  dups : null,
}

// --
// relations
// --

let Statics = /* qqq : split static routines. ask how */
{

  // borrow

  _TempBorrow,
  TempBorrow0,
  TempBorrow : TempBorrow1,
  TempBorrow1,
  TempBorrow2,
  TempBorrow3,

  //

  ContextsForTesting,

  // vae

  _TempMatrices : [ Object.create( null ), Object.create( null ), Object.create( null ), Object.create( null ) ],

}

// --
// declare
// --

let Extension =
{

  // borrow

  _TempBorrow,
  TempBorrow0,
  tempBorrow0,
  TempBorrow : TempBorrow1,
  tempBorrow : tempBorrow1,
  TempBorrow1,
  tempBorrow1,
  TempBorrow2,
  tempBorrow2,
  TempBorrow3,
  tempBorrow3,

  //

  ContextsForTesting,

  //

  Statics,

}

_.classExtend( Self, Extension );

})();
