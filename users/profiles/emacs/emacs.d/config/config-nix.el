(use-package nix-mode
  :mode "\\.nix\\'"
  :config (setq format-on-save t)
  :bind ("<f8>" . (lambda () (interactive) (setq format-on-save (not format-on-save)) ))
  :hook
  (before-save . (lambda () (when (format-on-save) (lsp-format-buffer)))))

(require 'sudo-utils)

(defun nixos-rebuild-switch ()
  (interactive)
  (sudo-utils-shell-command "nixos-rebuild switch"))

(defun nixos-rebuild-test ()
  (interactive)
  ;; async-shell command should be sufficient, to check why it isn't
  (sudo-utils-shell-command "nixos-rebuild test"))

(global-set-key [f6] 'nixos-rebuild-test)

(provide 'config-nix)
