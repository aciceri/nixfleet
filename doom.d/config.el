;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Andrea Ciceri"
      user-mail-address "andrea.ciceri@autistici.org")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light))
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 't)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setenv "SSH_AUTH_SOCK" "/run/user/1000/gnupg/S.gpg-agent.ssh")

(set-formatter! 'nix-smart-formatter "nixFormat ." :modes '(nix-mode))

(defun doom-modeline-set-vcs-modeline () nil) ; FIXME

(setq +format-on-save-enabled-modes
      '(not latex-mode))

(setq org-roam-directory (file-truename "~/roam"))
(org-roam-db-autosync-mode)

(setq doom-font (font-spec :family "Fira Code" :size 16)
      doom-variable-pitch-font (font-spec :family "Fira Code")
      doom-big-font-increment 1)

(after! vterm
  (dotimes (workspace-number 10)
    (define-key vterm-mode-map (kbd (format "M-%d" workspace-number)) nil)))

(after! polymode (progn
                   (define-hostmode poly-nix-hostmode :mode 'nix-mode)

                   (define-innermode poly-sh-innermode
                     :mode 'sh-mode
                     :head-matcher "^.*[+=].*''"
                     :tail-matcher "''.*[+;].*$"
                     :head-mode 'host
                     :tail-mode 'host)

                   (define-polymode poly-nix-mode
                     :hostmode 'poly-nix-hostmode
                     :innermodes '(poly-sh-innermode))
                   ))

(after! org
  (setq-default prettify-symbols-alist
                '(("[ ]" "☐")
                  ("[X]" "☑")
                  ("[-]" "❍")
                  ("#+begin_src" "λ")
                  ("#+end_src" "λ"))))
