# Матричні операції

Огляд операцій над матрицями.

### Виконання простої операції

Операції над матрицями виконуються викликом методів або статичних рутин.

```js
var matrix = _.Matrix.Make([ 3, 3 ]).copy
([
  1, 2, 3,
  4, 5, 6,
  7, 8, -9
]);
var result = matrix.determinant();
console.log( `determinant : ${ result }` );
/* log : determinant : 54 */
```

Метод `determinant` знаходить детермінант матриці.

### Транспонування матриці методом `transpose`

Матрицю можливо транспонувати методом `transpose`.

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

matrix.transpose();
console.log( `transposed matrix :\n${ matrix }` );
/* log : transposed matrix :
Matrix.Array.2x2 ::
  +1 +3
  +2 +4
*/
```

### Множення матриці на скаляр

Матриця може бути помножена на скаляр за допомогою статичної рутини `Mul`. Кожне значення матриці збільшиться в відповідну кількість разів. Рутина поміщає результат виконання операції в контейнер `dst`, якщо `dst` має значення `null`, тоді результат поміщається в новий контейнер.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);

var dst = _.Matrix.Mul( null, [ matrix, 3 ] );
console.log( `dst :\n${ dst }` );
/* log : dst :
Matrix.F32x.2x2 ::
  +3 +6
  +9 +12
*/
```

Статична рутина `Mul` множить матрицю `matrix` на скаляр `3`. Оскільки перший аргумент має значення `null` то під результат створюється новий контейнер `dst`, який і повертається, як результат виконання рутини.

Альтернативно, замість статичної рутини можливо викликати метод об'єкта.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);

matrix.mul( 3 );
console.log( `matrix :\n${ matrix }` );
/* log : matrix :
Matrix.Array.2x2 ::
  +3 +6
  +9 +12
*/
```

Метод `mul`, множить матрицю `matrix` на скаляр `3`. Результат записується в `matrix`.

### Множення матриці на вектор

Приклад множення матриці на вектор.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);
var vector = [ 1, 1 ];

var dst = _.Matrix.Mul( null, [ matrix, vector ] );
console.log( `dst :\n${ dst }` );
/* log : dst :
[ 3, 7 ]
*/
```

Статична рутина `Mul` множить матрицю `matrix` на вектор `vector`. Оскільки перший аргумент має значення `null`, то під результат створюється новий контейнер `dst`, який і повертається, як результат виконання рутини.

Альтернативно, екземпляр класу може бути помножений на вектор з використанням методу `matrixApplyTo`.

```js
var matrix = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);
var vector = [ 1, 1 ];

matrix.matrixApplyTo( vector );
console.log( `vector :\n${ vector }` );
/* log : vector :
[ 3, 7 ]
*/
```

Метод `mul`, множить матрицю `matrix` на вектор `vector`. Результат записується в вектор `vector`.

### Множення двох матриць

За допомогою статичної рутини `Mul` можливо перемножити і декілька матриць.

```js
var matrix1 = _.Matrix.MakeSquare
([
  1, 2,
  3, 4
]);
var matrix2 = _.Matrix.MakeSquare
([
  4, 3,
  2, 1
]);

var dst = _.Matrix.Mul( null, [ matrix1, matrix2 ] );
console.log( `dst :\n${ dst }` );
/* log : dst :
Matrix.Array.2x2 ::
  +8 +5
  +20 +13
*/
```

Статична рутина `Mul` множить матрицю `matrix1` на матрицю `matrix2`. Оскільки перший аргумент має значення `null` то під результат створюється новий контейнер `dst`, який і повертається, як результат виконання рутини.

### Множення декількох матриць

Статичною рутиною `Mul` можливо перемножити й декілька матриць за раз.

```js
var matrix1 = _.Matrix.Make([ 2, 3 ]).copy
([
  1, 2, -3,
  3, 4, -2,
]);
var matrix2 = _.Matrix.Make([ 3, 2 ]).copy
([
  4,  3,
  2,  1,
  -1, -2,
]);

var matrix3 = _.Matrix.MakeCol
([
  -4,
  5,
]);

var dst = _.Matrix.Mul( null, [ matrix1, matrix2, matrix3 ] );
console.log( `dst :\n${ dst }` );
/* log : dst :
Matrix.Array.2x1 ::
  +11
  -3
*/
```

Послідовність запису матриць в масиві відповідає порядку множення. Матриці послідовно перемножуються одна на одну. Оскільки перший аргумент має значення `null` то під результат створюється новий контейнер `dst`, який і повертається, як результат виконання рутини. Жодна із матриць `matrix1`, `matrix2`, `matrix3` не змінюється.

[Повернутись до змісту](../README.md#Туторіали)
