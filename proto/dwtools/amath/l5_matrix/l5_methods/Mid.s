(function _Mid_s_() {

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
// top
// --

function _linearModel( o )
{

  _.routineOptions( polynomExactFor, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( o.order >= 1 );

  if( o.points )
  if( o.order === null )
  o.order = o.points.length;

  if( o.npoints === null )
  o.npoints = o.points ? o.points.length : o.order;

  let m = this.makeZero([ o.npoints, o.order ]);
  let ys = [];

  /* */

  let i = 0;
  function fixPoint( p )
  {
    ys[ i ] = p[ 1 ];
    let row = m.rowVectorGet( i )
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

_linearModel.defaults =
{
  npoints : null,
  points : null,
  domain : null,
  order : null,
  onFunction : null,
}

//

function polynomExactFor( o )
{

  _.routineOptions( polynomExactFor, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( o.points )
  _.assert( o.order === null || o.order === o.points.length );

  let model = this._linearModel( o );
  let result = this.solve( null , model.m , model.y );

  return result;
}

polynomExactFor.defaults =
{
}

polynomExactFor.defaults.__proto__ = _linearModel.defaults;

//

function polynomClosestFor( o )
{

  _.routineOptions( polynomExactFor, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let model = this._linearModel( o );

  let mt = model.m.clone().transpose();
  let y = this.mul( null , [ mt , model.y ] );
  let m = this.mul( null , [ mt , model.m ] );

  let result = this.solve( null , m , y );

  return result;
}

polynomClosestFor.defaults =
{
  points : null,
  domain : null,
  order : null,
  onFunction : null,
}

polynomClosestFor.defaults.__proto__ = _linearModel.defaults;

// --
// relations
// --

let Statics = /* qqq : split static routines. ask how */
{

  /* modeler */

  _linearModel,
  polynomExactFor,
  polynomClosestFor,

}

// --
// declare
// --

let Extend =
{

  // modeler

  _linearModel,

  polynomExactFor,
  polynomClosestFor,

  //

  Statics,

}

_.classExtend( Self, Extend );

})();
