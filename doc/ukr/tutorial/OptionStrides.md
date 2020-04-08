# Використання опції strides

Як використати опцію <code>stride</code> для інтерпретації буфера як матрицю.

### Послідовний вибір елементів в рядку

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

### Вибір елементів з кроком

```js
var matrix1 = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 2, 2 ],
  strides : [ 4, 2 ]
});

console.log( 'matrix1 : ', matrix.toStr() );
/* log : matrix1 : +1, +3,
                   +5, +7,
*/
```

Значення першого елемента в опції `strides` визначає крок для рядків, другого - для колонок.

```js
var matrix2 = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 2, 2 ],
  offset : 1,
  strides : [ 3, 4 ]
});

console.log( 'matrix2 : ', matrix.toStr() );
/* log : matrix2 : +2, +6,
                   +5, +9,
*/
```

Один буфер може використовуватись декількома матрицями з різними опціями `strides`.

### Транспонована матриця з кроком

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


console.log( 'transposed matrix : ', matrix.toStr() );
/* log : transposed matrix : +1, +5,
                             +3, +7,
*/
```

[Повернутись до змісту](../README.md#Туторіали)
