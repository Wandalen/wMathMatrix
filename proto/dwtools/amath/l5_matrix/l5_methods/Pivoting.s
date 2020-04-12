(function _Pivoting_s_() {

'use strict';

let _ = _global_.wTools;
let Parent = null;
let Self = _.Matrix;

// --
// implementation
// --

function _pivotDimension( d, current, expected )
{
  let self = this;

  for( let p1 = 0 ; p1 < expected.length ; p1++ )
  {
    if( expected[ p1 ] === current[ p1 ] )
    continue;
    let p2 = current[ expected[ p1 ] ];
    _.longSwapElements( current, p2, p1 );
    self.linesSwap( d, p2, p1 );
  }

  _.assert( expected.length === self.dims[ d ] );
  _.assert( _.longIdentical( current, expected ) );

}

//

/**
 * Method pivotForward() pivots elements of the matrix.
 * Pivoting provides by swapping of elements in declared order.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.pivotForward( [ [ 1, 0, 2 ], [ 1, 0, 2 ] ] );
 * console.log( got.toStr() );
 * // log : +5, +4, +6,
 * //       +2, +1, +3,
 * //       +8, +7, +9,
 *
 * @param { Array } pivots - Array than defines the order of pivoting.
 * @method pivotForward
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If pivots.length is not equal to number of dimensions.
 * @throws { Error } If {-pivots-} element defines wrong pivoting.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function pivotForward( pivots )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( pivots.length === self.dims.length );

  for( let d = 0 ; d < pivots.length ; d++ )
  {
    let current = _.longFromRange([ 0, self.dims[ d ] ]);
    let expected = pivots[ d ];
    if( expected === null )
    continue;
    self._pivotDimension( d, current, expected )
  }

  return self;
}

//

/**
 * Method pivotBackward() pivots elements of the matrix.
 * Pivoting provides by swapping of elements in declared position.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.pivotBackward( [ [ 1, 0, 2 ], [ 1, 0, 2 ] ] );
 * console.log( got.toStr() );
 * // log : +5, +4, +6,
 * //       +2, +1, +3,
 * //       +8, +7, +9,
 *
 * @param { Array } pivots - Array than defines the order of pivoting.
 * @method pivotBackward
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If pivots.length is not equal to number of dimensions.
 * @throws { Error } If {-pivots-} element defines wrong pivoting.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function pivotBackward( pivots )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( pivots.length === self.dims.length );

  for( let d = 0 ; d < pivots.length ; d++ )
  {
    let current = pivots[ d ];
    let expected = _.longFromRange([ 0, self.dims[ d ] ]);
    if( current === null )
    continue;
    current = current.slice();
    self._pivotDimension( d, current, expected )
  }

  return self;
}

//

function _vectorPivotDimension( v, current, expected )
{
  let self = this;

  for( let p1 = 0 ; p1 < expected.length ; p1++ )
  {
    if( expected[ p1 ] === current[ p1 ] )
    continue;
    let p2 = current[ expected[ p1 ] ];
    _.longSwapElements( current, p1, p2 );
    self.vectorAdapter.scalarsSwap( v, p1, p2 );
  }

  _.assert( expected.length === v.length );
  _.assert( _.longIdentical( current, expected ) );

}

//

/**
 * Static routine VectorPivotForward() pivots elements of the vector {-vector-}.
 * If {-vector-} is a Matrix instance, then routine pivots the rows.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.VectorPivotForward( matrix, [ 1, 0, 2 ] );
 * console.log( got.toStr() );
 * // log : +4, +5, +6,
 * //       +1, +2, +3,
 * //       +7, +8, +9,
 *
 * @param { Array } pivots - Array than defines the order of pivoting.
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-pivots-} is not an Array.
 * @throws { Error } If {-pivots-} element defines wrong pivoting.
 * @static
 * @function VectorPivotForward
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function VectorPivotForward( vector, pivot )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.arrayIs( pivot ) );

  if( _.matrixIs( vector ) )
  return vector.pivotForward([ pivot, null ]);

  let original = vector;
  vector = this.vectorAdapter.from( vector );
  let current = _.longFromRange([ 0, vector.length ]);
  let expected = pivot;
  if( expected === null )
  return vector;
  this._vectorPivotDimension( vector, current, expected )

  return original;
}

//

/**
 * Static routine VectorPivotBackward() pivots elements of the vector {-vector-}.
 * If {-vector-} is a Matrix instance, then routine pivots the rows.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.VectorPivotBackward( matrix, [ 1, 0, 2 ] );
 * console.log( got.toStr() );
 * // log : +4, +5, +6,
 * //       +1, +2, +3,
 * //       +7, +8, +9,
 *
 * @param { Array } pivots - Array than defines the order of pivoting.
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-pivots-} is not an Array.
 * @throws { Error } If {-pivots-} element defines wrong pivoting.
 * @static
 * @function VectorPivotBackward
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function VectorPivotBackward( vector, pivot )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.arrayIs( pivot ) );

  if( _.matrixIs( vector ) )
  return vector.pivotBackward([ pivot, null ]);

  let original = vector;
  vector = this.vectorAdapter.from( vector );
  let current = pivot.slice();
  let expected = _.longFromRange([ 0, vector.length ]);
  if( current === null )
  return vector;
  this._vectorPivotDimension( vector, current, expected )

  return original;
}

// --
// relations
// --

let Statics =
{

  /* pivot */

  _vectorPivotDimension,
  VectorPivotForward,
  VectorPivotBackward,

}

// --
// extension
// --

let Extension =
{

  //

  _pivotDimension,
  pivotForward,
  pivotBackward,

  _vectorPivotDimension,
  VectorPivotForward,
  VectorPivotBackward,

  //

  Statics,

}

_.classExtend( Self, Extension );

})();
