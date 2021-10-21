
(use-package evil
  :init
  (setq evil-want-keybinding nil)
  :config
    (evil-mode 1) ; globally enable evil-mode except for the following modes
    (mapcar (lambda (mode) (evil-set-initial-state mode 'emacs))
	      '(vterm-mode
		eshell-mode
		dired-mode
		)))

(use-package evil-collection
  :after (evil)
  :config
  (evil-collection-init))

(provide 'config-evil)
