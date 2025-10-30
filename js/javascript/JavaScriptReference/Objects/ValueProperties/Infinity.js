// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Infinity

//The global property Infinity is a numeric value representing infinity.

/*

Property attributes of Infinity
Writable	no
Enumerable	no
Configurable	no


 */

 const maxNumber = Math.pow(10, 1000); // max positive number

if (maxNumber === Infinity) {
  console.log('Let\'s call it Infinity!');
  // expected output: "Let's call it Infinity!"
}

console.log(1 / maxNumber);
// expected output: 0


/* Infinity is a property of the global object. In other words, it is a
variable in global scope.

The initial value of Infinity is Number.POSITIVE_INFINITY. The value Infinity
(positive infinity) is greater than any other number.

This value behaves slightly differently than mathematical infinity; see
Number.POSITIVE_INFINITY for details.

As defined by the ECMAScript 5 specification, Infinity is read-only
(implemented in JavaScript 1.8.5 / Firefox 4). */


console.log(Infinity          ); /* Infinity */
console.log(Infinity + 1      ); /* Infinity */
console.log(Math.pow(10, 1000)); /* Infinity */
console.log(Math.log(0)       ); /* -Infinity */
console.log(1 / Infinity      ); /* 0 */
console.log(1 / 0             ); /* Infinity */


