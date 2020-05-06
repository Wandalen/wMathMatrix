( function _Integration_test_s_() {

'use strict';

/*
*/

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../dwtools/Tools.s' );

  _.include( 'wTesting' );
  _.include( 'wFiles' );

  require( '../l5_matrix/module/full/Include.s' );

}

//

var _ = _global_.wTools.withDefaultLong.Fx;

// --
// test
// --

function sample( test )
{
  let self = this;
  let a = test.assetFor( self.suiteTempPath );
  let filter = { filePath : a.abs( './**/*.(s|js)' ) };
  let found = a.fileProvider.filesFind
  ({
    filter,
    mode : 'distinct',
    mandatory : 0,
  });
  debugger;

  /* */

  let startTime, spentTime;

  for( let i = 0 ; i < found.length ; i++ )
  {
    if( _.longHas( found[ i ].exts, 'browser' ) )
    continue;

    a.ready
    .then( () =>
    {
      test.case = found[ i ].relative;
      startTime = _.time.now();
      return null;
    })

    if( _.longHas( found[ i ].exts, 'throwing' ) )
    {
      a.appStartNonThrowing({ execPath : found[ i ].relative })
      .then( ( got ) =>
      {
        spentTime = _.time.spent( startTime );
        console.log( spentTime );

        test.notIdentical( got.exitCode, 0 );
        test.ge( _.strCount( got.output, 'ncaught' ), 1 );
        test.ge( _.strCount( got.output, 'rror' ), 1 );
        return null;
      })
    }
    else
    {
      a.appStart({ execPath : found[ i ].relative })
      .then( ( got ) =>
      {
        spentTime = _.time.spent( startTime );
        console.log( spentTime );

        test.identical( got.exitCode, 0 );
        test.identical( _.strCount( got.output, 'ncaught' ), 0 );
        test.identical( _.strCount( got.output, 'rror' ), 0 );
        return null;
      })
    }
  }

  /* */

  return a.ready;
}

sample.timeOut = 60000;

// --
// declare
// --

var Self =
{

  name : 'Tools.Math.Integration',
  silencing : 1,
  enabled : 1,

  context :
  {
    suiteTempPath : _.path.join( __dirname, '../../../../' ),
    assetsOriginalSuitePath : _.path.join( __dirname, '../../../../' ),
    appJsPath : null,
  },

  tests :
  {
    sample,
  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_global_.wTester.test( Self.name );

})();
