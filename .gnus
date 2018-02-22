(setq gnus-ignored-newsgroups "")

(setq gnus-select-method '(nnnil ""))

(setq gnus-secondary-select-methods 
      '((nnimap "skel"
	       (nnimap-address "imap.gmail.com"))
      (nnimap "brisingr"
	      (nnimap-address "imap.gmail.com"))))

;; This is needed to allow msmtp to do its magic:
(setq message-sendmail-f-is-evil 't)

;;need to tell msmtp which account we're using
(setq message-sendmail-extra-arguments '("--read-envelope-from"))

;; with Emacs 23.1, you have to set this explicitly (in MS Windows)
;; otherwise it tries to send through OS associated mail client
(setq message-send-mail-function 'message-send-mail-with-sendmail)
;; we substitute sendmail with msmtp
(setq sendmail-program "msmtp")
;;need to tell msmtp which account we're using
(defun cg-feed-msmtp ()
  (if (message-mail-p)
          (save-excursion
                (let* ((from
                               (save-restriction
                                         (message-narrow-to-headers)
                                         (message-fetch-field "from")))
                           (account
                                   (cond
                                            ;; I use email address as account label in ~/.msmtprc
                                        ((string-match "skel.eloren@gmail.com" from)"skel")
                                ;; Add more string-match lines for your email accounts
                                ((string-match "brisingr.roneet@gmail.com" from)"brisingr"))))
                  (setq message-sendmail-extra-arguments (list '"-a" account)))))) ; the original form of this script did not have the ' before "a" which causes a very difficult to track bug --frozencemetery

(setq message-sendmail-envelope-from 'header)
(add-hook 'message-send-mail-hook 'cg-feed-msmtp)
