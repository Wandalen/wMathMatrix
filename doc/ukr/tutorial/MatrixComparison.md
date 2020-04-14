# Порівняння матриць

Описуються способи і правила порівняння матриць.

Матриці можливо порівняти використовуючи рутини `_.identical` i `_.equivalent`. Рутина `_.identical` виконує строге порівняння, а `_.equivalent` порівнює не строго.

Різниця між рутинами для порівнняня:
- `_.identical` порівнює тип контейнера.
- `_.identical` порівнює тип буфера.
- `_.equivalent` порівнює із певною точністю.

### Порівняння двох матриць

```js
var matrixA = _.Matrix.MakeSquare
([
  +1, -5,
  -3, +4,
]);

var matrixB = _.Matrix.MakeSquare
([
  +1, -5,
  -3, +4,
]);

var identical = _.identical( matrixA, matrixB );
console.log( `identical : ${ identical }` );
/* log : identical : true */

var equivalent = _.equivalent( matrixA, matrixB );
console.log( `equivalent : ${ identical }` );
/* log : equivalent : true */
```

Обидві матриці мають однакові буфери, розмірності і порядок зчитування елементів тому рутини `_.identical` i `_.equivalent` повернули `true`.

### Порівняння матриць із різною шириною кроку

```js
var buffer1 = new F32x
([
  1, 2,
  3, 4,
]);
var matrixA = _.Matrix
({
  buffer : buffer1,
  dims : [ 2, 2 ],
  strides : [ 2, 1  ],
});

var buffer2 = new F32x
([
  0, 1, 2, 3,
  3, 4, 5, 0,
]);

var matrixB = _.Matrix
({
  buffer : buffer2,
  dims : [ 2, 2 ],
  strides : [ 3, 1 ],
  offset : 1,
});
var identical = _.identical( matrixA, matrixB );
console.log( `identical : ${ identical }` );
/* log : identical : true*/

var equivalent = _.equivalent( matrixA, matrixB );
console.log( `equivalent : ${ identical }` );
/* log : equivalent : true */
```

Рутини `_.identical` i `_.equivalent` порівнюють значення матриці, при цьому ігноруюються значення таких полів як `strides` i `offset`. Для матриць `matrixA` i `matrixB` результат перевірки - `true`.

### Порівняння матриць із буферами різних типів

```js
var buffer1 = new I32x
([
  +1, -5,
  -3, +4,
]);
var matrixA = _.Matrix
({
  buffer : buffer1,
  dims : [ 2, 2 ],
  inputTransposing : 1,
});

var buffer2 = new F32x
([
  +1, -5,
  -3, +4,
]);
var matrixB = _.Matrix
({
  buffer : buffer2,
  dims : [ 2, 2 ],
  inputTransposing : 1,
});
var identical = _.identical( matrixA, matrixB );
console.log( `identical : ${ identical }` );
/* log : identical : false */

var equivalent = _.equivalent( matrixA, matrixB );
console.log( `equivalent : ${ identical }` );
/* log : equivalent : true */
```

Значення матриць, їх розмірність, порядок інтерпретації буфера однаковий, відрізняються лише типи буферів. Рутина `_.identical` порівнює як значення матриці, так і типи буферів, її результат - `false`. Рутина `_.equivalent` порівняла лише значення матриць, її результат - `true`.

### Порівняння вектора та матриці

Матрицю-колонку можливо порівняти з вектором в форматі масиву чи типізованого масиву.

```js
var matrixCol = _.Matrix.MakeCol
([
  1,
  2,
  3
]);

var vector = [ 1, 2, 3 ];

var identical = _.identical( matrixCol, vector );
console.log( `identical : ${ identical }` );
/* log : identical : false */

var equivalent = _.equivalent( matrixCol, vector );
console.log( `equivalent : ${ identical }` );
/* log : equivalent : true */
```

Строге порівняння вектора в матричному форматі та в формі масиву повертатиме `false`, бо формати задання відрізняються. Рутина ж `_.equivalent` каже про те, що обидва вектори схожі, ігноруючи різницю в форматах.

### Порівняння із заданою точністю

В обчисленнях, що допускають похибку для порівняння використовуйте рутину `_.equivalent`. В рутині `_.equivalent` можливо задати точність порівняння.

```js
var matrixA = _.Matrix.MakeSquare
([
  1.01, 2,
  3,    4,
]);

var matrixB = _.Matrix.MakeSquare
([
  1.01, 2,
  3,    4,
]);

var equivalent = _.equivalent( matrixA, matrixB );
console.log( `result of comparison with standard accuracy : ${ equivalent }` );
/* log : result of comparison with standard accuracy : false */

var equivalent = _.equivalent( matrixA, matrixB, { accuracy : 0.01 } );
console.log( `result of comparison with accuracy 0.01 : ${ equivalent }` );
/* log : result of comparison with non-standard accuracy :true */
```

Матриці мають значення які незначно відрізняються. При порівнянні зі стандартним відхиленням `1e-7` перевірка провалилась, а при встановленні більшого відхилення рутина повернула `true`.

[Повернутись до змісту](../README.md#Туторіали)
