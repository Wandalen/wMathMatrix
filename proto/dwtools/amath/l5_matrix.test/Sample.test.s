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
  let a = self.assetFor( test );
  a.routinePath = a.path.join( a.routinePath, '..' );
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

  /* - */

  a.ready

  .then( () =>
  {
    test.case = 'Determinant.js';
    return null;
  })

  a.appStart({ execPath : 'Determinant.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    test.identical( _.strCount( got.output, 'determinant of matrix :' ), 1 );
    test.identical( _.strCount( got.output, '24' ), 1 );

    return null;
  })

  /* - */

  a.ready

  .then( () =>
  {
    test.case = 'Experiment.js';
    return null;
  })

  a.appStart({ execPath : 'Experiment.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );

    return null;
  })

  /* - */

  a.ready

  .then( () =>
  {
    test.case = 'Sample.js';
    return null;
  })

  a.appStart({ execPath : 'Sample.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    test.identical( _.strCount( got.output, 'got' ), 1 );
    test.identical( _.strCount( got.output, 'expected' ), 1 );
    test.identical( _.strCount( got.output, '+14 +23 +18' ), 2 );
    test.identical( _.strCount( got.output, '+23 +41 +30' ), 2 );
    test.identical( _.strCount( got.output, '+18 +30 +36' ), 2 );

    return null;
  })

  /* - */

  a.ready

  .then( () =>
  {
    test.case = 'Svd.js';
    return null;
  })

  a.appStart({ execPath : 'Svd.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    test.identical( _.strCount( got.output, 'Final U' ), 1 );
    test.identical( _.strCount( got.output, 'Final S' ), 1 );
    test.identical( _.strCount( got.output, 'Final V' ), 1 );

    return null;
  })

  return a.ready;
}

// --
// declare
// --

var Self =
{

  name : 'Tools.Math.Sample',
  silencing : 1,
  enabled : 1,
  // routineTimeOut : 60000,

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
