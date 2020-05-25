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
// meta
// --

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

function _Solve2_pre( routine, args )
{
  let self = this;
  let o;

  if( _.mapIs( args[ 0 ] ) )
  {
    _.assert( args.length === 1 );
    o = args[ 0 ];
  }
  else
  {
    _.assert( args.length === 3 );
    o = Object.create( null );
    o.x = args[ 0 ]; /* xxx : swap x and m */
    o.m = args[ 1 ];
    o.y = args[ 2 ];
  }

  _.routineOptions( routine, o );

  if( o.permutating )
  {
    if( o.onPermutate === null )
    o.onPermutate = this._PermutateLineRook.body;
    if( o.onPermutatePre === null )
    o.onPermutatePre = this._PermutateLineRook.pre;
  }

  if( o.x === null )
  {
    if( _.longIs( o.y ) )
    {
      let l = Math.max( o.m.dims[ 1 ], this.NrowOf( o.y ) );
      o.x = _.longGrow( o.y, [ 0, l ], 0 ); /* zzz : use new longGrow */
    }
    else if( o.y !== null )
    {
      o.x = o.y.clone();
      if( _.matrixIs( o.x ) && o.x.nrow < o.m.ncol )
      {
        o.x.expand([ [ null, o.m.ncol - o.x.nrow ], null ]);
      }
      else if( _.vadIs( o.x ) && o.x.length < o.m.ncol )
      {
        o.x = o.x.grow([ 0, o.m.ncol-1 ]);
      }
    }
  }
  else
  {
    if( o.y === null )
    o.y = o.x;
    else
    this.CopyTo( o.x, o.y );
  }

  o.oy = o.y;
  o.ox = o.x;

  if( o.x === null || o.y === null )
  {
    return o;
  }

  _.assert( arguments.length === 2 );
  _.assert( this.NcolOf( o.y ) === this.NcolOf( o.x ), () => inconsistentDims( o.y, o.x ) );
  _.assert( o.m.dims[ 1 ] <= this.NrowOf( o.x ), () => inconsistentDims( o.m, o.x ) );
  // _.assert( o.m.dims[ 0 ] === this.NrowOf( o.y ), () => inconsistentDims( o.m, o.y ) );
  _.assert( o.m.dims[ 0 ] >= this.NrowOf( o.y ), () => inconsistentDims( o.m, o.y ) );
  _.assert( _.matrixIs( o.m ) );
  _.assert( _.matrixIs( o.x ) || _.vectorIs( o.x ) );
  _.assert( _.matrixIs( o.x ) || _.vectorIs( o.y ) );

  return o;

  function inconsistentDims( m1, m2 )
  {
    return `Inconsistent dimensions of 2 matrix-like structures ${_.Matrix.DimsOf( m1 )} and ${_.Matrix.DimsOf( m2 )}`;
    /* zzz : implement _.matrixLike */
    /* zzz : move _.matrixIs? */
    /* zzz : implement static routine _.Matrix.DimsExportString */
  }

}

//

function _Solver_functor( fop )
{

  if( _.routineIs( arguments[ 0 ] ) )
  fop = { method : arguments[ 0 ] };

  _.routineOptions( _Solver_functor, fop );
  _.assert( _.routineIs( fop.method ) );
  _.assert( _.routineIs( _Solve2_pre ) );
  _.assert( _.mapIs( fop.method.defaults ) );
  _.assert( _.longHas( [ 'o', 'ox' ], fop.returning ) );

  // let xIsVector = fop.xIsVector;
  let method = fop.method;
  let returning = fop.returning;
  solve.defaults =
  {
    ... fop.method.defaults,
    ox : null,
    oy : null,
    y : null,
  }
  solve.pre = _Solve2_pre;
  solve.body = method;

  let r =
  {
    [ method.name ] : solve,
  }

  return r[ method.name ];

  function solve()
  {
    let o = Self._Solve2_pre( solve, arguments );

    // debugger;
    // if( !xIsVector )
    // {
    //   o.x = this.From( o.x );
    //   o.y = this.From( o.y ); /* xxx : remove? */
    // }

    method.call( this, o );

    // debugger;
    // if( o.permutating && o.repermutatingSolution )
    // {
    //   this.PermutateBackward( o.x, popts.permutates[ 1 ] ); /* xxx : remove other usages, maybe */
    // }

    if( returning === 'ox' )
    return o.ox;
    else
    return o;
  }

}

_Solver_functor.defaults =
{
  method : null,
  // xIsVector : 0,
  returning : 'ox',
}

// --
// triangulator
// --

function _TriangulateGausian( o )
{
  let proto = this;

  // _.routineOptions( _TriangulateGausian, o );

  let nrow = o.m.nrow;
  let ncol = Math.min( o.m.ncol, nrow );

  if( o.x )
  o.x = this.From( o.x );

  // if( o.y !== null )
  // o.y = Self.From( o.y );
  // o.m = self;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  // _.assert( !o.x || o.x.dims[ 0 ] === o.m.dims[ 1 ] );
  _.assert( !o.x || o.m.dims[ 1 ] <= this.NrowOf( o.x ) );
  // _.assert( !o.y || o.y.dims[ 0 ] === o.m.dims[ 0 ] );

  _.assertMapHasAll( o, _TriangulateGausian.defaults );
  _.assert( _.matrixIs( o.m ) );
  _.assert( o.x === null || _.matrixIs( o.x ) );
  // _.assert( _.matrixIs( o.y ) );
  // _.assert( o.y === undefined );

  let popts;
  if( o.permutating )
  {
    popts = o.onPermutatePre( o.onPermutate, [ o ] );
  }

  /* */

  if( o.x )
  triangulateWithRight();
  else
  triangulateWithoutRight();

  return o;
  // return o.permutates;

  /* */

  function triangulateWithRight()
  {

    for( let r1 = 0 ; r1 < ncol ; r1++ )
    {

      if( o.permutating )
      {
        popts.lineIndex = r1;
        o.onPermutate( popts );
      }

      let row1 = o.m.rowGet( r1 );
      let xrow1 = o.x.rowGet( r1 );
      let scaler1 = row1.eGet( r1 );
      if( o.normalizing )
      {
        row1.div( scaler1 );
        xrow1.div( scaler1 );
        scaler1 = 1;
      }

      for( let r2 = r1+1 ; r2 < nrow ; r2++ )
      {
        let row2 = o.m.rowGet( r2 );
        let yrow2 = o.x.rowGet( r2 );
        let scaler = row2.eGet( r1 ) / scaler1;
        row2.subScaled( row1, scaler );
        yrow2.subScaled( xrow1, scaler );
      }

    }

    debugger;
    if( o.permutating && o.repermutatingSolution )
    {
      Self.PermutateBackward( o.x, popts.permutates[ 1 ] );
    }

  }

  /* */

  function triangulateWithoutRight()
  {

    for( let r1 = 0 ; r1 < ncol ; r1++ )
    {

      if( o.permutating )
      {
        popts.lineIndex = r1;
        o.onPermutate( popts );
      }

      let row1 = o.m.rowGet( r1 );
      let scaler1 = row1.eGet( r1 );
      if( o.normalizing )
      {
        row1.div( scaler1 );
        scaler1 = 1;
      }

      for( let r2 = r1+1 ; r2 < nrow ; r2++ )
      {
        let row2 = o.m.rowGet( r2 );
        let scaler = row2.eGet( r1 ) / scaler1;
        row2.subScaled( row1, scaler );
      }

    }

  }

  /* */

}

_TriangulateGausian.defaults =
{
  m : null,
  x : null,
  // y : null,
  onPermutate : null,
  onPermutatePre : null,
  permutates : null,
  permutating : 0,
  repermutatingSolution : 1,
  normalizing : 0,
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

let TriangulateGausian = _Solver_functor
({
  method : _TriangulateGausian,
  returning : 'o',
});
var defaults = TriangulateGausian.defaults;
defaults.normalizing = 0;
defaults.permutating = 0;
defaults.repermutatingSolution = 0;

function triangulateGausian( y )
{
  let self = this;
  let o = Object.create( null );
  o.y = y;
  o.m = self;
  return self.TriangulateGausian( o );
}

// function triangulateGausian( y )
// {
//   let self = this;
//   let o = Object.create( null );
//   o.y = y;
//   o.m = self;
//   return self._TriangulateGausian( o );
// }

//

/**
 * Method triangulateGausianNormalizing() triangulation by Gauss method noramalizing it.
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
 * m.triangulateGausianNormalizing( y );
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
 * @method triangulateGausianNormalizing
 * @throws { Error } If vector {-y-} has length different to number or rows in current matrix.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

let TriangulateGausianNormalizing = _Solver_functor
({
  method : _TriangulateGausian,
  returning : 'o',
});
var defaults = TriangulateGausianNormalizing.defaults;
defaults.normalizing = 1;
defaults.permutating = 0;
defaults.repermutatingSolution = 0;

function triangulateGausianNormalizing( y )
{
  let self = this;
  let o = Object.create( null );
  o.y = y;
  o.m = self;
  return self.TriangulateGausianNormalizing( o );
}

// function triangulateGausianNormalizing( y )
// {
//   let self = this;
//   let o = Object.create( null );
//   o.y = x;
//   o.m = self
//   o.normalizing = 1;
//   return self._TriangulateGausian( o );
// }

//

/**
 * Method triangulateGausianPermutating() provides triangulation with permutating by Gauss method.
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
 * var permutates = m.triangulateGausianPermutating( y );
 * test.identical( m, em );
 * console.log( m.toStr() );
 * // log :
 * // +3, +2, +1, +1,
 * // +0, +4, +2, +0,
 * // +0, +0, +0, +0,
 * console.log( permutates );
 * // log : [ [ 0, 1, 2 ], [ 1, 3, 2, 0 ] ]
 *
 * @param { Matrix } y - Column vector to transform.
 * @returns { Matrix } - Returns triangulated vector, performs triangulation of the matrix.
 * @method triangulateGausianPermutating
 * @throws { Error } If vector {-y-} has length different to number or rows in current matrix.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

let TriangulateGausianPermutating = _Solver_functor
({
  method : _TriangulateGausian,
  returning : 'o',
});
var defaults = TriangulateGausianPermutating.defaults;
defaults.normalizing = 0;
defaults.permutating = 1;
defaults.repermutatingSolution = 1;

function triangulateGausianPermutating( y )
{
  let self = this;
  let o = Object.create( null );
  o.y = y;
  o.m = self;
  return self.TriangulateGausianPermutating( o );
}

let TriangulateGausianNormalizingPermutating = _Solver_functor
({
  method : _TriangulateGausian,
  returning : 'o',
});
var defaults = TriangulateGausianNormalizingPermutating.defaults;
defaults.normalizing = 1;
defaults.permutating = 1;
defaults.repermutatingSolution = 1;

function triangulateGausianNormalizingPermutating( y )
{
  let self = this;
  let o = Object.create( null );
  o.y = y;
  o.m = self;
  return self.TriangulateGausianNormalizingPermutating( o );
}

// function triangulateGausianPermutating( y )
// {
//   let self = this;
//   let o = Object.create( null );
//   o.y = y;
//   o.onPermutate = self._PermutateLineRook;
//   o.onPermutatePre = self._PermutateLineRook.pre;
//   _.assert( _.routineIs( o.onPermutate ) );
//   _.assert( _.routineIs( o.onPermutatePre ) );
//   return self._TriangulateGausian( o );
// }

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

  }

  return self;
}

//

/**
 * Method triangulateLuNormalizing() triangulation by LU method, normalizing it.
 *
 * @example
 * var m = _.Matrix.Make([ 3, 3 ]).copy
 * ([
 *   +1, -2,  +2,
 *   +5, -15, +8,
 *   -2, -11, -11,
 * ]);
 *
 * m.triangulateLuNormalizing();
 * console.log( m.toStr() );
 * // log :
 * // +1, -2,  +2,
 * // +5, -5,  +0.4,
 * // -2, -15, -1,
 *
 * @returns { Matrix } - Returns triangulated matrix.
 * @method triangulateLuNormalizing
 * @throws { Error } If arguments are passed.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function triangulateLuNormalizing() /* xxx : rename */
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
 * Method triangulateLuPermutating() provides triangulation of matrix with permutating by Lu method.
 * Optionally, it accepts vector of permutates {-permutates-}.
 *
 * @example
 * var m = _.Matrix.Make([ 3, 3 ]).copy
 * ([
 *   +1, -2,  +2,
 *   +5, -15, +8,
 *   -2, -11, -11,
 * ]);
 *
 * m.triangulateLuPermutating();
 * console.log( m.toStr() );
 * // log :
 * // +5.000, -15.000, +8.000,
 * // -0.400, -17.000, -7.800,
 * // -0.200, -0.059,  -0.059,
 *
 * @returns { Long } - Returns long with permutates, provides triangulation of matrix.
 * @method triangulateLuPermutating
 * @throws { Error } If vector {-y-} has length different to number or rows in current matrix.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function triangulateLuPermutating( permutates )
{
  let self = this;
  let nrow = self.nrow;
  let ncol = Math.min( self.ncol, nrow );

  let popts = self._PermutateLineRook.pre.call( self, self._PermutateLineRook, [{ m : self, permutates }] );

  /* */

  _.assert( self.dims.length === 2 );
  _.assert( _.arrayIs( popts.permutates ) );
  _.assert( popts.permutates.length === 2 );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  /* */

  for( let r1 = 0 ; r1 < ncol ; r1++ )
  {

    popts.lineIndex = r1;
    self._permutateLineRook( popts );

    let row1 = self.rowGet( r1 );
    let scaler1 = row1.eGet( r1 );

    for( let r2 = r1+1 ; r2 < nrow ; r2++ )
    {
      let row2 = self.rowGet( r2 );
      let scaler = row2.eGet( r1 ) / scaler1;
      self.vectorAdapter.subScaled( row2.review( r1+1 ), row1.review( r1+1 ), scaler );
      row2.eSet( r1, scaler );
    }

  }

  /* */

  popts.matrix = self;

  return popts;
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
  return this.SolveWithTrianglesPermutating( x, m, y )
}

//

function _SolveWithGausian( o )
{
  let proto = this;
  let nrow = o.m.nrow;
  let ncol = Math.min( o.m.ncol, nrow );

  _.assertMapHasAll( o, _SolveWithGausian.defaults );
  _.assert( _.matrixIs( o.m ) );
  _.assert( _.matrixIs( o.x ) );
  // _.assert( _.matrixIs( o.y ) );

  let permutates = o.m.triangulateGausianPermutating( o.x ); /* xxx */
  this.SolveTriangleUpper( o.x, o.m, o.x );

  // Self.PermutateBackward( o.x, permutates[ 1 ] );

  if( o.permutating && o.repermutatingSolution )
  {
    Self.PermutateBackward( o.x, popts.permutates[ 1 ] );
  }

  return o.ox;
}

_SolveWithGausian.defaults =
{
  m : null,
  x : null,
  y : null,
  permutating : 0,
  repermutatingSolution : 1,
  onPermutate : null,
  onPermutatePre : null,
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

  let triangulated = this.TriangulateGausian
  ({
    m : o.m,
    x : o.x,
    permutating : 1,
    repermutatingSolution : 0,
  });

  // o.m.triangulateGausian( o.x );
  this.SolveTriangleUpper( o.x, o.m, o.x );

  return o.ox;
}

//

/**
 * Static routine SolveWithGausianPermutating() solves system of equations by Gaussian method with permutating.
 *
 * @example
 * var matrixA = _.Matrix.MakeSquare( [ [ 3, -2, 2, 3 ] ] );
 * var matrixB = _.Matrix.MakeCol( [ 1, 2 ] );
 *
 * var matrixX = _.Matrix.SolveWithGausianPermutating( null, matrixA, matrixB );
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
 * @method SolveWithGausianPermutating
 * @throws { Error } If dimensions of {-x-} and {-y-} are different.
 * @throws { Error } If number of rows of {-m-} is not equal to number of rows of {-x-}.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function SolveWithGausianPermutating()
{
  let o = this._Solve_pre( arguments );

  // let permutates = o.m.triangulateGausianPermutating( o.x ); /* xxx */

  let triangulated = this.TriangulateGausianPermutating
  ({
    m : o.m,
    x : o.x,
    permutating : 1,
    repermutatingSolution : 0,
  });

  this.SolveTriangleUpper( o.x, o.m, o.x );
  Self.PermutateBackward( o.x, triangulated.permutates[ 1 ] ); /* xxx : remove maybe? */

  return o.ox;
}

//

function _SolveWithGaussJordan( o )
{
  let proto = this;
  let nrow = o.m.nrow;
  let ncol = Math.min( o.m.ncol, nrow );

  _.assertMapHasAll( o, _SolveWithGaussJordan.defaults );

  if( o.x )
  o.x = proto.From( o.x );

  _.assert( _.matrixIs( o.m ) );
  _.assert( o.x === null || _.matrixIs( o.x ) );

  let popts;
  if( o.permutating )
  {
    popts = o.onPermutatePre( o.onPermutate, [ o ] );
    _.assert( popts.permutates === o.permutates );
  }

  /* */

  if( o.x )
  solveWithX();
  else
  solveWithoutX();

  /* */

  if( o.permutating && o.repermutatingSolution )
  {
    Self.PermutateBackward( o.x, popts.permutates[ 1 ] );
  }

  /* */

  return o;

  function solveWithX()
  {
    for( let r1 = 0 ; r1 < ncol ; r1++ )
    {

      if( o.onPermutate )
      {
        popts.lineIndex = r1;
        o.onPermutate( popts );
      }

      let row1 = o.m.rowGet( r1 );
      let scaler1 = row1.eGet( r1 );

      if( abs( scaler1 ) < proto.accuracy )
      continue;

      row1.mul( 1/scaler1 );

      let xrow1 = o.x.rowGet( r1 );
      xrow1.mul( 1/scaler1 );

      for( let r2 = 0 ; r2 < nrow ; r2++ )
      {

        if( r1 === r2 )
        continue;

        let xrow2 = o.x.rowGet( r2 );
        let row2 = o.m.rowGet( r2 );
        let scaler2 = row2.eGet( r1 );

        row2.subScaled( row1, scaler2 );
        xrow2.subScaled( xrow1, scaler2 );

      }

    }
  }

  /* */

  function solveWithoutX()
  {
    for( let r1 = 0 ; r1 < ncol ; r1++ )
    {

      if( o.onPermutate )
      {
        popts.lineIndex = r1;
        o.onPermutate( popts );
      }

      let row1 = o.m.rowGet( r1 );
      let scaler1 = row1.eGet( r1 );

      if( abs( scaler1 ) < proto.accuracy )
      continue;

      row1.mul( 1/scaler1 );

      for( let r2 = 0 ; r2 < nrow ; r2++ )
      {

        if( r1 === r2 )
        continue;

        let row2 = o.m.rowGet( r2 );
        let scaler2 = row2.eGet( r1 );

        row2.subScaled( row1, scaler2 );

      }

    }
  }

  /* */

}

_SolveWithGaussJordan.defaults =
{
  m : null,
  x : null,

  permutates : null,
  permutating : 0,
  repermutatingSolution : 1,
  onPermutate : null,
  onPermutatePre : null,
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

let SolveWithGaussJordan = _Solver_functor( _SolveWithGaussJordan );

//

/**
 * Static routine SolveWithGaussJordanPermutating() solves system of equations by Gauss-Jordan method with permutating.
 *
 * @example
 * var matrixA = _.Matrix.MakeSquare( [ [ 3, -2, 2, 3 ] ] );
 * var matrixB = _.Matrix.MakeCol( [ 1, 2 ] );
 *
 * var matrixX = _.Matrix.SolveWithGaussJordanPermutating( null, matrixA, matrixB );
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
 * @function SolveWithGaussJordanPermutating
 * @static
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

let SolveWithGaussJordanPermutating = _Solver_functor( _SolveWithGaussJordan );
var defaults = SolveWithGaussJordanPermutating.defaults;
defaults.permutating = 1;
defaults.repermutatingSolution = 1;

//

/**
 * Method invertWithGaussJordan() inverts the values of matrix by Gauss-Jordan method.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ [ 3, -2, 2, 3 ] ] );
 * var got = matrix.invertWithGaussJordan();
 *
 * console.log( got.toStr() );
 * // log :
 * // 0.231, 0.154,
 * // -0.154, 0, 231
 *
 * @returns { Matrix } - Returns the matrix with inverted values.
 * @method invertWithGaussJordan
 * @throws { Error } If arguments is passed.
 * @throws { Error } If current matrix is not square matrix.
 * @function invertWithGaussJordan
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function invertWithGaussJordan( dst )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( self.dims[ 0 ] === self.dims[ 1 ] );

  if( dst === null )
  {
    dst = self.clone();
    return dst.invertWithGaussJordan();
  }
  else if( dst === undefined || dst === _.self )
  {
    dst = self;
  }

  _.assert( dst === self, 'not implemented' ); /* qqq : implement */

  let nrow = self.nrow;

  for( let r1 = 0 ; r1 < nrow ; r1++ )
  {

    let row1 = self.rowGet( r1 ).review( r1+1 );
    let xrow1 = self.rowGet( r1 ).review([ 0, r1 ]); /* xxx */
    debugger;

    let scaler1 = 1 / xrow1.eGet( r1 );
    xrow1.eSet( r1, 1 );
    self.vectorAdapter.mul( row1, scaler1 );
    self.vectorAdapter.mul( xrow1, scaler1 );

    for( let r2 = 0 ; r2 < nrow ; r2++ )
    {

      if( r1 === r2 )
      continue;

      let row2 = self.rowGet( r2 ).review( r1+1 );
      let xrow2 = self.rowGet( r2 ).review([ 0, r1 ]);
      let scaler2 = xrow2.eGet( r1 );
      xrow2.eSet( r1, 0 )

      self.vectorAdapter.subScaled( row2, row1, scaler2 );
      self.vectorAdapter.subScaled( xrow2, xrow1, scaler2 );

    }

  }

  return self;
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
  m.triangulateLuNormalizing();

  o.x = this.SolveTriangleLower( o.x, o.m, o.y );
  o.x = this.SolveTriangleUpperNormalizing( o.x, o.m, o.x );

  return o.ox;
}

//

/**
 * Static routine SolveWithTrianglesPermutating() solves system of equations by triangles method with permutating.
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
 * var x = _.Matrix.SolveWithTrianglesPermutating( null, m, y );
 * console.log( x );
 * // log : [ -1, -2, +3 ]
 *
 * @param { Null|Matrix } x - Destination matrix.
 * @param { Matrix } m - Matrix of coefficients.
 * @param { Matrix } y - Matrix of results.
 * @returns { Matrix } - Returns the matrix with unknowns.
 * @throws { Error } If dimensions of {-x-} and {-y-} are different.
 * @throws { Error } If number of rows of {-m-} is not equal to number of rows of {-x-}.
 * @function SolveWithTrianglesPermutating
 * @static
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function _SolveWithTriangles( o )
{
  let proto = this;

  _.assertMapHasAll( o, _SolveWithTriangles.defaults );
  _.assert( _.matrixIs( o.m ) );
  _.assert( _.matrixIs( o.x ) );

  // let o = this._Solve_pre( arguments );
  let triangulated = m.triangulateLuPermutating();

  o.y = Self.VectorPermutateForward( o.y, triangulated.permutates[ 0 ] );

  debugger;
  o.x = this.SolveTriangleLowerNormalizing( o.x, o.m, o.y );
  debugger;
  o.x = this.SolveTriangleUpper( o.x, o.m, o.x );
  debugger;

  Self.PermutateBackward( o.x, triangulated.permutates[ 1 ] );
  Self.PermutateBackward( o.y, triangulated.permutates[ 0 ] ); /* xxx : remove maybe */

  // return o.ox;
  return o;
}

_SolveWithTriangles.defaults =
{
  m : null,
  x : null,
  // y : null,
  onPermutate : null,
  onPermutatePre : null,
  permutates : null,
  permutating : 0,
  repermutatingSolution : 1,
  normalizing : 0,
}

//

function SolveWithTrianglesPermutating( x, m, y ) /* xxx : remove */
{

  let o = this._Solve_pre( arguments );
  let triangulated = m.triangulateLuPermutating();

  o.y = Self.VectorPermutateForward( o.y, triangulated.permutates[ 0 ] );

  o.x = this.SolveTriangleLowerNormalizing( o.x, o.m, o.y );
  o.x = this.SolveTriangleUpper( o.x, o.m, o.x );

  Self.PermutateBackward( o.x, triangulated.permutates[ 1 ] );
  Self.PermutateBackward( o.y, triangulated.permutates[ 0 ] );

  return o.ox;
}

// //
//
// function _SolveTriangleWithRoutine( args, onSolve )
// {
//   let x = args[ 0 ];
//   let m = args[ 1 ];
//   let y = args[ 2 ];
//
//   _.assert( args.length === 3 );
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//   _.assert( y );
//
//   if( _.matrixIs( y ) )
//   {
//
//     if( x === null )
//     {
//       x = y.clone();
//     }
//     else
//     {
//       x = Self.From( x, y.dims );
//       x.copy( y );
//     }
//
//     _.assert( x.hasShape( y ) );
//     _.assert( x.dims[ 0 ] === m.dims[ 1 ] );
//
//     for( let v = 0 ; v < y.dims[ 1 ] ; v++ )
//     {
//       onSolve( x.colGet( v ), m, y.colGet( v ) );
//     }
//
//     return x;
//   }
//
//   /* */
//
//   y = this.vectorAdapter.from( y );
//
//   if( x === null )
//   {
//     x = y.clone();
//   }
//   else
//   {
//     x = this.vectorAdapter.from( x );
//     x.copy( y );
//   }
//
//   /* */
//
//   _.assert( x.length === y.length );
//
//   return onSolve( x, m, y );
// }

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

// function SolveTriangleLower( x, m, y )
// {
//   let self = this;
//   return self._SolveTriangleWithRoutine( arguments, handleSolve );
//
//   function handleSolve( x, m, y )
//   {
//
//     for( let r1 = 0 ; r1 < y.length ; r1++ )
//     {
//       let xu = x.review([ 0, r1-1 ]);
//       let row = m.rowGet( r1 );
//       let scaler = row.eGet( r1 );
//       row = row.review([ 0, r1-1 ]);
//       let xval = ( x.eGet( r1 ) - self.vectorAdapter.dot( row, xu ) ) / scaler;
//       x.eSet( r1, xval );
//     }
//
//     return x;
//   }
//
// }

function _SolveTriangleLower( o )
{

  // o.x = o.x.toVad({ restriding : 0 });

  if( o.normalizing )
  {

    if( _.matrixIs( o.x ) )
    actMatrixNormalizing( o.x );
    else
    actVectorNormalizing( o.x );

  }
  else
  {

    if( _.matrixIs( o.x ) )
    actMatrixNotNormalizing( o.x );
    else
    actVectorNotNormalizing( o.x );

  }

  return o;

  function actMatrixNormalizing( x ) /* xxx : rewrite? */
  {
    for( let i = 0, l = x.ncol ; i < l ; i++ )
    {
      actVectorNormalizing( x.colGet( i ) );
    }
  }

  function actVectorNormalizing( x )
  {
    for( let r1 = 0, l = x.length ; r1 < l ; r1++ )
    {
      let xu = x.review([ 0, r1-1 ]);
      let row = o.m.rowGet( r1 );
      row = row.review([ 0, r1-1 ]);
      let xval = ( x.eGet( r1 ) - row.dot( xu ) );
      x.eSet( r1, xval );
    }
  }

  function actMatrixNotNormalizing( x ) /* xxx : rewrite? */
  {
    for( let i = 0, l = x.ncol ; i < l ; i++ )
    {
      actVectorNotNormalizing( x.colGet( i ) );
    }
  }

  function actVectorNotNormalizing( x )
  {
    for( let r1 = 0, l = x.length ; r1 < l ; r1++ )
    {
      let xu = x.review([ 0, r1-1 ]);
      let row = o.m.rowGet( r1 );
      let scaler = row.eGet( r1 );
      row = row.review([ 0, r1-1 ]);
      let xval = ( x.eGet( r1 ) - row.dot( xu ) ) / scaler;
      x.eSet( r1, xval );
    }
  }

}

_SolveTriangleLower.defaults =
{
  m : null,
  x : null,
  // y : null,
  normalizing : 0,
}

//

let SolveTriangleLower = _Solver_functor
({
  method : _SolveTriangleLower,
  // xIsVector : 1,
});

var defaults = SolveTriangleLower.defaults;
defaults.normalizing = 0;

//

/**
 * Static routine SolveTriangleLowerNormalizing() solves system of equations with lower triangular matrix.
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
 * var x = _.Matrix.SolveTriangleLowerNormalizing( null, m, y );
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
 * @function SolveTriangleLowerNormalizing
 * @static
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

// function SolveTriangleLowerNormalizing( x, m, y )
// {
//   let self = this;
//   return self._SolveTriangleWithRoutine( arguments, handleSolve );
//
//   function handleSolve( x, m, y )
//   {
//
//     for( let r1 = 0 ; r1 < y.length ; r1++ )
//     {
//       let xu = x.review([ 0, r1-1 ]);
//       let row = m.rowGet( r1 );
//       row = row.review([ 0, r1-1 ]);
//       let xval = ( x.eGet( r1 ) - self.vectorAdapter.dot( row, xu ) );
//       x.eSet( r1, xval );
//     }
//
//     return x;
//   }
//
// }

let SolveTriangleLowerNormalizing = _Solver_functor
({
  method : _SolveTriangleLower,
});
var defaults = SolveTriangleLowerNormalizing.defaults;
defaults.normalizing = 1;

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

function _SolveTriangleUpper( o )
{

  // o.x = o.x.toVad({ restriding : 0 });

  if( o.normalizing )
  {

    if( _.matrixIs( o.x ) )
    actMatrixNormalizing( o.x );
    else
    actVectorNormalizing( o.x );

  }
  else
  {

    if( _.matrixIs( o.x ) )
    actMatrixNotNormalizing( o.x );
    else
    actVectorNotNormalizing( o.x );

  }

  return o;

  function actMatrixNormalizing( x )
  {
    for( let i = 0, l = x.ncol ; i < l ; i++ )
    {
      actVectorNormalizing( x.colGet( i ) );
    }
  }

  function actVectorNormalizing( x )
  {
    for( let l = x.length-1, r1 = l ; r1 >= 0 ; r1-- )
    {
      let xu = x.review([ r1+1, l ]);
      let row = o.m.rowGet( r1 );
      row = row.review([ r1+1, row.length-1 ]);
      let xval = ( x.eGet( r1 ) - row.dot( xu ) );
      x.eSet( r1, xval );
    }
  }

  function actMatrixNotNormalizing( x ) /* zzz : rewrite? */
  {
    for( let i = 0, l = x.ncol ; i < l ; i++ )
    {
      actVectorNotNormalizing( x.colGet( i ) );
    }
  }

  function actVectorNotNormalizing( x )
  {
    for( let l = x.length-1, r1 = l ; r1 >= 0 ; r1-- )
    {
      let xu = x.review([ r1+1, l ]);
      let row = o.m.rowGet( r1 );
      let scaler = row.eGet( r1 );
      row = row.review([ r1+1, row.length-1 ]);
      let xval = ( x.eGet( r1 ) - row.dot( xu ) ) / scaler;
      x.eSet( r1, xval );
    }
  }

}

// {
//
//   if( !_.vadIs( o.x ) )
//   o.x = o.x.toVad({ restriding : 0 });
//
//   if( o.normalizing )
//   {
//
//     for( let l = o.x.length-1, r1 = l ; r1 >= 0 ; r1-- )
//     {
//       let xu = o.x.review([ r1+1, l ]);
//       let row = o.m.rowGet( r1 );
//       row = row.review([ r1+1, row.length-1 ]);
//       let xval = ( o.x.eGet( r1 ) - row.dot( xu ) );
//       o.x.eSet( r1, xval );
//     }
//
//   }
//   else
//   {
//
//     for( let l = o.x.length-1, r1 = l ; r1 >= 0 ; r1-- )
//     {
//       let xu = o.x.review([ r1+1, l ]);
//       let row = o.m.rowGet( r1 );
//       let scaler = row.eGet( r1 );
//       row = row.review([ r1+1, row.length-1 ]);
//       let xval = ( o.x.eGet( r1 ) - row.dot( xu ) ) / scaler;
//       o.x.eSet( r1, xval );
//     }
//
//   }
//
//   return o;
//   // return o.x;
// }

_SolveTriangleUpper.defaults =
{
  m : null,
  x : null,
  // y : null,
  normalizing : 0,
}

let SolveTriangleUpper = _Solver_functor
({
  method : _SolveTriangleUpper,
});
var defaults = SolveTriangleUpper.defaults;
defaults.normalizing = 0;

// function SolveTriangleUpper( x, m, y )
// {
//   let self = this;
//   return self._SolveTriangleWithRoutine( arguments, handleSolve );
//
//   function handleSolve( x, m, y )
//   {
//
//     for( let r1 = y.length-1 ; r1 >= 0 ; r1-- )
//     {
//       let xu = x.review([ r1+1, x.length-1 ]);
//       let row = m.rowGet( r1 );
//       let scaler = row.eGet( r1 );
//       row = row.review([ r1+1, row.length-1 ]);
//       let xval = ( x.eGet( r1 ) - self.vectorAdapter.dot( row, xu ) ) / scaler;
//       x.eSet( r1, xval );
//     }
//
//     return x;
//   }
//
// }

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
 * var x = _.Matrix.SolveTriangleUpperNormalizing( null, m, y );
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

// function SolveTriangleUpperNormalizing( x, m, y )
// {
//   let self = this;
//   return self._SolveTriangleWithRoutine( arguments, handleSolve );
//
//   function handleSolve( x, m, y )
//   {
//
//     for( let r1 = y.length-1 ; r1 >= 0 ; r1-- )
//     {
//       let xu = x.review([ r1+1, x.length-1 ]);
//       let row = m.rowGet( r1 );
//       row = row.review([ r1+1, row.length-1 ]);
//       let xval = ( x.eGet( r1 ) - self.vectorAdapter.dot( row, xu ) );
//       x.eSet( r1, xval );
//     }
//
//     return x;
//   }
//
// }

let SolveTriangleUpperNormalizing = _Solver_functor
({
  method : _SolveTriangleUpper,
  // xIsVector : 1,
});
var defaults = SolveTriangleUpperNormalizing.defaults;
defaults.normalizing = 1;

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
 * var r = _.Matrix.SolveGeneral({ m, y, permutating : 0 });
 * console.log( r.toStr() );
 * // log : {
 * //   nsolutions : Infinity,
 * //   x : _.Matrix.MakeCol([ +3, -3, +0 ]),
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
 * @param { BoolLike } o.permutating - Enables permutating.
 * @returns { Map } - Returns maps with solved system of equations.
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If options map {-o-} has extra options.
 * @function SolveGeneral
 * @static
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function _SolveGeneral( o )
{
  let proto = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assertMapHasAll( o, _SolveGeneral.defaults );

  /* alloc */

  if( o.x )
  o.x = this.From( o.x );

  let ncol = o.m.ncol;
  let nrow = o.m.nrow;
  o.nsolutions = 1;
  o.nkernel = 0;

  /* verify */

  _.assert( o.x === null || o.m.ncol === o.x.nrow );
  _.assert( o.kernel === null || o.m.ncol === o.kernel.nrow );
  _.assert( o.kernel === null || o.m.ncol === o.kernel.ncol );
  _.assert( o.x === null || o.x instanceof Self );
  _.assert( o.x === null || o.x.dims[ 1 ] === 1 );

  /* solve */

  if( o.permutating )
  {
    let repermutatingSolution = o.repermutatingSolution;
    o.repermutatingSolution = 0;
    let x = proto._SolveWithGaussJordan( o );
    o.repermutatingSolution = repermutatingSolution;
  }
  else
  {
    let x = proto._SolveWithGaussJordan( o );
  }

  /* analyse */

  debugger;
  for( let r = 0 ; r < ncol ; r++ )
  {
    let diag = r < nrow ? o.m.scalarGet([ r, r ]) : 0;
    if( abs( diag ) < proto.accuracy )
    {
      if( !o.x || abs( o.x.scalarGet([ r, 0 ]) ) < proto.accuracy )
      {
        o.nsolutions = Infinity;
        o.nkernel += 1;
      }
      else
      {
        debugger;
        o.nsolutions = 0;
        if( o.kernel === null )
        o.kernel = proto.Make([ ncol, 0 ]);
        return o;
      }
    }
  }

  if( o.kernel === null )
  o.kernel = proto.Make([ ncol, o.nkernel ]);

  let ckernel = 0;
  for( let r = 0 ; r < ncol ; r++ )
  {
    let diag = r < nrow ? o.m.scalarGet([ r, r ]) : 0;
    if( abs( diag ) < proto.accuracy )
    {
      let kcol = o.kernel.colGet( ckernel );
      let mcol = o.m.colGet( r );
      kcol.copy( mcol );
      kcol.mul( -1 );
      kcol.eSet( r, 1 );
      ckernel += 1;
    }
  }

  /* permutate backward */

  if( o.permutating )
  {
    if( o.repermutatingSolution )
    {
      if( o.x !== null )
      Self.PermutateBackward( o.x, o.permutates[ 1 ] );
      // let permutates2 = [ o.permutates[ 1 ], o.permutates[ 0 ] ];
      let permutates2 = [ o.permutates[ 1 ], null ];
      o.kernel.permutateBackward( permutates2 );
    }
    if( o.repermutatingTransformation )
    {
      o.m.permutateBackward( o.permutates );
    }
  }

  /* return */

  return o;
}

_SolveGeneral.defaults =
{

  ... _SolveWithGaussJordan.defaults,

  x : null,
  m : null,
  kernel : null,
  repermutatingTransformation : 0,

}

//

let SolveGeneral = _Solver_functor
({
  method : _SolveGeneral,
  returning : 'o',
});

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

/*
qqq : update documentation
qqq : implement good coverage
*/

function invert( dst )
{
  let self = this;

  _.assert( self.dims.length === 2 );
  _.assert( self.isSquare(), `Matrix should be square to be inverted` );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( dst === undefined || dst === _.self )
  dst = self;

  if( dst === self )
  {
    return self.invertWithGaussJordan();
  }
  else
  {
    let clone = self.clone();
    dst = Self.SolveWithGaussJordan( dst, clone, self.Self.MakeIdentity( self.dims[ 0 ] ) );
    return dst;
  }

}

// //
//
// /**
//  * Method copyAndInvert() inverts current matrix by Gauss-Jordan method.
//  *
//  * @example
//  * var m = _.Matrix.MakeSquare( 3 );
//  * var src = _.Matrix.Make( [ 3, 3 ] ).copy
//  * ([
//  *   +2, -3, +4,
//  *   +2, -2, +3,
//  *   +6, -7, +9,
//  * ]);
//  *
//  * m.copyAndInvert( src );
//  * console.log( m.toStr() );
//  * // log :
//  * // -1.5, +0.5, +0.5,
//  * // +0,   +3,   -1,
//  * // +1,   +2,   -1,
//  *
//  * @param { Long|VectorAdapter|Matrix } - Source buffer.
//  * @returns { Matrix } - Returns the matrix with inverted values of source buffer.
//  * @method copyAndInvert
//  * @throws { Error } If number of dimensions is more then two.
//  * @throws { Error } If current matrix is not a square matrix.
//  * @throws { Error } If arguments.length is not equal to one.
//  * @class Matrix
//  * @namespace wTools
//  * @module Tools/math/Matrix
//  */
//
// function copyAndInvert( src )
// {
//   let self = this;
//
//   _.assert( self.dims.length === 2 );
//   _.assert( self.isSquare() );
//   _.assert( arguments.length === 1, 'Expects single argument' );
//
//   self.copy( src );
//   self.invert();
//
//   return self;
// }

// --
// relations
// --

let Statics = /* qqq : split static routines. ask how */
{

  /* Solve */

  _TriangulateGausian,
  TriangulateGausian,
  TriangulateGausianNormalizing,
  TriangulateGausianPermutating,

  Solve,

  _Solve_pre,
  _Solve2_pre,
  _Solver_functor,

  SolveWithGausian,
  SolveWithGausianPermutating,

  _SolveWithGaussJordan,
  SolveWithGaussJordan,
  SolveWithGaussJordanPermutating,

  _SolveWithTriangles,
  SolveWithTriangles,
  SolveWithTrianglesPermutating,

  // _SolveTriangleWithRoutine, /* xxx : check */
  _SolveTriangleLower,
  SolveTriangleLower,
  SolveTriangleLowerNormalizing,
  _SolveTriangleUpper,
  SolveTriangleUpper,
  SolveTriangleUpperNormalizing,

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

  // meta

  _Solve_pre, /* xxx : remove */
  _Solve2_pre,
  _Solver_functor,

  // triangulator

  _TriangulateGausian,
  TriangulateGausian,
  triangulateGausian,
  TriangulateGausianNormalizing,
  triangulateGausianNormalizing,
  TriangulateGausianPermutating,
  triangulateGausianPermutating,

  triangulateLu,
  triangulateLuNormalizing,
  triangulateLuPermutating,

  // Solver

  Solve,

  _SolveWithGausian,
  SolveWithGausian,
  SolveWithGausianPermutating,

  _SolveWithGaussJordan,
  SolveWithGaussJordan,
  SolveWithGaussJordanPermutating,
  invertWithGaussJordan,

  _SolveWithTriangles,
  SolveWithTriangles,
  SolveWithTrianglesPermutating,

  // _SolveTriangleWithRoutine,
  _SolveTriangleLower,
  SolveTriangleLower,
  SolveTriangleLowerNormalizing,
  _SolveTriangleUpper,
  SolveTriangleUpper,
  SolveTriangleUpperNormalizing,

  _SolveGeneral,
  SolveGeneral,

  invert,
  // copyAndInvert,

  //

  Statics,

}

_.classExtend( Self, Extension );

})();
