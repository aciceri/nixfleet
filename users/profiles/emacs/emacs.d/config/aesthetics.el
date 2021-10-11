(use-package modus-themes
  :init 
  (setq
        modus-themes-region '(bg-only no-extend))
  (modus-themes-load-themes)
  :config
    (modus-themes-load-vivendi)
  :bind ("<f5>" . modus-themes-toggle)    
)  

(use-package fira-code-mode
  :custom (fira-code-mode-disabled-ligatures '(":")) ;; List of ligatures to turn off
  :config (global-fira-code-mode))


(defalias 'yes-or-no-p 'y-or-n-p)
(setq use-dialog-box nil
      display-time-format "%H:%M"
      mouse-autoselect-window 't
      inhibit-startup-screen t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(fringe-mode 1)
(display-time-mode 1)
(global-hl-line-mode 1)

(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook #'show-paren-mode)


(provide 'aesthetics)
