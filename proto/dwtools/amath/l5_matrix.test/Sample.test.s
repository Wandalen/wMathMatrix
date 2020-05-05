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
// context
// --

function assetFor( test )
{
  let self = this;
  let a = Object.create( null );

  a.test = test;
  a.originalSamplePath = _.path.join( __dirname, '../../../../sample' );
  a.routinePath = _.path.join( a.originalSamplePath, test.name );
  a.fileProvider = _.fileProvider;
  a.path = _.fileProvider.path;
  a.ready = _.Consequence().take( null );

  a.appStart = _.process.starter
  ({
    execPath : self.appJsPath || null,
    currentPath : a.routinePath,
    outputCollecting : 1,
    throwingExitCode : 1,
    outputGraying : 1,
    ready : a.ready,
    mode : 'fork',
  })

  return a;
}

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
      debugger;
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

  context :
  {
    assetFor,
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
