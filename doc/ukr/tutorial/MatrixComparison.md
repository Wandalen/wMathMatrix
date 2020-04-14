# Порівняння матриць

Описуються способи і правила порівняння матриць.

### Порівняння двох матриць

Матриці можна порівняти використовуючи рутини `_.identical` i `_.equivalent`. Рутина `_.identical` виконує строге порівняння типу буфера та значень матриці, а `_.equivalent` порівнює лише значення з заданою точністю.

```js
var buffer1 = new F32x
([
  +1, -5, +2,
  -3, +4, +7,
]);
var matrixA = _.Matrix
({
  buffer : buffer1,
  dims : [ 2, 3 ],
  inputTransposing : 1,
});

var buffer2 = new F32x
([
  +1, -5, +2,
  -3, +4, +7,
]);
var matrixB = _.Matrix
({
  buffer : buffer2,
  dims : [ 2, 3 ],
  inputTransposing : 1,
});
var identical = _.identical( matrixA, matrixB );
console.log( `identical :\n${ identical }` );
/* log : identical :
true
*/

var equivalent = _.equivalent( matrixA, matrixB );
console.log( `equivalent :\n${ identical }` );
/* log : equivalent :
true
*/
```

Обидві матриці мають однакові буфери, розмірності і порядок зчитування елементів тому рутини `_.identical` i `_.equivalent` повернули `true`.

### Порівняння матриць із різною шириною кроку

```js
var buffer1 = new F32x
([
  +8, -4, +1,
  +1, -5, +2,
  -3, +4, +7,
]);
var matrixA = _.Matrix
({
  buffer : buffer1,
  dims : [ 2, 3 ],
  strides : [ 3, 1  ],
  offset : 3
});

var buffer2 = new F32x
([
  +1, -5, +2,
  -3, +4, +7,
]);
var matrixB = _.Matrix
({
  buffer : buffer2,
  dims : [ 2, 3 ],
  strides : [ 2, 1 ],
});
var identical = _.identical( matrixA, matrixB );
console.log( `identical :\n${ identical }` );
/* log : identical :
true
*/

var equivalent = _.equivalent( matrixA, matrixB );
console.log( `equivalent :\n${ identical }` );
/* log : equivalent :
true
*/
```

Рутини `_.identical` i `_.equivalent` порівнюють значення матриці, при цьому ігноруюються значення таких полів як `strides` i `offset`. Для матриць `matrixA` i `matrixB` результат перевірки - `true`.

### Порівняння матриць із буферами різних типів

```js
var buffer1 = new I32x
([
  +1, -5, +2,
  -3, +4, +7,
]);
var matrixA = _.Matrix
({
  buffer : buffer1,
  dims : [ 2, 3 ],
  inputTransposing : 1,
});

var buffer2 = new F32x
([
  +1, -5, +2,
  -3, +4, +7,
]);
var matrixB = _.Matrix
({
  buffer : buffer2,
  dims : [ 2, 3 ],
  inputTransposing : 1,
});
var identical = _.identical( matrixA, matrixB );
console.log( `identical :\n${ identical }` );
/* log : identical :
false
*/

var equivalent = _.equivalent( matrixA, matrixB );
console.log( `equivalent :\n${ identical }` );
/* log : equivalent :
true
*/
```

Значення матриць, їх розмірність, порядок інтерпретації буфера однаковий, відрізняються лише типи буферів. Рутина `_.identical` порівнює як значення матриці, так і типи буферів, її результат - `false`. Рутина `_.equivalent` порівняла лише значення матриць, її результат - `true`.

### Порівняння вектора та матриці

Матрицю-колонку можна порівняти з вектором.

```js
var matrixCol = _.Matrix.MakeCol
([
  1,
  -2,
  3
]);

var vector = [ 1, -2, 3 ];

var identical = _.identical( matrixCol, vector );
console.log( `identical :\n${ identical }` );
/* log : identical :
false
*/

var equivalent = _.equivalent( matrixCol, vector );
console.log( `equivalent :\n${ identical }` );
/* log : equivalent :
true
*/
```

Строге порівняння вектора і матриці колонки завжди повертатиме `false`, бо інстанси мають різні типи. Використовуйте рутину `_.equivalent` для порівняння вектора і матриці-колонки.

### Порівняння із заданою точністю

В обчисленнях, що допускають похибку для порівняння використовуйте рутину `_.equivalent`. В рутині `_.equivalent` можна задати точність порівняння.

```js
var buffer1 = new I32x
([
  +1, -5, +2,
  -3, +4, +7,
]);
var matrixA = _.Matrix
({
  buffer : buffer1,
  dims : [ 2, 3 ],
  inputTransposing : 1,
});

var buffer2 = new F32x
([
  +1.00001, -5, +2,
  -3,       +4, +7.000001,
]);
var matrixB = _.Matrix
({
  buffer : buffer2,
  dims : [ 2, 3 ],
  inputTransposing : 1,
});

var gotStandard = _.equivalent( matrixA, matrixB );
console.log( `result of comparison with standard accuracy :\n${ gotStandard }` );
/* log : result of comparison with standard accuracy :
false
*/

var gotNonStandard = _.equivalent( matrixA, matrixB, { accuracy : 0.0001 } );
console.log( `result of comparison with non-standard accuracy :\n${ gotNonStandard }` );
/* log : result of comparison with non-standard accuracy :
true
*/
```

Матриці мають різний тип буферів та значення які незначно відрізняються. При порівнянні зі стандартним відхиленням `1e-7` перевірка провалилась, а при встановленні більшого відхилення рутина повернула `true`.

[Повернутись до змісту](../README.md#Туторіали)
