# Елементи матриці

Як отримати рядок, колонку, елемент, скаляр чи підматрицю певної матриці.

### Як працювати з рядком

Для того, щоб отримати значення рядка використовуйте метод `rowGet`.

```js
var matrix = _.Matrix.MakeSquare([ 1, 2, 3, 4 ]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4,
*/
var row = matrix.rowGet( 0 );
console.log( `first row :\n${ row.toStr() }` );
/* log : first row :
1.000, 2.000
*/
```

Метод `rowGet` повертає рядок у вигляді вектор адаптера, не копіюючи даних, а лише надаючи на них посилання.

Щоб встановити значення для рядка використовуйте метод `rowSet`.

```js
var matrix = _.Matrix.MakeSquare([ 1, 2, 3, 4 ]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4,
*/
matrix.rowSet( 0, [ 4, 3 ] );
console.log( `changed matrix :\n${ matrix.toStr() }` );
/* log : changed matrix :
+1, +2,
+4, +3,
*/
```

Метод `rowSet` очікує вектор в будь-якому форматі: масив, типізовний масив чи вектор адаптер.

### Як працювати з колонкою

Для того, щоб отримати значення колонки використовуйте метод `colGet`.

```js
var matrix = _.Matrix.MakeSquare([ 1, 2, 3, 4 ]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4
*/
var row = matrix.colGet( 0 );
console.log( `first column :\n${ row.toStr() }` );
/* log : first column :
1.000, 3.000 */
```

Метод `colGet` повертає колонку у вигляді вектор адаптера, не копіюючи даних, а лише надачи на них посилання.

Щоб встановити значення для колонки використовуйте метод `colSet`.

```js
var matrix = _.Matrix.MakeSquare([ 1, 2, 3, 4 ]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4
*/
matrix.colSet( 0, 5 );
console.log( `changed matrix :\n${ matrix.toStr() }` );
/* log : changed matrix :
+5, +2,
+5, +4
*/
```

Метод `colSet` очікує вектор в будь-якому форматі: масив, типізовний масив чи вектор адаптер.

### Як отримати або встановити значення скаляра

Для доступу до елемента за індексами рядка і колонки використовуються методи `scalarGet` i `scalarSet`.

```js
var matrix = _.Matrix.MakeSquare([ 1, 2, 3, 4 ]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4
*/

var el = matrix.scalarGet([ 0, 1 ]);
console.log( `second element of first row :\n${ el }` );
/* log : second element of first row :
2
*/

matrix.scalarSet( [ 0, 1 ], 5 );
console.log( `changed matrix :\n${ matrix.toStr() }` );
/* log : changed matrix :
+1, +5,
+3, +4
*/
```

Методи `scalarGet` i `scalarSet` очікують багатовимірний індекс. У випадку матриці вищого порядку вимірів буде більше 2-х.

### Як отримати або встановити значення елемента рядка матриці

Метод `eGet` повертає елемент матриці. Елементом типової 2-во вмиірної матриці є колонка. Якщо ж матриця має 3-ри виміри то елементом буде типова 2-во вимірна матриця. Якщо матриця має 4-ри виміри то елементом буде типова 3-х вимірна матриця.

```js
var matrix = _.Matrix.MakeSquare([ 1, 2, 3, 4 ]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4,
*/
var el = matrix.eGet( 1 );
console.log( `the second column of matrix :\n${ el.toStr() }` );
/* log : the second column of matrix :
2.000, 4.000
*/
```

Для встановлення значення елемента матриці використовуйте метод `eSet`.

```js
var matrix = _.Matrix.MakeSquare([ 1, 2, 3, 4 ]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4
*/
matrix.eSet( 0, [ 3, 5 ] );
console.log( `changed matrix :\n${ matrix.toStr() }` );
/* log : changed matrix :
+3, +2,
+5, +4
*/
```

### Як отримати підматрицю

Для того, щоб отримати підматрицю використовуйте метод `submatrix`.

```js
var matrix = _.Matrix.MakeSquare
([
  1,  2,  3,  4,
  5,  6,  7,  8,
  9,  10, 11, 12,
  13, 14, 15, 16,
]);
console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1,  +2,  +3,  +4,
+5,  +6,  +7,  +8,
+9,  +10, +11, +12,
+13, +14, +15, +16,
*/
var sub1 = matrix.submatrix( [ [ 0, 2 ], [ 0, 2 ] ] );
console.log( `submatrix1 :\n${ sub1.toStr() }` );
/* log : submatrix :
+1, +2,
+5, +6,
*/
var sub2 = matrix.submatrix( [ [ 2, 4 ], [ 2, 4 ] ] );
console.log( `submatrix2 :\n${ sub2.toStr() }` );
/* log : submatrix :
+3, +4,
+7, +8,
*/
```

Перший ренж задає кількість і розміщення рядків, другий - для колонок.

[Повернутись до змісту](../README.md#Туторіали)
