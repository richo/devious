; Handler to invoke any functions that need to take place after we're connected
; and ready
(register-handler (lambda (line)
  (cond ; End of MOTD
    [(line-event? line "376") (devious-become-ready)])))

(register-handler (lambda (line)
  (if (msg-from-admin? line)
      (let* [(data (line-get-data line))]
            (if (string-prefix? "eval" data)
                (with-input-from-string
                  (string-intersperse (cdr (string-split data)) " ")
                  (compose eval read)))))))
