(library (do-notation)
  (export do-notation <- flat-map)
  (import (chezscheme))

  (define-syntax <- (lambda (code) (syntax-error code "invalid context")))

  (define flat-map (make-parameter (lambda (f x) (f x))))

  (define-syntax do-notation
    (syntax-rules (<-)
      [(_ x) x]
      [(_ (<- x e) e* ...)
        ((flat-map) (lambda (x) (do-notation e* ...)) e)])))
