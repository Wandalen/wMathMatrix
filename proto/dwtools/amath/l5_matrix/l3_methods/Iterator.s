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
// basic
// --

/**
 * Method scalarWhile() applies callback {-o.onScalar-} to each element of current matrix
 * while callback returns defined value.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.scalarWhile( ( e ) => Math.pow( e, 2 ) );
 * console.log( got );
 * // log : 81
 *
 * @param { Map|Function } o - Options map of callback.
 * @param { Function } o.onScalar - Callback.
 * Callback {-o.onScalar-} applies four arguments : element of matrix, position `indexNd`,
 * flat index `indexFlat`, options map {-o-}.
 * @returns { * } - Returns the result of callback.
 * @method scalarWhile
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-o-} is not a Map, not a Function.
 * @throws { Error } If options map {-o-} has extra options.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function scalarWhile( o ) /* qqq : cover and optimize routine eachInMultiRange. discuss. loook scalarEach */
{
  let self = this;
  let result = true;

  if( _.routineIs( o ) )
  o = { onScalar : o }

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routineOptions( scalarWhile, o );
  _.assert( _.routineIs( o.onScalar ) );

  let dims = self.dimsEffective;
  let it = Object.create( null );
  it.options = o;

  _.eachInMultiRange
  ({
    ranges : dims,
    onEach : handleEach,
  })

  return result;

  function handleEach( indexNd, indexLogical )
  {
    it.indexNd = indexNd;
    it.indexLogical = indexLogical;
    // it.scalar = self.scalarGet( indexNd );
    // result = o.onScalar.call( self, value, indexNd, indexFlat, o );
    result = o.onScalar.call( self, it );
    return result;
  }

}

scalarWhile.defaults =
{
  onScalar : null,
}

//

/**
 * Method scalarEach() applies callback {-onScalar-} to each element of current matrix.
 * The callback {-onScalar-} applies option map with next fields : `indexNd`, `indexFlat`,
 * `indexFlatRowFirst`, `atom`, `args`. Field `args` defines by the second argument.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var storage = [];
 * matrix.scalarEach( ( e ) => { storage.push(  Math.pow( e.atom, 2 ) ) } );
 * console.log( storage );
 * // log : [ 1, 4, 9, 16, 25, 36, 49, 64, 81 ]
 *
 * @param { Function } onScalar - Callback.
 * @param { Array } args - Array for callback.
 * @returns { Matrix } - Returns the original matrix.
 * @method scalarEach
 * @throws { Error } If arguments.length is more then two.
 * @throws { Error } If number of dimensions of matrix is more then two.
 * @throws { Error } If {-args-} is not an Array.
 * @throws { Error } If {-onScalar-} accepts less or more then one argument.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function scalarEach( onScalar, args ) /* qqq2 : cover routine scalarEach */
{
  let self = this;
  let dims = self.dimsEffective;

  if( args === undefined )
  args = [];

  _.assert( arguments.length <= 2 );
  _.assert( _.arrayIs( args ) );
  _.assert( onScalar.length === 1 );

  if( dims.length === 2 )
  {
    iterate2();
  }
  else if( dims.length === 3 )
  {
    iterate3();
  }
  else
  {
    iterateN();
  }

  return self;

  /* */

  function iterate2()
  {
    let dims0 = dims[ 0 ];
    let dims1 = dims[ 1 ];

    if( dims0 === Infinity )
    dims1 = 1;
    if( dims1 === Infinity )
    dims1 = 1;

    let strides = self.stridesEffective;
    let it = Object.create( null ); /* qqq2 : cover all fields of it */
    it.args = args;
    it.indexNd = [ 0, 0 ];
    it.offset = self.offset; /* qqq2 : cover field it.offset. it.offset should always point on the current element of the buffer */
    let indexLogical = 0;
    for( let c = 0 ; c < dims1 ; c++ )
    {
      it.indexNd[ 1 ] = c;
      for( let r = 0 ; r < dims0 ; r++ )
      {
        it.indexNd[ 0 ] = r;
        it.indexLogical = indexLogical;
        it.offset += strides[ 0 ];
        it.scalar = self.scalarGet( it.indexNd );
        onScalar.call( self, it );
        indexLogical += 1;
      }
    }
  }

  /* */

  function iterate3()
  {
    let dims0 = dims[ 0 ];
    let dims1 = dims[ 1 ];
    let dims2 = dims[ 2 ];

    if( dims0 === Infinity )
    dims1 = 1;
    if( dims1 === Infinity )
    dims1 = 1;

    let it = Object.create( null );
    it.args = args;
    it.indexNd = [ 0, 0, 0 ];
    it.offset = self.offset;
    let indexLogical = 0;

    for( let d2 = 0 ; d2 < dims2 ; d2++ )
    {
      it.indexNd[ 2 ] = d2;
      for( let c = 0 ; c < dims1 ; c++ )
      {
        it.indexNd[ 1 ] = c;
        for( let r = 0 ; r < dims0 ; r++ )
        {
          it.indexNd[ 0 ] = r;
          it.indexLogical = indexLogical;
          it.scalar = self.scalarGet( it.indexNd );
          it.offset += strides[ 0 ];
          onScalar.call( self, it );
          indexLogical += 1;
        }
      }
    }
  }

  /* */

  function iterateN()
  {
    let dims0 = dims[ 0 ];
    let dims1 = dims[ 1 ];

    if( dims0 === Infinity )
    dims1 = 1;
    if( dims1 === Infinity )
    dims1 = 1;

    let it = Object.create( null );
    it.args = args;
    it.indexNd = _.dup( 0, dims.length );
    it.offset = self.offset;
    let indexLogical = 0;

    self.sliceEach( ( it2 ) =>
    {

      for( let i = 2 ; i < dims.length ; i++ )
      it.indexNd[ i ] = it2.indexNd[ i-2 ];

      for( let c = 0 ; c < dims1 ; c++ )
      {
        it.indexNd[ 1 ] = c;
        for( let r = 0 ; r < dims0 ; r++ )
        {
          it.indexNd[ 0 ] = r;
          it.indexLogical = indexLogical;
          it.offset += strides[ 0 ];
          it.scalar = self.scalarGet( it.indexNd );
          onScalar.call( self, it );
          indexLogical += 1;
        }
      }

    });

  }

  /* */

}

//

function sliceEach( onMatrix, args )
{
  let self = this;
  let dims = self.dimsEffective;

  if( args === undefined )
  args = [];

  _.assert( arguments.length <= 2 );
  _.assert( _.arrayIs( args ) );
  _.assert( onMatrix.length === 1 );

  let it = Object.create( null );
  it.args = args;
  it.indexNd = _.dup( 0, dims.length - 2 );
  it.indexFlat = 0;

  if( !it.indexNd.length )
  {
    onMatrix( it );
  }
  else
  {

    for( let i = 2 ; i < dims.length ; i++ )
    if( dims[ i ] === 0 )
    return self;

    do
    {
      onMatrix( it );
    }
    while( inc() );
  }

  return self;



  function inc()
  {
    let d = 0;

    while( d < dims.length-2 )
    {
      it.indexNd[ d ] += 1;
      if( it.indexNd[ d ] < dims[ d+2 ] )
      {
        it.indexFlat += 1;
        return true;
      }
      it.indexNd[ d ] = 0;
      d += 1;
    }

    return false;
  }

}

// --
// relations
// --

let Statics =
{
}

// --
// declare
// --

let Extension =
{

  /*

  iterators :

  - map
  - filter
  - reduce
  - zip

  */

  // basic

  scalarWhile,
  scalarEach,
  sliceEach, /* qqq : cover and document */

  //

  Statics,

}

_.classExtend( Self, Extension );

})();
