(function _Check_s_() {

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
let longSlice = Array.prototype.slice;

let Parent = null;
let Self = _.Matrix;

_.assert( _.objectIs( _.vectorAdapter ) );
_.assert( _.routineIs( Self ), 'wMatrix is not defined, please include wMatrix.s first' );

// --
// implementation
// --

/**
 * Method isCol() checks whether the current matrix is column.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 2, 1 ] );
 * var got = matrix.isCol();
 * console.log( got );
 * // log : true
 *
 * @returns { Boolean } - Returns value of whether the matrix is column.
 * @method isSquare
 * @throws { Error } If arguments are provided.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function isCol()
{
  let self = this;
  if( self.dims[ 1 ] !== 1 )
  return false;
  if( self.dims.length !== 2 )
  {
    for( let i = 2 ; i < self.dims.length ; i++ )
    if( self.dims[ i ] !== 1 )
    return false;
  }
  return true;
}

//

/**
 * Method isRow() checks whether the current matrix is row.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 1, 2 ] );
 * var got = matrix.isCol();
 * console.log( got );
 * // log : true
 *
 * @returns { Boolean } - Returns value of whether the matrix is row.
 * @method isSquare
 * @throws { Error } If arguments are provided.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function isRow()
{
  let self = this;
  if( self.dims[ 0 ] !== 1 )
  return false;
  if( self.dims.length !== 2 )
  {
    for( let i = 2 ; i < self.dims.length ; i++ )
    if( self.dims[ i ] !== 1 )
    return false;
  }
  return true;
}

//

/**
 * Method isSquare() checks the equality of current matrix dimensions.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 1, 2 ] );
 * var got = matrix.isSquare();
 * console.log( got );
 * // log : false
 *
 * @returns { Boolean } - Returns value whether is the instance square matrix.
 * @method isSquare
 * @throws { Error } If arguments are provided.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function isSquare()
{
  let self = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return self.dims[ 0 ] === self.dims[ 1 ];
}

//

/**
 * Check if current matrix is diagonal.
 *
 * @example
 * var matrix =  _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   3,  2,   3,
 *   0,  -1,  1,
 *   4,  -5,  2
 * ]);
 * matrix.isDiagonal();
 * // returns : false;
 *
 * var matrix =  _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   3,  0,   0,
 *   0,  -1,  0,
 *   0,  0,   2
 * ]);
 * matrix.isDiagonal();
 * // returns : true
 *
 * @returns { Boolean } Returns true if the matrix is diagonal and false if not.
 * @function isDiagonal
 * @throws { Error } If arguments are provided.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function isDiagonal()
{
  let self = this;

  _.assert( _.Matrix.Is( self ) );
  _.assert( arguments.length === 0 );

  let cols = self.length;
  let rows = self.scalarsPerElement;

  for( let i = 0; i < rows; i++ )
  {
    for( let j = 0; j < cols; j++ )
    {
      if( j !== i && self.scalarGet( [ i, j ]) !== 0 )
      return false
    }
  }

  return true;
}

//

/**
 * Check if current matrix is upper triangular
 *
 * @example
 * var matrix =  _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   3,  2,   3,
 *   0,  -1,  1,
 *   0,  0,   2
 * ]);
 * matrix.isUpperTriangle();
 * // returns true;
 *
 * var matrix =  _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   3,  2,   3,
 *   0,  -1,  1,
 *   4,  0,   2
 * ]);
 * matrix.isUpperTriangle();
 * // returns false;
 *
 * @returns { Boolean } Returns true if the matrix is upper triangular and false if not.
 * @function isUpperTriangle
 * @throws { Error } An Error if ( this ) is not a matrix.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function isUpperTriangle( accuracy )
{
  let self = this;

  _.assert( _.Matrix.Is( self ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !_.numberIs( accuracy ) || arguments.length === 0 )
  accuracy = 1E-5;

  let cols = self.length;
  let rows = self.scalarsPerElement;

  for( let i = 0; i < rows; i++ )
  {
    for( let j = 0; j < cols; j++ )
    {
      if( i > j )
      {
        let point = self.scalarGet([ i, j ]);
        if( 0 - accuracy > point || point > 0 + accuracy )
        {
          return false
        }
      }
    }
  }

  return true;
}

//

/**
 * Check if current matrix is symmetric.
 *
 * @example
 * var matrix =  _.Matrix.MakeSquare
 * ([
 *   1,  0,
 *   0, -1
 * ]);
 * matrix.isSymmetric();
 * // returns : true;
 *
 * var matrix =  _.Matrix.MakeSquare
 * ([
 *   1,  0,
 *   1, -1,
 * ]);
 * matrix.isSymmetric();
 * // returns false;
 *
 * @param { this } - The source matrix.
 * @returns { Boolean } Returns true if the matrix is symmetric and false if not.
 * @function isSymmetric
 * @throws { Error } An Error if ( this ) is not a matrix.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function isSymmetric( accuracy )
{
  let self = this;

  _.assert( _.Matrix.Is( self ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !_.numberIs( accuracy ) || arguments.length === 0 )
  accuracy = 1E-5; /* xxx */

  let cols = self.length;
  let rows = self.scalarsPerElement;

  if( cols !== rows )
  {
    return false;
  }

  for( let i = 0; i < rows; i++ )
  {
    for( let j = 0; j < cols; j++ )
    {
      if( i > j )
      {
        let dif = self.scalarGet([ i, j ]) - self.scalarGet([ j, i ]);
        if( 0 - accuracy > dif || dif > 0 + accuracy )
        {
          return false
        }
      }
    }
  }

  return true;
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

  //

  isCol, /* qqq : cover and document, please */
  isRow, /* qqq : cover and document, please */
  isSquare,
  isDiagonal,
  isUpperTriangle,
  isSymmetric,

  //

  Statics,

}

_.classExtend( Self, Extension );

})();
