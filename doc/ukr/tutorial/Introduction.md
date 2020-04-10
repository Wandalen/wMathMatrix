# Введення

В даній статті виконується огляд концепції матриці та її форматів задання.

### Створення матриці

Для створення матриці визначеного розміру використовуєтья рутина `make`.

```js
var matrix = _.Matrix.Make( [ 2, 2 ] );
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+0, +0,
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
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +3,
+2, +4,
*/
```

<!--
### Виконання простої операції
-->

### Використання опції `strides`

Опція `strides` дає зрозуміти як інтерпретувати матрицю.

```js
var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 2, 2 ],
  strides : [ 4, 2 ]
});
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +3,
+5, +7,
*/
```

### Транспонування матриці при створенні

Дані можуть бути автоматично транспоновані при створенні матриці

```js
var matrix = _.Matrix
({
  dims : [ 2, 2 ],
  buffer : [ 1, 2, 3, 4 ],
});
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4,
*/

var matrix = _.Matrix
({
  dims : [ 2, 2 ],
  buffer : [ 1, 2, 3, 4 ],
  inputTransposing : 1,
});
console.log( `transposed matrix :\n${ matrix.toStr() }` );
/* log : transposed matrix :
+1, +3,
+2, +4,
*/
```

### Транспонування матриці методом `transpose`

Створену матрицю можна транспонувати методом `transpose`, дані зберігаються в оригінальному контейнері.

```js
var matrix = _.Matrix.MakeSquare( [ 1, 2, 3, 4 ] );
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4,
*/

matrix.transpose();
console.log( `transposed matrix :\n${ matrix.toStr() }` );
/* log : transposed matrix :
+1, +3,
+2, +4,
*/
```

### Транспонування матриці зміною опції `strides`

Для транспонування матриці можна змінити порядок значень в опції `strides`.

```js
var buffer1 = new I32x( [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );

var matrix = _.Matrix
({
  buffer : buffer1,
  dims : [ 2, 2 ],
  strides : [ 4, 2 ],
  offset : 1,
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +3,
+5, +7,
*/

var matrixTransposed = _.Matrix
({
  buffer : buffer1,
  dims : [ 2, 2 ],
  strides : [ 2, 4 ],
  offset : 1,
});
console.log( `transposed matrix :\n${ matrixTransposed.toStr() }` );
/* log : transposed matrix :
+1, +5,
+3, +7,
*/
```

![ZeroCopyTransposing.png](../../img/ZeroCopyTransposing.png)

Приведена діаграма показано як буфер інтерпретується в матрицю. При зміні опції `strides` проходить транспонування матриці без копіювання буфера.

<!--
### Множення матриці на скаляр

### Множення двох матриць

### Множення матриці на вектор

### Рішення системи лінійних рівнянь
-->

[Повернутись до змісту](../README.md#Туторіали)
