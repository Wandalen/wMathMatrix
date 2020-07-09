(function _Basic_s_() {

'use strict';

/* wMatrix */

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../../wtools/Tools.s' );

  _.include( 'wMathScalar' );
  _.include( 'wMathVector' );
  _.include( 'wCopyable' );
  _.include( 'wEntityBasic' );

}

if( typeof module !== 'undefined' )
{
  module[ 'exports' ] = _global_.wTools;
}


})();
