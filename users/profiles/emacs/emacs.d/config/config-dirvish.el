(use-package dired
  ;; Dirvish respects all the keybindings in `dired-mode-map'
  :bind
  (nil
   :map dired-mode-map
   ("h" . dired-up-directory)
   ("j" . dired-next-line)
   ("k" . dired-previous-line)
   ("l" . dired-find-file)
   ("i" . wdired-change-to-wdired-mode)
   ("." . dired-omit-mode))
  :config
  (setq dired-recursive-deletes 'always)
  (setq delete-by-moving-to-trash t)
  (setq dired-dwim-target t)
  ;; Make sure to use the long name of flags when exists
  ;; eg. use "--almost-all" instead of "-A"
  ;; Otherwise some commands won't work properly
  (setq dired-listing-switches
        "-l --almost-all --human-readable --time-style=long-iso --group-directories-first --no-group"))

(use-package dired-x
  ;; Enable dired-omit-mode by default
  ;; :hook
  ;; (dired-mode . dired-omit-mode)
  :config
  ;; Make dired-omit-mode hide all "dotfiles"
  (setq dired-omit-files
        (concat dired-omit-files "\\|^\\..*$")))

(use-package dirvish
  :custom
  ;; Go back home? Just press `bh'
  (dirvish-menu-bookmarks
   '(("h" "~/"                          "Home")
     ("d" "~/Downloads/"                "Downloads")
     ("m" "/mnt/"                       "Drives")
     ("t" "~/.local/share/Trash/files/" "TrashCan")))
  ;; (dirvish-header-line-format '(:left (path) :right (free-space)))
  (dirvish-mode-line-format
   '(:left
     (sort file-time " " file-size symlink) ; it's ok to place string inside
     :right
     ;; For `dired-filter' users, replace `omit' with `filter' segment defined below
     (omit yank index)))
  (dirvish-attributes '(subtree-state
                        ;; file-size
                        ;; Feel free to replace `all-the-icons' with `vscode-icon'.
                        all-the-icons))
  ;; Maybe the icons are too big to your eyes
  ;; (dirvish-all-the-icons-height 0.8)
  ;; In case you want the details at startup like `dired'
  ;; (dirvish-hide-details nil)
  :config
  ;; Place this line under :init to ensure the overriding at startup, see #22
  (dirvish-override-dired-mode)
  (dirvish-peek-mode)
  ;; Define mode line segment for `dired-filter'
  ;; (dirvish-define-mode-line filter "Describe filters."
  ;;   (when (bound-and-true-p dired-filter-mode)
  ;;     (propertize (format " %s " (dired-filter--describe-filters))
  ;;                 'face 'dired-filter-group-header)))
  :bind
  ;; Bind `dirvish|dirvish-dired|dirvish-side|dirvish-dwim' as you see fit
  (("C-c f" . dirvish-fd)
   :map dired-mode-map
   ("TAB" . dirvish-toggle-subtree)
   ("SPC" . dirvish-show-history)
   ("*"   . dirvish-mark-menu)
   ("r"   . dirvish-roam)
   ("b"   . dirvish-goto-bookmark)
   ("f"   . dirvish-file-info-menu)
   ("M-n" . dirvish-go-forward-history)
   ("M-p" . dirvish-go-backward-history)
   ("M-s" . dirvish-setup-menu)
   ("M-f" . dirvish-toggle-fullscreen)
   ([remap dired-sort-toggle-or-edit] . dirvish-quicksort)
   ([remap dired-do-redisplay] . dirvish-ls-switches-menu)
   ([remap dired-summary] . dirvish-dispatch)
   ([remap dired-do-copy] . dirvish-yank-menu)
   ([remap mode-line-other-buffer] . dirvish-other-buffer)))

;; Addtional syntax highlighting for dired
(use-package diredfl
  :hook
  (dired-mode . diredfl-mode))

;; Use `all-the-icons' as Dirvish's icon backend
(use-package all-the-icons
  :if (display-graphic-p))

;; Or, use `vscode-icon' instead
;; (use-package vscode-icon
;;   :config
;;   (push '("jpg" . "image") vscode-icon-file-alist))

;; `ibuffer' like file filtering system
(use-package dired-filter
  :after dirvish
  :config
  :custom
  ;; Do not touch the header line
  (dired-filter-show-filters nil)
  (dired-filter-revert 'always)
  :bind
  (:map dired-mode-map
        ([remap dired-omit-mode] . dired-filter-mode)))

(use-package dired-collapse
  :bind
  (:map dired-mode-map
        ("M-c" . dired-collapse-mode)))

;; We already have `dirvish-toggle-subtree'
;; But you can still use this package if you want those fancy features
;; (use-package dired-subtree
;;   :config
;;   (setq dired-subtree-use-backgrounds nil)
;;   :bind
;;   (:map dired-mode-map
;;         ("TAB" . dired-subtree-toggle)))

(provide 'config-dirvish)
