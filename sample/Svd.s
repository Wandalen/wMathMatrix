if( typeof module !== 'undefined' )
require( 'wmathmatrix' );
require('wFiles');

let _ = wTools;

var matrix =  _.Matrix.Make( [ 4, 5 ] ).copy
([
  1, 0, 0, 0, 2,
  0, 0, 3, 0, 0,
  0, 0, 0, 0, 0,
  0, 2, 0, 0, 0
]);

var u = _.Matrix.Make( [ 4, 4 ] );
var s = _.Matrix.Make( [ 4, 5 ] );
var v = _.Matrix.Make( [ 5, 5 ] );

matrix.svd( u, s, v );
logger.log( 'Final U' );
for( var i = 0; i < 4; i++ )
{
  let row = u.rowGet( i );
  logger.log( row.eGet( 0 ), row.eGet( 1 ), row.eGet( 2 ), row.eGet( 3 ) )
}

logger.log( 'Final S' );
for( var i = 0; i < 4; i ++ )
{
  let row = s.rowGet( i );
  logger.log( row.eGet( 0 ), row.eGet( 1 ), row.eGet( 2 ), row.eGet( 3 ), row.eGet( 4 ))
}

logger.log( 'Final V' );
for( var i = 0; i < 5; i ++ )
{
  let row = v.rowGet( i );
  logger.log( row.eGet( 0 ), row.eGet( 1 ), row.eGet( 2 ), row.eGet( 3 ), row.eGet( 4 ))
}


let iss = _.Matrix._Mul2( null, s, v.clone().transpose());
let res = _.Matrix._Mul2( null, u, iss );
logger.log( 'Final Result' );
for( var i = 0; i < 4; i ++ )
{
  let row = res.rowGet( i );
  logger.log( row.eGet( 0 ), row.eGet( 1 ), row.eGet( 2 ), row.eGet( 3 ), row.eGet( 4 ))
}
