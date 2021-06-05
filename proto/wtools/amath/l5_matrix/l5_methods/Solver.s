(function _Solve_s_() {

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
// meta
// --

function _Solve2_head( routine, args )
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
    o.x = args[ 0 ];
    o.m = args[ 1 ];
    o.y = args[ 2 ];
  }

  _.routine.optionsWithoutUndefined( routine, o ); /* qqq : for Dmytro : investigate, maybe, it can be improved */
  // _.routine.options_( routine, o );

  if( o.permutating )
  {
    if( o.onPermutate === null )
    o.onPermutate = this._PermutateLineRook.body;
    if( o.onPermutatePre === null )
    o.onPermutatePre = this._PermutateLineRook.head;
  }

  if( o.x === null )
  {
    if( _.longIs( o.y ) )
    {
      let l = Math.max( o.m.dims[ 1 ], this.NrowOf( o.y ) ) - 1;
      o.x = _.longGrow_( null, o.y, [ 0, l ], 0 );
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
  _.assert( o.m.dims[ 0 ] >= this.NrowOf( o.y ), () => inconsistentDims( o.m, o.y ) );
  _.assert( _.matrixIs( o.m ) );
  _.assert( _.matrixIs( o.x ) || _.vectorIs( o.x ) );
  _.assert( _.matrixIs( o.x ) || _.vectorIs( o.y ) );

  return o;

  function inconsistentDims( m1, m2 )
  {
    return `Inconsistent dimensions of 2 matrix-like ${_.matrix.dimsExportString( m1 )} and ${_.matrix.dimsExportString( m2 )}`;
  }

}

//

function _SolveRepermutate( o )
{
  let proto = this;

  if( !o.permutating )
  return o;

  _.map.assertHasAll( o, _SolveRepermutate.defaults );

  if( o.repermutatingSolution )
  if( o.x )
  {
    Self.PermutateBackward( o.x, o.permutates[ 1 ] );
  }

  if( o.repermutatingTransformation )
  if( o.m )
  {
    o.m.permutateBackward( o.permutates );
  }

  return o;
}

_SolveRepermutate.defaults =
{
  m : null,
  x : null,
  permutates : null,
  permutating : 0,
  onPermutate : null,
  onPermutatePre : null,
  repermutatingSolution : 1,
  repermutatingTransformation : 0,
}

//

function _Solver_functor( fop )
{

  if( _.routineIs( arguments[ 0 ] ) )
  fop = { method : arguments[ 0 ] };

  _.routine.options_( _Solver_functor, fop );
  _.assert( _.routineIs( fop.method ) );
  _.assert( _.routineIs( _Solve2_head ) );
  _.assert( _.mapIs( fop.method.defaults ) );
  _.assert( _.longHas( [ 'o', 'ox' ], fop.returning ) );

  let method = fop.method;
  let returning = fop.returning;
  let repermutate = fop.repermutate;

  if( repermutate === null )
  repermutate = _SolveRepermutate;

  solve.defaults =
  {
    ... fop.method.defaults,
    ox : null,
    oy : null,
    y : null,
  }
  solve.head = _Solve2_head;
  solve.body = method;

  let r =
  {
    [ method.name ] : solve,
  }

  return r[ method.name ];

  function solve()
  {
    let o = this._Solve2_head( solve, arguments );

    method.call( this, o );

    repermutate( o );

    if( returning === 'ox' )
    return o.ox;
    else
    return o;
  }

}

_Solver_functor.defaults =
{
  method : null,
  repermutate : null,
  returning : 'ox',
}

// --
// triangulator
// --

function _TriangulateGausian( o )
{
  let proto = this;
  let nrow = o.m.nrow;
  let ncol = Math.min( o.m.ncol, nrow );

  if( o.x )
  o.x = this.From( o.x );

  _.assert( arguments.length === 1 );
  _.assert( !o.x || o.m.dims[ 1 ] <= this.NrowOf( o.x ) );
  _.map.assertHasAll( o, _TriangulateGausian.defaults );
  _.assert( _.matrixIs( o.m ) );
  _.assert( o.x === null || _.matrixIs( o.x ) );

  if( o.permutating )
  o.onPermutatePre( o.onPermutate, [ o ] );

  /* */

  if( o.x )
  triangulateWithX();
  else
  triangulateWithoutX();

  return o;

  /* */

  function triangulateWithX() /* xxx : split */
  {

    for( let r1 = 0 ; r1 < ncol ; r1++ )
    {

      if( o.permutating )
      {
        o.lineIndex = r1;
        o.onPermutate( o );
      }

      let row1 = o.m.rowGet( r1 );
      let xrow1 = o.x.rowGet( r1 );
      let scaler1 = row1.eGet( r1 );

      if( Math.abs( scaler1 ) < proto.accuracySqrt )
      continue;

      if( o.normalizing )
      {
        row1.eSet( r1, 1 );
        row1 = row1.review( r1+1 );
        row1.div( scaler1 );
        xrow1.div( scaler1 );
        scaler1 = 1;
      }
      else
      {
        row1 = row1.review( r1+1 );
      }

      for( let r2 = r1+1 ; r2 < nrow ; r2++ )
      {
        let row2 = o.m.rowGet( r2 );
        let xrow2 = o.x.rowGet( r2 );
        let scaler = row2.eGet( r1 ) / scaler1;

        if( Math.abs( scaler ) < proto.accuracy )
        continue;

        row2.eSet( r1, 0 );
        row2 = row2.review( r1+1 );
        row2.subScaled( row1, scaler );
        xrow2.subScaled( xrow1, scaler );
      }

    }

    // proto._SolveRepermutate( o );

  }

  /* */

  function triangulateWithoutX()
  {

    for( let r1 = 0 ; r1 < ncol ; r1++ )
    {

      if( o.permutating )
      {
        o.lineIndex = r1;
        o.onPermutate( o );
      }

      let row1 = o.m.rowGet( r1 );
      let scaler1 = row1.eGet( r1 );

      if( Math.abs( scaler1 ) < proto.accuracySqrt )
      continue;

      if( o.normalizing )
      {
        row1.eSet( r1, 1 );
        row1 = row1.review( r1+1 );
        row1.div( scaler1 );
        scaler1 = 1;
      }
      else
      {
        row1 = row1.review( r1+1 );
      }

      for( let r2 = r1+1 ; r2 < nrow ; r2++ )
      {
        let row2 = o.m.rowGet( r2 );
        let scaler = row2.eGet( r1 ) / scaler1;

        if( Math.abs( scaler ) < proto.accuracy )
        continue;

        row2.eSet( r1, 0 );
        row2 = row2.review( r1+1 ); /* xxx */
        row2.subScaled( row1, scaler );
      }

    }

  }

  /* */

}

_TriangulateGausian.defaults =
{

  ... _SolveRepermutate.defaults,

  m : null,
  x : null,
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

//

function _TriangulateLu( o )
{
  let proto = this;
  let nrow = o.m.nrow;
  let ncol = Math.min( o.m.ncol, nrow );

  _.map.assertHasAll( o, _TriangulateLu.defaults );

  if( o.permutating )
  o.onPermutatePre( o.onPermutate, [ o ] );

  _.assert( arguments.length === 1 );
  _.assert( o.m.dims.length === 2 );

  /* */

  if( o.normalizing )
  actNormalizing();
  else
  actNotNormalizing();

  /* */

  return o;

  /* */

  function actNormalizing()
  {
    for( let r1 = 0 ; r1 < ncol ; r1++ )
    {

      if( o.permutating )
      {
        o.lineIndex = r1;
        o.onPermutate( o );
      }

      let row1 = o.m.rowGet( r1 );
      let scaler1 = row1.eGet( r1 );
      row1 = row1.review( r1+1 );
      row1.div( scaler1 );

      for( let r2 = r1+1 ; r2 < nrow ; r2++ )
      {
        let row2 = o.m.rowGet( r2 );
        let scaler = row2.eGet( r1 );
        row2.review( r1+1 ).subScaled( row1, scaler );
      }

    }
  }

  /* */

  function actNotNormalizing()
  {
    for( let r1 = 0 ; r1 < ncol ; r1++ )
    {

      if( o.permutating )
      {
        o.lineIndex = r1;
        o.onPermutate( o );
      }

      let row1 = o.m.rowGet( r1 );
      let scaler1 = row1.eGet( r1 );
      row1 = row1.review( r1+1 )

      for( let r2 = r1+1 ; r2 < nrow ; r2++ )
      {
        let row2 = o.m.rowGet( r2 );
        let scaler = row2.eGet( r1 ) / scaler1;
        row2.review( r1+1 ).subScaled( row1, scaler );
        row2.eSet( r1, scaler );
      }

    }
  }

  /* */

}

_TriangulateLu.defaults =
{

  ... _SolveRepermutate.defaults,

  m : null,
  normalizing : 0,
  repermutatingSolution : 0,
  repermutatingTransformation : 0,

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

let TriangulateLu = _Solver_functor
({
  method : _TriangulateLu,
  returning : 'o',
});
var defaults = TriangulateLu.defaults;
defaults.normalizing = 0;
defaults.permutating = 0;

function triangulateLu( o )
{
  let self = this;
  o = o || Object.create( null );
  o.m = self;
  return self.TriangulateLu( o );
}

triangulateLu.defaults =
{
  ... _.mapBut_( null, TriangulateLu.defaults, [ 'm' ] ),
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

let TriangulateLuNormalizing = _Solver_functor
({
  method : _TriangulateLu,
  returning : 'o',
});
var defaults = TriangulateLuNormalizing.defaults;
defaults.normalizing = 1;
defaults.permutating = 0;

function triangulateLuNormalizing( o )
{
  let self = this;
  o = o || Object.create( null );
  o.m = self;
  return self.TriangulateLuNormalizing( o );
}

triangulateLuNormalizing.defaults =
{
  ... _.mapBut_( null, TriangulateLuNormalizing.defaults, [ 'm' ] ),
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

let TriangulateLuPermutating = _Solver_functor
({
  method : _TriangulateLu,
  returning : 'o',
});
var defaults = TriangulateLuPermutating.defaults;
defaults.normalizing = 1;
defaults.permutating = 1;

function triangulateLuPermutating( o )
{
  let self = this;
  o = o || Object.create( null );
  o.m = self;
  return self.TriangulateLuPermutating( o );
}

triangulateLuPermutating.defaults =
{
  ... _.mapBut_( null, TriangulateLuPermutating.defaults, [ 'm' ] ),
}

//

let TriangulateLuNormalizingPermutating = _Solver_functor
({
  method : _TriangulateLu,
  returning : 'o',
});
var defaults = TriangulateLuNormalizingPermutating.defaults;
defaults.normalizing = 1;
defaults.permutating = 1;

function triangulateLuNormalizingPermutating( o )
{
  let self = this;
  o = o || Object.create( null );
  o.m = self;
  return self.TriangulateLuNormalizingPermutating( o );
}

triangulateLuNormalizingPermutating.defaults =
{
  ... _.mapBut_( null, TriangulateLuNormalizingPermutating.defaults, [ 'm' ] ),
}

// --
// Solver
// --


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

function _SolveTriangleLower( o )
{

  _.map.assertHasAll( o, _SolveTriangleLower.defaults );

  if( o.normalized )
  {

    if( _.matrixIs( o.x ) )
    actMatrixNormalized( o.x );
    else
    actVectorNormalized( o.x );

  }
  else
  {

    if( _.matrixIs( o.x ) )
    actMatrixNotNormalized( o.x );
    else
    actVectorNotNormalized( o.x );

  }

  return o;

  function actMatrixNormalized( x )
  {
    for( let i = 0, l = x.ncol ; i < l ; i++ )
    {
      actVectorNormalized( x.colGet( i ) );
    }
  }

  function actVectorNormalized( x )
  {
    for( let r1 = 0, l = x.length ; r1 < l ; r1++ )
    // for( let r1 = 0, l = m.ncol ; r1 < l ; r1++ )
    {
      let xu = x.review([ 0, r1-1 ]);
      let row = o.m.rowGet( r1 ).review([ 0, r1-1 ]);
      let xval = x.eGet( r1 ) - row.dot( xu );
      x.eSet( r1, xval );
    }
  }

  function actMatrixNotNormalized( x )
  {
    for( let i = 0, l = x.ncol ; i < l ; i++ )
    {
      actVectorNotNormalized( x.colGet( i ) );
    }
  }

  function actVectorNotNormalized( x )
  {
    for( let r1 = 0, l = x.length ; r1 < l ; r1++ )
    // for( let r1 = 0, l = m.ncol ; r1 < l ; r1++ )
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
  normalized : 0,
}

//

let SolveTriangleLower = _Solver_functor
({
  method : _SolveTriangleLower,
});

var defaults = SolveTriangleLower.defaults;
defaults.normalized = 0;

//

/**
 * Static routine SolveTriangleLowerNormalized() solves system of equations with lower triangular matrix.
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
 * var x = _.Matrix.SolveTriangleLowerNormalized( null, m, y );
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
 * @function SolveTriangleLowerNormalized
 * @static
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

let SolveTriangleLowerNormalized = _Solver_functor
({
  method : _SolveTriangleLower,
});
var defaults = SolveTriangleLowerNormalized.defaults;
defaults.normalized = 1;

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
  let proto = this;

  _.map.assertHasAll( o, _SolveTriangleUpper.defaults );

  if( o.normalized )
  {

    if( _.matrixIs( o.x ) )
    actMatrixNormalized( o.x );
    else
    actVectorNormalized( o.x );

  }
  else
  {

    if( _.matrixIs( o.x ) )
    actMatrixNotNormalized( o.x );
    else
    actVectorNotNormalized( o.x );

  }

  return o;

  function actMatrixNormalized( x )
  {
    for( let i = 0, l = x.ncol ; i < l ; i++ )
    {
      actVectorNormalized( x.colGet( i ) );
    }
  }

  function actVectorNormalized( x )
  {
    for( let l = x.length-1, r1 = l ; r1 >= 0 ; r1-- )
    {
      let xu = x.review([ r1+1, l ]);
      let row = o.m.rowGet( r1 );
      row = row.review([ r1+1, row.length-1 ]);
      let xval = x.eGet( r1 ) - row.dot( xu );
      x.eSet( r1, xval );
    }
  }

  function actMatrixNotNormalized( x )
  {
    for( let i = 0, l = x.ncol ; i < l ; i++ )
    {
      actVectorNotNormalized( x.colGet( i ) );
    }
  }

  function actVectorNotNormalized( x )
  {
    for( let l = x.length-1, r1 = l ; r1 >= 0 ; r1-- )
    {
      let row = o.m.rowGet( r1 );
      let scaler = row.eGet( r1 );
      let xu = x.review([ r1+1, l ]);
      row = row.review([ r1+1, row.length-1 ]);
      let xval = ( x.eGet( r1 ) - row.dot( xu ) );
      if( Math.abs( scaler ) > proto.accuracy )
      {
        xval /= scaler;
      }
      x.eSet( r1, xval );
    }
  }

}

_SolveTriangleUpper.defaults =
{
  m : null,
  x : null,
  normalized : 0,
}

//

let SolveTriangleUpper = _Solver_functor
({
  method : _SolveTriangleUpper,
});
var defaults = SolveTriangleUpper.defaults;
defaults.normalized = 0;

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
 * var x = _.Matrix.SolveTriangleUpperNormalized( null, m, y );
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

let SolveTriangleUpperNormalized = _Solver_functor
({
  method : _SolveTriangleUpper,
});
var defaults = SolveTriangleUpperNormalized.defaults;
defaults.normalized = 1;

//

function _SolveWithGausian( o )
{
  let proto = this;

  if( o.x )
  o.x = proto.From( o.x );

  _.map.assertHasAll( o, _SolveWithGausian.defaults );
  _.assert( _.matrixIs( o.m ) );
  _.assert( o.x === null || _.matrixIs( o.x ) );

  // o.normalizing = 1;
  proto._TriangulateGausian( o );

  if( o.ox === null )
  return o.ox;

  o.normalized = o.normalizing;
  proto._SolveTriangleUpper( o );

  // proto._SolveRepermutate( o );

  return o.ox;
}

_SolveWithGausian.defaults =
{

  ... _SolveRepermutate.defaults,

  normalizing : 1,
  m : null,
  x : null,
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

let SolveWithGausian = _Solver_functor
({
  method : _SolveWithGausian,
  returning : 'ox',
});
var defaults = SolveWithGausian.defaults;
defaults.permutating = 0;
defaults.normalizing = 0;

//

let SolveWithGausianNormalizing = _Solver_functor
({
  method : _SolveWithGausian,
  returning : 'ox',
});
var defaults = SolveWithGausianNormalizing.defaults;
defaults.permutating = 0;
defaults.normalizing = 1;

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

let SolveWithGausianPermutating = _Solver_functor
({
  method : _SolveWithGausian,
  returning : 'ox',
});
var defaults = SolveWithGausianPermutating.defaults;
defaults.permutating = 1;
defaults.normalizing = 0;

let SolveWithGausianNormalizingPermutating = _Solver_functor
({
  method : _SolveWithGausian,
  returning : 'ox',
});
var defaults = SolveWithGausianNormalizingPermutating.defaults;
defaults.permutating = 1;
defaults.normalizing = 1;

//

function _SolveWithGaussJordan( o )
{
  let proto = this;
  let nrow = o.m.nrow;
  let ncol = Math.min( o.m.ncol, nrow );

  _.map.assertHasAll( o, _SolveWithGaussJordan.defaults );

  if( o.x )
  o.x = proto.From( o.x );

  _.assert( _.matrixIs( o.m ) );
  _.assert( o.x === null || _.matrixIs( o.x ) );

  if( o.permutating )
  o.onPermutatePre( o.onPermutate, [ o ] );

  /* */

  if( o.x )
  solveWithX();
  else
  solveWithoutX();

  if( !o.normalizing && o.x )
  {
    let diag = o.m.diagonalGet();
    for( let d = diag.length-1 ; d >= 0 ; d-- )
    {
      let scaler = diag.eGet( d );
      if( Math.abs( scaler ) >= proto.accuracy )
      o.x.rowGet( d ).div( scaler );
    }
  }

  /* */

  // proto._SolveRepermutate( o );

  /* */

  return o;

  function solveWithX() /* qqq2 : factorize by option o.normalizing */
  {
    for( let r1 = 0 ; r1 < ncol ; r1++ )
    {

      if( o.permutating )
      {
        o.lineIndex = r1;
        o.onPermutate( o );
      }

      let row1 = o.m.rowGet( r1 );
      let scaler1 = row1.eGet( r1 );

      if( abs( scaler1 ) < proto.accuracySqrt )
      continue;

      if( o.normalizing )
      row1.eSet( r1, 1 );
      row1 = row1.review( r1+1 );
      if( o.normalizing )
      row1.mul( 1/scaler1 );

      let xrow1 = o.x.rowGet( r1 );
      if( o.normalizing )
      xrow1.mul( 1/scaler1 );

      for( let r2 = 0 ; r2 < nrow ; r2++ )
      {

        if( r1 === r2 )
        continue;

        let xrow2 = o.x.rowGet( r2 );
        let row2 = o.m.rowGet( r2 );
        let scaler2 = row2.eGet( r1 );

        if( !o.normalizing )
        scaler2 = scaler2 / scaler1;

        if( abs( scaler2 ) < proto.accuracy )
        continue;

        row2.eSet( r1, 0 );
        row2 = row2.review( r1+1 );
        row2.subScaled( row1, scaler2 );
        xrow2.subScaled( xrow1, scaler2 );

      }

    }
  }

  /* */

  function solveWithoutX()  /* qqq2 : factorize by option o.normalizing */
  {
    for( let r1 = 0 ; r1 < ncol ; r1++ )
    {

      if( o.permutating )
      {
        o.lineIndex = r1;
        o.onPermutate( o );
      }

      let row1 = o.m.rowGet( r1 );
      let scaler1 = row1.eGet( r1 );

      if( abs( scaler1 ) < proto.accuracySqrt )
      continue;

      if( o.normalizing )
      row1.eSet( r1, 1 );
      row1 = row1.review( r1+1 );
      if( o.normalizing )
      row1.mul( 1/scaler1 );

      for( let r2 = 0 ; r2 < nrow ; r2++ )
      {

        if( r1 === r2 )
        continue;

        let row2 = o.m.rowGet( r2 );
        let scaler2 = row2.eGet( r1 );

        if( !o.normalizing )
        scaler2 = scaler2 / scaler1;

        if( abs( scaler2 ) < proto.accuracy )
        continue;

        row2.eSet( r1, 0 );
        row2 = row2.review( r1+1 );
        row2.subScaled( row1, scaler2 );

      }

    }
  }

  /* */

}

_SolveWithGaussJordan.defaults =
{

  ... _SolveRepermutate.defaults,

  m : null,
  x : null,
  normalizing : 1,

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
var defaults = SolveWithGaussJordan.defaults;
defaults.permutating = 0;
defaults.normalizing = 0;

let SolveWithGaussJordanNormalizing = _Solver_functor( _SolveWithGaussJordan );
var defaults = SolveWithGaussJordanNormalizing.defaults;
defaults.permutating = 0;
defaults.normalizing = 1;

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
defaults.normalizing = 0;

let SolveWithGaussJordanNormalizingPermutating = _Solver_functor( _SolveWithGaussJordan );
var defaults = SolveWithGaussJordanNormalizingPermutating.defaults;
defaults.permutating = 1;
defaults.normalizing = 1;

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
    let xrow1 = self.rowGet( r1 ).review([ 0, r1 ]);

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

function _SolveWithTriangles( o )
{
  let proto = this;

  if( o.x )
  o.x = this.From( o.x );

  _.map.assertHasAll( o, _SolveWithTriangles.defaults );
  _.assert( _.matrixIs( o.m ) );
  _.assert( _.matrixIs( o.x ) || o.x === null ); /* yyy */

  proto._TriangulateLu( o );

  /* _TriangulateLu permutate both o.m and ox. no need to permutate o.x individually */

  if( o.x === null )
  return o;

  o.normalized = !o.normalizing;
  proto._SolveTriangleLower( o );

  o.normalized = o.normalizing;
  proto._SolveTriangleUpper( o );

  return o;
}

_SolveWithTriangles.defaults =
{

  ... _SolveRepermutate.defaults,

  m : null,
  x : null,
  permutating : 0,
  normalizing : 1,

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

let SolveWithTriangles = _Solver_functor( _SolveWithTriangles );
var defaults = SolveWithTriangles.defaults;
defaults.permutating = 0;
defaults.normalizing = 0;

let SolveWithTrianglesNormalizing = _Solver_functor( _SolveWithTriangles );
var defaults = SolveWithTrianglesNormalizing.defaults;
defaults.permutating = 0;
defaults.normalizing = 1;

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

let SolveWithTrianglesPermutating = _Solver_functor( _SolveWithTriangles );
var defaults = SolveWithTrianglesPermutating.defaults;
defaults.permutating = 1;
defaults.normalizing = 0;

let SolveWithTrianglesNormalizingPermutating = _Solver_functor( _SolveWithTriangles );
var defaults = SolveWithTrianglesNormalizingPermutating.defaults;
defaults.permutating = 1;
defaults.normalizing = 1;

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

// function Solve( x, m, y )
// {
//   _.assert( arguments.length === 3, 'Expects exactly three arguments' );
//   return this.SolveWithTrianglesPermutating( x, m, y )
// }

let Solve = SolveWithTrianglesNormalizingPermutating;

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

// --
// general
// --

function _SolveGeneralRepermutate( o )
{
  let proto = this;

  if( !o.permutating )
  return o;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.map.assertHasAll( o, _SolveGeneralRepermutate.defaults );

  /* permutate backward */

  if( o.repermutatingSolution )
  {
    if( o.x !== null )
    Self.PermutateBackward( o.x, o.permutates[ 1 ] );
    if( o.okernel === o.nkernel && o.nkernel > 0 )
    {
      let permutates2 = [ o.permutates[ 1 ], null ];
      o.kernel.permutateBackward( permutates2 );
    }
  }
  if( o.repermutatingTransformation )
  {
    o.m.permutateBackward( o.permutates );
  }

  /* return */

  return o;
}

_SolveGeneralRepermutate.defaults =
{

  ... _SolveRepermutate.defaults,

  x : null,
  m : null,
  kernel : null,

  repermutatingSolution : 1,
  repermutatingTransformation : 0,

}

//

function _SolveGeneral( o )
{
  let proto = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.map.assertHasAll( o, _SolveGeneral.defaults );

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
  _.assert( o.kernel === null || o.m.ncol <= o.kernel.ncol );
  _.assert( o.x === null || o.x instanceof Self );
  _.assert( o.x === null || o.x.dims[ 1 ] === 1 );

  /* solve */

  o.normalizing = 1;
  let x = proto._SolveWithGaussJordan( o );

  /* estimate */

  for( let r = 0 ; r < ncol ; r++ )
  {
    let diag = r < nrow ? o.m.scalarGet([ r, r ]) : 0;
    if( abs( diag ) < proto.accuracySqrt )
    {
      if( !o.x || abs( o.x.scalarGet([ r, 0 ]) ) < proto.accuracySqrt )
      {
        o.nsolutions = Infinity;
        o.nkernel += 1;
      }
      else
      {
        o.nsolutions = 0;
        if( o.kernel === null )
        o.kernel = proto.Make([ ncol, 0 ]);
        return o;
      }
    }
  }

  /* reval */

  if( o.kernel === null )
  o.kernel = proto.Make([ ncol, o.nkernel ]);

  _.assert( o.kernel.dims[ 0 ] === o.m.dims[ 1 ] );
  _.assert( o.kernel.dims[ 1 ] >= o.nkernel - o.okernel );

  for( let r = 0 ; r < ncol ; r++ )
  {
    let diag = r < nrow ? o.m.scalarGet([ r, r ]) : 0;
    if( abs( diag ) < proto.accuracySqrt )
    {
      let kcol = o.kernel.colGet( o.okernel );
      let mcol = o.m.colGet( r );
      kcol.copy( mcol );
      kcol.mul( -1 );
      kcol.eSet( r, 1 );
      o.okernel += 1;
    }
  }

  /* permutate backward */

  // proto._SolveGeneralRepermutate( o );

  /* return */

  return o;
}

_SolveGeneral.defaults =
{

  ... _SolveGeneralRepermutate.defaults,

  x : null,
  m : null,
  kernel : null,
  okernel : 0,
  permutating : 1,

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

let SolveGeneral = _Solver_functor
({
  method : _SolveGeneral,
  repermutate : _SolveGeneralRepermutate,
  returning : 'o',
});

//

function nullspace( dst )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( dst === undefined || dst === null || dst === _.self || _.matrixIs( dst ) );

  let o = { m : self.clone() };

  if( dst === _.self || dst === self )
  {
    o.kernel = self;
  }
  else if( dst === null || dst === undefined )
  {
  }
  else
  {
    o.kernel = dst;
  }

  self.SolveGeneral( o );
  return o.kernel;
}

//

function rref( dst, y )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1 || arguments.length === 2 );
  _.assert( dst === undefined || dst === null || dst === _.self || _.matrixIs( dst ) );

  let o = { y };

  if( dst === _.self || dst === self || dst === undefined )
  {
    o.m = self;
  }
  else if( dst === null )
  {
    o.m = self.clone();
  }
  else
  {
    dst.copy( self );
    o.m = dst;
  }

  self.SolveWithGaussJordanNormalizingPermutating( o );
  // self.SolveGeneral( o );
  return o.m;
}

// --
// relations
// --

let Statics = /* qqq : split static routines. ask how */
{

  // meta

  _Solve2_head,
  _SolveRepermutate,
  _Solver_functor,

  // triangulator

  _TriangulateGausian,
  TriangulateGausian,
  TriangulateGausianNormalizing,
  TriangulateGausianPermutating,
  TriangulateGausianNormalizingPermutating,

  _TriangulateLu,
  TriangulateLu,
  TriangulateLuNormalizing,
  TriangulateLuPermutating,
  TriangulateLuNormalizingPermutating,

  // solver

  _SolveTriangleLower,
  SolveTriangleLower,
  SolveTriangleLowerNormalized,
  _SolveTriangleUpper,
  SolveTriangleUpper,
  SolveTriangleUpperNormalized,

  _SolveWithGausian,
  SolveWithGausian,
  SolveWithGausianNormalizing,
  SolveWithGausianPermutating,
  SolveWithGausianNormalizingPermutating,

  _SolveWithGaussJordan,
  SolveWithGaussJordan,
  SolveWithGaussJordanNormalizing,
  SolveWithGaussJordanPermutating,
  SolveWithGaussJordanNormalizingPermutating,

  _SolveWithTriangles,
  SolveWithTriangles,
  SolveWithTrianglesNormalizing,
  SolveWithTrianglesPermutating,
  SolveWithTrianglesNormalizingPermutating,

  Solve,

  // general

  _SolveGeneralRepermutate,
  _SolveGeneral,
  SolveGeneral,

}

// --
// declare
// --

let Extension =
{

  // meta

  _Solve2_head,
  _SolveRepermutate,
  _Solver_functor,

  // triangulator

  _TriangulateGausian,
  TriangulateGausian,
  triangulateGausian,
  TriangulateGausianNormalizing,
  triangulateGausianNormalizing,
  TriangulateGausianPermutating,
  triangulateGausianPermutating,
  TriangulateGausianNormalizingPermutating,
  triangulateGausianNormalizingPermutating,

  _TriangulateLu,
  TriangulateLu,
  triangulateLu,
  TriangulateLuNormalizing,
  triangulateLuNormalizing,
  TriangulateLuPermutating,
  triangulateLuPermutating,
  TriangulateLuNormalizingPermutating,
  triangulateLuNormalizingPermutating,

  // solver

  _SolveTriangleLower,
  SolveTriangleLower,
  SolveTriangleLowerNormalized,
  _SolveTriangleUpper,
  SolveTriangleUpper,
  SolveTriangleUpperNormalized,

  _SolveWithGausian,
  SolveWithGausian,
  SolveWithGausianNormalizing,
  SolveWithGausianPermutating,
  SolveWithGausianNormalizingPermutating,

  _SolveWithGaussJordan,
  SolveWithGaussJordan,
  SolveWithGaussJordanNormalizing,
  SolveWithGaussJordanPermutating,
  SolveWithGaussJordanNormalizingPermutating,
  invertWithGaussJordan,

  _SolveWithTriangles,
  SolveWithTriangles,
  SolveWithTrianglesNormalizing,
  SolveWithTrianglesPermutating,
  SolveWithTrianglesNormalizingPermutating,

  Solve,
  invert,

  // general

  _SolveGeneralRepermutate,
  _SolveGeneral,
  SolveGeneral,
  nullspace, /* qqq : cover please */
  rref, /* qqq : cover please */

  //

  Statics,

}

_.classExtend( Self, Extension );

})();
