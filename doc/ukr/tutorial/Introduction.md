# Введення

В даній статті виконується огляд концепції матриці та її форматів задання.

### Задання матриці

Для створення інстансу використовується конструктор класу `_.Matrix` або рутини неймспейсу `_.Matrix`.

Дані для матриці можуть задаватись будь-яким форматом [вектора](https://github.com/Wandalen/wMathVector).

### Створення матриці визначеного розміру

Для створення матриці визначеного розміру використовуєтья рутина `make`.

```js
var matrix = _.Matrix.make( [ 3, 3 ] );
console.log( matrix.buffer );
/* log Float32Array [ 0, 0, 0, 0, 0, 0, 0, 0, 0 ] */
matrix.copy( [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );
console.log( matrix.buffer );
/* log Float32Array [ 1, 4, 7, 2, 5, 8, 3, 6, 9 ] */
```

### Виконання простої операції

Для виконання операції з матрицею потрібно викликати відповідний метод у інстанса.

```js
var matrix = _.Matrix.make( [ 3, 3 ] ).copy
([
  1, 2, 3,
  4, 5, 6,
  7, 8, -9
]);
var got = matrix.determinant();
console.log( got );
/* log 54 */
```

### Використання опції strides

Опція `strides` дає зрозуміти як інтерпретувати матрицю.

```js
var matrix = _.Matrix.make( [ 3, 3 ] ).copy
([
  1, 2, 3,
  4, 5, 6,
  7, 8, -9
]);
matrix.strides = [ 1, 3 ];
console.log( matrix.rowVectorGet( 0 ).toStr() );
/* log : "1.000, 2.000, 3.000" */
console.log( matrix.rowVectorGet( 1 ).toStr() );
/* log : "4.000, 5.000, 6.000" */
console.log( matrix.rowVectorGet( 2 ).toStr() );
/* log : "7.000, 8.000, -9.000" */
```

### Транспонування матриці

Для транспонування матриці достатньо змінити другий елемент опції `strides` на значення `1`. Це дозволить інтерпретувати стовпчики матриці як рядки.

```js
var matrix = _.Matrix.make( [ 3, 3 ] ).copy
([
  1, 2, 3,
  4, 5, 6,
  7, 8, -9
]);
matrix.strides = [ 3, 1 ];
console.log( matrix.rowVectorGet( 0 ).toStr() );
/* log "1.000, 4.000, 7.000" */
console.log( matrix.rowVectorGet( 1 ).toStr() );
/* log "2.000, 5.000, 8.000" */
console.log( matrix.rowVectorGet( 1 ).toStr() );
/* log "3.000, 6.000, -9.000" */
```

### Рішення системи лінійних рівнянь

Рішення системи з двох лінійних рівнянь

```
3*x1 - 2*x2 = 1;
2*x1 + 3*x2 = 2;
```

Знайти невідомі значення можна перемноживши інвертовану матрицю коефіцієнтів на матрицю значень.

```js
var matrixA = _.Matrix.make( [ 2, 2 ] ).copy( [ 3, -2, 2, 3 ] );
var matrixB = _.Matrix.make( [ 2, 1 ] ).copy( [ 1, 2 ] );

var matrixAInv =  matrixA.invertingClone();
var matrixX = _.Matrix.mul( null, [ matrixAInv, matrixB ] );

var x1 = matrixX.eGet( 0 ).eGet( 0 );
var x2 = matrixX.eGet( 0 ).eGet( 1 );
console.log( x1, x2 )
/* log 0.5384615659713745 0.307692289352417 */
```

[Повернутись до змісту](../README.md#Туторіали)
