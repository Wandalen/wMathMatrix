(function _Mid_s_() {

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
// top
// --

function _LinearModel( o )
{

  _.routineOptions( PolynomExactFor, o );
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

function PolynomExactFor( o )
{

  _.routineOptions( PolynomExactFor, o );
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

function PolynomClosestFor( o )
{

  _.routineOptions( PolynomExactFor, o );
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
