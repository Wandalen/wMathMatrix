# Використання опції strides

Як використати опцію <code>stride</code> для інтерпретації буфера як матриці.

### Стандартна ширина кроку

Об'єкт класа `Matrix` можливо створити одним із заданням значень полів об'єкта.

```js

var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 3, 2 ],
  inputTransposing : 0,
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +4,
+2, +5,
+3, +6,
*/

console.log( `effective strides :\n${ matrix._stridesEffective }` );
/* log : effective strides :
[ 1, 3 ]
*/

```

Три опції - це мінімальний обсяг інформації, котрий потрібен конструктору матриці. Буфер із даними `buffer`, інформація про виміри `dims` та опція `inputTransposing` - інформація про те чи вхідні дані є в транспонованій формі.

За замовчуванням в буфері елементи йдуть в такій послідовності:

![StandardStridesInputTransposing0.png](../../img/StandardStridesInputTransposing0.png)

Якщо задати значення опції `inputTransposing : 1`, тоді ширина кроку буде порахована за альтернативним алгоритмом.

```js

var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 3, 2 ],
  inputTransposing : 1,
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4,
+5, +6,
*/

console.log( `effective strides :\n${ matrix._stridesEffective }` );
/* log : effective strides :
[ 2, 1 ]
*/

```

Якщо задати значення опції `inputTransposing : 1` тоді ширина кроку заданих прикладу буде [ 2, 1 ]:

![StandardStridesInputTransposing0.png](../../img/StandardStridesInputTransposing0.png)

Опція `inputTransposing` підказує конструктору, які порахувати ширину кроку, альтернативно можливо вказати ширину кроку явно:

```js

var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 3, 2 ],
  strides : [ 2, 1 ],
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+3, +4,
+5, +6,
*/

console.log( `effective strides :\n${ matrix._stridesEffective }` );
/* log : effective strides :
[ 2, 1 ]
*/

```

Останній приклад ілюструється наступною діаграмою.

![StandardStrides.png](../../img/StandardStrides.png)

Приведена діаграма показує як буфер відображається ( map into ) в матрицю. Всі скаляри йдуть послідовно один за одним. За замовчуванням `strides` обраховується так щоб всі скаляри йшли послідовно. В якій же послідовності перебирати розмірності вказує оція `inputTransposing`.

Альтернативно для створення нової матриці можливо використати одну із [статичних рутин](./MatrixCreation.md) `_.Matrix.Make*`.

### Нестандартна ширина кроку

Ширина кроку може мати довільні значення, які можливо задати явно при конструюванні матриці.

```js
var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 3, 2 ],
  strides : [ 3, 1 ],
  offset : 1,
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+4, +5,
+7, +8,
*/
```

Значення першого елемента в опції `strides` визначає те який відступ потрібно зробити щоб отримати наступний елемент даної колонки. Значення другого елемента в опції `strides` визначає те який відступ потрібно зробити щоб отримати наступний елемент даного рядка.

![NonStandardStrides.png](../../img/NonStandardStrides.png)

Діаграма показує як розміщуються елементи матриці в буфері `buffer`. Зміщення в буфері - один елемент. `strides` має значення `[ 3, 1 ]`.


### Негативна ширина кроку

```js
var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 3, 2 ],
  offset : 8,
  strides : [ -2, -1 ],
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+9, +8,
+7, +6,
+5, +4,
*/
```

При використанні негативних значень в опції `strides` відлік елементів ведеться в зворотньому напряму від зміщення в буфері.

![NegativeStrides.png](../../img/NegativeStrides.png)

Діаграма показує як розміщуються елементи матриці в буфері `buffer`. Матриця має максимальне зміщення до елементу з індексом 8. Відлік елементів ведеться у зворотньому напрямі: крок для рядків - -3 елемента, для колонок - -1 елемент.


### Транспонована матриця з кроком

Для транспонування матриці можна змінити порядок значень в опції `strides`.

```js
var buffer1 = new I32x( [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ] );

var matrix = _.Matrix
({
  buffer : buffer1,
  dims : [ 3, 2 ],
  strides : [ 3, 1 ],
  offset : 1,
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1, +2,
+4, +5,
+7, +8,
*/

var matrixTransposed = _.Matrix
({
  buffer : buffer1,
  dims : [ 3, 2 ],
  strides : [ 1, 3 ],
  offset : 1,
});
console.log( `transposed matrix :\n${ matrixTransposed.toStr() }` );
/* log : transposed matrix :
+1, +4,
+2, +5,
+3, +6,
*/
```

![ZeroCopyTransposing.png](../../img/ZeroCopyTransposing.png)

Приведена діаграма показано як буфер інтерпретується в матрицю. При зміні опції `strides` проходить транспонування матриці без копіювання буфера.

### Підматриці

```js
var matrix = _.Matrix
({
  buffer : [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ],
  dims : [ 4, 3 ],
  offset : 1,
  strides : [ 4, 1 ],
});

console.log( `matrix :\n${ matrix.toStr() }` );
/* log : matrix :
+1,  +2,  +3,
+5,  +6,  +7,
+9,  +10, +11,
+13, +14, +15,
*/

var sub1 = matrix.submatrix( [ 1, 2 ], [ 0, 1 ] );
console.log( `submatrix1 :\n${ sub1.toStr() }` );
/* log : matrix :
+5,  +6,
+9,  +10,
*/

var sub2 = matrix.submatrix( [ 1, 2 ], [ 1, 2 ] );
console.log( `submatrix1 :\n${ sub1.toStr() }` );
/* log : matrix :
+6,  +7,
+10, +11,
*/

sub1.mul( [ sub1, 2 ] );
sub2.mul( [ sub2, 3 ] );
console.log( matrix.toStr() );
/* log : matrix :
+1,  +2,  +3,
+10, +36, +21,
+27, +60, +33,
+13, +14, +15,
*/
```

![Submatrices.png](../../img/Submatrices.png)

Приведена діаграма показано як буфер інтерпретується в матрицю. Пунктирами показано як розміщені підматриці в буфері та, відповідно, матриці. Підматриці використовують один буфер, тому спільні елементи збільшились в 6 разів.


### Багатовимірна матриця

...

[Повернутись до змісту](../README.md#Туторіали)
