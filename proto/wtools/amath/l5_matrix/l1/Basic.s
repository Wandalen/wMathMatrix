(function _Basic_s_() {

'use strict';

//

const _ = _global_.wTools;
const abs = Math.abs;
const min = Math.min;
const max = Math.max;
const sqrt = Math.sqrt;
const sqr = _.math.sqr;

_.assert( _.object.isBasic( _.vectorAdapter ), 'wMatrix requires vector module' );
_.assert( !!_.all );

/**
 * @classdesc Multidimensional structure which in the most trivial case is Matrix of scalars. A matrix of specific form could also be classified as a vector. MathMatrix heavily relly on MathVector, which introduces VectorAdapter. VectorAdapter is a reference, it does not contain data but only refer on actual ( aka Long ) container of lined data.  Use MathMatrix for arithmetic operations with matrices, to triangulate, permutate or transform matrix, to get a specific or the general solution of a system of linear equations, to get LU, QR decomposition, for SVD or PCA. Also, Matrix is a convenient and efficient data container, you may use it to continuously store huge an array of arrays or for matrix computation.
 * @class wMatrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

const Parent = null;
const Self = wMatrix;
function wMatrix( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

// --
// inter
// --

/**
 * Method init() initializes the instance of matrix and set value for options.
 *
 * @example
 * var matrix = _.Matrix
 * ({
 *   buffer : [ 1, 2, 3, 4, 5, 6, 7, 8 ],
 *   dims : [ 2, 2 ],
 *   strides : [ 2, 1 ];
 * });
 * console.log( matrix.inputRowMajor );
 * // log : null
 * matrix.init( { inputRowMajor : 1 } );
 * console.log( matrix.inputRowMajor );
 * // log : 1
 *
 * @param { Aux } o - Options map.
 * @returns { Matrix } - Returns original instance of Matrix with changed options.
 * @method init
 * @throws { Error } If arguments.length is more then one.
 * @throws { Error } If {-o-} is not a Aux.
 * @throws { Error } If {-o-} has extra options.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function init( o )
{
  let self = this;

  self._.stridesEffective = null;
  self._.length = null;
  self._.scalarsPerElement = null;
  self._.scalarsPerLayer = null
  self._.scalarsPerMatrix = null;
  self._.layersPerMatrix = null;
  self._.occupiedRange = null;
  self._.dimsEffective = null;
  self._.strides = null;
  self._.offset = 0;

  self._changing = [ 1 ];
  _.workpiece.initFields( self );
  self._changing[ 0 ] -= 1;

  Object.preventExtensions( self );

  if( o )
  {
    self.copy( o );
  }
  else
  {
    self._sizeChanged();
  }

  _.assert( arguments.length <= 1 );

}

//

/**
 * Static routine Is() checks whether the provided argument is an instance of Matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   3, 4
 * ]);
 * var got = _.Matrix.Is( matrix );
 * console.log( got );
 * // log : true
 *
 * @param { * } src - The source argument.
 * @returns { Boolean } - Returns whether the argument is instance of Matrix.
 * @throws { Error } If arguments.length is not equal to one.
 * @static
 * @function Is
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function Is( src )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  return _.matrixIs( src );
}

//

function _iterate()
{

  let iterator = Object.create( null );
  iterator.next = next;
  iterator.index = 0;
  iterator.vector = this;
  return iterator;

  function next()
  {
    let result = Object.create( null );
    result.done = this.index === this.vector.length;
    if( result.done )
    return result;
    result.value = this.vector.eGet( this.index );
    this.index += 1;
    return result;
  }

}

//

function _toStringTag()
{
  return 'Matrix';
}

//

function _inspectCustom()
{
  return this.toStr();
}

//

function _toPrimitive( hint )
{
  return this.toStr();
}

//

function _accuracyGet()
{
  return this.vectorAdapter.accuracy
}

//

function _accuracySqrGet()
{
  return this.vectorAdapter.accuracySqr
}

//

function _accuracySqrtGet()
{
  return this.vectorAdapter.accuracySqrt
}

//

function _traverseAct( it ) /* zzz : deprecate */
{
  let self = this;

  if( it.resetting === undefined )
  it.resetting = true;
  // it.resetting = 1;

  _.Copyable.prototype._traverseAct.head.call( this, _traverseAct, [ it ] );

  if( !it.dst )
  {
    _.assert( it.technique === 'object' );
    _.assert( it.src instanceof Self );
    it.dst = it.src.clone();
    return it.dst;
  }

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( it.resetting !== undefined );
  _.assert( !!it.dst );

  let dst = it.dst;
  let src = it.src;
  let srcIsInstance = src instanceof Self;
  let dstIsInstance = dst instanceof Self;

  if( src === dst )
  return dst;

  /* */

  if( _.longIs( src ) )
  {
    dst.copyFromBuffer( src );
    return dst;
  }
  else if( _.numberIs( src ) )
  {
    dst.copyFromScalar( src );
    return dst;
  }

  // if( dstIsInstance )
  // dst._changeBegin();

  if( src.dims )
  {
    _.assert( it.resetting || !dst.dims || _.long.identical( dst.dims , src.dims ) );
  }

  if( dstIsInstance )
  if( dst.stridesEffective )
  dst._.stridesEffective = null;

  /* */

  if( dstIsInstance )
  if( src.buffer !== undefined )
  {
    /* use here resetting option maybe!!!? */

    dst.dims = null;

    if( srcIsInstance && dst.buffer && dst.scalarsPerMatrix === src.scalarsPerMatrix )
    {
    }
    else if( !srcIsInstance )
    {
      dst.buffer = src.buffer;
      if( src.offset !== undefined )
      dst.offset = src.offset;
      if( src.strides !== undefined )
      dst.strides = src.strides;
    }
    else if( src.buffer && !dst.buffer && src.scalarsPerMatrix !== undefined )
    {
      dst.buffer = self.longType.long.makeUndefined( src.buffer , src.scalarsPerMatrix );
      dst.offset = 0;
      dst.strides = null;
      dst._.stridesEffective = dst.StridesFromDimensions( src.dims, !!dst.inputRowMajor );
    }
    else if( src.buffer && dst.scalarsPerMatrix !== src.scalarsPerMatrix )
    {
      dst.buffer = self.longType.long.makeUndefined( src.buffer , src.scalarsPerMatrix );
      dst.offset = 0;
      dst.strides = null;
      dst._.stridesEffective = dst.StridesFromDimensions( src.dims, !!dst.inputRowMajor );
    }
    else debugger;

  }

  /* */

  if( src.dims )
  {
    // _.assert( dstIsInstance, 'not tested' );
    if( dstIsInstance )
    dst._dimsSet( src.dims );
    else
    dst.dims = self.longType.long.make( src.dims, src.dims );
  }

  it.copyingAggregates = 0;
  dst = _.Copyable.prototype._traverseAct( it );

  if( srcIsInstance )
  _.assert( _.long.identical( dst.dims , src.dims ) );

  if( dstIsInstance )
  {
    // dst._changeEnd();
    // _.assert( dst._changing[ 0 ] === 0 );
  }

  if( srcIsInstance )
  {

    if( dstIsInstance )
    {
      _.assert( dst.hasShape( src ) );
      src.scalarEach( function( it )
      {
        dst.scalarSet( it.indexNd, it.buffer[ it.offset[ 0 ] ] );
      });
    }
    else
    {
      let extract = it.src._exportNormalized();
      let newIteration = it.iterationNew();
      newIteration.select( 'buffer' );
      newIteration.src = extract.buffer;
      dst.buffer = _._cloneAct( newIteration );
      dst.offset = extract.offset;
      dst.strides = extract.strides;
    }
  }

  return dst;
}

_traverseAct.iterationDefaults = Object.create( _._cloner.iterationDefaults );
_traverseAct.defaults = _.mapExtendDstNotOwn( Object.create( _._cloner.defaults ), _traverseAct.iterationDefaults );

//

function _equalAre( it )
{

  _.assert( arguments.length === 1, 'Expects exactly three arguments' );
  _.assert( _.routineIs( it.onNumbersAreEqual ) );
  _.assert( _.looker.iterationIs( it ) );

  // xxx : clean
  // if( _global_.debugger )
  // debugger;

  it.continue = false;

  if( !_.matrixIs( it.src ) || !_.matrixIs( it.src2 ) )
  return end( false );
  // {
    // it.result = false;
    // return;
  // }

  if( it.strictTyping )
  if( it.src.buffer.constructor !== it.src2.buffer.constructor )
  return end( false );
  // {
  //   it.result = false;
  //   return it.result;
  // }

  if( it.strictContainer )
  {
    if( !_.long.identical( [ ... it.src.dims ], [ ... it.src2.dims ] )  )
    return end( false );
    // {
    //   it.result = false;
    //   return it.result;
    // }
  }
  else
  {
    if( !it.src.scalarsPerMatrix || !it.src2.scalarsPerMatrix )
    {
      if( it.src.scalarsPerMatrix || it.src2.scalarsPerMatrix )
      return end( false );
      // return it.stop( false );
    }
    else if( it.src.dims.length < it.src2.dims.length )
    {
      if( !dimsCompare( it.src.dims, it.src2.dims ) )
      return;
      // return it.result;
    }
    else
    {
      if( !dimsCompare( it.src2.dims, it.src.dims ) )
      return;
      // return it.result;
    }
  }

  it.result = it.src.scalarWhile( function( it2 )
  {
    let scalar = it2.buffer[ it2.offset[ 0 ] ];
    let scalar2 = it.src2.scalarGet( it2.indexNd );
    return it.onNumbersAreEqual( scalar, scalar2 );
  });

  _.assert( _.boolIs( it.result ) );
  // return it.result;

  /* */

  function dimsCompare( src1, src2 )
  {
    for( let i = src1.length-1 ; i >= 0 ; i-- )
    {
      if( src1[ i ] !== src2[ i ] )
      {
        it.result = false;
        return it.result;
      }
    }
    for( let i = src2.length-1 ; i >= src1.length ; i-- )
    {
      if( src2[ i ] !== 1 )
      {
        it.result = false;
        return it.result;
      }
    }
    return true;
  }

  function end( result )
  {
    it.result = result;
  }

}

_.routineExtend( _equalAre, _.equaler._equal );

//

function _equalSecondCoerce( it )
{

  if( it.strictContainer )
  return;

  if( _.longIs( it.src ) || _.vectorAdapterIs( it.src ) )
  {
    it.src = _.Matrix.FromVector( it.src );
  }

  if( _.longIs( it.src2 ) || _.vectorAdapterIs( it.src2 ) )
  {
    it.src2 = _.Matrix.FromVector( it.src2 );
  }

}

//

function _longGet()
{
  let self = this;
  if( _.routineIs( self ) )
  self = self.prototype;
  let result = self.vectorAdapter.longType;
  _.assert( _.object.isBasic( result ) );
  return result;
}

// --
// import / export
// --

/**
 * Static routine ExportStructure() exports data from the source matrix {-src-} into the destination structure {-dst-}.
 *
 * @example
 * var src = _.Matrix.Make( [ 2, 2 ] );
 * var dst = {};
 * _.Matrix.ExportStructure( { src : src, dst : dst } );
 * console.log( dst );
 * // log : {
 * //   dims: [ 2, 2 ],
 * //   buffer: Float32Array [ 4, 5, 1, 2 ],
 * //   offset: 0,
 * //   strides: [ 2, 1 ]
 * // }
 *
 * @param { Aux } o - Options map.
 * @param { Matrix } o.src - Source matrix.
 * @param { Aux|ObjectLike|Matrix } o.dst - Destination container.
 * @param { String } o.how - Format of structure, it should have value 'object' to prevent exception.
 * @returns { Aux|ObjectLike|Matrix } - Returns destination container with data from current matrix.
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-o-} is not a Aux.
 * @throws { Error } If {-o-} has extra options.
 * @throws { Error } If {-o.src-} and {-o.dst-} are instance of Matrix and have different dimensions.
 * @static
 * @function ExportStructure
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function ExportStructure( o )
{

  o = _.routine.options_( ExportStructure, arguments );

  _.assert( _.longHas( [ 'object', 'structure' ], o.how ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( o.dst === null )
  {
    if( o.how === 'object' )
    {
      o.dst = new this.Self( o.src );
      return o.dst;
    }
    else
    {
      o.dst = Object.create( null );
    }
  }

  if( o.src === o.dst )
  return o.dst;

  /* */

  let dstIsInstance = o.dst instanceof Self;
  let srcIsInstance = o.src instanceof Self;

  if( dstIsInstance && !srcIsInstance )
  {

    if( _.vectorIs( o.src ) )
    {
      o.dst.bufferImport({ buffer : o.src });
      return o.dst;
    }
    else if( _.numberIs( o.src ) )
    {
      o.dst.copyFromScalar( o.src );
      return o.dst;
    }

  }

  _.assert( _.mapIs( o.src ) || o.src instanceof Self );

  if( !srcIsInstance )
  {
    if( Config.debug )
    _.map.assertHasOnly( o.src, this.FieldsOfInputGroups );
  }

  if( dstIsInstance )
  {
    // o.dst._changeBegin();

    if( srcIsInstance )
    {

      o.dst._dimsSet( this.DimsDeduceFrom( o.src, o.dst.dims ) );

      if( o.src.scalarsPerMatrix !== o.dst.scalarsPerMatrix )
      {
        o.dst._.buffer = this.longType.long.makeUndefined( o.src.buffer , o.src.scalarsPerMatrix );
        o.dst._.offset = 0;
        o.dst._.strides = null;
        o.dst._.occupiedRange = null;
        o.dst._.dimsEffective = null;
        o.dst._.stridesEffective = o.dst.StridesFromDimensions( o.src.dims, 0 );
      }

    }
    else
    {

      let o2 = Object.create( null );
      o2.dimsWas = o.dst.dims;
      o2.buffer = o.src.buffer;
      o2.offset = o.src.offset;
      o2.strides = o.src.strides;
      o2.dims = this.DimsDeduceFrom( o.src, o2.dimsWas ? false : true );
      o2.inputRowMajor = o.src.inputRowMajor || 0;

      if( o2.buffer )
      {

        if
        (
             o.src.dims
          || o.src.strides
          || ( o.src.inputRowMajor !== null && o.src.inputRowMajor !== undefined )
          || ( o.src.offset !== null && o.src.offset !== undefined )
        )
        {

          _.assert( o.src.inputRowMajor !== undefined || !!o2.strides, 'Expects either specified {- inputRowMajor -} or {- strides -} if {- buffer -} is specified' );

          o.dst._.offset = 0;
          o.dst._.strides = null;
          o.dst._.dims = null;
          o.dst._.stridesEffective = null;
          o.dst._.dimsEffective = null;

        }

        o.dst._.occupiedRange = null;

        if( _.vectorAdapterIs( o2.buffer ) )
        {

          if( o2.strides )
          {
            // o2.strides = o2.strides.slice(); /* yyy */
            o2.strides = [ ... o2.strides ];
          }
          else
          {
            if( !o2.dims )
            o2.dims = dimsSet( o2.dims || o2.dimsWas );
            o2.strides = this.StridesFromDimensions( o2.dims, o.src.inputRowMajor );
          }

          o2.offset = o2.offset || 0;

          o2.offset = o2.buffer.offset + o2.offset*o2.buffer.stride;
          for( let i = 0 ; i < o2.strides.length ; i++ )
          o2.strides[ i ] *= o2.buffer.stride;

          o2.buffer = o2.buffer._vectorBuffer;

        }

      }

      set( 'buffer', o2.buffer );
      set( 'offset', o2.offset );
      set( 'strides', o2.strides );

      dimsSet( o2.dims || o2.dimsWas );

      if( !o.dst._.stridesEffective )
      o.dst._.stridesEffective = o.dst.StridesEffectiveFrom( o.dst.dims, o.dst.strides, o.src.inputRowMajor );

    }

    o.dst._sizeChanged();
    // o.dst._changeEnd();
    // _.assert( o.dst._changing[ 0 ] === 0 );

    if( srcIsInstance )
    {
      o.src.scalarEach( function( it )
      {
        o.dst.scalarSet( it.indexNd, it.buffer[ it.offset[ 0 ] ] );
      });
    }

  }
  else
  {

    copy( 'dims' );

    if( o.restriding )
    {
      let extract = o.src._exportNormalized();
      _.props.extend( o.dst, extract );
    }
    else
    {
      copy( 'buffer' );
      o.dst.strides = o.src.stridesEffective || o.src.strides;
      o.dst.offset = o.src.offset || 0;
    }

  }

  return o.dst;

  /* */

  function copy( key )
  {
    if( o.src[ key ] !== null && o.src[ key ] !== undefined )
    o.dst[ key ] = o.src[ key ];
  }

  function set( key, val )
  {
    if( val !== null && val !== undefined )
    o.dst._[ key ] = val;
  }

  function dimsSet( dims )
  {
    if( dims )
    {
      o.dst._dimsSet( dims );
      // o.dst._.dims = o.dst.longType.long.make( dims );
      return dims;
    }
    else
    {
      o.dst._dimsDeduceInitial();
      return o.dst.dims;
    }
  }

}

ExportStructure.defaults =
{
  src : null,
  dst : null,
  how : 'structure',
  restriding : 1,
}

//

/**
 * Method exportStructure() exports data from the current matrix into the destination structure {-dst-}.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 2, 2 ] );
 * var dst = {};
 * matrix.exportStructure( { dst : dst } );
 * console.log( dst );
 * // log : {
 * //   dims: [ 2, 2 ],
 * //   buffer: Float32Array [ 4, 5, 1, 2 ],
 * //   offset: 0,
 * //   strides: [ 2, 1 ]
 * // }
 *
 * @param { Aux } o - Options map.
 * @param { Aux|ObjectLike|Matrix } o.dst - Destination container.
 * @param { String } o.how - Format of structure, it should have value 'object' to prevent exception.
 * @returns { Aux|ObjectLike|Matrix } - Returns destination container with data from current matrix.
 * @method exportStructure
 * @throws { Error } If arguments are not provided.
 * @throws { Error } If {-o-} is not a Aux.
 * @throws { Error } If {-o-} has extra options.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function exportStructure( o )
{
  let self = this;

  o = _.routine.options_( exportStructure, arguments );

  o.src = self;

  return self.ExportStructure( o );
}

exportStructure.defaults =
{
  ... _.mapBut_( null, ExportStructure.defaults, [ 'src' ] ),
}

//

/**
 * Method _exportNormalized() extracts data from the Matrix instance and saves it in new map.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   3, 4
 * ]);
 * var extract = matrix._exportNormalized();
 * console.log( extract );
 * // log :
 * // {
 * //  buffer : [ 1, 2, 3, 4 ],
 * //  offset : 0,
 * //  strides : 1, 2,
 * // }
 *
 * @returns { Map } - Returns map with matrix data.
 * @method _exportNormalized
 * @throws { Error } If arguments are passed.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

/* zzz : deprecate routine _exportNormalized? */

function _exportNormalized()
{
  let self = this;
  let result = Object.create( null );

  _.assert( arguments.length === 0, 'Expects no arguments' );

  result.buffer = self.longType.long.makeUndefined( self.buffer, self.scalarsPerMatrix );
  result.offset = 0;
  result.strides = self.StridesFromDimensions( self.dims, 0 );

  self.scalarEach( function( it ) /* qqq : use maybe method */
  {
    let i = self._FlatScalarIndexFromIndexNd( it.indexNd, result.strides );
    result.buffer[ i ] = it.buffer[ it.offset[ 0 ] ];
  });

  return result;
}

// //
//
// function _copy( src )
// {
//   let self = this;
//
//   _.assert( arguments.length === 1, 'Expects exactly two arguments' );
//
//   self.ExportStructure
//   ({
//     src : src,
//     dst : self,
//     how : 'object',
//   });
//   return self;
//
//   // let it = _._cloner( self._traverseAct, { src, dst : self, /*resetting, */ technique : 'object' } );
//   // self._traverseAct( it );
//   //
//   // return it.dst;
// }

//

/**
 * Method copy() copies scalars from buffer {-src-} into inner matrix.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 2, 2 ] );
 * console.log( matrix.toStr() );
 * // log : +0, +0,
 * //       +0, +0,
 * matrix.copy( [ 1, 2, 3, 4 ] );
 * console.log( matrix.toStr() );
 * // log : +1, +2,
 * //       +3, +4,
 *
 * @param { Long|Number } src - A Long or single scalar.
 * @returns { Matrix } - Returns original instance of Matrix filled by values from {-src-}.
 * @method copy
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-src-} is not a Long, not a Number.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function copy( src )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  self.ExportStructure
  ({
    src : src,
    dst : self,
    how : 'object',
  });

  return self;

  // let it = _._cloner( self._traverseAct, { src, dst : self, /*resetting, */ technique : 'object' } );
  // self._traverseAct( it );
  //
  // return it.dst;

}

//

// function copyResetting( src )
// {
//   let self = this;
//
//   _.assert( arguments.length === 1, 'Expects single argument' );
//
//   return self._copy( src, 1 );
// }

//

/**
 * Method copyFromScalar() applies scalar {-src-} to each element of inner matrix.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 2, 2 ] );
 * console.log( matrix.toStr() );
 * // log : +0, +0,
 * //       +0, +0,
 * matrix.copyFromScalar( 5 );
 * console.log( matrix.toStr() );
 * // log : +5, +5,
 * //       +5, +5,
 *
 * @param { Number } src - Scalar to fill the matrix.
 * @returns { Matrix } - Returns original instance of Matrix filled by scalar values.
 * @method copyFromScalar
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-src-} is not a Number.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function copyFromScalar( src )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.numberIs( src ) );

  self.scalarEach( ( it ) => self.scalarSet( it.indexNd, src ) );

  return self;
}

//

/**
 * Method copyFromBuffer() copies scalars from buffer {-src-} into inner matrix.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 2, 2 ] );
 * console.log( matrix.toStr() );
 * // log : +0, +0,
 * //       +0, +0,
 * matrix.copyFromBuffer( [ 1, 2, 3, 4 ] );
 * console.log( matrix.toStr() );
 * // log : +1, +2,
 * //       +3, +4,
 *
 * @param { Long } src - A Long for assigning to the matrix.
 * @returns { Matrix } - Returns original instance of Matrix filled by values from {-src-}.
 * @throws { Error } If arguments.length is less then one.
 * @throws { Error } If {-src-} is not a Long.
 * @method copyFromBuffer
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function copyFromBuffer( src )
{
  let self = this;
  self.bufferImport({ buffer : src });
  return self;
}

//

/**
 * Method clone() makes copy of the matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   3, 4
 * ]);
 * console.log( matrix.toStr() );
 * // log : +1, +2,
 * //       +3, +4,
 * var copy = matrix.clone();
 * console.log( copy.toStr() );
 * // log : +1, +2,
 * //       +3, +4,
 * console.log( matrix === copy );
 * // log : false
 *
 * @returns { Matrix } - Returns copy of the Matrix.
 * @method clone
 * @throws { Error } If arguments is passed.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function clone( extending )
{
  let self = this;

  _.assert( arguments.length === 0 || arguments.length === 1, 'Expects no arguments' );

  // _global_.debugger = 1;
  // let dst = _.Copyable.prototype.clone.call( self );
  // _.assert( dst.buffer === self.buffer );

  // _global_.debugger = 1;

  if( extending )
  {
    // let src = _.mapOnly_( null, self, self.Self.FieldsOfCopyableGroups );
    // _.props.extend( src, extending );
    let src = self.exportStructure();
    if( extending )
    _.props.extend( src, extending );
    let dst = new self.constructor( src );
    _.assert( dst !== self && dst !== src );
    return dst;
  }
  else
  {
    let src = self.exportStructure();
    let dst = new self.constructor( src );
    _.assert( dst !== self );
    return dst;
  }

  if( Config.debug )
  {
    if( extending && extending.buffer !== undefined && extending.buffer !== null )
    _.assert( dst.buffer === extending.buffer );
    else
    _.assert( dst.buffer === self.buffer );
  }

  return dst;
}

//

function cloneExtending()
{
  let self = this;
  return self.clone( ... arguments );
}

//

/**
 * Static routine CopyTo() copies data from buffer {-src-} into buffer {-dst-}.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 2, 2 ] );
 * console.log( matrix.toStr() );
 * var copy = _.Matrix.CopyTo( matrix, [ 1, 2, 3, 4 ] );
 * console.log( copy.toStr() );
 * // log : +1, +2,
 * //       +3, +4,
 * console.log( matrix === copy );
 * // log : true
 *
 * @param { Long|VectorAdapter|Matrix } dst - Destination container.
 * @param { Long|VectorAdapter|Matrix } src - Source container.
 * @returns { Long|VectorAdapter|Matrix } - Returns original instance of destination container filled by values of source container.
 * @throws { Error } If arguments.length is not equal to two.
 * @throws { Error } If {-dst-} and {-src-} have different dimensions.
 * @throws { Error } If routine is called by instance of Matrix.
 * @static
 * @function CopyTo
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function CopyTo( dst, src ) /* aaa3 : cover please. should work even if src.length < dst.length ask */ /* Dmytro : covered */
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( dst === src )
  return dst;

  let odst = dst;
  let dstDims = Self.DimsOf( dst );
  let srcDims = Self.DimsOf( src );
  let dimsIdentical = true;

  _.assert( srcDims.length === dstDims.length, 'not implemented' );
  for( let i = 0 ; i < srcDims.length ; i++ )
  {
    if( srcDims[ i ] !== dstDims[ i ] )
    dimsIdentical = false;
    _.assert( srcDims[ i ] <= dstDims[ i ] );
  }

  if( !_.matrixIs( src ) )
  {

    src = this.vectorAdapter.from( src );
    if( _.longIs( dst ) )
    dst = this.vectorAdapter.from( dst );

    if( _.vectorAdapterIs( dst ) )
    {
      for( let s = 0 ; s < src.length ; s += 1 )
      dst.eSet( s, src.eGet( s ) );
      for( let s = src.length ; s < dst.length ; s += 1 )
      dst.eSet( s, 0 );
    }
    else if( _.matrixIs( dst ) )
    {
      if( !dimsIdentical )
      dst.copy( 0 );
      for( let s = 0 ; s < src.length ; s += 1 )
      dst.scalarSet( [ s, 0 ], src.eGet( s ) );
    }
    else _.assert( 0, 'Unknown type of {-dst-}', _.entity.strType( dst ) );

    return odst;
  }
  else
  {

    let dstDims = Self.DimsOf( dst );
    let srcDims = Self.DimsOf( src );

    if( _.longIs( dst ) )
    dst = this.vectorAdapter.from( dst );

    if( _.matrixIs( dst ) )
    {
      if( dimsIdentical )
      copyDstMatrixSrcMatrixIdentical();
      else
      copyDstMatrixSrcMatrixDifferent();
    }
    else if( _.vectorAdapterIs( dst ) )
    {
      if( dimsIdentical )
      copyDstVadSrcMatrixIdentical();
      else
      copyDstVadSrcMatrixDifferent();
    }
    // else if( _.longIs( dst ) )
    // {
    //   src.scalarEach( function( it )
    //   {
    //     dst[ it.indexLogical ] = it.buffer[ it.offset[ 0 ] ];
    //   });
    // }
    else _.assert( 0, 'Unknown type of {-dst-}', _.entity.strType( dst ) );

  }

  return odst;

  /* */

  function copyDstMatrixSrcMatrixIdentical()
  {
    src.scalarEach( function( it )
    {
      dst.scalarSet( it.indexNd, it.buffer[ it.offset[ 0 ] ] );
    });
  }

  /* */

  function copyDstMatrixSrcMatrixDifferent()
  {
    dst.scalarEach( function( it )
    {
      if( src.hasIndex( it.indexNd ) )
      dst.scalarSet( it.indexNd, src.scalarGet( it.indexNd ) );
      else
      dst.scalarSet( it.indexNd, 0 );
    });
  }

  /* */

  function copyDstVadSrcMatrixIdentical()
  {
    src.scalarEach( function( it )
    {
      dst.eSet( it.indexLogical, it.buffer[ it.offset[ 0 ] ] );
    });
  }

  /* */

  function copyDstVadSrcMatrixDifferent()
  {
    // _.assert( 0, 'not tested' );
    dst.copy( 0 );
    src.scalarEach( function( it )
    {
      dst.eSet( it.indexLogical, it.buffer[ it.offset[ 0 ] ] );
    });
  }

  /* */

}

//

/**
 * Method ExportString() converts source matrix to string.
 *
 * @example
 * var src = _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   3, 4
 * ]);
 * var got = _.Matrix.ExportString( { src : src } );
 * console.log( got );
 * // log :
 * +1, +2,
 * +3, +4,
 *
 * @param { Map } o - Options map.
 * @param { Matrix } o.src - Source matrix.
 * @param { String } o.dst - Destination string, result of conversion appends to it.
 * @param { String } o.how - Returned format, should have value 'nice' to prevent exception.
 * @param { String } o.tab - String inserted before each new line.
 * @param { String } o.dtab - String inserted before each new row.
 * @param { Number } o.precision -  Precision of scalar values.
 * @param { BoolLike } o.usingSign - Prepend sign to scalar values.
 * @returns { String } - Returns formatted string that represents matrix of scalars.
 * @throws { Error } If options map {-o-} has extra options.
 * @throws { Error } If options map {-o-} is not map like.
 * @throws { Error } If {-o.src-} is not an instance of Matrix.
 * @throws { Error } If {-o.dst-} is not a String.
 * @throws { Error } If {-o.tab-} is not a String.
 * @throws { Error } If {-o.dtab-} is not a String.
 * @function ExportString
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function ExportString( o )
{

  o = o || Object.create( null );
  _.routine.options_( ExportString, o );
  _.assert( _.longHas( [ 'nice', 'geometry' ], o.how ) );
  _.assert( _.strIs( o.dst ) );
  _.assert( _.strIs( o.tab ) );
  _.assert( _.strIs( o.dtab ) );

  let tab1 = o.tab + o.dtab;
  let tab2 = o.tab + o.dtab;
  let scalarsPerRow = o.src.scalarsPerRow;
  let scalarsPerCol = o.src.scalarsPerCol;
  let isInt;

  if( o.how === 'nice' )
  niceExport();
  else if( o.how === 'geometry' )
  geometryExport();
  else _.assert( 0 );

  return o.dst;

  /* */

  function geometryExport()
  {

    o.dst += `\n${tab2}dims : ${_.entity.exportString( o.src.dimsEffective || o.src.dims )}`;
    o.dst += `\n${tab2}strides : ${_.entity.exportString( o.src.stridesEffective || o.src.strides )}`;
    o.dst += `\n${tab2}offset : ${_.entity.exportString( o.src.offset || 0 )}`;
    if( o.src.occupiedRange )
    o.dst += `\n${tab2}occupiedRange : ${_.entity.exportString( o.src.occupiedRange )}`;
    if( o.src.buffer )
    o.dst += `\n${tab2}buffer.length : ${o.src.buffer.length}`;

  }

  /* */

  function niceExport()
  {

    _.assert( o.src instanceof Self );

    if( o.withHead )
    {
      o.dst += o.src.headExportString() + ' ::\n';
    }

    if( o.src.dims.length > 2 )
    {
      tab2 = tab2 + o.dtab;
    }

    isInt = true;
    o.src.scalarEach( function( it )
    {
      isInt = isInt && _.intIs( it.buffer[ it.offset[ 0 ] ] );
    });

    if( o.src.dims.length === 2 )
    {

      matrixToStr();

    }
    else if( o.src.dims.length > 2 )
    {

      o.src.layerEach( ( it ) =>
      {
        if( it.indexLogical > 0 )
        o.dst += `\n`;
        o.dst += `${tab1}Layer ${it.indexNd.join( ' ' )}\n`;
        matrixToStr( it.indexNd );
      });

    }
    else _.assert( 0, 'not implemented' );

  }

  /* */

  function matrixToStr( matrixIndexNd )
  {
    let r;

    if( !scalarsPerRow )
    return;

    for( r = 0 ; r < scalarsPerCol ; r += 1 )
    {
      rowToStr( matrixIndexNd, r );
      if( r < scalarsPerCol - 1 )
      o.dst += '\n' + o.tab;
    }

    if( o.src.dims[ 0 ] === Infinity )
    {
      o.dst += '\n';
      for( let c = 0 ; c < scalarsPerRow ; c += 1 )
      o.dst += o.infinityStr + o.scalarDelimeterStr;
    }

  }

  /* */

  function rowToStr( matrixIndexNd, r )
  {
    let row;

    o.dst += tab2;

    if( matrixIndexNd === undefined )
    row = o.src.rowGet( r );
    else
    row = o.src.rowNdGet([ r, ... matrixIndexNd ]);

    for( let c = 0 ; c < scalarsPerRow ; c += 1 )
    {
      eToStr( row.eGet( c ), c === scalarsPerRow-1 );
    }

    if( o.src.dims[ 1 ] === Infinity )
    o.dst += o.scalarDelimeterStr + o.infinityStr;

  }

  /* */

  function eToStr( e, isLast )
  {

    if( isInt )
    {
      if( !o.usingSign || e < 0 )
      o.dst += e.toFixed( 0 );
      else
      o.dst += '+' + e.toFixed( 0 );
    }
    else
    {
      if( _.numberIs( e ) )
      o.dst += e.toFixed( o.precision );
      else
      o.dst += String( e );
    }

    if( !isLast )
    o.dst += o.scalarDelimeterStr;
  }

  /* */

}

ExportString.defaults =
{
  src : null,
  dst : '',
  how : 'nice', /* [ 'nice', 'geometry', 'dims' ] */
  tab : '',
  dtab : '  ',
  scalarDelimeterStr : ' ',
  infinityStr : '...',
  precision : 3,
  usingSign : 1,
  withHead : 1,
  verbosity : 9,
  it : null,
}

//

function exportString( o )
{
  let self = this;
  o = _.routine.options_( exportString, arguments );
  o.src = self;
  let result = self.ExportString( o );
  return result;
}

exportString.defaults =
{
  ... _.mapBut_( null, ExportString.defaults, [ 'src' ] ),
  it : null,
}

//

/**
 * Method dimsExportString() converts dimensions values to string.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 4 ] );
 * var got = matrix.dimsExportString( { dst : 'dims of matrix : ' } );
 * console.log( got );
 * // log : dims of matrix : 3x4
 *
 * @param { Aux } o - Options map.
 * @param { String } o.dst - Destination string, the result of conversion appends to it.
 * @returns { String } - Returns value whether are dimensions of two matrices the same.
 * @method dimsExportString
 * @throws { Error } If {-o-} is not a Aux.
 * @throws { Error } If {-o-} has extra options.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function dimsExportString( o )
{
  let self = this;
  o = _.routine.options_( dimsExportString, arguments );

  o.dst += self.dims[ 0 ]; /* xxx : use _.math.dimsExportString */

  for( let i = 1 ; i < self.dims.length ; i++ )
  o.dst += `x${self.dims[ i ]}`;

  return o.dst;
}

dimsExportString.defaults =
{
  dst : '',
}

//

function headExportString()
{
  let self = this;
  return `Matrix.${_.entity.strType( self.buffer )}.${self.dimsExportString()}`;
}

//

/**
 * Method bufferExport() copies content of the matrix to the buffer {-dst-}.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   3, 4
 * ]);
 * var dst = [ 0, 0, 0, 0 ];
 * var got = matrix.bufferExport( dst );
 * console.log( got );
 * // log : [ 1, 2, 3, 4 ]
 * console.log( got === dst );
 * // log : true
 *
 * @param { Long } dst - Destination buffer.
 * @returns { Long } - Returns destination buffer filled by values of matrix buffer.
 * If {-dst-} is undefined, then method returns copy of matrix buffer.
 * @method bufferExport
 * @throws { Error } If arguments.length is more then one.
 * @throws { Error } If {-dst-} is not a Long.
 * @throws { Error } If number of elements in matrix is not equal to dst.length.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function bufferExport( o )
{
  let self = this;
  let scalarsPerMatrix = self.scalarsPerMatrix;

  if( !_.mapIs( o ) )
  o = { dstBuffer : o };

  _.routine.options_( bufferExport, o );

  if( o.restriding === null )
  o.restriding = self.buffer.length >= scalarsPerMatrix*2;
  if( o.dstObject === null )
  o.dstObject = Object.create( null );

  if( !o.dstBuffer )
  {
    if( o.asFloat )
    {
      if( self.buffer instanceof F64x )
      {
        if( o.restriding )
        o.dstBuffer = self.longType.long.makeUndefined( self.buffer, scalarsPerMatrix );
        else
        o.dstBuffer = self.longType.long.make( F64x, self.buffer );
      }
      else
      {
        if( o.restriding )
        o.dstBuffer = self.longType.long.makeUndefined( F32x, scalarsPerMatrix );
        else
        o.dstBuffer = self.longType.long.make( F32x, self.buffer );
      }
    }
    else
    {
      if( o.restriding )
      o.dstBuffer = self.longType.long.makeUndefined( self.buffer, scalarsPerMatrix );
      else
      o.dstBuffer = self.longType.long.make( self.buffer );
    }
  }

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( _.longIs( o.dstBuffer ) );

  if( o.restriding )
  {
    _.assert
    (
      scalarsPerMatrix === o.dstBuffer.length,
      `Buffer for matrix ${self.dimsExportString()} should have ${scalarsPerMatrix} scalars, but got ${o.dstBuffer.length}`
    );
    self.scalarEach( function( it )
    {
      o.dstBuffer[ it.indexLogical ] = it.buffer[ it.offset[ 0 ] ];
    });
    if( o.dstObject )
    {
      o.dstObject.dims = self.dims;
      o.dstObject.strides = self.StridesFromDimensions( self.dims, false );
      o.dstObject.offset = 0;
      o.dstObject.buffer = o.dstBuffer;
    }
  }
  else
  {
    let occupiedRange = self.occupiedRange;
    let src =
    {
      strides : self.stridesEffective,
      dims : self.dims,
      occupiedRange : occupiedRange,
      buffer : o.dstBuffer,
    }
    _.assert
    (
         0 <= occupiedRange[ 0 ] && occupiedRange[ 0 ] < o.dstBuffer.length
      && 0 <= occupiedRange[ 1 ] && occupiedRange[ 1 ] <= o.dstBuffer.length
      , () => 'Bad buffer for such dimensions and stride', self.ExportString({ how : 'geometry', src })
    );

    let length = o.dstBuffer.length <= self.buffer.length ? o.dstBuffer.length : self.buffer.length;
    for( let i = 0 ; i < length ; i++ )
    o.dstBuffer[ i ] = self.buffer[ i ];

    if( o.dstObject )
    {
      o.dstObject.dims = self.dims;
      o.dstObject.strides = self.strides || self.stridesEffective;
      o.dstObject.offset = self.offset;
      o.dstObject.buffer = o.dstBuffer;
    }
  }

  if( o.dstObject )
  return o.dstObject;
  else
  return o.dstBuffer;
}

bufferExport.defaults =
{
  dstBuffer : null,
  dstObject : 0,
  restriding : null, /* yyy : set to null, later */
  asFloat : 0,
}

//

function bufferImport( o )
{
  let self = this;
  let hasNull;
  let index;

  _.routine.options_( bufferImport, arguments );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.vectorIs( o.buffer ) );

  if( o.dims )
  {
    if( _.vectorAdapterIs( o.dims ) )
    o.dims = o.dims.toLong();
    hasNull = _.longCountElement( o.dims, null );
    _.assert( hasNull <= 1, `The matrix can increase size only along one dimension, but got ${ hasNull } not defined dimensions` );
    index = _.longLeftIndex( o.dims, null );
    o.dims[ index ] = 1;
  }

  if( o.replacing && o.dims )
  {

    if( hasNull )
    {
      let value = o.buffer.length / _.avector.reduceToProduct( o.dims );
      _.assert( _.intIs( value ), 'Expects integer value as dimension' );
      o.dims[ index ] = value;
    }
    else
    {
      _.assert( o.buffer.length >= _.avector.reduceToProduct( o.dims ) );
    }

    self._dimsSet( o.dims );
    moveReplacing1();

  }
  else if( o.replacing && !o.dims )
  {

    _.assert( o.buffer.length >= self.scalarsPerMatrix );
    moveReplacing1();

  }
  else if( !o.replacing && o.dims )
  {

    if( hasNull )
    {
      let value = self.buffer.length / _.avector.reduceToProduct( o.dims );
      _.assert( _.intIs( value ), 'Expects integer value as dimension' );
      o.dims[ index ] = value;
    }
    else
    {
      _.assert( self.buffer.length >= _.avector.reduceToProduct( o.dims ) );
    }

    if( !_.long.identical( self.dims, o.dims ) )
    {
      self._dimsSet( o.dims );
      move();
    }

    bufferMove();

  }
  else if( !o.replacing && !o.dims )
  {

    bufferMove();

  }
  else _.assert( 0 );

  return self;

  /* */

  function move()
  {
    let dims = self.dims;
    self._.offset = 0;
    self._.dimsEffective = null;
    self._.strides = null;
    self._.stridesEffective = self.StridesEffectiveAdjust( self.StridesFromDimensions( dims, o.replacing ? 0 : o.inputRowMajor ), dims );
    self._.occupiedRange = null;
    self._sizeChanged();
  }

  /* */

  function moveReplacing1()
  {
    let dims = self.dims;
    self._.buffer = _.vectorAdapterIs( o.buffer ) ? o.buffer._vectorBuffer : o.buffer;
    move();
  }

  /* */

  function bufferMove()
  {
    _.assert
    (
      self.scalarsPerMatrix === o.buffer.length,
      `Matrix ${self.dimsExportString()} should have ${self.scalarsPerMatrix} scalars, but got ${o.buffer.length}`
    );

    let strides = self.StridesFromDimensions( self.dimsEffective, o.inputRowMajor );

    if( _.vectorAdapterIs( o.buffer ) )
    {
      self.scalarEach( function( it )
      {
        let indexFlat = self._FlatScalarIndexFromIndexNd( it.indexNd, strides ); /* zzz : optimize iterating */
        self.scalarSet( it.indexNd, o.buffer.eGet( indexFlat ) );
      });
    }
    else
    {
      self.scalarEach( function( it )
      {
        let indexFlat = self._FlatScalarIndexFromIndexNd( it.indexNd, strides );
        self.scalarSet( it.indexNd, o.buffer[ indexFlat ] );
      });
    }
  }

}

bufferImport.defaults =
{
  buffer : null,
  inputRowMajor : 1,
  replacing : 0,
  dims : null,
}

//

/**
 * Method toStr() converts current matrix to string.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   3, 4
 * ]);
 * var got = matrix.toStr();
 * console.log( got );
 * // log :
 * +1, +2,
 * +3, +4,
 *
 * @param { Map } o - Options map.
 * @param { String } o.tab - String inserted before each new line.
 * @param { String } o.dtab - String inserted before each new row.
 * @param { Number } o.precision -  Precision of scalar values.
 * @param { BoolLike } o.usingSign - Prepend sign to scalar values.
 * @returns { String } - Returns formatted string that represents matrix of scalars.
 * @method toStr
 * @throws { Error } If options map {-o-} has extra options.
 * @throws { Error } If options map {-o-} is not map like.
 * @throws { Error } If {-o.dst-} is not a String.
 * @throws { Error } If {-o.tab-} is not a String.
 * @throws { Error } If {-o.dtab-} is not a String.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function toStr( o )
{
  let self = this;
  let result = '';

  o = o || Object.create( null );
  _.routine.options_( toStr, o );

  let o2 =
  {
    src : self,
    ... _.mapOnly_( null, o, self.ExportString.defaults ),
  }

  return self.ExportString( o2 );
}

toStr.defaults =
{
  tab : '',
  precision : 3,
  usingSign : 1,
}

toStr.defaults.__proto__ = _.entity.exportString.defaults;

//

/**
 * Method toLong() converts current matrix to a Long.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   3, 4
 * ]);
 * var got = matrix.toLong();
 * console.log( got );
 * // log : Float32Array [ 1, 3, 2, 4 ]
 *
 * @returns { Long } - Returns Long filled by scalars of current matrix.
 * @method toLong
 * @throws { Error } If method calls by not instance of Matrix.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function toLong( o )
{
  let self = this;
  if( arguments.length === 0 )
  o = Object.create( null );
  o = _.routine.options_( toLong, o );

  let result = self.bufferExport({ restriding : o.restriding });
  return result;
}

toLong.defaults =
{
  restriding : 1,
};

//

function toVad( o )
{
  let self = this;
  if( arguments.length === 0 )
  o = Object.create( null );

  let result;
  o = _.routine.options_( toVad, o );

  if( o.restriding )
  {
    result = self.vad.from( self.bufferExport({ restriding : o.restriding }) );
  }
  else
  {
    _.assert( self.ncol <= 1 || self.nrow <= 1 );
    if( self.ncol <= 1 )
    result = self.vad.fromLongLrangeAndStride( self.buffer, self.offset, self.scalarsPerMatrix, self.stridesEffective[ 0 ] );
    else
    result = self.vad.fromLongLrangeAndStride( self.buffer, self.offset, self.scalarsPerMatrix, self.stridesEffective[ 1 ] );
  }

  return result;
}

toVad.defaults =
{
  restriding : 0,
};

// --
// size in bytes
// --

function _sizeGet()
{
  let result = this.sizeOfScalar*this.scalarsPerMatrix;
  _.assert( result >= 0 );
  return result;
}

//

function _sizeOfLayerGet()
{
  let result = this.sizeOfScalar*this.scalarsPerLayer;
  _.assert( result >= 0 );
  return result;
}

//

function _sizeOfElementGet()
{
  let result = this.sizeOfScalar*this.scalarsPerElement;
  _.assert( result >= 0 );
  return result;
}

//

function _sizeOfElementStrideGet()
{
  let result = this.sizeOfScalar*this.strideOfElement;
  _.assert( result >= 0 );
  return result;
}

//

function _sizeOfColGet()
{
  let result = this.sizeOfScalar*this.scalarsPerCol;
  _.assert( result >= 0 );
  return result;
}

//

function _sizeOfColStrideGet()
{
  let result = this.sizeOfScalar*this.strideOfCol;
  _.assert( result >= 0 );
  return result;
}

//

function _sizeOfRowGet()
{
  let result = this.sizeOfScalar*this.scalarsPerRow;
  _.assert( result >= 0 );
  return result;
}

//

function _sizeOfRowStrideGet()
{
  let result = this.sizeOfScalar*this.strideOfRow;
  _.assert( result >= 0 );
  return result;
}

//

function _sizeOfScalarGet()
{
  _.assert( !!this.buffer );
  let result = this.buffer.BYTES_PER_ELEMENT;
  _.assert( result >= 0 );
  return result;
}

// --
// size in scalars
// --

function _scalarsPerColGet()
{
  let self = this;
  let result = self.dimsEffective[ 0 ];
  _.assert( result >= 0 );
  return result;
}

//

function _scalarsPerRowGet()
{
  let self = this;
  let result = self.dimsEffective[ 1 ];
  _.assert( result >= 0 );
  return result;
}

//

function _nrowGet()
{
  let self = this;
  let result = self.dimsEffective[ 0 ];
  _.assert( result >= 0 );
  return result;
}

//

function _ncolGet()
{
  let self = this;
  let result = self.dimsEffective[ 1 ];
  _.assert( result >= 0 );
  return result;
}

//

function _nlayersGet()
{
  let self = this;
  return self._.layersPerMatrix;
}

//

/**
 * Static routine ScalarsPerMatrixForDimensions() calculates quantity of scalars in matrix with defined dimensions.
 *
 * @example
 * var scalars = _.Matrix.ScalarsPerMatrixForDimensions( [ 2, 2 ] );
 * console.log( scalars );
 * // log : 4
 *
 * @param { Array } dims - An array with matrix dimensions.
 * @returns { Number } - Returns quantity of scalars in matrix with defined dimensions.
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-dims-} is not an Array.
 * @throws { Error } If routine is called by instance of Matrix.
 * @static
 * @function ScalarsPerMatrixForDimensions
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function ScalarsPerMatrixForDimensions( dims )
{
  let result = 1;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.longIs( dims ) );

  for( let d = dims.length-1 ; d >= 0 ; d-- )
  {
    _.assert( dims[ d ] >= 0 );
    if( dims[ d ] !== Infinity )
    result *= dims[ d ];
  }

  return result;
}

//

/**
 * Static routine NrowOf() returns number of rows in source Matrix {-src-}.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 5 ] );
 * var rows = _.Matrix.NrowOf( matrix );
 * console.log( rows );
 * // log : 3
 *
 * @param { Matrix|VectorAdapter|Long|Number } src - Source matrix or Long.
 * @returns { Number } - Returns quantity of rows in source matrix.
 * @throws { Error } If {-src-} is not a Matrix, not a VectorAdapter, not a Long or not a Number.
 * @static
 * @function NrowOf
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function NrowOf( src )
{
  if( src instanceof Self )
  return src.dims[ 0 ];
  if( _.numberIs( src ) )
  return 1;
  _.assert( src.length >= 0 );
  return src.length;
}

//

/**
 * Static routine NcolOf() returns number of columns in source Matrix {-src-}.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 5 ] );
 * var cols = _.Matrix.NcolOf( matrix );
 * console.log( cols );
 * // log : 5
 *
 * @param { Matrix|VectorAdapter|Long|Number } src - Source matrix or Long.
 * @returns { Number } - Returns quantity of columns in source matrix.
 * @throws { Error } If {-src-} is not a Matrix, not a VectorAdapter, not a Long or not a Number.
 * @static
 * @function NcolOf
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function NcolOf( src )
{
  if( src instanceof Self )
  return src.dims[ 1 ];
  if( _.numberIs( src ) )
  return 1;
  _.assert( src.length >= 0 );
  return 1;
}

//

/**
 * Static routine DimsOf() returns dimensions of source Matrix {-src-}.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 5 ] );
 * var dims = _.Matrix.DimsOf( matrix );
 * console.log( dims );
 * // log : [ 3, 5 ]
 *
 * @param { Matrix|VectorAdapter|Long|Number } src - Source matrix or Long.
 * @returns { Array } - Returns dimensions in source matrix.
 * @throws { Error } If {-src-} is not a Matrix, not a VectorAdapter, not a Long or not a Number.
 * @static
 * @function DimsOf
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function DimsOf( src )
{
  if( src instanceof Self )
  return src.dims; /* xxx : use _.matrix.dimsOf */
  // return src.dims.slice(); /* yyy */
  if( _.numberIs( src ) )
  return [ 1, 1 ];
  let result = [ 0, 1 ];
  _.assert( !!src && src.length >= 0 );
  result[ 0 ] = src.length;
  return result;
}

//

/**
 * Method flatScalarIndexFrom() finds the index of element in the matrix buffer.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   3, 4
 * ]);
 * var got = matrix.flatScalarIndexFrom( [ 1, 1 ] );
 * console.log( got );
 * // log : 4
 *
 * @param { Array } indexNd - The position of element.
 * @returns { Number } - Returns flat index of element.
 * @method flatScalarIndexFrom
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-src-} is not an Array.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function flatScalarIndexFrom( indexNd )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  let result = self._FlatScalarIndexFromIndexNd( indexNd, self.stridesEffective );

  return result + self.offset;
}

//

function _FlatScalarIndexFromIndexNd( indexNd, strides )
{
  let result = 0;

  if( Config.debug )
  {
    _.assert( arguments.length === 2, 'Expects exactly two arguments' );
    _.assert( _.longIs( indexNd ) );
    _.assert( _.longIs( strides ) );
    _.assert( indexNd.length >= strides.length );
    for( let i = strides.length ; i < indexNd.length ; i++ )
    _.assert( indexNd[ i ] === 0 );
  }

  for( let i = 0 ; i < strides.length ; i++ )
  {
    result += indexNd[ i ]*strides[ i ];
  }

  return result;
}

// --
// stride
// --

function _stridesSet( src )
{
  let self = this;

  _.assert( _.longIs( src ) || src === null );

  if( _.longIs( src ) )
  src = _.longSlice( src );

  self._.strides = src;

  self._sizeChanged();

}

//

function _strideOfElementGet()
{
  return this.stridesEffective[ this.stridesEffective.length-1 ];
}

//

function _strideOfColGet()
{
  return this.stridesEffective[ 1 ];
}

//

function _strideInColGet()
{
  return this.stridesEffective[ 0 ];
}

//

function _strideOfRowGet()
{
  return this.stridesEffective[ 0 ];
}

//

function _strideInRowGet()
{
  return this.stridesEffective[ 1 ];
}

//

function StridesEffectiveFrom( dims, strides, inputRowMajor )
{
  let result;

  _.assert( !!dims );
  _.assert
  (
      !!strides || _.boolLike( inputRowMajor )
    , 'If field {- strides -} is not spefified explicitly then field {- inputRowMajor -} should be specified explicitly.'
  );
  _.assert( dims[ 0 ] >= 0 );
  _.assert( dims[ dims.length-1 ] >= 0 );
  _.assert( arguments.length === 2 || arguments.length === 3 );

  if( strides )
  {
    // result = strides.slice(); /* yyy */
    result = [ ... strides ];
  }
  else
  {
    result = this.StridesFromDimensions( dims, inputRowMajor );
  }

  result = this.StridesEffectiveAdjust( result, dims );

  return result;
}

//

/**
 * Static routine StridesFromDimensions() calculates strides for each dimension taking into account rowMajor value.
 *
 * @example
 * var strides = _.Matrix.StridesFromDimensions( [ 2, 2 ], true );
 * console.log( strides );
 * // log : [ 2, 1 ]
 *
 * @param { Array } dims - Dimensions of a matrix.
 * @param { BoolLike } rowMajor - Options defines rowMajor of the matrix.
 * @returns { Array } - Returns strides for each dimension of the matrix.
 * @throws { Error } If arguments.length is not equal to two.
 * @throws { Error } If {-dims-} is not an Array.
 * @throws { Error } If {-rowMajor-} is not BoolLike.
 * @throws { Error } If elements of {-dims-} is negative number.
 * @static
 * @function StridesFromDimensions
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function StridesFromDimensions( dims, rowMajor )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.longIs( dims ), 'Expects dims' );
  _.assert( _.boolLike( rowMajor ) );
  _.assert( dims[ 0 ] >= 0 );
  _.assert( dims[ dims.length-1 ] >= 0 );

  // let strides = new Array( dims ); /* yyy */
  let strides = [ ... dims ];

  if( rowMajor )
  {
    let ex = strides[ 1 ];
    strides[ 1 ] = strides[ 0 ];
    strides[ 0 ] = ex;
  }

  strides.splice( strides.length-1, 1 );
  strides.unshift( 1 );

  let current = strides[ 0 ];
  for( let i = 1 ; i < strides.length ; i++ )
  {
    current = strides[ i ] = current * normalize( strides[ i ] );
  }

  if( rowMajor )
  {
    let ex = strides[ 1 ];
    strides[ 1 ] = strides[ 0 ];
    strides[ 0 ] = ex;
  }

  // strides = this.StridesEffectiveAdjust( strides, dims );

  if( dims[ 0 ] === Infinity )
  strides[ 0 ] = 0;
  if( dims[ 1 ] === Infinity )
  strides[ 1 ] = 0;

  return strides;

  /* */

  function strideGet( i )
  {

    if( rowMajor )
    if( i === 0 )
    i = 1;
    else if( i === 1 )
    i = 0;

    let result = stride[ i ]

    _.assert( result >= 0 );

    return result;
  }

  /* */

  function normalize( stride )
  {
    if( stride === Infinity )
    return 1;
    return stride;
  }

  /* */

}

//

/**
 * Static routine StridesEffectiveAdjust() analyzes dimensions in argument {-dims-} and normalize strides of a matrix.
 * If the last dimensions of 3D matrix or higher is 1 or Infinity, then strides removes removes.
 *
 * @example
 * var got = _.Matrix.StridesEffectiveAdjust( [ 2, 1, 3, 2 ], [ 2, 2, 1, Infinity ] );
 * console.log( got );
 * // log : [ 2, 1 ]
 *
 * @param { Long } strides - Strides of a matrix.
 * @param { Long } dims - Dimensions of a matrix.
 * @returns { Long } - Returns effective dimensions of a matrix.
 * @throws { Error } If {-strides-} has not valid type.
 * @throws { Error } If {-dims-} has not valid type.
 * @static
 * @function StridesEffectiveAdjust
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function StridesEffectiveAdjust( strides, dims )
{

  _.assert( _.arrayIs( strides ) );
  _.assert( !!dims );
  _.assert( arguments.length === 2 );
  _.assert( strides.length === dims.length );

  if( dims[ 0 ] === Infinity )
  strides[ 0 ] = 0;
  if( dims[ 1 ] === Infinity )
  strides[ 1 ] = 0;

  if( dims.length > 2 )
  if( dims[ dims.length-1 ] === 1 || dims[ dims.length-1 ] === Infinity )
  {
    strides.splice( strides.length-1, 1 );
    for( let i = strides.length-1 ; i >= 2 ; i-- )
    if( dims[ i ] === 1 || dims[ i ] === Infinity )
    strides.splice( i, 1 );
    else
    break;
  }

  return strides;
}

//

/**
 * Static routine StridesRoll() calculates strides offset for each dimension.
 *
 * @example
 * var strides = _.Matrix.StridesRoll( [ 2, 2 ] );
 * console.log( strides );
 * // log : [ 4, 2 ]
 *
 * @param { Array } strides - Strides of a matrix.
 * @returns { Array } - Returns strides for each dimension of the matrix.
 * @throws { Error } If arguments.length is not equal to one.
 * @static
 * @function StridesRoll
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function StridesRoll( strides )
{

  _.assert( arguments.length === 1, 'Expects single argument' );

  for( let s = strides.length-2 ; s >= 0 ; s-- )
  strides[ s ] = strides[ s+1 ]*strides[ s ];

  return strides;
}

// --
// buffer
// --

function bufferSet( src )
{
  let self = this;

  if( self._.buffer === src )
  return;

  if( _.numberIs( src ) )
  src = self.longType.long.make([ src ]);

  _.assert( _.longIs( src ) || src === null );

  self._.buffer = src;
  // self._.buffer = self.longType.make( src );

  if( !self._changing[ 0 ] ) /* zzz : remove */
  {
    self._.offset = 0;
    self._.stridesEffective = null;
  }

  self._sizeChanged();
}

//

function offsetSet( src )
{
  let self = this;

  _.assert( _.numberIs( src ) );

  self._.offset = src;

  self._sizeChanged();

}

//

/**
 * Method bufferNormalize() normalizes buffer of current matrix.
 * Method replaces current matrix buffer by new buffer with only elements of matrix.
 *
 * @example
 * var matrix = _.Matrix
 * ({
 *    buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
 *    dims : [ 2, 2 ],
 *    strides : [ 1, 2 ]
 * });
 * console.log( matrix.buffer );
 * // log : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]
 * matrix.bufferNormalize();
 * console.log( matrix.buffer );
 * // log : [ 1, 2, 3, 4 ]
 *
 * @returns { Undefined } - Returns not a value, changes buffer of current matrix.
 * @method bufferNormalize
 * @throws { Error } If argument is provided.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function bufferNormalize() /* qqq : optimize */ /* Dmytro : it needs clarifications */
{
  let self = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  self.bufferImport
  ({
    buffer : self.toLong(),
    inputRowMajor : 0,
    replacing : 1,
  })

}

// --
// reshaping
// --

function _changeBegin()
{
  let self = this;

  self._changing[ 0 ] += 1;

}

//

function _changeEnd()
{
  let self = this;

  self._changing[ 0 ] -= 1;
  self._sizeChanged();

}

//

function _sizeChanged() /* yyy */
{
  let self = this;

  if( self._changing[ 0 ] )
  return;

  self._adjust();

}

//

function _adjust() /* yyy */
{
  let self = this;

  self._adjustVerify();
  self._adjustAct();
  self._adjustValidate();

}

//

function _adjustAct()
{
  let self = this;

  // self._changing[ 0 ] += 1;

  /* strides */

  if( _.numberIs( self.strides ) )
  {
    let strides = [ 1, 1 ];
    strides[ strides.length-1 ] = self.strides;
    self.strides = self.StridesRoll( strides );
  }

  /* dims */

  _.assert( self.dims === null || _.longIs( self.dims ) );

  if( !self.dims )
  {
    self._dimsDeduceInitial();
  }

  _.assert( _.arrayIs( self.dims ) || _.bufferTypedIs( self.dims ) );

  if( self.buffer === null )
  {
    let lengthFlat = self.ScalarsPerMatrixForDimensions( self.dims );
    self.buffer = self.longType.long.make( lengthFlat );
  }

  self._.dimsEffective = self.DimsEffectiveFrom( self.dims );
  self._.length = self.LengthFrom( self.dims );

  self._.scalarsPerMatrix = _.avector.reduceToProduct( self.dimsEffective );
  self._.scalarsPerLayer = self.dimsEffective[ 0 ] * self.dimsEffective[ 1 ];
  self._.layersPerMatrix = self.scalarsPerMatrix / ( self.dimsEffective[ 0 ] * self.dimsEffective[ 1 ] );

  let lastDim = self.dims[ self.dims.length-1 ];
  if( lastDim === Infinity || lastDim === 0 )
  self._.scalarsPerElement = _.avector.reduceToProduct( self.DimsNormalize( self.dims.slice( 0, self.dims.length-1 ) ) );
  else
  self._.scalarsPerElement = self.scalarsPerMatrix / lastDim;

  /* strides */

  if( !self.stridesEffective )
  {
    self._.stridesEffective = self.StridesEffectiveFrom( self.dims, self.strides, 0 );
  }

  _.assert( self.stridesEffective.length >= 2 );

  /* buffer region */

  let occupiedRange = self.OccupiedRangeFrom( self.dims, self.stridesEffective, self.offset );
  self._.occupiedRange = occupiedRange;
  if( self.scalarsPerMatrix )
  if( self.buffer.length )
  {
    _.assert
    (
         0 <= occupiedRange[ 0 ] && occupiedRange[ 0 ] < self.buffer.length
      && 0 <= occupiedRange[ 1 ] && occupiedRange[ 1 ] <= self.buffer.length
      , () => 'Bad buffer for such dimensions and stride', self.exportString({ how : 'geometry' })
    );
  }

  /* done */

  _.entityFreeze( self.dimsEffective );
  _.entityFreeze( self.dims );
  _.entityFreeze( self.stridesEffective );

  // self._changing[ 0 ] -= 1;
}

//

function _adjustVerify()
{
  let self = this;

  _.assert( _.longIs( self.strides ) || self.strides === null, 'Bad strides' );
  _.assert( _.numberIs( self.offset ) && self.offset >= 0, 'Matrix expects defined non-negative offset' );

}

//

function _adjustValidate()
{
  let self = this;

  if( !Config.debug )
  return

  _.assert( _.arrayIs( self.dims ) || _.bufferTypedIs( self.dims ) );
  _.assert( self.length >= 0 );
  _.assert( self.scalarsPerElement >= 0 );

  _.assert( _.longIs( self.buffer ), 'Matrix needs buffer' );
  _.assert( _.longIs( self.strides ) || self.strides === null );
  _.assert( self.offset >= 0, 'Matrix needs proper offset' );

  _.assert( _.longIs( self.stridesEffective ) );
  _.assert( _.numbersAreInt( self.stridesEffective ) );
  _.assert( self.stridesEffective.length >= 2 );

  _.assert( _.numbersAreAll( self.dims ) );
  _.assert( _.numbersArePositive( self.dims ) );

  _.assert( _.intIs( self.length ) );
  _.assert( self.length >= 0 );
  _.assert( self.dims[ self.dims.length-1 ] === self.length || self.dims[ self.dims.length-1 ] === Infinity );

  for( let d = 0 ; d < self.dims.length-1 ; d++ )
  _.assert( self.dims[ d ] >= 0 );

  if( self.scalarsPerMatrix > 0 && _.numberIsFinite( self.length ) )
  for( let d = 0 ; d < self.dimsEffective.length ; d++ )
  _.assert
  (
    self.offset + ( self.dimsEffective[ d ]-1 )*self.stridesEffective[ d ] <= self.buffer.length
    , () => 'Out of bound' + self.exportString({ how : 'geometry' })
  );

}

//

function _dimsSet( src )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( src )
  {
    _.assert( _.arrayIs( src ) || _.bufferTypedIs( src ) );
    _.assert( src.length >= 2 );
    _.assert( _.numbersAreAll( src ) );
    _.assert( _.numbersArePositive( src ) );
    // _.assert( src[ 0 ] >= 0 );
    // _.assert( src[ src.length-1 ] >= 0 );
    self._.dims = _.entityFreeze( src.slice() );
  }
  else
  {
    self._.dims = null;
  }

  _.assert( self._.dims === null || _.numbersAreAll( self._.dims ) );

  return src;
}

//

function dimsSet( src )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  self._dimsSet( src );

  self._.stridesEffective = null;

  self._sizeChanged();

  return src;
}

//

/**
 * Static routine DimsEffectiveFrom() analyzes dimensions in argument {-dims-} and normalize it.
 * If the last dimensions of 3D matrix or higher is 1 or Infinity, it removes.
 *
 * @example
 * var got = _.Matrix.DimsEffectiveFrom( [ 2, 1, 1, Infinity ] );
 * console.log( got );
 * // log : [ 2, 1 ]
 *
 * @param { Long } dims - Dimensions of a matrix.
 * @returns { Long } - Returns effective dimensions of a matrix.
 * @throws { Error } If {-dims-} has not valid type.
 * @static
 * @function DimsEffectiveFrom
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function DimsEffectiveFrom( dims )
{

  for( let i1 = 0 ; i1 < dims.length ; i1++ )
  if( dims[ i1 ] === Infinity )
  {
    // let dimsEffective = new Array( dims ); /* yyy */
    let dimsEffective = [ ... dims ]; /* yyy */
    dimsEffective[ i1 ] = 1;
    for( let i2 = i1+1 ; i2 < dimsEffective.length ; i2++ )
    if( dimsEffective[ i2 ] === Infinity )
    dimsEffective[ i2 ] = 1;
    dims = dimsEffective;
    break;
  }

  if( dims.length > 2 )
  if( dims[ dims.length-1 ] === 1 )
  {
    // let dimsEffective = new Array( dims ); /* yyy */
    let dimsEffective = [ ... dims ];
    dimsEffective.splice( dims.length-1, 1 );
    for( let i = dimsEffective.length-1 ; i >= 2 ; i-- )
    if( dimsEffective[ i ] === 1 )
    dimsEffective.splice( i, 1 );
    else
    break;
    dims = dimsEffective;
  }

  return dims;
}

//

function DimsNormalize( dims )
{

  for( let i1 = 0 ; i1 < dims.length ; i1++ )
  if( dims[ i1 ] === Infinity )
  {
    let dimsEffective = dims.slice();
    dimsEffective[ i1 ] = 1;
    for( let i2 = i1+1 ; i2 < dimsEffective.length ; i2++ )
    if( dimsEffective[ i2 ] === Infinity )
    dimsEffective[ i2 ] = 1;
    dims = dimsEffective;
    break;
  }

  return dims;
}

//

function _dimsDeduceInitial()
{
  let self = this;

  _.assert( arguments.length === 0 );
  _.assert( self.dims === null );

  // _.assert( _.longIs( self.buffer ), 'Expects buffer' );
  // if( self.buffer.length - self.offset > 0 )
  // {
  //   self._.dims = [ self.buffer.length - self.offset, 1 ];
  //   if( !self.stridesEffective && !self.strides )
  //   self._.stridesEffective = [ 1, self.buffer.length - self.offset ];
  // }
  // else
  // {
  //   self._.dims = [ 1, 0 ];
  //   if( !self.stridesEffective && !self.strides )
  //   self._.stridesEffective = [ 1, 1 ];
  // }
  // return self.dims;

  let o2 = self.DimsDeduceInitial
  ({
    buffer : self.buffer,
    offset : 0,
  });

  if( !self.stridesEffective && !self.strides )
  if( o2.stridesEffective )
  self._.stridesEffective = o2.stridesEffective;
  self._dimsSet( o2.dims );

  return self.dims;
}

//

function DimsDeduceInitial( o )
{

  _.assert( arguments.length === 1 );
  _.assert( _.longIs( o.buffer ), 'Expects buffer' );
  _.map.assertHasAll( o, DimsDeduceInitial.defaults );

  if( o.buffer.length - o.offset > 0 )
  {
    o.dims = [ o.buffer.length - o.offset, 1 ];
    o.stridesEffective = [ 1, o.buffer.length - o.offset ];
  }
  else
  {
    o.dims = [ 1, 0 ];
    o.stridesEffective = [ 1, 1 ];
  }

  return o;
}

DimsDeduceInitial.defaults =
{
  buffer : null,
  offset : 0,
}

//

function DimsDeduceFrom( src, fallbackDims )
{

  _.assert( arguments.length === 1 || arguments.length === 2 );
  if( fallbackDims === undefined )
  fallbackDims = true;

  if( src.dims )
  {
    _.assert( _.numbersAreAll( src.dims ) );
    _.assert( _.numbersArePositive( src.dims ) );
    return src.dims;
  }

  let dim0, dim1;
  let offset = src.offset || 0;

  if( src.scalarsPerCol !== undefined && src.scalarsPerCol !== null )
  {
    dim0 = src.scalarsPerCol;
  }
  else if( src.scalarsPerElement !== undefined && src.scalarsPerElement !== null )
  {
    dim0 = src.scalarsPerElement;
  }
  else if( src.ncol !== undefined && src.ncol !== null )
  {
    dim0 = src.ncol;
  }

  if( src.scalarsPerRow !== undefined && src.scalarsPerRow !== null )
  {
    dim1 = src.scalarsPerRow;
  }
  else if( src.nrow !== undefined && src.nrow !== null )
  {
    dim1 = src.nrow;
  }

/* example :

                ____        ____        _____
  buffer : [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
  offset : 1
  dims : [ 3, 2 ]
  strides : [ 4, 1 ]
  m :
  [
    1 2
    5 6
    9 10
  ]

*/

  // if( _global_.debugger )
  // debugger;

  if( src.buffer )
  {

    if( fallbackDims )
    if( dim0 === undefined && dim1 === undefined && src.strides )
    {
      if( src.strides[ 0 ] > src.strides[ 1 ] )
      {
        dim0 = Math.floor( ( src.buffer.length - offset ) / src.strides[ 0 ] );
      }
      else
      {
        dim1 = Math.floor( ( src.buffer.length - offset ) / src.strides[ 1 ] );
      }
    }

    if( dim0 === undefined && dim1 !== undefined )
    {
      let stride;
      let l = src.buffer.length - offset;
      if( src.strides && src.strides[ 0 ] >= src.strides[ 1 ] )
      {
        stride = src.strides[ 0 ];
        if( dim1 !== undefined && dim1 < src.strides[ 0 ] )
        l += src.strides[ 0 ] - dim1;
      }
      else
      {
        stride = dim1;
      }
      dim0 = Math.floor( l / stride );
    }

    if( dim1 === undefined && dim0 !== undefined )
    {
      let stride;
      let l = src.buffer.length - offset;
      if( src.strides && src.strides[ 1 ] >= src.strides[ 0 ] )
      {
        stride = src.strides[ 1 ];
        if( dim0 !== undefined && dim0 < src.strides[ 1 ] )
        l += src.strides[ 1 ] - dim0;
      }
      else
      {
        stride = dim0;
      }
      dim1 = Math.floor( l / stride );
    }

  }

  if( dim0 === undefined || dim1 === undefined )
  {
    _.assert( dim0 === undefined );
    _.assert( dim1 === undefined );

    if( !fallbackDims )
    return;

    if( _.longIs( fallbackDims ) )
    {
      dim0 = fallbackDims[ 0 ];
      dim1 = fallbackDims[ 1 ];
    }
    else
    {
      dim0 = src.buffer.length - offset;
      dim1 = 1;
    }

  }

  let result = [ dim0, dim1 ];

  _.assert( _.intIs( result[ 0 ] ), 'Cant deduce {- dims -} of the matrix' );
  _.assert( _.intIs( result[ 1 ] ), 'Cant deduce {- dims -} of the matrix' );

  return result;
}

//

/**
 * Static routine LengthFrom() returns length of last dimension of a matrix.
 * If dimension has value Infinity, then it replaces to 1.
 *
 * @example
 * var got = _.Matrix.LengthFrom( [ 2, 2, Infinity ] );
 * console.log( got );
 * // log : 1
 *
 * @param { Long } dims - Dimensions of a matrix.
 * @returns { Long } - Returns length of last dimension of a matrix.
 * @throws { Error } If {-dims-} has not valid type.
 * @static
 * @function LengthFrom
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function LengthFrom( dims )
{
  let result = dims[ dims.length-1 ];
  if( result === Infinity )
  result = 1;
  return result;
}

//

/**
 * Static routine OccupiedRangeFrom() calculates the part of buffer that occupied matrix.
 *
 * @example
 * var got = _.Matrix.OccupiedRangeFrom( [ 2, 2 ], [ 3, 1 ], 5 );
 * console.log( got );
 * // log : [ 5, 10 ]
 *
 * @param { Long } dims - Dimensions of a matrix.
 * @param { Long } strides - Strides of a matrix.
 * @param { Number } offset - Offset of a matrix.
 * @returns { Long } - Returns length of last dimension of a matrix.
 * @throws { Error } If {-dims-} has not valid type.
 * @throws { Error } If {-strides-} has not valid type.
 * @static
 * @function OccupiedRangeFrom
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function OccupiedRangeFrom( dims, strides, offset )
{

  _.assert( arguments.length === 3 );

  let occupiedRange = [ 0, 0 ];

  let extreme = [ 0, 0 ];

  for( let s = 0 ; s < strides.length ; s++ )
  {
    if( dims[ s ] === Infinity )
    continue;

    let delta = dims[ s ] > 0 ? strides[ s ]*( dims[ s ]-1 ) : 0;

    if( delta >= 0 )
    extreme[ 1 ] = extreme[ 1 ] + delta;
    else
    extreme[ 0 ] = extreme[ 0 ] + delta;

  }

  occupiedRange[ 0 ] += extreme[ 0 ];
  occupiedRange[ 1 ] += extreme[ 1 ];
  occupiedRange[ 0 ] += offset;
  occupiedRange[ 1 ] += offset;
  occupiedRange[ 1 ] += 1;

  return occupiedRange;
}

//

/**
 * Static routine ShapesAreSame() compares dimensions of two matrices {-ins1-} and {-ins-}.
 *
 * @example
 * var matrix1 = _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   3, 4
 * ]);
 * var matrix2 = _.Matrix.Make( [ 2, 2 ] );
 * var got = _.Matrix.ShapesAreSame( matrix1, matrix2 );
 * console.log( got );
 * // log : true
 *
 * @param { Matrix|VectorAdapter|Long } ins1 - The source matrix.
 * @param { Matrix|VectorAdapter|Long } ins2 - The source matrix.
 * @returns { Boolean } - Returns value whether are dimensions of two matrices the same.
 * @throws { Error } If routine is called by instance of Matrix.
 * @static
 * @function ShapesAreSame
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function ShapesAreSame( ins1, ins2 )
{
  // _.assert( !_.instanceIs( this ) );

  let dims1 = this.DimsOf( ins1 );
  let dims2 = this.DimsOf( ins2 );

  return _.long.identical( dims1, dims2 );
}

//

/**
 * Method hasShape() compares dimensions of instance with dimensions of source container {-src-}.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   3, 4
 * ]);
 * var got = matrix.hasShape( [ 2, 2 ] );
 * console.log( got );
 * // log : true
 *
 * @param { Array|Matrix } src - The container with dimensions.
 * @returns { Boolean } - Returns value whether are dimensions of two matrices the same.
 * @method hasShape
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-src-} is not an Array, not a Matrix.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function hasShape( src )
{
  let self = this;

  if( src instanceof Self )
  src = src.dims;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.longIs( src ) );

  return _.long.identical( self.dimsEffective, src );
}

// --
// meta
// --

function _metaDefine( how, key, value )
{
  let opts =
  {
    enumerable : false,
    configurable : false,
  }

  if( how === 'get' )
  {
    opts.get = value;
    Object.defineProperty( Self.prototype, key, opts );
  }
  else if( how === 'field' )
  {
    opts.value = value;
    Object.defineProperty( Self.prototype, key, opts );
  }
  else if( how === 'static' )
  {
    opts.get = value;
    Object.defineProperty( Self, key, opts );
    Object.defineProperty( Self.prototype, key, opts );
  }
  else _.assert( 0 );

}

// --
// relations
// --

let bufferSymbol = Symbol.for( 'buffer' );
let offsetSymbol = Symbol.for( 'offset' );
let dimsSymbol = Symbol.for( 'dims' );
let dimsEffectiveSymbol = Symbol.for( 'dimsEffective' );
let stridesSymbol = Symbol.for( 'strides' );
let stridesEffectiveSymbol = Symbol.for( 'stridesEffective' );
let lengthSymbol = Symbol.for( 'length' );
let scalarsPerMatrixSymbol = Symbol.for( 'scalarsPerMatrix' );
let scalarsPerLayerSymbol = Symbol.for( 'scalarsPerLayer' );
let layersPerMatrixSymbol = Symbol.for( 'layersPerMatrix' );
let scalarsPerElementSymbol = Symbol.for( 'scalarsPerElement' );
let occupiedRangeSymbol = Symbol.for( 'occupiedRange' );

//

let Composes =
{

  dims : null,
  // growingDimension : 1,

}

//

let Aggregates =
{
  buffer : null,
}

//

let Associates =
{
  // buffer : null, /* zzz : move buffer here */
}

//

let Restricts =
{

  _changing : [ 1 ], /* zzz : remove */

}

//

let Medials =
{

  strides : null,
  offset : 0,
  scalarsPerElement : null,
  scalarsPerCol : null,
  scalarsPerRow : null,
  ncol : null,
  nrow : null,
  inputRowMajor : null,

}

//

let Statics =
{

  /* */

  Is,
  ExportStructure,
  ExportString,
  CopyTo,

  ScalarsPerMatrixForDimensions,
  NrowOf, /* qqq : cover routine NrowOf. should work for any vector, matrix and scalar */ /* Andrey : covered */
  NcolOf, /* qqq : cover routine NcolOf. should work for any vector, matrix and scalar */ /* Andrey : covered */
  DimsOf, /* qqq : cover routine DimsOf. should work for any vector, matrix and scalar */ /* Andrey : covered */
  _FlatScalarIndexFromIndexNd,

  StridesFromDimensions,
  StridesEffectiveAdjust,
  StridesRoll,
  DimsEffectiveFrom,
  DimsNormalize,
  DimsDeduceInitial,
  DimsDeduceFrom,
  LengthFrom,
  OccupiedRangeFrom,
  ShapesAreSame,

  /* var */

  vectorAdapter : _.vectorAdapter,
  vad : _.vectorAdapter,
  vector : _.vector,

}

//

let Forbids =
{

  stride : 'stride',
  strideInBytes : 'strideInBytes',
  strideInScalars : 'strideInScalars',
  stridePerElement : 'stridePerElement',
  lengthInStrides : 'lengthInStrides',
  dimensions : 'dimensions',
  dimensionsWithLength : 'dimensionsWithLength',
  colLength : 'colLength',
  rowLength : 'rowLength',
  _generator : '_generator',
  usingOptimizedAccessors : 'usingOptimizedAccessors',
  dimensionsDesired : 'dimensionsDesired',
  array : 'array',
  inputRowMajor : 'inputRowMajor',
  inputTransposing : 'inputTransposing',
  breadth : 'breadth',
  _dimsWas : '_dimsWas',
  ncols : 'ncols',
  nrows : 'nrows',
  growingDimension : 'growingDimension',
  long : 'long',

}

/*
zzz : implement fast vad iterator
zzz : optimize scalar iteration
*/

//

let write = { put : _.accessor.putter.symbol, addingMethods : 1 };
let readPut = { put : _.accessor.putter.symbol, addingMethods : 1, set : 0 };
let readOnly = { put : 0, set : 0, addingMethods : 1 };

let Accessors =
{

  /* etc */

  _ : { get : _.accessor.getter.toValue, set : 0, put : 0, strict : 0 },
  buffer : write,
  offset : write,

  /* vectors */

  strides : write,
  dims : write,
  dimsEffective : { set : false },
  occupiedRange : readPut, /* cached */
  stridesEffective : readPut, /* cached */

  /* size in bytes */

  size : readOnly,
  sizeOfLayer : readOnly,
  sizeOfElement : readOnly,
  sizeOfElementStride : readOnly,
  sizeOfCol : readOnly,
  sizeOfColStride : readOnly,
  sizeOfRow : readOnly,
  sizeOfRowStride : readOnly,
  sizeOfScalar : readOnly,

  /* length in scalars */

  scalarsPerElement : readPut, /* cached */
  scalarsPerCol : readOnly,
  scalarsPerRow : readOnly,
  ncol : readOnly,
  nrow : readOnly,
  scalarsPerLayer : readPut, /* qqq : cover */
  scalarsPerMatrix : readOnly,

  strideOfElement : readOnly,
  strideOfCol : readOnly,
  strideInCol : readOnly,
  strideOfRow : readOnly,
  strideInRow : readOnly,

  /* other metrics */

  layersPerMatrix : readPut, /* qqq : cover */
  nlayers : readPut, /* qqq : cover */
  length : readPut, /* cached */

}

// --
// declare
// --

let Extension =
{

  // inter

  init,
  Is,

  _iterate,
  _toStringTag,
  _toPrimitive,
  _accuracyGet,
  _accuracySqrGet,
  _accuracySqrtGet,

  _traverseAct, /* zzz : deprecate */
  _equalAre,

  _longGet,

  // import / export

  ExportStructure,
  exportStructure,
  _exportNormalized,
  copy,

  copyFromScalar,
  copyFromBuffer,
  clone,
  cloneExtending,

  CopyTo,
  ExportString,
  exportString,
  dimsExportString,
  headExportString,
  bufferExport, /* qqq : cover */
  bufferImport,

  toStr,
  toLong,
  toVad, /* qqq : light coverage is required */

  // size in bytes

  _sizeGet,
  _sizeOfLayerGet,

  _sizeOfElementGet,
  _sizeOfElementStrideGet,

  _sizeOfColGet,
  _sizeOfColStrideGet,

  _sizeOfRowGet,
  _sizeOfRowStrideGet,

  _sizeOfScalarGet,

  // length in scalars

  _scalarsPerColGet,
  _scalarsPerRowGet,
  _nrowGet,
  _ncolGet,
  _nlayersGet,

  ScalarsPerMatrixForDimensions,
  NrowOf,
  NcolOf,
  DimsOf,

  flatScalarIndexFrom,
  _FlatScalarIndexFromIndexNd,

  // stride

  _stridesSet, /* cached */

  _strideOfElementGet,
  _strideOfColGet,
  _strideInColGet,
  _strideOfRowGet,
  _strideInRowGet,

  StridesEffectiveFrom,
  StridesFromDimensions,
  StridesEffectiveAdjust,
  StridesRoll,

  // buffer

  bufferSet, /* cached */
  offsetSet, /* cached */

  bufferNormalize,

  // buffer : _.define.accessor({ put : _.accessor.putter.symbol, addingMethods : 1 }),

  // reshaping

  _changeBegin, /* zzz : remove */
  _changeEnd,
  _sizeChanged,

  _adjust,
  _adjustAct,
  _adjustVerify,
  _adjustValidate,

  _dimsSet,
  dimsSet, /* cached */
  DimsEffectiveFrom,
  DimsNormalize,
  _dimsDeduceInitial,
  DimsDeduceInitial,
  DimsDeduceFrom,
  LengthFrom,
  OccupiedRangeFrom,

  ShapesAreSame,
  hasShape,

  // relations

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Medials,
  Statics,
  Forbids,
  Accessors,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Extension,
});

_.Copyable.mixin( Self );

_metaDefine( 'field', Symbol.iterator, _iterate );
_metaDefine( 'get', Symbol.toStringTag, _toStringTag );
_metaDefine( 'field', Symbol.for( 'nodejs.util.inspect.custom' ), _inspectCustom );
_metaDefine( 'field', Symbol.toPrimitive, _toPrimitive );
_metaDefine( 'field', Symbol.for( 'equalAre' ), _equalAre );
_metaDefine( 'field', Symbol.for( 'equalSecondCoerce' ), _equalSecondCoerce );
_metaDefine( 'field', Symbol.for( 'notLong' ), true );

_metaDefine( 'static', 'accuracy', _accuracyGet );
_metaDefine( 'static', 'accuracySqr', _accuracySqrGet );
_metaDefine( 'static', 'accuracySqrt', _accuracySqrtGet );
_metaDefine( 'static', 'longType', _longGet );

_.Matrix = Self;

_.assert( !!_.vectorAdapter );
_.assert( !!_.vectorAdapter.longType );

_.assert( _.object.isBasic( _.withLong ) );
_.assert( _.object.isBasic( _.withLong.Fx ) );
_.assert( _.routineIs( Self.prototype[ Symbol.for( 'equalAre' ) ] ) );

_.assert( Self.prototype.vectorAdapter.longType === Self.vectorAdapter.longType );
_.assert( Self.longType === Self.vectorAdapter.longType );
_.assert( Self.prototype.longType === Self.vectorAdapter.longType );
_.assert( Self.longType === _.vectorAdapter.longType );
_.assert( Self.vectorAdapter === _.vectorAdapter );
_.assert( Self.vad === _.vectorAdapter );
_.assert( Self.vector === _.vector );
_.assert( _.routineIs( Self.prototype.bufferGet ) );
_.assert( _.routineIs( Self.prototype.bufferSet ) );
_.assert( _.routineIs( Self.prototype.bufferPut ) );

})();
