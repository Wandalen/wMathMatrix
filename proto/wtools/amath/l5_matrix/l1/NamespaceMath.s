(function _NamesapceMath_s_() {

'use strict';

const _ = _global_.wTools;
_.matrix = _.matrix || Object.create( null );

// --
// basic
// --

function matrixLike( src ) /* qqq : cover please */
{
  if( _.numberIs( src ) )
  return true;
  if( !src )
  return false;
  if( _.matrixIs( src ) )
  return true;
  if( _.vectorIs( src ) )
  return true;
  return false;
}

//

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

//

function dimsExportString( o )
{

  if( _.longIs( arguments[ 0 ] ) )
  o = { dims : arguments[ 0 ] };

  o = _.routine.options_( dimsExportString, o );
  _.assert( _.longIs( o.dims ) );

  o.dst += o.dims[ 0 ];

  for( let i = 1 ; i < o.dims.length ; i++ )
  o.dst += `x${o.dims[ i ]}`;

  return o.dst;
}

dimsExportString.defaults =
{
  dst : '',
  dims : null,
}

// --
// declare
// --

let ToolsExtension =
{
  matrixLike,
  matrixIs,
  constructorIsMatrix,
}

_.props.supplement( _, ToolsExtension );

//

let MathExtension =
{
  matrixLike,
  matrixIs,
  constructorIsMatrix,
  dimsExportString,
}

_.props.supplement( _.math, MathExtension );

//

let MatrixExtension =
{
  like : matrixLike,
  is : matrixIs,
  isConstructor : constructorIsMatrix,
}

_.props.supplement( _.matrix, MatrixExtension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
