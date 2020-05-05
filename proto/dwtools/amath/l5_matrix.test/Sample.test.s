( function _Sample_test_s_() {

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
  let filter = { filePath : _.fileProvider.path.join( __dirname, '../../../../sample/**/*.(s|js)' ) };
  let found = _.fileProvider.filesFind
  ({
    filter,
    mode : 'distinct',
    mandatory : 0,
  });

  let ready = _.Consequence().take( null );
  let sampleStart = _.process.starter
  ({
    currentPath : _.fileProvider.path.join( __dirname, '../../../../sample' ),
    outputCollecting : 1,
    throwingExitCode : 1,
    outputGraying : 1,
    ready,
    mode : 'fork',
  })

  /* */

  for( let i = 0 ; i < found.length ; i++ )
  {
    ready
    .then( () =>
    {
      test.case = found[ i ].relative;
      return null;
    })

    sampleStart({ execPath : found[ i ].relative })
    .then( ( got ) =>
    {
      test.identical( got.exitCode, 0 );
      test.identical( _.strCount( got.output, 'ncaught' ), 0 );
      test.identical( _.strCount( got.output, 'rror' ), 0 );
      return null;
    })
  }

  /* */

  return ready;
}

sample.timeOut = 60000;

// --
// declare
// --

var Self =
{

  name : 'Tools.Math.Sample',
  silencing : 1,
  enabled : 1,

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
