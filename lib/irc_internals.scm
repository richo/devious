(define (ping? line)
  (string-prefix? "PING" line)
  )

(define (pong line)
  (string-translate* line '(("PING" . "PONG"))))

(define (devious-init output)
  (map
    (lambda (line) (write-line line output))

    (list
      (string-append "user " devious-nick " 8 * : " devious-name)
      (string-append "nick " devious-nick)
      )
  ))


