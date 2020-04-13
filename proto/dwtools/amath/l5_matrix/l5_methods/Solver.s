(function _Solve_s_() {

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
// triangulator
// --

function _triangulateGausian( o )
{
  let self = this;
  let nrow = self.nrow;
  let ncol = Math.min( self.ncol, nrow );

  _.routineOptions( _triangulateGausian, o );

  if( o.onPivot && !o.pivots )
  {
    o.pivots = [];
    for( let i = 0 ; i < self.dims.length ; i += 1 )
    o.pivots[ i ] = _.longFromRange([ 0, self.dims[ i ] ]);
  }

  if( o.y !== null )
  o.y = Self.From( o.y );

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( !o.y || o.y.dims[ 0 ] === self.dims[ 0 ] );

  /* */

  if( o.y )
  for( let r1 = 0 ; r1 < ncol ; r1++ )
  {

    if( o.onPivot )
    o.onPivot.call( self, r1, o );

    let row1 = self.rowGet( r1 );
    let yrow1 = o.y.rowGet( r1 );
    let scaler1 = row1.eGet( r1 );
    if( o.normal )
    {
      self.vectorAdapter.div( row1, scaler1 );
      self.vectorAdapter.div( yrow1, scaler1 );
      scaler1 = 1;
    }

    for( let r2 = r1+1 ; r2 < nrow ; r2++ )
    {
      let row2 = self.rowGet( r2 );
      let yrow2 = o.y.rowGet( r2 );
      let scaler = row2.eGet( r1 ) / scaler1;
      self.vectorAdapter.subScaled( row2, row1, scaler );
      self.vectorAdapter.subScaled( yrow2, yrow1, scaler );
    }

    // logger.log( 'self', self );

  }
  else for( let r1 = 0 ; r1 < ncol ; r1++ )
  {

    if( o.onPivot )
    o.onPivot.call( self, r1, o );

    let row1 = self.rowGet( r1 );
    let scaler1 = row1.eGet( r1 );
    if( o.normal )
    {
      self.vectorAdapter.div( row1, scaler1 );
      scaler1 = 1;
    }

    for( let r2 = r1+1 ; r2 < nrow ; r2++ )
    {
      let row2 = self.rowGet( r2 );
      let scaler = row2.eGet( r1 ) / scaler1;
      self.vectorAdapter.subScaled( row2, row1, scaler );
    }

    // logger.log( 'self', self );

  }

  return o.pivots;
}

_triangulateGausian.defaults =
{
  y : null,
  onPivot : null,
  pivots : null,
  normal : 0,
}

//

/**
 * Method triangulateGausian() provides triangulation by Gauss method.
 * Optionally this transformation can be applied to vector {-y-}.
 *
 * @example
 * var m = _.Matrix.Make([ 3, 3 ]).copy
 * ([
 *   +1, -2,  +2,
 *   +5, -15, +8,
 *   -2, -11, -11,
 * ]);
 *
 * var y = _.Matrix.MakeCol([ 1, 1, 1 ]);
 *
 * m.triangulateGausian( y );
 * console.log( m.toStr() );
 * // log :
 * // +1, -2, +2,
 * // +0, -5, -2,
 * // +0, +0, -1,
 * console.log( y.toStr() );
 * // log :
 * // +1,
 * // -4,
 * // +15
 *
 * @param { Matrix } y - Column vector to transform.
 * @returns { Matrix } - Returns triangulated vector, performs triangulation of the matrix.
 * @method triangulateGausian
 * @throws { Error } If vector {-y-} has length different to number or rows in current matrix.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function triangulateGausian( y )
{
  let self = this;
  let o = Object.create( null );
  o.y = y;
  return self._triangulateGausian( o );
}

//

/**
 * Method triangulateGausianNormal() calculates normal to elements and provides triangulation by Gauss method.
 * Optionally this transformation can be applied to vector {-y-}.
 *
 * @example
 * var m = _.Matrix.Make([ 3, 3 ]).copy
 * ([
 *   +1, -2,  +2,
 *   +5, -15, +8,
 *   -2, -11, -11,
 * ]);
 *
 * var y = _.Matrix.MakeCol([ 1, 1, 1 ]);
 *
 * m.triangulateGausianNormal( y );
 * console.log( m.toStr() );
 * // log :
 * // +1, -2, +2,
 * // +0, +1, 0.4,
 * // +0, +0, 1,
 * console.log( y.toStr() );
 * // log :
 * // +1,
 * // +0.8,
 * // -15
 *
 * @param { Matrix } y - Column vector to transform.
 * @returns { Matrix } - Returns triangulated vector, performs triangulation of the matrix.
 * @method triangulateGausianNormal
 * @throws { Error } If vector {-y-} has length different to number or rows in current matrix.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function triangulateGausianNormal( y )
{
  let self = this;
  let o = Object.create( null );
  o.y = y;
  o.normal = 1;
  return self._triangulateGausian( o );
}

//

/**
 * Method triangulateGausianPivoting() provides triangulation with pivoting by Gauss method.
 * Optionally this transformation can be applied to vector {-y-}.
 *
 * @example
 * var m = _.Matrix.Make([ 3, 4 ]).copy
 * ([
 *   +1, +3, +1, +2,
 *   +2, +6, +4, +8,
 *   +0, +0, +2, +4,
 * ]);
 *
 * var y = _.Matrix.MakeCol([ +1, +3, +1 ]);
 * var pivots = m.triangulateGausianPivoting( y );
 * test.identical( m, em );
 * console.log( m.toStr() );
 * // log :
 * // +3, +2, +1, +1,
 * // +0, +4, +2, +0,
 * // +0, +0, +0, +0,
 * console.log( pivots );
 * // log : [ [ 0, 1, 2 ], [ 1, 3, 2, 0 ] ]
 *
 * @param { Matrix } y - Column vector to transform.
 * @returns { Matrix } - Returns triangulated vector, performs triangulation of the matrix.
 * @method triangulateGausianPivoting
 * @throws { Error } If vector {-y-} has length different to number or rows in current matrix.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function triangulateGausianPivoting( y )
{
  let self = this;
  let o = Object.create( null );
  o.y = y;
  o.onPivot = self._PivotRook;
  return self._triangulateGausian( o );
}

//

/**
 * Method triangulateGausian() provides triangulation by Lu method.
 *
 * @example
 * var m = _.Matrix.Make([ 3, 3 ]).copy
 * ([
 *   +1, -2,  +2,
 *   +5, -15, +8,
 *   -2, -11, -11,
 * ]);
 *
 * m.triangulateLu();
 * console.log( m.toStr() );
 * // log :
 * // +1, -2, +2,
 * // +5, -5, -2,
 * // -2, +3, -1,
 *
 * @returns { Matrix } - Returns triangulated matrix.
 * @method triangulateLu
 * @throws { Error } If arguments are passed.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function triangulateLu()
{
  let self = this;
  let nrow = self.nrow;
  let ncol = Math.min( self.ncol, nrow );

  _.assert( arguments.length === 0, 'Expects no arguments' );

  logger.log( 'self', self );

  for( let r1 = 0 ; r1 < ncol ; r1++ )
  {
    let row1 = self.rowGet( r1 );
    let scaler1 = row1.eGet( r1 );
    row1 = row1.review( r1+1 );

    for( let r2 = r1+1 ; r2 < nrow ; r2++ )
    {
      let row2 = self.rowGet( r2 );
      let scaler = row2.eGet( r1 ) / scaler1;
      self.vectorAdapter.subScaled( row2.review( r1+1 ), row1, scaler );
      row2.eSet( r1, scaler );
    }

    logger.log( 'self', self );
  }

  return self;
}

//

/**
 * Method triangulateLuNormal() calculates normal to matrix rows and provides triangulation by Lu method.
 *
 * @example
 * var m = _.Matrix.Make([ 3, 3 ]).copy
 * ([
 *   +1, -2,  +2,
 *   +5, -15, +8,
 *   -2, -11, -11,
 * ]);
 *
 * m.triangulateLuNormal();
 * console.log( m.toStr() );
 * // log :
 * // +1, -2,  +2,
 * // +5, -5,  +0.4,
 * // -2, -15, -1,
 *
 * @returns { Matrix } - Returns triangulated matrix.
 * @method triangulateLuNormal
 * @throws { Error } If arguments are passed.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function triangulateLuNormal()
{
  let self = this;
  let nrow = self.nrow;
  let ncol = Math.min( self.ncol, nrow );

  _.assert( arguments.length === 0, 'Expects no arguments' );

  for( let r1 = 0 ; r1 < ncol ; r1++ )
  {
    let row1 = self.rowGet( r1 );
    let scaler1 = row1.eGet( r1 );
    row1 = row1.review( r1+1 );
    self.vectorAdapter.div( row1, scaler1 );

    for( let r2 = r1+1 ; r2 < nrow ; r2++ )
    {
      let row2 = self.rowGet( r2 );
      let scaler = row2.eGet( r1 );
      self.vectorAdapter.subScaled( row2.review( r1+1 ), row1, scaler );
      row2.eSet( r1, scaler );
    }

  }

  return self;
}

//

/**
 * Method triangulateLuPivoting() provides triangulation of matrix with pivoting by Lu method.
 * Optionally, it accepts vector of pivots {-pivots-}.
 *
 * @example
 * var m = _.Matrix.Make([ 3, 3 ]).copy
 * ([
 *   +1, -2,  +2,
 *   +5, -15, +8,
 *   -2, -11, -11,
 * ]);
 *
 * m.triangulateLuPivoting();
 * console.log( m.toStr() );
 * // log :
 * // +5.000, -15.000, +8.000,
 * // -0.400, -17.000, -7.800,
 * // -0.200, -0.059,  -0.059,
 *
 * @returns { Long } - Returns long with pivots, provides triangulation of matrix.
 * @method triangulateLuPivoting
 * @throws { Error } If vector {-y-} has length different to number or rows in current matrix.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function triangulateLuPivoting( pivots )
{
  let self = this;
  let nrow = self.nrow;
  let ncol = Math.min( self.ncol, nrow );

  if( !pivots )
  {
    pivots = [];
    for( let i = 0 ; i < self.dims.length ; i += 1 )
    pivots[ i ] = _.longFromRange([ 0, self.dims[ i ] ]);
  }

  let o = Object.create( null );
  o.pivots = pivots;

  /* */

  _.assert( self.dims.length === 2 );
  _.assert( _.arrayIs( pivots ) );
  _.assert( pivots.length === 2 );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  /* */

  logger.log( 'self', self );

  for( let r1 = 0 ; r1 < ncol ; r1++ )
  {

    self._PivotRook.call( self, r1, o );

    let row1 = self.rowGet( r1 );
    let scaler1 = row1.eGet( r1 );
    row1 = row1.review( r1+1 );

    for( let r2 = r1+1 ; r2 < nrow ; r2++ )
    {
      let row2 = self.rowGet( r2 );
      let scaler = row2.eGet( r1 ) / scaler1;
      self.vectorAdapter.subScaled( row2.review( r1+1 ), row1, scaler );
      row2.eSet( r1, scaler );
    }

    logger.log( 'self', self );

  }

  return pivots;
}

//

function _PivotRook( i, o )
{
  let self = this;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( o.pivots )

  let row1 = self.rowGet( i ).review( i );
  let col1 = self.colGet( i ).review( i );
  let value = row1.eGet( 0 );

  let maxr = self.vectorAdapter.reduceToMaxAbs( row1 );
  let maxc = self.vectorAdapter.reduceToMaxAbs( col1 );

  if( maxr.value > maxc.value )
  {
    if( maxr.value === value )
    return false;
    let i2 = maxr.index + i;
    _.longSwapElements( o.pivots[ 1 ], i, i2 );
    self.colsSwap( i, i2 );
  }
  else
  {
    if( maxc.value === value )
    return false;
    let i2 = maxc.index + i;
    _.longSwapElements( o.pivots[ 0 ], i, i2 );
    self.rowsSwap( i, i2 );
    if( o.y )
    o.y.rowsSwap( i, i2 );
  }

  return true;
}

// --
// Solver
// --

/**
 * Static routine Solve() solves system of equations.
 *
 * @example
 * var matrixA = _.Matrix.MakeSquare( [ [ 3, -2, 2, 3 ] ] );
 * var matrixB = _.Matrix.MakeCol( [ 1, 2 ] );
 *
 * var matrixX = _.Matrix.Solve( null, matrixA, matrixB );
 *
 * console.log( `x1 : ${ matrixX.scalarGet( [ 0, 0 ] ) },\nx2 : ${ matrixX.scalarGet( [ 1, 0 ] ) }` );
 * // log :
 * // x1 : 0.5384615659713745,
 * // x2 : 0.307692289352417
 *
 * @param { Null|Matrix } x - Destination matrix.
 * @param { Matrix } m - Matrix of coefficients.
 * @param { Matrix } y - Matrix of results.
 * @returns { Matrix } - Returns the matrix with unknowns.
 * @throws { Error } If arguments.length is not equal to three.
 * @function Solve
 * @static
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function Solve( x, m, y )
{
  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  return this.SolveWithTrianglesPivoting( x, m, y )
}

//

function _Solve_pre( args )
{
  let self = this;
  let o = Object.create( null );
  o.x = args[ 0 ];
  o.m = args[ 1 ];
  o.y = args[ 2 ];

  o.oy = o.y;
  o.ox = o.x;

  if( o.x === null )
  {
    if( _.longIs( o.y ) )
    o.x = o.y.slice();
    else
    o.x = o.y.clone();
    o.ox = o.x;
  }
  else
  {
    if( !_.matrixIs( o.x ) )
    o.x = self.vectorAdapter.from( o.x );
    this.CopyTo( o.x, o.y );
  }

  if( !_.matrixIs( o.y ) )
  o.y = self.vectorAdapter.from( o.y );

  if( !_.matrixIs( o.x ) )
  o.x = self.vectorAdapter.from( o.x );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( this.ShapesAreSame( o.x , o.y ) );
  _.assert( o.m.dims[ 0 ] === this.NrowOf( o.x ) );

  return o;
}

//

/**
 * Static routine SolveWithGausian() solves system of equations by Gaussian method.
 *
 * @example
 * var matrixA = _.Matrix.MakeSquare( [ [ 3, -2, 2, 3 ] ] );
 * var matrixB = _.Matrix.MakeCol( [ 1, 2 ] );
 *
 * var matrixX = _.Matrix.SolveWithGausian( null, matrixA, matrixB );
 *
 * console.log( `x1 : ${ matrixX.scalarGet( [ 0, 0 ] ) },\nx2 : ${ matrixX.scalarGet( [ 1, 0 ] ) }` );
 * // log :
 * // x1 : 0.538,
 * // x2 : 0.308
 *
 * @param { Null|Matrix } x - Destination matrix.
 * @param { Matrix } m - Matrix of coefficients.
 * @param { Matrix } y - Matrix of results.
 * @returns { Matrix } - Returns the matrix with unknowns.
 * @throws { Error } If dimensions of {-x-} and {-y-} are different.
 * @throws { Error } If number of rows of {-m-} is not equal to number of rows of {-x-}.
 * @function SolveWithGausian
 * @static
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function SolveWithGausian()
{
  let o = this._Solve_pre( arguments );

  o.m.triangulateGausian( o.x );
  this.SolveTriangleUpper( o.x, o.m, o.x );

  // o.x = this.ConvertToClass( o.oy.constructor, o.x );
  return o.ox;
}

//

/**
 * Static routine SolveWithGausianPivoting() solves system of equations by Gaussian method with pivoting.
 *
 * @example
 * var matrixA = _.Matrix.MakeSquare( [ [ 3, -2, 2, 3 ] ] );
 * var matrixB = _.Matrix.MakeCol( [ 1, 2 ] );
 *
 * var matrixX = _.Matrix.SolveWithGausianPivoting( null, matrixA, matrixB );
 *
 * console.log( `x1 : ${ matrixX.scalarGet( [ 0, 0 ] ) },\nx2 : ${ matrixX.scalarGet( [ 1, 0 ] ) }` );
 * // log :
 * // x1 : 0.641,
 * // x2 : 0.462
 *
 * @param { Null|Matrix } x - Destination matrix.
 * @param { Matrix } m - Matrix of coefficients.
 * @param { Matrix } y - Matrix of results.
 * @returns { Matrix } - Returns the matrix with unknowns.
 * @method SolveWithGausianPivoting
 * @throws { Error } If dimensions of {-x-} and {-y-} are different.
 * @throws { Error } If number of rows of {-m-} is not equal to number of rows of {-x-}.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function SolveWithGausianPivoting()
{
  let o = this._Solve_pre( arguments );

  let pivots = o.m.triangulateGausianPivoting( o.x );
  this.SolveTriangleUpper( o.x, o.m, o.x );
  Self.VectorPivotBackward( o.x, pivots[ 1 ] );

  return o.ox;
}

//

function _SolveWithGaussJordan( o )
{
  let self = this;

  let nrow = o.m.nrow;
  let ncol = Math.min( o.m.ncol, nrow );

  o.x = this.From( o.x );
  o.y = o.x;

  /* */

  if( o.onPivot && !o.pivots )
  {
    o.pivots = [];
    for( let i = 0 ; i < o.m.dims.length ; i += 1 )
    o.pivots[ i ] = _.longFromRange([ 0, o.m.dims[ i ] ]);
  }

  /* */

  for( let r1 = 0 ; r1 < ncol ; r1++ )
  {

    if( o.onPivot )
    o.onPivot.call( o.m, r1, o );

    let row1 = o.m.rowGet( r1 );
    let scaler1 = row1.eGet( r1 );

    if( abs( scaler1 ) < this.accuracy )
    continue;

    self.vectorAdapter.mul( row1, 1/scaler1 );

    let xrow1 = o.x.rowGet( r1 );
    self.vectorAdapter.mul( xrow1, 1/scaler1 );

    for( let r2 = 0 ; r2 < nrow ; r2++ )
    {

      if( r1 === r2 )
      continue;

      let xrow2 = o.x.rowGet( r2 );
      let row2 = o.m.rowGet( r2 );
      let scaler2 = row2.eGet( r1 );
      let scaler = scaler2;

      self.vectorAdapter.subScaled( row2, row1, scaler );
      self.vectorAdapter.subScaled( xrow2, xrow1, scaler );

    }

  }

  /* */

  if( o.onPivot && o.pivotingBackward )
  {
    Self.VectorPivotBackward( o.x, o.pivots[ 1 ] );
    /*o.m.pivotBackward( o.pivots );*/
  }

  /* */

  // o.x = this.ConvertToClass( o.oy.constructor, o.x );
  return o.ox;
}

//

/**
 * Static routine SolveWithGaussJordan() solves system of equations by Gauss-Jordan method.
 *
 * @example
 * var matrixA = _.Matrix.MakeSquare( [ [ 3, -2, 2, 3 ] ] );
 * var matrixB = _.Matrix.MakeCol( [ 1, 2 ] );
 *
 * var matrixX = _.Matrix.SolveWithGaussJordan( null, matrixA, matrixB );
 *
 * console.log( `x1 : ${ matrixX.scalarGet( [ 0, 0 ] ) },\nx2 : ${ matrixX.scalarGet( [ 1, 0 ] ) }` );
 * // log :
 * // x1 : 0.641,
 * // x2 : 0.462
 *
 * @param { Null|Matrix } x - Destination matrix.
 * @param { Matrix } m - Matrix of coefficients.
 * @param { Matrix } y - Matrix of results.
 * @returns { Matrix } - Returns the matrix with unknowns.
 * @throws { Error } If dimensions of {-x-} and {-y-} are different.
 * @throws { Error } If number of rows of {-m-} is not equal to number of rows of {-x-}.
 * @function SolveWithGaussJordan
 * @static
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function SolveWithGaussJordan()
{
  let o = this._Solve_pre( arguments );
  return this._SolveWithGaussJordan( o );
}

//

/**
 * Static routine SolveWithGaussJordanPivoting() solves system of equations by Gauss-Jordan method with pivoting.
 *
 * @example
 * var matrixA = _.Matrix.MakeSquare( [ [ 3, -2, 2, 3 ] ] );
 * var matrixB = _.Matrix.MakeCol( [ 1, 2 ] );
 *
 * var matrixX = _.Matrix.SolveWithGaussJordanPivoting( null, matrixA, matrixB );
 *
 * console.log( `x1 : ${ matrixX.scalarGet( [ 0, 0 ] ) },\nx2 : ${ matrixX.scalarGet( [ 1, 0 ] ) }` );
 * // log :
 * // x1 : 1,
 * // x2 : 2
 *
 * @param { Null|Matrix } x - Destination matrix.
 * @param { Matrix } m - Matrix of coefficients.
 * @param { Matrix } y - Matrix of results.
 * @returns { Matrix } - Returns the matrix with unknowns.
 * @throws { Error } If dimensions of {-x-} and {-y-} are different.
 * @throws { Error } If number of rows of {-m-} is not equal to number of rows of {-x-}.
 * @function SolveWithGaussJordanPivoting
 * @static
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function SolveWithGaussJordanPivoting()
{
  let o = this._Solve_pre( arguments );
  o.onPivot = this._PivotRook;
  o.pivotingBackward = 1;
  return this._SolveWithGaussJordan( o );
}

//

/**
 * Method InvertWithGaussJordan() inverts the values of matrix by Gauss-Jordan method.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ [ 3, -2, 2, 3 ] ] );
 * var got = matrix.InvertWithGaussJordan();
 *
 * console.log( got.toStr() );
 * // log :
 * // 0.231, 0.154,
 * // -0.154, 0, 231
 *
 * @returns { Matrix } - Returns the matrix with inverted values.
 * @method InvertWithGaussJordan
 * @throws { Error } If arguments is passed.
 * @throws { Error } If current matrix is not square matrix.
 * @function InvertWithGaussJordan
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function InvertWithGaussJordan()
{
  let m = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( m.dims[ 0 ] === m.dims[ 1 ] );

  let nrow = m.nrow;

  for( let r1 = 0 ; r1 < nrow ; r1++ )
  {

    let row1 = m.rowGet( r1 ).review( r1+1 );
    let xrow1 = m.rowGet( r1 ).review([ 0, r1 ]);

    let scaler1 = 1 / xrow1.eGet( r1 );
    xrow1.eSet( r1, 1 );
    m.vectorAdapter.mul( row1, scaler1 );
    m.vectorAdapter.mul( xrow1, scaler1 );

    for( let r2 = 0 ; r2 < nrow ; r2++ )
    {

      if( r1 === r2 )
      continue;

      let row2 = m.rowGet( r2 ).review( r1+1 );
      let xrow2 = m.rowGet( r2 ).review([ 0, r1 ]);
      let scaler2 = xrow2.eGet( r1 );
      xrow2.eSet( r1, 0 )

      m.vectorAdapter.subScaled( row2, row1, scaler2 );
      m.vectorAdapter.subScaled( xrow2, xrow1, scaler2 );

    }

    // logger.log( 'm', m );

  }

  return m;
}

//

/**
 * Static routine SolveWithTriangles() solves system of equations by triangles method.
 *
 * @example
 * var m = _.Matrix.MakeSquare
 * ([
 *   1, 5, 4,
 *   0, 1, 2,
 *   0, 0, 1,
 * ]);
 *
 * var y = _.Matrix.MakeCol([ 4, 2, 2 ]);
 * var x = _.Matrix.SolveWithTriangles( null, m, y );
 * console.log( x.toStr() );
 * // log :
 * //  6,
 * // -2,
 * //  2,
 *
 * @param { Null|Matrix } x - Destination matrix.
 * @param { Matrix } m - Matrix of coefficients.
 * @param { Matrix } y - Matrix of results.
 * @returns { Matrix } - Returns the matrix with unknowns.
 * @throws { Error } If dimensions of {-x-} and {-y-} are different.
 * @throws { Error } If number of rows of {-m-} is not equal to number of rows of {-x-}.
 * @function SolveWithTriangles
 * @static
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function SolveWithTriangles( x, m, y )
{

  let o = this._Solve_pre( arguments );
  m.triangulateLuNormal();

  o.x = this.SolveTriangleLower( o.x, o.m, o.y );
  o.x = this.SolveTriangleUpperNormal( o.x, o.m, o.x );

  // o.x = this.ConvertToClass( o.oy.constructor, o.x );
  return o.ox;
}

//

/**
 * Static routine SolveWithTrianglesPivoting() solves system of equations by triangles method with pivoting.
 *
 * @example
 * var m = _.Matrix.MakeSquare
 * ([
 *   +1, -1, +2,
 *   +2, +0, +2,
 *   -2, +0, -4,
 * ]);
 *
 * var y = [ 7, 4, -10 ];
 * var x = _.Matrix.SolveWithTrianglesPivoting( null, m, y );
 * console.log( x );
 * // log : [ -1, -2, +3 ]
 *
 * @param { Null|Matrix } x - Destination matrix.
 * @param { Matrix } m - Matrix of coefficients.
 * @param { Matrix } y - Matrix of results.
 * @returns { Matrix } - Returns the matrix with unknowns.
 * @throws { Error } If dimensions of {-x-} and {-y-} are different.
 * @throws { Error } If number of rows of {-m-} is not equal to number of rows of {-x-}.
 * @function SolveWithTrianglesPivoting
 * @static
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function SolveWithTrianglesPivoting( x, m, y )
{

  let o = this._Solve_pre( arguments );
  let pivots = m.triangulateLuPivoting();

  o.y = Self.VectorPivotForward( o.y, pivots[ 0 ] );

  o.x = this.SolveTriangleLowerNormal( o.x, o.m, o.y );
  o.x = this.SolveTriangleUpper( o.x, o.m, o.x );

  Self.VectorPivotBackward( o.x, pivots[ 1 ] );
  Self.VectorPivotBackward( o.y, pivots[ 0 ] );

  // o.x = this.ConvertToClass( o.oy.constructor, o.x );
  return o.ox;
}

//

function _SolveTriangleWithRoutine( args, onSolve )
{
  let x = args[ 0 ];
  let m = args[ 1 ];
  let y = args[ 2 ];

  _.assert( args.length === 3 );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( y );

  if( _.matrixIs( y ) )
  {

    if( x === null )
    {
      x = y.clone();
    }
    else
    {
      x = Self.From( x, y.dims );
      x.copy( y );
    }

    _.assert( x.hasShape( y ) );
    _.assert( x.dims[ 0 ] === m.dims[ 1 ] );

    for( let v = 0 ; v < y.dims[ 1 ] ; v++ )
    {
      onSolve( x.colGet( v ), m, y.colGet( v ) );
    }

    return x;
  }

  /* */

  y = this.vectorAdapter.from( y );

  if( x === null )
  {
    x = y.clone();
  }
  else
  {
    x = this.vectorAdapter.from( x );
    x.copy( y );
  }

  /* */

  _.assert( x.length === y.length );

  return onSolve( x, m, y );
}

//

/**
 * Static routine SolveTriangleLower() solves system of equations with lower triangular matrix.
 *
 * @example
 * var m = _.Matrix.MakeSquare
 * ([
 *   2, 0, 0,
 *   2, 3, 0,
 *   4, 5, 6,
 * ]);
 *
 * var y = _.Matrix.MakeCol([ 2, 2, 4 ]);
 * var x = _.Matrix.SolveTriangleLower( null, m, y );
 * console.log( x.toStr() );
 * // log :
 * // 1
 * // 0
 * // 0
 *
 * @param { Null|Matrix } x - Destination matrix.
 * @param { Matrix } m - Matrix of coefficients.
 * @param { Matrix } y - Matrix of results.
 * @returns { Matrix } - Returns the matrix with unknowns.
 * @throws { Error } If dimensions of {-x-} and {-y-} are different.
 * @throws { Error } If number of rows of {-m-} is not equal to number of rows of {-x-}.
 * @function SolveTriangleLower
 * @static
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function SolveTriangleLower( x, m, y )
{
  let self = this;

  function handleSolve( x, m, y )
  {

    for( let r1 = 0 ; r1 < y.length ; r1++ )
    {
      let xu = x.review([ 0, r1-1 ]);
      let row = m.rowGet( r1 );
      let scaler = row.eGet( r1 );
      row = row.review([ 0, r1-1 ]);
      let xval = ( x.eGet( r1 ) - self.vectorAdapter.dot( row, xu ) ) / scaler;
      x.eSet( r1, xval );
    }

    return x;
  }

  return self._SolveTriangleWithRoutine( arguments, handleSolve );
}

//

/**
 * Static routine SolveTriangleLowerNormal() solves system of equations with lower triangular matrix.
 *
 * @example
 * var m = _.Matrix.MakeSquare
 * ([
 *   1, 0, 0,
 *   2, 1, 0,
 *   4, 5, 1,
 * ]);
 *
 * var y = _.Matrix.MakeCol([ 2, 2, 4 ]);
 * var x = _.Matrix.SolveTriangleLowerNormal( null, m, y );
 * console.log( x.toStr() );
 * // log :
 * //  2
 * // -2
 * //  6
 *
 * @param { Null|Matrix } x - Destination matrix.
 * @param { Matrix } m - Matrix of coefficients.
 * @param { Matrix } y - Matrix of results.
 * @returns { Matrix } - Returns the matrix with unknowns.
 * @throws { Error } If dimensions of {-x-} and {-y-} are different.
 * @throws { Error } If number of rows of {-m-} is not equal to number of rows of {-x-}.
 * @function SolveTriangleLowerNormal
 * @static
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function SolveTriangleLowerNormal( x, m, y )
{
  let self = this;

  function handleSolve( x, m, y )
  {

    for( let r1 = 0 ; r1 < y.length ; r1++ )
    {
      let xu = x.review([ 0, r1-1 ]);
      let row = m.rowGet( r1 );
      row = row.review([ 0, r1-1 ]);
      let xval = ( x.eGet( r1 ) - self.vectorAdapter.dot( row, xu ) );
      x.eSet( r1, xval );
    }

    return x;
  }

  return self._SolveTriangleWithRoutine( arguments, handleSolve );
}

//

/**
 * Static routine SolveTriangleUpper() solves system of equations with upper triangular matrix.
 *
 * @example
 * var m = _.Matrix.MakeSquare
 * ([
 *   6, 5, 4,
 *   0, 3, 2,
 *   0, 0, 2,
 * ]);
 *
 * var y = _.Matrix.MakeCol([ 4, 2, 2 ]);
 * var x = _.Matrix.SolveTriangleUpper( null, m, y );
 * console.log( x.toStr() );
 * // log :
 * // 0
 * // 0
 * // 1
 *
 * @param { Null|Matrix } x - Destination matrix.
 * @param { Matrix } m - Matrix of coefficients.
 * @param { Matrix } y - Matrix of results.
 * @returns { Matrix } - Returns the matrix with unknowns.
 * @throws { Error } If dimensions of {-x-} and {-y-} are different.
 * @throws { Error } If number of rows of {-m-} is not equal to number of rows of {-x-}.
 * @function SolveTriangleUpper
 * @static
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function SolveTriangleUpper( x, m, y )
{
  let self = this;
  return self._SolveTriangleWithRoutine( arguments, handleSolve );

  function handleSolve( x, m, y )
  {

    for( let r1 = y.length-1 ; r1 >= 0 ; r1-- )
    {
      let xu = x.review([ r1+1, x.length-1 ]);
      let row = m.rowGet( r1 );
      let scaler = row.eGet( r1 );
      row = row.review([ r1+1, row.length-1 ]);
      let xval = ( x.eGet( r1 ) - self.vectorAdapter.dot( row, xu ) ) / scaler;
      x.eSet( r1, xval );
    }

    return x;
  }

}

//

/**
 * Static routine SolveTriangleUpper() solves system of equations with upper triangular matrix.
 *
 * @example
 * var m = _.Matrix.MakeSquare
 * ([
 *   1, 5, 4,
 *   0, 1, 2,
 *   0, 0, 1,
 * ]);
 *
 * var y = _.Matrix.MakeCol([ 4, 2, 2 ]);
 * var x = _.Matrix.SolveTriangleUpperNormal( null, m, y );
 * console.log( x.toStr() );
 * // log :
 * //  6
 * // -2
 * //  2
 *
 * @param { Null|Matrix } x - Destination matrix.
 * @param { Matrix } m - Matrix of coefficients.
 * @param { Matrix } y - Matrix of results.
 * @returns { Matrix } - Returns the matrix with unknowns.
 * @throws { Error } If dimensions of {-x-} and {-y-} are different.
 * @throws { Error } If number of rows of {-m-} is not equal to number of rows of {-x-}.
 * @function SolveTriangleUpper
 * @static
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function SolveTriangleUpperNormal( x, m, y )
{
  let self = this;

  function handleSolve( x, m, y )
  {

    for( let r1 = y.length-1 ; r1 >= 0 ; r1-- )
    {
      let xu = x.review([ r1+1, x.length-1 ]);
      let row = m.rowGet( r1 );
      row = row.review([ r1+1, row.length-1 ]);
      let xval = ( x.eGet( r1 ) - self.vectorAdapter.dot( row, xu ) );
      x.eSet( r1, xval );
    }

    return x;
  }

  return self._SolveTriangleWithRoutine( arguments, handleSolve );
}

//

/**
 * Static routine SolveGeneral() solves system of equations in general form.
 *
 * @example
 *
 * var m = _.Matrix.MakeSquare
 * ([
 *   +2, +2, -2,
 *   -2, -3, +4,
 *   +4, +3, -2,
 * ]);
 *
 * var me = _.Matrix.MakeSquare
 * ([
 *   +1, +0, +1,
 *   +0, +1, -2,
 *   +0, +0, +0,
 * ]);
 *
 * var y = _.Matrix.MakeCol([ 0, 3, 3 ]);
 * var r = _.Matrix.SolveGeneral({ m, y, pivoting : 0 });
 * console.log( r.toStr() );
 * // log : {
 * //   nsolutions : Infinity,
 * //   base : _.Matrix.MakeCol([ +3, -3, +0 ]),
 * //   nkernel : 1,
 * //   kernel : _.Matrix.MakeSquare
 * //   ([
 * //     +0, +0, -1,
 * //     +0, +0, +2,
 * //     +0, +0, +1,
 * //   ]),
 * // }
 *
 * @param { Map } o - Options map.
 * @param { Matrix } o.x - Destination matrix.
 * @param { Matrix } o.m - Matrix of coefficients.
 * @param { Matrix } o.y - Matrix of results.
 * @param { Number } o.kernel - Number of kernels.
 * @param { BoolLike } o.pivoting - Enables pivoting.
 * @returns { Map } - Returns maps with solved system of equations.
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If options map {-o-} has unknown options.
 * @function SolveGeneral
 * @static
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function SolveGeneral( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routineOptions( SolveGeneral, o );

  /* */

  let result = Object.create( null );
  result.nsolutions = 1;
  result.kernel = o.kernel;
  result.nkernel = 0;

  /* alloc */

  if( o.m.nrow < o.m.ncol )
  {
    let missing = o.m.ncol - o.m.nrow;
    o.m.expand([ [ 0, missing ], 0 ]);
    o.y.expand([ [ 0, missing ], 0 ]);
  }

  if( !result.kernel )
  result.kernel = Self.MakeZero( o.m.dims );
  let nrow = o.m.nrow;

  /* verify */

  _.assert( o.m.nrow === o.y.nrow );
  _.assert( o.m.nrow === result.kernel.nrow );
  _.assert( result.kernel.hasShape( o.m ) );
  _.assert( o.y instanceof Self );
  _.assert( o.y.dims[ 1 ] === 1 );

  /* Solve */

  let optionsForMethod;
  if( o.pivoting )
  {
    optionsForMethod = this._Solve_pre([ o.x, o.m, o.y ]);
    optionsForMethod.onPivot = this._PivotRook;
    optionsForMethod.pivotingBackward = 0;
    o.x = result.base = this._SolveWithGaussJordan( optionsForMethod );
  }
  else
  {
    optionsForMethod = this._Solve_pre([ o.x, o.m, o.y ]);
    o.x = result.base = this._SolveWithGaussJordan( optionsForMethod );
  }

  /* analyse */

  logger.log( 'm', o.m );
  logger.log( 'x', o.x );

  for( let r = 0 ; r < nrow ; r++ )
  {
    let row = o.m.rowGet( r );
    if( abs( row.eGet( r ) ) < this.accuracy )
    {
      if( abs( o.x.scalarGet([ r, 0 ]) ) < this.accuracy )
      {
        result.nsolutions = Infinity;
        let termCol = result.kernel.colGet( r );
        let srcCol = o.m.colGet( r );
        termCol.copy( srcCol );
        self.vectorAdapter.mul( termCol, -1 );
        termCol.eSet( r, 1 );
        result.nkernel += 1;
      }
      else
      {
        debugger;
        result.nsolutions = 0;
        return result;
      }
    }
  }

  if( o.pivoting )
  {
    Self.VectorPivotBackward( result.base, optionsForMethod.pivots[ 1 ] );
    result.kernel.pivotBackward([ optionsForMethod.pivots[ 1 ], optionsForMethod.pivots[ 0 ] ]);
    o.m.pivotBackward( optionsForMethod.pivots );
  }

  return result;
}

SolveGeneral.defaults =
{
  x : null,
  m : null,
  y : null,
  kernel : null,
  pivoting : 1,
}

//

/**
 * Method invert() inverts current matrix by Gauss-Jordan method.
 *
 * @example
 * var m = _.Matrix.Make([ 3, 3 ]).copy
 * ([
 *   +2, -3, +4,
 *   +2, -2, +3,
 *   +6, -7, +9,
 * ]);
 *
 * m.invert();
 * console.log( m.toStr() );
 * // log :
 * // -1.5, +0.5, +0.5,
 * // +0,   +3,   -1,
 * // +1,   +2,   -1,
 *
 * @returns { Matrix } - Returns the matrix with inverted values.
 * @method invert
 * @throws { Error } If number of dimensions is more then two.
 * @throws { Error } If current matrix is not a square matrix.
 * @throws { Error } If arguments are passed.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function invert()
{
  let self = this;

  _.assert( self.dims.length === 2 );
  _.assert( self.isSquare() );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  return self.InvertWithGaussJordan();
}

//

/**
 * Method invertingClone() inverts copy of current matrix by Gauss-Jordan method.
 *
 * @example
 * var m = _.Matrix.Make([ 3, 3 ]).copy
 * ([
 *   +2, -3, +4,
 *   +2, -2, +3,
 *   +6, -7, +9,
 * ]);
 *
 * var got = m.invertingClone();
 * console.log( got.toStr() );
 * // -1.5, +0.5, +0.5,
 * // +0,   +3,   -1,
 * // +1,   +2,   -1,
 * console.log( got !== m );
 * // log : true
 *
 * @returns { Matrix } - Returns a copy of the matrix with inverted values.
 * @method invertingClone
 * @throws { Error } If number of dimensions is more then two.
 * @throws { Error } If current matrix is not a square matrix.
 * @throws { Error } If arguments are passed.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function invertingClone()
{
  let self = this;

  _.assert( self.dims.length === 2 );
  _.assert( self.isSquare() );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  return Self.SolveWithGaussJordan( null, self.clone(), self.Self.MakeIdentity( self.dims[ 0 ] ) );
}

//

/**
 * Method copyAndInvert() inverts current matrix by Gauss-Jordan method.
 *
 * @example
 * var m = _.Matrix.MakeSquare( 3 );
 * var src = _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   +2, -3, +4,
 *   +2, -2, +3,
 *   +6, -7, +9,
 * ]);
 *
 * m.copyAndInvert( src );
 * console.log( m.toStr() );
 * // log :
 * // -1.5, +0.5, +0.5,
 * // +0,   +3,   -1,
 * // +1,   +2,   -1,
 *
 * @param { Long|VectorAdapter|Matrix } - Source buffer.
 * @returns { Matrix } - Returns the matrix with inverted values of source buffer.
 * @method copyAndInvert
 * @throws { Error } If number of dimensions is more then two.
 * @throws { Error } If current matrix is not a square matrix.
 * @throws { Error } If arguments.length is not equal to one.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function copyAndInvert( src )
{
  let self = this;

  _.assert( self.dims.length === 2 );
  _.assert( self.isSquare() );
  _.assert( arguments.length === 1, 'Expects single argument' );

  self.copy( src );
  self.invert();

  return self;
}

// --
// relations
// --

let Statics = /* qqq : split static routines. ask how */
{

  /* Solve */

  _PivotRook,

  Solve,

  _Solve_pre,

  SolveWithGausian,
  SolveWithGausianPivoting,

  _SolveWithGaussJordan,
  SolveWithGaussJordan,
  SolveWithGaussJordanPivoting,
  InvertWithGaussJordan,

  SolveWithTriangles,
  SolveWithTrianglesPivoting,

  _SolveTriangleWithRoutine,
  SolveTriangleLower,
  SolveTriangleLowerNormal,
  SolveTriangleUpper,
  SolveTriangleUpperNormal,

  SolveGeneral,

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

  // triangulator

  _triangulateGausian,
  triangulateGausian,
  triangulateGausianNormal,
  triangulateGausianPivoting,

  triangulateLu,
  triangulateLuNormal,
  triangulateLuPivoting,

  _PivotRook,

  // Solver

  Solve,

  _Solve_pre,

  SolveWithGausian,
  SolveWithGausianPivoting,

  _SolveWithGaussJordan,
  SolveWithGaussJordan,
  SolveWithGaussJordanPivoting,
  InvertWithGaussJordan,

  SolveWithTriangles,
  SolveWithTrianglesPivoting,

  _SolveTriangleWithRoutine,
  SolveTriangleLower,
  SolveTriangleLowerNormal,
  SolveTriangleUpper,
  SolveTriangleUpperNormal,

  SolveGeneral,

  invert,
  invertingClone,
  copyAndInvert,

  //

  Statics,

}

_.classExtend( Self, Extension );

})();
