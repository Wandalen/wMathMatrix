( function _Eigen_s_()
{

'use strict';

const _ = _global_.wTools;
const Parent = null;
const Self = _.Matrix;

_.assert( _.object.isBasic( _.vectorAdapter ) );
_.assert( _.routineIs( Self ), 'wMatrix is not defined, please include wMatrix.s first' );

// --
//
// --

function polynomnRoots( polynomn, dst ) /* xxx qqq : move out. ask */
{
  let calc = [ polynomn0Roots, polynomn1Roots, polynomn2Roots, polynomn3Roots ];

  if( polynomn.length > 3 )
  {
    _.assert( 0, 'not implemented' );
  }

  return calc[ polynomn.length ].call( this, polynomn, dst );
}

//

function polynomn0Roots( polynomn, dst )
{
  _.assert( polynomn.length === 0 );
  if( !dst )
  dst = [];
  return dst;
}

//

function polynomn1Roots( polynomn, dst )
{
  _.assert( polynomn.length === 1 );

  if( !dst )
  dst = [];
  dst[ 0 ] = - polynomn[ 0 ];

  return dst;
}

//

function polynomn2Roots( polynomn, dst )
{
  _.assert( polynomn.length === 2 );

  if( !dst )
  dst = [];
  let d = _.math.sqrt( polynomn[ 0 ]**2 - 4*polynomn[ 1 ] );
  dst[ 0 ] = ( - polynomn[ 0 ] - d ) / 2;
  dst[ 1 ] = ( - polynomn[ 0 ] + d ) / 2;

  return dst;
}

//

function polynomn3Roots( polynomn, dst )
{
  _.assert( polynomn.length === 3 );

  if( !dst )
  dst = [];

  if( Math.abs( polynomn[ 0 ] ) < _.accuracy )
  {
    return polynomn2Roots( polynomn.slice( 1 ), dst );
  }

  /* to depressed cubic */
  let p = ( 3*polynomn[ 1 ] - polynomn[ 0 ]*polynomn[ 0 ] ) / ( 3 );
  let q = ( 2*polynomn[ 0 ]*polynomn[ 0 ]*polynomn[ 0 ] - 9*polynomn[ 0 ]*polynomn[ 1 ] + 27*polynomn[ 2 ] ) / ( 27 );

  if( Math.abs( p ) < _.accuracy )
  {
    let val = _.math.cbrt( -q );
    dst = [ val, val, val ];
  }
  else if( Math.abs( q ) < _.accuracy )
  {
    _.assert( 'not tested' );
    dst = [ 0, p < 0 ? [ Math.sqrt( -p ), -Math.sqrt( -p ) ] : [ 0, 0 ] ];
  }
  else
  {
    let desc = q*q/4 + p*p*p/27;
    // if( Math.abs( desc ) < _.accuracy )
    // {
    //   dst = [ -1.5*q/p, 3*q/p ];
    // }
    // else if( desc > 0 )
    // {
    //   let u = _.math.cbrt( -q/2 - Math.sqrt( desc ) );
    //   dst = [ u - p/( 3*u ) ];
    // }
    // else
    {
      let u = 2*Math.sqrt( -p/3 );
      let t = Math.acos( 3*q/p/u )/3;
      let k = 2*Math.PI/3;
      dst = [ u*Math.cos( t ), u*Math.cos( t-k ), u*Math.cos( t-2*k ) ];
    }
  }

  /* from depressed cubic */
  for( let i = 0; i < dst.length; i++ )
  dst[ i ] -= polynomn[ 0 ] / 3;

  dst.sort();

  return dst;
}

//

function characteristicPolynomial( dst )
{
  let self = this;
  let ncol = self.ncol;
  let calc = [ act0, act1, act2, act3 ];

  _.assert( arguments.length === 0 || arguments.length === 1, 'Expects single argument' );

  if( !dst )
  dst = [];

  if( ncol > 3 )
  {
    _.assert( 0, 'not implemented' );
  }

  calc[ ncol ]();

  return dst;

  /* */

  function act0()
  {
  }

  function act1()
  {
    dst[ 0 ] = - e( 0, 0 );
  }

  function act2()
  {
    dst[ 0 ] = - e( 0, 0 ) - e( 1, 1 );
    dst[ 1 ] = + e( 0, 0 )*e( 1, 1 ) - e( 0, 1 )*e( 1, 0 );

/*
    | z-e00 -e01   |
    | -e10   z-e11 |

    ( z-e00 )*( z-e11 ) + e10*e01 = 0
    z^2 - z*( e00+e11 ) + e00*e11 - e10*e01 = 0
*/

  }

  function act3()
  {

    dst[ 0 ] = - e( 0, 0 ) - e( 1, 1 ) - e( 2, 2 );
    dst[ 1 ] = + e( 0, 0 )*e( 1, 1 ) + e( 1, 1 )*e( 2, 2 ) + e( 2, 2 )*e( 0, 0 )
               - e( 0, 2 )*e( 2, 0 ) - e( 1, 2 )*e( 2, 1 ) - e( 1, 0 )*e( 0, 1 );
    dst[ 2 ] = - e( 0, 0 )*e( 1, 1 )*e( 2, 2 ) - e( 0, 1 )*e( 1, 2 )*e( 2, 0 ) - e( 1, 0 )*e( 2, 1 )*e( 0, 2 )
               + e( 0, 2 )*e( 2, 0 )*e( 1, 1 ) + e( 0, 1 )*e( 1, 0 )*e( 2, 2 ) + e( 1, 2 )*e( 2, 1 )*e( 0, 0 );

/*
    | z-e00   -e01   -e02|
    |  -e10  z-e11   -e12|
    |  -e20   -e21  z-e22|

    ++++ ( z-e00 )*( z-e11 )*( z-e22 ) +--- e01*e12*e20 +--- e10*e21*e02
    --+- e02*e20*( z-e11 ) ---+ e10*e01*( z-e22 ) ---+ e12*e21*( z-e00 ) = 0

    + z*z*z
    - e00*z*z - e11*z*z - e22*z*z
    + e00*e11*z + e00*e22*z + e11*e22*z - e02*e20*z - e10*e01*z - e12*e21*z
    - e00*e11*e22 - e01*e12*e20 - e10*e21*e02 + e02*e11*e20 + e10*e01*e22 + e12*e21*e00 = 0

*/

  }

  function e()
  {
    return self.scalarGet([ ... arguments ]);
  }

}

//

function _Eigen( o )
{

  _.map.assertHasAll( o, _Eigen.defaults );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.matrixIs( o.m ) );

  let proto = this;
  let ncol = o.m.ncol;

  o.isReal = true;

  let polynomn = o.m.characteristicPolynomial();
  o.eigenVals = polynomnRoots( polynomn, o.eigenVals );

  if( o.eigenVals.length && isNaN( o.eigenVals[ 0 ] ) )
  o.isReal = false;

  if( !o.isReal )
  return o;

  if( o.eigenSpace === null )
  o.eigenSpace = proto.MakeZero( [ ncol, ncol ] );
  if( o.eigenSpace )
  eigenSpaceCalc();

  return o;

  /* */

  function eigenSpaceCalc()
  {
    let m2 = o.m.clone();
    let diag = m2.diagonalGet();
    let okernel = 0;

    for( let i = 0 ; i < o.eigenVals.length ; )
    {
      if( i > 0 && Math.abs( o.eigenVals[ i-1 ] - o.eigenVals[ i ] ) < proto.accuracy )
      {
        i+= 1;
        continue;
      }
      diag.sub( o.eigenVals[ i ] );
      let o2 = { m : m2, kernel : o.eigenSpace, okernel };
      proto.SolveGeneral( o2 );
      i += o2.okernel - okernel;
      okernel = o2.okernel;
      m2.copy( o.m ); /* xxx : write test to check no buffer reallocation is done */
    }

    if( okernel < ncol && o.generalizating )
    {

      if( Config.debug )
      o.eigenVals.forEach( ( val ) => _.assert( Math.abs( val - o.eigenVals[ 0 ] ) <= proto.accuracy ), 'not expected' );

      let y = o.eigenSpace.colGet( 0 );
      let o2 = { m : m2, y };
      diag.sub( o.eigenVals[ 0 ] );
      proto.SolveGeneral( o2 );
      o.eigenSpace.colSet( okernel, o2.x.toLong() );
      okernel += 1;

      for( let i = okernel ; i < ncol ; i++ )
      {
        y = o2.x;
        o2 = { m : m2, y };
        m2.copy( o.m );
        diag.sub( o.eigenVals[ 0 ] );
        proto.SolveGeneral( o2 );
        o.eigenSpace.colSet( okernel, o2.x.toLong() );
        okernel += 1;
      }

    }

    _.assert( okernel <= ncol );

  }

}

_Eigen.defaults =
{
  m : null,
  eigenVals : null,
  eigenSpace : null,
  generalizating : 1,
}

//

function eigenVals( o )
{
  let self = this;
  o = o || Object.create( null );

  _.routine.options_( eigenVals, o );

  o.m = self;
  o.eigenSpace = false;

  self._Eigen( o );

  return o.eigenVals;
}

eigenVals.defaults =
{
  ... _.mapBut_( null, _Eigen.defaults, [ 'm', 'eigenSpace' ] ),
}

//

function eigenVectors( o )
{
  let self = this;
  o = o || Object.create( null );

  _.routine.options_( eigenVectors, o );

  o.m = self;

  self._Eigen( o );

  return o.eigenSpace;
}

eigenVectors.defaults =
{
  ... _.mapBut_( null, _Eigen.defaults, [ 'm' ] ),
}

// --
// relations
// --

let Statics =
{

  _Eigen,

}

// --
// declare
// --

let Extension =
{

  characteristicPolynomial,
  charpoly : characteristicPolynomial,
  _Eigen,
  eigenVals,
  eigenVectors,

  //

  Statics,

}

_.classExtend( Self, Extension );

} )();
