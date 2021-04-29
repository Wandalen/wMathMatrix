(function _Mid_s_() {

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
// top
// --

function _LinearModel( o )
{

  _.routine.options_( PolynomExactFor, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( o.order >= 1 );

  if( o.points )
  if( o.order === null )
  o.order = o.points.length;

  if( o.npoints === null )
  o.npoints = o.points ? o.points.length : o.order;

  let m = this.MakeZero([ o.npoints, o.order ]);
  let ys = [];

  /* */

  let i = 0;
  function fixPoint( p )
  {
    ys[ i ] = p[ 1 ];
    let row = m.rowGet( i )
    for( let d = 0 ; d < o.order ; d++ )
    row.eSet( d, pow( p[ 0 ], d ) );
    i += 1;
  }

  /* */

  if( o.points )
  {

    for( let p = 0 ; p < o.points.length ; p++ )
    fixPoint( o.points[ p ] );

  }
  else
  {

    if( o.domain === null )
    o.domain = [ 0, o.order ]

    _.assert( o.order === o.domain[ 1 ] - o.domain[ 0 ] )

    let x = o.domain[ 0 ];
    while( x < o.domain[ 1 ] )
    {
      let y = o.onFunction( x );
      fixPoint([ x, y ]);
      x += 1;
    }

  }

  /* */

  let result = Object.create( null );

  result.m = m;
  result.y = ys;

  return result;
}

_LinearModel.defaults =
{
  npoints : null,
  points : null,
  domain : null,
  order : null,
  onFunction : null,
}

//

/**
 * Static routine PolynomExactFor() extracts polinoms for model that declared in options map {-o-}.
 *
 * @example
 * // PolynomExactFor for E( n )
 * // 1, 2, 6, 10, 15, 21, 28, 36
 * // E = c0 + c1*n + c2*n**2
 * // E = 0 + 0.5*n + 0.5*n**2
 * // E = ( n + n**2 ) * 0.5
 *
 * var f = function( x )
 * {
 *   var r = 0;
 *   for( var i = 0 ; i < x ; i++ )
 *   r += i;
 *   return r;
 * }
 *
 * var polynom = _.Matrix.PolynomExactFor
 * ({
 *   order : 3,
 *   domain : [ 1, 4 ],
 *   onFunction : f,
 * });
 * console.log( polynom.toStr() );
 * // log :
 * // 0,
 * // -0.5,
 * // +0.5
 *
 * @param { Map } o - Options map.
 * @param { Number } o.npoints - Number of points.
 * @param { Long } o.points - A Long with points.
 * @param { Number } o.order - Order of points.
 * @param { Function } o.onFunction - Function that defines model.
 * @returns { Matrix } - Returns polynoms of the model.
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If options map {-o-} has extra options.
 * @static
 * @function PolynomExactFor
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function PolynomExactFor( o )
{

  _.routine.options_( PolynomExactFor, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( o.points )
  _.assert( o.order === null || o.order === o.points.length );

  let model = this._LinearModel( o );
  let result = this.Solve( null , model.m , model.y );

  return result;
}

PolynomExactFor.defaults =
{
}

PolynomExactFor.defaults.__proto__ = _LinearModel.defaults;

//

/**
 * Static routine PolynomClosestFor() calculates closest polynoms for model that declared in options map {-o-}.
 *
 * @example
 * // closest for function E( i )';
 * var polynom = _.Matrix.PolynomClosestFor
 * ({
 *   order : 2,
 *   points : [ [ 1, 0.5 ], [ 2, 2.25 ], [ 3, 2 ] ],
 * });
 * console.log( polynom.toStr() );
 * // log :
 * // 1/12,
 * //  3/4
 *
 * @param { Map } o - Options map.
 * @param { Number } o.npoints - Number of points.
 * @param { Long } o.points - A Long with points.
 * @param { Number } o.order - Order of points.
 * @param { Function } o.onFunction - Function that defines model.
 * @returns { Matrix } - Returns polynoms of the model.
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If options map {-o-} has extra options.
 * @static
 * @function PolynomClosestFor
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function PolynomClosestFor( o )
{

  _.routine.options_( PolynomExactFor, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let model = this._LinearModel( o );

  let mt = model.m.clone().transpose();
  let y = this.Mul( null , [ mt , model.y ] );
  let m = this.Mul( null , [ mt , model.m ] );

  let result = this.Solve( null , m , y );

  return result;
}

PolynomClosestFor.defaults =
{
  points : null,
  domain : null,
  order : null,
  onFunction : null,
}

PolynomClosestFor.defaults.__proto__ = _LinearModel.defaults;

// --
// relations
// --

let Statics =
{

  /* modeler */

  _LinearModel,
  PolynomExactFor,
  PolynomClosestFor,

}

// --
// declare
// --

let Extension =
{

  // modeler

  _LinearModel,

  PolynomExactFor,
  PolynomClosestFor,

  //

  Statics,

}

_.classExtend( Self, Extension );

})();
