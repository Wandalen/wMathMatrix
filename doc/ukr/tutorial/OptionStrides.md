# Використання опції strides

Як динамічно змінювати матриці з одиничного буферу.

Множину матриць можна створити використовуючи конструктор і методи. Опція `strides` дозволяє динамічно змінювати елементи матриці.

### Послідовний вибір елементів в рядку

```js
var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 2, 2 ],
  strides : [ 2, 1 ]
});

console.log( 'first row : ', matrix.rowVectorGet( 0 ).toStr() );
/* log : first row : 1.000, 2.000 */
console.log( 'second row : ', matrix.rowVectorGet( 1 ).toStr() );
/* log : second row : 3.000, 4.000 */
```

### Вибір елементів з кроком

```js
var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 2, 2 ],
  strides : [ 4, 2 ]
});

console.log( 'first row : ', matrix.rowVectorGet( 0 ).toStr() );
/* log : first row : 1.000, 3.000 */
console.log( 'second row : ', matrix.rowVectorGet( 1 ).toStr() );
/* log : second row : 5.000, 7.000 */
```

### Транспонована матриця з кроком

```js
var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 2, 2 ],
  strides : [ 2, 4 ]
});

console.log( 'first row : ', matrix.rowVectorGet( 0 ).toStr() );
/* log : first row : 1.000, 5.000 */
console.log( 'second row : ', matrix.rowVectorGet( 1 ).toStr() );
/* log : second row : 3.000, 7.000 */
```

### Зміна опції `strides`

```js
var matrix = _.Matrix
({
  buffer : [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  dims : [ 2, 2 ],
  strides : [ 3, 4 ]
});

console.log( 'first row : ', matrix.rowVectorGet( 0 ).toStr() );
/* log : first row : 1.000, 5.000 */
console.log( 'second row : ', matrix.rowVectorGet( 1 ).toStr() );
/* log : second row : 4.000, 8.000 */
```

