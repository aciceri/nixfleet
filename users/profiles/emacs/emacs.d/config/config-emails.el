(use-package notmuch
  :custom
  (notmuch-archive-tags '("-unread"))
  (notmuch-show-indent-content nil)
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

(provide 'config-emails)
