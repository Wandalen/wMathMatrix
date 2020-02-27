(function _Iterate_s_() {

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
// implementation
// --

function atomWiseReduceWithFlatVector( onVector )
{
  let self = this;
  let result;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( self.strideOfElement === self.atomsPerElement );

  debugger;

  result = onVector( self.asVector() );

  return result;
}

//

function atomWiseReduceWithAtomHandler( onBegin, onAtom, onEnd )
{
  let self = this;
  let result;

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  _.assert( self.dims.length === 2, 'not implemented' );

  let op = onBegin
  ({
    args : [ self ],
    container : self,
    filter : null,
  });

  for( let c = 0 ; c < self.atomsPerCol ; c++ )
  for( let r = 0 ; r < self.atomsPerRow ; r++ )
  {
    op.key = [ c, r ];
    op.element = self.atomGet([ c, r ]);
    onAtom( op );
  }

  onEnd( op );

  return op.result;
}

//

function atomWiseWithAssign( onAtom, args )
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

  for( let c = 0 ; c < self.atomsPerCol ; c++ )
  for( let r = 0 ; r < self.atomsPerRow ; r++ )
  {
    op.key = [ c, r ];
    op.dstElement = self.atomGet( op.key );
    onAtom.call( self, op );
  }

  return self;
}

//

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
    dims = src.dims;
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

  if( o.onAtomsBegin )
  debugger;
  if( !o.onAtomsBegin )
  o.onAtomsBegin = function handleAtomsBeing( op )
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
    /*o.dst = proto.makeZero( dims );*/
    o.dst = o.args[ 0 ] = proto.Self.from( o.dst, dims );
  }
  else
  {
    o.srcs = o.args.slice( o.usingDstAsSrc ? 0 : 1 );
  }

  let fsrc = o.srcs[ 0 ];

  /* srcs allocation */

  for( let s = 0 ; s < o.srcs.length ; s++ )
  {
    let src = o.srcs[ s ] = proto.Self.from( o.srcs[ s ], dims );
    _.assert( src instanceof Self );
  }

  /* verification */

  _.assert( !proto.instanceIs() );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( o.dst instanceof Self || o.reducing );
  _.assert( !o.dst || o.dst.dims.length === 2, 'not implemented' );
  _.assert( !o.dst || _.longIdentical( o.dst.dims, dims ) )
  _.assert( fsrc instanceof Self );
  _.assert( fsrc.dims.length === 2, 'not implemented' );
  _.assert( _.longIdentical( fsrc.dims, dims ) )

  /* */

  op = o.onVectorsBegin.call( o.dst, op );

  op.args = o.args;
  op.dstContainer = o.dst;
  op.srcContainers = o.srcs;

  _.assert( op.srcContainers.length > 0 );

  /* */

  let brk = 0;
  for( let c = 0 ; c < fsrc.atomsPerCol ; c++ )
  {

    for( let r = 0 ; r < fsrc.atomsPerRow ; r++ )
    {

      op.key = [ c, r ];

      op.dstElement = fsrc.atomGet( op.key );

      o.onAtomsBegin( op );

      _.assert( _.numberIs( op.dstElement ) );

      if( op.srcContainers.length === 1 )
      {
        op.srcElement = fsrc.atomGet( op.key );
        o.onAtom.call( o.dst, op );

        if( o.onContinue )
        if( o.onContinue( o ) === false )
        brk = 1;

      }
      else for( let s = 1 ; s < op.srcContainers.length ; s++ )
      {
        op.srcElement = op.srcContainers[ s ].atomGet( op.key );
        o.onAtom.call( o.dst, op );

        if( o.onContinue )
        if( o.onContinue( o ) === false )
        {
          brk = 1;
          break;
        }

      }

      if( !o.reducing )
      op.dstContainer.atomSet( op.key, op.dstElement );

      if( o.onAtomsEnd )
      o.onAtomsEnd( op );

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
  onAtom : null,
  onAtomsBegin : null,
  onAtomsEnd : null,
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

function atomWiseZip( onAtom, dst, srcs )
{
  let self = this;
  let o =
  {
    onAtom,
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
  _.assert( _.routineIs( o.onAtom ) );

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

  for( let c = 0 ; c < self.atomsPerCol ; c++ )
  for( let r = 0 ; r < self.atomsPerRow ; r++ )
  {
    op.key = [ c, r ];
    op.dstElement = self.atomGet( op.key );

    for( let s = 0 ; s < srcs.length ; s++ )
    op.srcElements[ s ] = srcs[ s ].atomGet( op.key );

    onAtom.call( self, op );
  }

  return self;
}

AtomWiseZip.defaults =
{
  onAtom : null,
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
    o.args[ 0 ] = self.lineVectorGet( o.lineOrder, i );
    result.eSet( i, o.onEach.apply( self, o.args ) );
  }
  else
  for( let i = 0 ; i < o.length ; i++ )
  {
    o.args[ 0 ] = self.lineVectorGet( o.lineOrder, i );
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
    length : self.atomsPerRow,
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
    length : self.atomsPerCol,
    lineOrder : 1,
    returningNumber,
  });

  return result;
}

// --
// relations
// --

let Statics = /* qqq : split static routines. ask how */
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

  //

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
