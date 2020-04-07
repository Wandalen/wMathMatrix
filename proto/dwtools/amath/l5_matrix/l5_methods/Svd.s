(function _Svd_s_() {

'use strict';

let _ = _global_.wTools;
let abs = Math.abs; /* xxx */
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
//
// --

/**
  * Split a M matrix into a Q and a R matrices, where M = Q*R, R is upper triangular
  * and the values of its diagonal are the eigenvalues of M, and Q is orthogonal and its columns are
  * the eigenvectors of M. Returns the eigenvalues of M. Matrix stays unchanged.
  *
  * @param { this } - The source matrix.
  * @param { q } - The destination Q matrix.
  * @param { r } - The destination R matrix.
  *
  * @example
  * // returns self.vectorAdapter.from( [ 4, -2, -2 ] );
  * var matrix =  _.Matrix.make( [ 3, 3 ] ).copy
  * ([
  *   1,  -3,  3,
  *   3, - 5,  3,
  *   6, - 6,  4
  * ]);
  * matrix._qrIteration( q, r );
  *
  * @returns { Array } Returns a vector with the values of the diagonal of R.
  * @function _qrIteration
  * @throws { Error } An Error if ( this ) is not a matrix.
  * @memberof module:Tools/math/Matrix.wMatrix#
  */

function _qrIteration( q, r )
{
  let self = this;
  _.assert( _.Matrix.Is( self ) );
  //_.assert( !isNaN( self.clone().invert().atomGet([ 0, 0 ]) ), 'Matrix must be invertible' )

  let cols = self.length;
  let rows = self.atomsPerElement;

  if( arguments.length === 0 )
  {
    var q = _.Matrix.makeIdentity( [ rows, cols ] );
    var r = _.Matrix.make([ rows, cols ]);
  }

  let a = self.clone();
  let loop = 0;
  q.copy( _.Matrix.makeIdentity( rows ) );


  while( a.isUpperTriangle() === false && loop < 1000 )
  {
    var qInt = _.Matrix.makeIdentity([ rows, cols ]);
    var rInt = _.Matrix.makeIdentity([ rows, cols ]);
    a._qrDecompositionHh( qInt, rInt );
    // Calculate transformation matrix
    q.mulLeft( qInt );

    a.mul2Matrices( rInt, qInt );

    loop = loop + 1;
  }

  q.copy( q );
  r.copy( a );

  if( loop === 1000 )
  {
    r.copy( rInt );
  }

  let eigenValues = self.vectorAdapter.toLong( a.diagonalVectorGet() );
  eigenValues.sort( ( a, b ) => b - a );

  logger.log( 'EI', eigenValues)
  for( let i = 0; i < eigenValues.length; i++ )
  {
    let newValue = eigenValues[ i ];
    for( let j = 0; j < eigenValues.length; j++ )
    {
      let value = r.atomGet( [ j, j ] );

      if( newValue === value )
      {
        let oldColQ = q.colVectorGet( i ).clone();
        let oldValue = r.atomGet( [ i, i ] );

        q.colSet( i, q.colVectorGet( j ) );
        q.colSet( j, oldColQ );

        r.atomSet( [ i, i ], r.atomGet( [ j, j ] ) );
        r.atomSet( [ j, j ], oldValue );
      }
    }
  }

  return r.diagonalVectorGet();
}

//

/**
  * Perform the QR Gram-Schmidt decomposition of a M matrix into a Q and a R matrices, where M = Q*R, R is
  * upper triangular, and Q is orthogonal. Matrix stays unchanged.
  *
  * @param { this } - The source matrix.
  * @param { q } - The destination Q matrix.
  * @param { r } - The destination R matrix.
  *
  * @example
  * // returns Q = _.Matrix.make( [ 3, 3 ] ).copy
  * ([
  *   0.857143, -0.467324, -0.216597,
  *   0.428571, 0.880322, -0.203369,
  *   -0.285714, -0.081489, -0.954844
  * ]);
  * returns R = _.Matrix.make( [ 3, 3 ] ).copy
  * ([
  *   14, 34.714287, -14,
  *   0, 172.803116, -58.390148,
  *   0, 0, 52.111328
  * ]);
  *
  * var matrix =  _.Matrix.make( [ 3, 3 ] ).copy
  * ([
  *   12, -51, 4,
  *   6, 167, -68,
  *   -4, -24, -41,
  * ]);
  * matrix._qrDecompositionGS( q, r );
  *
  * @function _qrDecompositionGS
  * @throws { Error } An Error if ( this ) is not a matrix.
  * @throws { Error } An Error if ( q ) is not a matrix.
  * @throws { Error } An Error if ( r ) is not a matrix.
  * @memberof module:Tools/math/Matrix.wMatrix#
  */

function _qrDecompositionGS( q, r )
{
  let self = this;

  _.assert( _.Matrix.Is( self ) );
  _.assert( _.Matrix.Is( q ) );
  _.assert( _.Matrix.Is( r ) );

  let cols = self.length;
  let rows = self.atomsPerElement;

  _.assert( !isNaN( self.clone().invert().atomGet([ 0, 0 ]) ), 'Matrix must be invertible' )

  let matrix = self.clone();
  q.copy( _.Matrix.makeIdentity( [ rows, cols ] ) );

  let qInt = _.Matrix.makeIdentity([ rows, cols ]);

  for( let i = 0; i < cols; i++ )
  {
    let col = matrix.colVectorGet( i );
    let sum = self.vectorAdapter.from( self.long.longMakeZeroed( rows ) );
    for( let j = 0; j < i ; j ++ )
    {
      let dot = self.vectorAdapter.dot( col, self.vectorAdapter.from( qInt.colVectorGet( j ) ) );
      debugger;

      self.vectorAdapter.add( sum, self.vectorAdapter.mul( self.vectorAdapter.from( qInt.colVectorGet( j ) ).clone(), - dot ) );
    }
    let e = self.vectorAdapter.normalize( self.vectorAdapter.add( col.clone(), sum ) );
    qInt.colSet( i, e );
  }

  // Calculate R
  r.mul2Matrices( qInt.clone().transpose(), matrix );

  // Calculate transformation matrix
  q.mulLeft( qInt );
  let a = _.Matrix.make([ cols, rows ]);
}

//

/**
  * Perform the QR Householder decomposition of a M matrix into a Q and a R matrices, where M = Q*R, R is
  * upper triangular, and Q is orthogonal. Matrix stays unchanged.
  *
  * @param { this } - The source matrix.
  * @param { q } - The destination Q matrix.
  * @param { r } - The destination R matrix.
  *
  * @example
  * // returns Q = _.Matrix.make( [ 3, 3 ] ).copy
  * ([
  *   -0.857143, 0.467324, -0.216597,
  *   -0.428571, -0.880322, -0.203369,
  *   0.285714, 0.081489, -0.954844
  * ]);
  * returns R = _.Matrix.make( [ 3, 3 ] ).copy
  * ([
  *   -14, -34.714287, 14,
  *   0, -172.803116, 58.390148,
  *   0, 0, 52.111328
  * ]);
  *
  * var matrix =  _.Matrix.make( [ 3, 3 ] ).copy
  * ([
  *   12, -51, 4,
  *   6, 167, -68,
  *   -4, -24, -41,
  * ]);
  * matrix._qrDecompositionHh( q, r );
  *
  * @function _qrDecompositionHh
  * @throws { Error } An Error if ( this ) is not a matrix.
  * @throws { Error } An Error if ( q ) is not a matrix.
  * @throws { Error } An Error if ( r ) is not a matrix.
  * @memberof module:Tools/math/Matrix.wMatrix#
  */

function _qrDecompositionHh( q, r )
{
  let self = this;

  _.assert( _.Matrix.Is( self ) );
  _.assert( _.Matrix.Is( q ) );
  _.assert( _.Matrix.Is( r ) );

  let cols = self.length;
  let rows = self.atomsPerElement;

  let matrix = self.clone();

  q.copy( _.Matrix.makeIdentity( rows ) );
  let identity = _.Matrix.makeIdentity( rows );

  // Calculate Q

  for( let j = 0; j < cols; j++ )
  {
    let u = self.vectorAdapter.from( self.long.longMakeZeroed( rows ) );
    let e = identity.clone().colVectorGet( j );
    let col = matrix.clone().colVectorGet( j );

    for( let i = 0; i < j; i ++ )
    {
      col.eSet( i, 0 );
    }
    debugger;
    let c = 0;

    if( matrix.atomGet( [ j, j ] ) > 0 )
    {
      c = 1;
    }
    else
    {
      c = -1;
    }

    u = self.vectorAdapter.add( col, e.mul( c*col.mag() ) ).normalize();

    debugger;
    let m = _.Matrix.make( [ rows, cols ] ).fromVectors_( u, u );
    let mi = identity.clone();
    let h = mi.addAtomWise( m.mul( - 2 ) );
    q.mulLeft( h );

    matrix = _.Matrix.mul2Matrices( null, h, matrix );
  }

  r.copy( matrix );

  // Calculate R
  // r.mul2Matrices( h.clone().transpose(), matrix );
  let m = _.Matrix.mul2Matrices( null, q, r );
  let rb = _.Matrix.mul2Matrices( null, q.clone().transpose(), self )

  for( let i = 0; i < rows; i++ )
  {
    for( let j = 0; j < cols; j++ )
    {
      if( m.atomGet( [ i, j ] ) < self.atomGet( [ i, j ] ) - 1E-4 ) /* xxx */
      {
        throw _.err( 'QR decomposition failed' );
      }
      if( m.atomGet( [ i, j ] ) > self.atomGet( [ i, j ] ) + 1E-4 )
      {
        throw _.err( 'QR decomposition failed' );
      }
    }
  }

}

//


/**
  * Create a matrix out of a two vectors multiplication. Vectors stay unchanged.
  *
  * @param { v1 } - The first source vector.
  * @param { v2 } - The second source vector.
  *
  * @example
  * // returns M = _.Matrix.make( [ 3, 3 ] ).copy
  * ([
  *   0, 0, 0,
  *   3, 3, 3,
  *   6, 6, 6
  * ]);
  *
  * var v1 =  self.vectorAdapter.from( [ 0, 1, 2 ] );
  * var v2 =  self.vectorAdapter.from( [ 3, 3, 3 ] );
  * matrix.fromVectors_( v1, v2 );
  *
  * @function fromVectors_
  * @throws { Error } An Error if ( this ) is not a matrix.
  * @throws { Error } An Error if ( q ) is not a matrix.
  * @throws { Error } An Error if ( r ) is not a matrix.
  * @memberof module:Tools/math/Matrix.wMatrix#
  */

function fromVectors_( v1, v2 ) /* xxx : remove? */
{

  debugger;
  _.assert( _.vectorAdapterIs( v1 ) );
  _.assert( _.vectorAdapterIs( v2 ) );
//  _.assert( v1.length === v2.length );

  let matrix = _.Matrix.make( [ v1.length, v2.length ] );

  for( let i = 0; i < v1.length; i ++ )
  {
    for( let j = 0; j < v2.length; j ++ )
    {
      matrix.atomSet( [ i, j ], v1.eGet( i )*v2.eGet( j ) );
    }
  }

  return matrix;
}

//

/**
  * Split a M matrix into a U, a S and a V matrices, where M = U*S*Vt, S is diagonal
  * and the values of its diagonal are the eigenvalues of M, and U and V is orthogonal.
  * Matrix stays unchanged.
  *
  * @param { this } - The source matrix.
  * @param { u } - The destination U matrix.
  * @param { s } - The destination S matrix.
  * @param { v } - The destination V matrix.
  *
  * @example
  * // returns:
  * var u =  _.Matrix.make( [ 2, 2 ] ).copy
  * ([
  *   -Math.sqrt( 2 ) / 2, -Math.sqrt( 2 ) / 2,
  *   -Math.sqrt( 2 ) / 2, Math.sqrt( 2 ) / 2
  * ]);
  * var s =  _.Matrix.make( [ 2, 2 ] ).copy
  * ([
  *   6.000, 0.000,
  *   0.000, 2.000,
  * ]);
  * var v =  _.Matrix.make( [ 2, 2 ] ).copy
  * ([
  *   -Math.sqrt( 2 ) / 2, Math.sqrt( 2 ) / 2,
  *   -Math.sqrt( 2 ) / 2, -Math.sqrt( 2 ) / 2
  * ]);
  *
  * var matrix =  _.Matrix.make( [ 2, 2 ] ).copy
  * ([
  *   2, 4,
  *   4, 2
  * ]);
  * matrix.svd( u, s, v );
  *
  * @function svd
  * @throws { Error } An Error if ( this ) is not a matrix.
  * @throws { Error } An Error if ( arguments.length ) is not three.
  * @memberof module:Tools/math/Matrix.wMatrix#
  */

function svd( u, s, v )
{
  let self = this;
  _.assert( _.Matrix.Is( self ) );
  _.assert( arguments.length === 3 );

  let dims = _.Matrix.DimsOf( self );
  let cols = dims[ 1 ];
  let rows = dims[ 0 ];
  let min = rows;
  if( cols < rows )
  min = cols;

  if( arguments[ 0 ] == null )
  var u = _.Matrix.make([ rows, rows ]);

  if( arguments[ 1 ] == null )
  var s = _.Matrix.make([ rows, cols ]);

  if( arguments[ 2 ] == null )
  var v = _.Matrix.make([ cols, cols ]);

  if( self.isSymmetric() === true )
  {
    let q =  _.Matrix.make( [ cols, rows ] );
    let r =  _.Matrix.make( [ cols, rows ] );
    let identity = _.Matrix.makeIdentity( [ cols, rows ] );
    self._qrIteration( q, r );

    let eigenValues = r.diagonalVectorGet();
    for( let i = 0; i < cols; i++ )
    {
      if( eigenValues.eGet( i ) >= 0 )
      {
        u.colSet( i, q.colVectorGet( i ) );
        s.colSet( i, identity.colVectorGet( i ).mul( eigenValues.eGet( i ) ) );
        v.colSet( i, q.colVectorGet( i ) );
      }
      else if( eigenValues.eGet( i ) < 0 )
      {
        u.colSet( i, q.colVectorGet( i ).mul( - 1 ) );
        s.colSet( i, identity.colVectorGet( i ).mul( - eigenValues.eGet( i ) ) );
        v.colSet( i, q.colVectorGet( i ).mul( - 1 ) );
      }
    }
  }
  else
  {
    let aaT = _.Matrix.mul2Matrices( null, self, self.clone().transpose() );
    let qAAT = _.Matrix.make( [ rows, rows ] );
    let rAAT = _.Matrix.make( [ rows, rows ] );

    aaT._qrIteration( qAAT, rAAT );
    let sd = _.Matrix.mul2Matrices( null, rAAT, qAAT.clone().transpose() )

    u.copy( qAAT );

    let aTa = _.Matrix.mul2Matrices( null, self.clone().transpose(), self );
    let qATA = _.Matrix.make( [ cols, cols ] );
    let rATA = _.Matrix.make( [ cols, cols ] );

    aTa._qrIteration( qATA, rATA );

    let sd1 = _.Matrix.mul2Matrices( null, rATA, qATA.clone().transpose() )

    v.copy( qATA );

    let eigenV = rATA.diagonalVectorGet();

    for( let i = 0; i < min; i++ )
    {
      if( eigenV.eGet( i ) !== 0 )
      {
        let col = u.colVectorGet( i ).slice();
        let m1 = _.Matrix.make( [ col.length, 1 ] ).copy( col );
        let m2 = _.Matrix.mul2Matrices( null, self.clone().transpose(), m1 );

        v.colSet( i, m2.colVectorGet( 0 ).mul( 1 / eigenV.eGet( i ) ).normalize() );
      }
    }

    for( let i = 0; i < min; i++ )
    {
      s.atomSet( [ i, i ], Math.sqrt( Math.abs( rATA.atomGet( [ i, i ] ) ) ) );
    }

  }

}


// --
// relations
// --

let Extension =
{

  _qrIteration,
  _qrDecompositionGS,
  _qrDecompositionHh,

  fromVectors_,

  svd,

}

_.classExtend( Self, Extension );

})();
