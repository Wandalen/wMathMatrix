# Створення матриці

Описуються способи створення матриці.

### Статична рутина `Make`

Створює матрицю заданої розмірності.

```js
var matrix = _.Matrix.Make([ 2, 2 ]);
console.log( 'matrix : ', matrix.toStr() );
/* log : matrix : +0, +0,
                  +0, +0,
*/
```

Створена матриця `matrix` має розмірність `2х2`, що було задано аргументом в виклику статичної рутини.

### Статична рутина `MakeSquare`

Створює квадратну матрицю із переданого буферу або заданої розмірності.

```js
var matrix1 = _.Matrix.MakeSquare([ 2, 2, 3, 3 ]);
console.log( 'matrix1 : ', matrix1.toStr() );
/* log : matrix1 : +2, +2,
                   +3, +3,
*/
```

Статична рутина `MakeSquare` виводить ( deduce ) розмірність `2x2` із довжини вектора, який передається на вхід.

```js
var matrix2 = _.Matrix.MakeSquare( 2 );
console.log( 'matrix2 : ', matrix2.toStr() );
/* log : matrix2 : +0, +0,
                   +0, +0,
*/
```

Розмірність `2x2` задається скаляром `2`. Так як створювана матриця квадратна то скаляра достатньо.

### Статична рутина `MakeZero`

Створює матрицю заданої розмірності і заповнює її нулями.

```js
var matrix1 = _.Matrix.MakeZero([ 2, 2 ]);
console.log( 'matrix1 : ', matrix1.toStr() );
/* log : matrix1 : +0, +0,
                   +0, +0,
*/
```

Розмірність `2x2` задається явно масивом.

```js
var matrix2 = _.Matrix.MakeZero( 2 );
console.log( 'matrix2 : ', matrix2.toStr() );
/* log : matrix2 : +0, +0,
                   +0, +0,
*/
```

Розмірність `2x2` задається явно скаляром.

### Статична рутина `MakeIdentity`

Створює одиничну матрицю заданої розмірності. Діагональні значення такої матриці `1`.

```js
var matrix1 = _.Matrix.MakeIdentity( [ 2, 3 ] );
console.log( 'matrix1 : ', matrix1.toStr() );
/* log : matrix1 : +1, +0, +0
                   +0, +1, +0
*/
```

Розмірність `2x3` задається явно масивом.

```js
var matrix2 = _.Matrix.MakeIdentity( 2 );
console.log( 'matrix2 : ', matrix2.toStr() );
/* log : matrix2 : +1, +0,
                   +0, +1,
*/
```

Розмірність `2x2` задається явно скаляром.

### Статична рутина `MakeDiagonal`

Створює квадратну матрицю з заданими діагональними значеннями.

```js
var matrix = _.Matrix.MakeDiagonal( [ 2, 3, 1 ] );
console.log( 'matrix : ', matrix.toStr() );
/* log : matrix : +2, +0, +0
                  +0, +3, +0
                  +0, +0, +1
*/
```

Розмірність `3х3` виводиться ( deduced ) із довжини даігоналі переданої, як вектор.

### Статична рутина `MakeCol`

Створює матрицю у формі колонки.

```js
var matrix1 = _.Matrix.MakeCol([ 2, 3 ]);
console.log( 'matrix1 : ', matrix1.toStr() );
/* log : matrix1 : +2,
                   +3,
*/
```

Стартична рутина `MakeCol` в якості аргументу, отримує колонку в форматі вектора. Розмірність матриці `2x1` виводиться ( deduced ) із довжини колонки.

```js
var matrix2 = _.Matrix.MakeCol( 2 );
console.log( 'matrix2 : ', matrix2.toStr() );
/* log : matrix2 : +0,
                   +0,
*/
```

Довжина колонки задаєтсья явно `2`, розмірність матриці `2x1`.

### Статична рутина `MakeRow`

Створює матрицю у формі рядка.

```js
var matrix1 = _.Matrix.MakeRow( [ 2, 3 ] );
console.log( 'matrix1 : ', matrix1.toStr() );
/* log : matrix1 : +2, +3,*/
```

Стартична рутина `MakeRow` в якості аргументу, отримує рядок в форматі вектора. Розмірність матриці `1x2` виводиться ( deduced ) із довжини колонки.

```js
var matrix2 = _.Matrix.MakeRow( 2 );
console.log( 'matrix2 : ', matrix2.toStr() );
/* log : matrix2 : +0, +0, */
```

Довжина рялка задаєтсья явно `2`, розмірність матриці `1x2`.

### Статична рутина `FromVector`

Створює матрицю-колонку з переданого вектора. Приймає вектора в будь-якому форматі:

- вектор адаптер
- типізований буфер
- звичайний масив

```js
var array = [ 1, 2, 3, 4, 5, 6 ];
console.log( 'array : ', array );
/* log : array : [ 1, 2, 3, 4, 5, 6 ] */
var vector = _.vectorAdapter.fromLongLrangeAndStride( array, 1, 3, 2 );
console.log( vector.toStr() );
/* log : 2.000, 4.000, 6.000 */

var matrix1 = _.Matrix.FromVector( vector );
console.log( 'matrix1 : ', matrix1.toStr() );
/* log : matrix1 : +1,
                   +3,
                   +5,
*/

var matrix2 = _.Matrix.FromVector( array );
console.log( 'matrix2 : ', matrix2.toStr() );
/* log : matrix2 : +1,
                   +2,
                   +3,
                   +4,
                   +5,
                   +6,
*/
```

### Статична рутина `FromScalar`

Створює матрицю заданої розмірності та заповнює її переданим значенням.

```js
var matrix = _.Matrix.FromScalar( 5, [ 2, 2 ] );
console.log( 'matrix : ', a.toStr() );
/* log : matrix : +5, +5,
                  +5, +5
*/
```

Розмірність матриці `2x2` задана 2-им аргументом.

### Статична рутина `FromTransformations`

Створює гомогенну матрицю 3D трансформацій за поворотами, зусувом та маштабуванням. Повороти задаються кватерніоном.

```js
var position = [ 1, 2, 3 ];
var quaternion = [ 0, 0, 0, 1 ];
var scale = [ 1, 1, 1 ];
var matrix = _.Matrix.FromTransformations( position, quaternion, scale );
console.log( 'matrix : ', matrix.toStr() );
/* log : matrix : +1, +0, +0, +1,
                  +0, +1, +0, +2,
                  +0, +0, +1, +3,
                  +0, +0, +0, +1,
*/
```

Так як зсув є єдиною компонентою із не одиничин значенням то в результаті повертається матриця зсуву `matrix`.

[Повернутись до змісту](../README.md#Туторіали)
