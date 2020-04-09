# Використання опції strides

Як використати опцію <code>stride</code> для інтерпретації буфера як матрицю.

### Стандартний крок

```js
var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 2, 2 ],
  strides : [ 2, 1 ]
});

console.log( 'matrix : ', matrix.toStr() );
/* log : matrix : +1, +2,
                  +3, +4,
*/
```

### Нестандартний крок

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

Значення першого елемента в опції `strides` визначає крок для рядків, другого - для колонок.

### Негативна ширина кроку

```js
var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 2, 2 ],
  offset : 8,
  strides : [ -2, -1 ],
});

console.log( 'matrix : ', matrix.toStr() );
/* log : matrix : +9, +8,
                  +7, +6,
*/
```

При використанні негативних значень в опції `strides` відлік елементів ведеться в зворотньому напряму від зміщення в буфері.

### Транспонована матриця з кроком

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

console.log( 'matrix : ', matrix.toStr() );
/* log : matrix : +1, +3,
                  +5, +7,
*/

var matrixTransposed = _.Matrix
({
  buffer : buffer1,
  dims : [ 2, 2 ],
  strides : [ 2, 4 ],
  offset : 1,
});
console.log( 'transposed matrix : ', matrixTransposed.toStr() );
/* log : transposed matrix : +1, +5,
                             +3, +7,
*/
```

![ZeroCopyTransposing.png](../../img/ZeroCopyTransposing.png)

Приведена діаграма показано як буфер інтерпретується в матрицю. При зміні опції `strides` проходить транспонування матриці без копіювання буфера.

[Повернутись до змісту](../README.md#Туторіали)
