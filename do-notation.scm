(library (do-notation)
  (export do-notation <- flat-map)
  (import (chezscheme))

  (define-syntax <- (lambda (code) (syntax-error code "invalid context")))

  (define flat-map (make-parameter (lambda (f x) (f x))))

  (define-syntax do-notation
    (syntax-rules (<- let let* letrec letrec* let-values let*-values)
      [(_ x) x]

      [(_ (<- x e) e* ...)
        ((flat-map) (lambda (x) (do-notation e* ...)) e)]

      [(_ (let [binding value] ...) e* ...)
        (let ([binding value] ...) (do-notation e* ...))]

      [(_ (let name bindings ...) e* ...)
        (let name (bindings ...) (do-notation e* ...))]

      [(_ (let* bindings ...) e* ...)
        (let* (bindings ...) (do-notation e* ...))]

      [(_ (letrec      bindings ...) e* ...) (letrec      (bindings ...) (do-notation e* ...))]
      [(_ (letrec*     bindings ...) e* ...) (letrec*     (bindings ...) (do-notation e* ...))]
      [(_ (let-values  bindings ...) e* ...) (let-values  (bindings ...) (do-notation e* ...))]
      [(_ (let*-values bindings ...) e* ...) (let*-values (bindings ...) (do-notation e* ...))]

      [(_ e e* ...)
        ((flat-map) (lambda (x) (do-notation e* ...)) e)])))
