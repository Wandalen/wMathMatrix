(function _Component_s_() {

'use strict';

const _ = _global_.wTools;
const Parent = null;
const Self = _.Matrix;

// --
// components accessor
// --

/**
 * Method scalarFlatGet() returns value of element by using its flat index.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.scalarFlatGet( 3 );
 * console.log( got );
 * // log : 4
 *
 * @param { Number } index - Index of matrix element.
 * @returns { Number } - Returns the element of matrix by using its flat index.
 * @method scalarFlatGet
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-index-} is not a Number.
 * @throws { Error } If {-index-} is out of range of matrix buffer.
 * @throws { Error } If {-index-} is out of range defined by indexes of matrix element.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function scalarFlatGet( index )
{
  let i = this.offset+index;
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.numberIs( index ) );
  _.assert( i < this.buffer.length );
  _.assert( this.occupiedRange[ 0 ] <= i && i < this.occupiedRange[ 1 ] );
  let result = this.buffer[ i ];
  return result;
}

//

/**
 * Method scalarFlatSet() sets value of element of matrix buffer by using its flat index.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.scalarFlatSet( 3, 1 );
 * console.log( got.toStr() );
 * // log : +1, +2, +3,
 * //       +1, +5, +6,
 * //       +7, +8, +9,
 *
 * @param { Number } index - Index of matrix element.
 * @param { Number } value - The value of element.
 * @returns { Matrix } - Returns the original instance of Matrix with changed buffer.
 * @method scalarFlatSet
 * @throws { Error } If arguments.length is not equal to two.
 * @throws { Error } If {-index-} is not a Number.
 * @throws { Error } If {-index-} is out of range of matrix buffer.
 * @throws { Error } If {-index-} is out of range defined by indexes of matrix element.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function scalarFlatSet( index, value )
{
  let i = this.offset+index;
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.numberIs( index ) );
  _.assert( i < this.buffer.length );
  _.assert( this.occupiedRange[ 0 ] <= i && i < this.occupiedRange[ 1 ] );
  this.buffer[ i ] = value;
  return this;
}

//

/**
 * Method scalarGet() returns value of element using its position in matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.scalarGet( [ 1, 1 ] );
 * console.log( got );
 * // log : 5
 *
 * @param { Array } index - Position of matrix element.
 * @returns { Number } - Returns the element of matrix using its position.
 * @method scalarGet
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-index-} is not an Array.
 * @throws { Error } If {-index-} is out of range of matrix buffer.
 * @throws { Error } If {-index-} is out of range defined by indexes of matrix element.
 * @throws { Error } If any of {-index-} elements is bigger then equivalent dimension value.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function scalarGet( index )
{
  let i = this.flatScalarIndexFrom( index );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( i < this.buffer.length );
  _.assert( this.occupiedRange[ 0 ] <= i && i < this.occupiedRange[ 1 ] );
  _.assert( index[ 0 ] < this.dims[ 0 ] );
  _.assert( index[ 1 ] < this.dims[ 1 ] );
  let result = this.buffer[ i ];
  return result;
}

//

/**
 * Method scalarSet() sets value of matrix element using its position.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.scalarSet( [ 1, 1 ], 1 );
 * console.log( got.toStr() );
 * // log : +1, +2, +3,
 * //       +4, +1, +6,
 * //       +7, +8, +9,
 *
 * @param { Number } index - Position of matrix element.
 * @param { Number } value - The value of element.
 * @returns { Matrix } - Returns the original instance of Matrix with changed buffer.
 * @method scalarSet
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-index-} is not an Array.
 * @throws { Error } If {-index-} is out of range of matrix buffer.
 * @throws { Error } If {-index-} is out of range defined by indexes of matrix element.
 * @throws { Error } If any of {-index-} elements is bigger then equivalent dimension value.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function scalarSet( index, value )
{
  let i = this.flatScalarIndexFrom( index );
  _.assert( _.numberIs( value ) );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( i < this.buffer.length );
  _.assert( this.occupiedRange[ 0 ] <= i && i < this.occupiedRange[ 1 ] );
  _.assert( index[ 0 ] < this.dims[ 0 ] );
  _.assert( index[ 1 ] < this.dims[ 1 ] );
  this.buffer[ i ] = value;
  return this;
}

//

/**
 * Method hasIndex() return true if matrix has element by provided index.
 *
 * @example
 * var matrix = _.Matrix.Make( 3 );
 * var got = matrix.scalarSet( [ 1, 1 ], 1 );
 * console.log( matrix.hasIndex( [0, 0] ) );
 * // true
 * console.log( matrix.hasIndex( [2, 1] ) );
 * // true
 * console.log( matrix.hasIndex( [3, 1] ) );
 * // false
 * console.log( matrix.hasIndex( [ 1 ] ) );
 * // true
 *
 * var matrix = _.Matrix.Make( [ 2, 3, 1 ] )
 * console.log( matrix.hasIndex( [0, 0] ) );
 * // true
 * console.log( matrix.hasIndex( [1, 2, 0] ) );
 * // true
 * console.log( matrix.hasIndex( [1, 2, 1] ) );
 * // false
 *
 * @param { Array } index - Position of matrix element.
 * @returns { Boolean } - Returns whether the matrix has element by index.
 * @method hasIndex
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-index-} is not an Array.
 * @throws { Error } If {-index-} dimension is larger than matrix dimension.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function hasIndex( index )
{
  let self = this;
  let dims = self.dims;
  _.assert( arguments.length === 1, 'Expects exactly one argument' );
  _.assert( _.arrayIs( index ), 'Expects array {-index-}' );
  _.assert( index.length <= dims.length );
  for( let i = 0 ; i < index.length ; i++ )
  {
    if( !( 0 <= index[ i ] && index[ i ] < dims[ i ] ) )
    return false;
  }
  return true;
}

//

/**
 * Method scalarsGet() returns vector of elements with length defined by delta between {-range-} elements.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 1, 9 ] ).copy( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.scalarsGet( [ 2, 5 ] );
 * console.log( got.toStr() );
 * // log : 3.000, 4.000, 5.000
 *
 * @param { Long } range - Range of elements.
 * @returns { VectorAdapter } - Returns the vector from matrix buffer.
 * @method scalarsGet
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-range-} is not a Long.
 * @throws { Error } If range.length is not equal to two.
 * @throws { Error } If instance of matrix is not a row matrix.
 * @throws { Error } If first element of range is bigger then the second.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function scalarsGet( range )
{
  let self = this;

  _.assert( _.longIs( range ) );
  _.assert( range.length === 2 );
  // _.assert( self.breadth.length === 1 );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( range[ 1 ] >= range[ 0 ] );

  debugger;

  let result = self.vectorAdapter.fromLongLrange
  (
    self.buffer,
    self.offset+range[ 0 ],
    ( range[ 1 ]-range[ 0 ] )
  );

  debugger;

  return result;
}

//

/**
 * Method asVector() extracts part of original buffer between first element of matrix and the
 * last element of the matrix.
 *
 * @example
 * var matrix = _.matrix
 * ({
 *   buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
 *   dims : [ 2, 2 ],
 *   strides : [ 2, 3 ],
 * });
 * var got = matrix.asVector();
 * console.log( got.toStr() );
 * // log : 1.000, 2.000, 3.000, 4.000, 5.000, 6.000
 *
 * @returns { VectorAdapter } - Returns the vector from matrix buffer.
 * @method asVector
 * @throws { Error } If argument is provided.
 * @throws { Error } If strides of element is not equal to scalars per element.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function asVector()
{
  let self = this
  let result = null;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( self.strideOfElement === self.scalarsPerElement, 'elementsInRangeGet :', 'cant make single row for elements with extra stride' );

  result = self.vectorAdapter.fromLongLrange
  (
    self.buffer,
    self.occupiedRange[ 0 ],
    self.occupiedRange[ 1 ]-self.occupiedRange[ 0 ]
  );

  return result;
}

// //
//
// /**
//  * Method granuleGet() returns vector extracted from original buffer.
//  *
//  * @param { Array } index - Position of element.
//  * @returns { VectorAdapter } - Returns the vector from matrix buffer.
//  * @method granuleGet
//  * @throws { Error } If {-index-} is not an Array.
//  * @class Matrix
//  * @namespace wTools
//  * @module Tools/math/Matrix
//  */
//
// function granuleGet( index )
// {
//   let self = this;
//   let scalarsPerGranule;
//
//   debugger;
//   _.assert( 0, 'not imlemented' );
//
//   if( index.length < self.stridesEffective.length+1 )
//   scalarsPerGranule = _.avector.reduceToProduct( self.stridesEffective.slice( index.length-1 ) );
//   else
//   scalarsPerGranule = 1;
//
//   let result = self.vectorAdapter.fromLongLrange
//   (
//     this.buffer,
//     this.offset + this.flatGranuleIndexFrom( index ),
//     scalarsPerGranule
//   );
//
//   return result;
// }

//

/**
 * Method elementSlice() makes new vector from default matrix element.
 * For regular 2D matrices it is row, for 3D matrices it is matrix.
 *
 * @example
 * var matrix = _.matrix
 * ({
 *   buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
 *   dims : [ 2, 2 ],
 *   strides : [ 2, 3 ],
 * });
 * var got = matrix.elementSlice( 1 );
 * console.log( got.toStr() );
 * // log : 3.000, 6.000
 *
 * @param { Number } - Index of element.
 * @returns { VectorAdapter } - Returns the vector with default matrix element.
 * @method elementSlice
 * @throws { Error } If {-index-} is not a Number.
 * @throws { Error } If {-index-} is out of matrix length.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function elementSlice( index )
{
  let self = this;
  let result = self.eGet( index );
  return self.vectorAdapter.slice( result );
}

//

/**
 * Method elementsInRangeGet() extracts vector of elements from original buffer.
 * Vector starts from element of matrix defined by first element of range an has length
 * defined by delta between ranges elements.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 1, 9 ] ).copy( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.elementsInRangeGet( [ 2, 5 ] );
 * console.log( got.toStr() );
 * // log : 3.000, 4.000, 5.000
 *
 * @param { Long } range - Range of elements.
 * @returns { VectorAdapter } - Returns the vector from matrix buffer.
 * @method elementsInRangeGet
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-range-} is not a Long.
 * @throws { Error } If range.length is not equal to two.
 * @throws { Error } If instance of matrix is not a row matrix.
 * @throws { Error } If first element of range is bigger then the second.
 * @throws { Error } If strides of element is not equal to scalars per element.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function elementsInRangeGet( range )
{
  let self = this
  let result;

  _.assert( _.longIs( range ) );
  _.assert( range.length === 2 );
  // _.assert( self.breadth.length === 1 );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( range[ 1 ] >= range[ 0 ] );
  _.assert( self.strideOfElement === self.scalarsPerElement, 'elementsInRangeGet :', 'cant make single row for elements with extra stride' );

  result = self.vectorAdapter.fromLongLrange
  (
    self.buffer,
    self.offset+self.strideOfElement*range[ 0 ],
    self.scalarsPerElement*( range[ 1 ]-range[ 0 ] )
  );

  return result;
}

//

/**
 * Method eGet() extracts default matrix element from current matrix.
 * For row matrices it is separate elements, for regular 2D matrices it is row,
 * for 3D matrices it is matrix.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.eGet( 1 );
 * console.log( got.toStr() );
 * // log : 4.000, 5.000, 6.000
 *
 * @param { Number } index - Index of element.
 * @returns { VectorAdapter } - Returns the vector with default matrix element.
 * @method eGet
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-index-} is not a Number.
 * @throws { Error } If dims.length is not equal to two.
 * @throws { Error } If {-index-} is out of matrix.length.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function eGet( index )
{

  _.assert( this.dims.length === 2, 'not implemented' );
  _.assert( 0 <= index && index < this.dims[ this.dims.length-1 ], 'Out of bound' );
  _.assert( _.numberIs( index ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let result = this.vectorAdapter.fromLongLrangeAndStride
  (
    this.buffer,
    this.offset + index*this.stridesEffective[ this.stridesEffective.length-1 ],
    this.dims[ this.dims.length-2 ],
    this.stridesEffective[ this.stridesEffective.length-2 ]
  );

  return result;
}

//

/**
 * Method eSet() sets value of default matrix element.
 * For row matrices it is separate elements, for regular 2D matrices it is row,
 * for 3D matrices it is matrix.
 *
 * @example
 * var matrix = _.Matrix.Make( [ 3, 3 ] ).copy( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.eSet( 1, 0 );
 * console.log( got.toStr() );
 * // log : +1, +2, +3,
 * //       +0, +0, +0,
 * //       +7, +8, +9
 *
 * @param { Number } index - Index of element.
 * @param { Number|Long|VectorAdapter } value - Value to assign to matrix element.
 * @returns { Matrix } - Returns original matrix instance.
 * @method eSet
 * @throws { Error } If arguments.length is not equal to two.
 * @throws { Error } If {-value-} is not a Number, not a Long, not a VectorAdapter.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function eSet( index, srcElement )
{
  let self = this;
  let selfElement = self.eGet( index );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  self.vectorAdapter.assign( selfElement, srcElement );

  return self;
}

//

/**
 * Method elementsSwap() swaps elements of two default matrix elements.
 * For row matrices it is separate elements, for regular 2D matrices it is row,
 * for 3D matrices it is matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.elementsSwap( 0, 2 );
 * console.log( got.toStr() );
 * // log : +7, +8, +9,
 * //       +4, +5, +6,
 * //       +1, +2, +3,
 *
 * @param { Number } i1 - Index of first element.
 * @param { Number } i2 - Index of second element.
 * @returns { Matrix } - Returns original matrix with swapped elements.
 * @method elementsSwap
 * @throws { Error } If arguments.length is not equal to two.
 * @throws { Error } If any of indexes is out of range of elements.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function elementsSwap( i1, i2 )
{
  let self = this;

  _.assert( 0 <= i1 && i1 < self.length );
  _.assert( 0 <= i2 && i2 < self.length );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( i1 === i2 )
  return self;

  let v1 = self.eGet( i1 );
  let v2 = self.eGet( i2 );

  self.vectorAdapter.swapVectors( v1, v2 );

  return self;
}

//

/**
 * Method lineGet() returns line, it is row or column of matrix, taking into account the
 * index of dimensions {-d-}. If {-d-} is 1, then method returns row with index
 * {-index-}, else if {-d-} is 0, then the method returns column.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.lineGet( 1, 2 );
 * console.log( got.toStr() );
 * // log : 7.000, 8.000, 9.000
 *
 * @param { Number } d - Dimension index.
 * @param { Number } index - Index of the line.
 * @returns { VectorAdapter } - Returns vector with row or column of the matrix.
 * @method lineGet
 * @throws { Error } If arguments.length is not equal to two.
 * @throws { Error } If number of dimensions is not equal to two.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function lineGet( d, index )
{
  let self = this;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( self.dims.length === 2 );

  if( d === 0 )
  return self.colGet( index );
  else if( d === 1 )
  return self.rowGet( index );
  else
  _.assert( 0, 'unknown dimension' );

}

// function lineGet_( d, index )
// {
//   let self = this;
//
//   _.assert( arguments.length === 2, 'Expects exactly two arguments' );
//   _.assert( self.dims.length === 2 );
//
//   if( d === 0 )
//   return self.rowGet( index );
//   else if( d === 1 )
//   return self.colGet( index );
//   else
//   _.assert( 0, `Cant get line for dim : ${d}` );
//
// }

//

/**
 * Method lineGet() applies value in source vector {-src-} to line of the matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.lineVectorSet( 1, 2, [ 0, 0, 0 ] );
 * console.log( got.toStr() );
 * // log : +1, +2, +3,
 * //       +4, +5, +6,
 * //       +0, +0, +0,
 *
 * @param { Number } d - Dimension index.
 * If {-d-} is 1, then method returns row with index {-index-}, else if {-d-} is 0, then the method returns column.
 * @param { Number } index - Index of the line.
 * @param { Long|VectorAdapter } src - The source elements.
 * @returns { VectorAdapter } - Returns vector with row or column of the matrix.
 * @method lineGet
 * @throws { Error } If arguments.length is not equal to three.
 * @throws { Error } If number of dimensions is not equal to two.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function lineSet( d, index, src )
{
  let self = this;

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  _.assert( self.dims.length === 2 );

  if( d === 0 )
  return self.colSet( index, src );
  else if( d === 1 )
  return self.rowSet( index, src );
  else
  _.assert( 0, 'unknown dimension' );

}

//

function lineNdGet( d, indexNd )
{
  let self = this;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.longIs( indexNd ) );
  _.assert( d < self.dims.length );

  let indexFull = [ ... indexNd.slice( 0, d ), 0, ... indexNd.slice( d, indexNd.length ) ];
  let indexFlat = self.flatScalarIndexFrom( indexFull );
  let line = _.vectorAdapter.fromLongLrangeAndStride
  (
    self.buffer,
    self.offset + indexFlat,
    self.dimsEffective[ d ] || 1,
    self.stridesEffective[ d ]
  );

  return line;
}

//

/**
 * Method linesSwap() swaps lines of the matrix taking into account index of dimension {-d-}.
 * If {-d-} is 1, then method returns row with index {-index-}, else if {-d-} is 0, then
 * the method returns column.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.linesSwap( 1, 1, 2 );
 * console.log( got.toStr() );
 * // log : +1, +3, +2,
 * //       +4, +6, +5,
 * //       +7, +9, +8,
 *
 * @param { Number } d - Index of dimension.
 * @param { Number } i1 - Index of first line.
 * @param { Number } i2 - Index of second line.
 * @returns { Matrix } - Returns original matrix with swapped lines.
 * @method linesSwap
 * @throws { Error } If arguments.length is not equal to three.
 * @throws { Error } If number of dimensions is not equal to two.
 * @throws { Error } If any of indexes is out of range of lines.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function linesSwap( d, i1, i2 )
{
  let self = this;

  let ad = d+1;
  if( ad > 1 )
  ad = 0;

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  _.assert( self.dims.length === 2 );
  _.assert( 0 <= i1 && i1 < self.dims[ d ] );
  _.assert( 0 <= i2 && i2 < self.dims[ d ] );

  if( i1 === i2 )
  return self;

  let v1 = self.lineGet( ad, i1 );
  let v2 = self.lineGet( ad, i2 );

  self.vectorAdapter.swapVectors( v1, v2 );

  return self;
}

//

// /**
//  * Method rowOfMatrixGet() returns row of matrix taking into account the offset in flat buffer.
//  *
//  * @example
//  * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
//  * var got = matrix.rowOfMatrixGet( [ 0, 0 ], 2 );
//  * console.log( got.toStr() );
//  * // log : 1.000, 2.000, 3.000
//  *
//  * @param { Long|VectorAdapter|Matrix } matrixIndex - Index of matrix.
//  * @param { Number } rowIndex - Index of the row.
//  * @returns { VectorAdapter } - Returns vector with row.
//  * @method rowOfMatrixGet
//  * @throws { Error } If {-matrixIndex-} is not a Long, not a VectorAdapter, not a Matrix.
//  * @class Matrix
//  * @namespace wTools
//  * @module Tools/math/Matrix
//  */
//
// function rowOfMatrixGet( matrixIndex, rowIndex )
// {
//
//   // debugger;
//   // throw _.err( 'not tested' );
//   _.assert( index < this.dims[ 1 ] );
//
//   let matrixOffset = this.flatGranuleIndexFrom( matrixIndex );
//   let result = this.vectorAdapter.fromLongLrangeAndStride
//   (
//     this.buffer,
//     this.offset + rowIndex*this.strideOfRow + matrixOffset,
//     this.scalarsPerRow,
//     this.strideInRow
//   );
//
//   return result;
// }

//

/**
 * Method rowNdGet() returns row of the matrix by its node index.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.rowNdGet( [ 1 ] );
 * console.log( got.toStr() );
 * // log : 4.000, 5.000, 6.000
 *
 * @param { Long } index - Index of the row.
 * @returns { VectorAdapter } - Returns vector with row of the matrix.
 * @method rowNdGet
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If {-index-} is out of range of rows.
 * @throws { Error } If {-index-} is not a Long.
 * @throws { Error } If index.length is equal or greater then number of dimensions.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function rowNdGet( indexNd )
{

  _.assert( 0 <= indexNd[ 0 ] && indexNd[ 0 ] < this.dims[ 0 ], 'Out of bound' );
  _.assert( _.longIs( indexNd ), 'Expects nd index' );
  // _.assert( indexNd.length+1 === this.dims.length );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let matrixIndex = [ indexNd[ 0 ], 0, ... indexNd.slice( 1 ) ];
  // let matrixOffset = this.flatGranuleIndexFrom( matrixIndex );
  // let offset = this.offset + matrixOffset;
  let offset = this.flatScalarIndexFrom( matrixIndex );
  let result = this.vectorAdapter.fromLongLrangeAndStride
  (
    this.buffer,
    offset,
    this.scalarsPerRow,
    this.strideInRow
  );

  return result;
}

//

/**
 * Method rowGet() returns row of the matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.rowGet( 1 );
 * console.log( got.toStr() );
 * // log : 4.000, 5.000, 6.000
 *
 * @param { Number } index - Index of the row.
 * @returns { VectorAdapter } - Returns vector with row of the matrix.
 * @method rowGet
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If number of dimensions is not equal to two.
 * @throws { Error } If {-index-} is out of range of rows.
 * @throws { Error } If {-index-} is not a Number.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function rowGet( index )
{

  _.assert( this.dims.length === 2, 'not implemented' );
  _.assert( 0 <= index && index < this.dims[ 0 ], 'Out of bound' );
  _.assert( _.numberIs( index ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let result = this.vectorAdapter.fromLongLrangeAndStride
  (
    this.buffer,
    this.offset + index*this.strideOfRow,
    this.scalarsPerRow,
    this.strideInRow
  );

  return result;
}

//

/**
 * Method rowSet() assigns values to the row of the matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.rowSet( 1, 5 );
 * console.log( got.toStr() );
 * // log : +1, +2, +3,
 * //       +5, +5, +5,
 * //       +7, +8, +9,
 *
 * @param { Number } rowIndex - Index of the row.
 * @param { Number|Long|VectorAdapter } srcRow - Source value for the row.
 * @returns { Matrix } - Returns original matrix with changed row.
 * @method rowSet
 * @throws { Error } If arguments.length is not equal to two.
 * @throws { Error } If {-srcRow-} is not a Number, not a Long, not a VectorAdapter.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function rowSet( rowIndex, srcRow )
{
  let self = this;
  let selfRow = self.rowGet( rowIndex );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  self.vectorAdapter.assign( selfRow, srcRow );

  return self;
}

//

/**
 * Method rowsSwap() swaps rows of the matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.rowsSwap( 1, 2 );
 * console.log( got.toStr() );
 * // log : +1, +2, +3,
 * //       +7, +8, +9,
 * //       +4, +5, +6,
 *
 * @param { Number } i1 - Index of first row.
 * @param { Number } i2 - Index of second row.
 * @returns { Matrix } - Returns original matrix with swapped rows.
 * @method rowsSwap
 * @throws { Error } If arguments.length is not equal to two.
 * @throws { Error } If number of dimensions is not equal to two.
 * @throws { Error } If any of indexes is out of range of lines.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function rowsSwap( i1, i2 )
{
  let self = this;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  return self.linesSwap( 0, i1, i2 );
}

//

/**
 * Method colGet() returns column of the matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.colGet( 1 );
 * console.log( got.toStr() );
 * // log : 2.000, 5.000, 8.000
 *
 * @param { Number } index - Index of the column.
 * @returns { VectorAdapter } - Returns vector with column of the matrix.
 * @method colGet
 * @throws { Error } If arguments.length is not equal to one.
 * @throws { Error } If number of dimensions is not equal to two.
 * @throws { Error } If {-index-} is out of range of columns.
 * @throws { Error } If {-index-} is not a Number.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function colGet( index )
{

  _.assert( this.dims.length === 2, 'not implemented' );
  _.assert( 0 <= index && index < this.dims[ 1 ], 'Out of bound' );
  _.assert( _.numberIs( index ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let result = this.vectorAdapter.fromLongLrangeAndStride
  (
    this.buffer,
    this.offset + index*this.strideOfCol,
    this.scalarsPerCol,
    this.strideInCol
  );

  return result;
}

//

/**
 * Method colSet() assigns values to the column of the matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.colSet( 1, [ 5, 5, 5 ] );
 * console.log( got.toStr() );
 * // log : +1, +5, +3,
 * //       +4, +5, +6,
 * //       +7, +5, +9,
 *
 * @param { Number } index - Index of the column.
 * @param { Number|Long|VectorAdapter } srcCol - Source value for the column.
 * @returns { Matrix } - Returns original matrix with changed column.
 * @method colSet
 * @throws { Error } If arguments.length is not equal to two.
 * @throws { Error } If {-srcCol-} is not a Number, not a Long, not a VectorAdapter.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function colSet( index, srcCol )
{
  let self = this;
  let selfCol = self.colGet( index );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  self.vectorAdapter.assign( selfCol, srcCol );

  return self;
}

//

/**
 * Method colsSwap() swaps columns of the matrix.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
 * var got = matrix.colsSwap( 1, 2 );
 * console.log( got.toStr() );
 * // log : +1, +3, +2,
 * //       +4, +6, +5,
 * //       +7, +9, +8,
 *
 * @param { Number } i1 - Index of first column.
 * @param { Number } i2 - Index of second second.
 * @returns { Matrix } - Returns original matrix with swapped columns.
 * @method colsSwap
 * @throws { Error } If arguments.length is not equal to two.
 * @throws { Error } If number of dimensions is not equal to two.
 * @throws { Error } If any of indexes is out of range of lines.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function colsSwap( i1, i2 )
{
  let self = this;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  return self.linesSwap( 1, i1, i2 );
}

// --
// relations
// --

let Statics =
{

}

// --
// extension
// --

let Extension =
{

  //

  /* components accessor */

  scalarFlatGet,
  scalarFlatSet,
  scalarGet,
  scalarSet,
  hasIndex, /* qqq : document and test, please */
  scalarsGet,
  asVector,

  // granuleGet,
  elementSlice,
  elementsInRangeGet,
  eGet,
  eSet,
  elementsSwap,

  lineGet,
  // lineGet_,
  lineSet,
  lineNdGet,
  linesSwap,

  // rowOfMatrixGet,
  rowNdGet, /* cover for 2 and many dimensionality */
  rowGet,
  rowSet,
  rowsSwap,

  colGet,
  colSet,
  colsSwap,

  //

  Statics,

}

_.classExtend( Self, Extension );

})();
