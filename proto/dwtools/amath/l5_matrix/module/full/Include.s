(function _Include_s_() {

'use strict';

/**
 * Collection of functions for matrix math. MathMatrix introduces class Matrix, which is a multidimensional structure which, in the most trivial case, is a 2D matrix. A matrix of specific form could also be classified as a vector. MathMatrix heavily relly on MathVector, which introduces VectorAdapter. A Vector adapter is an implementation of the abstract interface, a kind of link that defines how to interpret data as the vector. An adapter is a special object to make algorithms more abstract and to use the same code for very different formats of vector specifying. Use module MathMatrix for arithmetic operations with matrices, to triangulate, permutate or transform matrix, to get a particular or the general solution of a system of linear equations, to get LU, QR decomposition, for SVD or PCA. Also, Matrix is a convenient and efficient data container. You may use it to continuously store multidimensional data.
  @module Tools/math/Matrix
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
