# Порівняння матриць

Засоби для порівняння матриць.

Матриці можливо порівняти використовуючи рутини `_.identical` i `_.equivalent`. Рутина `_.identical` виконує строге порівняння, а `_.equivalent` порівнює не строго.

Різниця між рутинами для порівняння:
- `_.identical` порівнює тип контейнера.
- `_.identical` порівнює тип буфера.
- `_.equivalent` порівнює із певною точністю.

### Порівняння двох матриць

```js
var matrix1 = _.Matrix.MakeSquare
([
  +1, -5,
  -3, +4,
]);

var matrix2 = _.Matrix.MakeSquare
([
  +1, -5,
  -3, +4,
]);

var identical = _.identical( matrix1, matrix2 );
console.log( `identical : ${ identical }` );
/* log : identical : true */

var equivalent = _.equivalent( matrix1, matrix2 );
console.log( `equivalent : ${ equivalent }` );
/* log : equivalent : true */
```

Обидві матриці мають однакові буфери, розмірності і значення елементів тому рутини `_.identical` i `_.equivalent` повернули `true`.

### Порівняння матриць із різною шириною кроку

Ширина кроку ( strides ) ніяк не впливає на результат порівняння матриць.

```js
var buffer1 = new F32x
([
  1, 2,
  3, 4,
]);
var matrix1 = new _.Matrix
({
  buffer : buffer1,
  dims : [ 2, 2 ],
  strides : [ 2, 1 ],
});

var buffer2 = new F32x
([
  0, 1, 2, 3,
  3, 4, 5, 0,
]);

var matrix2 = new _.Matrix
({
  buffer : buffer2,
  dims : [ 2, 2 ],
  strides : [ 3, 1 ],
  offset : 1,
});

var identical = _.identical( matrix1, matrix2 );
console.log( `identical : ${ identical }` );
/* log : identical : true*/

var equivalent = _.equivalent( matrix1, matrix2 );
console.log( `equivalent : ${ equivalent }` );
/* log : equivalent : true */
```

Рутини `_.identical` i `_.equivalent` порівнюють значення матриці і обидві повертають `true`. Як видно значення таких полів як `strides` i `offset` ігноруються.

### Порівняння матриць із буферами різних типів

```js
var buffer1 = new I32x
([
  +1, -5,
  -3, +4,
]);
var matrix1 = new _.Matrix
({
  buffer : buffer1,
  dims : [ 2, 2 ],
  inputRowMajor : 1,
});

var buffer2 = new F32x
([
  +1, -5,
  -3, +4,
]);
var matrix2 = new _.Matrix
({
  buffer : buffer2,
  dims : [ 2, 2 ],
  inputRowMajor : 1,
});

var identical = _.identical( matrix1, matrix2 );
console.log( `identical : ${ identical }` );
/* log : identical : false */

var equivalent = _.equivalent( matrix1, matrix2 );
console.log( `equivalent : ${ equivalent }` );
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
console.log( `equivalent : ${ equivalent }` );
/* log : equivalent : true */
```

Строге порівняння вектора в матричному форматі `matrixCol` та в форматі масиву `vector` повертатиме `false`, бо формати задання відрізняються. Рутина ж `_.equivalent` каже про те, що обидва вектори схожі, ігноруючи різницю в форматах.

### Порівняння із заданою точністю

Якщо в обчислення допускається відхилення тоді строге порівняння не підходить. Рутина `_.equivalent` порівнює із певною точністю. За допомогою рутини `_.equivalent` можливо задати точність порівняння.

```js
var matrix1 = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);

var matrix2 = _.Matrix.MakeSquare
([
  1, 2,
  3, 4.001
]);

var equivalent = _.equivalent( matrix1, matrix2 );
console.log( `result of comparison with standard accuracy : ${ equivalent }` );
/* log : result of comparison with standard accuracy : false */

var equivalent = _.equivalent( matrix1, matrix2, { accuracy : 0.01 } );
console.log( `result of comparison with accuracy 0.01 : ${ equivalent }` );
/* log : result of comparison with non-standard accuracy :true */
```

Матриці `matrix1` та `matrix2` відрізняються лише в останньому скалярі на `0.001`. При порівнянні зі стандартним відхиленням `1e-7` перевірка провалилась, а при встановленні нижчої точності `0.01` рутина `_.equivalent` повернула `true`.

[Повернутись до змісту](../README.md#Туторіали)
