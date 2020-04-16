(function _Iterator_s_() {

'use strict';

let _ = _global_.wTools;
let abs = Math.abs;
let min = Math.min;
let max = Math.max;
let pow = Math.pow;
let pi = Math.PI;
let sin = Math.sin;
let cos = Math.cos;
let sqrt = Math.sqrt;
let sqr = _.math.sqr;
let longSlice = Array.prototype.slice;

let Parent = null;
let Self = _.Matrix;

// --
// advanced
// --

/**
 * Method atomWiseReduceWithFlatVector() applies the flat buffer of current matrix to the callback {-onVector-}.
 *
 * @example
 * var matrix = _.Matrix
 * ({
 *   buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
 *   dims : [ 2, 2 ],
 *   strides : [ 1, 2 ],
 * });
 * var got = matrix.atomWiseReduceWithFlatVector( ( e ) => e );
 * console.log( got.toStr() );
 * // log : 1.000, 2.000, 3.000, 4.000
 *
 * @param { Function } onVector - Callback that executes on flat buffer.
 * @returns { * } - Returns result of callback execution.
 * @method atomWiseReduceWithFlatVector
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If this.strideOfElement is not identical to this.scalarsPerElement.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function atomWiseReduceWithFlatVector( onVector )
{
  let self = this;
  let result;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( self.strideOfElement === self.scalarsPerElement );

  debugger;

  result = onVector( self.asVector() );

  return result;
}

//

/**
 * Method atomWiseReduceWithAtomHandler() executes the reducer callback {-onElement-} on each element of the current matrix.
 * Before iteration executes callback {-onBegin-} that prepare data, after iteration executes callback {-onEnd-} that normalize data.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   3, 4
 * ]);
 * var onBegin = function( o ){ return o };
 * var onElement = function( o ){ o.container.scalarSet( o.key, o.element + 1 ) };
 * var onEnd = function( o ){ o.result = o.container.toStr() };
 * var got = matrix.atomWiseReduceWithAtomHandler( onBegin, onElement, onEnd );
 * console.log( got );
 * // log :
 * // +2, +3,
 * // +4, +5
 *
 * @param { Function } onBegin - Callback that executes before iteration. It executes on options map with next fields : `args`, `container`, `filter`.
 * @param { Function } onElement - Callback that executes on options map for each element of the matrix.
 * To options map is added fields `key` and `element`, this fields change for each element.
 * @param { Function } onEnd - Callback that executes after iteration. It executes on options map with final values.
 * @returns { * } - Returns the value of field `result` in option map.
 * @method atomWiseReduceWithAtomHandler
 * @throws { Error } If arguments.length is not equal to three.
 * @throws { Error } If number of dimensions is greater then two.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function atomWiseReduceWithAtomHandler( onBegin, onScalar, onEnd )
{
  let self = this;

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  _.assert( self.dims.length === 2, 'not implemented' );

  let op = onBegin
  ({
    args : [ self ],
    container : self,
    filter : null,
  });

  for( let c = 0 ; c < self.scalarsPerCol ; c++ )
  for( let r = 0 ; r < self.scalarsPerRow ; r++ )
  {
    op.key = [ c, r ];
    op.element = self.scalarGet([ c, r ]);
    onScalar( op );
  }

  onEnd( op );

  return op.result;
}

//

/**
 * Method atomWiseWithAssign() executes the reducer callback {-onScalar-} on each element of the current matrix.
 * The call context of callback is current matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   3, 4
 * ]);
 * var args = [ 1, 2, 3, 4 ];
 * var onScalar = function( o )
 * {
 *   if( o.args[ o.key[ 0 ] + o.key[ 1 ] ] >= 3 )
 *   this.scalarSet( o.key, 1 );
 *   else
 *   this.scalarSet( o.key, 0 );
 * };
 * var got = matrix.atomWiseWithAssign( onScalar, args );
 * console.log( got );
 * // log :
 * // +0, +0,
 * // +0, +1
 *
 * @param { Function } onScalar - Callback that executes on options map for each element of the matrix.
 * Options map includes next fields : `key`, `args`, `dstContainer`, `dstElement`, `srcElement`.
 * @param { * } args - Arguments for callback, it is linked to field `args` of options map.
 * @returns { Matrix } - Returns original matrix.
 * @method atomWiseWithAssign
 * @throws { Error } If arguments.length is not equal to two.
 * @throws { Error } If number of dimensions is greater then two.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function atomWiseWithAssign( onScalar, args )
{
  let self = this;
  let result;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( self.dims.length === 2, 'not implemented' );

  let op = Object.create( null );
  op.key = -1;
  op.args = args;
  op.dstContainer = self;
  op.dstElement = null;
  op.srcElement = null;
  Object.preventExtensions( op );

  for( let c = 0 ; c < self.scalarsPerCol ; c++ )
  for( let r = 0 ; r < self.scalarsPerRow ; r++ )
  {
    op.key = [ c, r ];
    op.dstElement = self.scalarGet( op.key );
    onScalar.call( self, op );
  }

  return self;
}

//

/**
 * Method AtomWiseHomogeneous() executes the reducer callback {-onScalar-} on each element of the current matrix.
 * The call context of callback is current matrix.
 *
 * @param { MapLike } o - Options map.
 * @param { Function } o.onScalar - Callback that executes on each element of matrices.
 * @param { Function } o.onScalarsBegin - Callback that executes before iteration.
 * @param { Function } o.onScalarsBegin - Callback that executes after iteration.
 * @param { Function } o.onVectorsBegin - Callback that executes before iteration.
 * @param { Function } o.onVectorsEnd - Callback that executes before iteration.
 * @param { Function } o.onContinue - Callback that defines possibility of next iteration cycle.
 * @param { Long } o.args - A Long with matrices.
 * @param { Undefined|Nothing|Matrix } o.dst - Destination matrix.
 * @param { BoolLike } o.usingDstAsSrc - A flag that defines interpreting {-o.dst-} as source matrix.
 * @param { BoolLike } o.usingExtraSrcs - A flag that defines using of additional source matrices.
 * @param { BoolLike } o.reducing - A flag that result of routine.
 * If {-o.reducing-} is not defined, then returns {-o.dst-} container. Otherwise, the changed copy of src container is returned.
 * @returns { Matrix } - Returns matrix with homogeneous values.
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If routine calls by instance of Matrix.
 * @throws { Error } If options map {-o-} is not MapLike.
 * @throws { Error } If options map {-o-} has extra options.
 * @throws { Error } If {-o.args-} contains not instance of Matrix.
 * @throws { Error } If any of {-o.args-} element contains scalar, which is not a Number.
 * @throws { Error } If field dims in {-o.args-} elements is not an Array.
 * @throws { Error } If {-o.reducing-} and {-o.usingDstAsSrc-} are set to `true` at the same time.
 * @throws { Error } If {-o.dst-} neither is undefined, nor Nothing, nor a Matrix and at the same time {-o.reducing-} is set to `false`.
 * @throws { Error } If number of dimensions of {-o.dst-} is greater then two.
 * @throws { Error } If o.dst.dims are not equivalent to dimensions in {-o.args-} elements.
 * @static
 * @routine AtomWiseHomogeneous
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function AtomWiseHomogeneous( o )
{
  let proto = this;
  let newDst = false;

  _.routineOptions( AtomWiseHomogeneous, o );

  if( o.dst !== undefined && o.dst !== _.nothing )
  {
    if( o.usingDstAsSrc )
    o.args.unshift( o.dst );
  }
  else
  {
    o.dst = o.args[ 0 ]
  }

  /* preliminary analysis */

  let dims = null;
  for( let s = 0 ; s < o.args.length ; s++ )
  {
    let src = o.args[ s ];
    if( src instanceof Self )
    if( dims )
    _.assert( _.longIdentical( src.dims, dims ) )
    else
    dims = src.dims; /* Dmytro : if add assertion `_.assert( src.dims.length === 2 );`, then assertion for o.dims and fsrc won't be needed */
  }

  _.assert( _.arrayIs( dims ) );

  /* default handlers*/

  let op;
  if( !o.onVectorsBegin )
  o.onVectorsBegin = function handleVectorsBeing()
  {

    debugger;

    op = Object.create( null );
    op.key = -1;
    op.args = null;
    op.dstContainer = null;
    op.dstElement = null;
    op.srcContainerIndex = -1;
    op.srcContainer = null;
    op.srcElement = null;
    Object.preventExtensions( op );

    return op;
  }

  if( o.onScalarsBegin )
  debugger;
  if( !o.onScalarsBegin )
  o.onScalarsBegin = function handleAtomsBeing( op )
  {
  }

  /* dst */

  if( o.reducing )
  {
    _.assert( !o.usingDstAsSrc );
    o.srcs = o.args.slice( 0 );
    o.dst = null;
  }
  else if( _.nothingIs( o.dst ) )
  {
    o.srcs = o.args.slice( 1 );
    o.dst = o.args[ 0 ];
    /*o.dst = proto.MakeZero( dims );*/
    o.dst = o.args[ 0 ] = proto.Self.From( o.dst, dims );
  }
  else
  {
    o.srcs = o.args.slice( o.usingDstAsSrc ? 0 : 1 );
  }

  let fsrc = o.srcs[ 0 ];

  /* srcs allocation */

  for( let s = 0 ; s < o.srcs.length ; s++ )
  {
    let src = o.srcs[ s ] = proto.Self.From( o.srcs[ s ], dims );
    _.assert( src instanceof Self );
  }

  /* verification */

  _.assert( !proto.instanceIs() );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( o.dst instanceof Self || o.reducing );
  _.assert( !o.dst || o.dst.dims.length === 2, 'not implemented' );
  _.assert( !o.dst || _.longIdentical( o.dst.dims, dims ) );
  _.assert( fsrc instanceof Self ); /* Dmytro : it is extra assertion, see cycle above that checks each instance in o.srcs container */
  _.assert( fsrc.dims.length === 2, 'not implemented' ); /* Dmytro : it is extra assertion, the next assertion should check length because o.dst.dims.length is 2 */
  _.assert( _.longIdentical( fsrc.dims, dims ) );

  /* */

  op = o.onVectorsBegin.call( o.dst, op );

  op.args = o.args;
  op.dstContainer = o.dst;
  op.srcContainers = o.srcs;

  _.assert( op.srcContainers.length > 0 );

  /* */

  let brk = 0;
  for( let c = 0 ; c < fsrc.scalarsPerCol ; c++ )
  {

    for( let r = 0 ; r < fsrc.scalarsPerRow ; r++ )
    {

      op.key = [ c, r ];

      op.dstElement = fsrc.scalarGet( op.key );

      o.onScalarsBegin( op );

      _.assert( _.numberIs( op.dstElement ) );

      if( op.srcContainers.length === 1 )
      {
        op.srcElement = fsrc.scalarGet( op.key );
        o.onScalar.call( o.dst, op );

        if( o.onContinue )
        if( o.onContinue( o ) === false )
        brk = 1;

      }
      else for( let s = 1 ; s < op.srcContainers.length ; s++ )
      {
        op.srcElement = op.srcContainers[ s ].scalarGet( op.key );
        o.onScalar.call( o.dst, op );

        if( o.onContinue )
        if( o.onContinue( o ) === false )
        {
          brk = 1;
          break;
        }

      }

      if( !o.reducing )
      op.dstContainer.scalarSet( op.key, op.dstElement );

      if( o.onScalarsEnd )
      o.onScalarsEnd( op );

      if( brk )
      break;
    }

    if( brk )
    break;
  }

  return o.onVectorsEnd.call( o.dst, op );
}

AtomWiseHomogeneous.defaults =
{
  onScalar : null,
  onScalarsBegin : null,
  onScalarsEnd : null,
  onVectorsBegin : null,
  onVectorsEnd : null,
  onContinue : null,
  args : null,
  dst : _.nothing,
  usingDstAsSrc : 0,
  usingExtraSrcs : 0,
  reducing : 0,
}

// }

function atomWiseZip( onScalar, dst, srcs )
{
  let self = this;
  let o =
  {
    onScalar,
    dst,
    dstContainer : self,
    srcs,
  }
  return self.AtomWiseZip( o )
}

//

function AtomWiseZip( o )
{
  let result;

  _.routineOptions( AtomWiseZip, o )
  _.assert( _.definedIs( o.dst ) );
  _.assert( o.dstContainer instanceof Self );
  _.assert( _.definedIs( o.srcs ) );
  _.assert( _.routineIs( o.onScalar ) );

  let self = o.dstContainer;

  _.assert( self.dims.length === 2, 'not implemented' );

  let op = Object.create( null );
  op.key = -1;
  op.args = [ dst, srcs ];
  op.dstContainer = self;
  op.dstElement = null;
  op.srcContainers = srcs;
  op.srcElements = [];
  Object.preventExtensions( op );

  /* */

  for( let s = 0 ; s < srcs.length ; s++ )
  {
    let src = srcs[ s ];
    _.assert( srcs[ s ] instanceof Self );
  }

  /* */

  for( let c = 0 ; c < self.scalarsPerCol ; c++ )
  for( let r = 0 ; r < self.scalarsPerRow ; r++ )
  {
    op.key = [ c, r ];
    op.dstElement = self.scalarGet( op.key );

    for( let s = 0 ; s < srcs.length ; s++ )
    op.srcElements[ s ] = srcs[ s ].scalarGet( op.key );

    onScalar.call( self, op );
  }

  return self;
}

AtomWiseZip.defaults =
{
  onScalar : null,
  dst : null,
  dstContainer : null,
  srcs : null,
}

//

function elementEach( onElement )
{
  let self = this;
  let args = _.longSlice( arguments, 1 );

  debugger;
  _.assert( 0, 'not tested' );

  args.unshift( null );
  args.unshift( null );

  for( let i = 0 ; i < self.length ; i++ )
  {
    args[ 0 ] = self.eGet( i );
    args[ 1 ] = i;
    onElement.apply( self, args );
  }

  return self;
}

//

function elementsZip( onEach, matrix )
{
  let self = this;
  let args = _.longSlice( arguments, 2 );

  args.unshift( null );
  args.unshift( null );

  _.assert( 0, 'not tested' );

  for( let i = 0 ; i < self.length ; i++ )
  {
    args[ 0 ] = self.eGet( i );
    args[ 1 ] = matrix.eGet( i );
    onEach.apply( self, args );
  }

  return self;
}

//

function _lineEachCollecting( o ) /* xxx : move out? */
{
  let self = this;

  _.assert( self.dims.length === 2 );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.longIs( o.args ) );
  _.assert( o.length >= 0 );
  _.assert( _.boolLike( o.returningNumber ) );

  /* */

  o.args = _.longSlice( o.args );

  if( !o.args[ 0 ] )
  {
    if( o.returningNumber )
    o.args[ 0 ] = new Array( o.length );
    else
    o.args[ 0 ] = [];
  }

  if( o.returningNumber )
  if( !_.vectorAdapterIs( o.args[ 0 ] ) )
  o.args[ 0 ] = self.vectorAdapter.fromLong( o.args[ 0 ] );

  let result = o.args[ 0 ];

  /* */

  if( o.returningNumber )
  for( let i = 0 ; i < o.length ; i++ )
  {
    o.args[ 0 ] = self.lineGet( o.lineOrder, i );
    result.eSet( i, o.onEach.apply( self, o.args ) );
  }
  else
  for( let i = 0 ; i < o.length ; i++ )
  {
    o.args[ 0 ] = self.lineGet( o.lineOrder, i );
    result[ i ] = o.onEach.apply( self, o.args );
  }

  /* */

  return result;
}

_lineEachCollecting.defaults =
{
  onEach : null,
  args : null,
  length : null,
  lineOrder : null,
  returningNumber : null,
}

//

function colEachCollecting( onEach , args , returningNumber )
{
  let self = this;

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );

  let result = self._lineEachCollecting
  ({
    onEach,
    args,
    length : self.scalarsPerRow,
    lineOrder : 0,
    returningNumber,
  });

  return result;
}

//

function rowEachCollecting( onEach , args , returningNumber )
{
  let self = this;

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );

  let result = self._lineEachCollecting
  ({
    onEach,
    args,
    length : self.scalarsPerCol,
    lineOrder : 1,
    returningNumber,
  });

  return result;
}

// --
// relations
// --

let Statics =
{

  /* iterator */

  AtomWiseHomogeneous,
  AtomWiseZip,

}

// --
// declare
// --

let Extension =
{

  // advanced

  atomWiseReduceWithFlatVector,
  atomWiseReduceWithAtomHandler,
  atomWiseWithAssign,
  AtomWiseHomogeneous,
  atomWiseZip,
  AtomWiseZip,

  elementEach,
  elementsZip,

  _lineEachCollecting,
  rowEachCollecting,
  colEachCollecting,

  /*

  iterators :

  - map
  - filter
  - reduce
  - zip

  */

  //

  Statics,

}

_.classExtend( Self, Extension );

})();
