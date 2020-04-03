# Створення матриці

Описуються способи створення матриці.

### Рутина `make`

Створює ініціалізовану матрицю заданого розміру.

```js
var matrix = _.Matrix.make( [ 2, 2 ] );
console.log( 'matrix : ', a.toStr() );
/* log : matrix : +0, +0,
                  +0, +0,
*/
```

### Рутина `makeSquare`

Створює квадратну матрицю із переданого буферу або числа.

```js
var matrix1 = _.Matrix.makeSquare( [ 2, 2, 3, 3 ] );
console.log( 'matrix1 : ', a.toStr() );
/* log : matrix1 : +2, +2,
                   +3, +3,
*/

var matrix2 = _.Matrix.makeSquare( 2 );
console.log( 'matrix2 : ', a.toStr() );
/* log : matrix2 : +0, +0,
                   +0, +0,
*/
```

### Рутина `makeZero`

Створює матрицю заданого розміру елементи котрої є нулі.

```js
var matrix1 = _.Matrix.makeZero( [ 2, 2 ] );
console.log( 'matrix1 : ', a.toStr() );
/* log : matrix1 : +0, +0,
                   +0, +0,
*/

var matrix2 = _.Matrix.makeZero( 2 );
console.log( 'matrix2 : ', a.toStr() );
/* log : matrix2 : +0, +0,
                   +0, +0,
*/
```

### Рутина `makeIdentity`

Створює матрицю заданого розміру, елемент матриці що має індекс рівний номеру рядка заповнюється значенням 1. У випадку квадратної матриці утворює одиничну матрицю.

```js
var matrix1 = _.Matrix.makeIdentity( [ 2, 3 ] );
console.log( 'matrix1 : ', a.toStr() );
/* log : matrix1 : +1, +0, +0
                   +0, +1, +0
*/

var matrix2 = _.Matrix.makeIdentity( 2 );
console.log( 'matrix2 : ', a.toStr() );
/* log : matrix2 : +1, +0,
                   +0, +1,
*/
```

### Рутина `makeDiagonal`

Створює квадратну матрицю діагональ якої заповнюється значеннями з переданого буферу.

```js
var matrix1 = _.Matrix.makeIdentity( [ 2, 3, 1 ] );
console.log( 'matrix : ', a.toStr() );
/* log : matrix : +2, +0, +0
                  +0, +3, +0
                  +0, +0, +1
*/
```

### Рутина `makeCol`

Створює квадратну матрицю-колонку з переданого аргумента.

```js
var matrix1 = _.Matrix.makeCol( [ 2, 3 ] );
console.log( 'matrix1 : ', a.toStr() );
/* log : matrix1 : +2,
                   +3,
*/

var matrix2 = _.Matrix.makeCol( 2 );
console.log( 'matrix2 : ', a.toStr() );
/* log : matrix2 : +0,
                   +0,
*/
```

### Рутина `makeRow`

Створює квадратну матрицю-колонку з переданого аргумента.

```js
var matrix1 = _.Matrix.makeRow( [ 2, 3 ] );
console.log( 'matrix1 : ', a.toStr() );
/* log : matrix1 : +2, +3,*/

var matrix2 = _.Matrix.makeRow( 2 );
console.log( 'matrix2 : ', a.toStr() );
/* log : matrix2 : +0, +0, */
```

### Рутина `fromVectorAdapter`

Створює матрицю-колонку з переданого вектора. Якщо вектор має крок, він передається як зміщення для рядка. Початкове зміщення в буфері - 0.

```js
var array = [ 1, 2, 3, 4, 5, 6 ];
var vector = _.vectorAdapter.fromLongLrangeAndStride( array, 1, 3, 2 );

var matrix1 = _.Matrix.fromVectorAdapter( vector );
console.log( 'matrix1 : ', a.toStr() );
/* log : matrix1 : +1, \n+3, \n+5, */

var matrix2 = _.Matrix.fromVectorAdapter( array );
console.log( 'matrix2 : ', a.toStr() );
/* log : matrix2 : +1, \n+2, \n+3, \n+4, \n+5, \n+6, */
```

### Рутина `fromScalar`

Створює матрицю заданого розміру та заповнює її переданим значенням.

```js
var matrix = _.Matrix.fromScalar( 5, [ 2, 2 ] );
console.log( 'matrix : ', a.toStr() );
/* log : matrix : +5, +5,
                  +5, +5
*/
```

<!--

Інтерпретатор не бачить рутину fromTransformations, потрібно дивитись що не так.
### Рутина `fromTransformations`

Створює матрицю заданого розміру та заповнює її переданим значенням.

```js
var matrix = _.Matrix.fromTransformations( 5, [ 2, 2 ] );
console.log( 'matrix : ', a.toStr() );
/* log : matrix : +5, +5,
                  +5, +5
*/
```
-->
