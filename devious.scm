#!/usr/bin/env csi -ss
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
(define all-initializers '())
; TODO dedupe
; Some cool metaprogramming to be done here for sure
(define (register-handler handler)
  (set! all-handlers (append all-handlers (list handler))))
(define (register-initializer initializer)
  (set! all-initializers (append all-initializers (list initializer))))

(register-initializer (lambda () (join-channels devious-channels)))
(register-handler (lambda (line) (_debug line)))

(require "lib/handlers")

; TODO
;
; (if (equal? (length all-handlers) 0)
;     ( bail!)
; )
(define env-or-default
  (lambda (env-var default)
    (let ((store (get-environment-variable env-var)))
          (if store
            store
            default
            ))))


(let ((ssl (get-environment-variable "DEVIOUS_SSL")))
      (if ssl
        (if (= ssl "false")
          (define devious-ssl? #f)
          (define devious-ssl? #t)
          )
        (define devious-ssl? #f)
        ))

(define devious-server (env-or-default "DEVIOUS_SERVER" "irc.psych0tik.net"))
(define devious-port (string->number (env-or-default "DEVIOUS_PORT" "6697")))
(define devious-nick (env-or-default "DEVIOUS_NICK" "devious"))
(define devious-name (env-or-default "DEVIOUS_NAME" "devious"))

(define devious-channels (list "#devious"))

(define devious-admin-nick "warl0ck")
(load-config)

(define (map-over handlers line)
  (map (lambda (f) (f line))
       handlers))

(define (handle-line line)
  ; Catch PING's early and handle
  (if (ping? line)
      (output (pong line))
      (map-over all-handlers line)))

(define (_loop i o)
  (let ((line (read-line i)))
    (if (eof-object? line)
        (_debug("eof reached"))
        (handle-line line))
    (_loop i o )))

; Setup and initialization
(define (enter i o) (
  ; Any module registration etc should happen here.
  (devious-init o)
  (_loop i o)))

(define (main argv)
  (receive
     (i o)
     (if devious-ssl?
         (ssl-connect devious-server devious-port)
         (tcp-connect devious-server devious-port)
     )
     ((define (output line) (write-line line o))
      (enter i o))))
