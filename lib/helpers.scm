(define (_debug d)
  (print d)
  )

(define (load-config)
  (if (file-exists? "devious-config.scm")
      (require "devious-config")
      )
  )

(define (line-get-event line) (list-ref (string-split line) 1))
