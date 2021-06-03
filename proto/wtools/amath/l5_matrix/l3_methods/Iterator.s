(function _Iterate_s_() {

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
// basic
// --

/**
 * Method scalarWhile() calls callback {-o.onScalar-} for each element of current matrix
 * while callback returns value, which is not equivalent to false.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *    1, 2, 3,
 *    4, 5, 6,
 *    7, 8, 9
 * ]);
 * var got = [];
 * var got = matrix.scalarWhile( ( it ) => got.push( Math.pow( it.indexLogical, 2 ) ) );
 * console.log( got );
 * // log : [ 0, 1, 4, 9, 16, 25, 36, 49, 64 ]
 *
 * @param { Aux|Function } o - Options map or callback.
 * @param { Function } o.onScalar - Callback.
 * Callback {-o.onScalar-} executes on map `it` with next fields : matrix, buffer, args, indexNd,
 * strides, offset, indexLogical.
 * @param { Array|Undefined } o.args - An array of arguments for callback.
 * @returns { * } - Returns the result of callback.
 * @method scalarWhile
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-o-} is not a Map, not a Function.
 * @throws { Error } If options map {-o-} has extra options.
 * @throws { Error } If {-o.args-} is not an Array or not undefined.
 * @throws { Error } If {-o.onScalar-} accepts less or more then one argument.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function scalarWhile( o )
{
  let self = this;
  let result = true;
  let dims = self.dimsEffective;

  if( _.routineIs( o ) )
  o = { onScalar : o };
  if( o.args === undefined )
  o.args = [];

  _.assert( arguments.length === 1 );
  _.routine.options_( scalarWhile, o );
  _.assert( _.arrayIs( o.args ) );
  _.assert( o.onScalar.length === 1 );

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

  return result;

  /* */

  function iterate2()
  {
    let dims0 = dims[ 0 ];
    let dims1 = dims[ 1 ];

    if( dims0 === Infinity )
    dims0 = 1;
    if( dims1 === Infinity )
    dims1 = 1;

    let it = Object.create( null );
    it.matrix = self;
    it.buffer = self.buffer;
    it.args = o.args;
    it.indexNd = [ 0, 0 ];
    it.strides = self.stridesEffective;
    it.offset = [ self.offset, self.offset ];
    let indexLogical = 0;
    let breaking = 0;

    for( let c = 0 ; c < dims1 && !breaking ; c++ )
    {
      it.indexNd[ 1 ] = c;
      for( let r = 0 ; r < dims0 && !breaking ; r++ )
      {
        it.indexNd[ 0 ] = r;
        it.indexLogical = indexLogical;
        result = o.onScalar.call( self, it );
        if( result === false )
        {
          breaking = 1;
          break;
        }
        it.offset[ 0 ] += it.strides[ 0 ];
        indexLogical += 1;
      }
      it.offset[ 1 ] += it.strides[ 1 ];
      it.offset[ 0 ] = it.offset[ 1 ];
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
    it.matrix = self;
    it.buffer = self.buffer;
    it.args = o.args;
    it.indexNd = [ 0, 0, 0 ];
    it.strides = self.stridesEffective;
    it.offset = [ self.offset, self.offset, self.offset ];
    let indexLogical = 0;
    let breaking = 0;

    for( let d2 = 0 ; d2 < dims2 && !breaking ; d2++ )
    {
      it.indexNd[ 2 ] = d2;
      for( let c = 0 ; c < dims1 && !breaking ; c++ )
      {
        it.indexNd[ 1 ] = c;
        for( let r = 0 ; r < dims0 && !breaking ; r++ )
        {
          it.indexNd[ 0 ] = r;
          it.indexLogical = indexLogical;
          result = o.onScalar.call( self, it );
          if( result === false )
          {
            breaking = 1;
            break;
          }
          it.offset[ 0 ] += it.strides[ 0 ];
          indexLogical += 1;
        }
        it.offset[ 1 ] += it.strides[ 1 ];
        it.offset[ 0 ] = it.offset[ 1 ];
      }
      it.offset[ 2 ] += it.strides[ 2 ];
      it.offset[ 1 ] = it.offset[ 2 ];
      it.offset[ 0 ] = it.offset[ 2 ];
    }
  }

  /* */

  function iterateN()
  {

    let it = Object.create( null );
    it.matrix = self;
    it.buffer = self.buffer;
    it.strides = self.stridesEffective;
    it.args = o.args;
    it.indexNd = _.dup( 0, dims.length );
    it.offset = _.dup( self.offset, dims.length );
    it.indexLogical = 0;

    let ranges = [];
    let lastIndex = dims.length - 1;
    for( let i = 0 ; i < dims.length ; i++ )
    ranges.push( [ 0, dims[ i ] ] );

    _.eachInMultiRange_.body
    ({
      ranges,
      onEach : handleEach,
      breaking : 1,
    })

    /* Dmytro : routine `eachInMultiRange_.body` does not use routine `routineOptions`. Routine `routineOptions` exists in `pre` */

    function handleEach( indexNd, indexLogical )
    {
      it.indexNd[ lastIndex ] = indexNd[ lastIndex ];
      it.indexLogical = indexLogical;

      it.offset[ lastIndex ] = it.indexNd[ lastIndex ] * it.strides[ lastIndex ] + self.offset;
      for( let i = dims.length - 2 ; i >= 0 ; i-- )
      {
        it.indexNd[ i ] = indexNd[ i ];
        it.offset[ i ] = it.indexNd[ i ] * it.strides[ i ] + it.offset[ i+1 ];
      }

      result = o.onScalar.call( self, it );

      // if( it.indexNd[ 0 ] + 1 === dims[ 0 ] ) /* Dmytro : imitates counter
      // {
      //   it.offset[ 1 ] += it.strides[ 1 ] === 0 ? dims[ 0 ] : it.strides[ 1 ];
      //   it.offset[ 0 ] = it.offset[ 1 ];
      //   if( it.offset[ 1 ] % it.strides[ dims.length - 1 ] === 0 && it.indexNd[ dims.length - 2 ] === dims[ dims.length - 2 ] - 1 )
      //   {
      //     for( let i = dims.length - 1 ; i >= 2 ; i-- )
      //     it.offset[ i ] = it.offset[ 1 ];
      //   }
      //   else
      //   {
      //     it.offset[ dims.length - 1 ] = it.indexNd[ dims.length - 1 ] * it.strides[ dims.length - 1 ];
      //     for( let i = dims.length - 2 ; i >= 2 ; i-- )
      //     it.offset[ i ] = it.indexNd[ i ] * it.strides[ i ] + it.offset[ i+1 ];
      //   }
      // }

      return result;
    }

  }

}

scalarWhile.defaults =
{
  onScalar : null,
  args : null,
}


// function scalarWhile( o ) /* aaa2 : cover and optimize routine eachInMultiRange. discuss. loook scalarEach */
// {
//   let self = this;
//   let result = true;
//
//   if( _.routineIs( o ) )
//   o = { onScalar : o }
//
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   _.routine.options_( scalarWhile, o );
//   _.assert( _.routineIs( o.onScalar ) );
//
//   let dims = self.dimsEffective;
//   let it = Object.create( null );
//   it.options = o;
//   /* aaa2 : object it should have same field object it of routine scalarEach has */
//
//   _.eachInMultiRange /* aaa2 : split body and pre of routine eachInMultiRange and use eachInMultiRange.body instead */
//   ({
//     ranges : dims,
//     onEach : handleEach,
//   })
//
//   return result;
//
//   function handleEach( indexNd, indexLogical )
//   {
//     it.indexNd = indexNd;
//     it.indexLogical = indexLogical;
//     it.scalar = self.scalarGet( indexNd );
//     // result = o.onScalar.call( self, value, indexNd, indexLogical, o );
//     result = o.onScalar.call( self, it );
//     return result;
//   }
//
// }
//
// scalarWhile.defaults =
// {
//   onScalar : null,
// }

//

/**
 * Method scalarEach() calls callback {-onScalar-} for each element of current matrix.
 * The callback {-onScalar-} applies option map with next fields : matrix, buffer, args, indexNd,
 * strides, offset, indexLogical.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *    1, 2, 3,
 *    4, 5, 6,
 *    7, 8, 9,
 * ]);
 * var got = [];
 * matrix.scalarEach( ( it ) => got.push( Math.pow( it.indexLogical, 2 ) ) );
 * console.log( got );
 * // log : [ 0, 1, 4, 9, 16, 25, 36, 49, 64 ]
 *
 * @param { Aux|Function } o - Options map or callback.
 * @param { Function } o.onScalar - Callback.
 * @param { Array|Undefined } o.args - An array of arguments.
 * @returns { Matrix } - Returns the original matrix.
 * @method scalarEach
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-o-} is not a Map or a Function.
 * @throws { Error } If {-o.args-} is not an Array or not undefined.
 * @throws { Error } If {-o.onScalar-} accepts less or more then one argument.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function scalarEach( o )
{
  let self = this;
  let dims = self.dimsEffective;

  if( _.routineIs( o ) )
  o = { onScalar : o };
  if( o.args === undefined )
  o.args = [];

  _.assert( arguments.length === 1 );
  _.assert( _.arrayIs( o.args ) );
  _.assert( o.onScalar.length === 1 );

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
    dims0 = 1;
    // dims1 = 1;
    if( dims1 === Infinity )
    dims1 = 1;

    let it = Object.create( null );
    it.matrix = self;
    it.buffer = self.buffer;
    it.args = o.args;
    it.indexNd = [ 0, 0 ];
    it.strides = self.stridesEffective;
    it.offset = [ self.offset, self.offset ];
    let indexLogical = 0;
    for( let c = 0 ; c < dims1 ; c++ )
    {
      it.indexNd[ 1 ] = c;
      for( let r = 0 ; r < dims0 ; r++ )
      {
        it.indexNd[ 0 ] = r;
        it.indexLogical = indexLogical;
        o.onScalar.call( self, it );
        it.offset[ 0 ] += it.strides[ 0 ];
        indexLogical += 1;
      }
      it.offset[ 1 ] += it.strides[ 1 ];
      it.offset[ 0 ] = it.offset[ 1 ];
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
    it.matrix = self;
    it.buffer = self.buffer;
    it.args = o.args;
    it.indexNd = [ 0, 0, 0 ];
    it.strides = self.stridesEffective;
    it.offset = [ self.offset, self.offset, self.offset ];
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
          o.onScalar.call( self, it );
          it.offset[ 0 ] += it.strides[ 0 ];
          indexLogical += 1;
        }
        it.offset[ 1 ] += it.strides[ 1 ];
        it.offset[ 0 ] = it.offset[ 1 ];
      }
      it.offset[ 2 ] += it.strides[ 2 ];
      it.offset[ 1 ] = it.offset[ 2 ];
      it.offset[ 0 ] = it.offset[ 2 ];
    }
  }

  /* */

  function iterateN()
  {

    let it = Object.create( null );
    it.matrix = self;
    it.buffer = self.buffer;
    it.strides = self.stridesEffective;
    it.args = o.args;
    it.indexNd = _.dup( 0, dims.length );
    it.offset = _.dup( self.offset, dims.length );
    it.indexLogical = 0;

    let ranges = [];
    let lastIndex = dims.length - 1;
    for( let i = 0 ; i < dims.length ; i++ )
    ranges.push( [ 0, dims[ i ] ] );

    _.eachInMultiRange_.body
    ({
      ranges,
      onEach : handleEach,
      breaking : 0,
    })


    function handleEach( indexNd, indexLogical )
    {
      it.indexNd[ lastIndex ] = indexNd[ lastIndex ];
      it.indexLogical = indexLogical;

      it.offset[ lastIndex ] = it.indexNd[ lastIndex ] * it.strides[ lastIndex ] + self.offset;
      for( let i = dims.length - 2 ; i >= 0 ; i-- )
      {
        it.indexNd[ i ] = indexNd[ i ];
        it.offset[ i ] = it.indexNd[ i ] * it.strides[ i ] + it.offset[ i+1 ];
      }

      return o.onScalar.call( self, it );
    }

  }

  // function iterateN()
  // {
  //   let dims0 = dims[ 0 ];
  //   let dims1 = dims[ 1 ];
  //   // let strides = self.stridesEffective;
  //
  //   if( dims0 === Infinity )
  //   dims0 = 1;
  //   // dims1 = 1;
  //   if( dims1 === Infinity )
  //   dims1 = 1;
  //
  //   let it = Object.create( null );
  //   it.matrix = self;
  //   it.buffer = self.buffer;
  //   it.strides = self.stridesEffective;
  //   it.args = o.args;
  //   it.indexNd = _.dup( 0, dims.length );
  //   it.offset = _.dup( self.offset, dims.length );
  //   let indexLogical = 0;
  //
  //   self.layerEach( ( it2 ) => /* aaa3 : implement without layerEach */ /* Dmytro : implemented */
  //   {
  //
  //     for( let i = 2 ; i < dims.length ; i++ )
  //     it.indexNd[ i ] = it2.indexNd[ i-2 ];
  //
  //     it.offset[ dims.length - 1 ] = it.indexNd[ dims.length - 1 ] * it.strides[ dims.length - 1 ] + self.offset;
  //     for( let i = dims.length - 2 ; i >= 2 ; i-- )
  //     it.offset[ i ] = it.indexNd[ i ] * it.strides[ i ] + it.offset[ i+1 ];
  //     it.offset[ 1 ] = it.offset[ 2 ];
  //     it.offset[ 0 ] = it.offset[ 2 ];
  //
  //     for( let c = 0 ; c < dims1 ; c++ )
  //     {
  //       it.indexNd[ 1 ] = c;
  //       for( let r = 0 ; r < dims0 ; r++ )
  //       {
  //         it.indexNd[ 0 ] = r;
  //         it.indexLogical = indexLogical;
  //         o.onScalar.call( self, it );
  //         it.offset[ 0 ] += it.strides[ 0 ];
  //         indexLogical += 1;
  //       }
  //       it.offset[ 1 ] += it.strides[ 1 ] === 0 ? dims0 : it.strides[ 1 ];
  //       it.offset[ 0 ] = it.offset[ 1 ];
  //     }
  //
  //     /* Dmytro : imitation of counter in cycles */
  //     // if( it.offset[ 1 ] % it.strides[ dims.length - 1 ] === 0 && it.indexNd[ dims.length - 2 ] === dims[ dims.length - 2 ] - 1 )
  //     // {
  //     //   for( let i = dims.length - 1 ; i >= 2 ; i-- )
  //     //   it.offset[ i ] = it.offset[ 1 ];
  //     // }
  //     // else
  //     // {
  //     //   it.offset[ dims.length - 1 ] = it.indexNd[ dims.length - 1 ] * it.strides[ dims.length - 1 ];
  //     //   for( let i = dims.length - 2 ; i >= 2 ; i-- )
  //     //   it.offset[ i ] = it.indexNd[ i ] * it.strides[ i ] + it.offset[ i+1 ];
  //     // }
  //
  //   });
  //
  // }

}

// function scalarEach( onScalar, args ) /* aaa2 : cover routine scalarEach */
// {
//   let self = this;
//   let dims = self.dimsEffective;
//
//   if( args === undefined )
//   args = [];
//
//   _.assert( arguments.length <= 2 );
//   _.assert( _.arrayIs( args ) );
//   _.assert( onScalar.length === 1 );
//
//   if( dims.length === 2 )
//   {
//     iterate2();
//   }
//   else if( dims.length === 3 )
//   {
//     iterate3();
//   }
//   else
//   {
//     iterateN();
//   }
//
//   return self;
//
//   /* */
//
//   function iterate2()
//   {
//     let dims0 = dims[ 0 ];
//     let dims1 = dims[ 1 ];
//
//     if( dims0 === Infinity )
//     dims1 = 1;
//     if( dims1 === Infinity )
//     dims1 = 1;
//
//     let it = Object.create( null ); /* aaa2 : cover all fields of it */
//     it.matrix = self;
//     it.buffer = self.buffer;
//     it.args = args;
//     it.indexNd = [ 0, 0 ];
//     it.strides = self.stridesEffective;
//     it.offset = [ self.offset, self.offset ]; /* aaa2 : cover field it.offset. it.offset[ 0 ] should always point on the current element of the buffer */
//     let indexLogical = 0;
//     for( let c = 0 ; c < dims1 ; c++ )
//     {
//       it.indexNd[ 1 ] = c;
//       for( let r = 0 ; r < dims0 ; r++ )
//       {
//         it.indexNd[ 0 ] = r;
//         it.indexLogical = indexLogical;
//         // it.scalar = self.scalarGet( it.indexNd );
//         onScalar.call( self, it );
//         it.offset[ 0 ] += it.strides[ 0 ];
//         indexLogical += 1;
//       }
//       it.offset[ 1 ] += it.strides[ 1 ];
//       it.offset[ 0 ] = it.offset[ 1 ];
//     }
//   }
//
//   /* */
//
//   function iterate3()
//   {
//     let dims0 = dims[ 0 ];
//     let dims1 = dims[ 1 ];
//     let dims2 = dims[ 2 ];
//
//     if( dims0 === Infinity )
//     dims1 = 1;
//     if( dims1 === Infinity )
//     dims1 = 1;
//
//     let it = Object.create( null );
//     it.matrix = self;
//     it.buffer = self.buffer;
//     it.args = args;
//     it.indexNd = [ 0, 0, 0 ];
//     it.strides = self.stridesEffective;
//     it.offset = [ self.offset, self.offset, self.offset ];
//     let indexLogical = 0;
//
//     for( let d2 = 0 ; d2 < dims2 ; d2++ )
//     {
//       it.indexNd[ 2 ] = d2;
//       for( let c = 0 ; c < dims1 ; c++ )
//       {
//         it.indexNd[ 1 ] = c;
//         for( let r = 0 ; r < dims0 ; r++ )
//         {
//           it.indexNd[ 0 ] = r;
//           it.indexLogical = indexLogical;
//           // it.scalar = self.scalarGet( it.indexNd );
//           onScalar.call( self, it );
//           it.offset[ 0 ] += it.strides[ 0 ];
//           indexLogical += 1;
//         }
//         it.offset[ 1 ] += it.strides[ 1 ];
//         it.offset[ 0 ] = it.offset[ 1 ];
//       }
//       it.offset[ 2 ] += it.strides[ 2 ];
//       it.offset[ 1 ] = it.offset[ 2 ];
//       it.offset[ 0 ] = it.offset[ 2 ];
//     }
//   }
//
//   /* */
//
//   function iterateN()
//   {
//     let dims0 = dims[ 0 ];
//     let dims1 = dims[ 1 ];
//     // let strides = self.stridesEffective;
//
//     if( dims0 === Infinity )
//     dims1 = 1;
//     if( dims1 === Infinity )
//     dims1 = 1;
//
//     let it = Object.create( null );
//     it.matrix = self;
//     it.buffer = self.buffer;
//     it.strides = self.stridesEffective;
//     it.args = args;
//     it.indexNd = _.dup( 0, dims.length );
//     it.offset = _.dup( self.offset, dims.length ); /* aaa2 : implement */
//     let indexLogical = 0;
//
//     self.layerEach( ( it2 ) =>
//     {
//
//       for( let i = 2 ; i < dims.length ; i++ )
//       it.indexNd[ i ] = it2.indexNd[ i-2 ];
//
//       for( let c = 0 ; c < dims1 ; c++ )
//       {
//         it.indexNd[ 1 ] = c;
//         for( let r = 0 ; r < dims0 ; r++ )
//         {
//           it.indexNd[ 0 ] = r;
//           it.indexLogical = indexLogical;
//           // it.scalar = self.scalarGet( it.indexNd );
//           onScalar.call( self, it );
//           it.offset[ 0 ] += it.strides[ 0 ];
//           indexLogical += 1;
//         }
//         it.offset[ 1 ] += it.strides[ 1 ];
//         it.offset[ 0 ] = it.offset[ 1 ]; /* aaa2 : not finished! finish please */
//       }
//
//     });
//
//   }
//
//   /* */
//
// }

//

/**
 * Method layerEach() calls callback {-onMatrix-} for each layer of current matrix.
 * The layer is single 2D matrix of multidimensional matrix.
 * The callback {-onMatrix-} applies option map with next fields : args, indexNd, indexLogical.
 *
 * @example
 * var matrix = _.Matrix.Make([ 2, 3, 2 ]).copy
 * ([
 *    1, 2, 3,
 *    4, 5, 6,
 *    7, 8, 9,
 *    10, 11, 12,
 * ]);
 * var got = [];
 * matrix.layerEach( ( it ) => got.push([ it.indexLogical, it.indexNd ]) );
 * console.log( got );
 * // log : [ [ 0, 0 ], [ 1, 1 ] ]
 *
 * @param { Aux|Function } o - Options map or callback.
 * @param { Function } o.onMatrix - Callback.
 * @param { Array|Undefined } o.args - An array of arguments.
 * @returns { Matrix } - Returns the original matrix.
 * @method layerEach
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-o-} is not a Map or a Function.
 * @throws { Error } If {-o.args-} is not an Array or not undefined.
 * @throws { Error } If {-o.onMatrix-} accepts less or more then one argument.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function layerEach( o )
{
  let self = this;
  let dims = self.dimsEffective;

  if( _.routineIs( o ) )
  o = { onMatrix : o };
  if( o.args === undefined )
  o.args = [];

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.arrayIs( o.args ) );
  _.assert( o.onMatrix.length === 1 );

  let it = Object.create( null );
  it.args = o.args;
  it.indexNd = _.dup( 0, dims.length - 2 );
  it.indexLogical = 0;

  if( !it.indexNd.length )
  {
    o.onMatrix( it );
  }
  else
  {

    for( let i = 2 ; i < dims.length ; i++ )
    if( dims[ i ] === 0 )
    return self;

    do
    {
      o.onMatrix( it );
    }
    while( inc() );
  }

  return self;

  /* */

  function inc()
  {
    let d = 0;

    while( d < dims.length-2 )
    {
      it.indexNd[ d ] += 1;
      if( it.indexNd[ d ] < dims[ d+2 ] )
      {
        it.indexLogical += 1;
        return true;
      }
      it.indexNd[ d ] = 0;
      d += 1;
    }

    return false;
  }

}

// function layerEach( onMatrix, args )
// {
//   let self = this;
//   let dims = self.dimsEffective;
//
//   if( args === undefined )
//   args = [];
//
//   _.assert( arguments.length <= 2 );
//   _.assert( _.arrayIs( args ) );
//   _.assert( onMatrix.length === 1 );
//
//   let it = Object.create( null );
//   it.args = args;
//   it.indexNd = _.dup( 0, dims.length - 2 );
//   it.indexLogical = 0;
//
//   if( !it.indexNd.length )
//   {
//     onMatrix( it );
//   }
//   else
//   {
//
//     for( let i = 2 ; i < dims.length ; i++ )
//     if( dims[ i ] === 0 )
//     return self;
//
//     do
//     {
//       onMatrix( it );
//     }
//     while( inc() );
//   }
//
//   return self;
//
//   function inc()
//   {
//     let d = 0;
//
//     while( d < dims.length-2 )
//     {
//       it.indexNd[ d ] += 1;
//       if( it.indexNd[ d ] < dims[ d+2 ] )
//       {
//         it.indexLogical += 1;
//         return true;
//       }
//       it.indexNd[ d ] = 0;
//       d += 1;
//     }
//
//     return false;
//   }
//
// }

//

/**
 * Method lineEach() calls callback {-onEach-} for each line along of provided dimension current matrix.
 * The callback {-onEach-} applies option map with next fields : buffer, indexNd, offset, line.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *    1, 2, 3,
 *    4, 5, 6,
 *    7, 8, 9,
 * ]);
 * var got = [];
 * matrix.lineEach( 0, ( it ) => got.push( ... it.line, '.' ) );
 * console.log( got );
 * // log : [ 1, 4, 7, '.', 2, 5, 8, '.', 3, 6, 9, '.' ]
 *
 * @param { Number } dimension - An index of dimension : 0 - row, 1, column, 2 - 2D matrix...
 * @param { Function } onEach - Callback.
 * @returns {} - Returns not a value, executes callback for each line along provided dimension of the matrix.
 * @method lineEach
 * @throws { Error } If arguments.length is not 2.
 * @throws { Error } If {-dimension-} is not a Number.
 * @throws { Error } If {-dimension-} is out of range of dimension.length.
 * @throws { Error } If the matrix has not effective dims.
 * @throws { Error } If {-onEach-} is not a Function.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function lineEach( dimension, onEach )
{
  let self = this;
  let stride = self.stridesEffective[ dimension ];
  let dims = self.dimsEffective;
  let length = dims[ dimension ];
  let dimsWithout = dims.slice();
  dimsWithout.splice( dimension, 1 );

  _.assert( arguments.length === 2 );
  _.assert( _.numberIs( dimension ) && 0 <= dimension && dimension < dims.length );
  _.assert( dimsWithout.length >= 1 );
  _.assert( _.routineIs( onEach ) );

  let it = Object.create( null );
  it.buffer = self.buffer;
  it.indexNd = _.dup( 0, dims.length );
  it.indexNd[ dimension ] = null;
  it.offset = _.dup( self.offset, dimsWithout.length );

  if( dimsWithout.length === 1 )
  {
    iterate2();
  }
  else if( dimsWithout.length === 2 )
  {
    iterate3();
  }
  else
  {
    iterateN();
  }

  /* */

  function iterate2()
  {
    let adimension = dimension + 1;
    if( adimension >= dims.length )
    adimension = 0;
    let astride = self.stridesEffective[ adimension ];
    let l = dimsWithout[ 0 ];
    for( let i1 = 0 ; i1 < l ; i1++ )
    {
      it.line = _.vad.fromLongLrangeAndStride( it.buffer, it.offset[ 0 ], length, stride );
      onEach( it );
      it.indexNd[ adimension ] += 1;
      it.offset[ 0 ] += astride;
    }
  }

  /* */

  function iterate3()
  {

    let adimension1 = dimension === 0 ? 1 : 0;
    let adimension2 = dimension === 2 ? 1 : 2;
    let astride1 = self.stridesEffective[ adimension1 ];
    let astride2 = self.stridesEffective[ adimension2 ];
    let l1 = dimsWithout[ 0 ];
    let l2 = dimsWithout[ 1 ];

    for( let i2 = 0 ; i2 < l2 ; i2++ )
    {
      for( let i1 = 0 ; i1 < l1 ; i1++ )
      {
        it.line = _.vad.fromLongLrangeAndStride( it.buffer, it.offset[ 0 ], length, stride );
        onEach( it );
        it.indexNd[ adimension1 ] += 1;
        it.offset[ 0 ] += astride1;
      }
      it.indexNd[ adimension2 ] += 1;
      it.offset[ 1 ] += astride2;
      it.offset[ 0 ] = it.offset[ 1 ];
    }
  }

  /* */

  function iterateN()
  {

    let stridesWithout = self.stridesEffective.slice();
    stridesWithout.splice( dimension, 1 );

    let toWithout = [];
    for( let i1 = 0, i2 = 0 ; i1 < dims.length ; i1++ )
    {
      if( i1 === dimension )
      {
        toWithout[ i1 ] = null;
        continue;
      }
      toWithout[ i1 ] = i2;
      i2 += 1;
    }

    let fromWithout = [];
    for( let i1 = 0, i2 = 0 ; i1 < dimsWithout.length ; i1++ )
    {
      if( i1 === dimension )
      i2 += 1;
      fromWithout[ i1 ] = i2;
      i2 += 1;
    }

    _.eachInMultiRange_
    ({
      ranges : dimsWithout,
      onEach : handleEach,
    })

    function handleEach( indexNd, indexLogical )
    {

      it.line = _.vad.fromLongLrangeAndStride( it.buffer, it.offset[ 0 ], length, stride );

      onEach( it );

      let i = 0;
      it.indexNd[ fromWithout[ i ] ] += 1;
      it.offset[ i ] += stridesWithout[ i ];
      // while( it.indexNd[ fromWithout[ i ] ] >= dimsWithout[ i ] ) /* Dmytro : it can leave range of fromWithout aaa2 : ? */ /* Dmytro : the last index of the fromWithout is ( fromWithout.length - 1 ). If condition does not checks it, then i can be greater */
      while( it.indexNd[ fromWithout[ i ] ] >= dimsWithout[ i ] && i < fromWithout.length - 1 )
      {
        i += 1;
        it.indexNd[ fromWithout[ i ] ] += 1;
        it.offset[ i ] += stridesWithout[ i ];
      }
      while( i > 0 )
      {

        i -= 1;
        it.indexNd[ fromWithout[ i ] ] = 0;
        it.offset[ i ] = it.offset[ i+1 ];
      }

      // it.indexNd = indexNd;
      // it.indexLogical = indexLogical;

      return true;
    }

  }

  /* */

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

  // basic

  scalarWhile,
  scalarEach,
  layerEach,
  lineEach,

  //

  Statics,

}

_.classExtend( Self, Extension );

})();
