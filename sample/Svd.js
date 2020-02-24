
if( typeof module !== 'undefined' )
require( 'wmathspace' );
require('wFiles');


var _ = wTools;

var matrix =  _.Space.make( [ 4, 5 ] ).copy
([
  1, 0, 0, 0, 2,
  0, 0, 3, 0, 0,
  0, 0, 0, 0, 0,
  0, 2, 0, 0, 0
]);

var u = _.Space.make( [ 4, 4 ] );
var s = _.Space.make( [ 4, 5 ] );
var v = _.Space.make( [ 5, 5 ] );

matrix.svd( u, s, v );
//logger.log( 'Final S', s );
//logger.log( 'Final V', v );
logger.log( 'Final U' );
for( var i = 0; i < 4; i++ )
{
  let row = u.rowVectorGet( i );
  logger.log( row.eGet( 0 ), row.eGet( 1 ), row.eGet( 2 ), row.eGet( 3 ) )
}

logger.log( 'Final S' );
for( var i = 0; i < 4; i ++ )
{
  let row = s.rowVectorGet( i );
  logger.log( row.eGet( 0 ), row.eGet( 1 ), row.eGet( 2 ), row.eGet( 3 ), row.eGet( 4 ))
}

logger.log( 'Final V' );
for( var i = 0; i < 5; i ++ )
{
  let row = v.rowVectorGet( i );
  logger.log( row.eGet( 0 ), row.eGet( 1 ), row.eGet( 2 ), row.eGet( 3 ), row.eGet( 4 ))
}


let iss = _.Space.mul2Matrices( null, s, v.clone().transpose());
let res = _.Space.mul2Matrices( null, u, iss );
logger.log( 'Final Result' );
for( var i = 0; i < 4; i ++ )
{
  let row = res.rowVectorGet( i );
  logger.log( row.eGet( 0 ), row.eGet( 1 ), row.eGet( 2 ), row.eGet( 3 ), row.eGet( 4 ))
}
