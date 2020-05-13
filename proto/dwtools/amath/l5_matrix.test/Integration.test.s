( function _Integration_test_s_() {

'use strict';

//

if( typeof module !== 'undefined' )
{

  let _ = require( 'wTools' );

  _.include( 'wTesting' );
  _.include( 'wFiles' );
  _.include( 'wappbasic' );

  require( '../l5_matrix/module/full/Include.s' );

}

//

let _ = _global_.wTools;
let fileProvider = _testerGlobal_.wTools.fileProvider;
let path = fileProvider.path;

// --
// context
//

function onSuiteBegin()
{
  let context = this;
  context.assetsOriginalSuitePath = path.join( __dirname, '../../../../sample'  );
}

//

function onSuiteEnd()
{
  let context = this;
}

//

function assetFor( test )
{
  let context = this;
  let a = { originalAssetPath : false, routinePath : context.assetsOriginalSuitePath };
  return test.assetFor( a );
}

// --
// test
// --

function sample( test )
{
  let context = this;
  let a = context.assetFor( test );
  let filter = { filePath : a.abs( './**/*.(s|js)' ), basePath : a.abs( '.' ) };
  let found = a.fileProvider.filesFind
  ({
    filter,
    mode : 'distinct',
    mandatory : 0,
  });

  /* */

  let startTime;

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
        console.log( _.time.spent( startTime ) );
        test.description = 'nonzero exit code';
        test.notIdentical( got.exitCode, 0 );
        return null;
      })
    }
    else
    {
      a.appStartNonThrowing({ execPath : found[ i ].relative })
      .then( ( got ) =>
      {
        console.log( _.time.spent( startTime ) );
        test.description = 'good exit code';
        test.identical( got.exitCode, 0 );
        if( got.exitCode )
        return null;
        test.description = 'have no uncaught errors';
        test.identical( _.strCount( got.output, 'ncaught' ), 0 );
        test.identical( _.strCount( got.output, 'rror' ), 0 );
        test.description = 'have some output';
        test.ge( got.output.split( '\n' ).length, 2 )
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

  onSuiteBegin,
  onSuiteEnd,

  context :
  {
    assetFor,
    suiteTempPath : null,
    assetsOriginalSuitePath : null,
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

