(function _Check_s_() {

'use strict';

let _ = _global_.wTools;
let vector = _.vectorAdapter;
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

_.assert( _.objectIs( vector ) );
_.assert( _.routineIs( Self ), 'wMatrix is not defined, please include wMatrix.s first' );

// --
// implementation
// --

/**
  * Check if a matrix is diagonal.
  *
  * @param { this } - The source matrix.
  *
  * @example
  * // returns true;
  * var matrix =  _.Matrix.make( [ 2, 3 ] ).copy
  * ([
  *   1,   0,   0,
  *   0, - 1,   0
  * ]);
  * matrix.isDiagonal( );
  *
  * // returns false;
  * var matrix =  _.Matrix.make( [ 2, 2 ] ).copy
  * ([
  *   1,   1,
  *   0, - 1
  * ]);
  * matrix.isDiagonal( );
  *
  * @returns { Boolean } Returns true if the matrix is diagonal and false if not.
  * @function isDiagonal
  * @throws { Error } An Error if ( this ) is not a matrix.
  * @memberof wTools.wMatrix
  */

function isDiagonal()
{
  let self = this;

  _.assert( _.Matrix.Is( self ) );
  _.assert( arguments.length === 0 );

  let cols = self.length;
  let rows = self.atomsPerElement;

  for( let i = 0; i < rows; i++ )
  {
    for( let j = 0; j < cols; j++ )
    {
      debugger;
      if( j !== i && self.atomGet( [ i, j ]) !== 0 )
      return false
    }
  }

  return true;
}

//

/**
  * Check if a matrix is upper triangular
  *
  * @param { this } - The source matrix.
  *
  * @example
  * // returns true;
  * var matrix =  _.Matrix.make( [ 2, 3 ] ).copy
  * ([
  *   1,   0,   1,
  *   0, - 1,   0
  * ]);
  * matrix.isUpperTriangle( );
  *
  * // returns false;
  * var matrix =  _.Matrix.make( [ 2, 2 ] ).copy
  * ([
  *   1,   0,
  *   1, - 1
  * ]);
  * matrix.isUpperTriangle( );
  *
  * @returns { Boolean } Returns true if the matrix is upper triangular and false if not.
  * @function isUpperTriangle
  * @throws { Error } An Error if ( this ) is not a matrix.
  * @memberof wTools.wMatrix
  */

function isUpperTriangle( accuracy )
{
  let self = this;

  _.assert( _.Matrix.Is( self ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !_.numberIs( accuracy ) || arguments.length === 0 )
  accuracy = 1E-5;

  let cols = self.length;
  let rows = self.atomsPerElement;

  for( let i = 0; i < rows; i++ )
  {
    for( let j = 0; j < cols; j++ )
    {
      debugger;
      if( i > j )
      {
        let point = self.atomGet([ i, j ]);
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
  * Check if a matrix is symmetric.
  *
  * @param { this } - The source matrix.
  *
  * @example
  * // returns true;
  * var matrix =  _.Matrix.make( [ 2, 3 ] ).copy
  * ([
  *   1,   0,
  *   0, - 1
  * ]);
  * matrix.isSymmetric( );
  *
  * // returns false;
  * var matrix =  _.Matrix.make( [ 2, 3 ] ).copy
  * ([
  *   1,   0,  0,
  *   1, - 1,  0
  * ]);
  * matrix.isSymmetric( );
  *
  * @returns { Boolean } Returns true if the matrix is symmetric and false if not.
  * @function isSymmetric
  * @throws { Error } An Error if ( this ) is not a matrix.
  * @memberof wTools.wMatrix
  */

function isSymmetric( accuracy )
{
  let self = this;

  _.assert( _.Matrix.Is( self ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !_.numberIs( accuracy ) || arguments.length === 0 )
  accuracy = 1E-5; /* xxx */

  let cols = self.length;
  let rows = self.atomsPerElement;

  if( cols !== rows )
  {
    return false;
  }

  for( let i = 0; i < rows; i++ )
  {
    for( let j = 0; j < cols; j++ )
    {
      debugger;
      if( i > j )
      {
        let dif = self.atomGet([ i, j ]) - self.atomGet([ j, i ]);
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

let Extend =
{

  //

  isDiagonal,
  isUpperTriangle,
  isSymmetric,

  //

  Statics,

}

_.classExtend( Self, Extend );

})();
