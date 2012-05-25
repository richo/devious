(define (ping? line) (string-prefix? "PING" line))

(define (pong line) (string-translate* line '(("PING" . "PONG"))))

(define (join-channels channels)
  (map
    (lambda (channel) (output (string-append "JOIN " channel)))
    channels))

; Output must be passed in because we haven't explicitly bound it yet
(define (devious-init output)
  (map
    (lambda (line) (write-line line output))
    (list
      (string-append "user " devious-nick " 8 * : " devious-name)
      (string-append "nick " devious-nick))))

(define (devious-become-ready)
  (let ((func (lambda (f) (f))))
        (map func all-initializers)))
