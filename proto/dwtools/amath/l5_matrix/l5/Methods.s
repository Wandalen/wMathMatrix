(function _Methods_s_() {

'use strict';

let _ = _global_.wTools;
let vector = _.vectorAdapter;
let abs = Math.abs;
let min = Math.min;
let max = Math.max;
let pow = Math.pow;
let pi = Math.PI;
let sin = Math.sin;
let cos = Math.cos;
let sqrt = Math.sqrt;
let sqr = _.sqr;
let longSlice = Array.prototype.slice;

let Parent = null;
let Self = _global_.wMatrix;

_.assert( _.objectIs( vector ) );
_.assert( _.routineIs( Self ), 'wMatrix is not defined, please include wMatrix.s first' );

// --
// make
// --

function make( dims )
{
  let proto = this ? this.Self.prototype : Self.prototype;

  _.assert( !this.instanceIs() );
  _.assert( _.longIs( dims ) || _.numberIs( dims ) );
  _.assert( arguments.length === 1, 'make expects single argument array (-dims-)' );

  if( _.numberIs( dims ) )
  dims = [ dims, dims ];

  let lengthFlat = proto.AtomsPerMatrixForDimensions( dims );
  let strides = proto.StridesForDimensions( dims, 0 );
  let buffer = proto.long.longMake( lengthFlat );
  let result = new proto.Self
  ({
    buffer,
    dims,
    inputTransposing : 0,
    /*strides, */
  });

  _.assert( _.longIdentical( strides, result._stridesEffective ) );

  return result;
}

//

function makeSquare( buffer )
{
  let proto = this ? this.Self.prototype : Self.prototype;

  let length = buffer;
  if( _.longIs( buffer ) )
  length = Math.sqrt( buffer.length );

  _.assert( !this.instanceIs() );
  _.assert( _.prototypeIs( this ) || _.constructorIs( this ) );
  _.assert( _.longIs( buffer ) || _.numberIs( buffer ) );
  _.assert( _.intIs( length ), 'makeSquare expects square buffer' );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let dims = [ length, length ];
  let atomsPerMatrix = this.AtomsPerMatrixForDimensions( dims );

  let inputTransposing = atomsPerMatrix > 0 ? 1 : 0;
  if( _.numberIs( buffer ) )
  {
    inputTransposing = 0;
    buffer = this.long.longMake( atomsPerMatrix );
  }
  else
  {
    buffer = proto.constructor._bufferFrom( buffer );
  }

  let result = new proto.constructor
  ({
    buffer,
    dims,
    inputTransposing,
  });

  return result;
}

//

function makeZero( dims )
{
  let proto = this ? this.Self.prototype : Self.prototype;

  _.assert( !this.instanceIs() );
  _.assert( _.longIs( dims ) || _.numberIs( dims ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.numberIs( dims ) )
  dims = [ dims, dims ];

  let lengthFlat = proto.AtomsPerMatrixForDimensions( dims );
  let strides = proto.StridesForDimensions( dims, 0 );
  let buffer = proto.long.longMakeZeroed( lengthFlat );
  let result = new proto.Self
  ({
    buffer,
    dims,
    inputTransposing : 0,
    /*strides, */
  });

  _.assert( _.longIdentical( strides, result._stridesEffective ) );

  return result;
}

//

function makeIdentity( dims )
{
  let proto = this ? this.Self.prototype : Self.prototype;

  _.assert( !this.instanceIs() );
  _.assert( _.longIs( dims ) || _.numberIs( dims ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.numberIs( dims ) )
  dims = [ dims, dims ];

  let lengthFlat = proto.AtomsPerMatrixForDimensions( dims );
  let strides = proto.StridesForDimensions( dims, 0 );
  let buffer = proto.long.longMakeZeroed( lengthFlat ); /* xxx */
  let result = new proto.Self
  ({
    buffer,
    dims,
    inputTransposing : 0,
    /*strides, */
  });

  result.diagonalSet( 1 );

  _.assert( _.longIdentical( strides, result._stridesEffective ) );

  return result;
}

//

function makeIdentity2( src )
{
  let proto = this ? this.Self.prototype : Self.prototype;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  let result = proto.makeIdentity( 2 );

  if( src )
  result.copy( src );

  return result;
}

//

function makeIdentity3( src )
{
  let proto = this ? this.Self.prototype : Self.prototype;

_.assert( arguments.length === 0 || arguments.length === 1 );

  let result = proto.makeIdentity( 3 );

  if( src )
  result.copy( src );

  return result;
}

//

function makeIdentity4( src )
{
  let proto = this ? this.Self.prototype : Self.prototype;

  _.assert( arguments.length === 0 || arguments.length === 1 );

  let result = proto.makeIdentity( 4 );

  if( src )
  result.copy( src );

  return result;
}

//

function makeDiagonal( diagonal )
{

  _.assert( !this.instanceIs() );
  _.assert( _.prototypeIs( this ) || _.constructorIs( this ) );
  _.assert( _.arrayIs( diagonal ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  /* */

  let length = diagonal.length;
  let dims = [ length, length ];
  let atomsPerMatrix = this.AtomsPerMatrixForDimensions( dims );
  let buffer = this.long.longMakeZeroed( atomsPerMatrix );
  let result = new this.Self
  ({
    buffer,
    dims,
    inputTransposing : 0,
    // strides : [ 1, length ],
  });

  result.diagonalSet( diagonal );

  return result;
}

//

function makeSimilar( m , dims )
{
  let proto = this;
  let result;

  if( proto.instanceIs() )
  {
    _.assert( arguments.length === 0 || arguments.length === 1 );
    return proto.Self.makeSimilar( proto , arguments[ 0 ] );
  }

  if( dims === undefined )
  dims = proto.DimsOf( m );

  /* */

  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.arrayIs( dims ) && dims.length === 2 );

  /* */

  if( m instanceof Self )
  {

    let atomsPerMatrix = Self.AtomsPerMatrixForDimensions( dims );
    let buffer = proto.long.longMakeZeroed( m.buffer, atomsPerMatrix ); /* yyy */
    /* could possibly be not zeroed */

    result = new m.constructor
    ({
      buffer,
      dims,
      inputTransposing : 0,
    });

  }
  else if( _.longIs( m ) )
  {

    _.assert( dims[ 1 ] === 1 );
    result = proto.long.longMakeUndefined( m, dims[ 0 ] ); /* yyy */

  }
  else if( _.vectorAdapterIs( m ) )
  {

    _.assert( dims[ 1 ] === 1 );
    result = m.makeSimilar( dims[ 0 ] );

  }
  else _.assert( 0, 'unexpected type of container', _.strType( m ) );

  return result;
}

//

function makeLine( o )
{
  let proto = this ? this.Self.prototype : Self.prototype;
  let strides = null;
  let offset = 0;
  let length = ( _.longIs( o.buffer ) || _.vectorAdapterIs( o.buffer ) ) ? o.buffer.length : o.buffer;
  let dims = null;

  _.assert( !this.instanceIs() );
  _.assert( _.matrixIs( o.buffer ) || _.vectorAdapterIs( o.buffer ) || _.arrayIs( o.buffer ) || _.bufferTypedIs( o.buffer ) || _.numberIs( o.buffer ) );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routineOptions( makeLine, o );

  /* */

  if( _.matrixIs( o.buffer ) )
  {
    _.assert( o.buffer.dims.length === 2 );
    if( o.dimension === 0 )
    _.assert( o.buffer.dims[ 1 ] === 1 );
    else if( o.dimension === 1 )
    _.assert( o.buffer.dims[ 0 ] === 1 );

    if( !o.zeroing )
    {
      return o.buffer;
    }
    else
    {
      o.buffer = o.buffer.dims[ o.dimension ];
      length = o.buffer;
    }
  }

  /* */

  if( o.zeroing )
  {
    o.buffer = length;
  }

  if( _.vectorAdapterIs( o.buffer ) )
  {
    length = o.buffer.length;
    o.buffer = proto._bufferFrom( o.buffer );
  }

  if( _.vectorAdapterIs( o.buffer ) )
  {

    offset = o.buffer.offset;
    length = o.buffer.length;

    if( o.buffer.stride !== 1 )
    {
      if( o.dimension === 0 )
      strides = [ o.buffer.stride, o.buffer.stride ];
      else
      strides = [ o.buffer.stride, o.buffer.stride ];
    }

    o.buffer = o.buffer._vectorBuffer;

  }
  else if( _.numberIs( o.buffer ) )
  o.buffer = o.zeroing ? this.long.longMakeZeroed( length ) : this.long.longMake( length );
  else if( o.zeroing )
  o.buffer = this.long.longMakeZeroed( length )
  else
  o.buffer = proto.constructor._bufferFrom( o.buffer );

  /* dims */

  if( o.dimension === 0 )
  {
    dims = [ length, 1 ];
  }
  else if( o.dimension === 1 )
  {
    dims = [ 1, length ];
  }
  else _.assert( 0, 'bad dimension', o.dimension );

  /* */

  let result = new proto.constructor
  ({
    buffer : o.buffer,
    dims,
    inputTransposing : 0,
    strides,
    offset,
  });

  return result;
}

makeLine.defaults =
{
  buffer : null,
  dimension : -1,
  zeroing : 1,
}

//

function makeCol( buffer )
{
  return this.makeLine
  ({
    buffer,
    zeroing : 0,
    dimension : 0,
  });
}

//

function makeColZeroed( buffer )
{
  return this.makeLine
  ({
    buffer,
    zeroing : 1,
    dimension : 0,
  });
}

//

function makeRow( buffer )
{
  return this.makeLine
  ({
    buffer,
    zeroing : 0,
    dimension : 1,
  });
}

//

function makeRowZeroed( buffer )
{
  return this.makeLine
  ({
    buffer,
    zeroing : 1,
    dimension : 1,
  });
}

// --
// converter
// --

function convertToClass( cls, src )
{
  let self = this;

  _.assert( !_.instanceIs( this ) );
  _.assert( _.constructorIs( cls ) );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( src.constructor === cls )
  return src;

  let result;
  if( _.matrixIs( src ) )
  {

    if( _.isSubClassOf( cls, src.Self ) )
    {
      _.assert( src.Self === cls, 'not tested' );
      return src;
    }

    _.assert( src.dims.length === 2 );
    _.assert( src.dims[ 1 ] === 1 );

    let array;
    let atomsPerMatrix = src.atomsPerMatrix;

    if( _.constructorLikeArray( cls ) )
    {
      result = new cls( atomsPerMatrix );
      array = result;
    }
    else if( _.constructorIsVector( cls ) )
    {
      array = new src.buffer.constructor( atomsPerMatrix );
      result = vector.FromLong( array );
    }
    else _.assert( 0, 'unknown class (-cls-)', cls.name );

    for( let i = 0 ; i < result.length ; i += 1 )
    array[ i ] = src.atomGet([ i, 0 ]);

  }
  else
  {

    let atomsPerMatrix = src.length;
    src = vector.From( src );

    if( _.constructorIsMatrix( cls ) )
    {
      let array = new src._vectorBuffer.constructor( atomsPerMatrix );
      result = new cls
      ({
        dims : [ src.length, 1 ],
        buffer : array,
        inputTransposing : 0,
      });
      for( let i = 0 ; i < src.length ; i += 1 )
      result.atomSet( [ i, 0 ], src.eGet( i ) );
    }
    else if( _.constructorLikeArray( cls ) )
    {
      result = new cls( atomsPerMatrix );
      for( let i = 0 ; i < src.length ; i += 1 )
      result[ i ] = src.eGet( i );
    }
    else if( _.constructorIsVector( cls ) )
    {
      let array = new src._vectorBuffer.constructor( atomsPerMatrix );
      result = vector.FromLong( array );
      for( let i = 0 ; i < src.length ; i += 1 )
      array[ i ] = src.eGet( i );
    }
    else _.assert( 0, 'unknown class (-cls-)', cls.name );

  }

  return result;
}

//

function fromVectorAdapter( src )
{
  let result;

  _.assert( !this.instanceIs() );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.vectorAdapterIs( src ) )
  {
    result = new this.Self
    ({
      buffer : src._vectorBuffer,
      dims : [ src.length, 1 ],
      strides : src.stride > 1 ? [ src.stride, 1 ] : undefined,
      inputTransposing : 0,
    });
  }
  else if( _.arrayIs( src ) )
  {
    result = new this.Self
    ({
      buffer : src,
      dims : [ src.length, 1 ],
      inputTransposing : 0,
    });
  }
  else _.assert( 0, 'cant convert', _.strType( src ), 'to Matrix' );

  return result;
}

//

function fromScalar( scalar, dims )
{

  _.assert( !this.instanceIs() );
  _.assert( _.arrayIs( dims ) );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.numberIs( scalar );

  debugger;

  let result = new this.Self
  ({
    buffer : this.long.longFrom( _.dup( scalar, this.AtomsPerMatrixForDimensions( dims ) ) ),
    dims,
    inputTransposing : 0,
  });

  return result;
}

//

function fromScalarForReading( scalar, dims )
{

  _.assert( !this.instanceIs() );
  _.assert( _.arrayIs( dims ) );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.numberIs( scalar );

  let buffer = this.long.longMake( 1 );
  buffer[ 0 ] = scalar;

  let result = new this.Self
  ({
    buffer,
    dims,
    strides : _.dup( 0, dims.length ),
  });

  return result;
}

//

function from( src, dims )
{
  let result;

  _.assert( !this.instanceIs() );
  _.assert( _.arrayIs( dims ) || dims == undefined );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( src === null )
  {
    _.assert( _.arrayIs( dims ) );
    result = this.makeZero( dims );
  }
  else if( src instanceof Self )
  {
    result = src;
  }
  else if( _.numberIs( src ) )
  {
    _.assert( _.arrayIs( dims ) );
    result = this.fromScalar( src, dims );
  }
  else
  {
    result = this.fromVectorAdapter( src );
  }

  _.assert( !dims || result.hasShape( dims ) );

  return result;
}

//

function fromForReading( src, dims )
{
  let result;

  _.assert( !this.instanceIs() );
  _.assert( _.arrayIs( dims ) || dims == undefined );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( src instanceof Self )
  {
    result = src;
  }
  else if( _.numberIs( src ) )
  {
    _.assert( _.arrayIs( dims ) );
    result = this.fromScalarForReading( src, dims );
  }
  else
  {
    let result = this.fromVectorAdapter( src );
  }

  _.assert( !dims || result.hasShape( dims ) );

  return result;
}

//

function fromTransformations( position, quaternion, scale )
{
  let self = this;

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );

  self.fromQuat( quaternion );
  self.scaleApply( scale );
  self.positionSet( position );

  return self;
}

//

function fromQuat( q )
{
  let self = this;

  q = _.vectorAdapter.From( q );
  let x = q.eGet( 0 );
  let y = q.eGet( 1 );
  let z = q.eGet( 2 );
  let w = q.eGet( 3 );

  _.assert( self.atomsPerElement >= 3 );
  _.assert( self.length >= 3 );
  _.assert( q.length === 4 );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let x2 = x + x, y2 = y + y, z2 = z + z;
  let xx = x * x2, xy = x * y2, xz = x * z2;
  let yy = y * y2, yz = y * z2, zz = z * z2;
  let wx = w * x2, wy = w * y2, wz = w * z2;

  self.atomSet( [ 0, 0 ] , 1 - ( yy + zz ) );
  self.atomSet( [ 0, 1 ] , xy - wz );
  self.atomSet( [ 0, 2 ] , xz + wy );

  self.atomSet( [ 1, 0 ] , xy + wz );
  self.atomSet( [ 1, 1 ] , 1 - ( xx + zz ) );
  self.atomSet( [ 1, 2 ] , yz - wx );

  self.atomSet( [ 2, 0 ] , xz - wy );
  self.atomSet( [ 2, 1 ] , yz + wx );
  self.atomSet( [ 2, 2 ] , 1 - ( xx + yy ) );

  if( self.dims[ 0 ] > 3 )
  {
    self.atomSet( [ 3, 0 ] , 0 );
    self.atomSet( [ 3, 1 ] , 0 );
    self.atomSet( [ 3, 2 ] , 0 );
    self.atomSet( [ 0, 3 ], 0 );
    self.atomSet( [ 1, 3 ], 0 );
    self.atomSet( [ 2, 3 ], 0 );
    self.atomSet( [ 3, 3 ], 1 );
  }

  return self;
}

//

function fromQuatWithScale( q )
{
  let self = this;

  q = _.vectorAdapter.From( q );
  let m = q.mag();
  let x = q.eGet( 0 ) / m;
  let y = q.eGet( 1 ) / m;
  let z = q.eGet( 2 ) / m;
  let w = q.eGet( 3 ) / m;

  _.assert( self.atomsPerElement >= 3 );
  _.assert( self.length >= 3 );
  _.assert( q.length === 4 );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let x2 = x + x, y2 = y + y, z2 = z + z;
  let xx = x * x2, xy = x * y2, xz = x * z2;
  let yy = y * y2, yz = y * z2, zz = z * z2;
  let wx = w * x2, wy = w * y2, wz = w * z2;

  self.atomSet( [ 0, 0 ] , m*( 1 - ( yy + zz ) ) );
  self.atomSet( [ 0, 1 ] , m*( xy - wz ) );
  self.atomSet( [ 0, 2 ] , m*( xz + wy ) );

  self.atomSet( [ 1, 0 ] , m*( xy + wz ) );
  self.atomSet( [ 1, 1 ] , m*( 1 - ( xx + zz ) ) );
  self.atomSet( [ 1, 2 ] , m*( yz - wx ) );

  self.atomSet( [ 2, 0 ] , m*( xz - wy ) );
  self.atomSet( [ 2, 1 ] , m*( yz + wx ) );
  self.atomSet( [ 2, 2 ] , m*( 1 - ( xx + yy ) ) );

  if( self.dims[ 0 ] > 3 )
  {
    self.atomSet( [ 3, 0 ] , 0 );
    self.atomSet( [ 3, 1 ] , 0 );
    self.atomSet( [ 3, 2 ] , 0 );
    self.atomSet( [ 0, 3 ], 0 );
    self.atomSet( [ 1, 3 ], 0 );
    self.atomSet( [ 2, 3 ], 0 );
    self.atomSet( [ 3, 3 ], 1 );
  }

  return self;
}

//

function fromAxisAndAngle( axis, angle )
{
  let self = this;
  axis = _.vectorAdapter.From( axis );

  // let m = axis.mag();
  // debugger;

  let x = axis.eGet( 0 );
  let y = axis.eGet( 1 );
  let z = axis.eGet( 2 );

  _.assert( axis.length === 3 );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let s = Math.sin( angle );
  let c = Math.cos( angle );
  let t = 1 - c;

  let m00 = c + x*x*t;
  let m11 = c + y*y*t;
  let m22 = c + z*z*t;

  let a = x*y*t;
  let b = z*s;

  let m10 = a + b;
  let m01 = a - b;

  a = x*z*t;
  b = y*s;

  let m20 = a - b;
  let m02 = a + b;

  a = y*z*t;
  b = x*s;

  let m21 = a + b;
  let m12 = a - b;

  self.atomSet( [ 0, 0 ], m00 );
  self.atomSet( [ 1, 0 ], m10 );
  self.atomSet( [ 2, 0 ], m20 );

  self.atomSet( [ 0, 1 ], m01 );
  self.atomSet( [ 1, 1 ], m11 );
  self.atomSet( [ 2, 1 ], m21 );

  self.atomSet( [ 0, 2 ], m02 );
  self.atomSet( [ 1, 2 ], m12 );
  self.atomSet( [ 2, 2 ], m22 );

  return self;
}

//

function fromEuler( euler )
{
  let self = this;
  // let euler = _.vectorAdapter.From( euler );

  // _.assert( self.dims[ 0 ] >= 3 );
  // _.assert( self.dims[ 1 ] >= 3 );
  _.assert( arguments.length === 1, 'Expects single argument' );

  _.euler.toMatrix( euler, self );

  return self;
}

//

function fromAxisAndAngleWithScale( axis, angle )
{
  let self = this;
  axis = _.vectorAdapter.From( axis );

  let m = axis.mag();
  debugger;
  let x = axis.eGet( 0 ) / m;
  let y = axis.eGet( 1 ) / m;
  let z = axis.eGet( 2 ) / m;

  _.assert( axis.length === 3 );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  let s = Math.sin( angle );
  let c = Math.cos( angle );
  let t = 1 - c;

  let m00 = c + x*x*t;
  let m11 = c + y*y*t;
  let m22 = c + z*z*t;

  let a = x*y*t;
  let b = z*s;

  let m10 = a + b;
  let m01 = a - b;

  a = x*z*t;
  b = y*s;

  let m20 = a - b;
  let m02 = a + b;

  a = y*z*t;
  b = x*s;

  let m21 = a + b;
  let m12 = a - b;

  self.atomSet( [ 0, 0 ], m*m00 );
  self.atomSet( [ 1, 0 ], m*m10 );
  self.atomSet( [ 2, 0 ], m*m20 );

  self.atomSet( [ 0, 1 ], m*m01 );
  self.atomSet( [ 1, 1 ], m*m11 );
  self.atomSet( [ 2, 1 ], m*m21 );

  self.atomSet( [ 0, 2 ], m*m02 );
  self.atomSet( [ 1, 2 ], m*m12 );
  self.atomSet( [ 2, 2 ], m*m22 );

  return self;
}

// --
// borrow
// --

function _tempBorrow( src, dims, index )
{
  let bufferConstructor;

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  _.assert( src instanceof Self || src === null );
  _.assert( _.arrayIs( dims ) || dims instanceof Self || dims === null );

  if( !src )
  {

    // debugger;
    // bufferConstructor = this.array.ArrayType;
    // bufferConstructor = this.longDescriptor;
    bufferConstructor = this.long.longDescriptor.type;
    if( !dims )
    dims = src;

  }
  else
  {

    if( src.buffer )
    bufferConstructor = src.buffer.constructor;

    if( !dims )
    if( src.dims )
    dims = src.dims.slice();

  }

  if( dims instanceof Self )
  dims = dims.dims;

  _.assert( _.routineIs( bufferConstructor ) );
  _.assert( _.arrayIs( dims ) );
  _.assert( index < 3 );

  let key = bufferConstructor.name + '_' + dims.join( 'x' );

  if( this._tempMatrices[ index ][ key ] )
  return this._tempMatrices[ index ][ key ];

  let result = this._tempMatrices[ index ][ key ] = new Self
  ({
    dims,
    buffer : new bufferConstructor( this.AtomsPerMatrixForDimensions( dims ) ),
    inputTransposing : 0,
  });

  return result;
}

//

function tempBorrow1( src )
{

  _.assert( arguments.length <= 1 );
  if( src === undefined )
  src = this;

  if( this instanceof Self )
  return Self._tempBorrow( this, src , 0 );
  else if( src instanceof Self )
  return Self._tempBorrow( src, src , 0 );
  else
  return Self._tempBorrow( null, src , 0 );

}

//

function tempBorrow2( src )
{

  _.assert( arguments.length <= 1 );
  if( src === undefined )
  src = this;

  if( this instanceof Self )
  return Self._tempBorrow( this, src , 1 );
  else if( src instanceof Self )
  return Self._tempBorrow( src, src , 1 );
  else
  return Self._tempBorrow( null, src , 1 );

}

//

function tempBorrow3( src )
{

  _.assert( arguments.length <= 1 );
  if( src === undefined )
  src = this;

  if( this instanceof Self )
  return Self._tempBorrow( this, src , 2 );
  else if( src instanceof Self )
  return Self._tempBorrow( src, src , 2 );
  else
  return Self._tempBorrow( null, src , 2 );

}

// --
// mul
// --

function matrixPow( exponent )
{

  _.assert( _.instanceIs( this ) );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let t = this.tempBorrow( this );

  // self.mul(  );

}

//

function mul_static( dst, srcs )
{

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.arrayIs( srcs ) );
  _.assert( srcs.length >= 2 );

  /* adjust dst */

  if( dst === null )
  {
    let dims = [ this.NrowOf( srcs[ srcs.length-2 ] ) , this.NcolOf( srcs[ srcs.length-1 ] ) ];
    dst = this.makeSimilar( srcs[ srcs.length-1 ] , dims );
  }

  /* adjust srcs */

  srcs = srcs.slice();
  let dstClone = null;

  let odst = dst;
  dst = this.from( dst );

  for( let s = 0 ; s < srcs.length ; s++ )
  {

    srcs[ s ] = this.from( srcs[ s ] );

    if( dst === srcs[ s ] || dst.buffer === srcs[ s ].buffer )
    {
      if( dstClone === null )
      {
        dstClone = dst.tempBorrow1();
        dstClone.copy( dst );
      }
      srcs[ s ] = dstClone;
    }

    _.assert( dst.buffer !== srcs[ s ].buffer );

  }

  /* */

  dst = this.mul2Matrices( dst , srcs[ 0 ] , srcs[ 1 ] );

  /* */

  if( srcs.length > 2 )
  {

    let dst2 = null;
    let dst3 = dst;
    for( let s = 2 ; s < srcs.length ; s++ )
    {
      let src = srcs[ s ];
      if( s % 2 === 0 )
      {
        dst2 = dst.tempBorrow2([ dst3.dims[ 0 ], src.dims[ 1 ] ]);
        this.mul2Matrices( dst2 , dst3 , src );
      }
      else
      {
        dst3 = dst.tempBorrow3([ dst2.dims[ 0 ], src.dims[ 1 ] ]);
        this.mul2Matrices( dst3 , dst2 , src );
      }
    }

    if( srcs.length % 2 === 0 )
    this.CopyTo( odst, dst3 );
    else
    this.CopyTo( odst, dst2 );

  }
  else
  {
    this.CopyTo( odst, dst );
  }

  return odst;
}

//

function mul( srcs )
{
  let dst = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.arrayIs( srcs ) );

  return dst.Self.mul( dst, srcs );
}

//

function mul2Matrices_static( dst, src1, src2 )
{

  src1 = Self.fromForReading( src1 );
  src2 = Self.fromForReading( src2 );

  if( dst === null )
  {
    dst = this.make([ src1.dims[ 0 ], src2.dims[ 1 ] ]);
  }

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  _.assert( src1.dims.length === 2 );
  _.assert( src2.dims.length === 2 );
  _.assert( dst instanceof Self );
  _.assert( src1 instanceof Self );
  _.assert( src2 instanceof Self );
  _.assert( dst !== src1 );
  _.assert( dst !== src2 );
  _.assert( src1.dims[ 1 ] === src2.dims[ 0 ], 'Expects src1.dims[ 1 ] === src2.dims[ 0 ]' );
  _.assert( src1.dims[ 0 ] === dst.dims[ 0 ] );
  _.assert( src2.dims[ 1 ] === dst.dims[ 1 ] );

  let nrow = dst.nrow;
  let ncol = dst.ncol;

  for( let r = 0 ; r < nrow ; r++ )
  for( let c = 0 ; c < ncol ; c++ )
  {
    let row = src1.rowVectorGet( r );
    let col = src2.colVectorGet( c );
    let dot = vector.dot( row, col );
    dst.atomSet( [ r, c ], dot );
  }

  return dst;
}

//

function mul2Matrices( src1, src2 )
{
  let dst = this;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  return dst.Self.mul2Matrices( dst, src1, src2 );
}

//

function mulLeft( src )
{
  let dst = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  // debugger;

  dst.mul([ dst, src ])

  return dst;
}

//

function mulRight( src )
{
  let dst = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  // debugger;

  dst.mul([ src, dst ]);
  // dst.mul2Matrices( src, dst );

  return dst;
}

// //
//
// function _mulMatrix( src )
// {
//
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   _.assert( src.breadth.length === 1 );
//
//   let self = this;
//   let atomsPerRow = self.atomsPerRow;
//   let atomsPerCol = src.atomsPerCol;
//   let code = src.buffer.constructor.name + '_' + atomsPerRow + 'x' + atomsPerCol;
//
//   debugger;
//   if( !self._tempMatrices[ code ] )
//   self._tempMatrices[ code ] = self.Self.make([ atomsPerCol, atomsPerRow ]);
//   let dst = self._tempMatrices[ code ]
//
//   debugger;
//   dst.mul2Matrices( dst, self, src );
//   debugger;
//
//   self.copy( dst );
//
//   return self;
// }
//
// //
//
// function mulAssigning( src )
// {
//   let self = this;
//
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   _.assert( self.breadth.length === 1 );
//
//   let result = self._mulMatrix( src );
//
//   return result;
// }
//
// //
//
// function mulCopying( src )
// {
//   let self = this;
//
//   _.assert( arguments.length === 1, 'Expects single argument' );
//   _.assert( src.dims.length === 2 );
//   _.assert( self.dims.length === 2 );
//
//   let result = Self.make( src.dims );
//   result.mul2Matrices( result, self, src );
//
//   return result;
// }

// --
// partial accessors
// --

function zero()
{
  let self = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  self.atomEach( ( it ) => self.atomSet( it.indexNd, 0 ) );

  return self;
}

//

function identify()
{
  let self = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  self.atomEach( ( it ) => it.indexNd[ 0 ] === it.indexNd[ 1 ] ? self.atomSet( it.indexNd, 1 ) : self.atomSet( it.indexNd, 0 ) );

  return self;
}

//

function diagonalSet( src )
{
  let self = this;
  let length = Math.min( self.atomsPerCol, self.atomsPerRow );

  if( src instanceof Self )
  src = src.diagonalVectorGet();

  src = vector.FromMaybeNumber( src, length );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( self.dims.length === 2 );
  _.assert( src.length === length );

  for( let i = 0 ; i < length ; i += 1 )
  {
    self.atomSet( [ i, i ], src.eGet( i ) );
  }

  return self;
}

//

function diagonalVectorGet()
{
  let self = this;
  let length = Math.min( self.atomsPerCol, self.atomsPerRow );
  let strides = self._stridesEffective;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( self.dims.length === 2 );

  let result = vector.FromSubLongWithStride( self.buffer, self.offset, length, strides[ 0 ] + strides[ 1 ] );

  return result;
}

//

function triangleLowerSet( src )
{
  let self = this;
  let nrow = self.nrow;
  let ncol = self.ncol;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( self.dims.length === 2 );

  _.assert( _.numberIs( src ) || src instanceof Self );

  if( src instanceof Self )
  {

    _.assert( src.dims[ 0 ] >= self.dims[ 0 ] );
    _.assert( src.dims[ 1 ] >= min( self.dims[ 0 ]-1, self.dims[ 1 ] ) );

    for( let r = 1 ; r < nrow ; r++ )
    {
      let cl = min( r, ncol );
      for( let c = 0 ; c < cl ; c++ )
      self.atomSet( [ r, c ], src.atomGet([ r, c ]) );
    }

  }
  else
  {

    for( let r = 1 ; r < nrow ; r++ )
    {
      let cl = min( r, ncol );
      for( let c = 0 ; c < cl ; c++ )
      self.atomSet( [ r, c ], src );
    }

  }

  return self;
}

//

function triangleUpperSet( src )
{
  let self = this;
  let nrow = self.nrow;
  let ncol = self.ncol;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( self.dims.length === 2 );

  _.assert( _.numberIs( src ) || src instanceof Self );

  if( src instanceof Self )
  {

    _.assert( src.dims[ 1 ] >= self.dims[ 1 ] );
    _.assert( src.dims[ 0 ] >= min( self.dims[ 1 ]-1, self.dims[ 0 ] ) );

    for( let c = 1 ; c < ncol ; c++ )
    {
      let cl = min( c, nrow );
      for( let r = 0 ; r < cl ; r++ )
      self.atomSet( [ r, c ], src.atomGet([ r, c ]) );
    }

  }
  else
  {

    for( let c = 1 ; c < ncol ; c++ )
    {
      let cl = min( c, nrow );
      for( let r = 0 ; r < cl ; r++ )
      self.atomSet( [ r, c ], src );
    }

  }

  return self;
}

// --
// transformer
// --

// function applyMatrixToVector( dstVector )
// {
//   let self = this;
//
//   _.assert( 0, 'deprecated' );
//
//   vector.matrixApplyTo( dstVector, self );
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
//   vector.matrixHomogenousApply( dstVector, self );
//
//   return self;
// }

function matrixApplyTo( dstVector )
{
  let self = this;

  if( self.hasShape([ 3, 3 ]) )
  {

    let dstVectorv = _.vectorAdapter.From( dstVector );
    let x = dstVectorv.eGet( 0 );
    let y = dstVectorv.eGet( 1 );
    let z = dstVectorv.eGet( 2 );

    let s00 = self.atomGet([ 0, 0 ]), s10 = self.atomGet([ 1, 0 ]), s20 = self.atomGet([ 2, 0 ]);
    let s01 = self.atomGet([ 0, 1 ]), s11 = self.atomGet([ 1, 1 ]), s21 = self.atomGet([ 2, 1 ]);
    let s02 = self.atomGet([ 0, 2 ]), s12 = self.atomGet([ 1, 2 ]), s22 = self.atomGet([ 2, 2 ]);

    dstVectorv.eSet( 0 , s00 * x + s01 * y + s02 * z );
    dstVectorv.eSet( 1 , s10 * x + s11 * y + s12 * z );
    dstVectorv.eSet( 2 , s20 * x + s21 * y + s22 * z );

    return dstVector;
  }
  else if( self.hasShape([ 2, 2 ]) )
  {

    let dstVectorv = _.vectorAdapter.From( dstVector );
    let x = dstVectorv.eGet( 0 );
    let y = dstVectorv.eGet( 1 );

    let s00 = self.atomGet([ 0, 0 ]), s10 = self.atomGet([ 1, 0 ]);
    let s01 = self.atomGet([ 0, 1 ]), s11 = self.atomGet([ 1, 1 ]);

    dstVectorv.eSet( 0 , s00 * x + s01 * y );
    dstVectorv.eSet( 1 , s10 * x + s11 * y );

    return dstVector;
  }

  return Self.mul( dstVector, [ self, dstVector ] );
}

//

function matrixHomogenousApply( dstVector )
{
  let self = this;
  let _dstVector = vector.From( dstVector );
  let dstLength = dstVector.length;
  let ncol = self.ncol;
  let nrow = self.nrow;
  let result = new Array( nrow );

  _.assert( arguments.length === 1 )
  _.assert( dstLength === ncol-1 );

  result[ dstLength ] = 0;
  for( let i = 0 ; i < nrow ; i += 1 )
  {
    let row = self.rowVectorGet( i );

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

function matrixDirectionsApply( dstVector )
{
  let self = this;
  let dstLength = dstVector.length;
  let ncol = self.ncol;
  let nrow = self.nrow;

  _.assert( arguments.length === 1 )
  _.assert( dstLength === ncol-1 );

  debugger;

  Self.mul( v, [ self.submatrix([ [ 0, v.length ], [ 0, v.length ] ]), v ] );
  vector.normalize( v );

  return dstVector;
}
//

function positionGet()
{
  let self = this;
  let l = self.length;
  let loe = self.atomsPerElement;
  let result = self.colVectorGet( l-1 );

  _.assert( arguments.length === 0, 'Expects no arguments' );

  // debugger;
  result = vector.FromSubLong( result, 0, loe-1 );

  //let result = self.elementsInRangeGet([ (l-1)*loe, l*loe ]);
  //let result = vector.FromSubLong( this.buffer, 12, 3 );

  return result;
}

//

function positionSet( src )
{
  let self = this;
  src = vector.FromLong( src );
  let dst = this.positionGet();

  _.assert( src.length === dst.length );

  vector.assign( dst, src );
  return dst;
}

//

function scaleMaxGet( dst )
{
  let self = this;
  let scale = self.scaleGet( dst );
  let result = _.avector.reduceToMaxAbs( scale ).value;
  return result;
}

//

function scaleMeanGet( dst )
{
  let self = this;
  let scale = self.scaleGet( dst );
  let result = _.avector.reduceToMean( scale );
  return result;
}

//

function scaleMagGet( dst )
{
  let self = this;
  let scale = self.scaleGet( dst );
  let result = _.avector.mag( scale );
  return result;
}

//

function scaleGet( dst )
{
  let self = this;
  let l = self.length-1;
  let loe = self.atomsPerElement;

  if( dst )
  {
    if( _.arrayIs( dst ) )
    dst.length = self.length-1;
  }

  if( dst )
  l = dst.length;
  else
  dst = _.vectorAdapter.From( self.long.longMakeZeroed( self.length-1 ) );

  let dstv = _.vectorAdapter.From( dst );

  _.assert( arguments.length === 0 || arguments.length === 1 );

  for( let i = 0 ; i < l ; i += 1 )
  dstv.eSet( i , vector.mag( vector.FromSubLong( this.buffer, loe*i, loe-1 ) ) );

  return dst;
}

//

function scaleSet( src )
{
  let self = this;
  src = vector.FromLong( src );
  let l = self.length;
  let loe = self.atomsPerElement;
  let cur = this.scaleGet();

  _.assert( src.length === l-1 );

  for( let i = 0 ; i < l-1 ; i += 1 )
  vector.mulScalar( self.eGet( i ), src.eGet( i ) / cur[ i ] );

  let lastElement = self.eGet( l-1 );
  vector.mulScalar( lastElement, 1 / lastElement.eGet( loe-1 ) );

}

//

function scaleAroundSet( scale, center )
{
  let self = this;
  scale = vector.FromLong( scale );
  let l = self.length;
  let loe = self.atomsPerElement;
  let cur = this.scaleGet();

  _.assert( scale.length === l-1 );

  for( let i = 0 ; i < l-1 ; i += 1 )
  vector.mulScalar( self.eGet( i ), scale.eGet( i ) / cur[ i ] );

  let lastElement = self.eGet( l-1 );
  vector.mulScalar( lastElement, 1 / lastElement.eGet( loe-1 ) );

  /* */

  debugger;
  center = vector.FromLong( center );
  let pos = vector.slice( scale );
  pos = vector.FromLong( pos );
  vector.mulScalar( pos, -1 );
  vector.addScalar( pos, 1 );
  vector.mulVectors( pos, center );

  self.positionSet( pos );

}

//

function scaleApply( src )
{
  let self = this;
  src = vector.FromLong( src );
  let ape = self.atomsPerElement;
  let l = self.length;

  for( let i = 0 ; i < ape ; i += 1 )
  {
    let c = self.rowVectorGet( i );
    c = vector.FromSubLong( c, 0, l-1 );
    vector.mulVectors( c, src );
  }

}

// --
// triangulator
// --

function _triangulateGausian( o )
{
  let self = this;
  let nrow = self.nrow;
  let ncol = Math.min( self.ncol, nrow );

  _.routineOptions( _triangulateGausian, o );

  if( o.onPivot && !o.pivots )
  {
    o.pivots = [];
    for( let i = 0 ; i < self.dims.length ; i += 1 )
    o.pivots[ i ] = _.longFromRange([ 0, self.dims[ i ] ]);
  }

  if( o.y !== null )
  o.y = Self.from( o.y );

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( !o.y || o.y.dims[ 0 ] === self.dims[ 0 ] );

  /* */

  if( o.y )
  for( let r1 = 0 ; r1 < ncol ; r1++ )
  {

    if( o.onPivot )
    o.onPivot.call( self, r1, o );

    let row1 = self.rowVectorGet( r1 );
    let yrow1 = o.y.rowVectorGet( r1 );
    let scaler1 = row1.eGet( r1 );
    if( o.normal )
    {
      vector.divScalar( row1, scaler1 );
      vector.divScalar( yrow1, scaler1 );
      scaler1 = 1;
    }

    for( let r2 = r1+1 ; r2 < nrow ; r2++ )
    {
      let row2 = self.rowVectorGet( r2 );
      let yrow2 = o.y.rowVectorGet( r2 );
      let scaler = row2.eGet( r1 ) / scaler1;
      vector.subScaled( row2, row1, scaler );
      vector.subScaled( yrow2, yrow1, scaler );
    }

    // logger.log( 'self', self );

  }
  else for( let r1 = 0 ; r1 < ncol ; r1++ )
  {

    if( o.onPivot )
    o.onPivot.call( self, r1, o );

    let row1 = self.rowVectorGet( r1 );
    let scaler1 = row1.eGet( r1 );
    if( o.normal )
    {
      vector.divScalar( row1, scaler1 );
      scaler1 = 1;
    }

    for( let r2 = r1+1 ; r2 < nrow ; r2++ )
    {
      let row2 = self.rowVectorGet( r2 );
      let scaler = row2.eGet( r1 ) / scaler1;
      vector.subScaled( row2, row1, scaler );
    }

    // logger.log( 'self', self );

  }

  return o.pivots;
}

_triangulateGausian.defaults =
{
  y : null,
  onPivot : null,
  pivots : null,
  normal : 0,
}

//

function triangulateGausian( y )
{
  let self = this;
  let o = Object.create( null );
  o.y = y;
  return self._triangulateGausian( o );

  // let self = this;
  // let nrow = self.nrow;
  // let ncol = Math.min( self.ncol, nrow );
  //
  // if( y !== undefined )
  // y = Self.from( y );
  //
  // _.assert( arguments.length === 0 || arguments.length === 1 );
  // _.assert( !y || y.dims[ 0 ] === self.dims[ 0 ] );
  //
  // if( y )
  // for( let r1 = 0 ; r1 < ncol ; r1++ )
  // {
  //   let row1 = self.rowVectorGet( r1 );
  //   let yrow1 = y.rowVectorGet( r1 );
  //   let scaler1 = row1.eGet( r1 );
  //
  //   for( let r2 = r1+1 ; r2 < nrow ; r2++ )
  //   {
  //     let row2 = self.rowVectorGet( r2 );
  //     let yrow2 = y.rowVectorGet( r2 );
  //     let scaler = row2.eGet( r1 ) / scaler1;
  //     vector.subScaled( row2, row1, scaler );
  //     vector.subScaled( yrow2, yrow1, scaler );
  //   }
  //
  // }
  // else for( let r1 = 0 ; r1 < ncol ; r1++ )
  // {
  //   let row1 = self.rowVectorGet( r1 );
  //
  //   for( let r2 = r1+1 ; r2 < nrow ; r2++ )
  //   {
  //     let row2 = self.rowVectorGet( r2 );
  //     let scaler = row2.eGet( r1 ) / row1.eGet( r1 );
  //     vector.subScaled( row2, row1, scaler );
  //   }
  //
  // }
  //
  // return self;
}

//

function triangulateGausianNormal( y )
{
  let self = this;
  let o = Object.create( null );
  o.y = y;
  o.normal = 1;
  return self._triangulateGausian( o );

  //

  self = this;
  let nrow = self.nrow;
  let ncol = Math.min( self.ncol, nrow );

  if( y !== undefined )
  y = Self.from( y );

  _.assert( arguments.length === 0 || arguments.length === 1 );
  _.assert( !y || y.dims[ 0 ] === self.dims[ 0 ] );

  if( y )
  for( let r1 = 0 ; r1 < ncol ; r1++ )
  {
    let row1 = self.rowVectorGet( r1 );
    let yrow1 = y.rowVectorGet( r1 );
    let scaler1 = row1.eGet( r1 );
    vector.divScalar( row1, scaler1 );
    vector.divScalar( yrow1, scaler1 );

    for( let r2 = r1+1 ; r2 < nrow ; r2++ )
    {
      let row2 = self.rowVectorGet( r2 );
      let yrow2 = y.rowVectorGet( r2 );
      let scaler = row2.eGet( r1 );
      vector.subScaled( row2, row1, scaler );
      vector.subScaled( yrow2, yrow1, scaler );
    }

  }
  else for( let r1 = 0 ; r1 < ncol ; r1++ )
  {
    let row1 = self.rowVectorGet( r1 );
    let scaler1 = row1.eGet( r1 );
    vector.divScalar( row1, scaler1 );

    for( let r2 = r1+1 ; r2 < nrow ; r2++ )
    {
      let row2 = self.rowVectorGet( r2 );
      let scaler = row2.eGet( r1 );
      vector.subScaled( row2, row1, scaler );
    }

  }

  return self;
}

//

function triangulateGausianPivoting( y )
{
  let self = this;
  let o = Object.create( null );
  o.y = y;
  o.onPivot = self._pivotRook;
  return self._triangulateGausian( o );
}

//

function triangulateLu()
{
  let self = this;
  let nrow = self.nrow;
  let ncol = Math.min( self.ncol, nrow );

  _.assert( arguments.length === 0, 'Expects no arguments' );

  logger.log( 'self', self );

  for( let r1 = 0 ; r1 < ncol ; r1++ )
  {
    let row1 = self.rowVectorGet( r1 );
    let scaler1 = row1.eGet( r1 );
    row1 = row1.subarray( r1+1 );

    for( let r2 = r1+1 ; r2 < nrow ; r2++ )
    {
      let row2 = self.rowVectorGet( r2 );
      let scaler = row2.eGet( r1 ) / scaler1;
      vector.subScaled( row2.subarray( r1+1 ), row1, scaler );
      row2.eSet( r1, scaler );
    }

    logger.log( 'self', self );
  }

  return self;
}

//

function triangulateLuNormal()
{
  let self = this;
  let nrow = self.nrow;
  let ncol = Math.min( self.ncol, nrow );

  _.assert( arguments.length === 0, 'Expects no arguments' );

  for( let r1 = 0 ; r1 < ncol ; r1++ )
  {
    let row1 = self.rowVectorGet( r1 );
    let scaler1 = row1.eGet( r1 );
    row1 = row1.subarray( r1+1 );
    vector.divScalar( row1, scaler1 );

    for( let r2 = r1+1 ; r2 < nrow ; r2++ )
    {
      let row2 = self.rowVectorGet( r2 );
      let scaler = row2.eGet( r1 );
      vector.subScaled( row2.subarray( r1+1 ), row1, scaler );
      row2.eSet( r1, scaler );
    }

  }

  return self;
}

//

function triangulateLuPivoting( pivots )
{
  let self = this;
  let nrow = self.nrow;
  let ncol = Math.min( self.ncol, nrow );

  if( !pivots )
  {
    pivots = [];
    for( let i = 0 ; i < self.dims.length ; i += 1 )
    pivots[ i ] = _.longFromRange([ 0, self.dims[ i ] ]);
  }

  let o = Object.create( null );
  o.pivots = pivots;

  /* */

  _.assert( self.dims.length === 2 );
  _.assert( _.arrayIs( pivots ) );
  _.assert( pivots.length === 2 );
  _.assert( arguments.length === 0 || arguments.length === 1 );

  /* */

  logger.log( 'self', self );

  for( let r1 = 0 ; r1 < ncol ; r1++ )
  {

    self._pivotRook.call( self, r1, o );

    let row1 = self.rowVectorGet( r1 );
    let scaler1 = row1.eGet( r1 );
    row1 = row1.subarray( r1+1 );

    for( let r2 = r1+1 ; r2 < nrow ; r2++ )
    {
      let row2 = self.rowVectorGet( r2 );
      let scaler = row2.eGet( r1 ) / scaler1;
      vector.subScaled( row2.subarray( r1+1 ), row1, scaler );
      row2.eSet( r1, scaler );
    }

    logger.log( 'self', self );

  }

  return pivots;
}

//

function _pivotRook( i, o )
{
  let self = this;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( o.pivots )

  let row1 = self.rowVectorGet( i ).subarray( i );
  let col1 = self.colVectorGet( i ).subarray( i );
  let value = row1.eGet( 0 );

  let maxr = vector.reduceToMaxAbs( row1 );
  let maxc = vector.reduceToMaxAbs( col1 );

  if( maxr.value > maxc.value )
  {
    if( maxr.value === value )
    return false;
    let i2 = maxr.index + i;
    _.longSwapElements( o.pivots[ 1 ], i, i2 );
    self.colsSwap( i, i2 );
  }
  else
  {
    if( maxc.value === value )
    return false;
    let i2 = maxc.index + i;
    _.longSwapElements( o.pivots[ 0 ], i, i2 );
    self.rowsSwap( i, i2 );
    if( o.y )
    o.y.rowsSwap( i, i2 );
  }

  return true;
}

// --
// solver
// --

function solve( x, m, y )
{
  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  return this.solveWithTrianglesPivoting( x, m, y )
}

//

function _solveOptions( args )
{
  let o = Object.create( null );
  o.x = args[ 0 ];
  o.m = args[ 1 ];
  o.y = args[ 2 ];

  o.oy = o.y;
  o.ox = o.x;

  if( o.x === null )
  {
    if( _.longIs( o.y ) )
    o.x = o.y.slice();
    else
    o.x = o.y.clone();
    o.ox = o.x;
  }
  else
  {
    if( !_.matrixIs( o.x ) )
    o.x = vector.From( o.x );
    this.CopyTo( o.x, o.y );
  }

  if( !_.matrixIs( o.y ) )
  o.y = vector.From( o.y );

  if( !_.matrixIs( o.x ) )
  o.x = vector.From( o.x );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( this.ShapesAreSame( o.x , o.y ) );
  _.assert( o.m.dims[ 0 ] === this.NrowOf( o.x ) );

  return o;
}

//

function solveWithGausian()
{
  let o = this._solveOptions( arguments );

  o.m.triangulateGausian( o.x );
  this.solveTriangleUpper( o.x, o.m, o.x );

  // o.x = this.convertToClass( o.oy.constructor, o.x );
  return o.ox;
}

//

function solveWithGausianPivoting()
{
  let o = this._solveOptions( arguments );

  let pivots = o.m.triangulateGausianPivoting( o.x );
  this.solveTriangleUpper( o.x, o.m, o.x );
  Self.VectorPivotBackward( o.x, pivots[ 1 ] );

  return o.ox;
}

//

function _solveWithGaussJordan( o )
{

  let nrow = o.m.nrow;
  let ncol = Math.min( o.m.ncol, nrow );

  o.x = this.from( o.x );
  o.y = o.x;

  /* */

  if( o.onPivot && !o.pivots )
  {
    o.pivots = [];
    for( let i = 0 ; i < o.m.dims.length ; i += 1 )
    o.pivots[ i ] = _.longFromRange([ 0, o.m.dims[ i ] ]);
  }

  /* */

  for( let r1 = 0 ; r1 < ncol ; r1++ )
  {

    if( o.onPivot )
    o.onPivot.call( o.m, r1, o );

    let row1 = o.m.rowVectorGet( r1 );
    let scaler1 = row1.eGet( r1 );

    if( abs( scaler1 ) < this.accuracy )
    continue;

    vector.mulScalar( row1, 1/scaler1 );

    let xrow1 = o.x.rowVectorGet( r1 );
    vector.mulScalar( xrow1, 1/scaler1 );

    for( let r2 = 0 ; r2 < nrow ; r2++ )
    {

      if( r1 === r2 )
      continue;

      let xrow2 = o.x.rowVectorGet( r2 );
      let row2 = o.m.rowVectorGet( r2 );
      let scaler2 = row2.eGet( r1 );
      let scaler = scaler2;

      vector.subScaled( row2, row1, scaler );
      vector.subScaled( xrow2, xrow1, scaler );

    }

  }

  /* */

  if( o.onPivot && o.pivotingBackward )
  {
    Self.VectorPivotBackward( o.x, o.pivots[ 1 ] );
    /*o.m.pivotBackward( o.pivots );*/
  }

  /* */

  // o.x = this.convertToClass( o.oy.constructor, o.x );
  return o.ox;
}

//

function solveWithGaussJordan()
{
  let o = this._solveOptions( arguments );
  return this._solveWithGaussJordan( o );
}

//

function solveWithGaussJordanPivoting()
{
  let o = this._solveOptions( arguments );
  o.onPivot = this._pivotRook;
  o.pivotingBackward = 1;
  return this._solveWithGaussJordan( o );
}

//

function invertWithGaussJordan()
{
  let m = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( m.dims[ 0 ] === m.dims[ 1 ] );

  let nrow = m.nrow;

  for( let r1 = 0 ; r1 < nrow ; r1++ )
  {

    let row1 = m.rowVectorGet( r1 ).subarray( r1+1 );
    let xrow1 = m.rowVectorGet( r1 ).subarray( 0, r1+1 );

    let scaler1 = 1 / xrow1.eGet( r1 );
    xrow1.eSet( r1, 1 );
    vector.mulScalar( row1, scaler1 );
    vector.mulScalar( xrow1, scaler1 );

    for( let r2 = 0 ; r2 < nrow ; r2++ )
    {

      if( r1 === r2 )
      continue;

      let row2 = m.rowVectorGet( r2 ).subarray( r1+1 );
      let xrow2 = m.rowVectorGet( r2 ).subarray( 0, r1+1 );
      let scaler2 = xrow2.eGet( r1 );
      xrow2.eSet( r1, 0 )

      vector.subScaled( row2, row1, scaler2 );
      vector.subScaled( xrow2, xrow1, scaler2 );

    }

    // logger.log( 'm', m );

  }

  return m;
}

//

function solveWithTriangles( x, m, y )
{

  let o = this._solveOptions( arguments );
  m.triangulateLuNormal();

  o.x = this.solveTriangleLower( o.x, o.m, o.y );
  o.x = this.solveTriangleUpperNormal( o.x, o.m, o.x );

  // o.x = this.convertToClass( o.oy.constructor, o.x );
  return o.ox;
}

//

function solveWithTrianglesPivoting( x, m, y )
{

  let o = this._solveOptions( arguments );
  let pivots = m.triangulateLuPivoting();

  o.y = Self.VectorPivotForward( o.y, pivots[ 0 ] );

  o.x = this.solveTriangleLowerNormal( o.x, o.m, o.y );
  o.x = this.solveTriangleUpper( o.x, o.m, o.x );

  Self.VectorPivotBackward( o.x, pivots[ 1 ] );
  Self.VectorPivotBackward( o.y, pivots[ 0 ] );

  // o.x = this.convertToClass( o.oy.constructor, o.x );
  return o.ox;
}

//

function _solveTriangleWithRoutine( args, onSolve )
{
  let x = args[ 0 ];
  let m = args[ 1 ];
  let y = args[ 2 ];

  _.assert( args.length === 3 );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( y );

  if( _.matrixIs( y ) )
  {

    if( x === null )
    {
      x = y.clone();
    }
    else
    {
      x = Self.from( x, y.dims );
      x.copy( y );
    }

    _.assert( x.hasShape( y ) );
    _.assert( x.dims[ 0 ] === m.dims[ 1 ] );

    for( let v = 0 ; v < y.dims[ 1 ] ; v++ )
    {
      onSolve( x.colVectorGet( v ), m, y.colVectorGet( v ) );
    }

    return x;
  }

  /* */

  y = _.vectorAdapter.From( y );

  if( x === null )
  {
    x = y.clone();
  }
  else
  {
    x = _.vectorAdapter.From( x );
    x.copy( y );
  }

  /* */

  _.assert( x.length === y.length );

  return onSolve( x, m, y );
}

//

function solveTriangleLower( x, m, y )
{

  function handleSolve( x, m, y )
  {

    for( let r1 = 0 ; r1 < y.length ; r1++ )
    {
      let xu = x.subarray( 0, r1 );
      let row = m.rowVectorGet( r1 );
      let scaler = row.eGet( r1 );
      row = row.subarray( 0, r1 );
      let xval = ( x.eGet( r1 ) - _.vectorAdapter.dot( row, xu ) ) / scaler;
      x.eSet( r1, xval );
    }

    return x;
  }

  return this._solveTriangleWithRoutine( arguments, handleSolve );
}

//

function solveTriangleLowerNormal( x, m, y )
{

  function handleSolve( x, m, y )
  {

    for( let r1 = 0 ; r1 < y.length ; r1++ )
    {
      let xu = x.subarray( 0, r1 );
      let row = m.rowVectorGet( r1 );
      row = row.subarray( 0, r1 );
      let xval = ( x.eGet( r1 ) - _.vectorAdapter.dot( row, xu ) );
      x.eSet( r1, xval );
    }

    return x;
  }

  return this._solveTriangleWithRoutine( arguments, handleSolve );
}

//

function solveTriangleUpper( x, m, y )
{

  function handleSolve( x, m, y )
  {

    for( let r1 = y.length-1 ; r1 >= 0 ; r1-- )
    {
      let xu = x.subarray( r1+1, x.length );
      let row = m.rowVectorGet( r1 );
      let scaler = row.eGet( r1 );
      row = row.subarray( r1+1, row.length );
      let xval = ( x.eGet( r1 ) - _.vectorAdapter.dot( row, xu ) ) / scaler;
      x.eSet( r1, xval );
    }

    return x;
  }

  return this._solveTriangleWithRoutine( arguments, handleSolve );
}

//

function solveTriangleUpperNormal( x, m, y )
{

  function handleSolve( x, m, y )
  {

    for( let r1 = y.length-1 ; r1 >= 0 ; r1-- )
    {
      let xu = x.subarray( r1+1, x.length );
      let row = m.rowVectorGet( r1 );
      row = row.subarray( r1+1, row.length );
      let xval = ( x.eGet( r1 ) - _.vectorAdapter.dot( row, xu ) );
      x.eSet( r1, xval );
    }

    return x;
  }

  return this._solveTriangleWithRoutine( arguments, handleSolve );
}

//

function solveGeneral( o )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routineOptions( solveGeneral, o );

  /* */

  let result = Object.create( null );
  result.nsolutions = 1;
  result.kernel = o.kernel;
  result.nkernel = 0;

  /* alloc */

  if( o.m.nrow < o.m.ncol )
  {
    let missing = o.m.ncol - o.m.nrow;
    o.m.expand([ [ 0, missing ], 0 ]);
    o.y.expand([ [ 0, missing ], 0 ]);
  }

  if( !result.kernel )
  result.kernel = Self.makeZero( o.m.dims );
  let nrow = o.m.nrow;

  /* verify */

  _.assert( o.m.nrow === o.y.nrow );
  _.assert( o.m.nrow === result.kernel.nrow );
  _.assert( result.kernel.hasShape( o.m ) );
  _.assert( o.y instanceof Self );
  _.assert( o.y.dims[ 1 ] === 1 );

  /* solve */

  let optionsForMethod;
  if( o.pivoting )
  {
    optionsForMethod = this._solveOptions([ o.x, o.m, o.y ]);
    optionsForMethod.onPivot = this._pivotRook;
    optionsForMethod.pivotingBackward = 0;
    o.x = result.base = this._solveWithGaussJordan( optionsForMethod );
  }
  else
  {
    optionsForMethod = this._solveOptions([ o.x, o.m, o.y ]);
    o.x = result.base = this._solveWithGaussJordan( optionsForMethod );
  }

  /* analyse */

  logger.log( 'm', o.m );
  logger.log( 'x', o.x );

  for( let r = 0 ; r < nrow ; r++ )
  {
    let row = o.m.rowVectorGet( r );
    if( abs( row.eGet( r ) ) < this.accuracy )
    {
      if( abs( o.x.atomGet([ r, 0 ]) ) < this.accuracy )
      {
        result.nsolutions = Infinity;
        let termCol = result.kernel.colVectorGet( r );
        let srcCol = o.m.colVectorGet( r );
        termCol.copy( srcCol );
        vector.mulScalar( termCol, -1 );
        termCol.eSet( r, 1 );
        result.nkernel += 1;
      }
      else
      {
        debugger;
        result.nsolutions = 0;
        return result;
      }
    }
  }

  if( o.pivoting )
  {
    Self.VectorPivotBackward( result.base, optionsForMethod.pivots[ 1 ] );
    result.kernel.pivotBackward([ optionsForMethod.pivots[ 1 ], optionsForMethod.pivots[ 0 ] ]);
    o.m.pivotBackward( optionsForMethod.pivots );
  }

  return result;
}

solveGeneral.defaults =
{
  x : null,
  m : null,
  y : null,
  kernel : null,
  pivoting : 1,
}

//

function invert()
{
  let self = this;

  _.assert( self.dims.length === 2 );
  _.assert( self.isSquare() );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  return self.invertWithGaussJordan();
}

//

function invertingClone()
{
  let self = this;

  _.assert( self.dims.length === 2 );
  _.assert( self.isSquare() );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  return Self.solveWithGaussJordan( null, self.clone(), self.Self.makeIdentity( self.dims[ 0 ] ) );
}

//

function copyAndInvert( src )
{
  let self = this;

  _.assert( self.dims.length === 2 );
  _.assert( self.isSquare() );
  _.assert( arguments.length === 1, 'Expects single argument' );

  self.copy( src );
  self.invert();

  return self;
}

//

function normalProjectionMatrixMake()
{
  let self = this;
  debugger;
  return self.clone().invert().transpose();
}

//

function normalProjectionMatrixGet( src )
{
  let self = this;

  if( src.hasShape([ 4, 4 ]) )
  {
    // debugger;

    let s00 = self.atomGet([ 0, 0 ]), s10 = self.atomGet([ 1, 0 ]), s20 = self.atomGet([ 2, 0 ]);
    let s01 = self.atomGet([ 0, 1 ]), s11 = self.atomGet([ 1, 1 ]), s21 = self.atomGet([ 2, 1 ]);
    let s02 = self.atomGet([ 0, 2 ]), s12 = self.atomGet([ 1, 2 ]), s22 = self.atomGet([ 2, 2 ]);

    let d1 = s22 * s11 - s21 * s12;
    let d2 = s21 * s02 - s22 * s01;
    let d3 = s12 * s01 - s11 * s02;

    let determiant = s00 * d1 + s10 * d2 + s20 * d3;

    if( determiant === 0 )
    throw _.err( 'normalProjectionMatrixGet : zero determinant' );

    determiant = 1 / determiant;

    let d00 = d1 * determiant;
    let d10 = ( s20 * s12 - s22 * s10 ) * determiant;
    let d20 = ( s21 * s10 - s20 * s11 ) * determiant;

    let d01 = d2 * determiant;
    let d11 = ( s22 * s00 - s20 * s02 ) * determiant;
    let d21 = ( s20 * s01 - s21 * s00 ) * determiant;

    let d02 = d3 * determiant;
    let d12 = ( s10 * s02 - s12 * s00 ) * determiant;
    let d22 = ( s11 * s00 - s10 * s01 ) * determiant;

    self.atomSet( [ 0, 0 ], d00 );
    self.atomSet( [ 1, 0 ], d10 );
    self.atomSet( [ 2, 0 ], d20 );

    self.atomSet( [ 0, 1 ], d01 );
    self.atomSet( [ 1, 1 ], d11 );
    self.atomSet( [ 2, 1 ], d21 );

    self.atomSet( [ 0, 2 ], d02 );
    self.atomSet( [ 1, 2 ], d12 );
    self.atomSet( [ 2, 2 ], d22 );

    return self;
  }

  // debugger;
  let sub = src.submatrix([ [ 0, src.dims[ 0 ]-1 ], [ 0, src.dims[ 1 ]-1 ] ]);
  // debugger;

  return self.copy( sub ).invert().transpose();
}

// --
// top
// --

function _linearModel( o )
{

  _.routineOptions( polynomExactFor, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( o.order >= 1 );

  if( o.points )
  if( o.order === null )
  o.order = o.points.length;

  if( o.npoints === null )
  o.npoints = o.points ? o.points.length : o.order;

  let m = this.makeZero([ o.npoints, o.order ]);
  let ys = [];

  /* */

  let i = 0;
  function fixPoint( p )
  {
    ys[ i ] = p[ 1 ];
    let row = m.rowVectorGet( i )
    for( let d = 0 ; d < o.order ; d++ )
    row.eSet( d, pow( p[ 0 ], d ) );
    i += 1;
  }

  /* */

  if( o.points )
  {

    for( let p = 0 ; p < o.points.length ; p++ )
    fixPoint( o.points[ p ] );

  }
  else
  {

    if( o.domain === null )
    o.domain = [ 0, o.order ]

    _.assert( o.order === o.domain[ 1 ] - o.domain[ 0 ] )

    let x = o.domain[ 0 ];
    while( x < o.domain[ 1 ] )
    {
      let y = o.onFunction( x );
      fixPoint([ x, y ]);
      x += 1;
    }

  }

  /* */

  let result = Object.create( null );

  result.m = m;
  result.y = ys;

  return result;
}

_linearModel.defaults =
{
  npoints : null,
  points : null,
  domain : null,
  order : null,
  onFunction : null,
}

//

function polynomExactFor( o )
{

  _.routineOptions( polynomExactFor, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( o.points )
  _.assert( o.order === null || o.order === o.points.length );

  let model = this._linearModel( o );
  let result = this.solve( null , model.m , model.y );

  return result;
}

polynomExactFor.defaults =
{
}

polynomExactFor.defaults.__proto__ = _linearModel.defaults;

//

function polynomClosestFor( o )
{

  _.routineOptions( polynomExactFor, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let model = this._linearModel( o );

  let mt = model.m.clone().transpose();
  let y = this.mul( null , [ mt , model.y ] );
  let m = this.mul( null , [ mt , model.m ] );

  let result = this.solve( null , m , y );

  return result;
}

polynomClosestFor.defaults =
{
  points : null,
  domain : null,
  order : null,
  onFunction : null,
}

polynomClosestFor.defaults.__proto__ = _linearModel.defaults;

// --
// projector
// --

// function formPerspective( fov, width, height, near, far )
function formPerspective( fov, size, depth )
{
  let self = this;
  let aspect = size[ 0 ] / size[ 1 ];

  // debugger;
  // _.assert( 0, 'not tested' );

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  _.assert( size.length === 2 );
  _.assert( depth.length === 2 );
  _.assert( self.hasShape([ 4, 4 ]) );

  fov = Math.tan( _.degToRad( fov * 0.5 ) );

  let ymin = - depth[ 0 ] * fov;
  let ymax = - ymin;

  let xmin = ymin;
  let xmax = ymax;

  if( aspect > 1 )
  {

    xmin *= aspect;
    xmax *= aspect;

  }
  else
  {

    ymin /= aspect;
    ymax /= aspect;

  }

  /* logger.log({ xmin, xmax, ymin, ymax }); */

  return self.formFrustum( [ xmin, xmax ], [ ymin, ymax ], depth );
}

//

// function formFrustum( left, right, bottom, top, near, far )
function formFrustum( horizontal, vertical, depth )
{
  let self = this;

  // debugger;
  // _.assert( 0, 'not tested' );

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  _.assert( horizontal.length === 2 );
  _.assert( vertical.length === 2 );
  _.assert( depth.length === 2 );
  _.assert( self.hasShape([ 4, 4 ]) );

  // let te = this.buffer;
  let x = 2 * depth[ 0 ] / ( horizontal[ 1 ] - horizontal[ 0 ] );
  let y = 2 * depth[ 0 ] / ( vertical[ 1 ] - vertical[ 0 ] );

  let a = ( horizontal[ 1 ] + horizontal[ 0 ] ) / ( horizontal[ 1 ] - horizontal[ 0 ] );
  let b = ( vertical[ 1 ] + vertical[ 0 ] ) / ( vertical[ 1 ] - vertical[ 0 ] );
  let c = - ( depth[ 1 ] + depth[ 0 ] ) / ( depth[ 1 ] - depth[ 0 ] );
  let d = - 2 * depth[ 1 ] * depth[ 0 ] / ( depth[ 1 ] - depth[ 0 ] );

  self.atomSet( [ 0, 0 ], x );
  self.atomSet( [ 1, 0 ], 0 );
  self.atomSet( [ 2, 0 ], 0 );
  self.atomSet( [ 3, 0 ], 0 );

  self.atomSet( [ 0, 1 ], 0 );
  self.atomSet( [ 1, 1 ], y );
  self.atomSet( [ 2, 1 ], 0 );
  self.atomSet( [ 3, 1 ], 0 );

  self.atomSet( [ 0, 2 ], a );
  self.atomSet( [ 1, 2 ], b );
  self.atomSet( [ 2, 2 ], c );
  self.atomSet( [ 3, 2 ], -1 );

  self.atomSet( [ 0, 3 ], 0 );
  self.atomSet( [ 1, 3 ], 0 );
  self.atomSet( [ 2, 3 ], d );
  self.atomSet( [ 3, 3 ], 0 );

  // debugger;
  return self;
}

//

// function formOrthographic( left, right, top, bottom, near, far )
function formOrthographic( horizontal, vertical, depth )
{
  let self = this;

  // debugger;
  // _.assert( 0, 'not tested' );

  _.assert( arguments.length === 3, 'Expects exactly three arguments' );
  _.assert( horizontal.length === 2 );
  _.assert( vertical.length === 2 );
  _.assert( depth.length === 2 );
  _.assert( self.hasShape([ 4, 4 ]) );

  let w = horizontal[ 1 ] - horizontal[ 0 ];
  let h = vertical[ 1 ] - vertical[ 0 ];
  let d = depth[ 1 ] - depth[ 0 ];

  let x = ( horizontal[ 1 ] + horizontal[ 0 ] ) / w;
  let y = ( vertical[ 1 ] + vertical[ 0 ] ) / h;
  let z = ( depth[ 1 ] + depth[ 0 ] ) / d;

  self.atomSet( [ 0, 0 ], 2 / w );
  self.atomSet( [ 1, 0 ], 0 );
  self.atomSet( [ 2, 0 ], 0 );
  self.atomSet( [ 3, 0 ], 0 );

  self.atomSet( [ 0, 1 ], 0 );
  self.atomSet( [ 1, 1 ], 2 / h );
  self.atomSet( [ 2, 1 ], 0 );
  self.atomSet( [ 3, 1 ], 0 );

  self.atomSet( [ 0, 2 ], 0 );
  self.atomSet( [ 1, 2 ], 0 );
  self.atomSet( [ 2, 2 ], -2 / d );
  self.atomSet( [ 3, 2 ], 0 );

  self.atomSet( [ 0, 3 ], -x );
  self.atomSet( [ 1, 3 ], -y );
  self.atomSet( [ 2, 3 ], -z );
  self.atomSet( [ 3, 3 ], 1 );

  // te[ 0 ] = 2 / w; te[ 4 ] = 0; te[ 8 ] = 0; te[ 12 ] = - x;
  // te[ 1 ] = 0; te[ 5 ] = 2 / h; te[ 9 ] = 0; te[ 13 ] = - y;
  // te[ 2 ] = 0; te[ 6 ] = 0; te[ 10 ] = - 2 / d; te[ 14 ] = - z;
  // te[ 3 ] = 0; te[ 7 ] = 0; te[ 11 ] = 0; te[ 15 ] = 1;

  return self;
}

//

let lookAt = ( function lookAt()
{

  let x = [ 0, 0, 0 ];
  let y = [ 0, 0, 0 ];
  let z = [ 0, 0, 0 ];

  return function( eye, target, up1 )
  {

    debugger;
    _.assert( 0, 'not tested' );

    let self = this;
    let te = this.buffer;

    _.avector.subVectors( z, eye, target ).normalize();

    if ( _.avector.mag( z ) === 0 )
    {

      z[ 2 ] = 1;

    }

    debugger;
    _.avector._cross3( x, up1, z );
    let xmag = _.avector.mag( x );

    if ( xmag === 0 )
    {

      z[ 0 ] += 0.0001;
      _.avector._cross3( x, up1, z );
      xmag = _.avector.mag( x );

    }

    _.avector.mulScalar( x, 1 / xmag );

    _.avector._cross3( y, z, x );

    te[ 0 ] = x[ 0 ]; te[ 4 ] = y[ 0 ]; te[ 8 ] = z[ 0 ];
    te[ 1 ] = x[ 1 ]; te[ 5 ] = y[ 1 ]; te[ 9 ] = z[ 1 ];
    te[ 2 ] = x[ 2 ]; te[ 6 ] = y[ 2 ]; te[ 10 ] = z[ 2 ];

    return this;
  }

})();

// --
// reducer
// --

function closest( insElement )
{
  let self = this;
  insElement = vector.FromLong( insElement );
  let result =
  {
    index : null,
    distance : +Infinity,
  }

  _.assert( arguments.length === 1, 'Expects single argument' );

  for( let i = 0 ; i < self.length ; i += 1 )
  {

    let d = vector.distanceSqr( insElement, self.eGet( i ) );
    if( d < result.distance )
    {
      result.distance = d;
      result.index = i;
    }

  }

  result.distance = sqrt( result.distance );

  return result;
}

//

function furthest( insElement )
{
  let self = this;
  insElement = vector.FromLong( insElement );
  let result =
  {
    index : null,
    distance : -Infinity,
  }

  _.assert( arguments.length === 1, 'Expects single argument' );

  for( let i = 0 ; i < self.length ; i += 1 )
  {

    let d = vector.distanceSqr( insElement, self.eGet( i ) );
    if( d > result.distance )
    {
      result.distance = d;
      result.index = i;
    }

  }

  result.distance = sqrt( result.distance );

  return result;
}

//

function elementMean()
{
  let self = this;

  let result = self.elementAdd();

  vector.divScalar( result, self.length );

  return result;
}

//

function minmaxColWise()
{
  let self = this;

  let minmax = self.distributionRangeSummaryValueColWise();
  let result = Object.create( null );

  result.min = self.long.longMakeUndefined( self.buffer, minmax.length );
  result.max = self.long.longMakeUndefined( self.buffer, minmax.length );

  for( let i = 0 ; i < minmax.length ; i += 1 )
  {
    result.min[ i ] = minmax[ i ][ 0 ];
    result.max[ i ] = minmax[ i ][ 1 ];
  }

  return result;
}

//

function minmaxRowWise()
{
  let self = this;

  let minmax = self.distributionRangeSummaryValueRowWise();
  let result = Object.create( null );

  result.min = self.long.longMakeUndefined( self.buffer, minmax.length );
  result.max = self.long.longMakeUndefined( self.buffer, minmax.length );

  for( let i = 0 ; i < minmax.length ; i += 1 )
  {
    result.min[ i ] = minmax[ i ][ 0 ];
    result.max[ i ] = minmax[ i ][ 1 ];
  }

  return result;
}

//

function determinant()
{
  let self = this;
  let l = self.length;

  if( l === 0 )
  return 0;

  let iterations = _.factorial( l );
  let result = 0;

  _.assert( l === self.atomsPerElement );

  /* */

  let sign = 1;
  let index = [];
  for( let i = 0 ; i < l ; i += 1 )
  index[ i ] = i;

  /* */

  function add()
  {
    let r = 1;
    for( let i = 0 ; i < l ; i += 1 )
    r *= self.atomGet([ index[ i ], i ]);
    r *= sign;
    // console.log( index );
    // console.log( r );
    result += r;
    return r;
  }

  /* */

  function swap( a, b )
  {
    let v = index[ a ];
    index[ a ] = index[ b ];
    index[ b ] = v;
    sign *= -1;
  }

  /* */

  let i = 0;
  while( i < iterations )
  {

    for( let s = 0 ; s < l-1 ; s++ )
    {
      let r = add();
      //console.log( 'add', i, index, r );
      swap( s, l-1 );
      i += 1;
    }

  }

  /* */

  // 00
  // 01
  //
  // 012
  // 021
  // 102
  // 120
  // 201
  // 210

  // console.log( 'determinant', result );

  return result;
}

// --
// relations
// --

let Statics = /* qqq : split static routines. ask how */
{

  /* make */

  make,
  makeSquare,
  // makeSquare2,
  // makeSquare3,
  // makeSquare4,

  makeZero,
  makeIdentity,
  makeIdentity2,
  makeIdentity3,
  makeIdentity4,

  makeDiagonal,
  makeSimilar,

  makeLine,
  makeCol,
  makeColZeroed,
  makeRow,
  makeRowZeroed,

  fromVectorAdapter,
  fromScalar,
  fromScalarForReading,
  from,
  fromForReading,

  _tempBorrow,
  tempBorrow : tempBorrow1,
  tempBorrow1,
  tempBorrow2,
  tempBorrow3,

  convertToClass,


  /* mul */

  mul : mul_static,
  mul2Matrices : mul2Matrices_static,


  /* solve */

  _pivotRook,

  solve,

  _solveOptions,

  solveWithGausian,
  solveWithGausianPivoting,

  _solveWithGaussJordan,
  solveWithGaussJordan,
  solveWithGaussJordanPivoting,
  invertWithGaussJordan,

  solveWithTriangles,
  solveWithTrianglesPivoting,

  _solveTriangleWithRoutine,
  solveTriangleLower,
  solveTriangleLowerNormal,
  solveTriangleUpper,
  solveTriangleUpperNormal,

  solveGeneral,


  /* modeler */

  _linearModel,
  polynomExactFor,
  polynomClosestFor,


  /* var */

  _tempMatrices : [ Object.create( null ) , Object.create( null ) , Object.create( null ) ],

}

/*
map
filter
reduce
zip
*/

// --
// declare
// --

let Extend =
{

  // make

  make,
  makeSquare,

  // makeSquare2,
  // makeSquare3,
  // makeSquare4,

  makeZero,

  makeIdentity,
  makeIdentity2,
  makeIdentity3,
  makeIdentity4,

  makeDiagonal,
  makeSimilar,

  makeLine,
  makeCol,
  makeColZeroed,
  makeRow,
  makeRowZeroed,

  // convert

  convertToClass,

  fromVectorAdapter,
  fromScalar,
  fromScalarForReading,
  from,
  fromForReading,

  fromTransformations,
  fromQuat,
  fromQuatWithScale,

  fromAxisAndAngle,

  fromEuler,

  // borrow

  _tempBorrow,
  tempBorrow : tempBorrow1,
  tempBorrow1,
  tempBorrow2,
  tempBorrow3,

  // mul

  pow : matrixPow,
  mul,
  mul2Matrices,
  mulLeft,
  mulRight,

  // partial accessors

  zero,
  identify,
  diagonalSet,
  diagonalVectorGet,
  triangleLowerSet,
  triangleUpperSet,

  // transformer

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

  // triangulator

  _triangulateGausian,
  triangulateGausian,
  triangulateGausianNormal,
  triangulateGausianPivoting,

  triangulateLu,
  triangulateLuNormal,
  triangulateLuPivoting,

  _pivotRook,

  // solver

  solve,

  _solveOptions,

  solveWithGausian,
  solveWithGausianPivoting,

  _solveWithGaussJordan,
  solveWithGaussJordan,
  solveWithGaussJordanPivoting,
  invertWithGaussJordan,

  solveWithTriangles,
  solveWithTrianglesPivoting,

  _solveTriangleWithRoutine,
  solveTriangleLower,
  solveTriangleLowerNormal,
  solveTriangleUpper,
  solveTriangleUpperNormal,

  solveGeneral,

  invert,
  invertingClone,
  copyAndInvert,

  normalProjectionMatrixMake,
  normalProjectionMatrixGet,

  // modeler

  _linearModel,

  polynomExactFor,
  polynomClosestFor,

  // projector

  formPerspective,
  formFrustum,
  formOrthographic,
  lookAt,

  // reducer

  closest,
  furthest,

  elementMean,

  minmaxColWise,
  minmaxRowWise,

  determinant,

  //

  Statics,

}

_.classExtend( Self, Extend );
_.assert( Self.from === from );
_.assert( Self.mul2Matrices === mul2Matrices_static );
_.assert( Self.prototype.mul2Matrices === mul2Matrices );

})();
