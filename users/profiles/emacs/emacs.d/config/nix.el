(use-package nix-mode
  :mode "\\.nix\\'")

(require 'sudo-utils)

(defun nixos-rebuild-switch ()
  (interactive)
  (sudo-utils-shell-command "nixos-rebuild switch"))

(defun nixos-rebuild-test ()
  (interactive)
  (sudo-utils-shell-command "nixos-rebuild test"))

(provide 'nix)
