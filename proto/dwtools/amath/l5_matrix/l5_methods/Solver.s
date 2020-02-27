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
  o.y = Self.from( o.y );

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( !o.y || o.y.dims[ 0 ] === self.dims[ 0 ] );

  /* */

  if( o.y )
  for( let r1 = 0 ; r1 < ncol ; r1++ )
  {

    if( o.onPivot )
    o.onPivot.call( self, r1, o );

    let row1 = self.rowVectorGet( r1 );
    let yrow1 = o.y.rowVectorGet( r1 );
    let scaler1 = row1.eGet( r1 );
    if( o.normal )
    {
      self.vectorAdapter.divScalar( row1, scaler1 );
      self.vectorAdapter.divScalar( yrow1, scaler1 );
      scaler1 = 1;
    }

    for( let r2 = r1+1 ; r2 < nrow ; r2++ )
    {
      let row2 = self.rowVectorGet( r2 );
      let yrow2 = o.y.rowVectorGet( r2 );
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

    let row1 = self.rowVectorGet( r1 );
    let scaler1 = row1.eGet( r1 );
    if( o.normal )
    {
      self.vectorAdapter.divScalar( row1, scaler1 );
      scaler1 = 1;
    }

    for( let r2 = r1+1 ; r2 < nrow ; r2++ )
    {
      let row2 = self.rowVectorGet( r2 );
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

function triangulateGausian( y )
{
  let self = this;
  let o = Object.create( null );
  o.y = y;
  return self._triangulateGausian( o );
}

//

function triangulateGausianNormal( y )
{
  let self = this;
  let o = Object.create( null );
  o.y = y;
  o.normal = 1;
  return self._triangulateGausian( o );
}

//

function triangulateGausianPivoting( y )
{
  let self = this;
  let o = Object.create( null );
  o.y = y;
  o.onPivot = self._pivotRook;
  return self._triangulateGausian( o );
}

//

function triangulateLu()
{
  let self = this;
  let nrow = self.nrow;
  let ncol = Math.min( self.ncol, nrow );

  _.assert( arguments.length === 0, 'Expects no arguments' );

  logger.log( 'self', self );

  for( let r1 = 0 ; r1 < ncol ; r1++ )
  {
    let row1 = self.rowVectorGet( r1 );
    let scaler1 = row1.eGet( r1 );
    row1 = row1.review( r1+1 );

    for( let r2 = r1+1 ; r2 < nrow ; r2++ )
    {
      let row2 = self.rowVectorGet( r2 );
      let scaler = row2.eGet( r1 ) / scaler1;
      self.vectorAdapter.subScaled( row2.review( r1+1 ), row1, scaler );
      row2.eSet( r1, scaler );
    }

    logger.log( 'self', self );
  }

  return self;
}

//

function triangulateLuNormal()
{
  let self = this;
  let nrow = self.nrow;
  let ncol = Math.min( self.ncol, nrow );

  _.assert( arguments.length === 0, 'Expects no arguments' );

  for( let r1 = 0 ; r1 < ncol ; r1++ )
  {
    let row1 = self.rowVectorGet( r1 );
    let scaler1 = row1.eGet( r1 );
    row1 = row1.review( r1+1 );
    self.vectorAdapter.divScalar( row1, scaler1 );

    for( let r2 = r1+1 ; r2 < nrow ; r2++ )
    {
      let row2 = self.rowVectorGet( r2 );
      let scaler = row2.eGet( r1 );
      self.vectorAdapter.subScaled( row2.review( r1+1 ), row1, scaler );
      row2.eSet( r1, scaler );
    }

  }

  return self;
}

//

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

    self._pivotRook.call( self, r1, o );

    let row1 = self.rowVectorGet( r1 );
    let scaler1 = row1.eGet( r1 );
    row1 = row1.review( r1+1 );

    for( let r2 = r1+1 ; r2 < nrow ; r2++ )
    {
      let row2 = self.rowVectorGet( r2 );
      let scaler = row2.eGet( r1 ) / scaler1;
      self.vectorAdapter.subScaled( row2.review( r1+1 ), row1, scaler );
      row2.eSet( r1, scaler );
    }

    logger.log( 'self', self );

  }

  return pivots;
}

//

function _pivotRook( i, o )
{
  let self = this;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( o.pivots )

  let row1 = self.rowVectorGet( i ).review( i );
  let col1 = self.colVectorGet( i ).review( i );
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
// solver
// --

function solve( x, m, y )
{
  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  return this.solveWithTrianglesPivoting( x, m, y )
}

//

function _solve_pre( args )
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

function solveWithGausian()
{
  let o = this._solve_pre( arguments );

  o.m.triangulateGausian( o.x );
  this.solveTriangleUpper( o.x, o.m, o.x );

  // o.x = this.convertToClass( o.oy.constructor, o.x );
  return o.ox;
}

//

function solveWithGausianPivoting()
{
  let o = this._solve_pre( arguments );

  let pivots = o.m.triangulateGausianPivoting( o.x );
  this.solveTriangleUpper( o.x, o.m, o.x );
  Self.VectorPivotBackward( o.x, pivots[ 1 ] );

  return o.ox;
}

//

function _solveWithGaussJordan( o )
{
  let self = this;

  let nrow = o.m.nrow;
  let ncol = Math.min( o.m.ncol, nrow );

  o.x = this.from( o.x );
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

    let row1 = o.m.rowVectorGet( r1 );
    let scaler1 = row1.eGet( r1 );

    if( abs( scaler1 ) < this.accuracy )
    continue;

    self.vectorAdapter.mulScalar( row1, 1/scaler1 );

    let xrow1 = o.x.rowVectorGet( r1 );
    self.vectorAdapter.mulScalar( xrow1, 1/scaler1 );

    for( let r2 = 0 ; r2 < nrow ; r2++ )
    {

      if( r1 === r2 )
      continue;

      let xrow2 = o.x.rowVectorGet( r2 );
      let row2 = o.m.rowVectorGet( r2 );
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

  // o.x = this.convertToClass( o.oy.constructor, o.x );
  return o.ox;
}

//

function solveWithGaussJordan()
{
  let o = this._solve_pre( arguments );
  return this._solveWithGaussJordan( o );
}

//

function solveWithGaussJordanPivoting()
{
  let o = this._solve_pre( arguments );
  o.onPivot = this._pivotRook;
  o.pivotingBackward = 1;
  return this._solveWithGaussJordan( o );
}

//

function invertWithGaussJordan()
{
  let m = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( m.dims[ 0 ] === m.dims[ 1 ] );

  let nrow = m.nrow;

  for( let r1 = 0 ; r1 < nrow ; r1++ )
  {

    let row1 = m.rowVectorGet( r1 ).review( r1+1 );
    let xrow1 = m.rowVectorGet( r1 ).review([ 0, r1 ]);

    let scaler1 = 1 / xrow1.eGet( r1 );
    xrow1.eSet( r1, 1 );
    m.vectorAdapter.mulScalar( row1, scaler1 );
    m.vectorAdapter.mulScalar( xrow1, scaler1 );

    for( let r2 = 0 ; r2 < nrow ; r2++ )
    {

      if( r1 === r2 )
      continue;

      let row2 = m.rowVectorGet( r2 ).review( r1+1 );
      let xrow2 = m.rowVectorGet( r2 ).review([ 0, r1 ]);
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

function solveWithTriangles( x, m, y )
{

  let o = this._solve_pre( arguments );
  m.triangulateLuNormal();

  o.x = this.solveTriangleLower( o.x, o.m, o.y );
  o.x = this.solveTriangleUpperNormal( o.x, o.m, o.x );

  // o.x = this.convertToClass( o.oy.constructor, o.x );
  return o.ox;
}

//

function solveWithTrianglesPivoting( x, m, y )
{

  let o = this._solve_pre( arguments );
  let pivots = m.triangulateLuPivoting();

  o.y = Self.VectorPivotForward( o.y, pivots[ 0 ] );

  o.x = this.solveTriangleLowerNormal( o.x, o.m, o.y );
  o.x = this.solveTriangleUpper( o.x, o.m, o.x );

  Self.VectorPivotBackward( o.x, pivots[ 1 ] );
  Self.VectorPivotBackward( o.y, pivots[ 0 ] );

  // o.x = this.convertToClass( o.oy.constructor, o.x );
  return o.ox;
}

//

function _solveTriangleWithRoutine( args, onSolve )
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
      x = Self.from( x, y.dims );
      x.copy( y );
    }

    _.assert( x.hasShape( y ) );
    _.assert( x.dims[ 0 ] === m.dims[ 1 ] );

    for( let v = 0 ; v < y.dims[ 1 ] ; v++ )
    {
      onSolve( x.colVectorGet( v ), m, y.colVectorGet( v ) );
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

function solveTriangleLower( x, m, y )
{
  let self = this;

  function handleSolve( x, m, y )
  {

    for( let r1 = 0 ; r1 < y.length ; r1++ )
    {
      let xu = x.review([ 0, r1-1 ]);
      let row = m.rowVectorGet( r1 );
      let scaler = row.eGet( r1 );
      row = row.review([ 0, r1-1 ]);
      let xval = ( x.eGet( r1 ) - self.vectorAdapter.dot( row, xu ) ) / scaler;
      x.eSet( r1, xval );
    }

    return x;
  }

  return self._solveTriangleWithRoutine( arguments, handleSolve );
}

//

function solveTriangleLowerNormal( x, m, y )
{
  let self = this;

  function handleSolve( x, m, y )
  {

    for( let r1 = 0 ; r1 < y.length ; r1++ )
    {
      let xu = x.review([ 0, r1-1 ]);
      let row = m.rowVectorGet( r1 );
      row = row.review([ 0, r1-1 ]);
      let xval = ( x.eGet( r1 ) - self.vectorAdapter.dot( row, xu ) );
      x.eSet( r1, xval );
    }

    return x;
  }

  return self._solveTriangleWithRoutine( arguments, handleSolve );
}

//

function solveTriangleUpper( x, m, y )
{
  let self = this;
  return self._solveTriangleWithRoutine( arguments, handleSolve );

  function handleSolve( x, m, y )
  {

    for( let r1 = y.length-1 ; r1 >= 0 ; r1-- )
    {
      let xu = x.review([ r1+1, x.length-1 ]);
      let row = m.rowVectorGet( r1 );
      let scaler = row.eGet( r1 );
      row = row.review([ r1+1, row.length-1 ]);
      let xval = ( x.eGet( r1 ) - self.vectorAdapter.dot( row, xu ) ) / scaler;
      x.eSet( r1, xval );
    }

    return x;
  }

}

//

function solveTriangleUpperNormal( x, m, y )
{
  let self = this;

  function handleSolve( x, m, y )
  {

    for( let r1 = y.length-1 ; r1 >= 0 ; r1-- )
    {
      let xu = x.review([ r1+1, x.length-1 ]);
      let row = m.rowVectorGet( r1 );
      row = row.review([ r1+1, row.length-1 ]);
      let xval = ( x.eGet( r1 ) - self.vectorAdapter.dot( row, xu ) );
      x.eSet( r1, xval );
    }

    return x;
  }

  return self._solveTriangleWithRoutine( arguments, handleSolve );
}

//

function solveGeneral( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routineOptions( solveGeneral, o );

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
  result.kernel = Self.makeZero( o.m.dims );
  let nrow = o.m.nrow;

  /* verify */

  _.assert( o.m.nrow === o.y.nrow );
  _.assert( o.m.nrow === result.kernel.nrow );
  _.assert( result.kernel.hasShape( o.m ) );
  _.assert( o.y instanceof Self );
  _.assert( o.y.dims[ 1 ] === 1 );

  /* solve */

  let optionsForMethod;
  if( o.pivoting )
  {
    optionsForMethod = this._solve_pre([ o.x, o.m, o.y ]);
    optionsForMethod.onPivot = this._pivotRook;
    optionsForMethod.pivotingBackward = 0;
    o.x = result.base = this._solveWithGaussJordan( optionsForMethod );
  }
  else
  {
    optionsForMethod = this._solve_pre([ o.x, o.m, o.y ]);
    o.x = result.base = this._solveWithGaussJordan( optionsForMethod );
  }

  /* analyse */

  logger.log( 'm', o.m );
  logger.log( 'x', o.x );

  for( let r = 0 ; r < nrow ; r++ )
  {
    let row = o.m.rowVectorGet( r );
    if( abs( row.eGet( r ) ) < this.accuracy )
    {
      if( abs( o.x.atomGet([ r, 0 ]) ) < this.accuracy )
      {
        result.nsolutions = Infinity;
        let termCol = result.kernel.colVectorGet( r );
        let srcCol = o.m.colVectorGet( r );
        termCol.copy( srcCol );
        self.vectorAdapter.mulScalar( termCol, -1 );
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

solveGeneral.defaults =
{
  x : null,
  m : null,
  y : null,
  kernel : null,
  pivoting : 1,
}

//

function invert()
{
  let self = this;

  _.assert( self.dims.length === 2 );
  _.assert( self.isSquare() );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  return self.invertWithGaussJordan();
}

//

function invertingClone()
{
  let self = this;

  _.assert( self.dims.length === 2 );
  _.assert( self.isSquare() );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  return Self.solveWithGaussJordan( null, self.clone(), self.Self.makeIdentity( self.dims[ 0 ] ) );
}

//

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

  /* solve */

  _pivotRook,

  solve,

  _solve_pre,

  solveWithGausian,
  solveWithGausianPivoting,

  _solveWithGaussJordan,
  solveWithGaussJordan,
  solveWithGaussJordanPivoting,
  invertWithGaussJordan,

  solveWithTriangles,
  solveWithTrianglesPivoting,

  _solveTriangleWithRoutine,
  solveTriangleLower,
  solveTriangleLowerNormal,
  solveTriangleUpper,
  solveTriangleUpperNormal,

  solveGeneral,

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

  _pivotRook,

  // solver

  solve,

  _solve_pre,

  solveWithGausian,
  solveWithGausianPivoting,

  _solveWithGaussJordan,
  solveWithGaussJordan,
  solveWithGaussJordanPivoting,
  invertWithGaussJordan,

  solveWithTriangles,
  solveWithTrianglesPivoting,

  _solveTriangleWithRoutine,
  solveTriangleLower,
  solveTriangleLowerNormal,
  solveTriangleUpper,
  solveTriangleUpperNormal,

  solveGeneral,

  invert,
  invertingClone,
  copyAndInvert,

  //

  Statics,

}

_.classExtend( Self, Extension );

})();
