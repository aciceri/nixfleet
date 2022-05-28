
(use-package evil
  :custom
  (evil-want-keybinding nil)
  (evil-undo-system 'undo-redo)
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

(use-package vimish-fold
  :ensure
  :after evil)

(use-package evil-vimish-fold
  :ensure
  :after vimish-fold
  :init
  (setq evil-vimish-fold-mode-lighter " ⮒")
  (setq evil-vimish-fold-target-modes '(prog-mode conf-mode text-mode))
  :config
  (global-evil-vimish-fold-mode))

(provide 'config-evil)
