(function _Permutation_s_() {

'use strict';

let _ = _global_.wTools;
let Parent = null;
let Self = _.Matrix;

// --
// implementation
// --

function _permutateDimension( d, current, expected )
{
  let self = this;

  _.assert( current.length <= expected.length );
  _.assert( expected.length === self.dims[ d ] );

  for( let p1 = 0 ; p1 < current.length ; p1++ )
  {
    if( expected[ p1 ] === current[ p1 ] )
    continue;
    let p2 = current[ expected[ p1 ] ];
    _.longSwapElements( current, p2, p1 );
    self.linesSwap( d, p2, p1 );
  }

  _.assert( _.longIdentical( current, expected.slice( 0, current.length ) ) );

}

//

/**
 * Method permutateForward() permutates elements of the matrix.
 * Permutating provides by swapping of elements in declared order.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.permutateForward( [ [ 1, 0, 2 ], [ 1, 0, 2 ] ] );
 * console.log( got.toStr() );
 * // log :
 * // +5, +4, +6,
 * // +2, +1, +3,
 * // +8, +7, +9,
 *
 * @param { Array } permutates - Array than defines the order of permutating.
 * @method permutateForward
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If permutates.length is not equal to number of dimensions.
 * @throws { Error } If {-permutates-} element defines wrong permutating.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function permutateForward( permutates )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( permutates.length === self.dims.length );

  for( let d = 0 ; d < permutates.length ; d++ )
  {
    let current = _.longFromRange([ 0, self.dims[ d ] ]);
    let expected = permutates[ d ];
    if( expected === null )
    continue;
    self._permutateDimension( d, current, expected )
  }

  return self;
}

//

/**
 * Method permutateBackward() permutates elements of the matrix.
 * Permutating provides by swapping of elements in declared position.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.permutateBackward( [ [ 1, 0, 2 ], [ 1, 0, 2 ] ] );
 * console.log( got.toStr() );
 * // log :
 * // +5, +4, +6,
 * // +2, +1, +3,
 * // +8, +7, +9,
 *
 * @param { Array } permutates - Array than defines the order of permutating.
 * @method permutateBackward
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If permutates.length is not equal to number of dimensions.
 * @throws { Error } If {-permutates-} element defines wrong permutating.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function permutateBackward( permutates )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( permutates.length === self.dims.length );

  for( let d = 0 ; d < permutates.length ; d++ )
  {
    let current = permutates[ d ];
    let expected = _.longFromRange([ 0, self.dims[ d ] ]);
    if( current === null )
    continue;
    current = current.slice();
    self._permutateDimension( d, current, expected )
  }

  return self;
}

//

function _VectorPermutateDimension( v, current, expected )
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
 * Static routine VectorPermutateForward() permutates elements of the vector {-vector-}.
 * If {-vector-} is a Matrix instance, then routine permutates the rows.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.VectorPermutateForward( matrix, [ 1, 0, 2 ] );
 * console.log( got.toStr() );
 * // log :
 * // +4, +5, +6,
 * // +1, +2, +3,
 * // +7, +8, +9,
 *
 * @param { Array } permutates - Array than defines the order of permutating.
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-permutates-} is not an Array.
 * @throws { Error } If {-permutates-} element defines wrong permutating.
 * @static
 * @function VectorPermutateForward
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function VectorPermutateForward( vector, permutate )
{
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.arrayIs( permutate ) );

  if( _.matrixIs( vector ) )
  return vector.permutateForward([ permutate, null ]);

  let original = vector;
  vector = this.vectorAdapter.from( vector );
  let current = _.longFromRange([ 0, vector.length ]);
  let expected = permutate;
  if( expected === null )
  return vector;
  this._VectorPermutateDimension( vector, current, expected )

  return original;
}

//

/**
 * Static routine PermutateBackward() permutates elements of the vector {-vector-}.
 * If {-vector-} is a Matrix instance, then routine permutates the rows.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.PermutateBackward( matrix, [ 1, 0, 2 ] );
 * console.log( got.toStr() );
 * // log :
 * // +4, +5, +6,
 * // +1, +2, +3,
 * // +7, +8, +9,
 *
 * @param { Array } permutates - Array than defines the order of permutating.
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-permutates-} is not an Array.
 * @throws { Error } If {-permutates-} element defines wrong permutating.
 * @static
 * @function PermutateBackward
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function PermutateBackward( vector, permutate )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.arrayIs( permutate ) );

  if( _.matrixIs( vector ) )
  return vector.permutateBackward([ permutate, null ]);

  let original = vector;
  vector = this.vectorAdapter.from( vector );
  let current = permutate.slice();
  let expected = _.longFromRange([ 0, vector.length ]);
  if( current === null )
  return vector;
  this._VectorPermutateDimension( vector, current, expected )

  return original;
}

//

function _PermutateLineRook_pre( routine, args )
{
  return Self.PermutateRook.pre.call( Self, ... arguments );
}

//

function _PermutateLineRook_body( o )
{
  let proto = Self;

  _.assert( arguments.length === 1 );
  _.assert( o.lineIndex >= 0 );
  _.assert( o.x === null || _.matrixIs( o.x ) );
  _.assertMapHasAll( o, _PermutateLineRook.defaults );

  let row1 = o.m.rowGet( o.lineIndex ).review( o.lineIndex );
  let col1 = o.m.colGet( o.lineIndex ).review( o.lineIndex );
  let maxr = o.m.vectorAdapter.reduceToMaxAbs( row1 );
  let maxc = o.m.vectorAdapter.reduceToMaxAbs( col1 );

  if( maxr.value > maxc.value )
  {
    let i2 = maxr.index + o.lineIndex;
    if( o.lineIndex === i2 )
    return false;
    _.longSwapElements( o.permutates[ 1 ], o.lineIndex, i2 );
    o.m.colsSwap( o.lineIndex, i2 );
    o.npermutations += 1;
    o.nColPermutations += 1;
  }
  else
  {
    let i2 = maxc.index + o.lineIndex;
    if( o.lineIndex === i2 )
    return false;
    _.longSwapElements( o.permutates[ 0 ], o.lineIndex, i2 );
    o.m.rowsSwap( o.lineIndex, i2 );
    if( o.x )
    o.x.rowsSwap( o.lineIndex, i2 );
    o.npermutations += 1;
    o.nRowPermutations += 1;
  }

  return true;
}

_PermutateLineRook_body.defaults =
{
  m : null,
  x : null,
  permutates : null,
  lineIndex : null,
  npermutations : 0,
  nRowPermutations : 0,
  nColPermutations : 0,
}

//

let _PermutateLineRook = _.routineFromPreAndBody( _PermutateLineRook_pre, _PermutateLineRook_body );

//

function _permutateLineRook( o )
{
  let self = this;
  o.m = self;
  return self._PermutateLineRook( o );
}

_permutateLineRook.defaults =
{
  ... _.mapBut( _PermutateLineRook.defaults, [ 'm' ] ),
}

//

function PermutateRook_pre( routine, args )
{
  let o1 = args[ 0 ];
  let o2 = o1;

  _.mapSupplement( o2, routine.defaults );
  // _.assert( o2.y === undefined );
  _.assert( o2.x === null || _.matrixIs( o2.x ) );

  if( !o2.permutates )
  {
    o2.permutates = [];
    for( let i = 0 ; i < o2.m.dims.length ; i += 1 )
    o2.permutates[ i ] = _.longFromRange([ 0, o2.m.dims[ i ] ]);
  }

  _.assert( arguments.length === 2 );
  _.assert( args.length === 1 );
  _.assert( _.longIs( o2.permutates ) );
  _.assert( !!o2.m );

  return o2;
}

//

function PermutateRook_body( o )
{
  let proto = Self;

  _.assert( arguments.length === 1 );
  _.assertRoutineOptions( PermutateRook_body, o );

  // Andrey: on non-square matrix max will be a problem. We need swaps only to diagonal end, so min correct here
  // let l = Math.max( o.m.dims[ 0 ], o.m.dims[ 1 ] );
  let l = Math.min( o.m.dims[ 0 ], o.m.dims[ 1 ] );
  for( let i = 0 ; i < l ; i++ )
  {
    o.lineIndex = i;
    proto._PermutateLineRook.body.call( proto, o );
  }

  delete o.lineIndex

  return o;
}

PermutateRook_body.defaults =
{
  m : null,
  x : null,
  // y : null,
  permutates : null,
  npermutations : 0,
  nRowPermutations : 0,
  nColPermutations : 0,
}

let PermutateRook = _.routineFromPreAndBody( PermutateRook_pre, PermutateRook_body );

//

function permutateRook( o )
{
  let self = this;
  o = _.routineOptions( permutateRook, o );
  o.m = self;
  return self.PermutateRook( o );
}

permutateRook.defaults =
{
  ... _.mapBut( PermutateRook.defaults, [ 'm' ] ),
}

// --
// relations
// --

let Statics =
{

  /* permutate */

  _VectorPermutateDimension,
  VectorPermutateForward,
  PermutateBackward,
  _PermutateLineRook,
  PermutateRook,

}

// --
// extension
// --

let Extension =
{

  //

  _permutateDimension,
  permutateForward, /* qqq : good coverage required. take into account cases with different length of permutation array and dims of the matrix */
  permutateBackward, /* qqq : good coverage required. take into account cases with different length of permutation array and dims of the matrix */

  _VectorPermutateDimension,
  VectorPermutateForward,
  PermutateBackward,

  _PermutateLineRook,
  _permutateLineRook,
  PermutateRook, /* qqq : cover please */
  permutateRook, /* qqq : cover please ( lightly ) */

  //

  Statics,

}

_.classExtend( Self, Extension );

})();
