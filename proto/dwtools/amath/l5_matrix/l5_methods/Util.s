(function _Util_s_() {

'use strict';

let _ = _global_.wTools;
let Parent = null;
let Self = _.Matrix;

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

    bufferConstructor = this.long.longDescriptor.type;
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
    inputTransposing : 0,
  });

  return result;
}

//

/**
 * Static routine TempBorrow0() provides temporary caching of source matrix {-src-} with index 0.
 *
 * @param { Matrix } src - Source matrix.
 * @returns { Matrix } - Returns instance of Matrix based on provided arguments.
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-src-} is not instance of Matrix.
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
  return Self._TempBorrow( src, src , 0 );
  else
  return Self._TempBorrow( null, src , 0 );
}

//

function tempBorrow0( src ) /* qqq : improve jsdoc */
{
  _.assert( arguments.length <= 1 );
  if( src === undefined )
  src = this;
  return Self._TempBorrow( this, src , 0 );
}

//

/**
 * Static routine TempBorrow1() provides temporary caching of source matrix {-src-} with index 1.
 *
 * @param { Matrix } src - Source matrix.
 * @returns { Matrix } - Returns instance of Matrix based on provided arguments.
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-src-} is not instance of Matrix.
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
  return Self._TempBorrow( src, src , 1 );
  else
  return Self._TempBorrow( null, src , 1 );
}

//

function tempBorrow1( src ) /* qqq : improve jsdoc */
{
  _.assert( arguments.length <= 1 );
  if( src === undefined )
  src = this;
  return Self._TempBorrow( this, src , 1 );
}

//

/**
 * Static routine TempBorrow2() provides temporary caching of source matrix {-src-} with index 2.
 *
 * @param { Matrix } src - Source matrix.
 * @returns { Matrix } - Returns instance of Matrix based on provided arguments.
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-src-} is not instance of Matrix.
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
  return Self._TempBorrow( src, src , 2 );
  else
  return Self._TempBorrow( null, src , 2 );
}

//

function tempBorrow2( src ) /* qqq : improve jsdoc */
{
  _.assert( arguments.length <= 1 );
  if( src === undefined )
  src = this;
  return Self._TempBorrow( this, src , 2 );
}

//

function TempBorrow3( src )
{
  _.assert( arguments.length === 1 );
  if( src instanceof Self )
  return Self._TempBorrow( src, src , 3 );
  else
  return Self._TempBorrow( null, src , 3 );
}

//

function tempBorrow3( src ) /* qqq : improve jsdoc */
{
  _.assert( arguments.length <= 1 );
  if( src === undefined )
  src = this;
  return Self._TempBorrow( this, src , 3 );
}

// --
// relations
// --

let Statics = /* qqq : split static routines. ask how */
{

  /* borrow */

  _TempBorrow,
  TempBorrow0,
  TempBorrow : TempBorrow1,
  TempBorrow1,
  TempBorrow2,
  TempBorrow3,

  /* var */

  _TempMatrices : [ Object.create( null ) , Object.create( null ) , Object.create( null ) , Object.create( null ) ],

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

  Statics,

}

_.classExtend( Self, Extension );

})();
