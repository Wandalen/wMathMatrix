# Matrix solver

Solving systems of linear equations.

### Solving of a system of linear equations

Solving of a system with two linear equations.

```
1*x1 - 2*x2 = -7;
3*x1 + 4*x2 = 39;
```

In compact form:

```
A*x = y
```

Let's use the static routine `Solve` to find unknown values.

```js

var A = _.Matrix.MakeSquare
([
  1, -2,
  3,  4
]);
var y = [ -7, 39 ];
var x = _.Matrix.Solve( null, A, y );

console.log( `x :\n${ x }` );
/* log : x : [ 5, 6 ] */

```

Routine `Solve` found the solution of a system of linear equations specified by matrix `A` and vector `y`. Value of `x1` is `5`, a value of `x2` is `6`.

[Back to content](../README.md#Tutorials)
