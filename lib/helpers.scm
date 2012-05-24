(define (_debug d) (print d))

(define (load-config)
  (if (file-exists? "devious-config.scm")
      (require "devious-config")))

(define (line-get-index line index) (list-ref (string-split line) index))

(define (line-get-event line) (line-get-index line 1))
(define (line-event? line event)
  (equal? (line-get-event line) event))

; (define (line-get-nick line) ... )
(define (line-from-nick? line nick)
  (string-prefix? (string-append ":" nick "!") line))

(define (line-get-channel line) (line-get-index line 2))
(define (line-from-channel? line channel)
  (equal? (line-get-channel line) channel))

(define (line-get-data line)
  (string-intersperse (cdr (string-split line ":")) ":"))

(define (msg-from-admin? line)
  (if (line-event? line "PRIVMSG")
      (line-from-nick? line devious-admin-nick)
      #f))
;;

(define (format-privmsg to data)
  (string-append "PRIVMSG " to " :" data))
