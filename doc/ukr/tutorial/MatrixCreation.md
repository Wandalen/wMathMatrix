# Створення матриці

Описуються способи створення матриці.

### Static routine `Make`

Створює матрицю заданої розмірності.

```js
var matrix = _.Matrix.Make([ 2, 2 ]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.2x2 ::
  +0 +0
  +0 +0
*/
```

Створена матриця `matrix` має розмірність `2х2`, що було задано аргументом в виклику статичної рутини.

### Явний конструктор

Матрицю можливо створити і за допомогою явного виклику конструктора. При цьому необхідно задати принаймні 3 поля.

```js
var matrix = new _.Matrix
({
  buffer : [ 1, 2, 3, 4 ],
  dims : [ 2, 2 ],
  inputRowMajor : 1,
});
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
```

Конструктору передаєтсья буфер, розмірності та підказка для обчислення ширини кроку. Створена матриця `matrix` має розмірність `2х2`, що задаєтсья явно.

### Static routine `MakeSquare`

Створює квадратну матрицю із переданого буферу або заданої розмірності.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +1 +2
  +3 +4
*/
```

Статична рутина `MakeSquare` виводить ( deduce ) розмірність `2x2` із довжини вектора, який передається на вхід.

```js
var matrix = _.Matrix.MakeSquare( 2 );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.2x2 ::
  +0 +0
  +0 +0
*/
```

Розмірність `2x2` задається скаляром `2`. Так як створювана матриця квадратна то скаляра достатньо для того щоб вирахувати розмірність.

### Static routine `MakeZero`

Створює матрицю заданої розмірності і заповнює її нулями.

```js
var matrix = _.Matrix.MakeZero([ 2, 2 ]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.2x2 ::
  +0 +0
  +0 +0
*/
```

Розмірність `2x2` задається явно масивом.

```js
var matrix = _.Matrix.MakeZero( 2 );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.2x2 ::
  +0 +0
  +0 +0
*/
```

Розмірність `2x2` задається явно скаляром.

### Static routine `MakeIdentity`

Створює одиничну матрицю заданої розмірності. Діагональні значення такої матриці `1`.

```js
var matrix = _.Matrix.MakeIdentity( [ 2, 3 ] );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.2x3 ::
  +1 +0 +0
  +0 +1 +0
*/
```

Розмірність `2x3` задається явно масивом.

```js
var matrix = _.Matrix.MakeIdentity( 2 );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.2x2 ::
  +1 +0
  +0 +1
*/
```

Розмірність `2x2` задається явно скаляром.

### Static routine `MakeDiagonal`

Створює квадратну матрицю з заданими діагональними значеннями.

```js
var matrix = _.Matrix.MakeDiagonal( [ 2, 3, 1 ] );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.3x3 ::
  +2 +0 +0
  +0 +3 +0
  +0 +0 +1
*/
```

Розмірність `3х3` виводиться ( deduced ) із довжини даігоналі переданої, як вектор.

### Static routine `MakeCol`

Створює матрицю у формі колонки.

```js
var matrix = _.Matrix.MakeCol([ 2, 3 ]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x1 ::
  +2
  +3
*/
```

Статична рутина `MakeCol` в якості аргументу, отримує колонку в одному із форматів вектора. Розмірність матриці `2x1` виводиться ( deduced ) із довжини колонки.

```js
var matrix = _.Matrix.MakeCol( 2 );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.2x1 ::
  +0
  +0
*/
```

Довжина колонки задаєтсья явно `2`, розмірність матриці `2x1`.

### Static routine `MakeRow`

Створює матрицю у формі рядка.

```js
var matrix = _.Matrix.MakeRow( [ 2, 3 ] );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.1x2 ::
  +2 +3
*/
```

Статична рутина `MakeRow` в якості аргументу, отримує колонку в одному із форматів вектора. Розмірність матриці `1x2` виводиться ( deduced ) із довжини колонки.

```js
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.1x2 ::
  +0 +0
*/
```

Довжина рялка задаєтсья явно `2`, розмірність матриці `1x2`.

### Static routine `FromVector`

Створює матрицю-колонку з переданого вектора. Приймає вектора в будь-якому форматі:

- вектор адаптер
- типізований буфер
- звичайний масив

```js
var array = [ 1, 2, 3, 4, 5, 6 ];
console.log( `array :\n${ array }` );
/* log : array :
[ 1, 2, 3, 4, 5, 6 ]
*/
var vector = _.vectorAdapter.fromLongLrangeAndStride( array, 1, 3, 2 );
console.log( `vector :\n${ vector }` );
/* log : vector :
VectorAdapter.x3.Array :: 2.000 4.000 6.000
*/

var matrix1 = _.Matrix.FromVector( vector );
console.log( `matrix1 :\n${ matrix1 }` );
/* log : matrix1 :
Matrix.Array.3x1 ::
  +2
  +4
  +6
*/

var matrix2 = _.Matrix.FromVector( array );
console.log( `matrix2 :\n${ matrix2 }` );
/* log : matrix2 :
Matrix.Array.6x1 ::
  +1
  +2
  +3
  +4
  +5
  +6
*/
```

### Static routine `FromScalar`

Створює матрицю заданої розмірності та заповнює її переданим значенням.

```js
var matrix = _.Matrix.FromScalar( 5, [ 2, 2 ] );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.2x2 ::
  +5 +5
  +5 +5
*/
```

Розмірність матриці `2x2` задана 2-им аргументом.

### Static routine `FromTransformations`

Створює гомогенну матрицю 3D трансформацій за поворотами, зсувом та маштабуванням. Повороти задаються кватерніоном.

```js
var position = [ 1, 2, 3 ];
var quaternion = [ 0, 0, 0, 1 ];
var scale = [ 1, 1, 1 ];
var matrix = _.Matrix.FromTransformations( position, quaternion, scale );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.4x4 ::
  +1 +0 +0 +1
  +0 +1 +0 +2
  +0 +0 +1 +3
  +0 +0 +0 +1
*/
```

Так як зсув є єдиною компонентою із не одиничин значенням то в результаті повертається матриця зсуву `matrix`.

### Безкінечна матриця

Один із вимірів матриці може бути безкінечністю.

```js
var matrix = _.Matrix.Make( [ Infinity, 2 ] ).copy
([
  0, 1,
]);
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.F32x.Infinityx2 ::
  +0 +1
... ...
*/
```

Матриця `matrix` має безкінечну кількість рядків, що задається в її розмірності і означає, що один й той самий рядок `0 1` повторюється безкінечно.

### Багатовимірна матриця

Для створення багатовимірної задайте додаткову кількість вимірів.

```js
var matrix3d = _.Matrix.Make([ 2, 3, 4 ]).copy
([
  1,  2,  3,
  4,  5,  6,
  7,  8,  9,
  10, 11, 12,
  13, 14, 15,
  16, 17, 18,
  19, 20, 21,
  22, 23, 23,
]);
console.log( `3D matrix :\n${ matrix3d }` );
/* log : 3D matrix :
Matrix.F32x.2x3x4 ::
  Layer 0
    +1 +2 +3
    +4 +5 +6
  Layer 1
    +7 +8 +9
    +10 +11 +12
  Layer 2
    +13 +14 +15
    +16 +17 +18
  Layer 3
    +19 +20 +21
    +22 +23 +23
*/
```

Eлементом 3D-матриці є 2-во вимірна матриця, у виводі показано що тривимірна матриця `matrix3d` має 4 підматриці `Matrix-0`, `Matrix-1`, `Matrix-2`, `Matrix-3` розмірністю `2x3` кожна.

[Повернутись до змісту](../README.md#Туторіали)
