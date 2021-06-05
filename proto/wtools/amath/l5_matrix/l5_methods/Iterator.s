(function _Iterator_s_() {

'use strict';

const _ = _global_.wTools;
const abs = Math.abs;
const min = Math.min;
const $1 = Math.$2;
// const $1 = Math.$2;
// const $1 = Math.$2;
// const $1 = Math.$2;
// const $1 = Math.$2;
// const $1 = Math.$2;
const sqr = _.math.sqr;
const longSlice = Array.prototype.slice;

const Parent = null;
const Self = _.Matrix;

// --
// advanced
// --

/**
 * Method scalarWiseReduceWithFlatVector() applies the flat buffer of current matrix to the callback {-onVector-}.
 *
 * @example
 * var matrix = new _.Matrix
 * ({
 *   buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
 *   dims : [ 2, 2 ],
 *   strides : [ 1, 2 ],
 * });
 * var got = matrix.scalarWiseReduceWithFlatVector( ( e ) => e );
 * console.log( got.toStr() );
 * // log : 1.000, 2.000, 3.000, 4.000
 *
 * @param { Function } onVector - Callback that executes on flat buffer.
 * @returns { * } - Returns result of callback execution.
 * @method scalarWiseReduceWithFlatVector
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If this.strideOfElement is not identical to this.scalarsPerElement.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function scalarWiseReduceWithFlatVector( onVector )
{
  let self = this;
  let result;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( self.strideOfElement === self.scalarsPerElement );

  result = onVector( self.asVector() );

  return result;
}

//

/**
 * Method scalarWiseReduceWithScalarHandler() executes the reducer callback {-onElement-} on each scalar of the current matrix.
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
 * var got = matrix.scalarWiseReduceWithScalarHandler( onBegin, onElement, onEnd );
 * console.log( got );
 * // log :
 * // +2, +3,
 * // +4, +5
 *
 * @param { Function } onBegin - Callback that executes before iteration. It executes on options map with next fields : `args`, `container`, `filter`.
 * @param { Function } onElement - Callback that executes on options map for each scalar of the matrix.
 * To options map is added fields `key` and `element`, this fields change for each element.
 * @param { Function } onEnd - Callback that executes after iteration. It executes on options map with final values.
 * @returns { * } - Returns the value of field `result` in option map.
 * @method scalarWiseReduceWithScalarHandler
 * @throws { Error } If arguments.length is not equal to three.
 * @throws { Error } If number of dimensions is greater then two.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function scalarWiseReduceWithScalarHandler( onBegin, onScalar, onEnd )
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
 * Method scalarWiseWithAssign() executes the reducer callback {-onScalar-} on each scalar of the current matrix.
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
 * var got = matrix.scalarWiseWithAssign( onScalar, args );
 * console.log( got );
 * // log :
 * // +0, +0,
 * // +0, +1
 *
 * @param { Function } onScalar - Callback that executes on options map for each scalar of the matrix.
 * Options map includes next fields : `key`, `args`, `dstContainer`, `dstElement`, `srcElement`.
 * @param { * } args - Arguments for callback, it is linked to field `args` of options map.
 * @returns { Matrix } - Returns original matrix.
 * @method scalarWiseWithAssign
 * @throws { Error } If arguments.length is not equal to two.
 * @throws { Error } If number of dimensions is greater then two.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function scalarWiseWithAssign( onScalar, args )
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
 * Method ScalarWiseHomogeneous() executes the reducer callback {-onScalar-} on each scalar of the current matrix.
 * The call context of callback is current matrix.
 *
 * @param { Aux } o - Options map.
 * @param { Function } o.onScalar - Callback that executes on each scalar of matrices.
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
 * @throws { Error } If options map {-o-} is not Aux.
 * @throws { Error } If options map {-o-} has extra options.
 * @throws { Error } If {-o.args-} contains not instance of Matrix.
 * @throws { Error } If any of {-o.args-} element contains scalar, which is not a Number.
 * @throws { Error } If field dims in {-o.args-} elements is not an Array.
 * @throws { Error } If {-o.reducing-} and {-o.usingDstAsSrc-} are set to `true` at the same time.
 * @throws { Error } If {-o.dst-} neither is undefined, nor Nothing, nor a Matrix and at the same time {-o.reducing-} is set to `false`.
 * @throws { Error } If number of dimensions of {-o.dst-} is greater then two.
 * @throws { Error } If o.dst.dims are not equivalent to dimensions in {-o.args-} elements.
 * @static
 * @routine ScalarWiseHomogeneous
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function ScalarWiseHomogeneous( o )
{
  let proto = this;
  let newDst = false;

  _.routine.options_( ScalarWiseHomogeneous, o );

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
    _.assert( _.long.identical( src.dims, dims ) )
    else
    dims = src.dims; /* Dmytro : if add assertion `_.assert( src.dims.length === 2 );`, then assertion for o.dims and fsrc won't be needed */
  }

  _.assert( _.arrayIs( dims ) );

  /* default handlers*/

  let op;
  if( !o.onVectorsBegin )
  o.onVectorsBegin = function handleVectorsBeing()
  {

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

  if( !o.onScalarsBegin )
  o.onScalarsBegin = function handleScalarsBeing( op )
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
  _.assert( !o.dst || _.long.identical( o.dst.dims, dims ) );
  _.assert( fsrc instanceof Self ); /* Dmytro : it is extra assertion, see cycle above that checks each instance in o.srcs container */
  _.assert( fsrc.dims.length === 2, 'not implemented' ); /* Dmytro : it is extra assertion, the next assertion should check length because o.dst.dims.length is 2 */
  _.assert( _.long.identical( fsrc.dims, dims ) );

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

ScalarWiseHomogeneous.defaults =
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

//

/**
 * Method scalarWiseZip() executes the reducer callback {-onScalar-} on each scalar of the current matrix and the matrices in container {-srcs-}.
 * The call context of callback is current matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   3, 4
 * ]);
 * var src = _.Matrix.MakeSquare
 * ([
 *   5, 5,
 *   5, 5
 * ]);
 * var onScalar = function( o )
 * {
 *   this.scalarSet( o.key, 0 );
 *   o.dst.push( 1 )
 * };
 * var dst = [];
 * var got = matrix.scalarWiseZip( onScalar, dst, [ src ] );
 * console.log( got.toStr() );
 * // log :
 * // +0, +0,
 * // +0, +0
 * console.log( dst );
 * // log : [ 1, 1, 1, 1 ]
 *
 * @param { Function } onScalar - Callback that executes for each scalar of matrix {-o.dstContainer-}.
 * @param { * } dst - Destination instance, a part of field `args`.
 * @param { Long } srcs - Container with source matrices.
 * Callback accepts options map with next fields : `key`, `args`, `dstContainer`, `dstElement`, `srcContainers`, `srcElements`.
 * @returns { Matrix } - Returns original matrix.
 * @method scalarWiseZip
 * @throws { Error } If {-onScalar-} is not a routine.
 * @throws { Error } If {-dst-} has undefined value.
 * @throws { Error } If number of dimensions of current matrix is greater then two.
 * @throws { Error } If {-srcs-} has undefined value.
 * @throws { Error } If {-srcs-} contains not instance of Matrix.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function scalarWiseZip( onScalar, dst, srcs )
{
  let self = this;
  let o =
  {
    onScalar,
    dst,
    dstContainer : self,
    srcs,
  }
  return self.ScalarWiseZip( o )
}

//

/**
 * Static routine ScalarWiseZip() executes the reducer callback {-o.onScalar-} on each scalar of the destination matrix {-o.dstContainer-} and the matrices in container {-o.srcs}.
 * The call context of callback is current matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   3, 4
 * ]);
 * var src = _.Matrix.MakeSquare
 * ([
 *   5, 5,
 *   5, 5
 * ]);
 * var onScalar = function( o )
 * {
 *   this.scalarSet( o.key, 0 );
 *   o.dst.push( 1 );
 * };
 * var got = _.Matrix.ScalarWiseZip
 * ({
 *   dst : [],
 *   dstContainer : matrix,
 *   srcs : [ src ],
 *   onScalar : onScalar,
 * });
 * console.log( got.toStr() );
 * // log :
 * // +0, +0,
 * // +0, +0
 * console.log( dst );
 * // log : [ 1, 1, 1, 1 ]
 *
 * @param { Aux } o - Options map.
 * @param { * } o.dst - Destination instance, a part of field `args`.
 * @param { Matrix } o.dstContainer - Destination matrix.
 * @param { Long } o.srcs - Container with source matrices.
 * @param { Function } o.onScalar - Callback that executes for each scalar of matrix {-o.dstContainer-}.
 * Callback accepts options map with next fields : `key`, `args`, `dstContainer`, `dstElement`, `srcContainers`, `srcElements`.
 * @returns { Matrix } - Returns matrix {-o.dstContainer-}.
 * @throws { Error } If options map {-o-} is not Aux.
 * @throws { Error } If options map {-o-} has extra options.
 * @throws { Error } If {-o.dst-} has undefined value.
 * @throws { Error } If {-o.dstContainer-} is not a Matrix.
 * @throws { Error } If number of dimensions of {-o.dstContainer-} is greater then two.
 * @throws { Error } If {-o.srcs-} has undefined value.
 * @throws { Error } If {-o.srcs-} contains not instance of Matrix.
 * @throws { Error } If {-o.onScalar-} is not a routine.
 * @static
 * @function ScalarWiseZip
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function ScalarWiseZip( o )
{
  let result;

  _.routine.options_( ScalarWiseZip, o )
  _.assert( _.definedIs( o.dst ) );
  _.assert( o.dstContainer instanceof Self );
  _.assert( _.definedIs( o.srcs ) );
  _.assert( _.routineIs( o.onScalar ) );

  let self = o.dstContainer;

  _.assert( self.dims.length === 2, 'not implemented' );

  let op = Object.create( null );
  op.key = -1;
  op.args = [ o.dst, o.srcs ];
  op.dstContainer = self;
  op.dstElement = null;
  op.srcContainers = o.srcs;
  op.srcElements = [];
  Object.preventExtensions( op );

  /* */

  for( let s = 0 ; s < o.srcs.length ; s++ )
  {
    let src = o.srcs[ s ];
    _.assert( src instanceof Self );
  }

  /* */

  for( let c = 0 ; c < self.scalarsPerCol ; c++ )
  for( let r = 0 ; r < self.scalarsPerRow ; r++ )
  {
    op.key = [ c, r ];
    op.dstElement = self.scalarGet( op.key );

    for( let s = 0 ; s < o.srcs.length ; s++ )
    op.srcElements[ s ] = o.srcs[ s ].scalarGet( op.key ); /* Dmytro : maybe it needs to push each element in array but not replace in cycle */

    o.onScalar.call( self, op );
  }

  return self;
}

ScalarWiseZip.defaults =
{
  onScalar : null,
  dst : null,
  dstContainer : null,
  srcs : null,
}

//

/**
 * Method elementEach() executes callback {-onElement-} on each element of the current matrix.
 * The call context of callback is current matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   3, 4
 * ]);
 * var onElement = function( e, i )
 * {
 *   if( i >= 1 )
 *   e.mul( 2 );
 * };
 * var got = matrix.elementEach( onElement );
 * console.log( got.toStr() );
 * // log :
 * // +1, +4,
 * // +3, +8
 *
 * @param { Function } onElement - Callback that executes for each element of the matrix.
 * It applies element, element index, arguments without callback.
 * @returns { Matrix } - Returns original matrix.
 * @method elementEach
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function elementEach( onElement )
{
  let self = this;
  let args = _.longSlice( arguments, 1 );

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

/**
 * Method elementsZip() executes callback {-onEach-} on each element of the current matrix and the matrix in argument {-matrix-}.
 * The call context of callback is current matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   3, 4
 * ]);
 * var src = _.Matrix.MakeSquare
 * ([
 *   5, 5,
 *   5, 5
 * ]);
 * var onEach = function( e1, e2 )
 * {
 *   e1.add( e2 );
 * };
 * var got = matrix.elementsZip( onEach, src );
 * console.log( got.toStr() );
 * // log :
 * // +6, +7,
 * // +8, +9
 *
 * @param { Function } onEach - Callback that executes for each element of the matrix.
 * It applies element, element index, arguments without callback.
 * @returns { Matrix } - Returns original matrix.
 * @method elementsZip
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

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

function _lineEachCollecting( o )
{
  let self = this;
  let length = self.dims[ o.dim ? 0 : 1 ];
  let result;

  _.assert( self.dims.length === 2 );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.longIs( o.args ) );
  // _.assert( o.length >= 0 );
  _.assert( o.length === undefined );
  _.assert( _.boolLike( o.returningNumber ) );
  _.map.assertHasOnly( o, _lineEachCollecting.defaults );

  /* */

  if( !o.args )
  o.args = [];
  o.args = _.longSlice( o.args );

  if( o.collecting )
  {
    if( !o.args.length )
    if( o.returningNumber )
    o.args.unshift( new Array( length ) );
    else
    o.args.unshift( [] );
  }
  else
  {
    o.args.unshift( null );
  }

  if( o.collecting )
  if( o.returningNumber )
  if( !_.vectorAdapterIs( o.args[ 0 ] ) )
  o.args[ 0 ] = self.vectorAdapter.fromLong( o.args[ 0 ] );

  if( o.collecting )
  iterateCollecting();
  else
  iterateNotCollecting();

  /* */

  return result;

  function iterateCollecting()
  {
    result = o.args[ 0 ];

    if( o.returningNumber )
    for( let i = 0, l = length ; i < l ; i++ )
    {
      o.args[ 0 ] = self.lineGet( o.dim, i );
      result.eSet( i, o.onEach.apply( self, o.args ) );
    }
    else
    for( let i = 0, l = length ; i < l ; i++ )
    {
      o.args[ 0 ] = self.lineGet( o.dim, i );
      result[ i ] = o.onEach.apply( self, o.args );
    }
  }

  function iterateNotCollecting()
  {
    result = self;

    for( let i = 0, l = length ; i < l ; i++ )
    {
      o.args[ 0 ] = self.lineGet( o.dim, i );
      o.onEach.apply( self, o.args );
    }

  }

}

_lineEachCollecting.defaults =
{
  onEach : null,
  args : null,
  dim : null,
  returningNumber : null,
  collecting : 1,
}

//

/**
 * Method colEachCollecting() executes callback {-onEach-} on argument {-args-}.
 * Each iteration the first element of {-args-} changes to the next column of current matrix.
 * The call context of callback is current matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   3, 4
 * ]);
 * var src = _.Matrix.MakeSquare
 * ([
 *   5, 5,
 *   5, 5
 * ]);
 * var onEach = function( e, m )
 * {
 *   m.eGet( 0 ).add( e );
 *   return e.eGet( 0 );
 * };
 * var got = matrix.colEachCollecting( onEach, [ [], src ], 0 );
 * console.log( got );
 * // log : [ 1, 2 ]
 * console.log( src.toStr() );
 * // log :
 * // +8,  +5,
 * // +12, +5
 *
 * @param { Function } onEach - Callback that executes for container {-args-},
 * the first element of {-args-} is column that corresponds to number of iteration.
 * @param { Long } args - The container with arguments for {-onEach-} callback.
 * @param { BoolLike } returningNumber - Defines type of result. If true, then routine returns VectorAdapter, otherwise, it returns original container type.
 * @returns { VectorAdapter|Long } - Returns vector from first element of {-args-}.
 * @method colEachCollecting
 * @throws { Error } If arguments.length is not 3.
 * @throws { Error } If {-onEach-} is not a Function.
 * @throws { Error } If {-args-} is not a Long.
 * @throws { Error } If {-returningNumber-} is not a BoolLike.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function colEachCollecting( onEach , args , returningNumber )
{
  let self = this;

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );

  let result = self._lineEachCollecting
  ({
    onEach,
    args,
    // length : self.scalarsPerRow,
    dim : 0,
    returningNumber,
  });

  return result;
}

//

/**
 * Method rowEachCollecting() executes callback {-onEach-} on argument {-args-}.
 * Each iteration the first element of {-args-} changes to the next row of current matrix.
 * The call context of callback is current matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   3, 4
 * ]);
 * var src = _.Matrix.MakeSquare
 * ([
 *   5, 5,
 *   5, 5
 * ]);
 * var onEach = function( e, m )
 * {
 *   m.eGet( 0 ).add( e );
 *   return e.eGet( 0 );
 * };
 * var got = matrix.rowEachCollecting( onEach, [ [], src ], 0 );
 * console.log( got );
 * // log : [ 1, 3 ]
 * console.log( src.toStr() );
 * // log :
 * // +9,  +5,
 * // +11, +5
 *
 * @param { Function } onEach - Callback that executes for container {-args-},
 * the first element of {-args-} is row that corresponds to number of iteration.
 * @param { Long } args - The container with arguments for {-onEach-} callback.
 * @param { BoolLike } returningNumber - Defines type of result. If true, then routine returns VectorAdapter, otherwise, it returns original container type.
 * @returns { VectorAdapter|Long } - Returns vector from first element of {-args-}.
 * @method rowEachCollecting
 * @throws { Error } If arguments.length is not 3.
 * @throws { Error } If {-onEach-} is not a Function.
 * @throws { Error } If {-args-} is not a Long.
 * @throws { Error } If {-returningNumber-} is not a BoolLike.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function rowEachCollecting( onEach , args , returningNumber )
{
  let self = this;

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );

  let result = self._lineEachCollecting
  ({
    onEach,
    args,
    // length : self.scalarsPerCol,
    dim : 1,
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

  ScalarWiseHomogeneous,
  ScalarWiseZip,

}

// --
// declare
// --

let Extension =
{

  // advanced

  scalarWiseReduceWithFlatVector,
  scalarWiseReduceWithScalarHandler,
  scalarWiseWithAssign,
  ScalarWiseHomogeneous,
  scalarWiseZip,
  ScalarWiseZip,

  elementEach,
  elementsZip,

  _lineEachCollecting,
  rowEachCollecting,
  colEachCollecting,

  /* qqq2 : implement and cover lineFilter */
  /* qqq2 : implement and light cover colFilter */
  /* qqq2 : implement and light cover rowFilter */

  /* qqq2 : implement and cover lineMap */
  /* qqq2 : implement and light cover colMap */
  /* qqq2 : implement and light cover rowMap */

  /* qqq2 :

  null -> clone
  nothing -> original
  _.self -> original

  3x3.colFilter( onCol ) -> 3x0
  3x3.colFilter( null, onCol ) -> 3x0
  3x3.colFilter( _.self, onCol ) -> 3x0

  */

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
