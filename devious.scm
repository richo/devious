#!/usr/bin/env csi -s
; Shitty irc bot, for the lulz
;

; Chicken internals
(use posix)
; Externals
(use openssl)
; Devious internals
(require "lib/irc_internals")
(require "lib/helpers")

;
; Poll indefinitely
(tcp-read-timeout #f)

; Hook to turn off debugging output
; (define (_debug) void)

(define all-handlers '())
(define (register-handler handler) (set! all-handlers (append all-handlers (list handler))))

(register-handler (lambda (line) (_debug line)))
(require "lib/handlers")

; TODO
;
; (if (equal? (length all-handlers) 0)
;     ( bail!)
; )

(define devious-server  "irc.psych0tik.net")
(define devious-port    6697)
(define devious-ssl     #t)

(define devious-nick    "devious")
(define devious-name    "devious")
(load-config)

(define (map-over handlers line)
  (let* ([func (lambda (f) (f line))])
        (map func handlers)
        )
  )

(define (handle-line line)
  ; Catch PING's early and handle
  (if (ping? line)
      (output (pong line))
      (map-over all-handlers line)
  )
  )

(define (_loop i o)
  (let* ([line (read-line i)])
    (if (equal? #!eof line)
        (_debug("eof reached"))
        (handle-line line)
    )
    (_loop i o)
  )
)

; Setup and initialization
(define (enter i o) (
  ; Any module registration etc should happen here.
  (devious-init o)
  (_loop i o))
  )

(define (main)
  ; TODO Deal with (if (devious-ssl)
  (receive
     (i o)
     (if (equal? devious-ssl #t)
         (ssl-connect devious-server devious-port)
         (tcp-connect devious-server devious-port)
     )
     (
      (define (output line) (write-line line o))
      (enter i o)
     )
  )
)


(main)


