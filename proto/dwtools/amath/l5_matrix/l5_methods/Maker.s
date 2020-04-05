(function _Make_s_() {

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

_.assert( _.objectIs( _.vectorAdapter ) );
_.assert( _.routineIs( Self ), 'wMatrix is not defined, please include wMatrix.s first' );

// --
// details
// --

function _BufferFrom( src )
{
  let proto = this.Self.prototype;
  let dst = src;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.longIs( src ) || _.vectorAdapterIs( src ) );

  if( _.vectorAdapterIs( dst ) && _.arrayIs( dst._vectorBuffer ) )
  {
    dst = this.long.longMake( src.length );
    for( let i = 0 ; i < src.length ; i++ )
    dst[ i ] = src.eGet( i );
  }
  else if( _.arrayIs( dst ) )
  {
    dst = proto.long.longFrom( dst );
  }

  return dst;
}

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
    buffer = proto.constructor._BufferFrom( buffer );
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

function MakeSquare( buffer )
{
  let proto = this.Self.prototype;

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
    buffer = proto.constructor._BufferFrom( buffer );
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

function makeSquare_( buffer )
{
  return this.MakeSquare( buffer );
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
    o.buffer = proto._BufferFrom( o.buffer );
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
  o.buffer = proto.constructor._BufferFrom( o.buffer );

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
      result = self.vectorAdapter.fromLong( array );
    }
    else _.assert( 0, 'unknown class (-cls-)', cls.name );

    for( let i = 0 ; i < result.length ; i += 1 )
    array[ i ] = src.atomGet([ i, 0 ]);

  }
  else
  {

    let atomsPerMatrix = src.length;
    src = self.vectorAdapter.from( src );

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
      result = self.vectorAdapter.fromLong( array );
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

  q = self.vectorAdapter.from( q );
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

  q = self.vectorAdapter.from( q );
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
  axis = self.vectorAdapter.from( axis );

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

  _.assert( arguments.length === 1, 'Expects single argument' );

  _.euler.toMatrix( euler, self );

  return self;
}

//

function fromAxisAndAngleWithScale( axis, angle )
{
  let self = this;

  axis = self.vectorAdapter.from( axis );

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
// projector
// --

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

//

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

  fov = Math.tan( _.math.degToRad( fov * 0.5 ) );

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

    debugger;
    _.avector.sub( z, eye, target ).normalize();
    // _.avector.subVectors( z, eye, target ).normalize();

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

    _.avector.mul( x, 1 / xmag );

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
  insElement = self.vectorAdapter.fromLong( insElement );
  let result =
  {
    index : null,
    distance : +Infinity,
  }

  _.assert( arguments.length === 1, 'Expects single argument' );

  for( let i = 0 ; i < self.length ; i += 1 )
  {

    let d = self.vectorAdapter.distanceSqr( insElement, self.eGet( i ) );
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
  insElement = self.vectorAdapter.fromLong( insElement );
  let result =
  {
    index : null,
    distance : -Infinity,
  }

  _.assert( arguments.length === 1, 'Expects single argument' );

  for( let i = 0 ; i < self.length ; i += 1 )
  {

    let d = self.vectorAdapter.distanceSqr( insElement, self.eGet( i ) );
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

  self.vectorAdapter.div( result, self.length );

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

// //
//
// function determinant()
// {
//   let self = this;
//   let l = self.length;
//
//   if( l === 0 )
//   return 0;
//
//   let iterations = _.math.factorial( l );
//   let result = 0;
//
//   _.assert( l === self.atomsPerElement );
//
//   /* */
//
//   let sign = 1;
//   let index = [];
//   for( let i = 0 ; i < l ; i += 1 )
//   index[ i ] = i;
//
//   /* */
//
//   function add()
//   {
//     let r = 1;
//     for( let i = 0 ; i < l ; i += 1 )
//     r *= self.atomGet([ index[ i ], i ]);
//     r *= sign;
//     // console.log( index );
//     // console.log( r );
//     result += r;
//     return r;
//   }
//
//   /* */
//
//   function swap( a, b )
//   {
//     let v = index[ a ];
//     index[ a ] = index[ b ];
//     index[ b ] = v;
//     sign *= -1;
//   }
//
//   /* */
//
//   let i = 0;
//   while( i < iterations )
//   {
//
//     for( let s = 0 ; s < l-1 ; s++ )
//     {
//       let r = add();
//       //console.log( 'add', i, index, r );
//       swap( s, l-1 );
//       i += 1;
//     }
//
//   }
//
//   /* */
//
//   // 00
//   // 01
//   //
//   // 012
//   // 021
//   // 102
//   // 120
//   // 201
//   // 210
//
//   // console.log( 'determinant', result );
//
//   return result;
// }

// --
// relations
// --

let Statics = /* qqq : split static routines. ask how */
{

  /* details */

  _BufferFrom,

  /* make */

  make,
  makeSquare,

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

  convertToClass,

  fromVectorAdapter,
  fromScalar,
  fromScalarForReading,
  from,
  fromForReading,

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

let Extension =
{

  // make

  make,
  makeSquare,
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

  // projector

  normalProjectionMatrixMake,
  normalProjectionMatrixGet,

  formPerspective, /* qqq : static */
  formFrustum, /* qqq : static */
  formOrthographic, /* qqq : static */
  lookAt, /* qqq : static */

  //

  Statics,

}

_.classExtend( Self, Extension );
_.assert( Self.from === from );

})();
