Awful is an awful programming language implemented (aw)fully with OCaml.

# Usage

## Building

Just run the makefile, then the binary:
```
$ make all
$ ./awful
```

## Values and basic operations

Awful has currently four types of values: integers, floats, booleans and functions. Basic operations for the first three types are defined:

```
> 2 + 2
==> 4
> 1. / 2.
==> 0.5
> true and false
==> false
```

## Functions

Functions in Awful can take an arbitrary number of arguments. They are created with the keyword `fun` as demonstrated:

```
> (fun x -> x*x) 3
==> 9
> (fun x n -> x + n) 3 4
==> 7
```

## Assignement

You can bind symbols to values in the environment:

```
> let x = 2
> x + 2
==> 4
> let b = true
> b or false
==> true
```

Remember that functions are just values, so to define a function you would use:

```
> let add = fun x n -> x + n
> add 1 8
==> 9
```

To define recursive functions, use the `rec` keyword with the `let`:

```
> let rec pow = fun x n -> if n = 0 then 1 else x * pow (n - 1)
> pow 2 2
==> 4
```

You can also define new binary operators (no overloading though!):

```
> let ** = fun x n -> pow x n
> 3 ** 2
==> 9
```

Symbols must start with a letter and can contain letters or numbers. Binary operators are limited to a restricted set of symbols (see the source).

Finally, bindings can be local, so we can write the exponentiation operator as:

```
let ** = let pow = fun x n -> if n = 0 then 1 else x * pow x (n-1) in fun x n -> pow x n
```

Have fun, or not!