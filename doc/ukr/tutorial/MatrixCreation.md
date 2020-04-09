# Створення матриці

Описуються способи створення матриці.

### Рутина `Make`

Створює матрицю заданої розмірності.

```js
var matrix = _.Matrix.Make([ 2, 2 ]);
console.log( 'matrix : ', a.toStr() );
/* log : matrix : +0, +0,
                  +0, +0,
*/
```

### Рутина `MakeSquare`

Створює квадратну матрицю із переданого буферу або числа.

```js
var matrix1 = _.Matrix.MakeSquare( [ 2, 2, 3, 3 ] );
console.log( 'matrix1 : ', a.toStr() );
/* log : matrix1 : +2, +2,
                   +3, +3,
*/
```

```js
var matrix2 = _.Matrix.MakeSquare( 2 );
console.log( 'matrix2 : ', a.toStr() );
/* log : matrix2 : +0, +0,
                   +0, +0,
*/
```

### Рутина `MakeZero`

Створює матрицю заданого розміру і заповнює її нулями.

```js
var matrix1 = _.Matrix.MakeZero( [ 2, 2 ] );
console.log( 'matrix1 : ', a.toStr() );
/* log : matrix1 : +0, +0,
                   +0, +0,
*/
```

```js
var matrix2 = _.Matrix.MakeZero( 2 );
console.log( 'matrix2 : ', a.toStr() );
/* log : matrix2 : +0, +0,
                   +0, +0,
*/
```

### Рутина `MakeIdentity`

Створює одиничну матрицю заданого розміру. Діагональні значення такої матриці `1`.

```js
var matrix1 = _.Matrix.MakeIdentity( [ 2, 3 ] );
console.log( 'matrix1 : ', a.toStr() );
/* log : matrix1 : +1, +0, +0
                   +0, +1, +0
*/
```

```js
var matrix2 = _.Matrix.MakeIdentity( 2 );
console.log( 'matrix2 : ', a.toStr() );
/* log : matrix2 : +1, +0,
                   +0, +1,
*/
```

### Рутина `MakeDiagonal`

Створює квадратну матрицю з заданими діагональними значеннями.

```js
var matrix1 = _.Matrix.MakeDiagonal( [ 2, 3, 1 ] );
console.log( 'matrix : ', a.toStr() );
/* log : matrix : +2, +0, +0
                  +0, +3, +0
                  +0, +0, +1
*/
```

### Рутина `MakeCol`

Створює матрицю у формі колонки.

```js
var matrix1 = _.Matrix.MakeCol([ 2, 3 ]);
console.log( 'matrix1 : ', a.toStr() );
/* log : matrix1 : +2,
                   +3,
*/
```

```js
var matrix2 = _.Matrix.MakeCol( 2 );
console.log( 'matrix2 : ', a.toStr() );
/* log : matrix2 : +0,
                   +0,
*/
```

### Рутина `MakeRow`

Створює матрицю у формі рядка.

```js
var matrix1 = _.Matrix.MakeRow( [ 2, 3 ] );
console.log( 'matrix1 : ', a.toStr() );
/* log : matrix1 : +2, +3,*/
```

```js
var matrix2 = _.Matrix.MakeRow( 2 );
console.log( 'matrix2 : ', a.toStr() );
/* log : matrix2 : +0, +0, */
```

### Рутина `FromVector`

Створює матрицю-колонку з переданого вектора. Приймає вектора в будь-якому форматі:

- як вектор адаптер
- типізований буфер
- звичайний масивмасив

```js
var array = [ 1, 2, 3, 4, 5, 6 ];
var vector = _.vectorAdapter.fromLongLrangeAndStride( array, 1, 3, 2 );
console.log( vector.toStr() );
/* log : 2.000, 4.000, 6.000 */

var matrix1 = _.Matrix.FromVector( vector );
console.log( 'matrix1 : ', a.toStr() );
/* log : matrix1 : +1,
                   +3,
                   +5,
*/

var matrix2 = _.Matrix.FromVector( array );
console.log( 'matrix2 : ', a.toStr() );
/* log : matrix2 : +1,
                   +2,
                   +3,
                   +4,
                   +5,
                   +6,
*/
```

### Рутина `FromScalar`

Створює матрицю заданого розміру та заповнює її переданим значенням.

```js
var matrix = _.Matrix.FromScalar( 5, [ 2, 2 ] );
console.log( 'matrix : ', a.toStr() );
/* log : matrix : +5, +5,
                  +5, +5
*/
```

### Рутина `fromTransformations`

Змінює значення матричі через трансформацію з квантеріоном.

```js
var matrix = _.Matrix.make( [ 4, 4 ] );
var position = [ 1, 2, 3 ];
var quaternion = [ 0, 0, 0, 1 ];
var scale = [ 1, 1, 1 ];
matrix.fromTransformations( position, quaternion, scale );
console.log( 'matrix : ' : matrix.toStr() );
/* log : matrix : +1, +0, +0, +1,
                  +0, +1, +0, +2,
                  +0, +0, +1, +3,
                  +0, +0, +0, +1,
*/
```

<!--
### Багатовимірні матриці
-->

[Повернутись до змісту](../README.md#Туторіали)
