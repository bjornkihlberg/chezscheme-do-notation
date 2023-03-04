(library (do-notation)
  (export do-notation)
  (import (chezscheme))

  (define-syntax do-notation
    (syntax-rules (<-)
      [(_ x) x])))
