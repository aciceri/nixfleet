(use-package nix-mode
  :mode "\\.nix\\'"
  :hook 
  (before-save . lsp-format-buffer))
(require 'sudo-utils)

(defun nixos-rebuild-switch ()
  (interactive)
  (sudo-utils-shell-command "nixos-rebuild switch"))

(defun nixos-rebuild-test ()
  (interactive)
  ;; async-shell command should be sufficient, to check why it isn't
  (sudo-utils-shell-command "nixos-rebuild test"))

(global-set-key [f6] 'nixos-rebuild-test)

(provide 'nix)
