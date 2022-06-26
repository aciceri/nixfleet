(use-package typescript-mode
  :mode "\\.ts\\'")

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (flycheck-status-emoji-mode +1)
  
  (setq
   flycheck-checker 'javascript-eslint
   flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
;;(add-hook 'before-save-hook 'tide-format-before-save)

;; instead use prettier
(add-hook 'typescript-mode-hook 'prettier-mode)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

(provide 'config-typescript)
