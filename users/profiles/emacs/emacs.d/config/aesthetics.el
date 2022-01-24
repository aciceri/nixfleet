(use-package modus-themes
  :init 
  (setq
        modus-themes-region '(bg-only no-extend))
  (modus-themes-load-themes)
  :config
    (modus-themes-load-operandi) ;white theme
    ;; (modus-themes-load-vivendi) ;black theme
  :bind ("<f5>" . modus-themes-toggle)    
)  

(use-package fira-code-mode
  :custom (fira-code-mode-disabled-ligatures '("x")) ;; List of ligatures to turn off
  :config
  (fira-code-mode-set-font)
  (global-fira-code-mode))

(use-package visual-fill-column
  :commands (visual-fill-column-mode)
  :hook
  (markdown-mode . activate-visual-fill-column)
  (org-mode . activate-visual-fill-column)
  :init
  (defun activate-visual-fill-column ()
    (interactive)
    (setq-local fill-column 80)
    (visual-line-mode t)
    (visual-fill-column-mode t))
  :config
  (setq-default visual-fill-column-center-text t
                visual-fill-column-fringes-outside-margins nil))

(use-package minimap
  :custom ((minimap-window-location 'right))
  :bind ("<f7>" . minimap-mode))

(use-package good-scroll
  :config (good-scroll-mode 1)
  :custom 
  :bind (([next] #'good-scroll-up-full-screen)
	 ([prior] #'good-scroll-down-full-screen))) 



(use-package rainbow-identifiers
  :hook ((prog-mode . rainbow-identifiers-mode)))

;; To move in a different config file
(when (string-equal system-type "darwin")
  (set-face-attribute 'default nil :height 150)
  (setq mac-command-modifier 'ctrl))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))


(defalias 'yes-or-no-p 'y-or-n-p)
(setq use-dialog-box nil
      display-time-format "%H:%M"
      column-number-mode t
      mouse-autoselect-window t
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
