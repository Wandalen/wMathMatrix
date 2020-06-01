(function _Include_s_() {

'use strict';

/**
 * Basic implementation of collection of functions for matrix math. MathMatrix introduces the class Matrix. Matrix is a multidimensional structure. A matrix of specific form could also be classified as a vector. MathMatrix heavily relly on MathVector, which introduces VectorAdapter. VectorAdapter is a reference, and it does not contain data but only refers to actual ( aka Long ) container of lined data.  Use MathMatrix for arithmetic operations with matrices, to triangulate, permutate or transform matrix, to get a specific or the general solution of a system of linear equations, to get LU, QR decomposition, for SVD or PCA. Matrix is a convenient and efficient data container, and you may use it to store huge an array of arrays or for matrix computation.
  @module Tools/math/MatrixBasic
*/

if( typeof module !== 'undefined' )
{

  require( '../../include/Mid.s' );

}

if( typeof module !== 'undefined' )
{
  module[ 'exports' ] = _global_.wTools;
}

})();
