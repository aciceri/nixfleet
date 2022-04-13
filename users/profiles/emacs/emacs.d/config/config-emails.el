(use-package notmuch
  :custom
  (notmuch-archive-tags '("-unread"))
  ;;(notmuch-show-indent-content nil)
  (notmuch-search-older-first nil)
  (message-kill-buffer-on-exit t)
  (notmuch-hello-sections
        '(notmuch-hello-insert-header
          notmuch-hello-insert-saved-searches
          notmuch-hello-insert-search
          notmuch-hello-insert-alltags
          notmuch-hello-insert-recent-searches
          notmuch-hello-insert-footer
          ))
  (notmuch-tagging-keys
   '(("a" notmuch-archive-tags "Archive")
     ("u" notmuch-show-
      mark-read-tags "Mark read")
     ("m" ("+muted") "Mute")
     ("f" ("+flagged") "Flag")
     ("s" ("+spam" "-inbox") "Mark as spam")
     ("d" ("+deleted" "-inbox") "Delete")))
  )

(use-package message
  :config
  (setq message-send-mail-function 'message-send-mail-with-sendmail
        message-sendmail-f-is-evil t
        message-sendmail-envelope-from nil ; 'header
        message-sendmail-extra-arguments '("--read-envelope-from"))

  (setq mml-secure-smime-sign-with-sender t)
  (setq mml-secure-openpgp-sign-with-sender t)

  ;; Add signature by default
  (add-hook 'message-setup-hook 'mml-secure-message-sign-pgpmime)
  ;; Verify other's signatures
  (setq mm-verify-option 'always))

(use-package sendmail
  :config
  (setq mail-specify-envelope-from nil
        send-mail-function 'message-send-mail-with-sendmail
        sendmail-program "msmtp"))

(provide 'config-emails)
