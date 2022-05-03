(use-package symex
  :custom
  (symex-modal-backend 'evil)
  :config
  (symex-initialize)
    (global-set-key (kbd "C-c s") 'symex-mode-interface))  ; or whatever keybinding you like


(use-package aggressive-indent
  :commands (aggressive-indent-mode aggressive-indent-global-mode)
  :hook
  (emacs-lisp-mode . aggressive-indent-mode)
  (lisp-mode . aggressive-indent-mode))

(provide 'config-lisp)
