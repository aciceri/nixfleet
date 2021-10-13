(use-package lsp-python-ms
  :hook (python-mode . (lambda ()
                         (setq indent-tabs-mode nil)  ; disable tabs
                         (require 'lsp-python-ms)
                         (lsp)))
  :init
  (setq lsp-python-ms-executable (executable-find "python-language-server")))

(provide 'config-python)
