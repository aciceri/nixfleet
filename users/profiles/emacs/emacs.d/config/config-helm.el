(use-package helm
  :init
  (progn
    (require 'helm-config)
    (setq helm-autoresize-max-height 0)
    (setq helm-autoresize-min-height 20)
    (global-set-key (kbd "C-c h") 'helm-command-prefix)
    (global-unset-key (kbd "C-x c"))

    (when (executable-find "ack")
      (setq helm-grep-default-command "ack -Hn --no-group --no-color %e %p %f"
	    helm-grep-default-recurse-command "ack -H --no-group --no-color %e %p %f"))

    (setq helm-semantic-fuzzy-match t
	  helm-imenu-fuzzy-match t
	  helm-M-x-fuzzy-match t ;; optional fuzzy matching for helm-M-x
	  helm-buffers-fuzzy-matching t
	  helm-recentf-fuzzy-match t
	  helm-split-window-in-side-p t
	  helm-buffer-max-length nil)

    (helm-mode 1)
    (helm-autoresize-mode 1))

  :bind
  (("C-c h" . helm-command-prefix)
   :map helm-command-map
   ("b" . helm-buffers-list)
   ("f" . helm-find-files)
   ("m" . helm-mini)
   ("o" . helm-imenu))
  :bind
  (("M-x" . helm-M-x)
   ("M-y" . helm-show-kill-ring)
   ("C-x b" . helm-mini)
   ("C-x C-f" . helm-find-files)))

(provide 'config-helm)
