(function _Make_s_() {

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
const longSlice = Array.prototype.slice;

const Parent = null;
const Self = _.Matrix;

_.assert( _.object.isBasic( _.vectorAdapter ) );
_.assert( _.routineIs( Self ), 'wMatrix is not defined, please include wMatrix.s first' );

// --
// make
// --

/**
 * Static routine Make() creates a new instance of Matrix with defined dimensions {-dims-}.
 *
 * @example
 * var got = new _.Matrix.Make( [ 2, 3 ] );
 * console.log( got.toStr() );
 * // log :
 * // +0 +0 +0
 * // +0 +0 +0
 *
 * @param { Array|Number } dims - Defines dimensions of a matrix. If {-dims-} is a Number, then the square matrix is returned.
 * @returns { Matrix } - Returns the new instance of Matrix with defined dimensions.
 * @throws { Error } If {-dims-} is not Array or Number.
 * @throws { Error } If arguments.length is not 1.
 * @static
 * @function Make
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function Make( dims )
{
  let proto = Self.prototype;

  _.assert( arguments.length === 1, 'Expects single argument array {-dims-}' );
  // _.assert( _.longIs( dims ) || _.numberIs( dims ) || _.vectorAdapterIs( dims ) );

  if( !_.arrayIs( dims ) )
  {
    if( _.numberIs( dims ) )
    dims = [ dims, dims ];
    else if( _.argumentsArrayIs( dims ) || _.bufferTypedIs( dims ) )
    dims = _.array.make( dims );
    else if( _.vectorAdapterIs( dims ) )
    dims = _.array.from( dims.toLong() );
    else
    _.assert( 0, 'Expects vector {-dims-}' );
  }

  let lengthFlat = proto.ScalarsPerMatrixForDimensions( dims );
  let buffer = proto.longType.long.make( lengthFlat );
  let strides = proto.StridesFromDimensions( dims, 0 );
  let result = new proto.Self
  ({
    buffer,
    dims,
    strides,
    inputRowMajor : 1,
  });

  return result;
}

//

/**
 * Static routine MakeSquare() creates a new square matrix with data provided in buffer {-buffer-}.
 *
 * @example
 * var got = _.Matrix.MakeSquare
 * ([
 *   1, 3, 5,
 *   2, 4, 6,
 *   3, 6, 8,
 * ]);
 * console.log( got.toStr() );
 * // log :
 * // +1 +3 +5
 * // +2 +4 +6
 * // +3 +6 +8
 *
 * @param { Long|Number } buffer - Source data.
 * @returns { Matrix } - Returns a new square matrix with provided data.
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-buffer-} is not a Long or a Number.
 * @throws { Error } If {-buffer-} is not square buffer.
 * @throws { Error } If method called by instance of Matrix.
 * @static
 * @function MakeSquare
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function MakeSquare( buffer )
{
  let proto = this.Self.prototype;

  let length;
  if( _.vectorIs( buffer ) )
  length = Math.sqrt( buffer.length );
  else if( _.numberIs( buffer ) )
  length = buffer;
  else
  _.assert( 0, 'Unexpected buffer type' );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.workpiece.prototypeIs( this ) || _.constructorIs( this ) );
  _.assert( _.numberIs( length ), 'MakeSquare expects square buffer' );

  let dims = [ length, length ];
  let scalarsPerMatrix = this.ScalarsPerMatrixForDimensions( dims );

  let inputRowMajor = scalarsPerMatrix > 0 ? 1 : 0;
  if( _.numberIs( buffer ) )
  {
    inputRowMajor = 0;
    buffer = this.longType.long.make( scalarsPerMatrix );
  }

  let result = new proto.constructor
  ({
    buffer,
    dims,
    inputRowMajor,
  });

  return result;
}

//

/**
 * Static routine MakeZero() creates a new instance of Matrix filled by zero.
 *
 * @example
 * var got = new _.Matrix.MakeZero( 3 );
 * console.log( got.toStr() );
 * // log :
 * // +0 +0 +0
 * // +0 +0 +0
 * // +0 +0 +0
 *
 * @param { Long|Number } dims - Defines dimensions of a matrix. If {-dims-} is a Number, then the square matrix is returned.
 * @returns { Matrix } - Returns a new matrix with defined dimensions. The matrix is filled by zeros.
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-dims-} is not a Long or a Number.
 * @static
 * @function MakeZero
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function MakeZero( dims )
{
  let proto = this.Self.prototype;

  _.assert( arguments.length === 1, 'Expects single argument array {-dims-}' );

  if( !_.arrayIs( dims ) )
  {
    if( _.numberIs( dims ) )
    dims = [ dims, dims ];
    else if( _.argumentsArrayIs( dims ) || _.bufferTypedIs( dims ) )
    dims = _.array.make( dims );
    else if( _.vectorAdapterIs( dims ) )
    dims = _.array.from( dims.toLong() );
    else
    _.assert( 0, 'Expects vector {-dims-}' );
  }

  let lengthFlat = proto.ScalarsPerMatrixForDimensions( dims );
  let buffer = proto.longType.long.makeZeroed( lengthFlat );
  let strides = proto.StridesFromDimensions( dims, 0 );
  let result = new proto.Self
  ({
    buffer,
    dims,
    strides,
    inputRowMajor : 1,
  });

  return result;
}

//

/**
 * Static routine MakeIdentity() creates a new identity matrix with defined dimensions {-dims-}.
 *
 * @example
 * var got = new _.Matrix.MakeIdentity( 3 );
 * console.log( got.toStr() );
 * // log :
 * // +1 +0 +0
 * // +0 +1 +0
 * // +0 +0 +1
 *
 * @param { Long|Number } dims - Defines dimensions of a matrix. If {-dims-} is Number, then the square matrix is returned.
 * @returns { Matrix } - Returns a new identity matrix with defined dimensions.
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-dims-} is not a Long or a Number.
 * @static
 * @function MakeIdentity
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function MakeIdentity( dims )
{
  let proto = this.Self.prototype;

  _.assert( arguments.length === 1, 'Expects single argument' );
  // _.assert( _.longIs( dims ) || _.numberIs( dims ) );

  if( !_.arrayIs( dims ) )
  {
    if( _.numberIs( dims ) )
    dims = [ dims, dims ];
    else if( _.argumentsArrayIs( dims ) || _.bufferTypedIs( dims ) )
    dims = _.array.make( dims );
    else if( _.vectorAdapterIs( dims ) )
    dims = _.array.from( dims.toLong() );
    else
    _.assert( 0, 'Expects vector {-dims-}' );
  }

  let lengthFlat = proto.ScalarsPerMatrixForDimensions( dims );
  let strides = proto.StridesFromDimensions( dims, 0 );
  let buffer = proto.longType.long.makeZeroed( lengthFlat );
  let result = new proto.Self
  ({
    buffer,
    dims,
    strides,
    inputRowMajor : 1,
  });

  result.identity();

  return result;
}

//

/**
 * Static routine MakeIdentity2() creates a new identity matrix with dimensions `2x2`.
 * The matrix can be filled by content of source buffer {-src-}.
 *
 * @example
 * var got = new _.Matrix.MakeIdentity2();
 * console.log( got.toStr() );
 * // log :
 * // +1 +0
 * // +0 +1
 *
 * @param { Long|VectorAdapter|Matrix|Number } src - Source buffer.
 * @returns { Matrix } - Returns a new `2x2` identity matrix.
 * @throws { Error } If arguments.length is greater then 1.
 * @throws { Error } If src.length is not 4 or {-src-} is not a Number.
 * @throws { Error } If {-src-} neither is a Long, nor a VectorAdapter, nor a Matrix, nor a Number.
 * @static
 * @function MakeIdentity2
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function MakeIdentity2( src )
{
  let proto = this.Self.prototype;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  let result = proto.MakeIdentity( 2 );

  if( src )
  result.copy( src );

  return result;
}

//

/**
 * Static routine MakeIdentity3() creates a new identity matrix with dimensions `3x3`.
 * The matrix can be filled by content of source buffer {-src-}.
 *
 * @example
 * var got = new _.Matrix.MakeIdentity3();
 * console.log( got.toStr() );
 * // log :
 * // +1 +0 +0
 * // +0 +1 +0
 * // +0 +0 +1
 *
 * @param { Long|VectorAdapter|Matrix|Number } src - Source buffer.
 * @returns { Matrix } - Returns a new `3x3` identity matrix.
 * @throws { Error } If arguments.length is greater then 1.
 * @throws { Error } If src.length is not 9 or {-src-} is not a Number.
 * @throws { Error } If {-src-} neither is a Long, nor a VectorAdapter, nor a Matrix, nor a Number.
 * @static
 * @function MakeIdentity3
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function MakeIdentity3( src )
{
  let proto = this.Self.prototype;

_.assert( arguments.length === 0 || arguments.length === 1 );

  let result = proto.MakeIdentity( 3 );

  if( src )
  result.copy( src );

  return result;
}

//

/**
 * Static routine MakeIdentity4() creates a new identity matrix with dimensions `4x4`.
 * The matrix can be filled by content of source buffer {-src-}.
 *
 * @example
 * var got = new _.Matrix.MakeIdentity4();
 * console.log( got.toStr() );
 * // log :
 * // +1 +0 +0 +0
 * // +0 +1 +0 +0
 * // +0 +0 +1 +0
 * // +0 +0 +0 +1
 *
 * @param { Long|VectorAdapter|Matrix|Number } src - Source buffer.
 * @returns { Matrix } - Returns a new `4x4` identity matrix.
 * @throws { Error } If arguments.length is greater then 1.
 * @throws { Error } If src.length is not 16 or {-src-} is not a Number.
 * @throws { Error } If {-src-} neither is a Long, nor a VectorAdapter, nor a Matrix, nor a Number.
 * @static
 * @function MakeIdentity4
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function MakeIdentity4( src )
{
  let proto = this.Self.prototype;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  let result = proto.MakeIdentity( 4 );

  if( src )
  result.copy( src );

  return result;
}

//

/**
 * Static routine MakeDiagonal() creates a new instance of Matrix with diagonal values defined by buffer {-diagonal-}.
 *
 * @example
 * var got = new _.Matrix.MakeDiagonal( [ 1, 2, 3 ] );
 * console.log( got.toStr() );
 * // log :
 * // +1 +0 +0
 * // +0 +2 +0
 * // +0 +0 +3
 *
 * @param { Long|VectorAdapter } diagonal - Source data.
 * @returns { Matrix } - Returns a new instance of Matrix with provided diagonal.
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-diagonal-} is not an Array.
 * @static
 * @function MakeDiagonal
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function MakeDiagonal( diagonal )
{

  // _.assert( _.arrayIs( diagonal ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.vectorAdapterIs( diagonal ) )
  diagonal = diagonal.toLong();
  else
  _.assert( _.longIs( diagonal ) );

  /* */

  let length = diagonal.length;
  let dims = [ length, length ];
  let scalarsPerMatrix = this.ScalarsPerMatrixForDimensions( dims );
  let buffer = this.longType.long.makeZeroed( scalarsPerMatrix );
  let result = new this.Self
  ({
    buffer,
    dims,
    inputRowMajor : 1,
    strides : [ 1, length ],
  });

  result.diagonalSet( diagonal );

  return result;
}

//

/**
 * Static routine MakeSimilar() makes a new instance of source instance {-m-}.
 * The new instance has the same type of buffer as source buffer.
 * If method executes with single argument, dimensions take from the source.
 *
 * @example
 * var buffer = new I32x
 * ([
 *   1, 2, 0,
 *   0, 4, 1,
 *   1, 0, 0,
 * ]);
 *
 * var matrix = new _.Matrix
 * ({
 *   buffer,
 *   dims : [ 3, 3 ],
 *   inputRowMajor : 1,
 * });
 *
 * var got = _.Matrix.MakeSimilar( matrix );
 * console.log( got.toStr() );
 * // log :
 * // +0 +0 +0
 * // +0 +0 +0
 * // +0 +0 +0
 * console.log( got !== matrix );
 * // log : true
 * console.log( got.buffer instanceof I32x );
 * // log : true
 *
 * @param { Matrix|Long|VectorAdapter } m - Source instance.
 * @param { Array } dims - Dimensions of new instance.
 * @returns { Matrix|Long|VectorAdapter } - Returns the instance of source container with similar buffer.
 * @throws { Error } If {-m-} neither is a Matrix, nor a Long, nor a VectorAdapter.
 * @throws { Error } If {-dims-} is not an Array.
 * @throws { Error } If {-dims-} length is not two.
 * @throws { Error } If arguments.length is less then one and greater then two.
 * @throws { Error } If {-m-} is a VectorAdapter and dims[ 0 ] is not 1.
 * @static
 * @function MakeSimilar
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function MakeSimilar( m, dims )
{
  let proto = this;
  let result;

  if( dims === undefined )
  dims = proto.DimsOf( m );
  else if( dims instanceof proto.Self )
  dims = proto.DimsOf( dims );
  else if( _.vectorAdapterIs( dims ) )
  dims = _.array.from( dims.toLong() );

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.longIs( dims ) );

  /* */

  if( m instanceof Self )
  {

    let scalarsPerMatrix = Self.ScalarsPerMatrixForDimensions( dims );
    let buffer = proto.longType.long.make( m.buffer, scalarsPerMatrix );
    let strides = proto.StridesFromDimensions( dims, 0 );

    result = new m.constructor
    ({
      buffer,
      dims,
      strides,
      inputRowMajor : 1,
    });

  }
  else if( _.longIs( m ) )
  {

    _.assert( dims.length === 2 && dims[ 1 ] === 1 );
    result = proto.longType.long.makeUndefined( m, dims[ 0 ] );

  }
  else if( _.vectorAdapterIs( m ) )
  {

    _.assert( dims.length === 2 && dims[ 1 ] === 1 );
    result = m.MakeSimilar( dims[ 0 ] );

  }
  else _.assert( 0, 'unexpected type of container', _.entity.strType( m ) );

  return result;
}

//

/**
 * Method makeSimilar() makes a new instance of Matrix with initialized buffer.
 * The buffer has the same type as the matrix buffer.
 * If method executes with single argument, dimensions take from the matrix.
 *
 * @example
 * var buffer = new I32x
 * ([
 *   1, 2, 0,
 *   0, 4, 1,
 *   1, 0, 0,
 * ]);
 *
 * var matrix = new _.Matrix
 * ({
 *   buffer,
 *   dims : [ 3, 3 ],
 *   inputRowMajor : 1,
 * });
 *
 * var got = matrix.makeSimilar();
 * console.log( got.toStr() );
 * // log :
 * // +0 +0 +0
 * // +0 +0 +0
 * // +0 +0 +0
 * console.log( got !== matrix );
 * // log : true
 * console.log( got.buffer instanceof I32x );
 * // log : true
 *
 * @param { Array } dims - Dimensions of new instance.
 * @returns { Matrix } - Returns a new instance of Matrix with initialized buffer.
 * @method makeSimilar
 * @throws { Error } If {-dims-} is not an Array.
 * @throws { Error } If {-dims-} length is not two.
 * @throws { Error } If arguments.length is greater then one.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function makeSimilar( dims )
{
  let self = this;
  _.assert( arguments.length === 0 || arguments.length === 1 );
  return self.MakeSimilar( self, dims );
}

//

/**
 * Static routine MakeLine() creates a new row matrix or a new column matrix
 * in accordance to length and type of destination matrix.
 *
 * var got = _.Matrix.MakeLine
 * ({
 *   buffer : [ 1, 2, 3 ],
 *   dimension : 0,
 *   zeroing : 0,
 * });
 *
 * console.log( got.toStr() );
 * // log :
 * // +1
 * // +2
 * // +3
 *
 * @param { Aux } o - Options map.
 * @param { Long|VectorAdapter|Matrix|Number } o.buffer - Source buffer.
 * @param { Number } o.dimension - The index of dimension : 0 - column, 1 - row.
 * @param { BoolLike } o.zeroing - Enables initializing of the buffer.
 * @returns { Matrix } - Returns a row matrix or a column matrix.
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If options map {-o-} is not a Aux.
 * @throws { Error } If options map {-o-} has extra options.
 * @throws { Error } If {-o.buffer-} has not valid type.
 * @throws { Error } If {-o.buffer-} is a Matrix and the o.buffer.dims[ o.dimension ] is not 1.
 * @static
 * @function MakeLine
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function MakeLine( o )
{
  let proto = this.Self.prototype;

  _.routine.options_( MakeLine, o );
  _.assert( _.matrixIs( o.buffer ) || _.vectorIs( o.buffer ) || _.numberIs( o.buffer ) );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( o.times >= 0 );

  let offset = 0;
  let length = _.vectorIs( o.buffer ) ? o.buffer.length : o.buffer;
  let dims = null;

  /* */

  if( _.matrixIs( o.buffer ) )
  {

    _.assert( o.buffer.dims.length === 2 );
    if( o.dimension === 0 )
    _.assert( o.buffer.dims[ 1 ] === o.times );
    else if( o.dimension === 1 )
    _.assert( o.buffer.dims[ 0 ] === o.times );

    if( o.zeroing )
    {
      // o.buffer = o.buffer.dims[ o.dimension ]; aaa2 : ? /* Dmytro : the first version of routine had many not optimal features like this */
      // length = o.buffer;
      length = o.buffer.dims[ o.dimension ];
    }
    else
    {
      _.assert( o.times === 1 );
      return o.buffer; /* zzz : check! */
    }

  }

  /* */

  if( o.zeroing )
  {
    o.buffer = this.longType.long.makeZeroed( length );
  }
  else
  {
    if( _.numberIs( o.buffer ) )
    {
      o.buffer = this.longType.long.make( length * o.times );
    }
    else if( _.argumentsArrayIs( o.buffer ) )
    {
      debugger;
      if( o.times === 1 )
      {
        o.buffer = proto.longType.long.make( o.buffer );
      }
      else
      {
        _.assert( 0, 'not tested' ); /* qqq2 : cover */
        let buffer = proto.longType.long.makeUndefined( length * o.times );
        o.buffer = _.longDuplicate
        ({
          dst : buffer,
          src : o.buffer,
          nDupsPerElement : o.times,
          nScalarsPerElement : o.buffer.length,
        });
      }
    }
    else
    {
      // if( o.times !== 1 )
      // debugger;
      if( o.times !== 1 )
      o.buffer = _.longDuplicate
      ({
        src : o.buffer,
        nDupsPerElement : o.times,
        nScalarsPerElement : o.buffer.length,
      });
    }
  }

  /* dims */

  if( o.dimension === 0 )
  {
    dims = [ length, o.times ];
  }
  else if( o.dimension === 1 )
  {
    dims = [ o.times, length ];
  }
  else _.assert( 0, 'bad dimension', o.dimension );

  /* */

  let result = new proto.constructor
  ({
    buffer : o.buffer,
    dims,
    offset,
    inputRowMajor : 0,
  });

  return result;
}

MakeLine.defaults =
{
  buffer : null,
  dimension : -1,
  zeroing : 1,
  times : 1, /* qqq2 : cover option times */
}

//

/**
 * Static routine MakeCol() creates new column matrix from buffer {-buffer-}.
 * If {-buffer-} is a Number, then it defines length of new column matrix.
 *
 * @example
 * var got = _.Matrix.MakeCol( 3 );
 * console.log( got.toStr() );
 * // log :
 * // +0
 * // +0
 * // +0
 *
 * @example
 * var got = _.Matrix.MakeCol( [ 1, 2, 0 ] );
 * console.log( got.toStr() );
 * // log :
 * // +1
 * // +2
 * // +0
 *
 * @example
 * var buffer = _.vectorAdapter.fromLong( [ -2, +0, -0.25 ] )
 * var got = _.Matrix.MakeCol( buffer );
 * console.log( got.toStr() );
 * // log :
 * // -2.000
 * //  0.000
 * // -0.250
 *
 * @param { VectorAdapter|Matrix|Long|Number } buffer - Source buffer.
 * @returns { Matrix|VectorAdapter } - Returns a new column matrix.
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-buffer-} has not valid type.
 * @throws { Error } If {-buffer-} is a Matrix, and buffer.dims[ 1 ] is not 1.
 * @static
 * @function MakeCol
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function MakeCol( buffer )
{
  _.assert( arguments.length === 1, 'Expects single argument {-buffer-}' );

  return this.MakeLine
  ({
    buffer,
    zeroing : 0,
    dimension : 0,
  });
}

//

/**
 * Static routine MakeColZeroed() creates new column matrix with initialized buffer.
 * The column matrix creates from source buffer {-buffer-}.
 * If {-buffer-} is a Number, then it defines length of new column matrix.

 *
 * @example
 * var got = _.Matrix.MakeColZeroed( 3 );
 * console.log( got.toStr() );
 * // log :
 * // +0
 * // +0
 * // +0
 *
 * @example
 * var got = _.Matrix.MakeColZeroed( [ 1, 2, 0 ] );
 * console.log( got.toStr() );
 * // log :
 * // +0
 * // +0
 * // +0
 *
 * @example
 * var buffer = _.vectorAdapter.fromLong( [ -2, +0, -0.25 ] )
 * var got = _.Matrix.MakeColZeroed( buffer );
 * console.log( got.toStr() );
 * // log :
 * // +0
 * // +0
 * // +0
 *
 * @param { VectorAdapter|Matrix|Long|Number } buffer - Source buffer.
 * @returns { Matrix } - Returns a new column matrix with initialized buffer.
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-buffer-} has not valid type.
 * @throws { Error } If {-buffer-} is a Matrix, and buffer.dims[ 1 ] is not 1.* @static
 * @function MakeColZeroed
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function MakeColZeroed( buffer )
{
  _.assert( arguments.length === 1, 'Expects single argument {-buffer-}' );

  return this.MakeLine
  ({
    buffer,
    zeroing : 1,
    dimension : 0,
  });
}

//

function MakeColDup( buffer, times )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );

  return this.MakeLine
  ({
    buffer,
    zeroing : 0,
    dimension : 0,
    times : times,
  });
}

//

/**
 * Static routine MakeRow() creates a new row matrix from source buffer {-buffer-}.
 * If {-buffer-} is a Number, then it defines length of new row matrix.
 *
 * @example
 * var got = _.Matrix.MakeRow( 3 );
 * console.log( got.toStr() );
 * // log : +0, +0, +0,
 *
 * @example
 * var got = _.Matrix.MakeRow( [ 1, 2, 0 ] );
 * console.log( got.toStr() );
 * // log : +1, +2, +0,
 *
 * @example
 * var buffer = _.vectorAdapter.fromLong( [ -2, +0, -0.25 ] )
 * var got = _.Matrix.MakeRow( buffer );
 * console.log( got.toStr() );
 * // log : -2.000, 0.000, -0.250,
 *
 * @param { VectorAdapter|Array|BufferTyped|Matrix|Number } buffer - Source buffer.
 * @returns { Matrix|VectorAdapter } - Returns a new row matrix.
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-buffer-} has not valid type.
 * @throws { Error } If {-buffer-} is a Matrix, and buffer.dims[ 0 ] is not 1.
 * @static
 * @function MakeRow
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function MakeRow( buffer )
{
  _.assert( arguments.length === 1, 'Expects single argument {-buffer-}' );

  return this.MakeLine
  ({
    buffer,
    zeroing : 0,
    dimension : 1,
  });
}

//

/**
 * Static routine MakeRowZeroed() creates a new row matrix with initialized buffer.
 * The row matrix creates from source buffer {-buffer-}.
 * If {-buffer-} is a Number, then it defines length of new row matrix.
 *
 * @example
 * var got = _.Matrix.MakeRowZeroed( 3 );
 * console.log( got.toStr() );
 * // log : +0, +0, +0,
 *
 * @example
 * var got = _.Matrix.MakeRowZeroed( [ 1, 2, 0 ] );
 * console.log( got.toStr() );
 * // log : +1, +2, +0,
 *
 * @example
 * var buffer = _.vectorAdapter.fromLong( [ -2, +0, -0.25 ] )
 * var got = _.Matrix.MakeRowZeroed( buffer );
 * console.log( got.toStr() );
 * // log : -2.000, 0.000, -0.250,
 *
 * @param { VectorAdapter|Array|BufferTyped|Matrix|Number } buffer - Source buffer.
 * @returns { Matrix|VectorAdapter } - Returns a new row matrix with initialized buffer.
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-buffer-} has not valid type.
 * @throws { Error } If {-buffer-} is a Matrix, and buffer.dims[ 0 ] is not 1.
 * @static
 * @function MakeRowZeroed
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function MakeRowZeroed( buffer )
{
  _.assert( arguments.length === 1, 'Expects single argument {-buffer-}' );

  return this.MakeLine
  ({
    buffer,
    zeroing : 1,
    dimension : 1,
  });
}

//

function MakeRowDup( buffer, times )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );

  return this.MakeLine
  ({
    buffer,
    zeroing : 0,
    dimension : 1,
    times : times,
  });
}

// --
// converter
// --

/**
 * Static routine ConvertToClass() converts source instance {-src-} to instance of destination class {-cls-}.
 * If constructor of {-src-} and constructor {-cls-} are the same constructor, then routine returns instance without conversion.
 * If {-src-} is an instance of Matrix, then it can be converted to Array, BufferTyped, VectorAdapter. Other instances can be
 * converted to Matrix, Array, BufferTyped, VectorAdapter.
 *
 * @example
 * var src = [ 1, 2 ];
 * var got = _.Matrix.ConvertToClass( _.Matrix, src );
 * console.log( got.toStr() );
 * // log :
 * // +1
 * // +2
 *
 * @param { Function } cls - Constructor of destination class.
 * @param { Matrix|VectorAdapter|Long } src - An instance for converting.
 * @returns { Matrix|VectorAdapter|Array|BufferTyped } - Returns converted instance.
 * @throws { Error } If arguments.length is not 2.
 * @throws { Error } If {-cls-} is not a constructor of class.
 * @throws { Error } If {-cls-} is not valid constructor.
 * @throws { Error } If {-src-} has incompatible type.
 * @static
 * @function ConvertToClass
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function ConvertToClass( cls, src )
{
  let proto = this;

  _.assert( _.constructorIs( cls ) );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( src.constructor === cls )
  return src;

  let result;
  if( _.matrixIs( src ) )
  {

    if( _.class.isSubClassOf( cls, src.Self ) )
    {
      _.assert( src.Self === cls, 'not tested' );
      return src;
    }

    _.assert( src.dims.length === 2 );
    _.assert( src.dims[ 1 ] === 1 );

    let array;
    let scalarsPerMatrix = src.scalarsPerMatrix;

    if( _.constructorLikeArray( cls ) )
    {
      result = new cls( scalarsPerMatrix );
      array = result;
    }
    else if( _.constructorIsVad( cls ) )
    {
      array = new src.buffer.constructor( scalarsPerMatrix );
      result = proto.vectorAdapter.fromLong( array );
    }
    else _.assert( 0, 'Unknown class {-cls-}', cls.name );

    for( let i = 0 ; i < result.length ; i += 1 )
    array[ i ] = src.scalarGet([ i, 0 ]);

  }
  else
  {

    let scalarsPerMatrix = src.length;
    src = proto.vectorAdapter.from( src );

    if( _.constructorIsMatrix( cls ) )
    {
      let buffer = new src._vectorBuffer.constructor( scalarsPerMatrix );
      let dims = [ src.length, 1 ];
      let strides = proto.StridesFromDimensions( dims, 0 );
      result = new cls
      ({
        dims,
        buffer,
        strides,
        inputRowMajor : 1,
      });
      for( let i = 0 ; i < src.length ; i += 1 )
      result.scalarSet( [ i, 0 ], src.eGet( i ) );
    }
    else if( _.constructorLikeArray( cls ) )
    {
      result = new cls( scalarsPerMatrix );
      for( let i = 0 ; i < src.length ; i += 1 )
      result[ i ] = src.eGet( i );
    }
    else if( _.constructorIsVad( cls ) )
    {
      let array = new src._vectorBuffer.constructor( scalarsPerMatrix );
      result = proto.vectorAdapter.fromLong( array );
      for( let i = 0 ; i < src.length ; i += 1 )
      array[ i ] = src.eGet( i );
    }
    else _.assert( 0, 'Unknown class {-cls-}', cls.name );

  }

  return result;
}

//

/**
 * Static routine FromVector() converts provided vector {-src-} to a column matrix.
 *
 * @example
 * var src = _.vectorAdapter.fromLong( [ 1, 2, 3 ] );
 * var got = _.Matrix.FromVector( src );
 * console.log( got.toStr() );
 * // log :
 * // +1
 * // +2
 * // +3
 *
 * @param { VectorAdapter|Long } src - Source vector.
 * @returns { Matrix } - Returns the new instance of Matrix.
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-src-} is not a VectorAdapter or Long.
 * @static
 * @function FromVector
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function FromVector( src )
{
  let result;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.vectorAdapterIs( src ) )
  {
    let buffer = src._vectorBuffer; /* Dmytro : duplicates buffer which is maiden by fromNumber */
    if( src.length > src._vectorBuffer.length )
    {
      buffer = _.long.makeUndefined( buffer, src.length );
      buffer = _.longFill( buffer, src._vectorBuffer );
    }

    result = new this.Self
    ({
      buffer,
      dims : [ src.length, 1 ],
      offset : src.offset !== 0 ? src.offset : 0,
      strides : src.stride > 1 ? [ src.stride, 1 ] : [ 1, src.length ],
      inputRowMajor : 1,
    });
  }
  else if( _.longIs( src ) )
  {
    result = new this.Self
    ({
      buffer : src,
      dims : [ src.length, 1 ],
      strides : [ 1, src.length ],
      inputRowMajor : 1,
    });
  }
  else _.assert( 0, 'cant convert', _.entity.strType( src ), 'to Matrix' );

  return result;
}

//

/**
 * Static routine FromScalar() creates new instance of matrix with defined dimensions {-dims-}.
 * The matrix fills by scalar {-scalar-}.
 *
 * @example
 * var got = _.Matrix.FromScalar( 2, [ 3, 3 ] );
 * console.log( got.toStr() );
 * // log :
 * // +2 +2 +2
 * // +2 +2 +2
 * // +2 +2 +2
 *
 * @param { Number } scalar - Source scalar.
 * @param { Array } dims - Dimensions of matrix.
 * @returns { Matrix } - Returns a new instance of Matrix filled by scalar value.
 * @throws { Error } If arguments.length is not 2.
 * @throws { Error } If {-scalar-} is not a Number.
 * @throws { Error } If {-dims-} is not an Array.
 * @static
 * @function FromScalar
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function FromScalar( scalar, dims ) /* aaa2 : can accept scalar without dims! */ /* Dmytro : implemented */
{

  if( arguments.length === 1 )
  dims = [ 1, 1 ];
  else if( arguments.length === 2 )
  _.assert( _.longIs( dims ) || _.vectorAdapterIs( dims ) );
  else
  _.assert( 0, 'Expects one or two arguments' );

  _.assert( _.numberIs( scalar ) );

  if( !_.arrayIs( dims ) && !_.bufferTypedIs( dims ) )
  {
    if( _.argumentsArrayIs( dims ) )
    dims = _.array.make( dims );
    else if( _.vectorAdapterIs( dims ) )
    dims = dims.toLong();
    // dims = _.array.from( dims.toLong() );
    else
    _.assert( 0, `Expects vector {-dims-}, but got ${_.entity.strType( dims )}` );
  }

  // debugger;
  // let buffer = this.longType.longFrom( _.dup( scalar, this.ScalarsPerMatrixForDimensions( dims ) ) );
  let buffer = this.longType.long.makeUndefined( this.ScalarsPerMatrixForDimensions( dims ) );
  _.longFill( buffer, scalar );
  // let strides = this.StridesFromDimensions( dims, 0 );

  let result = new this.Self
  ({
    buffer,
    dims,
    // strides,
    inputRowMajor : 0,
  });

  return result;
}

//

/**
 * Static routine FromScalarForReading() creates new instance of matrix filled by scalar {-scalar-}.
 * The instance does not contain equivalent buffer but only a single element buffer for reading.
 *
 * @example
 * var got = _.Matrix.FromScalarForReading( 2, [ 3, 3 ] );
 * console.log( got.toStr() );
 * // log :
 * // +2 +2 +2
 * // +2 +2 +2
 * // +2 +2 +2
 * console.log( got.buffer.length );
 * // log : 1
 *
 * @param { Number } scalar - Source scalar.
 * @param { Array } dims - Dimensions of matrix.
 * @returns { Matrix } - Returns a new instance of Matrix with specified dimension.
 * The matrix is read-only, it contains a single element buffer.
 * @throws { Error } If arguments.length is not 2.
 * @throws { Error } If {-scalar-} is not a Number.
 * @throws { Error } If {-dims-} is not an Array.
 * @static
 * @function FromScalarForReading
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function FromScalarForReading( scalar, dims )
{

  if( arguments.length === 1 )
  dims = [ 1, 1 ];
  else if( arguments.length === 2 )
  _.assert( _.longIs( dims ) || _.vectorAdapterIs( dims ) );
  else
  _.assert( 0, 'Expects one or two arguments' );

  _.assert( _.numberIs( scalar ) );

  if( !_.arrayIs( dims ) && !_.bufferTypedIs( dims ) )
  {
    if( _.argumentsArrayIs( dims ) )
    dims = _.array.make( dims );
    else if( _.vectorAdapterIs( dims ) )
    dims = dims.toLong();
    else
    _.assert( 0, 'Expects vector {-dims-}' );
  }

  let buffer = this.longType.long.make( 1 );
  buffer[ 0 ] = scalar;

  let result = new this.Self
  ({
    buffer,
    dims,
    strides : _.dup( 0, dims.length ),
  });

  return result;
}

//

/**
 * Static routine From() converts source instance {-src-} to instance of Matrix.
 * If {-src-} is an instance of Matrix, then routine returns original source matrix.
 * If {-src-} is null, then routine returns instance of matrix filled by zeros.
 *
 * @example
 * var got = _.Matrix.From( null, [ 3, 3 ] );
 * console.log( got.toStr() );
 * // log :
 * // +0 +0 +0
 * // +0 +0 +0
 * // +0 +0 +0
 *
 * @example
 * var src = _.Matrix.MakeSquare
 * ([
 *   +1, +2, +3,
 *   +0, +4, +5,
 *   +0, +0, +6,
 * ]);
 * var got = _.Matrix.From( src, [ 3, 3 ] );
 * console.log( got.toStr() );
 * // log :
 * // +1 +2 +3
 * // +0 +4 +5
 * // +0 +0 +6
 *
 * @param { Matrix|VectorAdapter|Long|Number|Null } src - Source instance.
 * @param { Array|Undefined } dims - Dimension of matrix.
 * @returns { Matrix } - Returns an instance of Matrix converted from source instance {-src-}.
 * @throws { Error } If arguments.length is less then 1 or greater then 2.
 * @throws { Error } If {-dims-} neither is an Array nor Undefined.
 * @throws { Error } If {-src-} is Null and {-dims-} is Undefined.
 * @throws { Error } If {-src-} is a Number and {-dims-} is Undefined.
 * @throws { Error } If {-src-} has not valid type.
 * @static
 * @function From
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function From( src, dims )
{
  let result;

  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( !_.arrayIs( dims ) )
  {
    if( _.argumentsArrayIs( dims ) || _.bufferTypedIs( dims ) )
    dims = _.array.make( dims );
    else if( _.vectorAdapterIs( dims ) )
    dims = _.array.from( dims.toLong() );
    else if( dims !== undefined )
    _.assert( 0, 'Expects vector {-dims-} or undefined' );
  }

  if( src === null )
  {
    _.assert( _.arrayIs( dims ) );
    result = this.MakeZero( dims );
  }
  else if( src instanceof Self )
  {
    result = src;
  }
  else if( _.numberIs( src ) )
  {
    _.assert( _.arrayIs( dims ) );
    result = this.FromScalar( src, dims );
  }
  else
  {
    result = this.FromVector( src );
  }

  _.assert( !dims || _.long.identical( result.dims, dims ) );

  return result;
}

//

/**
 * Static routine FromForReading() converts source instance {-src-} to instance of Matrix.
 * If {-src-} is an instance of Matrix, then routine returns original source matrix.
 * If {-src-} is a Number, then routine returns read-only instance of matrix.
 *
 * @example
 * var got = _.Matrix.FromForReading( null, [ 3, 3 ] );
 * console.log( got.toStr() );
 * // log :
 * // +0 +0 +0
 * // +0 +0 +0
 * // +0 +0 +0
 *
 * var got = _.Matrix.FromForReading( 2, [ 3, 3 ] );
 * console.log( got.toStr() );
 * // log :
 * // +2 +2 +2
 * // +2 +2 +2
 * // +2 +2 +2
 * console.log( got.buffer.length );
 * // log : 1
 *
 * @param { Matrix|VectorAdapter|Long|Number } src - Source instance.
 * @param { Array|Undefined } dims - Dimension of matrix.
 * @returns { Matrix } - Returns an instance of Matrix converted from source instance {-src-}.
 * @throws { Error } If arguments.length is less then 1 or greater then 2.
 * @throws { Error } If {-dims-} neither is an Array nor Undefined.
 * @throws { Error } If {-src-} is a Number and {-dims-} is Undefined.
 * @throws { Error } If {-src-} has not valid type.
 * @static
 * @function FromForReading
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function FromForReading( src, dims )
{
  let result;

  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( !_.arrayIs( dims ) )
  {
    if( _.argumentsArrayIs( dims ) || _.bufferTypedIs( dims ) )
    dims = _.array.make( dims );
    else if( _.vectorAdapterIs( dims ) )
    dims = _.array.from( dims.toLong() );
    else if( dims !== undefined )
    _.assert( 0, 'Expects vector {-dims-} or undefined' );
  }

  if( src instanceof Self )
  {
    result = src;
  }
  else if( _.numberIs( src ) )
  {
    _.assert( _.arrayIs( dims ) );
    result = this.FromScalarForReading( src, dims );
  }
  else
  {
    result = this.FromVector( src );
  }

  _.assert( !dims || _.long.identical( result.dims, dims ) );

  return result;
}

//

/**
 * Static routine ColFrom() converts provided vector {-src-} to a column matrix.
 * If {-src-} is a column matrix, then routine returns original matrix.
 *
 * @example
 * var src = _.vectorAdapter.fromLong( [ 1, 2, 3 ] );
 * var got = _.Matrix.ColFrom( src );
 * console.log( got.toStr() );
 * // log :
 * // Matrix.Array.3x1 ::
 * // +1
 * // +2
 * // +3
 *
 * @param { Long|VectorAdapter|Matrix|Number } src - Source vector.
 * @returns { Matrix } - Returns the new instance of Matrix.
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-src-} has not valid type.
 * @throws { Error } If {-src-} is a Matrix and has more than two dimensions.
 * @throws { Error } If {-src-} is a flat matrix and number of columns is not equal to 1.
 * @static
 * @function ColFrom
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function ColFrom( src )
{
  let result;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.matrixIs( src ) )
  {
    _.assert( src.dims.length === 2, 'Expects flat matrix {-src-}' );
    _.assert( src.dims[ 1 ] === 1, 'Expects column matrix {-src-}' );

    return src;
  }
  else if( _.vectorIs( src ) )
  {
    return this.MakeLine
    ({
      buffer : src,
      zeroing : 0,
      dimension : 0,
    });
  }
  else if( _.numberIs( src ) )
  {
    let buffer = this.longType.long.make( 1 );
    buffer[ 0 ] = src;

    return this.MakeLine
    ({
      buffer,
      zeroing : 0,
      dimension : 0,
    });
  }
  else _.assert( 0, `Can't convert ${ _.entity.strType( src ) } to Matrix` );
}

//

/**
 * Static routine RowFrom() converts provided vector {-src-} to a row matrix.
 * If {-src-} is a row matrix, then routine returns original matrix.
 *
 * @example
 * var src = _.vectorAdapter.fromLong( [ 1, 2, 3 ] );
 * var got = _.Matrix.RowFrom( src );
 * console.log( got.toStr() );
 * // log :
 * // Matrix.Array.1x3 ::
 * // +1 +2 +3
 *
 * @param { Long|VectorAdapter|Matrix|Number } src - Source vector.
 * @returns { Matrix } - Returns the new instance of Matrix.
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-src-} has not valid type.
 * @throws { Error } If {-src-} is a Matrix and has more than two dimensions.
 * @throws { Error } If {-src-} is a flat matrix and number of rows is not equal to 1.
 * @static
 * @function RowFrom
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function RowFrom( src )
{
  let result;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.matrixIs( src ) )
  {
    _.assert( src.dims.length === 2, 'Expects flat matrix {-src-}' );
    _.assert( src.dims[ 0 ] === 1, 'Expects row matrix {-src-}' );

    return src;
  }
  else if( _.vectorIs( src ) )
  {
    return this.MakeLine
    ({
      buffer : src,
      zeroing : 0,
      dimension : 1,
    });
  }
  else if( _.numberIs( src ) )
  {
    let buffer = this.longType.long.make( 1 );
    buffer[ 0 ] = src;

    return this.MakeLine
    ({
      buffer,
      zeroing : 0,
      dimension : 1,
    });
  }
  else _.assert( 0, `Can't convert ${ _.entity.strType( src ) } to Matrix` );
}

// --
// transformation
// --

/**
 * The method FromTransformations() converts provided position {-position-}, quaternion {-quaternion-}, scale {-scale-} values
 * and applies it to destination matrix {-dst-}.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   +1, +2, +3, +1,
 *   +0, +4, +5, +1,
 *   +0, +0, +6, +1,
 *   +0, +0, +6, +1,
 * ]);
 *
 * var position = [ 1, 2, 3 ];
 * var quaternion = [ 0, 0, 0, 1 ];
 * var scale = [ 1, 1, 1 ];
 * var got = _.Matrix.FromTransformations( matrix, position, quaternion, scale );
 * console.log( got.toStr() );
 * // log :
 * // +1 +0 +0 +1
 * // +0 +1 +0 +2
 * // +0 +0 +1 +3
 * // +0 +0 +0 +1
 *
 * @param { Matrix|Null } dst - Destination matrix.
 * @param { VectorAdapter|Long } position - Position.
 * @param { VectorAdapter|Long } quaternion - Quaternion.
 * @param { VectorAdapter|Long } scale - Scale.
 * @returns { Matrix } - Returns destination matrix with result of transformation by quaternion, scale and position.
 * @method FromTransformations
 * @throws { Error } If arguments.length is less then 3 or greater then 4.
 * @throws { Error } If {-dst-} is not square matrix `4x4`.
 * @throws { Error } If quaternion.length is not 4.
 * @throws { Error } If scale.length is not 3.
 * @throws { Error } If position.length is not 3.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function FromTransformations( dst, position, quaternion, scale )
{

  if( arguments.length === 3 )
  {
    dst = this.MakeSquare( 4 );
    position = arguments[ 0 ];
    quaternion = arguments[ 1 ];
    scale = arguments[ 2 ];
  }
  else if( arguments.length === 4 )
  {
    if( dst === null )
    dst = this.MakeSquare( 4 );
    else
    dst = this.From( dst );
  }
  else
  {
    _.assert( 0, 'Expects 3 or 4 arguments' );
  }

  dst.fromQuat( quaternion );
  dst.scaleApply( scale );
  dst.positionSet( position );

  return dst;
}

//

/**
 * The method fromTransformations() converts provided position {-position-}, quaternion {-quaternion-}, scale {-scale-} values
 * to the new instance of Matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   +1, +2, +3, +1,
 *   +0, +4, +5, +1,
 *   +0, +0, +6, +1,
 *   +0, +0, +6, +1,
 * ]);
 *
 * var position = [ 1, 2, 3 ];
 * var quaternion = [ 0, 0, 0, 1 ];
 * var scale = [ 1, 1, 1 ];
 * var got = matrix.fromTransformations( position, quaternion, scale );
 * console.log( got.toStr() );
 * // log :
 * // +1 +0 +0 +1
 * // +0 +1 +0 +2
 * // +0 +0 +1 +3
 * // +0 +0 +0 +1
 *
 * @param { VectorAdapter|Long } position - Position.
 * @param { VectorAdapter|Long } quaternion - Quaternion.
 * @param { VectorAdapter|Long } scale - Scale.
 * @returns { Matrix } - Returns current matrix with result of transformation by quaternion, scale and position.
 * @method fromTransformations
 * @throws { Error } If current matrix is not square matrix `4x4`.
 * @throws { Error } If quaternion.length is not 4.
 * @throws { Error } If scale.length is not 3.
 * @throws { Error } If position.length is not 3.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function fromTransformations( position, quaternion, scale )
{
  let self = this;

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );

  return Self.FromTransformations( self, position, quaternion, scale );
}

//

/**
 * The method fromQuat() transforms current matrix by using quaternion {-quaternion-} transformation.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   +1, +2, +3, +1,
 *   +0, +4, +5, +1,
 *   +0, +0, +6, +1,
 *   +0, +0, +6, +1,
 * ]);
 *
 * var quaternion = [ 0, 0, 0, 1 ];
 * var got = matrix.fromQuat( quaternion );
 * console.log( got.toStr() );
 * // log :
 * // +1 +0 +0 +0
 * // +0 +1 +0 +0
 * // +0 +0 +1 +0
 * // +0 +0 +0 +1
 *
 * @param { VectorAdapter|Long } quaternion - The quaternion to make transformation.
 * @returns { Matrix } - Returns original matrix with transformed scalars.
 * @method fromQuat
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If length of a row of current matrix is less than 3.
 * @throws { Error } If number of columns of current matrix is less than 3.
 * @throws { Error } If quaternion.length is not 4.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function fromQuat( q )
{
  let self = this;

  q = self.vectorAdapter.from( q );
  let w = q.eGet( 0 );
  let x = q.eGet( 1 );
  let y = q.eGet( 2 );
  let z = q.eGet( 3 );
  // let x = q.eGet( 0 );
  // let y = q.eGet( 1 );
  // let z = q.eGet( 2 );
  // let w = q.eGet( 3 );

  _.assert( self.scalarsPerElement >= 3 );
  _.assert( self.length >= 3 );
  _.assert( q.length === 4 );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let x2 = x + x, y2 = y + y, z2 = z + z;
  let xx = x * x2, xy = x * y2, xz = x * z2;
  let yy = y * y2, yz = y * z2, zz = z * z2;
  let wx = w * x2, wy = w * y2, wz = w * z2;

  self.scalarSet( [ 0, 0 ] , 1 - ( yy + zz ) );
  self.scalarSet( [ 0, 1 ] , xy - wz );
  self.scalarSet( [ 0, 2 ] , xz + wy );

  self.scalarSet( [ 1, 0 ] , xy + wz );
  self.scalarSet( [ 1, 1 ] , 1 - ( xx + zz ) );
  self.scalarSet( [ 1, 2 ] , yz - wx );

  self.scalarSet( [ 2, 0 ] , xz - wy );
  self.scalarSet( [ 2, 1 ] , yz + wx );
  self.scalarSet( [ 2, 2 ] , 1 - ( xx + yy ) );

  if( self.dims[ 0 ] > 3 )
  {
    self.scalarSet( [ 3, 0 ] , 0 );
    self.scalarSet( [ 3, 1 ] , 0 );
    self.scalarSet( [ 3, 2 ] , 0 );
    self.scalarSet( [ 0, 3 ], 0 );
    self.scalarSet( [ 1, 3 ], 0 );
    self.scalarSet( [ 2, 3 ], 0 );
    self.scalarSet( [ 3, 3 ], 1 );
  }

  return self;
}

//

/**
 * The method fromQuatWithScale() transforms current matrix by using quaternion {-quaternion-} transformation.
 * The scalars are transformed by using scale calculated from quaternion.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   +1, +2, +3, +1,
 *   +0, +4, +5, +1,
 *   +0, +0, +6, +1,
 *   +0, +0, +6, +1,
 * ]);
 *
 * var quaternion = [ 0, 2, 1, 1 ];
 * var got = matrix.fromQuatWithScale( quaternion );
 * console.log( got.toStr() );
 * // log :
 * // -1.633 -0.816 +1.633 +0.000
 * // +0.816 +1.633 +1.633 +0.000
 * // -1.633 +1.633 -0.816 +0.000
 * // +0.000 +0.000 +0.000 +1.000
 *
 * @param { VectorAdapter|Long } q - The quaternion to make transformation.
 * @returns { Matrix } - Returns original matrix with transformed scalars.
 * @method fromQuatWithScale
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If length of a row of current matrix is less than 3.
 * @throws { Error } If number of columns of current matrix is less than 3.
 * @throws { Error } If quaternion.length is not 4.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function fromQuatWithScale( q )
{
  let self = this;

  q = self.vectorAdapter.from( q );
  let m = q.mag();
  let x = q.eGet( 0 ) / m;
  let y = q.eGet( 1 ) / m;
  let z = q.eGet( 2 ) / m;
  let w = q.eGet( 3 ) / m;

  _.assert( self.scalarsPerElement >= 3 );
  _.assert( self.length >= 3 );
  _.assert( q.length === 4 );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let x2 = x + x, y2 = y + y, z2 = z + z;
  let xx = x * x2, xy = x * y2, xz = x * z2;
  let yy = y * y2, yz = y * z2, zz = z * z2;
  let wx = w * x2, wy = w * y2, wz = w * z2;

  self.scalarSet( [ 0, 0 ] , m*( 1 - ( yy + zz ) ) );
  self.scalarSet( [ 0, 1 ] , m*( xy - wz ) );
  self.scalarSet( [ 0, 2 ] , m*( xz + wy ) );

  self.scalarSet( [ 1, 0 ] , m*( xy + wz ) );
  self.scalarSet( [ 1, 1 ] , m*( 1 - ( xx + zz ) ) );
  self.scalarSet( [ 1, 2 ] , m*( yz - wx ) );

  self.scalarSet( [ 2, 0 ] , m*( xz - wy ) );
  self.scalarSet( [ 2, 1 ] , m*( yz + wx ) );
  self.scalarSet( [ 2, 2 ] , m*( 1 - ( xx + yy ) ) );

  if( self.dims[ 0 ] > 3 )
  {
    self.scalarSet( [ 3, 0 ] , 0 );
    self.scalarSet( [ 3, 1 ] , 0 );
    self.scalarSet( [ 3, 2 ] , 0 );
    self.scalarSet( [ 0, 3 ], 0 );
    self.scalarSet( [ 1, 3 ], 0 );
    self.scalarSet( [ 2, 3 ], 0 );
    self.scalarSet( [ 3, 3 ], 1 );
  }

  return self;
}

//

/**
 * The method fromAxisAndAngle() calculates 3D coordinates of a dot by using axis values {-axis-} and angle {-angle-}.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   +1, +2, +3,
 *   +0, +4, +5,
 *   +0, +0, +6,
 * ]);
 *
 * var axis = [ 1, 4, 5 ];
 * var got = matrix.fromAxisAndAngle( axis, 30 );
 * console.log( got.toStr() );
 * // log :
 * //  1.000 8.323  0.277
 * // -1.557 13.686 17.903
 * //  8.181 15.927 21.298
 *
 * @param { VectorAdapter|Long } axis - The value for each axis.
 * @param { Number } angle - An angle in 3D space.
 * @returns { Matrix } - Returns original matrix with transformed scalars.
 * @method fromAxisAndAngle
 * @throws { Error } If arguments.length is not 2.
 * @throws { Error } If axis.length is not 3.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function fromAxisAndAngle( axis, angle )
{
  let self = this;
  axis = self.vectorAdapter.from( axis );

  // let m = axis.mag();
  // debugger;

  let x = axis.eGet( 0 );
  let y = axis.eGet( 1 );
  let z = axis.eGet( 2 );

  _.assert( axis.length === 3 );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let s = Math.sin( angle );
  let c = Math.cos( angle );
  let t = 1 - c;

  let m00 = c + x*x*t;
  let m11 = c + y*y*t;
  let m22 = c + z*z*t;

  let a = x*y*t;
  let b = z*s;

  let m10 = a + b;
  let m01 = a - b;

  a = x*z*t;
  b = y*s;

  let m20 = a - b;
  let m02 = a + b;

  a = y*z*t;
  b = x*s;

  let m21 = a + b;
  let m12 = a - b;

  self.scalarSet( [ 0, 0 ], m00 );
  self.scalarSet( [ 1, 0 ], m10 );
  self.scalarSet( [ 2, 0 ], m20 );

  self.scalarSet( [ 0, 1 ], m01 );
  self.scalarSet( [ 1, 1 ], m11 );
  self.scalarSet( [ 2, 1 ], m21 );

  self.scalarSet( [ 0, 2 ], m02 );
  self.scalarSet( [ 1, 2 ], m12 );
  self.scalarSet( [ 2, 2 ], m22 );

  return self;
}

//

/**
 * The method fromAxisAndAngleWithScale() calculates 3D coordinates of a dot by using axis values {-axis-} and angle {-angle-}.
 * The routine calculates scale from {-axis-} and uses it in calculation of coordinates.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   +1, +2, +3,
 *   +0, +4, +5,
 *   +0, +0, +6,
 * ]);
 *
 * var axis = [ 1, 4, 5 ];
 * var got = matrix.fromAxisAndAngleWithScale( axis, 30 );
 * console.log( got.toStr() );
 * // log :
 * //  1.130 5.462 -3.300
 * // -4.418 3.088 3.598
 * //  4.605 1.622 4.262
 *
 * @param { VectorAdapter|Long } axis - The value for each axis.
 * @param { Number } angle - An angle in 3D space.
 * @returns { Matrix } - Returns original matrix with transformed scalars.
 * @method fromAxisAndAngleWithScale
 * @throws { Error } If arguments.length is not 2.
 * @throws { Error } If axis.length is not 3.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function fromAxisAndAngleWithScale( axis, angle )
{
  let self = this;

  axis = self.vectorAdapter.from( axis );

  let m = axis.mag();
  let x = axis.eGet( 0 ) / m;
  let y = axis.eGet( 1 ) / m;
  let z = axis.eGet( 2 ) / m;

  _.assert( axis.length === 3 );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let s = Math.sin( angle );
  let c = Math.cos( angle );
  let t = 1 - c;

  let m00 = c + x*x*t;
  let m11 = c + y*y*t;
  let m22 = c + z*z*t;

  let a = x*y*t;
  let b = z*s;

  let m10 = a + b;
  let m01 = a - b;

  a = x*z*t;
  b = y*s;

  let m20 = a - b;
  let m02 = a + b;

  a = y*z*t;
  b = x*s;

  let m21 = a + b;
  let m12 = a - b;

  self.scalarSet( [ 0, 0 ], m*m00 );
  self.scalarSet( [ 1, 0 ], m*m10 );
  self.scalarSet( [ 2, 0 ], m*m20 );

  self.scalarSet( [ 0, 1 ], m*m01 );
  self.scalarSet( [ 1, 1 ], m*m11 );
  self.scalarSet( [ 2, 1 ], m*m21 );

  self.scalarSet( [ 0, 2 ], m*m02 );
  self.scalarSet( [ 1, 2 ], m*m12 );
  self.scalarSet( [ 2, 2 ], m*m22 );

  return self;
}

//

/**
 * The method fromEuler() transforms euler groups and applies it to current matrix.
 *
 * @example
 * var euler = [ -1.1460587579332022, 0.42747914557614075, -2.8632929945846817, 0, 1, 2 ];
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   +1, +2, +3,
 *   +0, +4, +5,
 *   +0, +0, +6,
 * ]);
 *
 * var got = matrix.fromEuler( euler );
 * console.log( got.toStr() );
 * // log :
 * // -0.875  0.250  0.415
 * //  0.250 -0.500  0.829
 * //  0.415  0.829  0.375
 *
 * @param { Long } euler - The euler group.
 * @returns { Matrix } - Returns original matrix with transformed scalars.
 * @method fromEuler
 * @throws { Error } If arguments.length is not 1.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function fromEuler( euler )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  _.euler.toMatrix( euler, self );

  return self;
}

// --
// projector
// --

/**
 * The method normalProjectionMatrixMake() creates new matrix that is a normal projection to current matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   +1, +2, +3,
 *   +0, +4, +5,
 *   +0, +0, +6,
 * ]);
 *
 * var got = matrix.normalProjectionMatrixMake();
 * console.log( got.toStr() );
 * // log :
 * // 1.000   0.000  0.000
 * // -0.500  0.250  0.000
 * // -0.083 -0.208  0.167
 *
 * @returns { Matrix } - Returns cloned matrix that is a normal projection to current matrix.
 * @method normalProjectionMatrixMake
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function normalProjectionMatrixMake()
{
  let self = this;
  debugger;
  return self.clone().invert().transpose();
}

//

/**
 * The method normalProjectionMatrixGet() calculates the normal projection of source matrix {-src-} to current matrix.
 * The result of calculation applies to current matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2, 3,
 *   0, 4, 5,
 *   0, 0, 6,
 * ]);
 * var src = _.Matrix.MakeSquare
 * ([
 *   0,  1,  2,  3,
 *   4,  5,  6,  7,
 *   8,  9,  10, 11,
 *   12, 13, 14, 15,
 * ]);
 *
 * matrix.normalProjectionMatrixGet( src );
 * console.log( matrix.toStr() );
 * // log :
 * // 1.000 -0.500 -0.083
 * // 0.000  0.250 -0.208
 * // 0.000  0.000  0.167
 *
 * @returns { Matrix } - Returns cloned matrix that is a normal projection to current matrix.
 * @method normalProjectionMatrixGet
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function normalProjectionMatrixGet( src )
{
  let self = this;

  if( src.hasShape([ 4, 4 ]) )
  {
    // debugger;

    let s00 = self.scalarGet([ 0, 0 ]), s10 = self.scalarGet([ 1, 0 ]), s20 = self.scalarGet([ 2, 0 ]);
    let s01 = self.scalarGet([ 0, 1 ]), s11 = self.scalarGet([ 1, 1 ]), s21 = self.scalarGet([ 2, 1 ]);
    let s02 = self.scalarGet([ 0, 2 ]), s12 = self.scalarGet([ 1, 2 ]), s22 = self.scalarGet([ 2, 2 ]);

    let d1 = s22 * s11 - s21 * s12;
    let d2 = s21 * s02 - s22 * s01;
    let d3 = s12 * s01 - s11 * s02;

    let determiant = s00 * d1 + s10 * d2 + s20 * d3;

    if( determiant === 0 )
    throw _.err( 'normalProjectionMatrixGet : zero determinant' );

    determiant = 1 / determiant;

    let d00 = d1 * determiant;
    let d10 = ( s20 * s12 - s22 * s10 ) * determiant;
    let d20 = ( s21 * s10 - s20 * s11 ) * determiant;

    let d01 = d2 * determiant;
    let d11 = ( s22 * s00 - s20 * s02 ) * determiant;
    let d21 = ( s20 * s01 - s21 * s00 ) * determiant;

    let d02 = d3 * determiant;
    let d12 = ( s10 * s02 - s12 * s00 ) * determiant;
    let d22 = ( s11 * s00 - s10 * s01 ) * determiant;

    self.scalarSet( [ 0, 0 ], d00 );
    self.scalarSet( [ 1, 0 ], d10 );
    self.scalarSet( [ 2, 0 ], d20 );

    self.scalarSet( [ 0, 1 ], d01 );
    self.scalarSet( [ 1, 1 ], d11 );
    self.scalarSet( [ 2, 1 ], d21 );

    self.scalarSet( [ 0, 2 ], d02 );
    self.scalarSet( [ 1, 2 ], d12 );
    self.scalarSet( [ 2, 2 ], d22 );

    return self;
  }

  let sub = src.submatrix([ [ 0, src.dims[ 0 ]-1 ], [ 0, src.dims[ 1 ]-1 ] ]);

  return self.copy( sub ).invert().transpose();
}

//

/**
 * Static routine FormPerspective() transforms provided arguments {-dst-}, {-fov-}, {-size-} and {-depth-} to perspective projection.
 * The result applies to the destination matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2, 3, 4,
 *   0, 4, 5, 6,
 *   0, 0, 6, 7,
 *   1, 2, 3, 8,
 * ]);
 *
 * var got = _.Matrix.FormPerspective( matrix, 60, [ 3, 4 ], [ 5, 6 ] );
 * console.log( matrix.toStr() );
 * // log :
 * // 1.732  0.000   0.000   0.000
 * // 0.000  1.299   0.000   0.000
 * // 0.000  0.000 -11.000 -60.000
 * // 0.000  0.000  -1.000   0.000
 *
 * @param { Matrix } dst - Destination matrix of size 4x4.
 * @param { Number } fov - Field of view, an angle of view.
 * @param { Long } size - The x and y coordinates.
 * @param { Long } depth - Depth vector.
 * @returns { Matrix } - Returns current matrix with result of transformation.
 * @function FormPerspective
 * @throws { Error } If arguments.length is not 4 or 3.
 * @throws { Error } If size.length is not 2.
 * @throws { Error } If depth.length is not 2.
 * @throws { Error } If current matrix is not square matrix, and it length is not 4.
 * @static
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function FormPerspective( dst, fov, size, depth )
{
  if( arguments.length === 3 )
  {
    dst = this.MakeSquare( 4 );
    fov = arguments[ 0 ];
    size = arguments[ 1 ];
    depth = arguments[ 2 ];
  }
  else if( arguments.length === 4 )
  {
    if( dst === null )
    dst = this.MakeSquare( 4 );
    else
    dst = this.From( dst );
  }
  else
  {
    _.assert( 0, 'Expects four or three arguments' );
  }

  _.assert( size.length === 2 );
  _.assert( depth.length === 2 );
  _.assert( dst.hasShape([ 4, 4 ]) );

  fov = Math.tan( _.math.degToRad( fov * 0.5 ) );

  let ymin = - depth[ 0 ] * fov;
  let ymax = - ymin;

  let xmin = ymin;
  let xmax = ymax;


  let aspect = size[ 0 ] / size[ 1 ];

  if( aspect > 1 )
  {

    xmin *= aspect;
    xmax *= aspect;

  }
  else
  {

    ymin /= aspect;
    ymax /= aspect;

  }

  return dst.formFrustum( [ xmin, xmax ], [ ymin, ymax ], depth );
}

//

/**
 * The method formPerspective() transforms provided arguments {-fov-}, {-size-} and {-depth-} to perspective projection.
 * The result applies to current matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2, 3, 4,
 *   0, 4, 5, 6,
 *   0, 0, 6, 7,
 *   1, 2, 3, 8,
 * ]);
 *
 * matrix.formPerspective( 60, [ 3, 4 ], [ 5, 6 ] );
 * console.log( matrix.toStr() );
 * // log :
 * // 1.732  0.000   0.000   0.000
 * // 0.000  1.299   0.000   0.000
 * // 0.000  0.000 -11.000 -60.000
 * // 0.000  0.000  -1.000   0.000
 *
 * @param { Number } fov - Field of view, an angle of view.
 * @param { Long } size - The x and y coordinates.
 * @param { Long } depth - Depth vector.
 * @returns { Matrix } - Returns current matrix with result of transformation.
 * @method formPerspective
 * @throws { Error } If arguments.length is not 3.
 * @throws { Error } If size.length is not 2.
 * @throws { Error } If depth.length is not 2.
 * @throws { Error } If current matrix is not square matrix, and it length is not 4.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

// function formPerspective( fov, width, height, near, far )
function formPerspective( fov, size, depth )
{
  let self = this;

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );

  return Self.FormPerspective( self, fov, size, depth );
  // let self = this;
  // let aspect = size[ 0 ] / size[ 1 ];
  //
  // // debugger;
  // // _.assert( 0, 'not tested' );
  //
  // _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  // _.assert( size.length === 2 );
  // _.assert( depth.length === 2 );
  // _.assert( self.hasShape([ 4, 4 ]) );
  //
  // fov = Math.tan( _.math.degToRad( fov * 0.5 ) );
  //
  // let ymin = - depth[ 0 ] * fov;
  // let ymax = - ymin;
  //
  // let xmin = ymin;
  // let xmax = ymax;
  //
  // if( aspect > 1 )
  // {
  //
  //   xmin *= aspect;
  //   xmax *= aspect;
  //
  // }
  // else
  // {
  //
  //   ymin /= aspect;
  //   ymax /= aspect;
  //
  // }
  //
  // /* console.log({ xmin, xmax, ymin, ymax }); */
  //
  // return self.formFrustum( [ xmin, xmax ], [ ymin, ymax ], depth );
}

//

/**
 * The method formFrustum() transforms provided arguments {-horizontal-}, {-vertical-} and {-depth-} to frustum.
 * The result applies to current matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2, 3, 4,
 *   0, 4, 5, 6,
 *   0, 0, 6, 7,
 *   1, 2, 3, 8,
 * ]);
 *
 * matrix.formFrustum( [ 1, 2 ], [ 3, 4 ], [ 5, 6 ] );
 * console.log( matrix.toStr() );
 * // log :
 * // +10 +0  +3  +0
 * // +0  +10 +7  +0
 * // +0  +0  -11 -60
 * // +0  +0  -1  +0
 *
 * @param { Long } horizontal - Horizontal vector.
 * @param { Long } vertical - Vertical vector.
 * @param { Long } depth - Depth vector.
 * @returns { Matrix } - Returns current matrix with result of transformation.
 * @method formFrustum
 * @throws { Error } If arguments.length is not 3.
 * @throws { Error } If horizontal.length is not 2.
 * @throws { Error } If vertical.length is not 2.
 * @throws { Error } If depth.length is not 2.
 * @throws { Error } If current matrix is not square matrix, and it length is not 4.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

// function formFrustum( left, right, bottom, top, near, far )
function formFrustum( horizontal, vertical, depth )
{
  let self = this;

  // debugger;
  // _.assert( 0, 'not tested' );

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  _.assert( horizontal.length === 2 );
  _.assert( vertical.length === 2 );
  _.assert( depth.length === 2 );
  _.assert( self.hasShape([ 4, 4 ]) );

  // let te = this.buffer;
  let x = 2 * depth[ 0 ] / ( horizontal[ 1 ] - horizontal[ 0 ] );
  let y = 2 * depth[ 0 ] / ( vertical[ 1 ] - vertical[ 0 ] );

  let a = ( horizontal[ 1 ] + horizontal[ 0 ] ) / ( horizontal[ 1 ] - horizontal[ 0 ] );
  let b = ( vertical[ 1 ] + vertical[ 0 ] ) / ( vertical[ 1 ] - vertical[ 0 ] );
  let c = - ( depth[ 1 ] + depth[ 0 ] ) / ( depth[ 1 ] - depth[ 0 ] );
  let d = - 2 * depth[ 1 ] * depth[ 0 ] / ( depth[ 1 ] - depth[ 0 ] );

  self.scalarSet( [ 0, 0 ], x );
  self.scalarSet( [ 1, 0 ], 0 );
  self.scalarSet( [ 2, 0 ], 0 );
  self.scalarSet( [ 3, 0 ], 0 );

  self.scalarSet( [ 0, 1 ], 0 );
  self.scalarSet( [ 1, 1 ], y );
  self.scalarSet( [ 2, 1 ], 0 );
  self.scalarSet( [ 3, 1 ], 0 );

  self.scalarSet( [ 0, 2 ], a );
  self.scalarSet( [ 1, 2 ], b );
  self.scalarSet( [ 2, 2 ], c );
  self.scalarSet( [ 3, 2 ], -1 );

  self.scalarSet( [ 0, 3 ], 0 );
  self.scalarSet( [ 1, 3 ], 0 );
  self.scalarSet( [ 2, 3 ], d );
  self.scalarSet( [ 3, 3 ], 0 );

  // debugger;
  return self;
}

//

/**
 * The method formOrthographic() transforms provided arguments {-horizontal-}, {-vertical-} and {-depth-} to orthogonal system.
 * The result applies to current matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2, 3, 4,
 *   0, 4, 5, 6,
 *   0, 0, 6, 7,
 *   1, 2, 3, 8,
 * ]);
 *
 * matrix.formOrthographic( [ 1, 2 ], [ 3, 4 ], [ 5, 6 ] );
 * console.log( matrix.toStr() );
 * // log :
 * // +2 +0 +0 -3
 * // +0 +2 +0 -7
 * // +0 +0 -2 -11
 * // +0 +0 +0 +1
 *
 * @param { Long } horizontal - Horizontal vector.
 * @param { Long } vertical - Vertical vector.
 * @param { Long } depth - Depth vector.
 * @returns { Matrix } - Returns current matrix with result of transformation.
 * @method formOrthographic
 * @throws { Error } If arguments.length is not 3.
 * @throws { Error } If horizontal.length is not 2.
 * @throws { Error } If vertical.length is not 2.
 * @throws { Error } If depth.length is not 2.
 * @throws { Error } If current matrix is not square matrix, and it length is not 4.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

// function formOrthographic( left, right, top, bottom, near, far )
function formOrthographic( horizontal, vertical, depth )
{
  let self = this;

  // debugger;
  // _.assert( 0, 'not tested' );

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  _.assert( horizontal.length === 2 );
  _.assert( vertical.length === 2 );
  _.assert( depth.length === 2 );
  _.assert( self.hasShape([ 4, 4 ]) );

  let w = horizontal[ 1 ] - horizontal[ 0 ];
  let h = vertical[ 1 ] - vertical[ 0 ];
  let d = depth[ 1 ] - depth[ 0 ];

  let x = ( horizontal[ 1 ] + horizontal[ 0 ] ) / w;
  let y = ( vertical[ 1 ] + vertical[ 0 ] ) / h;
  let z = ( depth[ 1 ] + depth[ 0 ] ) / d;

  self.scalarSet( [ 0, 0 ], 2 / w );
  self.scalarSet( [ 1, 0 ], 0 );
  self.scalarSet( [ 2, 0 ], 0 );
  self.scalarSet( [ 3, 0 ], 0 );

  self.scalarSet( [ 0, 1 ], 0 );
  self.scalarSet( [ 1, 1 ], 2 / h );
  self.scalarSet( [ 2, 1 ], 0 );
  self.scalarSet( [ 3, 1 ], 0 );

  self.scalarSet( [ 0, 2 ], 0 );
  self.scalarSet( [ 1, 2 ], 0 );
  self.scalarSet( [ 2, 2 ], -2 / d );
  self.scalarSet( [ 3, 2 ], 0 );

  self.scalarSet( [ 0, 3 ], -x );
  self.scalarSet( [ 1, 3 ], -y );
  self.scalarSet( [ 2, 3 ], -z );
  self.scalarSet( [ 3, 3 ], 1 );

  // te[ 0 ] = 2 / w; te[ 4 ] = 0; te[ 8 ] = 0; te[ 12 ] = - x;
  // te[ 1 ] = 0; te[ 5 ] = 2 / h; te[ 9 ] = 0; te[ 13 ] = - y;
  // te[ 2 ] = 0; te[ 6 ] = 0; te[ 10 ] = - 2 / d; te[ 14 ] = - z;
  // te[ 3 ] = 0; te[ 7 ] = 0; te[ 11 ] = 0; te[ 15 ] = 1;

  return self;
}

//

/**
 * The method lookAt() calculates projection using coordinates of dot {-eye-}, object {-target-} and vector {-up1-}.
 * The result applies to current matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2, 3,
 *   4, 0, 4,
 *   5, 6, 0,
 * ]);
 *
 * matrix.lookAt( [ 1, 0, 1 ], [ 2, 3, 2 ], [ 1, 1, 1 ] );
 * console.log( matrix.toStr() );
 * // log :
 * //  0.000 0.707 -0.707
 * //  4.000 0.816 -0.408
 * // -0.408 6.000 -0.577
 *
 * @param { Long|VectorAdapter } eye - The dot in space.
 * @param { Long|VectorAdapter } target - Target object.
 * @param { Long|VectorAdapter } up1 - Vector.
 * @returns { Matrix } - Returns current matrix with result of transformation.
 * @method lookAt
 * @throws { Error } If arguments.length is not 3.
 * @throws { Error } If horizontal.length is not 2.
 * @throws { Error } If vertical.length is not 2.
 * @throws { Error } If depth.length is not 2.
 * @throws { Error } If current matrix is not square matrix, and it length is not 4.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function lookAt( eye, target, up1 )
{
  let self = this;
  let te = self.buffer;

  let x = [ 0, 0, 0 ];
  let y = [ 0, 0, 0 ];

  let z = _.avector.sub( null, eye, target );

  _.avector.normalize( z );

  let zmag = _.avector.mag( z );
  if( _.equivalent( zmag, 0 ) )
  {
    z[ 2 ] = 1;
  }

  _.avector._cross3( x, up1, z );

  let xmag = _.avector.mag( x );
  if( _.equivalent( xmag, 0 ) )
  {
    z[ 0 ] += 0.0001;
    _.avector._cross3( x, up1, z );
    xmag = _.avector.mag( x );
  }

  _.avector.mul( x, 1 / xmag );

  _.avector._cross3( y, z, x );

  te[ 0 ] = x[ 0 ]; te[ 4 ] = y[ 0 ]; te[ 8 ] = z[ 0 ];
  te[ 1 ] = x[ 1 ]; te[ 5 ] = y[ 1 ]; te[ 9 ] = z[ 1 ];
  te[ 2 ] = x[ 2 ]; te[ 6 ] = y[ 2 ]; te[ 10 ] = z[ 2 ];

  return self;
}

// --
// relations
// --

let Statics = /* qqq : split static routines. ask how */
{

  /* details */

  // _BufferFrom,

  /* make */

  Make,
  MakeSquare,

  MakeZero,
  MakeIdentity,
  MakeIdentity2,
  MakeIdentity3,
  MakeIdentity4,

  MakeDiagonal,
  MakeSimilar,

  MakeLine,
  MakeCol,
  MakeColZeroed,
  MakeColDup,
  MakeRow,
  MakeRowZeroed,
  MakeRowDup,

  ConvertToClass,

  /* aaa2 : implement please FromCol, FromRow */ /* Dmytro : implemented, this routines renamed to ColFrom and RowFrom */

  FromVector, /* zzz : deprecate */
  FromScalar,
  FromScalarForReading,
  From,
  FromForReading,
  ColFrom,
  RowFrom,
  FromTransformations,
  FormPerspective,

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

  // make

  Make,
  MakeSquare,
  MakeZero,

  MakeIdentity,
  MakeIdentity2,
  MakeIdentity3,
  MakeIdentity4,

  MakeDiagonal,
  MakeSimilar,
  makeSimilar,

  MakeLine,
  MakeCol,
  MakeColZeroed,
  MakeColDup, /* qqq : cover and document */
  MakeRow,
  MakeRowZeroed,
  MakeRowDup, /* qqq : cover and document */

  // convert

  ConvertToClass,

  FromVector, /* zzz : deprecate */
  FromScalar,
  FromScalarForReading,
  From,
  FromForReading,
  ColFrom,
  RowFrom,

  // transformation

  FromTransformations,
  fromTransformations,
  fromQuat,
  fromQuatWithScale,

  fromAxisAndAngle,
  fromAxisAndAngleWithScale,

  fromEuler,

  // projector

  normalProjectionMatrixMake,
  normalProjectionMatrixGet,

  FormPerspective,
  formPerspective, /* qqq : implement static, cover */ /* Dmytro : implemented */
  formFrustum, /* qqq : implement static, cover */
  formOrthographic, /* qqq : implement static, cover */
  lookAt, /* qqq : implement static, cover */

  //

  Statics,

}

_.classExtend( Self, Extension );
_.assert( Self.From === From );

})();
