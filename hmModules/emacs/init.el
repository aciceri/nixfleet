;; package --- My Emacs config -*- lexical-binding:t -*-
;; Author: Andrea Ciceri <andrea.ciceri@autistici.org>
;;; Commentary:
;; TODO
;; - org-roam
;; - org goodies
;; - persp-mode?
;; - understand how to configure cape
;;; Code:


(use-package flymake
  :config
  ;; TODO write "E", "W" or "N" in margins overriding the margin created by diff-hl
  ;; (push `(before-string . ,(propertize " " 'display '((margin left-margin) "E"))) (get :error 'flymake-overlay-control))
  ;; (push `(before-string . ,(propertize " " 'display '((margin left-margin) "W"))) (get :warning 'flymake-overlay-control))
  ;; (push `(before-string . ,(propertize " " 'display '((margin left-margin) "N"))) (get :note 'flymake-overlay-control))
  ;; TODO set following only when on terminal (where wavy underlines are not shown)
  ;; (set-face-attribute 'flymake-error  nil :inverse-video t)
  ;; (set-face-attribute 'flymake-warning  nil :inverse-video t)
  ;; (set-face-attribute 'flymake-note  nil :inverse-video t)
  :custom
  (flymake-mode-line-lighter "Fly")
  :hook prog-mode)

(use-package eglot
  :custom
  ;; Tricks that should make Emacs faster
  (eglot-events-buffer-size 0) ; disable events logging, it should be enabled only when debuggigng LSP servers
  (eglot-sync-connect-nil 0) ; disable UI freeze when opening big files
  (eglot-connect-timeout nil) ; never timeout
  )

(use-package consult-eglot
  :after (consult eglot embark)
  :config
    (require 'consult-eglot-embark)
    (consult-eglot-embark-mode)
  )

(use-package emacs
  :bind (("<mouse-4>" . scroll-down-line)
	 ("<mouse-5>" . scroll-up-line)
	 (("C-x F" . recentf-open)))
  :hook (server-after-make-frame . (lambda () (xterm-mouse-mode +1))) ;; FIXME why is this needed?
  :custom
  (use-dialog-box nil)
  (use-short-answers t)
  (native-comp-async-report-warnings-errors nil)
  (inhibit-startup-message t)
  (visible-bell t)
  (scroll-conservatively 101) ;; more than 100 => redisplay doesn't recenter point)
  (scroll-margin 3)
  (temporary-file-directory "~/.emacs-saves/")
  (backup-directory-alist `(("." . ,temporary-file-directory)))
  (auto-save-files-name-transforms `((".*" ,temporary-file-directory t)))
  (backup-by-copying t)
  (focus-follows-mouse t)
  (mouse-autoselect-window t)
  (treesit-font-lock-level 4)
  :config
  (set-face-background 'vertical-border (face-background 'default))
  (set-display-table-slot standard-display-table 'vertical-border (make-glyph-code ?┃))
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (xterm-mouse-mode +1)
  (tool-bar-mode -1)
  (global-hl-line-mode -1)
  (global-auto-revert-mode t)
  (show-paren-mode +1)
  (column-number-mode +1)
  (add-to-list 'default-frame-alist '(font . "Iosevka Comfy-13"))
  (recentf-mode +1)
  (fset #'jsonrpc--log-event #'ignore) ; this should be enabled only when needed, otherwise makes Emacs slower
  (setq save-interprogram-paste-before-kill 't) ; system clipboard will be saved in the kill ring
  (defun ccr/reload-emacs ()
    (interactive)
    (load-file "~/.config/emacs/init.el"))
  (load-theme 'catppuccin 't)
  (defun ccr/nixos-rebuild ()
    (interactive)
    (let* ((operation (completing-read "nixos-rebuild " '("switch" "boot" "test" "dry-activate")))
	   (buffer-name (format "nixos-rebuild-%s" operation)))
      (async-shell-command (format "sudo nixos-rebuild --flake fleet %s -L" operation) buffer-name)))
  )

(use-package doc-view
  :custom
  (doc-view-scale-internally nil)
  (doc-view-imenu-enabled 't)
  (doc-view-continuous t))

(use-package tramp
  :config
  ;; TODO ugly `ccr' hardcoded, moreover this makes sense only when connecting to NixOS machines
  (add-to-list 'tramp-remote-path "/home/ccr/.nix-profile/bin" 't)
  (add-to-list 'tramp-remote-path "/etc/profiles/per-user/ccr/bin" 't)
  (add-to-list 'tramp-remote-path "/run/current-system/sw/bin" 't)
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
  :custom
  (tramp-use-ssh-controlmaster-options nil) ;; makes tramp use ~/.ssh/config
  )

(use-package ligature
  :config
  (ligature-set-ligatures 't '("www"))
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                       "\\\\" "://"))
  (global-ligature-mode t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package clipetty
  :delight
  :ensure t
  :hook (after-init . global-clipetty-mode))

(use-package nerd-icons)

(use-package nerd-icons-completion
  :after marginalia
  :config (nerd-icons-completion-mode +1)
  :hook (
	 (marginalia-mode . nerd-icons-completion-marginalia-setup)
	 (ibuffer-mode . nerd-icons-completion-marginalia-setup)))

(use-package nerd-icons-ibuffer
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(use-package treemacs-nerd-icons
  :config
  (treemacs-load-theme "nerd-icons"))

(use-package nerd-icons-dired
    :hook
      (dired-mode . nerd-icons-dired-mode))

(use-package indent-bars
  :config
  (require 'indent-bars-ts)
  :custom
  (indent-bars-treesit-support t)
  (indent-bars-spacing-override 2)
  ;; (indent-bars-treesit-wrap '())
  (indent-bars-color-by-depth '(:regexp "outline-\\([0-9]+\\)" :blend 0.4))
  (indent-bars-no-stipple-char (string-to-char "┋"))
  (indent-bars-prefer-character 't) ;; so it works also in terminal
)

(use-package diredfl
  :config (diredfl-global-mode))

(use-package treemacs
  :after solaire-mode
  :custom
  (treemacs-show-cursor nil)
  (treemacs-display-current-project-exclusively t)
  (treemacs-project-followlinto-home nil)
  (treemacs-display-current-project-exclusively t)
  (treemacs-git-mode 'deferred)
  :bind (("C-c w t" . treemacs-select-window)
	 ("C-c o T" . treemacs))
  )

(use-package meow
  :hook (server-after-make-frame . (lambda () (meow--prepare-face)))
  :custom
  (meow-use-clipboard 't)
  :config
  (add-hook 'after-make-frame-functions (defun ccr/meow--prepare-face (_)
					  (meow--prepare-face)
					  (remove-hook 'after-make-frame-functions 'ccr/meow--prepare-face)))
  (add-to-list 'meow-mode-state-list '(eshell-mode . insert))
  (add-to-list 'meow-mode-state-list '(eat-mode . insert))
  (add-to-list 'meow-mode-state-list '(notmuch-hello-mode . insert))
  (add-to-list 'meow-mode-state-list '(notmuch-search-mode . insert))
  :init
  (meow-global-mode 1)
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; SPC j/k will run the original command in MOTION state.
   '("j" . "H-j")
   '("k" . "H-k")
   ;; Use SPC (0-9) for digit arguments.
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '(">" . indent-rigidly-right)
   '("<" . indent-rigidly-left)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("/" . meow-visit)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("Y" . meow-sync-grab)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore)))


(use-package windmove
  :config
  (windmove-mode +1)
  (defcustom ccr/v-resize-amount 4
    "How smany rows move when calling `ccr/v-resize`"
    :type 'integer
    :group 'ccr)
  (defcustom ccr/h-resize-amount 4
    "How many columns move when calling `ccr/h-resize`"
    :type 'integer
    :group 'ccr
    )
  (defun ccr/v-resize (key)
    "Interactively vertically resize the window"
    (interactive "cHit >/< to enlarge/shrink")
    (cond ((eq key (string-to-char ">"))
	   (enlarge-window-horizontally ccr/v-resize-amount)
	   (call-interactively 'ccr/v-resize))
	  ((eq key (string-to-char "<"))
	   (enlarge-window-horizontally (- ccr/v-resize-amount))
	   (call-interactively 'ccr/v-resize))
	  (t (push key unread-command-events))))
  (defun ccr/h-resize (key)
    "Interactively horizontally resize the window"
    (interactive "cHit >/< to enlarge/shrink")
    (cond ((eq key (string-to-char ">"))
	   (enlarge-window ccr/h-resize-amount)
	   (call-interactively 'ccr/h-resize))
	  ((eq key (string-to-char "<"))
	   (enlarge-window (- ccr/h-resize-amount))
	   (call-interactively 'ccr/h-resize))
	  (t (push key unread-command-events))))
  :bind (("C-c w k" . windmove-up)
	   ("C-c w l" . windmove-right)
	   ("C-c w j" . windmove-down)
	   ("C-c w h" . windmove-left)
	   ("M-k" . windmove-up)
	   ("M-l" . windmove-right)
	   ("M-j" . windmove-down)
	   ("M-h" . windmove-left)
	   ("C-c w <up>" . windmove-up)
	   ("C-c w <right>" . windmove-right)
	   ("C-c w <down>" . windmove-down)
	   ("C-c w <left>" . windmove-left)
	   ("C-c w q" . delete-window)
	   ("C-c w K" . windmove-delete-up)
	   ("C-c w L" . windmove-delete-right)
	   ("C-c w J" . windmove-delete-down)
	   ("C-c w H" . windmove-delete-left)
	   ("C-c w x" . kill-buffer-and-window)
	   ("C-c w v" . split-window-right)
	   ("C-c w s" . split-window-below)
	   ("C-c w V" . ccr/v-resize)
	   ("C-c w S" . ccr/h-resize)))

(use-package vertico
  :custom
  (vertico-mouse-mode t)
  ;; (vertico-reverse-mode t) ;; FIXME breaks vertico-posframe
  (vertico-count 16)
  (vertico-resize t)
  (vertico-cycle t)
  (vertico-mode t)
  :bind (:map vertico-map
    (("DEL" . vertico-directory-delete-char)
     ("C-DEL" . vertico-directory-delete-word))))

;; (use-package vertico-posframe
;;   :after vertico
;;   :config
;;   (vertico-posframe-mode +1)
;;   :custom
;;   (vertico-multiform-commands
;;    '((t
;;       posframe
;;       (vertico-posframe-poshandler . posframe-poshandler-frame-center)
;;       (vertico-posframe-fallback-mode . vertico-buffer-mode))))
;;   (vertico-posframe-min-height 1)
;;   ;; (vertico-posframe-min-width 80)
;;   (vertico-posframe-parameters '((alpha-background . 80)))
;; )

(use-package marginalia
  :init
  (marginalia-mode +1)
  :custom
  (marginalia-aligh 'right))

(use-package consult
  :bind (([remap switch-to-buffer] . consult-buffer)
         ([remap goto-line] . consult-goto-line)
         ([remazp imenu] . consult-imenu)
         ([remap project-switch-to-buffer] . consult-project-buffer)
          ("C-c b b" . consult-project-buffer)
           ("C-c b B" . consult-buffer)
           ("C-c g l" . consult-goto-line)
           ("C-c b i" . consult-imenu)
           ("C-c f f" . consult-find)
           ("C-c F" . consult-ripgrep)
           ("C-c f" . consult-find)
           ("C-c l" . consult-line)
           ("C-c m" . wconsult-mark)
           ("C-c o o" . consult-outline)
           ("C-c e" . consult-flymake))
  :custom
  (xref-show-xrefs-function #'consult-xref)
  (xref-show-definitions-function #'consult-xref))

(use-package orderless
  :custom
  (completion-styles '(orderless)))

(use-package embark
  :bind (("C-'" . embark-act)
         ("C-=" . embark-dwim)))

(use-package corfu
  :config
  (corfu-terminal-mode)
  (corfu-popupinfo-mode)
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)
  :custom
  (completion-cycle-threshold nil)
  (tab-always-indent 'complete)
  (kind-icon-default-face 'corfu-default)
  :bind (:map corfu-map
    (("M-d" . corfu-doc-toggle)
    ("M-l" . corfu-show-location)
    ("SPC" . corfu-insert-separator)))
  :init
  (global-corfu-mode))

(use-package cape
  :config
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

(use-package prog-mode
  :hook ((prog-mode . hl-line-mode)
	 (prog-mode . display-line-numbers-mode)))

(use-package which-key :delight :config
  (which-key-mode)
  (which-key-setup-side-window-right))

(use-package magit
  :bind (("C-c o g" . magit)))

(use-package magit-delta
  :hook (magit-mode . magit-delta-mode))

;; FIXME
;; (use-package magit-todos
;;   :after magit
;;   :custom (magit-todos-keyword-suffix "\\(?:([^)]+)\\)?:?")
;;   :config (magit-todos-mode 1))

(use-package difftastic
  :demand t
  :bind (:map magit-blame-read-only-mode-map
              ("D" . difftastic-magit-show)
              ("S" . difftastic-magit-show))
  :config
  (eval-after-load 'magit-diff
    '(transient-append-suffix 'magit-diff '(-1 -1)
       [("D" "Difftastic diff (dwim)" difftastic-magit-diff)
        ("S" "Difftastic show" difftastic-magit-show)])))

;; FIXME there is something deeply wrong about how nix is configured here
;; (use-package nix-mode
;;   :delight nix-prettify-mode
;;   :config
;;   (global-nix-prettify-mode))

(use-package agenix
  :after envrc
  :hook (agenix-pre-mode . envrc-mode))

(use-package nix-ts-mode
  :hook (
	 (nix-ts-mode . (lambda ()
			  (require 'eglot)
			  (add-to-list 'eglot-server-programs
				       '(nix-ts-mode . ("nixd")))
			  (eglot-ensure)))
	 (nix-ts-mode . electric-pair-mode)
	 (nix-ts-mode . (lambda () (setq-local indent-bars-spacing-override 2) (indent-bars-mode)))
	 (nix-ts-mode . (lambda ()
			  (setq-local
			   treesit-font-lock-settings
			   (append treesit-font-lock-settings
				   (treesit-font-lock-rules
				    :language 'nix
				    :feature 'function
				    :override t
				    `((formal) @font-lock-type-face)
										   
				    :language 'nix
				    :feature 'function
				    `((attrpath) @font-lock-function-name-face)
				    )))))
	 )
  :mode "\\.nix\\'"
  )

(use-package dockerfile-ts-mode
  :mode "Dockerfile\\'")

(use-package python-ts-mode
  :hook ((python-ts-mode . (lambda ()
			     (require 'eglot)
			     (add-to-list 'eglot-server-programs
					  '(python-ts-mode . ("jedi-language-server")))
			     (eglot-ensure))))
  :mode "\\.py\\'")

(use-package typescript-ts-mode
  :hook ((typescript-ts-mode . (lambda ()
			  (require 'eglot)
			  (eglot-ensure))))
  :mode "\\.ts\\'")

(use-package haskell-ts-mode
  :hook ((haskell--ts-mode . eglot-ensure))
  :mode "\\.hs\\'"
  :config
  (add-to-list 'eglot-server-programs
	       '(haskell-ts-mode . ("haskell-language-server-wrapper" "--lsp"))))

(use-package purescript-mode
  :custom ((project-vc-extra-root-markers '("spago.dhall")))
  :hook ((purescript-mode . eglot-ensure)
	 (purescript-mode . turn-on-purescript-indentation)
	 (purescript-mode . (lambda () (setq project-vc-extra-root-markers '("spago.dhall"))))))

(use-package terraform-mode
  :after eglot
  :config
  (add-to-list 'eglot-server-programs
	       '(terraform-mode . ("terraform-lsp")))
  :hook ((terraform-mode . eglot-ensure)
	 ;; (terraform-mode . tree-sitter-hl-mode)
	 (terraform-mode . (lambda () (setq indent-bars-spacing-override 2) (indent-bars-mode)))
	 ))

(use-package yaml-mode
  :hook (yaml-mode . tree-sitter-hl-mode))

(use-package sh-mode
  :hook (sh-mode . tree-sitter-hl-mode))

;; FIXME
;; (use-package mmm-mode
;;   :config
;;   (mmm-add-group 'nix-sh
;; 		 '((sh-command
;; 		    :submode sh-mode
;; 		    :face mmm-output-submode-face
;; 		    :front "[^'a-zA-Z]''[^']"
;; 		    :back "''[^$\\']"
;; 		    :include-front t
;; 		    :front-offset 4
;; 		    :end-not-begin t)))
;;   (mmm-add-mode-ext-class 'nix-mode "\\.nix\\'" 'nix-sh))

(use-package paredit
  :delight
  :hook ((lisp-mode . enable-paredit-mode)
	 (emacs-lisp-mode . enable-paredit-mode)))

(use-package eldoc
  :delight)

(use-package eldoc-box
  :after eglot
  :custom
  (eldoc-box-only-multiline nil)
  (eldoc-box-lighter "ElBox")
  :bind (("C-c h" . eldoc-box-help-at-point)))

  (use-package diff-hl
    :init
    (global-diff-hl-mode 1)
    (diff-hl-margin-mode 1))

(use-package envrc
  :config
  (envrc-global-mode +1))

(use-package hl-todo
  :init
  (global-hl-todo-mode))

(use-package eat
  :init
  ;; FIXME if we not load eat on startup then adding more non bound keys in :config
  ;; will a cause "nesting exceeds `max-lisp-eval-depth'" on (eat-reload)
  (eat)
  :custom
  (eat-kill-buffer-on-exit t)
  :config
  (add-to-list 'eat-semi-char-non-bound-keys '[?\e 104]) ; M-h
  (add-to-list 'eat-semi-char-non-bound-keys '[?\e 106]) ; M-j
  (add-to-list 'eat-semi-char-non-bound-keys '[?\e 107]) ; M-k
  (add-to-list 'eat-semi-char-non-bound-keys '[?\e 108]) ; M-l
  (eat-update-semi-char-mode-map)
  (eat-reload)
  :hook (eat-mode . (lambda () (setq-local scroll-margin 0)))
  :bind (("C-c o t" . eat-project))
  ;; FIXME doesn't work well
  ;; ((eat-mode . compilation-shell-minor-mode))
  )

(use-package eshell
  :init (require 'eshell) ;; this slows down Emacs startup but it's needed when starting eshell with
  			  ;; emacsclient --eval before opening another eshell buffer directly from inside Emacs
  (eat-eshell-mode)
  (eat-eshell-visual-command-mode)
  :custom ((eshell-prefer-lisp-functions t)
	   (eshell-history-size 10000))
  :config
  (defun ccr/start-eshell () ;; Used from outside Emacs by emacsclient --eval
    (eshell 'N)
    (add-hook 'kill-buffer-hook 'delete-frame nil 't)) ;; destroy frame on exit

  ;; Wrapping this in order to merge histories from different shells
  ;; (advice-add 'eshell-write-history
  ;; 	      :around #'ccr/wrap-eshell-write-history)

  (add-to-list 'eshell-modules-list 'eshell-tramp) ;; to use sudo in eshell
  ;; (add-to-list 'eshell-modules-list 'eshell-smart) ;; plan 9 style

  (setq ccr/eshell-aliases
	'((g  . magit)
	  (gl . magit-log)
	  (d  . dired)
	  (o  . find-file)	
	  (oo . find-file-other-window)
	  (l  . (lambda () (eshell/ls '-la)))
	  (eshell/clear . eshell/clear-scrollback)))
  
  (mapc (lambda (alias)
	  (defalias (car alias) (cdr alias)))
	ccr/eshell-aliases)

  :hook (eshell-mode . (lambda () (setq-local scroll-margin 0)))
  :bind (("C-c o e" . project-eshell)
	 :map eshell-mode-map
	 ("C-r" . eshell-atuin-history))) ;; i.e. just C-r in semi-char-mode

(use-package eshell-command-not-found
  :custom ((eshell-command-not-found-command "command-not-found"))
  :hook ((eshell-mode . eshell-command-not-found-mode)))

(use-package eshell-atuin
  :hook ((eshell-mode . eshell-atuin-mode)))

(use-package fish-completion-mode
  :hook ((eshell-mode . fish-completion-mode)))

(use-package eshell-syntax-highlighting
  :custom
  ((eshell-syntax-highlighting-highlight-in-remote-dirs nil))
  :config
  (eshell-syntax-highlighting-global-mode +1))

(use-package eshell-prompt-extras
  :custom ((eshell-highlight-prompt nil)
	   (eshell-prompt-function 'epe-theme-lambda)))

(use-package popper
  :custom
  (popper-reference-buffers '("\*Messages\*"
			      "Output\*$"
			      "\\*Async Shell Command\\*"
			      (completion-list-mode . hide)
			      help-mode
			      compilation-mode
			      "^\\*Nix-REPL*\\*$" nix-repl-mode ;eshell as a popup
			      "^\\*.+-eshell.*\\*$" eshell-mode ;eshell as a popup
			      "^\\*shell.*\\*$" shell-mode	;shell as a popup
			      "^\\*term.*\\*$" term-mode	;term as a popup
			      "^\\*eat.*\\*$" eat-mode		;eat as a popup
			      ))
  (popper-window-height 0.33)
  (popper-echo-lines 1)
  (popper-mode-line nil)
  :init
  (popper-mode 1)
  (popper-echo-mode 1)
  :bind (("C-c t t" . popper-toggle-latest)
         ("C-c t c" . popper-cycle)
         ("C-c t p" . popper-toggle-type)))

(use-package org
  :hook ((org-mode . variable-pitch-mode)
	 (org-mode . visual-line-mode)
	 (org-mode . visual-fill-column-mode))
  :custom ((org-log-done 'time)
	   (org-return-follows-link t)
	   (org-hide-emphasis-markers t)
	   (visual-fill-column-center-text t)
	   (visual-fill-column-width 100)
	   (fill-column 100)
	   (org-capture-templates '(
				    ("j" "Work Log Entry"
				     entry (file+datetree "~/org/work-log.org")
				     "* %?"
				     :empty-lines 0)
				    ("n" "Note"
				     entry (file+headline "~/org/notes.org" "Random Notes")
				     "** %?"
				     :empty-lines 0)
				    ))
	   (org-auto-align-tags nil)
	   (org-tags-column 0)
	   (org-catch-invisible-edits 'show-and-error)
	   (org-special-ctrl-a/e t)
	   (org-insert-heading-respect-content t)
	   (org-pretty-entities t)
	   (org-ellipsis "…")
	   )
  :bind (("C-c o l" . org-store-link)
	 ("C-c o a" . org-agenda)
	 ("C-c o c" . org-capture)
	 ("C-c b o" . org-switchb))
  :config
  (defun ccr/org-capture (key)
    "Capture a note using the template KEY and close the frame when done.
This is meant to be an helper to be called from the window manager."
    (interactive)
    (org-capture nil key)
    (add-hook 'kill-buffer-hook 'delete-frame nil 't) ;; destroy frame on exit
    (delete-other-windows))

  (dolist (face '(org-block-begin-line 
                  org-block-end-line 
                  org-verbatim
		  org-code
                  ))
    (set-face-attribute face nil :inherit 'fixed-pitch))
  
  (org-babel-do-load-languages
   'org-babel-load-languages '((haskell . t))))

(use-package org-agenda
  :custom
  (org-agenda-files '("~/org"))
  (org-agenda-tags-column 0)
  (org-agenda-block-separator ?─)
  (org-agenda-time-grid
   '((daily today require-timed)
     (800 1000 1200 1400 1600 1800 2000)
     " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄"))
  (org-agenda-current-time-string
   "◀── now ─────────────────────────────────────────────────")
  :bind (("C-c o a" . org-agenda)))

(use-package org-modern
  :after org
  :init
  (global-org-modern-mode)
  ;; FIXME the following doesn't work when using the daemon, it should be executed only
  ;; one time after the first frame is created
  :hook (server-after-make-frame . (lambda ()
  (set-face-font 'variable-pitch "Dejavu Serif-14")
  (set-face-font 'fixed-pitch "Iosevka Comfy-14")
  (set-face-font 'org-table "Iosevka Comfy-14")
  (set-face-font 'org-meta-line "Iosevka Comfy-14")
  (set-face-font 'org-drawer "Iosevka Comfy-14")
  (set-face-font 'org-special-keyword "Iosevka Comfy-14")
  (set-face-font 'org-property-value "Iosevka Comfy-14")
  (set-face-font 'org-block "Iosevka Comfy-14")
  (set-face-font 'org-modern-tag "Iosevka Comfy-14")
  (set-face-font 'org-modern-date-active "Iosevka Comfy-14")
  (set-face-font 'org-modern-date-inactive "Iosevka Comfy-14")))
)

(use-package org-roam
  :custom
  (org-roam-v2-ack t)
  (org-roam-directory (file-truename "~/org"))
  (org-roam-complete-everywhere 't)
  (org-roam-dailies-capture-templates
   '(
     ("d" "Generic entry" entry
      "* %?"
      :target (file+head "%<%Y-%m-%d>.org" "#+title %<%Y-%m-%d>"))
     ("b" "Billable entry" entry
      "* TODO ${Entry} :billable:${Client}:\n:PROPERTIES:\n:SPENT: ${Spent}\n:END:\n%?"
      :target (file+head "%<%Y-%m-%d>.org" "#+title %<%Y-%m-%d>")
      :create-id t))
   )
  :config
  (require 'org-roam-dailies)
  (org-roam-db-autosync-mode)

  ;; In order to automatically add an org id for some capture templates (using the :create-id keyword)
  (defun ccr/org-capture-maybe-create-id ()
    (when (org-capture-get :create-id)
      (org-id-get-create)))
  (add-hook 'org-capture-mode-hook #'ccr/org-capture-maybe-create-id)
  
  ;; The following functions name are relevant because org-roam-ql columns in queries use their suffix
  (defun org-roam-node-spent (node)
    "Return the hours spent as number"
    (string-to-number (cdr (assoc "SPENT" (org-roam-node-properties node)))))
  (defun org-roam-node-date (node)
    "Return the org datestring when a node was created (obtained from the filename)"
      (format "<%s>" (file-name-sans-extension (file-name-nondirectory (org-roam-node-file node)))))

  (org-roam-ql-defpred
   'date-range
   "Check if node was created in given time range"
   #'org-roam-node-date
   #'(lambda (node-date start-date end-date)
       (let ((node-date (condition-case nil
			    ;; if the entry is not from the journal (i.e. the filename is not something like "2024-10-10.org")
			    ;; then it's always discarded (the epoch time is given to it)
			    (encode-time (org-parse-time-string node-date))
			    (error (encode-time (org-parse-time-string "<1970-01-01>")))))
	     (start-date (encode-time (org-parse-time-string start-date)))
	     (end-date (encode-time (org-parse-time-string end-date))))
	 (and (time-less-p start-date node-date)
	      (time-less-p node-date end-date)))
       ))
  
  (defun ccr/org-roam-spent-hours (client &optional date-start date-end)
    "Return the total spent hours on something (usually a client)"
    (let* ((query-tags `(tags ,client "billable"))
	   (query (if (and date-start date-end)
		      `(and ,query-tags (date-range ,date-start ,date-end))
		    query-tags)))
      (apply #'+(mapcar #'org-roam-node-spent (org-roam-ql-nodes query))))))

(use-package org-roam-ql
  :after org-roam
  :bind ((:map org-roam-mode-map
               ("v" . org-roam-ql-buffer-dispatch)
               :map minibuffer-mode-map
               ("C-c n i" . org-roam-ql-insert-node-title))))

(use-package consult-org-roam
  :delight
  :after org-roam
  :init
  (require 'consult-org-roam)
  ;; Activate the minor mode
  (consult-org-roam-mode 1)
  :custom
  (consutl-org-roam-grep-func #'consult-ripgrep)
  (consult-org-roam-buffer-narrow-key ?r)
  (consult-org-roam-buffer-after-buffers t)
  (setq org-roam-database-connector 'sqlite-builtin)
  :config
  (consult-customize
   consult-org-roam-forward-links
   :preview-key (kbd "M-."))
  :bind
  ("C-c n f" . consult-org-roam-file-find)
  ("C-c n b" . consult-org-roam-backlinks)
  ("C-c n l" . consult-org-roam-forward-links)
  ("C-c n s" . consult-org-roam-search))

(use-package org-roam-ui
  :straight
    :after org-roam
    :hook (after-init . org-roam-ui-mode) ;; don't care about startup time since I'm using Emacs daemonized
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

(use-package gptel
  :custom
  (gptel-api-key (lambda () (require 'f) (f-read-text (getenv "OPENAI_API_KEY_PATH"))))
  (gptel-model "gpt-4o")
  :config
  (require 'gptel-curl)

  (add-hook 'gptel-post-response-functions 'gptel-end-of-response)
  (add-hook 'gptel-post-stream-hook 'gptel-auto-scroll)

  (defun ccr/suggest-eshell-command ()
    (interactive)
    (save-excursion
      (eshell-bol)
      (let ((start-pos (point))
	    (end-pos (line-end-position)))
	(gptel-request
	    (buffer-substring-no-properties start-pos end-pos) ;the prompt
	  :system "You are proficient with emacs shell (eshell), translate the following to something I could directly prompt to the shell. Your responses should only be code, without explanation or formatting."
	  :buffer (current-buffer)
	  :context (cons (set-marker (make-marker) start-pos)
			 (set-marker (make-marker) end-pos))
	  :callback
	  (lambda (response info)
	    (if (not response)
		(message "ChatGPT response failed with: %s" (plist-get info :status))
	      (kill-region start-pos end-pos)
	      (insert response)))))))

  (add-to-list 'display-buffer-alist
               '("^\\*ChatGPT\\*"
		 (display-buffer-full-frame)
		 (name . "floating")))

  (defun ccr/start-chatgpt () ;; Used from outside Emacs by emacsclient --eval
    (display-buffer (gptel "*ChatGPT*"))
    (set-frame-name "floating")
    ;; (delete-other-windows)
    ;; (add-hook 'kill-buffer-hook 'delete-frame nil 't)
    ) ;; destroy frame on exit
  )

(use-package pass
  :config
  (require 'password-store-otp) ;; FIXME use `use-pacakge' idiomatic way
  
  :bind (("C-c p p" . password-store-copy)
	 ("C-c p o" . password-store-otp-token-copy)
	 ("C-c p e" . password-store-edit)
	 ("C-c p i" . password-store-insert)))

(use-package with-editor
  :init (shell-command-with-editor-mode +1))

(use-package go-translate
  :custom
  (gts-translate-list '(("it" "en") ("en" "it")))
  (gts-default-translator
   (gts-translator
    :picker (gts-prompt-picker)
    :engines `(,(gts-bing-engine)
               ,(gts-google-engine :parser (gts-google-summary-parser)))
    :render (gts-buffer-render)))
  (gts-buffer-follow-p 't)
  :bind (("C-c T t" . gts-do-translate)))

(use-package message
  :custom
  (message-send-mail-function 'smtpmail-send-it)
  (send-mail-function 'smtpmail-send-it)
  (user-mail-address "andrea.ciceri@autistici.org")
  (smtpmail-smtp-server "mail.autistici.org")
  (smtpmail-stream-type 'ssl)
  (smtpmail-smtp-service 465)
  ;; also the following line is needeed in ~/.authinfo.gpg
  ;; machine mail.autistici.org login andrea.ciceri@autistici.org password <password>
  )

(use-package notmuch
  :custom
  (notmuch-show-logo nil)
  (send-mail-function 'sendmail-send-it)
  (notmuch-archive-tags '("-new"))
  (notmuch-saved-searches
   '((:name "Inbox" :query "tag:new" :key "i")
     (:name "Sent" :query "tag:sent" :key "s")
     (:name "Draft" :query "tag:draft" :key "s")
     (:name "GitHub" :query "tag:github" :key "g")
     (:name "Trash" :query "tag:trash" :key "t"))))

(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("5bafdfa3e21f921abf9b9fd77e1e0ce032e62e3a6f8f13ec8ce7945727c654e9"
     "5f92b9fc442528b6f106eaefa18bb5e7bfa0d737164e18f1214410fef2a6678d"
     "b7f70bd00f79099f11d67a25c592d70593377488a263bb3dd73dee99b0549dba"
     "7d10494665024176a90895ff7836a8e810d9549a9872c17db8871900add93d5c"
     "b5c3c59e2fff6877030996eadaa085a5645cc7597f8876e982eadc923f597aca" default))
 '(magit-todos-insert-after '(bottom) nil nil "Changed by setter of obsolete option `magit-todos-insert-at'")
 '(org-fold-catch-invisible-edits 'show-and-error nil nil "Customized with use-package org")
 '(safe-local-variable-values
   '((eval progn (require 'org-re-reveal)
	   (add-hook 'after-save-hook #'org-re-reveal-export-to-html nil t))
     (copilot-mode 0) (copilot-mode -1))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; Local Variables:
;; byte-compile-warnings: (not free-vars noruntime unresolved)
;; End: