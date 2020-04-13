(function _Mid_s_() {

'use strict';

/* wMatrix */

if( typeof module !== 'undefined' )
{
  require( './Basic.s' );
}

if( typeof module !== 'undefined' )
{

  require( '../l1/Basic.s' );

  require( '../l3/RoutinesFromVector.s' );

  require( '../l3_methods/Element.s' );
  require( '../l3_methods/Iterator.s' );

  require( '../l5_methods/Advanced.s' );
  require( '../l5_methods/Checker.s' );
  require( '../l5_methods/Element.s' );
  require( '../l5_methods/Iterator.s' );
  require( '../l5_methods/Maker.s' );
  require( '../l5_methods/Operation.s' );
  require( '../l5_methods/Pivoting.s' );
  require( '../l5_methods/Solver.s' );
  require( '../l5_methods/Transformation.s' );
  require( '../l5_methods/Util.s' );

  require( '../l7_methods/Svd.s' );

}

if( typeof module !== 'undefined' )
{
  module[ 'exports' ] = _global_.wTools;
}

})();