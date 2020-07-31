(function _Checker_s_() {

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
 * @method isCol
 * @throws { Error } If arguments are provided.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function isCol()
{
  _.assert( arguments.length === 0, 'Expects no arguments' );

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
 * var got = matrix.isRow();
 * console.log( got );
 * // log : true
 *
 * @returns { Boolean } - Returns value of whether the matrix is row.
 * @method isRow
 * @throws { Error } If arguments are provided.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function isRow()
{
  _.assert( arguments.length === 0, 'Expects no arguments' );

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
 * Method isHorizontal() checks whether the number of rows is less than the number of columns.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 2, 4 ] );
 * var got = matrix.isHorizontal();
 * console.log( got );
 * // log : true
 *
 * var matrix = _.Matrix.Make( [ 2, 2 ] );
 * var got = matrix.isHorizontal();
 * console.log( got );
 * // log : false
 *
 * @returns { Boolean } - Returns value whether is the instance horizontal matrix.
 * @method isHorizontal
 * @throws { Error } If arguments are provided.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function isHorizontal()
{
  let self = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return self.dims[ 0 ] < self.dims[ 1 ];
}

//

/**
 * Method isVertical() checks whether the number of rows is more than the number of columns.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 4, 2 ] );
 * var got = matrix.isVertical();
 * console.log( got );
 * // log : true
 *
 * var matrix = _.Matrix.Make( [ 2, 2 ] );
 * var got = matrix.isVertical();
 * console.log( got );
 * // log : false
 *
 * @returns { Boolean } - Returns value whether is the instance vertical matrix.
 * @method isVertical
 * @throws { Error } If arguments are provided.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function isVertical()
{
  let self = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return self.dims[ 0 ] > self.dims[ 1 ];
}

//

/**
 * Method isDiagonal() checks whether the current matrix is diagonal.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   3,  2,   3,
 *   0,  -1,  1,
 *   4,  -5,  2
 * ]);
 * matrix.isDiagonal();
 * // returns : false;
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   3,  0,  0,
 *   0,  1,  0,
 *   0,  0,  2
 * ]);
 * matrix.isDiagonal();
 * // returns : true
 *
 * @param { Number } accuracy - The accuracy of comparing.
 * @returns { Boolean } - Returns true if the matrix is diagonal, and false if not.
 * @function isDiagonal
 * @throws { Error } If arguments.length is more then 1.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function isDiagonal( accuracy )
{
  let self = this;

  _.assert( _.Matrix.Is( self ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !_.numberIs( accuracy ) || arguments.length === 0 )
  accuracy = self.accuracySqrt;

  let ncol = self.ncol;
  let nrow = self.nrow;

  for( let i = 0; i < nrow; i++ )
  {
    for( let j = 0; j < ncol; j++ )
    {
      // if( j !== i && self.scalarGet( [ i, j ]) !== 0 )
      let isElementEqualToZero = _.numbersAreEquivalent( self.scalarGet([ i, j ]), 0, accuracy );
      if( j !== i && !isElementEqualToZero )
      return false
    }
  }

  return true;
}

//

/**
 * Method isIdentity() checks whether the current matrix is identity.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   3,  2,   3,
 *   0,  -1,  1,
 *   4,  -5,  2
 * ]);
 * matrix.isIdentity();
 * // returns : false;
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   1,  0,  0,
 *   0,  1,  0,
 *   0,  0,  1
 * ]);
 * matrix.isIdentity();
 * // returns : true
 *
 * @param { Number } accuracy - The accuracy of comparing.
 * @returns { Boolean } - Returns true if the matrix is identity, and false if not.
 * @function isIdentity
 * @throws { Error } If arguments.length is more then 1.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function isIdentity( accuracy )
{
  let self = this;

  _.assert( _.Matrix.Is( self ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !_.numberIs( accuracy ) || arguments.length === 0 )
  accuracy = self.accuracySqrt;

  let ncol = self.ncol;
  let nrow = self.nrow;

  for( let i = 0; i < nrow; i++ )
  {
    for( let j = 0; j < ncol; j++ )
    {
      if( j !== i && !_.numbersAreEquivalent( self.scalarGet([ i, j ]), 0, accuracy ) )
      return false

      if( j === i && !_.numbersAreEquivalent( self.scalarGet([ i, j ]), 1, accuracy ) )
      return false
    }
  }

  return true;
}

//

/**
 * Method isScalar() checks whether all diagonal elements are equal to same scalar and all other elements are zero.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   3,  0,  0,
 *   0, -1,  0,
 *   0,  0,  2
 * ]);
 * matrix.isScalar();
 * // returns : false;
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   3,  0,  0,
 *   0,  3,  0,
 *   0,  0,  3
 * ]);
 * matrix.isScalar();
 * // returns : true
 *
 * @param { Number } accuracy - The accuracy of comparing.
 * @returns { Boolean } - Returns true if the matrix is scalar matrix, and false if not.
 * @function isScalar
 * @throws { Error } If arguments.length is more then 1.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function isScalar( accuracy )
{
  let self = this;

  _.assert( _.Matrix.Is( self ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !_.numberIs( accuracy ) || arguments.length === 0 )
  accuracy = self.accuracySqrt;

  let ncol = self.ncol;
  let nrow = self.nrow;

  let firstElem = self.scalarGet([ 0, 0 ]);

  for( let i = 0; i < nrow; i++ )
  {
    for( let j = 0; j < ncol; j++ )
    {
      if( j !== i && !_.numbersAreEquivalent( self.scalarGet([ i, j ]), 0, accuracy ) )
      return false

      if( j === i && !_.numbersAreEquivalent( self.scalarGet([ i, j ]), firstElem, accuracy ) )
      return false
    }
  }

  return true;
}

//

/**
 * Method isZero() checks whether all elements are zero.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   3,  0,  0,
 *   0, -1,  0,
 *   0,  0,  2
 * ]);
 * matrix.isZero();
 * // returns : false;
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   0,  0,  0,
 *   0,  0,  0,
 *   0,  0,  0
 * ]);
 * matrix.isZero();
 * // returns : true
 *
 * @param { Number } accuracy - The accuracy of comparing.
 * @returns { Boolean } - Returns true if the matrix is zero, and false if not.
 * @function isZero
 * @throws { Error } If arguments.length is more then 1.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function isZero( accuracy )
{
  let self = this;

  _.assert( _.Matrix.Is( self ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !_.numberIs( accuracy ) || arguments.length === 0 )
  accuracy = self.accuracySqrt;

  let ncol = self.ncol;
  let nrow = self.nrow;

  for( let i = 0; i < nrow; i++ )
  for( let j = 0; j < ncol; j++ )
  if( j !== i && !_.numbersAreEquivalent( self.scalarGet([ i, j ]), 0, accuracy ) )
  return false;

  return true;
}

//

/**
 * Method isUpperTriangle() checks whether the current matrix is upper triangular.
 *
 * @example
 * var matrix =  _.Matrix.MakeSquare
 * ([
 *   3,  2,  3,
 *   0,  1,  1,
 *   0,  0,  2
 * ]);
 * matrix.isUpperTriangle();
 * // returns true;
 *
 * @example
 * var matrix =  _.Matrix.MakeSquare
 * ([
 *   3,  2,  3,
 *   0,  1,  1,
 *   4,  0,  2
 * ]);
 * matrix.isUpperTriangle();
 * // returns false;
 *
 * @returns { Boolean } - Returns true if the matrix is upper triangular, and false if not.
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
  accuracy = self.accuracySqrt;

  let ncol = self.ncol;
  let nrow = self.nrow;

  for( let i = 0; i < nrow; i++ )
  for( let j = 0; j < ncol; j++ )
  if( i > j && !_.numbersAreEquivalent( self.scalarGet([ i, j ]), 0, accuracy ) )
  return false;

  return true;
}

//

/**
 * Method isLowerTriangle() checks whether the current matrix is upper triangular.
 *
 * @example
 * var matrix =  _.Matrix.MakeSquare
 * ([
 *   3,  2,  3,
 *   0,  1,  1,
 *   0,  0,  2
 * ]);
 * matrix.isLowerTriangle();
 * // returns true;
 *
 * @example
 * var matrix =  _.Matrix.MakeSquare
 * ([
 *   3,  2,  3,
 *   0,  1,  1,
 *   4,  0,  2
 * ]);
 * matrix.isLowerTriangle();
 * // returns false;
 *
 * @returns { Boolean } - Returns true if the matrix is upper triangular, and false if not.
 * @function isLowerTriangle
 * @throws { Error } An Error if ( this ) is not a matrix.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function isLowerTriangle( accuracy )
{
  let self = this;

  _.assert( _.Matrix.Is( self ) );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !_.numberIs( accuracy ) || arguments.length === 0 )
  accuracy = self.accuracySqrt;

  let ncol = self.ncol;
  let nrow = self.nrow;

  for( let i = 0; i < nrow; i++ )
  for( let j = 0; j < ncol; j++ )
  if( i < j && !_.numbersAreEquivalent( self.scalarGet([ i, j ]), 0, accuracy ) )
  return false;

  return true;
}

//

/**
 * Method isSymmetric() checks whether the current matrix is symmetric.
 *
 * @example
 * var matrix =  _.Matrix.MakeSquare
 * ([
 *   1,  2,  3,
 *   2,  8,  2,
 *   3,  2,  4,
 * ]);
 * matrix.isSymmetric();
 * // returns : true;
 *
 * @example
 * var matrix =  _.Matrix.MakeSquare
 * ([
 *   1,  2,  3,
 *   4,  8,  2,
 *   4,  4,  4,
 * ]);
 * matrix.isSymmetric();
 * // returns false;
 *
 * @param { Number } accuracy - The accuracy of comparing.
 * @returns { Boolean } - Returns true if the matrix is symmetric, and false if not.
 * @function isSymmetric
 * @throws { Error } If arguments.length is greater then 1.
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
  accuracy = self.accuracySqrt;

  let ncol = self.ncol;
  let nrow = self.nrow;

  if( ncol !== nrow )
  {
    return false;
  }

  for( let i = 0; i < nrow; i++ )
  {
    for( let j = 0; j < ncol; j++ )
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

//

function _EquivalentSpace_pre( routine, args )
{
  let proto = this;
  let o = args[ 0 ];

  if( !_.mapIs( o ) )
  o = { m1 : args[ 0 ], m2 : args[ 1 ] }

  o = _.routineOptions( routine, o );

  if( o.m1 )
  o.m1 = proto.From( o.m1 );
  if( o.m2 )
  o.m2 = proto.From( o.m2 );

  _.assert( arguments.length === 1 || arguments.length === 2 );

  return o;
}

//

function _EquivalentSpace( o )
{
  let proto = this;

  _.assertMapHasAll( o, _EquivalentSpace.defaults );

  let dim2 = o.dim + 1 === 2 ? 0 : 1;

  if( o.m1.dims[ dim2 ] < o.m2.dims[ dim2 ] )
  {
    let ex = o.m1;
    o.m1 = o.m2;
    o.m2 = ex;
  }

  let ncol1 = o.m1.dims[ dim2 ];
  let ncol2 = o.m2.dims[ dim2 ];
  let nrow1 = o.m1.dims[ o.dim ];
  let nrow2 = o.m2.dims[ o.dim ];

  o.left = ncol2;
  o.found = _.dup( 0, ncol1 + ncol2 );

  if( nrow1 !== nrow2 )
  {
    o.result = false;
    return o;
  }

  for( let c1 = 0 ; c1 < ncol1 ; c1++ )
  {
    let col1 = o.m1.lineGet( o.dim, c1 );
    if( col1.magSqr() <= proto.accuracySqr )
    continue;
    for( let c2 = 0 ; c2 < ncol2 ; c2++ )
    {
      let col2 = o.m2.lineGet( o.dim, c2 );
      if( col2.magSqr() <= proto.accuracySqr )
      {
        o.left -= 1;
        continue;
      }
      if( col1.areParallel( col2 ) )
      {
        if( o.found[ ncol1 + c2 ] === 0 )
        o.left -= 1;
        o.found[ c1 ] += 1;
        o.found[ ncol1 + c2 ] += 1;
      }
    }
  }

  o.result = o.left === 0;

  return o;
}

_EquivalentSpace.defaults =
{
  m1 : null,
  m2 : null,
  dim : null,
}

//

function EquivalentColumnSpace_body( o )
{
  let proto = this;
  _.assert( arguments.length === 1 );
  o = proto._EquivalentSpace( o );
  return o.result;
}

EquivalentColumnSpace_body.defaults =
{
  ... _EquivalentSpace.defaults,
  dim : 0,
}

let EquivalentColumnSpace = _.routineFromPreAndBody( _EquivalentSpace_pre, EquivalentColumnSpace_body );

//

function EquivalentRowSpace_body( o )
{
  let proto = this;
  _.assert( arguments.length === 1 );
  o = proto._EquivalentSpace( o );
  return o.result;
}

EquivalentRowSpace_body.defaults =
{
  ... _EquivalentSpace.defaults,
  dim : 1,
}

let EquivalentRowSpace = _.routineFromPreAndBody( _EquivalentSpace_pre, EquivalentRowSpace_body );

// --
// relations
// --

let Statics =
{

  _EquivalentSpace,
  EquivalentColumnSpace,
  EquivalentRowSpace,

}

// --
// extension
// --

let Extension =
{

  //

  isCol, /* qqq : cover and document, please */ /* Andrey: covered */
  isRow, /* qqq : cover and document, please */ /* Andrey: covered */
  isSquare,
  isHorizontal,
  isVertical,
  isDiagonal,
  isIdentity,
  isScalar,
  isZero,
  isUpperTriangle,
  isLowerTriangle,
  isSymmetric,
  /* qqq : missing checks? */

  _EquivalentSpace,
  EquivalentColumnSpace,
  EquivalentRowSpace,

  //

  Statics,

}

_.classExtend( Self, Extension );

})();
