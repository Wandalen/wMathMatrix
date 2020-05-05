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

  /* */

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

  /* */

  return a.ready;
}

//

function matrixCreation( test )
{
  let self = this;
  let a = self.assetFor( test );

  /* */

  a.ready
  .then( () =>
  {
    test.case = '1_Make.js';
    return null;
  })

  a.appStart({ execPath : '1_Make.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '2_ExplicitConstructor.js';
    return null;
  })

  a.appStart({ execPath : '2_ExplicitConstructor.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '3_MakeSquareFromLong.js';
    return null;
  })

  a.appStart({ execPath : '3_MakeSquareFromLong.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '4_MakeSquareFromNumber.js';
    return null;
  })

  a.appStart({ execPath : '4_MakeSquareFromNumber.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '5_MakeZeroFromDims.js';
    return null;
  })

  a.appStart({ execPath : '5_MakeZeroFromDims.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '6_MakeZeroFromNumber.js';
    return null;
  })

  a.appStart({ execPath : '6_MakeZeroFromNumber.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '7_MakeIdentityFromDims.js';
    return null;
  })

  a.appStart({ execPath : '7_MakeIdentityFromDims.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '8_MakeIdentityFromNumber.js';
    return null;
  })

  a.appStart({ execPath : '8_MakeIdentityFromNumber.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '9_MakeDiagonal.js';
    return null;
  })

  a.appStart({ execPath : '9_MakeDiagonal.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '10_MakeColFromLong.js';
    return null;
  })

  a.appStart({ execPath : '10_MakeColFromLong.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '11_MakeColFromNumber.js';
    return null;
  })

  a.appStart({ execPath : '11_MakeColFromNumber.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '12_MakeRowFromLong.js';
    return null;
  })

  a.appStart({ execPath : '12_MakeRowFromLong.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '13_MakeRowFromNumber.js';
    return null;
  })

  a.appStart({ execPath : '13_MakeRowFromNumber.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '14_FromVector.js';
    return null;
  })

  a.appStart({ execPath : '14_FromVector.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '15_FromScalar.js';
    return null;
  })

  a.appStart({ execPath : '15_FromScalar.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '16_FromTransformations.js';
    return null;
  })

  a.appStart({ execPath : '16_FromTransformations.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '17_InfinityMatrix.js';
    return null;
  })

  a.appStart({ execPath : '17_InfinityMatrix.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '18_3dMatrix.js';
    return null;
  })

  a.appStart({ execPath : '18_3dMatrix.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  return a.ready;
}

//

function matrixElements( test )
{
  let self = this;
  let a = self.assetFor( test );

  /* */

  a.ready
  .then( () =>
  {
    test.case = '1_RowGet.js';
    return null;
  })

  a.appStart({ execPath : '1_RowGet.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '2_RowSet.js';
    return null;
  })

  a.appStart({ execPath : '2_RowSet.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '3_ColGet.js';
    return null;
  })

  a.appStart({ execPath : '3_ColGet.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '4_ColSet.js';
    return null;
  })

  a.appStart({ execPath : '4_ColSet.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '5_ScalarGetSet.js';
    return null;
  })

  a.appStart({ execPath : '5_ScalarGetSet.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '6_EGet.js';
    return null;
  })

  a.appStart({ execPath : '6_EGet.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '7_ESet.js';
    return null;
  })

  a.appStart({ execPath : '7_ESet.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '8_DiagonalGet.js';
    return null;
  })

  a.appStart({ execPath : '8_DiagonalGet.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '9_DiagonalSet.js';
    return null;
  })

  a.appStart({ execPath : '9_DiagonalSet.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

  a.ready
  .then( () =>
  {
    test.case = '10_Submatrix.js';
    return null;
  })

  a.appStart({ execPath : '10_Submatrix.js' })
  .then( ( got ) =>
  {
    test.identical( got.exitCode, 0 );
    return null;
  })

  /* */

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
  routineTimeOut : 20000,

  context :
  {
    assetFor,
  },

  tests :
  {

    sample,
    matrixComparison,
    matrixCreation,
    matrixElements,

  },

}

//

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_global_.wTester.test( Self.name );

})();
