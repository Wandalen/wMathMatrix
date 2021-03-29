(function _Transformation_s_() {

'use strict';

const _ = _global_.wTools;
const abs = Math.abs;
const min = Math.min;
const max = Math.max;
const pow = Math.pow;
const pi = Math.PI;
const sin = Math.sin;
const cos = Math.cos;
const sqrt = Math.sqrt;
const sqr = _.math.sqr;

const Parent = null;
const Self = _.Matrix;

// --
// transformer
// --

// function applyMatrixToVector( dstVector )
// {
//   let self = this;
//
//   _.assert( 0, 'deprecated' );
//
//   self.vectorAdapter.matrixApplyTo( dstVector, self );
//
//   return self;
// }

//

// function matrixHomogenousApply( dstVector )
// {
//   let self = this;
//
//   _.assert( arguments.length === 1 )
//   _.assert( 0, 'not tested' );
//
//   self.vectorAdapter.matrixHomogenousApply( dstVector, self );
//
//   return self;
// }

/**
 * The method matrixApplyTo() provides multiplication of current matrix on destination vector {-dst-}.
 * The result of multiplication applies to destination vector.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   3, 4
 * ]);
 * var dstVector = [ 1, 1 ];
 *
 * var got = matrix.matrixApplyTo( dstVector );
 * console.log( got );
 * // log : [ 3, 7 ]
 * console.log( dstVector === got );
 * // log : true
 *
 * @param { VectorAdapter|Long } dstVector - Destination vector, an instance of VectorAdapter or Long.
 * @returns { VectorAdapter } - Returns destination vector with result of multiplication.
 * @method matrixApplyTo
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-dstVector-} is not a Long, not a VectorAdapter.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function matrixApplyTo( dstVector )
{
  let self = this;

  if( self.hasShape([ 3, 3 ]) )
  {

    let dstVectorv = self.vectorAdapter.from( dstVector );
    let x = dstVectorv.eGet( 0 );
    let y = dstVectorv.eGet( 1 );
    let z = dstVectorv.eGet( 2 );

    let s00 = self.scalarGet([ 0, 0 ]), s10 = self.scalarGet([ 1, 0 ]), s20 = self.scalarGet([ 2, 0 ]);
    let s01 = self.scalarGet([ 0, 1 ]), s11 = self.scalarGet([ 1, 1 ]), s21 = self.scalarGet([ 2, 1 ]);
    let s02 = self.scalarGet([ 0, 2 ]), s12 = self.scalarGet([ 1, 2 ]), s22 = self.scalarGet([ 2, 2 ]);

    dstVectorv.eSet( 0 , s00 * x + s01 * y + s02 * z );
    dstVectorv.eSet( 1 , s10 * x + s11 * y + s12 * z );
    dstVectorv.eSet( 2 , s20 * x + s21 * y + s22 * z );

    return dstVector;
  }
  else if( self.hasShape([ 2, 2 ]) )
  {

    let dstVectorv = self.vectorAdapter.from( dstVector );
    let x = dstVectorv.eGet( 0 );
    let y = dstVectorv.eGet( 1 );

    let s00 = self.scalarGet([ 0, 0 ]), s10 = self.scalarGet([ 1, 0 ]);
    let s01 = self.scalarGet([ 0, 1 ]), s11 = self.scalarGet([ 1, 1 ]);

    dstVectorv.eSet( 0 , s00 * x + s01 * y );
    dstVectorv.eSet( 1 , s10 * x + s11 * y );

    return dstVector;
  }

  return self.Mul( dstVector, [ self, dstVector ] );
}

//

/**
 * The method matrixHomogenousApply() calculates the homogenous value for each row
 * of current matrix and applies it to the destination vector {-dst-}.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 0, 0, 0,
 *   0, 1, 0, 0,
 *   0, 0, 1, 0,
 *   0, 0, 1, 0,
 * ]);
 *
 * var dstVector = [ 1, 2, 1 ];
 *
 * var got = matrix.matrixHomogenousApply( dstVector );
 * console.log( got );
 * // log : [ 1, 2, 1 ]
 * console.log( got === dstVector );
 * // log : true
 *
 * @param { VectorAdapter|Long } dstVector - Destination vector, an instance of VectorAdapter or Long.
 * @returns { VectorAdapter } - Returns the vector with homogenous values.
 * @method matrixHomogenousApply
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-dstVector-} is not a Long, not a VectorAdapter.
 * @throws { Error } If dst.length is not equal to number of columns of matrix decremented by 1.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function matrixHomogenousApply( dstVector )
{
  let self = this;
  let _dstVector = self.vectorAdapter.from( dstVector );
  let dstLength = dstVector.length;
  let ncol = self.ncol;
  let nrow = self.nrow;
  let result = new Array( nrow );

  _.assert( arguments.length === 1 );
  _.assert( dstLength === ncol-1 );

  result[ dstLength ] = 0;
  for( let i = 0 ; i < nrow ; i += 1 )
  {
    let row = self.rowGet( i );

    result[ i ] = 0;
    for( let j = 0 ; j < dstLength ; j++ )
    result[ i ] += row.eGet( j ) * _dstVector.eGet( j );

    result[ i ] += row.eGet( dstLength );

  }

  for( let j = 0 ; j < dstLength ; j++ )
  _dstVector.eSet( j, result[ j ] / result[ dstLength ] );

  return dstVector;
}

//

/**
 * The method matrixDirectionsApply() calculates directions of matrix and applies it to
 * destination vector {-dstVector-}.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   4, 0, 1,
 *   0, 5, 2,
 *   0, 0, 1,
 * ]);
 *
 * var dst = _.vectorAdapter.fromLong( [ 1, 1 ] );
 *
 * var got = matrix.matrixDirectionsApply( dstVector );
 * console.log :
 * // log : [ 4, 5 ]
 * console.log( got === dst );
 * // log : true
 *
 * @param { VectorAdapter|Long } dstVector - Destination vector.
 * @returns { VectorAdapter } - Returns destination vector with changed values.
 * @method matrixDirectionsApply
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-dstVector-} is not a Long, not a VectorAdapter.
 * @throws { Error } If dst.length is not equal to number of columns of matrix decremented by 1.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function matrixDirectionsApply( dstVector )
{
  let self = this;
  let dstLength = dstVector.length;
  let ncol = self.ncol;
  let nrow = self.nrow;

  _.assert( arguments.length === 1 );
  _.assert( dstLength === ncol-1 );

  debugger;

  // Self.mul( v, [ self.submatrix([ [ 0, v.length ], [ 0, v.length ] ]), v ] ); /* Dmytro : unknown variable v. Please, clarify this moment */
  // self.vectorAdapter.normalize( v );
  Self.mul( dstVector, [ self.submatrix([ [ 0, dstVector.length ], [ 0, dstVector.length ] ]), dstVector ] );
  self.vectorAdapter.normalize( dstVector );

  return dstVector;
}

//

/**
 * The method positionGet() gets the vector from last column of matrix.
 * The vector has length equivalent to row length decremented by one.
 *
 * @example
 * var buffer = _.Matrix.MakeSquare
 * ([
 *   +2, +2, +2,
 *   +2, +3, +4,
 *   +4, +3, -2,
 * ]);
 *
 * var got = matrix.positionGet();
 * console.log( got.toStr() );
 * // log : 2.000 4.000
 *
 * @returns { VectorAdapter } - Returns vector from last column of the matrix.
 * @method positionGet
 * @throws { Error } If arguments are passed.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function positionGet()
{
  let self = this;
  let l = self.length;
  let loe = self.scalarsPerElement;
  let result = self.colGet( l-1 );

  _.assert( arguments.length === 0, 'Expects no arguments' );

  // debugger;
  result = self.vectorAdapter.fromLongLrange( result, 0, loe-1 );

  //let result = self.elementsInRangeGet([ (l-1)*loe, l*loe ]);
  //let result = self.vectorAdapter.fromLongLrange( this.buffer, 12, 3 );

  return result;
}

//

/**
 * The method positionSet() assigns vector {-src-} to the vector maiden from last column
 * of the matrix. The column does not include last element.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   +6, +4, +6,
 *   +8, +0, +4
 *   +0, +0, +12,
 * ]);
 *
 * var src = [ 4, 4 ];
 *
 * var got = matrix.positionSet( src );
 * console.log( got );
 * // log : 4.000, 4.000
 *
 * @param { Long|VectorAdapter } src - Source vector.
 * @returns { VectorAdapter } - Returns vector specified by the matrix.
 * @method positionSet
 * @throws { Error } If src.length is equal or great then length of the matrix row.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function positionSet( src )
{
  let self = this;
  src = self.vectorAdapter.fromLong( src );
  let dst = this.positionGet();

  _.assert( src.length === dst.length );

  self.vectorAdapter.assign( dst, src );
  return dst;
}

//

/**
 * The method scaleMaxGet() returns maximum value of scale of the matrix.
 *
 * @example
 * var buffer = _.Matrix.MakeSquare
 * ([
 *   2,  2,  2,
 *   2,  3,  4,
 *   4,  3, -2,
 * ]);
 *
 * var dst = _.vectorAdapter.fromLong( [ 0, 0 ] );
 *
 * var got = matrix.scaleMaxGet( dst )
 * console.log( got);
 * // log : 3.605551275463989
 *
 * @param { Long|VectorAdapter } dst - Destination vector for scales.
 * @returns { Number } - Returns maximum value of scale of the matrix.
 * @method scaleMaxGet
 * @throws { Error } If {-dst-} is not an instance of VectorAdapter or Array.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function scaleMaxGet( dst )
{
  let self = this;
  let scale = self.scaleGet( dst );
  let result = _.avector.reduceToMaxAbs( scale ).value;
  return result;
}

//

/**
 * The method scaleMeanGet() returns medium value of scale of the matrix.
 *
 * @example
 * var buffer = _.Matrix.MakeSquare
 * ([
 *   2,  2,  2,
 *   2,  3,  4,
 *   4,  3, -2,
 * ]);
 *
 * var dst = _.vectorAdapter.fromLong( [ 0, 0 ] );
 *
 * var got = matrix.scaleMeanGet( dst )
 * console.log( got);
 * // log : 3.2169892001050897
 *
 * @param { VectorAdapter } dst - Destination vector for scales.
 * @returns { Number } - Returns medium value of scales of the matrix.
 * @method scaleMeanGet
 * @throws { Error } If {-dst-} is not an instance of an Long or a VectorAdapter.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function scaleMeanGet( dst )
{
  let self = this;
  let scale = self.scaleGet( dst );
  let result = _.avector.reduceToMean( scale );
  return result;
}

//

/**
 * The method scaleMagGet() returns magnitude of matrix scale.
 *
 * @example
 * var buffer = _.Matrix.MakeSquare
 * ([
 *   2,  2,  2,
 *   2,  3,  4,
 *   4,  3, -2,
 * ]);
 *
 * var dst = _.vectorAdapter.fromLong( [ 0, 0 ] );
 *
 * var got = matrix.scaleMagGet( dst )
 * console.log( got);
 * // log : 4.58257569495*-584
 *
 * @param { Long|VectorAdapter } dst - Destination vector for scales.
 * @returns { Number } - Returns magnitude of scale specified by the matrix.
 * @method scaleMagGet
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-dst-} is not a Long, not a VectorAdapter.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function scaleMagGet( dst )
{
  let self = this;
  let scale = self.scaleGet( dst );
  let result = _.avector.mag( scale );
  return result;
}

//

/**
 * The method scaleGet() returns scale of the matrix.
 *
 * @example
 * var buffer = _.Matrix.MakeSquare
 * ([
 *   2, 2, 2,
 *   2, 3, 4,
 *   4, 3, -2,
 * ]);
 *
 * var dst = _.vectorAdapter.fromLong( [ 0, 0 ] );
 *
 * var got = matrix.scaleGet( dst );
 * console.log( got );
 * // log : [ 2.828, 3.606 ]
 *
 * @param { Long|VectorAdapter } dst - Destination vector.
 * @returns { Long } - Returns destination long with scales of the matrix.
 * @method scaleGet
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-dst-} is not a Long, not a VectorAdapter.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function scaleGet( dst )
{
  let self = this;
  let l = self.length-1;
  let loe = self.scalarsPerElement;

  if( dst )
  {
    if( _.arrayIs( dst ) )
    dst.length = self.length-1;
  }

  if( dst ) /* Dmytro : bug if dst is not an Array */
  l = dst.length;
  else
  dst = self.vectorAdapter.from( self.longType.longMakeZeroed( self.length-1 ) );

  let dstv = self.vectorAdapter.from( dst );

  _.assert( arguments.length === 0 || arguments.length === 1 );

  for( let i = 0 ; i < l ; i += 1 )
  dstv.eSet( i , self.vectorAdapter.mag( self.vectorAdapter.fromLongLrange( this.buffer, loe*i, loe-1 ) ) );

  return dst;
}

//

/**
 * The method matrix.scaleSet() returns scaled instance of Matrix, takes source from context.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   3, 2, 3,
 *   4, 0, 2,
 *   0, 0, 6,
 * ]);
 *
 * var src = _.vectorAdapter.fromLong( [ 0, 0 ] );
 *
 * var got = matrix.scaleSet( src );
 * console.log( got);
 * // log :
 * // +0 +0 +0.5
 * // +0 +0 +0.33
 * // +0 +0 +1
 *
 * @param { VectorAdapter|Long } src - Source vector.
 * @returns { Matrix } - Returns scaled instance of Matrix.
 * @method scaleSet
 * @throws { Error } If arguments.length is not 1.
 * @throws { Error } If {-src-} is not an instance of VectorAdapter or Long.
 * @throws { Error } If src.length is not equal to self.length decremented by 1.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function scaleSet( src )
{
  let self = this;
  src = self.vectorAdapter.fromLong( src );
  let l = self.length;
  let loe = self.scalarsPerElement;
  let cur = this.scaleGet();

  _.assert( src.length === l-1 );

  for( let i = 0 ; i < l-1 ; i += 1 )
  self.vectorAdapter.mul( self.eGet( i ), src.eGet( i ) / cur[ i ] );

  let lastElement = self.eGet( l-1 );
  self.vectorAdapter.mul( lastElement, 1 / lastElement.eGet( loe-1 ) );

}

//

/**
 * The method matrix.scaleAroundSet() returns scaled matrix instance of around provided vector {-center-}, takes source from context.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2, 0,
 *   0, 4, 1,
 *   1, 0, 0,
 * ]);
 *
 * var scale = _.vectorAdapter.fromLong( [ 0, 0 ] );
 * var center = _.vectorAdapter.fromLong( [ 2, 3 ] );
 *
 * var got = matrix.scaleAroundSet( src );
 * console.log( got);
 * // log :
 * // +0 +0 +2
 * // +0 +0 +3
 * // +0 +0 +0
 *
 * @param { VectorAdapter|Long } scale - the instance of VectorAdapter or Long.
 * @param { VectorAdapter|Long } center - the instance of VectorAdapter or Long.
 * @returns { Matrix } - Returns scaled instance of Matrix.
 * @method scaleAroundSet
 * @throws { Error } If {-center-} is not an instance of VectorAdapter or Long.
 * @throws { Error } If {-scale-} is not an instance of VectorAdapter or Long.
 * @throws { Error } If (scale.length) is not equal (self.length) decrementing by 1.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function scaleAroundSet( scale, center )
{
  let self = this;
  scale = self.vectorAdapter.fromLong( scale );
  let l = self.length;
  let loe = self.scalarsPerElement;
  let cur = this.scaleGet();

  _.assert( scale.length === l-1 );

  for( let i = 0 ; i < l-1 ; i += 1 )
  self.vectorAdapter.mul( self.eGet( i ), scale.eGet( i ) / cur[ i ] );

  let lastElement = self.eGet( l-1 );
  self.vectorAdapter.mul( lastElement, 1 / lastElement.eGet( loe-1 ) );

  /* */

  debugger;
  center = self.vectorAdapter.fromLong( center );
  let pos = self.vectorAdapter.slice( scale );
  pos = self.vectorAdapter.fromLong( pos );
  self.vectorAdapter.mul( pos, -1 );
  self.vectorAdapter.add( pos, 1 );
  self.vectorAdapter.mul( pos, center );
  // self.vectorAdapter.mulScalar( pos, -1 );
  // self.vectorAdapter.addScalar( pos, 1 );
  // self.vectorAdapter.mulVectors( pos, center );

  self.positionSet( pos );

}

//

/**
 * The method matrix.scaleApply() changes source vector {-src-}, takes source from context.
 *
 * @example
 * var matrix = _.Matrix.MakeSquare
 * ([
 *   1, 2, 0,
 *   0, 4, 1,
 *   1, 0, 0,
 * ]);
 *
 * var src = _.vectorAdapter.fromLong( [ 2, 3 ] );
 *
 * var got = matrix.scaleApply( src );
 * console.log( got);
 * // log : undefined
 *
 * @param { VectorAdapter|Long } src - the instance of VectorAdapter or Long.
 * @returns { Undefined } - Returns not a value, change source vector {-src-}.
 * @method scaleApply
 * @throws { Error } If {-src-} is not an instance of VectorAdapter or Long.
 * @throws { Error } If (arguments.length) is not 1.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function scaleApply( src )
{
  let self = this;
  src = self.vectorAdapter.fromLong( src );
  let ape = self.scalarsPerElement;
  let l = self.length;

  for( let i = 0 ; i < ape ; i += 1 )
  {
    let c = self.rowGet( i );
    c = self.vectorAdapter.fromLongLrange( c, 0, l-1 );
    self.vectorAdapter.mul( c, src );
    // self.vectorAdapter.mulVectors( c, src );
  }

}

//

function matrixRotationGet()
{
  let self = this;

  let dst = self.clone();

  _.assert( self.dims[ 0 ] === 4 );
  _.assert( self.dims[ 1 ] === 4 );
  _.assert( arguments.length === 0 );

  let ape = self.scalarsPerElement;
  let l = self.length;
  let scale = self.scaleGet();

  for( let i = 0 ; i < ape ; i += 1 )
  {
    let c = dst.rowGet( i );
    c = dst.vectorAdapter.fromLongLrange( c, 0, l-1 );

    for( let j = 0; j < c.length; j++ )
    {
      let s = scale.eGet( j );
      if( s === 0 )
      continue;
      c.eSet( j, c.eGet( j ) / s );
    }
  }

  dst.colSet( 3, [ 0, 0, 0, 1 ] );

  return dst;
}

matrixRotationGet.shaderChunkName = 'matrixRotationGet';
matrixRotationGet.shaderChunk =
`
mat4 matrixRotationGet ( mat4 matrixLocal )
{
  mat4 rotationMatrix = matrixLocal;

  float sx = sqrt( matrixLocal[ 0 ][ 0 ]*matrixLocal[ 0 ][ 0 ] + matrixLocal[ 0 ][ 1 ]*matrixLocal[ 0 ][ 1 ] + matrixLocal[ 0 ][ 2 ]*matrixLocal[ 0 ][ 2 ] );
  float sy = sqrt( matrixLocal[ 1 ][ 0 ]*matrixLocal[ 1 ][ 0 ] + matrixLocal[ 1 ][ 1 ]*matrixLocal[ 1 ][ 1 ] + matrixLocal[ 1 ][ 2 ]*matrixLocal[ 1 ][ 2 ] );
  float sz = sqrt( matrixLocal[ 2 ][ 0 ]*matrixLocal[ 2 ][ 0 ] + matrixLocal[ 2 ][ 1 ]*matrixLocal[ 2 ][ 1 ] + matrixLocal[ 2 ][ 2 ]*matrixLocal[ 2 ][ 2 ] );

  rotationMatrix[ 0 ][ 0 ] = rotationMatrix[ 0 ][ 0 ] / sx;
  rotationMatrix[ 1 ][ 0 ] = rotationMatrix[ 1 ][ 0 ] / sy;
  rotationMatrix[ 2 ][ 0 ] = rotationMatrix[ 2 ][ 0 ] / sz;

  rotationMatrix[ 0 ][ 1 ] = rotationMatrix[ 0 ][ 1 ] / sx;
  rotationMatrix[ 1 ][ 1 ] = rotationMatrix[ 1 ][ 1 ] / sy;
  rotationMatrix[ 2 ][ 1 ] = rotationMatrix[ 2 ][ 1 ] / sz;

  rotationMatrix[ 0 ][ 2 ] = rotationMatrix[ 0 ][ 2 ] / sx;
  rotationMatrix[ 1 ][ 2 ] = rotationMatrix[ 1 ][ 2 ] / sy;
  rotationMatrix[ 2 ][ 2 ] = rotationMatrix[ 2 ][ 2 ] / sz;

  rotationMatrix[ 0 ][ 3 ] = rotationMatrix[ 0 ][ 3 ] / sx;
  rotationMatrix[ 1 ][ 3 ] = rotationMatrix[ 1 ][ 3 ] / sy;
  rotationMatrix[ 2 ][ 3 ] = rotationMatrix[ 2 ][ 3 ] / sz;

  rotationMatrix[ 3 ] = vec4( 0.0, 0.0, 0.0, 1.0 );

  return rotationMatrix;
}
`

//

function matrixScalingGet()
{
  let self = this;

  let dst = self.MakeIdentity4();

  _.assert( self.dims[ 0 ] === 4 );
  _.assert( self.dims[ 1 ] === 4 );
  _.assert( arguments.length === 0 );
  
  dst.scaleApply( self.scaleGet() );
  
  return dst;
}

matrixScalingGet.shaderChunkName = 'matrixScalingGet';
matrixScalingGet.shaderChunk =
`
mat4 matrixScalingGet ( mat4 matrixLocal )
{
  mat4 scaleMatrix;

  float sx = sqrt( matrixLocal[ 0 ][ 0 ]*matrixLocal[ 0 ][ 0 ] + matrixLocal[ 0 ][ 1 ]*matrixLocal[ 0 ][ 1 ] + matrixLocal[ 0 ][ 2 ]*matrixLocal[ 0 ][ 2 ] );
  float sy = sqrt( matrixLocal[ 1 ][ 0 ]*matrixLocal[ 1 ][ 0 ] + matrixLocal[ 1 ][ 1 ]*matrixLocal[ 1 ][ 1 ] + matrixLocal[ 1 ][ 2 ]*matrixLocal[ 1 ][ 2 ] );
  float sz = sqrt( matrixLocal[ 2 ][ 0 ]*matrixLocal[ 2 ][ 0 ] + matrixLocal[ 2 ][ 1 ]*matrixLocal[ 2 ][ 1 ] + matrixLocal[ 2 ][ 2 ]*matrixLocal[ 2 ][ 2 ] );

  scaleMatrix[ 0 ] = vec4( sx, 0.0, 0.0, 0.0 );
  scaleMatrix[ 1 ] = vec4( 0.0, sy, 0.0, 0.0 );
  scaleMatrix[ 2 ] = vec4( 0.0, 0.0, sz, 0.0 );
  scaleMatrix[ 3 ] = vec4( 0.0, 0.0, 0.0, 1.0 );

  return scaleMatrix;
}
`

//

function matrixTranslationGet()
{
  let self = this;

  let dst = self.MakeIdentity4();

  _.assert( self.dims[ 0 ] === 4 );
  _.assert( self.dims[ 1 ] === 4 );
  _.assert( arguments.length === 0 );
  
  dst.positionSet( self.positionGet() )
  
  return dst;
}

matrixTranslationGet.shaderChunkName = 'matrixTranslationGet';
matrixTranslationGet.shaderChunk =
`
mat4 matrixTranslationGet ( mat4 matrixLocal )
{
  mat4 translationMatrix;

  translationMatrix[ 0 ] = vec4( 1.0, 0.0, 0.0, 0.0 );
  translationMatrix[ 1 ] = vec4( 0.0, 1.0, 0.0, 0.0 );
  translationMatrix[ 2 ] = vec4( 0.0, 0.0, 1.0, 0.0 );
  translationMatrix[ 3 ] = matrixLocal[ 3 ];
  translationMatrix[ 3 ][ 3 ] = 1.0;

  return translationMatrix;
}
`

//

function injectChunks( routines )
{
  let Chunks = _._chunk = _._chunk || Object.create( null );

  for( let r in routines )
  {
    let routine = routines[ r ];

    if( !_.routineIs( routine ) )
    continue;

    if( !routine.shaderChunk )
    continue;

    _.assert( _.strIs( routine.shaderChunk ) );

    let shaderChunk = '';
    shaderChunk += '\n' + routine.shaderChunk + '\n';

    let chunkName = routine.shaderChunkName || r;

    Chunks[ chunkName ] = shaderChunk;

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

  //

  matrixApplyTo,
  matrixHomogenousApply,
  matrixDirectionsApply,

  positionGet,
  positionSet,
  scaleMaxGet,
  scaleMeanGet,
  scaleMagGet,
  scaleGet,
  scaleSet,
  scaleAroundSet,
  scaleApply,
  
  matrixRotationGet,
  matrixScalingGet,
  matrixTranslationGet,

  //

  Statics,

}

_.classExtend( Self, Extension );
injectChunks( Extension );

})();
