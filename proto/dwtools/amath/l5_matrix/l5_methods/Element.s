(function _Element_s_() {

'use strict';

let _ = _global_.wTools;
let Parent = null;
let Self = _.Matrix;

// --
// partial accessors
// --

/**
 * The method zero() assigns the value `0` to each element of the current matrix.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   1, 2, 3,
 *   0, 4, 5
 *   0, 0, 6,
 * ]);
 *
 * var got = matrix.zero();
 * console.log( got );
 * // log : +0, +0, +0,
 * //       +0, +0, +0
 * //       +0, +0, +0,
 *
 * @returns { Matrix } - Returns the original matrix filled by zeros.
 * @method zero
 * @throws { Error } If arguments are passed.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function zero()
{
  let self = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  self.scalarEach( ( it ) => self.scalarSet( it.indexNd, 0 ) );

  return self;
}

//

/**
 * The method identity() transforms current matrix to identity matrix.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   3, 2, 3,
 *   4, 0, 2
 *   0, 0, 6,
 * ]);
 *
 * var got = matrix.identity();
 * console.log( got );
 * // log : +1, +0, +0,
 * //       +0, +1, +0,
 * //       +0, +0, +1,
 *
 * @returns { Matrix } - Returns original matrix, it is identity matrix.
 * @method identity
 * @throws { Error } If arguments are passed.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function identity()
{
  let self = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  self.scalarEach( ( it ) => it.indexNd[ 0 ] === it.indexNd[ 1 ] ? self.scalarSet( it.indexNd, 1 ) : self.scalarSet( it.indexNd, 0 ) );

  return self;
}

//

/**
 * The method diagonalSet() assigns the values from {-src-} to the diagonal of current matrix.
 * If {-src-} is a Matrix, then method assigns the diagonal of {-src-} to the diagonal of current
 * matrix.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   3, 2, 3,
 *   4, 0, 2
 *   0, 0, 6,
 * ]);
 *
 * var src = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   +1, +2, +3,
 *   +4, +5, +4
 *   +3, +2, +1,
 * ]);
 *
 * var got = matrix.diagonalSet( src );
 * console.log( got );
 * // log
 * +1, +2, +3,
 * +4, +5, +2,
 * +0, +0, +1,
 *
 * @param { Number|Long|VectorAdapter|Matrix } src - The values.
 * @returns { Matrix } - Returns original matrix with changed diagonal values.
 * @method diagonalSet
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If src.length is not same as minimal dimension of the current matrix.
 * @throws { Error } If number of dimensions of current matrix is not 2.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function diagonalSet( src )
{
  let self = this;
  let length = Math.min( self.scalarsPerCol, self.scalarsPerRow );

  if( src instanceof Self )
  src = src.diagonalGet();

  src = self.vectorAdapter.fromMaybeNumber( src, length );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( self.dims.length === 2 );
  _.assert( src.length === length );

  for( let i = 0 ; i < length ; i += 1 )
  {
    self.scalarSet( [ i, i ], src.eGet( i ) );
  }

  return self;
}

//

/**
 * The method diagonalGet() returns vector with values of diagonal of current matrix.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   +3, +2, +3,
 *   +4, +0, +2
 *   +0, +0, +6,
 * ]);
 *
 * var got = matrix.diagonalGet();
 * console.log( got );
 * // log : 3.000 0.000 6.000
 *
 * @returns { VectorAdapter } - Returns vector of diagonal values.
 * @method diagonalGet
 * @throws { Error } If arguments are passed.
 * @throws { Error } If number of dimensions of current matrix is not 2.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function diagonalGet()
{
  let self = this;
  let length = Math.min( self.scalarsPerCol, self.scalarsPerRow );
  let strides = self._stridesEffective;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( self.dims.length === 2 );

  let result = self.vectorAdapter.fromLongLrangeAndStride( self.buffer, self.offset, length, strides[ 0 ] + strides[ 1 ] );

  return result;
}

//

/**
 * The method triangleLowerSet() assigns the value from source value {-src-} to the lower
 * triangle of current matrix.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   0, 0, 0,
 *   0, 0, 0,
 *   0, 0, 0,
 * ]);
 *
 * var src = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   1, 1, 1,
 *   1, 1, 1,
 *   1, 1, 1,
 * ]);
 *
 * var got = matrix.triangleLowerSet( src );
 * console.log( got );
 * // log : +0, +0, +0,
 * //       +1, +0, +0,
 * //       +1, +1, +0,
 *
 * @param { Number|Matrix } src - Source values.
 * @returns { Matrix } - Returns original matrix with changed lower triangle.
 * @method triangleLowerSet
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If number of dimensions or current matrix is not 2.
 * @throws { Error } If {-src-} is instance of Matrix and number of its rows is less then number of rows in current matrix.
 * @throws { Error } If {-src-} is instance of Matrix and number of its columns is less minimal value of next parameters: decremented number or rows of current matrix or number of columns of current matrix.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function triangleLowerSet( src )
{
  let self = this;
  let nrow = self.nrow;
  let ncol = self.ncol;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( self.dims.length === 2 );

  _.assert( _.numberIs( src ) || src instanceof Self );

  if( src instanceof Self )
  {

    _.assert( src.dims[ 0 ] >= self.dims[ 0 ] );
    _.assert( src.dims[ 1 ] >= Math.min( self.dims[ 0 ]-1, self.dims[ 1 ] ) );

    for( let r = 1 ; r < nrow ; r++ )
    {
      let cl = Math.min( r, ncol );
      for( let c = 0 ; c < cl ; c++ )
      self.scalarSet( [ r, c ], src.scalarGet([ r, c ]) );
    }

  }
  else
  {

    for( let r = 1 ; r < nrow ; r++ )
    {
      let cl = Math.min( r, ncol );
      for( let c = 0 ; c < cl ; c++ )
      self.scalarSet( [ r, c ], src );
    }

  }

  return self;
}

//

/**
 * The method triangleUpperSet() assigns the value from source value {-src-} to the upper
 * triangle of current matrix.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   0, 0, 0,
 *   0, 0, 0,
 *   0, 0, 0,
 * ]);
 *
 * var src = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   1, 1, 1,
 *   1, 1, 1,
 *   1, 1, 1,
 * ]);
 *
 * var got = matrix.triangleUpperSet( src );
 * console.log( got );
 * // log : +0, +1, +1,
 * //       +0, +0, +1,
 * //       +0, +0, +0,
 *
 * @param { Number|Matrix } src - Source values.
 * @returns { Matrix } - Returns original matrix with changed upper triangle.
 * @method triangleUpperSet
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If number of dimensions or current matrix is not 2.
 * @throws { Error } If {-src-} is instance of Matrix and number of its columns is less then number of columns in current matrix.
 * @throws { Error } If {-src-} is instance of Matrix and number of its rows is less minimal value of next parameters: decremented number or columns of current matrix or number of columns of current matrix.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function triangleUpperSet( src )
{
  let self = this;
  let nrow = self.nrow;
  let ncol = self.ncol;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( self.dims.length === 2 );

  _.assert( _.numberIs( src ) || src instanceof Self );

  if( src instanceof Self )
  {

    _.assert( src.dims[ 1 ] >= self.dims[ 1 ] );
    _.assert( src.dims[ 0 ] >= Math.min( self.dims[ 1 ]-1, self.dims[ 0 ] ) );

    for( let c = 1 ; c < ncol ; c++ )
    {
      let cl = Math.min( c, nrow );
      for( let r = 0 ; r < cl ; r++ )
      self.scalarSet( [ r, c ], src.scalarGet([ r, c ]) );
    }

  }
  else
  {

    for( let c = 1 ; c < ncol ; c++ )
    {
      let cl = Math.min( c, nrow );
      for( let r = 0 ; r < cl ; r++ )
      self.scalarSet( [ r, c ], src );
    }

  }

  return self;
}

// --
// total
// --

/**
 * Method expand() expands dimensions of the matrix taking into account provided argument {-expand-}.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4 ] );
 * console.log( matrix.toStr() );
 * // log : +1, +2,
 * //       +3, +4,
 * var expanded = matrix.expand( [ 1, 0 ] );
 * console.log( expanded );
 * // log : +0, +0,
 * //       +1, +2,
 * //       +3, +4,
 * //       +0, +0,
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4 ] );
 * console.log( matrix.toStr() );
 * // log : +1, +2,
 * //       +3, +4,
 * var expanded = matrix.expand( [ [ 1, 0 ], [ 1, 0 ] ] );
 * console.log( expanded );
 * // log : +0, +0, +0,
 * //       +0, +1, +2,
 * //       +0, +3, +4,
 *
 * @param { Long } expand - The quantity of appended and prepended lines in each dimension.
 * @returns { Matrix } - Returns original expanded matrix.
 * @method expand
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If expand.length is not equal to quantity of dimensions.
 * @throws { Error } If elements of {-expand-} is bigger then equivalent dimension length.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function expand( expand )
{
  let self = this;

  /* */

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( expand.length === self.dims.length );

  /* */

  let dims = self.dims.slice();
  for( let i = 0 ; i < dims.length ; i++ )
  {
    if( !expand[ i ] )
    {
      expand[ i ] = [ 0, 0 ];
    }
    else if( _.numberIs( expand[ i ] ) )
    {
      expand[ i ] = [ expand[ i ], expand[ i ] ];
    }
    else
    {
      expand[ i ][ 0 ] = expand[ i ][ 0 ] || 0;
      expand[ i ][ 1 ] = expand[ i ][ 1 ] || 0;
    }
    _.assert( expand[ i ].length === 2 );
    _.assert( -expand[ i ][ 0 ] <= dims[ i ] );
    _.assert( -expand[ i ][ 1 ] <= dims[ i ] );
    dims[ i ] += expand[ i ][ 0 ] + expand[ i ][ 1 ];
  }

  if( self.hasShape( dims ) )
  return self;

  let scalarsPerMatrix = Self.ScalarsPerMatrixForDimensions( dims );
  let strides = Self.StridesForDimensions( dims, 0 );
  let buffer = self.long.longMakeZeroed( self.buffer, scalarsPerMatrix );

  /* move data */

  self.scalarEach( function( it )
  {
    for( let i = 0 ; i < dims.length ; i++ )
    {
      it.indexNd[ i ] += expand[ i ][ 0 ];
      if( it.indexNd[ i ] < 0 || it.indexNd[ i ] >= dims[ i ] )
      return;
    }
    let indexFlat = Self._FlatScalarIndexFromIndexNd( it.indexNd , strides );
    _.assert( indexFlat >= 0 );
    _.assert( indexFlat < buffer.length );
    buffer[ indexFlat ] = it.scalar;
  });

  /* copy */

  // self.copyResetting
  self.copy
  ({
    inputTransposing : 0,
    offset : 0,
    buffer,
    dims,
    strides : null,
  });

  return self;
}

//

/**
 * Method submatrix() creates new instance of Matrix from part of original matrix.
 * The buffer of new instance is the same container as original matrix buffer.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.submatrix( [ [ 0, 2 ], [ 0, 2 ] ] );
 * console.log( got.toStr() );
 * // log : +1, +2,
 * //       +4, +5,
 *
 * @param { Array } submatrix - Array with pairs of ranges.
 * @returns { Matrix } - Returns new instance of Matrix with part of original matrix.
 * @method submatrix
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-submatrix-} is not an Array.
 * @throws { Error } If submatrix.length is not equal to numbers of dimensions.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function submatrix( submatrix )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.arrayIs( submatrix ), 'Expects array (-submatrix-)' );
  _.assert( submatrix.length <= self.dims.length, 'Expects array (-submatrix-) of length of self.dims' );

  for( let s = submatrix.length ; s < self.dims.length ; s++ )
  submatrix.unshift( _.all );

  let dims = [];
  let strides = [];
  let stride = 1;
  let offset = Infinity;

  for( let s = 0 ; s < submatrix.length ; s++ )
  {
    if( submatrix[ s ] === _.all )
    {
      dims[ s ] = self.dims[ s ];
      strides[ s ] = self._stridesEffective[ s ];
    }
    else if( _.numberIs( submatrix[ s ] ) )
    {
      dims[ s ] = 1;
      strides[ s ] = self._stridesEffective[ s ];
      offset = Math.min( self._stridesEffective[ s ]*submatrix[ s ], offset );
    }
    else if( _.arrayIs( submatrix[ s ] ) )
    {
      _.assert( _.arrayIs( submatrix[ s ] ) && submatrix[ s ].length === 2 );
      dims[ s ] = submatrix[ s ][ 1 ] - submatrix[ s ][ 0 ];
      strides[ s ] = self._stridesEffective[ s ];
      offset = Math.min( self._stridesEffective[ s ]*submatrix[ s ][ 0 ], offset );
    }
    else _.assert( 0, 'unknown submatrix request' );
  }

  if( offset === Infinity )
  offset = 0;
  offset += self.offset;

  let result = new Self
  ({
    buffer : self.buffer,
    offset,
    strides,
    dims,
    inputTransposing : self.inputTransposing,
  });

  return result;
}

//

/**
 * Method transpose() transposes the matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4 ] );
 * console.log( matrix.toStr() );
 * // log : +1, +2,
 * //       +3, +4
 * matrix.transpose();
 * console.log( matrix.toStr() );
 * // log : +1, +3,
 * //       +2, +4
 *
 * @returns { Matrix } - Returns original matrix instance with transposed elements.
 * @method transpose
 * @throws { Error } If argument is provided.
 * @throws { Error } If dims.length is less then 2.
 * @throws { Error } If strides.length is less then 2.
 * @throws { Error } If strides.length is not equal to dims.length.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function transpose() /* xxx : check */
{
  let self = this;
  self._changeBegin();

  let dims = self.dims.slice();
  let strides = self._stridesEffective.slice();

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( dims.length >= 2 );
  _.assert( strides.length >= 2 );
  _.assert( strides.length === dims.length );

  // _.longSwapElements( dims, dims.length-1, dims.length-2 );
  // _.longSwapElements( strides, strides.length-1, strides.length-2 );

  _.longSwapElements( dims, 0, 1 );
  _.longSwapElements( strides, 0, 1 );

  self.strides = strides;
  self.dims = dims;

  self._changeEnd();
  return self;
}

// --
// relations
// --

let Statics =
{

}

// --
// extension
// --

let Extension =
{

  // partial accessors

  zero,
  identity,
  diagonalSet,
  diagonalGet,
  triangleLowerSet,
  triangleUpperSet,

  // total

  expand,
  submatrix,
  transpose,

  //

  Statics,

}

_.classExtend( Self, Extension );

})();
