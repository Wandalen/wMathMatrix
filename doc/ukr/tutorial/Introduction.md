# Введення

В даній статті виконується огляд концепції матриці та її форматів задання.

### Створення матриці

Для створення матриці визначеного розміру використовуєтья рутина `make`.

```js
var matrix = _.Matrix.Make( [ 2, 2 ] );
console.log( 'matrix : ', matrix.toStr() );
/* log : matrix : +0, +0,
                  +0, +0,
*/
```

Для створення матриці з урахуванням опцій використовуєтья конструктор `_.Matrix`.

```js
var matrix = _.Matrix
({
  dims : [ 2, 2 ],
  buffer : [ 1, 2, 3, 4 ],
  strides : [ 1, 2 ],
});
console.log( 'matrix : ', matrix.toStr() );
/* log : matrix : +1, +3,
                  +2, +4,
*/
```

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
console.log( 'determinant : ', got );
/* log : determinant : 54 */
```

### Використання опції strides

Опція `strides` дає зрозуміти як інтерпретувати матрицю.

```js
var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 2, 2 ],
  strides : [ 4, 2 ]
});
console.log( 'matrix : ', matrix.toStr() );
/* log : matrix : +1, +3,
                  +5, +7,
*/
```

### Транспонування матриці при створенні

Дані можуть бути автоматично транспоновані при створенні матриці

```js
var matrix = _.Matrix
({
  dims : [ 2, 2 ],
  buffer : [ 1, 1, 2, 2 ],
});
console.log( 'matrix : ', matrix.toStr() );
/* log : matrix : +1, +1,
                  +2, +2,
*/

var matrix = _.Matrix
({
  dims : [ 2, 2 ],
  buffer : [ 1, 1, 2, 2 ],
  inputTransposing : 1,
});
console.log( 'transposed matrix : ', matrix.toStr() );
/* log : transposed matrix : +1, +2,
                             +1, +2,
*/
```

### Транспонування матриці методом `transpose`

Створену матрицю можна транспонувати методом `transpose`, дані зберігаються в оригінальному контейнері.

```js
var matrix = _.Matrix.MakeSquare( [ 1, 1, 2, 2 ] );
console.log( 'matrix : ', matrix.toStr() );
/* log : matrix : +1, +1,
                  +2, +2,
*/

matrix.transpose();
console.log( 'transposed matrix : ', matrix.toStr() );
/* log : transposed matrix : +1, +2,
                             +1, +2,
*/
```

### Транспонування матриці зміною опції `strides`

Для транспонування матриці можна змінити порядок значень в опції `strides`.

```js
var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 2, 2 ],
  strides : [ 4, 2 ]
});

console.log( 'matrix : ', matrix.toStr() );
/* log : matrix : +1, +3,
                  +5, +7,
*/

var matrixTransposed = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 2, 2 ],
  strides : [ 2, 4 ]
});
console.log( 'transposed matrix : ', matrixTransposed.toStr() );
/* log : transposed matrix : +1, +5,
                             +3, +7,
*/
```

### Множення двох матриць

Перемножити матриці можна з допомогою статичної рутини `Mul`. Рутина поміщає результат виконання операції в контейнер `dst`, якщо `dst` має значення `null`, тоді результат поміщається в новий контейнер.

```js
var matrixA = _.Matrix.MakeSquare( [ 1, 2, 3, 4 ] );
var matrixB = _.Matrix.MakeSquare( [ 4, 3, 2, 1 ] );

var matrix = _.Matrix.Mul( null, [ matrixA, matrixB ] );
console.log( 'matrix : ', matrix.toStr() );
/* log : matrix :  +8,  +5,
                  +20, +13,
*/
```

Екземпляр класу `Matrix` також має метод `mul`, результат множення матриць присвоюється цьому екземпляру.

```js
var matrixA = _.Matrix.MakeSquare( [ 1, 2, 3, 4 ] );
var matrixB = _.Matrix.MakeSquare( [ 4, 3, 2, 1 ] );

var matrix = _.Matrix.Make( [ 2, 2 ] );
matrix.mul( [ matrixA, matrixB ] );
console.log( 'matrix : ', matrix.toStr() );
/* log : matrix :  +8,  +5,
                  +20, +13,
*/
```

### Множення матриці на вектор

Матриця може бути помножена на вектор з допомогою статичної рутини `Mul`, результатом множення буде вектор.

```js
var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4 ] );
var vector = [ 1, 1 ];

var got = _.Matrix.Mul( null, [ matrix, vector ] );
console.log( 'got : ', got );
/* log : oot : [ 3, 7 ] */
```

Екземпляр класу може бути помножений на вектор з використанням методу `matrixApplyTo`, результат множення записується в вектор.

```js
var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4 ] );
var vector = [ 1, 1 ];

var got = matrix.matrixApplyTo( vector );
console.log( 'got : ', got );
/* log : oot : [ 3, 7 ] */
console.log( 'got === vector : ', got === vector );
/* log : got === vector : true */
```

### Рішення системи лінійних рівнянь

Рішення системи з двох лінійних рівнянь

```
3*x1 - 2*x2 = 1;
2*x1 + 3*x2 = 2;
```

Знайти невідомі значення можна використавши рутину `solve`.

```js
var matrixA = _.Matrix.MakeSquare( [ 3, -2, 2, 3 ] );
var matrixB = _.Matrix.MakeCol( [ 1, 2 ] );

var matrixX = _.Matrix.solve( null, matrixA, matrixB );

var x1 = matrixX.scalarGet( [ 0, 0 ] );
var x2 = matrixX.scalarGet( [ 1, 0 ] );
console.log( 'x1 : ', x1, ', x2 : ', x2 );
/* log : x1 : 0.5384615659713745, x2 : 0.307692289352417 */
```

[Повернутись до змісту](../README.md#Туторіали)
