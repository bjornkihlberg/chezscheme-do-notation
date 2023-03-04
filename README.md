# chezscheme-do-notation

Haskell style `do` notation library for Chez Scheme

---

## Quickstart

```scheme
(import (do-notation))
```

The `do-notation` form uses the `flat-map` thread parameter. By default `flat-map` is set to imitate the identity monad:

```scheme
> (do-notation
    (<- x 5)
    (<- y 7)
    (+ x y))
12
```

Various `let` forms work the same like within `do` notation in Haskell:

```scheme
> (do-notation
    (<- x 68)
    (let [y (add1 x)])
    (add1 y))
70
```

`define` is also supported:

```scheme
> (do-notation
    (<- x 1336)
    (define (f a) (+ a x))
    (f 2))
1338
```

We can imitate other monads by defining other versions of `flat-map`.

## Examples

### Maybe monad

```scheme
> (define (thruthy-flat-map f x) (and x (f x)))
```

```scheme
> (parameterize ([flat-map thruthy-flat-map])
    (do-notation
      (<- x 5)
      (<- y #f)
      (+ x y)))
#f
```

### List monad

```scheme
> (define (list-flat-map f x) (apply append (map f x)))
```

```scheme
> (parameterize ([flat-map list-flat-map])
    (do-notation
      (<- x '(1 2))
      (<- y '(huey dewey))
      (list (cons x y))))
((1 . huey) (1 . dewey) (2 . huey) (2 . dewey))
```

### Writer monad

```scheme
> (define (writer-flat-map f x/ws)
    (let ([y/ws (f (car x/ws))])
      (cons (car y/ws) (append (cdr x/ws) (cdr y/ws)))))
> (define (pure x) (cons x '()))
```

Helper procedures

```scheme
> (define (tell . ws) (cons (void) ws))
> (define run-writer car)
> (define exec-writer cdr)
```

```scheme
> (parameterize ([flat-map writer-flat-map])
    (let ([w (do-notation
               (<- x (pure 15))
               (tell 'huey 'dewey)
               (<- y (pure -2))
               (tell 'louie)
               (pure (+ x y)))])

      (values (run-writer w)
              (exec-writer w))))
13
(huey dewey louie)
```
