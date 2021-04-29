(function _RoutinesFromVector_s_() {

'use strict';

//

const _ = _global_.wTools;
// let vector = _.vectorAdapter;
let operations = _.vectorAdapter.operations;

let _abs = Math.abs;
const _min = Math.min;
const _max = Math.max;
let _arraySlice = Array.prototype.slice;
let _sqrt = Math.sqrt;
const _sqr = _.math.sqr;

const Parent = null;
const Self = _.Matrix;
let Proto = Object.create( null );
let Statics = Proto.Statics = Object.create( null );

_.assert( _.routineIs( Self ), 'wMatrix is not defined, please include wMatrix.s first' );

/*
map
filter
reduce
zip
*/

//

function declareElementsZipRoutine( routine, rname )
{

  if( routine.operation.takingVectors[ 1 ] < 2 )
  return;

  if( routine.operation.takingArguments[ 0 ] > routine.operation.takingVectors[ 0 ] )
  return;

  if( routine.operation.takingArguments[ 0 ] === 1 )
  return;

  let name = rname + 'Zip';
  Proto[ name ] = function()
  {
    let self = this;

    _.assert( _.object.isBasic( self.vad ) );
    let routine2 = _.routineJoin( self.vad, routine );

    let args = _.longSlice( arguments );
    args.unshift( routine2 );

    _.assert( 0, 'not tested' );

    self.elementsZip.apply( self, args );

    return self;
  }

}

//

function declareColWiseCollectingRoutine( routine, rname )
{

  let op = routine.operation;
  let returningNumber = op.returningNumber;
  let name = rname + 'ColWise';
  let collecting = !!op.reducing;

  _.assert( _.boolIs( returningNumber ) );
  _.assert( !Proto[ name ] );

  Proto[ name ] = function reduceRowWise()
  {
    let self = this;

    _.assert( _.object.isBasic( self.vad ) );
    // let routine2 = _.routineJoin( self.vad, routine );
    let result = self._lineEachCollecting
    ({
      args : arguments,
      returningNumber : returningNumber,
      dim : 0,
      onEach : ( ... args ) => routine.apply( self.vad, args ),
      collecting,
    });

    return result;
  }

}

//

function declareRowWiseCollectingRoutine( routine , rname )
{

  let op = routine.operation;
  let returningNumber = op.returningNumber;
  let name = rname + 'RowWise';
  let collecting = op.reducing;

  _.assert( _.boolIs( returningNumber ) );
  _.assert( !Proto[ name ] );

  // if( rname === 'mul' )
  // debugger;
  // if( rname === 'reduceToMean' )
  // debugger;
  // if( rname === 'distributionRangeSummaryValue' )
  // debugger;

  Proto[ name ] = function reduceRowWise()
  {
    let self = this;

    _.assert( _.object.isBasic( self.vad ) );
    // let routine2 = _.routineJoin( self.vectorAdapter, routine );
    let result = self._lineEachCollecting
    ({
      args : arguments,
      returningNumber : returningNumber,
      dim : 1,
      onEach : ( ... args ) => routine.apply( self.vad, args ),
      collecting,
    });

    return result;
  }

}

//

function declareScalarWiseReducingRoutine( routine , rname )
{
  let op = routine.operation;

  _.assert( arguments.length === 2 )

  // if( rname === 'allFinite' )
  // debugger;

  if( !op.reducing )
  return;

  // if( !op.takingVectorsOnly )
  // return;

  if( op.conditional )
  return;

  if( !op.reducing )
  return;

  if( !op.onScalar )
  return;

  // if( op.kind !== 'scalarWiseReducing' )
  // return;

  // if( op.generator.name !== '__operationReduceToScalar_functor' )
  // {
    if( op.returningBoolean )
    return;

  //   debugger;
  //   _.assert( 0 );
  //   return;
  // }

  _.assert( !op.returningBoolean );

  if( _.long.identical( op.takingArguments, [ 1, 1 ] ) )
  return;

  // debugger;

  let name = rname + 'ScalarWise';
  let handleScalar = op.onScalar[ 0 ];
  let onScalarsBegin0 = op.onScalarsBegin[ 0 ];
  let onScalarsEnd0 = op.onScalarsEnd[ 0 ];
  let onVectorsBegin0 = op.onVectorsBegin[ 0 ];
  let onVectorsEnd0 = op.onVectorsEnd[ 0 ];

  function onBegin( o )
  {
    let op = onVectorsBegin0( o );
    onScalarsBegin0( op );
    return op;
  }

  function onEnd( op )
  {
    onScalarsEnd0( op );
    let result = onVectorsEnd0( op );
    return result;
  }

  _.assert( _.object.isBasic( handleScalar.defaults ) );
  _.assert( _.routineIs( onScalarsBegin0 ) );
  _.assert( _.routineIs( onScalarsEnd0 ) );
  _.assert( _.routineIs( onVectorsBegin0 ) );
  _.assert( _.routineIs( onVectorsEnd0 ) );
  _.assert( !Proto[ name ] );

  Proto[ name ] = function scalarWise()
  {
    let self = this;
    _.assert( arguments.length === 0, 'Expects no arguments' );
    let result = self.scalarWiseReduceWithScalarHandler( onBegin, handleScalar, onEnd );
    return result;
  }

}

//

function declareScalarWiseHomogeneousWithScalarRoutines( routine, rname )
{
  let op = routine.operation;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( op.reducing )
  return;
  if( !op.homogeneous )
  return;
  if( op.special )
  return;

  if( op.takingArguments[ 0 ] !== 2 || op.takingArguments[ 1 ] !== 2 )
  return;

  let onScalar = op.onScalar[ 1 ];
  let name = rname;

  _.assert( !Proto[ name ] );
  _.assert( _.object.isBasic( op ) );
  _.assert( _.routineIs( onScalar ) );

  /* */

  function handleScalar2( op )
  {
    let self = this;

    op.srcElement = op.args[ 0 ];
    let val = onScalar( op );
    _.assert( val === undefined );
    _.assert( _.numberIs( op.dstElement ) );
    _.assert( _.numberIs( op.srcElement ) );
    self.scalarSet( op.key, op.dstElement );

  }

  handleScalar2.have = { onScalar };

  /* */

  Proto[ name ] = function scalarWise()
  {
    let self = this;

    _.assert( arguments.length === 1, 'Expects single argument' );
    _.assert( _.numberIs( arguments[ 0 ] ) );

    self.scalarWiseWithAssign( handleScalar2, arguments );

    return self;
  }

}

//

function declareScalarWiseHomogeneousRoutine( routine, name )
{
  let dop = routine.operation;

  if( !dop.scalarWise )
  return;

  if( !dop.homogeneous )
  return;

  if( !dop.input )
  return;

  if( dop.kind === 'reducing' )
  return;

  if( !dop.onScalar )
  return;

  // if( _.long.identical( dop.input, [ 'vw|s', 's' ] ) )
  // return;

  if( dop.input === 'vw|s s' )
  {
    debugger;
    return;
  }

  let routineName = name + 'ScalarWise';
  let onScalar0 = dop.onScalar[ 0 ];
  let onScalar1 = dop.onScalar[ 1 ];
  let onVectorsBegin0 = dop.onVectorsBegin[ 0 ];
  let onVectorsEnd0 = dop.onVectorsEnd[ 0 ];
  let onContinue0 = dop.onContinue[ 0 ];

  _.assert( _.routineIs( onScalar0 ) );
  _.assert( _.routineIs( onScalar1 ) );
  _.assert( _.object.isBasic( onScalar0.defaults ) );
  _.assert( !onScalar1.defaults );
  _.assert( !Statics[ routineName ] );
  _.assert( !Proto[ routineName ] );

  function onVectorsBegin( o )
  {
    let op = onVectorsBegin0( o );
    return op;
  }

  function handleScalar( o )
  {
    let r = onScalar1.call( this, o );
    _.assert( r === undefined );
  }

  function onVectorsEnd( o )
  {
    o.result = o.dstContainer;
    if( onVectorsEnd0 )
    onVectorsEnd0( o );
    return o.result;
  }

  handleScalar.defaults = onScalar0.defaults;

  /* */

  if( dop.takingArguments[ 0 ] === 1 )
  Proto[ routineName ] = Statics[ routineName ] = function ScalarWiseHomogeneous()
  {
    let self = this;
    let dst, args;

    if( _.instanceIs( this ) )
    {
      dst = this;
      args = _.longSlice( arguments, 0 );
      args.unshift( dst );
    }
    else
    {
      dst = arguments[ 0 ];
      args = _.longSlice( arguments, 0 );
    }

    let result = self.Self.ScalarWiseHomogeneous
    ({
      onContinue : onContinue0,
      onVectorsBegin,
      onVectorsEnd,
      onScalar : handleScalar,
      args,
      reducing : dop.reducing,
      usingDstAsSrc : dop.usingDstAsSrc,
      usingExtraSrcs : dop.usingExtraSrcs,
    });

    return result;
  }
  else if( dop.takingArguments[ 0 ] > 1 )
  Statics[ routineName ] = Statics[ routineName ] = function ScalarWiseHomogeneous()
  {
    let self = this;
    let dst, args;

    if( _.instanceIs( this ) )
    {
      dst = this;
      args = _.longSlice( arguments, 0 );
      args.unshift( dst );
    }
    else
    {
      dst = arguments[ 0 ];
      args = _.longSlice( arguments, 0 );
    }

    let result = self.Self.ScalarWiseHomogeneous
    ({
      onVectorsBegin,
      onVectorsEnd,
      onScalar : handleScalar,
      args,
      reducing : dop.reducing,
      usingDstAsSrc : dop.usingDstAsSrc,
      usingExtraSrcs : dop.usingExtraSrcs,
    });

    // _.assert( arguments.length === 2, 'Expects exactly two arguments' );
    // _.assert( _.arrayIs( srcs ) );
    // let result = self.Self.scalarWiseHomogeneousZip
    // ({
    //   onScalarsBegin : onVectorsBegin,
    //   onScalarsEnd : onVectorsEnd,
    //   onScalar : handleScalar,
    //   dst,
    //   srcs,
    // });

    return result;
  }
  else _.assert( 0 );

}

// //
//
// function declareScalarWiseHomogeneousRoutines()
// {
//
//   for( let op in operations.scalarWiseHomogeneous )
//   declareScalarWiseHomogeneousRoutine( operations.scalarWiseHomogeneous[ op ], op );
//
//   _.assert( Statics.addScalarWise );
//   _.assert( Statics.allFiniteScalarWise );
//
// }

// --
// aliases
// --

let Aliases =
{
  allFiniteScalarWise : 'allFinite',
  anyNanScalarWise : 'anyNan',
  allIntScalarWise : 'allInt',
  allZeroScalarWise : 'allZero',
}

function declareAliases()
{

  for( let name1 in Aliases )
  {
    let name2 = Aliases[ name1 ];
    _.assert( !!Proto[ name1 ] );
    _.assert( !Proto[ name2 ] );
    Proto[ name2 ] = Proto[ name1 ];
  }

}

// --
//
// --

let routines = _.vectorAdapter._routinesMathematical;
let r;
for( r in routines )
{
  let routine = routines[ r ];

  _.assert( _.routineIs( routine ) );

  declareElementsZipRoutine( routine, r );
  declareColWiseCollectingRoutine( routine, r );
  declareRowWiseCollectingRoutine( routine, r );
  declareScalarWiseReducingRoutine( routine, r );
  declareScalarWiseHomogeneousWithScalarRoutines( routine, r );
  declareScalarWiseHomogeneousRoutine( routine, r );

}

// declareScalarWiseHomogeneousRoutines();

declareAliases();

_.classExtend( Self, Proto );

_.assert( _.routineIs( Statics.addScalarWise ) );
_.assert( _.routineIs( Self.prototype.allFiniteScalarWise ) );

_.assert( _.routineIs( Self.prototype.reduceToMaxValueColWise ) );
_.assert( _.routineIs( Self.prototype.reduceToMaxValueRowWise ) );
_.assert( _.routineIs( Self.prototype.addScalarWise ) );
// _.assert( _.routineIs( Self.prototype.addScalar ) );
_.assert( _.routineIs( Self.addScalarWise ) );

_.assert( !Self.prototype.isValidZip );
_.assert( !Self.prototype.anyNanZip );
_.assert( !Self.prototype.allFiniteZip );

_.assert( !Self.prototype.isValidScalarWise );
_.assert( _.routineIs( Self.prototype.anyNanScalarWise ) );
_.assert( _.routineIs( Self.prototype.allFiniteScalarWise ) );

_.assert( !Self.prototype.isValid );
_.assert( _.routineIs( Self.prototype.anyNan ) );
_.assert( _.routineIs( Self.prototype.allFinite ) );

})();
