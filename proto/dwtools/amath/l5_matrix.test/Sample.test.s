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

  /* */

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
    return null;
  })

  /* */

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

  /* */

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
    return null;
  })

  /* */

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
    return null;
  })

  return a.ready;
}

//

function matrixComparison( test )
{
  let self = this;
  let a = self.assetFor( test );

  /* */

  a.ready
  .then( () =>
  {
    test.case = '1_CompareIdenticalMatrices.js';
    return null;
  })

  a.appStart({ execPath : '1_CompareIdenticalMatrices.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready

  .then( () =>
  {
    test.case = '2_ComparisonWithStridesAndOffset.js';
    return null;
  })

  a.appStart({ execPath : '2_ComparisonWithStridesAndOffset.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready

  .then( () =>
  {
    test.case = '3_DifferentBuffers.js';
    return null;
  })

  a.appStart({ execPath : '3_DifferentBuffers.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready

  .then( () =>
  {
    test.case = '4_MatrixAndVector.js';
    return null;
  })

  a.appStart({ execPath : '4_MatrixAndVector.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready

  .then( () =>
  {
    test.case = '5_EquivalentWithAccuracy.js';
    return null;
  })

  a.appStart({ execPath : '5_EquivalentWithAccuracy.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
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
  routineTimeOut : 15000,

  context :
  {
    assetFor,
  },

  tests :
  {

    sample,
    matrixComparison,

  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_global_.wTester.test( Self.name );

})();
