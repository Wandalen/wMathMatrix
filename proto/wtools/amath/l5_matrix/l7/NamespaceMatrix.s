(function _NamespaceMatrix_s_() {

'use strict';

const _ = _global_.wTools;

// --
//
// --

function fromLibrary( o )
{

  if( !_.mapIs( o ) )
  o = { name : arguments[ 0 ] };
  _.routine.options_( fromLibrary, o );

  let nameToMatrix =
  {
    '2x2.rank1.bad.accuracy' : m2x2Rank1BadAccuracy,
  }

  let result = nameToMatrix[ o.name ];
  _.assert( !!result, `Unknown ${o.name}` );

  return result;

  function m2x2Rank1BadAccuracy()
  {
    return _.Matrix.MakeSquare([ 2,2 ]).copy
    ([
      +18, -6,
      +45, -15,
    ]);
  }

}

fromLibrary.defaults =
{
  name : null,
}

// --
// declare
// --

let Extension =
{

  fromLibrary,

}

_.props.supplement( _.matrix, Extension );

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
