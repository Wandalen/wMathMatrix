(function _NamespaceMatrix_s_() {

'use strict';

const _ = _global_.wTools;
_.matrix = _.matrix || Object.create( null );

// --
// basic
// --

function dimsExportString( o )
{
  let self = this;

  if( !_.mapIs( arguments[ 0 ] ) )
  o = { src : arguments[ 0 ] }

  o = _.routine.options_( dimsExportString, o );

  if( !_.matrix.like( o.src ) )
  return '{- not matrix-like! -}'

  let dims = _.matrix.dimsOf( o.src );

  let result = _.math.dimsExportString( dims );

  return result;
}

dimsExportString.defaults =
{
  src : null,
  dst : '',
}

//

function dimsOf( src )
{
  if( _.matrixIs( src ) )
  return src.dims;
  if( _.numberIs( src ) )
  return [ 1, 1 ];
  let result = [ 0, 1 ];
  _.assert( !!src && src.length >= 0 );
  result[ 0 ] = src.length;
  return result;
}

// --
// declare
// --

let Extension =
{

  dimsExportString,
  dimsOf,

}

_.props.supplement( _.matrix, Extension );

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
