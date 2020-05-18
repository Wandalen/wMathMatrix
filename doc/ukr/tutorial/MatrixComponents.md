# Компоненти матриці

Як отримати рядок, колонку, елемент, скаляр чи підматрицю матриці.

### Рядки

Для того, щоб отримати значення рядка використовуйте метод `rowGet`.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
var row = matrix.rowGet( 0 );
console.log( `first row :\n${ row }` );
/* log : first row :
VectorAdapter.x2.Array :: 1.000 2.000
*/
```

Метод `rowGet` повертає рядок у вигляді вектор адаптера, не копіюючи даних, а лише надаючи на них посилання.

Щоб встановити значення для рядка використовуйте метод `rowSet`.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
matrix.rowSet( 0, [ 4, 3 ] );
console.log( `changed matrix :\n${ matrix }` );
/* log : changed matrix :
Matrix.Array.2x2 ::
  +4 +3
  +3 +4
*/
```

Метод `rowSet` очікує вектор в будь-якому форматі: масив, типізовний масив чи вектор адаптер.

### Колонки

Для того, щоб отримати значення колонки використовуйте метод `colGet`.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
var row = matrix.colGet( 0 );
console.log( `first column :\n${ row }` );
/* log : first column :
VectorAdapter.x2.Array :: 1.000 3.000
*/
```

Метод `colGet` повертає колонку у вигляді вектор адаптера, не копіюючи даних, а лише надаючи на них посилання.

Щоб встановити значення для колонки використовуйте метод `colSet`.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
matrix.colSet( 0, 5 );
console.log( `changed matrix :\n${ matrix }` );
/* log : changed matrix :
Matrix.Array.2x2 ::
  +5 +2
  +5 +4
*/
```

Метод `colSet` очікує вектор в будь-якому форматі: масив, типізований масив чи вектор адаптер.

### Діагональ

Метод `diagonalGet` повертає вектор з діагоналлю матриці.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
var diagonal = matrix.diagonalGet();
console.log( `diagonal of matrix :\n${ diagonal }` );
/* log : diagonal of matrix :
VectorAdapter.x2.Array :: 1.000 4.000
*/
```

Для встановлення значення діагоналі матриці використовуйте метод `diagonalSet`.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
matrix.diagonalSet( [ 5, 7 ] );
console.log( `changed matrix :\n${ matrix }` );
/* log : changed matrix :
Matrix.Array.2x2 ::
  +5 +2
  +3 +7
*/
```

Методу `diagonalSet` передається вектор, що записується як діагональ матриці. При передачі скаляра діагональ матриці буде заповнена значенням цього скаляра.

### Елементи

Метод `eGet` повертає елемент матриці. Елементом типової 2-х вимірної матриці є колонка. Якщо ж матриця має 3-ри виміри то елементом буде типова 2-во вимірна матриця. Якщо матриця має 4-ри виміри то елементом буде типова 3-х вимірна матриця.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
var el = matrix.eGet( 1 );
console.log( `second column of matrix :\n${ el }` );
/* log : second column of matrix :
VectorAdapter.x2.Array :: 2.000 4.000
*/
```

Для встановлення значення елемента матриці використовуйте метод `eSet`.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
matrix.eSet( 0, [ 3, 5 ] );
console.log( `changed matrix :\n${ matrix }` );
/* log : changed matrix :
Matrix.Array.2x2 ::
  +3 +2
  +5 +4
*/
```

Методу `eSet` передається номер елемента ( колонки ) `0` та вектор нових значень. Вектор може бути заданий в форматі масиву, типізованого масиву чи вектор адаптера.

### Скаляри

Для доступу до елемента за індексами рядка і колонки використовуються методи `scalarGet` i `scalarSet`.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
var el = matrix.scalarGet([ 0, 1 ]);
console.log( `second element of first row :\n${ el }` );
/* log : second element of first row :
2
*/

matrix.scalarSet( [ 0, 1 ], 5 );
console.log( `changed matrix :\n${ matrix }` );
/* log : changed matrix :
Matrix.Array.2x2 ::
  +1 +5
  +3 +4
*/
```

Методи `scalarGet` i `scalarSet` очікують багатовимірний індекс. У випадку матриці вищого порядку вимірів буде більше 2-х.

### Падматриці

Для того, щоб отримати підматрицю використовуйте метод `submatrix`.

```js
var matrix = _.Matrix.MakeSquare
([
  0,  1,  2,  3,
  4,  5,  6,  7,
  8,  9,  10, 11,
  12, 13, 14, 15,
])
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.4x4 ::
  +0 +1 +2 +3
  +4 +5 +6 +7
  +8 +9 +10 +11
  +12 +13 +14 +15
*/
var sub1 = matrix.submatrix( [ 1, 2 ], [ 0, 1 ] );
console.log( `submatrix1 :\n${ sub1 }` );
/* log : submatrix1 :
Matrix.Array.2x2 ::
  +4 +5
  +8 +9
*/
var sub2 = matrix.submatrix( [ 1, 2 ], [ 1, 2 ] );
console.log( `submatrix2 :\n${ sub2 }` );
/* log : submatrix2 :
Matrix.Array.2x2 ::
  +5 +6
  +9 +10
*/
```

Перший ренж вибирає потрібні рядки, другий вибирає колонки. Підматриця `sub1` вибирає перетин рядків `1, 2` та колонок `0, 1` включно. Підматриця `sub2` вибирає перетин рядків `1, 2` та колонок `1, 2`. Підматриці мають спільні скаляри `6` i `10`.

[Повернутись до змісту](../README.md#Туторіали)
