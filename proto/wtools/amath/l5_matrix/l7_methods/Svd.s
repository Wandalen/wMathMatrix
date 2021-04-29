(function _Svd_s_() {

'use strict';

const _ = _global_.wTools;
const abs = Math.abs; /* zzz */
const min = Math.min;
const max = Math.max;
const pow = Math.pow;
const pi = Math.PI;
const sin = Math.sin;
const cos = Math.cos;
const sqrt = Math.sqrt;
const sqr = _.math.sqr;
const longSlice = Array.prototype.slice;

const Parent = null;
const Self = _.Matrix;

_.assert( _.object.isBasic( _.vectorAdapter ) );
_.assert( _.routineIs( Self ), 'wMatrix is not defined, please include wMatrix.s first' );

// --
//
// --

function gramSchmidtDecompose( o )
{
  let self = this;
  let l = self.ncol;

  o = _.routine.options_( gramSchmidtDecompose, arguments );

  if( l === 0 )
  return self;

  if( o.normalizing )
  {

    let col2 = self.vectorAdapter.make( self.nrow );
    let col3 = self.vectorAdapter.make( self.nrow );
    let col4 = self.vectorAdapter.make( self.nrow );

    self.colGet( 0 ).normalize();
    for( let i1 = 1 ; i1 < l ; i1++ )
    {
      let currCol = self.colGet( i1 );
      col2.assign( 0 );
      for( let i2 = 0 ; i2 < i1 ; i2++ )
      {
        let prevCol = self.colGet( i2 );
        col3.assign( prevCol ).mul( prevCol.dot( currCol ) );
        col2.sub( col3 );
      }
      currCol.add( col2 );
      currCol.normalize();
    }

  }
  else
  {

    let col2 = self.vectorAdapter.make( self.nrow );
    let col3 = self.vectorAdapter.make( self.nrow );
    for( let i1 = 1 ; i1 < l ; i1++ )
    {
      let currCol = self.colGet( i1 );
      col2.assign( 0 );
      for( let i2 = 0 ; i2 < i1 ; i2++ )
      {
        let prevCol = self.colGet( i2 );
        col3.assign( prevCol ).mul( prevCol.dot( currCol ) / prevCol.magSqr() );
        col2.sub( col3 );
      }
      currCol.add( col2 );
    }

  }

/* non-normalized :
an = a
bn = b - an * ( b*an ) / ( an*an )
cn = c - an * ( c*an ) / ( an*an ) - bn * ( c*bn ) / ( bn*bn )
*/

/* normalized :
an = a
an =/ a.mag()
bn = ( b - an * ( b*an ) )
bn =/ bn.mag()
cn = c - an * ( c*an ) - bn * ( c*bn )
cn =/ cn.mag()
*/

/* QR
A * R.inv() = Q
A = Q*R
*/

  return self;
}

gramSchmidtDecompose.defaults =
{
  normalizing : 0,
}

//

function qrDecompose( o )
{
  let self = this;
  let l = self.ncol;

  o = _.routine.options_( qrDecompose, arguments );

  o.q = self;
  if( o.r === null )
  o.r = o.q.MakeIdentity( o.q.dims );
  else
  o.r.identity();

  _.assert( o.r.hasShape( o.q ) );

  if( l === 0 )
  return self;

  let col2 = self.vectorAdapter.make( self.nrow );
  let col3 = self.vectorAdapter.make( self.nrow );
  let col4 = self.vectorAdapter.make( self.nrow );

  let firstCol = self.colGet( 0 );
  let mag = firstCol.mag();
  firstCol.mul( 1 / mag );
  o.r.scalarSet( [ 0, 0 ], mag );

  for( let i1 = 1 ; i1 < l ; i1++ )
  {
    let currCol = self.colGet( i1 );
    col2.assign( 0 );

    for( let i2 = 0 ; i2 < i1 ; i2++ )
    {
      let prevCol = self.colGet( i2 );
      let dot = prevCol.dot( currCol );
      o.r.scalarSet( [ i2, i1 ], dot );
      col3.assign( prevCol ).mul( dot );
      col2.sub( col3 );
    }

    currCol.add( col2 );
    let mag = currCol.mag();
    currCol.mul( 1 / mag );
    o.r.scalarSet( [ i1, i1 ], mag );

  }

/* QR
A - initial space
Q - ortho-normalized space
R - ortho-normalized space to initial sapce
R.inv() - initial sapce to ortho-normalized space
A * R.inv() = Q
A = Q*R
R.inv() = R.transposed()
*/

  return o;
}

qrDecompose.defaults =
{
  r : null,
}

//

/**
 * Method _qrIteration() splits a M matrix into a Q and a R matrices, where M = Q*R, R is upper triangular
 * and the values of its diagonal are the eigenvalues of M, and Q is orthogonal and its columns are
 * the eigenvectors of M. Returns the eigenvalues of M. Matrix stays unchanged.
 *
 * @example
 * var matrix =  _.Matrix.MakeSquare
 * ([
 *   1, 2,
 *   2, 1,
 * ]);
 * var got = matrix._qrIteration();
 * console.log( got.toStr() );
 * // returns : 3.000 -1.000
 *
 * @param { Matrix } q - The destination Q matrix.
 * @param { Matrix } r - The destination R matrix.
 * @returns { Long|VectorAdapter } - Returns a vector with the values of the diagonal of R.
 * @method _qrIteration
 * @throws { Error } If arguments.length is 0.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function _qrIteration( q, r )
{
  let self = this;
  _.assert( _.Matrix.Is( self ) );
  //_.assert( !isNaN( self.clone().invert().scalarGet([ 0, 0 ]) ), 'Matrix must be invertible' )

  let cols = self.length;
  let rows = self.scalarsPerElement;

  if( arguments.length === 0 )
  {
    var q = _.Matrix.MakeIdentity( [ rows, cols ] );
    var r = _.Matrix.Make([ rows, cols ]);
  }

  let a = self.clone();
  let loop = 0;
  q.copy( _.Matrix.MakeIdentity( rows ) );


  while( a.isUpperTriangle() === false && loop < 1000 )
  {
    var qInt = _.Matrix.MakeIdentity([ rows, cols ]);
    var rInt = _.Matrix.MakeIdentity([ rows, cols ]);
    a._qrDecompositionHh( qInt, rInt );
    // Calculate transformation matrix
    q.mulLeft( qInt );

    a.mul([ rInt, qInt ]);

    loop = loop + 1;
  }

  q.copy( q );
  r.copy( a );

  if( loop === 1000 )
  {
    r.copy( rInt );
  }

  let eigenValues = self.vectorAdapter.toLong( a.diagonalGet() );
  eigenValues.sort( ( a, b ) => b - a );

  logger.log( 'EI', eigenValues)
  for( let i = 0; i < eigenValues.length; i++ )
  {
    let newValue = eigenValues[ i ];
    for( let j = 0; j < eigenValues.length; j++ )
    {
      let value = r.scalarGet( [ j, j ] );

      if( newValue === value )
      {
        let oldColQ = q.colGet( i ).clone();
        let oldValue = r.scalarGet( [ i, i ] );

        q.colSet( i, q.colGet( j ) );
        q.colSet( j, oldColQ );

        r.scalarSet( [ i, i ], r.scalarGet( [ j, j ] ) );
        r.scalarSet( [ j, j ], oldValue );
      }
    }
  }

  return r.diagonalGet();
}

//

/**
 * Method _qrDecompositionGS() performs the QR Gram-Schmidt decomposition of a M matrix into a Q and a R matrices, where M = Q*R, R is
 * upper triangular, and Q is orthogonal. Matrix stays unchanged.
 *
 * @example
 * test.description = 'Matrix with one repeated eigenvalue 3x3';
 *
 * var matrix =  _.Matrix.MakeSquare
 * ([
 *   12, -51, 4,
 *   6,  167, -68,
 *   -4, -24, -41,
 * ]);
 * var q = _.Matrix.Make( [ 3, 3 ] );
 * var r = _.Matrix.Make( [ 3, 3 ] );
 * matrix.qrDecompositionGS( q, r );
 *
 * console.log( q.toStr() );
 * // log :
 * // 0.857  -0.467 -0.216
 * // 0.428  0.880  -0.203
 * // -0.285 -0.081 -0.954
 *
 * console.log( r.toStr() );
 * // log :
 * // 14.000 34.714  -14.000
 * // 0.000  172.803 -58.390
 * // 0.000  0.000   52.111
 *
 * @param { Matrix } q - The destination Q matrix.
 * @param { Matrix } r - The destination R matrix.
 * @method _qrDecompositionGS
 * @throws { Error } If {-q-} s not a Matrix.
 * @throws { Error } If {-r-} is not a Matrix.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function _qrDecompositionGS( q, r )
{
  let self = this;

  _.assert( _.Matrix.Is( self ) );
  _.assert( _.Matrix.Is( q ) );
  _.assert( _.Matrix.Is( r ) );

  let cols = self.length;
  let rows = self.scalarsPerElement;

  _.assert( !isNaN( self.clone().invert().scalarGet([ 0, 0 ]) ), 'Matrix must be invertible' )

  let matrix = self.clone();
  q.copy( _.Matrix.MakeIdentity( [ rows, cols ] ) );

  let qInt = _.Matrix.MakeIdentity([ rows, cols ]);

  for( let i = 0; i < cols; i++ )
  {
    let col = matrix.colGet( i );
    let sum = self.vectorAdapter.from( self.longType.longMakeZeroed( rows ) );
    for( let j = 0; j < i ; j ++ )
    {
      let dot = self.vectorAdapter.dot( col, self.vectorAdapter.from( qInt.colGet( j ) ) );
      debugger;

      self.vectorAdapter.add( sum, self.vectorAdapter.mul( self.vectorAdapter.from( qInt.colGet( j ) ).clone(), - dot ) );
    }
    let e = self.vectorAdapter.normalize( self.vectorAdapter.add( col.clone(), sum ) );
    qInt.colSet( i, e );
  }

  // Calculate R
  r.mul( qInt.clone().transpose(), matrix );

  // Calculate transformation matrix
  q.mulLeft( qInt );
  let a = _.Matrix.Make([ cols, rows ]);
}

//

/**
 * Perform the QR Householder decomposition of a M matrix into a Q and a R matrices, where M = Q*R, R is
 * upper triangular, and Q is orthogonal. Matrix stays unchanged.
 *
 * @example
 * var matrix =  _.Matrix.Make( [ 3, 3 ] ).copy
 * ([
 *   12, -51, 4,
 *   6,  167, -68,
 *   -4, -24, -41,
 * ]);
 * matrix._qrDecompositionHh( q, r );
 *
 * console.log( q.toStr() );
 * // log :
 * // -0.857 0.467  -0.216
 * // -0.428 -0.880 -0.203
 * // 0.285  0.081  -0.954
 * // ]);
 * console.log( r.toStr() );
 * // log :
 * //   -14.000 -34.714  14.000
 * //   0.000   -172.803 58.390
 * //   0.000   0.000    52.111
 *
 * @param { Matrix } q - The destination Q matrix.
 * @param { Matrix } r - The destination R matrix.
 * @function _qrDecompositionHh
 * @throws { Error } If {-q-} s not a Matrix.
 * @throws { Error } If {-r-} is not a Matrix.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
 */

function _qrDecompositionHh( q, r )
{
  let self = this;
  let cols = self.length;
  let rows = self.scalarsPerElement;

  _.assert( _.Matrix.Is( self ) );
  _.assert( _.Matrix.Is( q ) );
  _.assert( _.Matrix.Is( r ) );

  let matrix = self.clone();

  q.copy( _.Matrix.MakeIdentity( rows ) );
  let identity = _.Matrix.MakeIdentity( rows );

  /* Calculate Q */

  let h; // Dmytro : see below

  for( let j = 0; j < cols; j++ )
  {
    let u = self.vectorAdapter.from( self.longType.longMakeZeroed( rows ) );
    let e = identity.clone().colGet( j );
    let col = matrix.clone().colGet( j );

    for( let i = 0; i < j; i ++ )
    {
      col.eSet( i, 0 );
    }
    let c = 0;

    if( matrix.scalarGet( [ j, j ] ) > 0 )
    {
      c = 1;
    }
    else
    {
      c = -1;
    }

    u = self.vectorAdapter.add( col, e.mul( c*col.mag() ) ).normalize();

    debugger;
    // let m = _.Matrix.Make( [ rows, cols ] ).OuterProductOfVectors( u, u );
    let m = _.Matrix.OuterProductOfVectors( u, u );
    let mi = identity.clone();
    debugger;
    // let h = mi.addScalarWise( m.mul( - 2 ) );
    h = mi.addScalarWise( m.mul( - 2 ) ); // Dmytro : it's local variable, temporary
    debugger;
    q.mulLeft( h );

    matrix = _.Matrix.Mul( null, [ h, matrix ] );
  }

  r.copy( matrix );

  // Calculate R
  // r._mul2Matrices( h.clone().transpose(), matrix );
  r.mul([ h.clone().transpose(), matrix ]);
  let m = _.Matrix.Mul( null, [ q, r ] );
  let rb = _.Matrix.Mul( null, [ q.clone().transpose(), self ] )

  for( let i = 0; i < rows; i++ )
  {
    for( let j = 0; j < cols; j++ )
    {
      debugger;
      if( m.scalarGet( [ i, j ] ) < self.scalarGet( [ i, j ] ) - m.accuracySqrt )
      {
        throw _.err( 'QR decomposition failed' );
      }
      if( m.scalarGet( [ i, j ] ) > self.scalarGet( [ i, j ] ) + m.accuracySqrt )
      {
        throw _.err( 'QR decomposition failed' );
      }
    }
  }

}

//

/**
 * Method svd() splits a M matrix into a U, a S and a V matrices, where M = U*S*Vt, S is diagonal
 * and the values of its diagonal are the eigenvalues of M, and U and V is orthogonal.
 * Matrix stays unchanged.
 *
 * @example
 *  var matrix =  _.Matrix.MakeSquare
 *  ([
 *    2, 4,
 *    4, 2,
 *  ]);
 *
 *  var u = _.Matrix.Make( [ 2, 2 ] );
 *  var s = _.Matrix.Make( [ 2, 2 ] );
 *  var v = _.Matrix.Make( [ 2, 2 ] );
 *
 *  matrix.svd( u, s, v );
 *
 * console.log( u.toStr() );
 * // log :
 * // -0.707, -0.707
 * // -0.707  0.707
 *
 * console.log( s.toStr() );
 * // log :
 * // 6.000 0.000
 * // 0.000 2.000
 *
 * console.log( v.toStr() );
 * // log :
 * // -0.707, 0.707
 * // -0.707  -0.707
 *
 * @param { Matrix } u - The destination U matrix.
 * @param { Matrix } s - The destination S matrix.
 * @param { Matrix } v - The destination V matrix.
 * @function svd
 * @throws { Error } If arguments.length is not 3.
 * @class Matrix
 * @namespace wTools
 * @module Tools/math/Matrix
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
  var u = _.Matrix.Make([ rows, rows ]);

  if( arguments[ 1 ] == null )
  var s = _.Matrix.Make([ rows, cols ]);

  if( arguments[ 2 ] == null )
  var v = _.Matrix.Make([ cols, cols ]);

  if( self.isSymmetric() === true )
  {
    let q =  _.Matrix.Make( [ cols, rows ] );
    let r =  _.Matrix.Make( [ cols, rows ] );
    let identity = _.Matrix.MakeIdentity( [ cols, rows ] );
    self._qrIteration( q, r );

    let eigenValues = r.diagonalGet();
    for( let i = 0; i < cols; i++ )
    {
      if( eigenValues.eGet( i ) >= 0 )
      {
        u.colSet( i, q.colGet( i ) );
        s.colSet( i, identity.colGet( i ).mul( eigenValues.eGet( i ) ) );
        v.colSet( i, q.colGet( i ) );
      }
      else if( eigenValues.eGet( i ) < 0 )
      {
        u.colSet( i, q.colGet( i ).mul( - 1 ) );
        s.colSet( i, identity.colGet( i ).mul( - eigenValues.eGet( i ) ) );
        v.colSet( i, q.colGet( i ).mul( - 1 ) );
      }
    }
  }
  else
  {
    let aaT = _.Matrix.Mul( null, [ self, self.clone().transpose() ] );
    let qAAT = _.Matrix.Make( [ rows, rows ] );
    let rAAT = _.Matrix.Make( [ rows, rows ] );

    aaT._qrIteration( qAAT, rAAT );
    let sd = _.Matrix.Mul( null, [ rAAT, qAAT.clone().transpose() ] )

    u.copy( qAAT );

    let aTa = _.Matrix.Mul( null, [ self.clone().transpose(), self ] );
    let qATA = _.Matrix.Make( [ cols, cols ] );
    let rATA = _.Matrix.Make( [ cols, cols ] );

    aTa._qrIteration( qATA, rATA );

    let sd1 = _.Matrix.Mul( null, [ rATA, qATA.clone().transpose() ] )

    v.copy( qATA );

    let eigenV = rATA.diagonalGet();

    for( let i = 0; i < min; i++ )
    {
      if( eigenV.eGet( i ) !== 0 )
      {
        let col = u.colGet( i ).slice();
        let m1 = _.Matrix.Make( [ col.length, 1 ] ).copy( col );
        let m2 = _.Matrix.Mul( null, [ self.clone().transpose(), m1 ] );

        v.colSet( i, m2.colGet( 0 ).mul( 1 / eigenV.eGet( i ) ).normalize() );
      }
    }

    for( let i = 0; i < min; i++ )
    {
      s.scalarSet( [ i, i ], Math.sqrt( Math.abs( rATA.scalarGet( [ i, i ] ) ) ) );
    }

  }

}

// --
// relations
// --

let Extension =
{

  gramSchmidtDecompose,
  qrDecompose,

  _qrIteration,
  _qrDecompositionGS,
  _qrDecompositionHh,

  svd,

}

_.classExtend( Self, Extension );

})();
