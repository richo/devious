; Handler to invoke any functions that need to take place after we're connected
; and ready
(register-handler (lambda (line)
  (cond
    ; End of MOTD
    [(equal? (line-get-event line) "376") (devious-become-ready)]
    )
  )
  )
