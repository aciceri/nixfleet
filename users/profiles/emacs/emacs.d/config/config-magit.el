(setenv "SSH_AUTH_SOCK" "/run/user/1000/gnupg/S.gpg-agent.ssh")

(use-package magit
  :bind (("C-x g" . magit-status)
         ("C-x C-g" . magit-status)))

(use-package magit-delta
  :hook (magit-mode . magit-delta-mode))

(use-package transient
  :defer t
  :config
  (transient-bind-q-to-quit))

(use-package diff-hl
  :after magit
  :config
  (require 'diff-hl-flydiff)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (diff-hl-flydiff-mode t)
  (global-diff-hl-mode t))

(provide 'config-magit)
