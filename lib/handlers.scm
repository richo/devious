; Handler to invoke any functions that need to take place after we're connected
; and ready
(register-handler (lambda (line)
  (cond ; End of MOTD
    [(line-event? line "376") (devious-become-ready)])))

(register-handler (lambda (line)
  (if (msg-from-admin? line)
      (output (format-privmsg (line-get-channel line)
                              (line-get-data line))))))
