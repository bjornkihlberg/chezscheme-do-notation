(define-syntax assert-with
  (syntax-rules ()
    [(_ comparison a b)
      (let ([actual a]
            [expected b])
        (guard (e [else (format #t "~a, namely the expression: (~a ~s ~s)\n"
                                   (condition-message e)
                                   'comparison
                                   actual
                                   expected)
                        (exit 1)])
          (assert (comparison actual expected))))]))

(display "Running tests...\n")

(define t0 (current-time))

(import (do-notation))

(assert-with eq? 1337 (do-notation 1337))

(define (thruthy-flat-map f x) (and x (f x)))

(assert-with eq? #f
  (parameterize ([flat-map thruthy-flat-map])
    (do-notation
      (<- x #f)
      (<- y 2)
      (+ x y))))

(assert-with eq? #f
  (parameterize ([flat-map thruthy-flat-map])
    (do-notation
      (<- x 'hey)
      #f
      x)))

(assert-with eq? 'yo
  (parameterize ([flat-map thruthy-flat-map])
    (do-notation
      (<- x 'yo)
      54
      x)))

(assert-with eq? #f
  (parameterize ([flat-map thruthy-flat-map])
    (do-notation
      (<- x 42068)
      (let [y (add1 x)]
           [z (odd? x)])
      (not (boolean? z))
      y)))

(define t1 (current-time))

(display "All tests passed!\n")
(format #t "~s\n" (time-difference t1 t0))
