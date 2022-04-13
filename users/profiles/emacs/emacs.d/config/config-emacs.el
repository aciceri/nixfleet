(setq backup-directory-alist `(("." . "~/.saves"))
      backup-by-copying t
      delete-old-versions 6
      kept-old-versions 2
      version-control t
      create-lockfiles nil
      native-comp-async-report-warnings-errors nil
      )

(provide 'config-emacs)
