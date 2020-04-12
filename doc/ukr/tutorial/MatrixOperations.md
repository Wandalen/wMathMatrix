# Матричні операції

Виконується огляд способів оперування матрицями.

### Виконання простої операції

Для виконання операції з матрицею потрібно викликати відповідний метод у інстанса.

```js
var matrix = _.Matrix.Make( [ 3, 3 ] ).copy
([
  1, 2, 3,
  4, 5, 6,
  7, 8, -9
]);
var got = matrix.determinant();
console.log( `determinant :\n${ got }` );
/* log : determinant :
54
*/
```

### Множення матриці на скаляр

Матриця може бути помножена на скаляр з допомогою статичної рутини `Mul`, кожне значення матриці збільшиться в відповідну кількість разів. Рутина поміщає результат виконання операції в контейнер `dst`, якщо `dst` має значення `null`, тоді результат поміщається в новий контейнер.

```js
var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4 ] );

var got = _.Matrix.Mul( null, [ matrix, 3 ] );
console.log( `got :\n${ got.toStr() }` );
/* log : matrix :
+3, +6,
+9, +12,
*/
```

### Множення двох матриць

Перемножити матриці можна з допомогою статичної рутини `Mul`, результатом множення буде матриця.

```js
var matrixA = _.Matrix.MakeSquare( [ 1, 2, 3, 4 ] );
var matrixB = _.Matrix.MakeSquare( [ 4, 3, 2, 1 ] );

var matrix = _.Matrix.Mul( null, [ matrixA, matrixB ] );
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+8,  +5,
+20, +13,
*/
```

Екземпляр класу `Matrix` також має метод `mul`, результат множення матриць присвоюється цьому екземпляру.

```js
var matrixA = _.Matrix.MakeSquare( [ 1, 2, 3, 4 ] );
var matrixB = _.Matrix.MakeSquare( [ 4, 3, 2, 1 ] );

var matrix = _.Matrix.Make( [ 2, 2 ] );
matrix.mul( [ matrixA, matrixB ] );
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+8,  +5,
+20, +13,
*/
```

### Множення матриці на вектор

Матриця може бути помножена на вектор з допомогою статичної рутини `Mul`, результатом множення буде вектор.

```js
var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4 ] );
var vector = [ 1, 1 ];

var got = _.Matrix.Mul( null, [ matrix, vector ] );
console.log( `got :\n${ got }` );
/* log : got :
[ 3, 7 ]
*/
```

Екземпляр класу може бути помножений на вектор з використанням методу `matrixApplyTo`, результат множення записується в вектор.

```js
var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4 ] );
var vector = [ 1, 1 ];

var got = matrix.matrixApplyTo( vector );
console.log( `got :\n${ got }` );
/* log : got :
[ 3, 7 ]
*/
console.log( `got === vector :\n${ got === vector }` );
/* log : got === vector :
true
*/
```

[Повернутись до змісту](../README.md#Туторіали)
