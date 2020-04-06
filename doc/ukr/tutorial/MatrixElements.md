# Елементи матриці

Як отримати значення або змінити елементи матриці.

### Як працювати з рядком

Для того, щоб отримати значення рядка використовується метод `rowVectorGet`.

```js
var matrix = _.Matrix.makeSquare( [ 1, 2, 3, 4 ] );
var row = matrix.rowVectorGet( 0 ).toStr();
console.log( 'first row : ', row );
/* log : first row : 1.000, 2.000 */
```

Щоб встановити значення для рядка використовується метод `rowSet`.

```js
var matrix = _.Matrix.makeSquare( [ 1, 2, 3, 4 ] );
matrix.rowSet( 0, [ 4, 3 ] );
var row = matrix.rowVectorGet( 0 ).toStr();
console.log( 'first row : ', row );
/* log : first row : 4.000, 3.000 */
```

### Як працювати з колонкою

Для того, щоб отримати значення колонки використовується метод `colVectorGet`.

```js
var matrix = _.Matrix.makeSquare( [ 1, 2, 3, 4 ] );
var row = matrix.colVectorGet( 0 ).toStr();
console.log( 'first column : ', row );
/* log : first column : 1.000, 3.000 */
```

Щоб встановити значення для рядка використовується метод `colSet`.

```js
var matrix = _.Matrix.makeSquare( [ 1, 2, 3, 4 ] );
matrix.rowSet( 0, 5 );
var row = matrix.colVectorGet( 0 ).toStr();
console.log( 'first row : ', row );
/* log : first row : 5.000, 5.000 */
```

### Як отримати або встановити значення елемента

### Елемент в матриці

Для доступу до елемента за індексами рядка і колонки використовуються методи `atomGet` i `atomSet`.

```js
var matrix = _.Matrix.makeSquare( [ 1, 2, 3, 4 ] );
var el = matrix.atomGet( [ 0, 1 ] );
console.log( 'second element of first row : ', el.toStr() );
/* log : second element of first row : 2.000 */

matrix.atomSet( [ 0, 1 ], 5 );
var el = matrix.atomGet( [ 0, 1 ] );
console.log( 'second element of first row : ', el.toStr() );
/* log : second element of first row : 5.000 */
```

### Елемент в рядку матриці

Значення елемента матриці визначається через метод `eGet`, його можна застосувати до окремого рядка.

```js
var matrixRow = _.Matrix.makeRow( [ 1, 2, 3, 4 ] );
var el = matrixRow.eGet( 1 );
console.log( 'second element of matrixRow : ', el.toStr() );
/* log : second element of matrixRow : 2.000 */

var matrixSquare = _.Matrix.makeSquare( [ 1, 2, 3, 4 ] );
var el = matrixSquare.eGet( 1 );
console.log( 'second row of matrixSquare : ', el.toStr() );
/* log : second row of matrixSquare : 3.000, 4.000 */
var separateEl = matrixSquare.rowVectorGet( 0 ).eGet( 1 );
console.log( 'second element of first row : ', separateEl.toStr() );
/* log : second element of first row : 2.000 */
```

Для встановлення значення елемента матриці використовується метод `eSet`, якщо елемент матриці це рядок, тоді значення встановлюються для кожного елемента рядка.

```js
var matrixSquare = _.Matrix.makeSquare( [ 1, 2, 3, 4 ] );
matrixSquare.eSet( 1, 5 );
var row = matrixSquare.eGet( 1 );
console.log( 'second row of matrixSquare : ', row );
/* log : second row of matrixSquare : 5.000, 5.000 */
matrixSquare.rowVectorGet( 0 ).eSet( 1, 4 );
var separateEl = matrixSquare.rowVectorGet( 0 ).eGet( 1 );
console.log( 'second element of first row : ', separateEl.toStr() );
/* log : second element of first row : 4.000 */
```

### Елемент буфера матриці

Модуль дозволяє працювати безпосередньо з буфером матриці з допомогою методів `atomFlatGet` i `atomFlatSet`. Доступні елементи лежать в ренжі між початком буферу і індексом останнього елемента створеної матриці.

```js
var matrix = _.matrix
({
  dims : [ 2, 2 ],
  strides : [ 1, 2 ],
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
});
var row = matrix.rowVectorGet( 0 );
console.log( 'first row : ', row.toStr() );
/* log : first row : 1.000, 2.000 */
var el = matrix.atomFlatGet( 2 );
console.log( 'second element of buffer : ', el );
/* log : second element of buffer : 3 */

matrix.strides = [ 3, 4 ];
var row = matrix.rowVectorGet( 0 );
console.log( 'first row : ', row.toStr() );
/* log : first row : 1.000, 4.000 */
var el = matrix.atomFlatGet( 2 );
console.log( 'second element of buffer : ', el );
/* log : second element of buffer : 3 */
```

Встановлення значення в буфері.

```js
var matrix = _.Matrix
({
  dims : [ 2, 2 ],
  strides : [ 1, 5 ],
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
});
console.log( 'matrix : ', a.toStr() );
/* log : matrix : +1, +2,
                  +6, +7,
*/
matrix.atomFlatSet( 6, 0 );
console.log( 'matrix : ', a.toStr() );
/* log : matrix : +1, +2,
                  +6, +0,
*/
```

[Повернутись до змісту](../README.md#Туторіали)
