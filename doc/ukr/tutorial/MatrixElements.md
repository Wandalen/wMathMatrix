# Елементи матриці

Як отримати рядок, колонку, елемент, скаляр чи підматрицю певної матриці.

### Як працювати з рядком

Для того, щоб отримати значення рядка використовується метод `rowVectorGet`.

```js
var matrix = _.Matrix.MakeSquare([ 1, 2, 3, 4 ]);
console.log( 'matrix : ', matrix.toStr() );
/* log : matrix : +1, +2,
                  +3, +4,
*/
var row = matrix.rowVectorGet( 0 );
console.log( 'first row : ', row.toStr() );
/* log : first row : 1.000, 2.000 */
```

Щоб встановити значення для рядка використовується метод `rowSet`.

```js
var matrix = _.Matrix.MakeSquare([ 1, 2, 3, 4 ]);
console.log( 'matrix : ', matrix.toStr() );
/* log : matrix : +1, +2,
                  +3, +4,
*/
matrix.rowSet( 0, [ 4, 3 ] );
console.log( 'changed matrix : ', matrix.toStr() );
/* log : changed matrix : +1, +2,
                          +4, +3,
*/
```

### Як працювати з колонкою

Для того, щоб отримати значення колонки використовується метод `colVectorGet`.

```js
var matrix = _.Matrix.MakeSquare([ 1, 2, 3, 4 ]);
console.log( 'matrix : ', matrix.toStr() );
/* log : matrix : +1, +2,
                  +3, +4
*/
var row = matrix.colVectorGet( 0 );
console.log( 'first column : ', row.toStr() );
/* log : first column : 1.000, 3.000 */
```

Щоб встановити значення для колонки використовується метод `colSet`.

```js
var matrix = _.Matrix.MakeSquare([ 1, 2, 3, 4 ]);
console.log( 'matrix : ', matrix.toStr() );
/* log : matrix : +1, +2,
                  +3, +4
*/
matrix.colSet( 0, 5 );
console.log( 'changed matrix : ', matrix.toStr() );
/* log : changed matrix : +5, +2,
                          +5, +4
*/
```

### Як отримати або встановити значення скаляра

Для доступу до елемента за індексами рядка і колонки використовуються методи `scalarGet` i `scalarSet`.

```js
var matrix = _.Matrix.MakeSquare([ 1, 2, 3, 4 ]);
console.log( 'matrix : ', matrix.toStr() );
/* log : matrix : +1, +2,
                  +3, +4
*/
var el = matrix.scalarGet( [ 0, 1 ] );
console.log( 'second element of first row : ', el );
/* log : second element of first row : 2 */

matrix.scalarSet( [ 0, 1 ], 5 );
console.log( 'changed matrix : ', matrix.toStr() );
/* log : changed matrix : +1, +5,
                          +3, +4
*/
```

### Як отримати або встановити значення елемента рядка матриці

За замовчуванням метод `eGet` застосовується до окремого рядка. Щоб вибрати окремий елемент матриці потрібно попередньо обрати потрібний рядок.

```js
var matrix = _.Matrix.MakeSquare([ 1, 2, 3, 4 ]);
console.log( 'matrix : ', matrix.toStr() );
/* log : matrix : +1, +2,
                  +3, +4
*/
var el = matrix.eGet( 1 );
console.log( 'second row of matrixSquare : ', el.toStr() );
/* log : second row of matrixSquare : 3.000, 4.000 */
var separateEl = matrixSquare.rowVectorGet( 0 ).eGet( 1 );
console.log( 'second element of first row : ', separateEl.toStr() );
/* log : second element of first row : 2.000 */
```

Для встановлення значення елемента матриці використовується метод `eSet`, якщо елемент матриці це рядок, тоді значення встановлюються для кожного елемента рядка. Для встановлення значення окремому елементу небхідно попередньо обрати рядок.

```js
var matrix = _.Matrix.MakeSquare([ 1, 2, 3, 4 ]);
console.log( 'matrix : ', matrix.toStr() );
/* log : matrix : +1, +2,
                  +3, +4
*/
matrix.rowVectorGet( 0 ).eSet( 1, 4 );
console.log( 'changed matrix : ', matrix.toStr() );
/* log : changed matrix : +1, +4,
                          +3, +4
*/
```
### Як отримати підматрицю

Для того, щоб отримати підматрицю використовується метод `submatrix`.

```js
var matrix = _.Matrix.MakeSquare
([
  1,  2,  3,  4,
  5,  6,  7,  8,
  9,  10, 11, 12,
  13, 14, 15, 16,
]);
console.log( 'matrix :\n', matrix.toStr() );
/* log : matrix :
+1,  +2,  +3,  +4,
+5,  +6,  +7,  +8,
+9,  +10, +11, +12,
+13, +14, +15, +16,
*/
var sub1 = matrix.submatrix( [ [ 0, 2 ], [ 0, 2 ] ] );
console.log( 'submatrix :\n', sub.toStr() );
/* log : submatrix :
+1, +2,
+5, +6,
*/
var sub2 = matrix.submatrix( [ [ 2, 4 ], [ 2, 4 ] ] );
/* log : submatrix :
+3, +4,
+7, +8,
*/
```

Перший ренж задає кількість і розміщення рядків, другий - для колонок.

[Повернутись до змісту](../README.md#Туторіали)
