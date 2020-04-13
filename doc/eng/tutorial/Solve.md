# Matrix solving

The solving of mathematical problems in the matrix way are considered.

### Solving of a system of linear equations

Solving of a system with two linear equations

```
3*x1 - 2*x2 = 1;
2*x1 + 3*x2 = 2;
```

Use the static routine `Solve` to find unknown values.

```js
var A = _.Matrix.MakeSquare
([
  3, -2,
  2,  3
]);
var x = _.Matrix.MakeCol
([
  1,
  2
]);

var y = _.Matrix.Solve( null, A, x );

console.log( `the unknown values is :\n${ y.toStr() }` );
/* log : the unknown values is :
0.538,
0.308,
*/
```

The routine of `Solve` made calculations of unknowns. The values of `x1` -` 0.538`, and `x2` -` 0.308`.

[Back to content](../README.md#Tutorials)
