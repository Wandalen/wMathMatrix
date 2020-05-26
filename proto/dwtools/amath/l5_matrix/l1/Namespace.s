(function _Scalar_s_() {

'use strict';

let _ = _global_.wTools;

// --
// basic
// --

function matrixIs( src )
{
  if( !src )
  return false;
  if( !_.Matrix )
  return false;
  if( src instanceof _.Matrix )
  return true;
  return false;
}

//

function constructorIsMatrix( src )
{
  return _.Matrix ? src === _.Matrix : false;
}

// --
// declare
// --

let Extension =
{
  matrixIs,
  constructorIsMatrix,
}

_.mapSupplement( _, Extension );
_.mapSupplement( _.math, Extension );

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
