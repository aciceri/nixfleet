;;; os/exwm/config.el -*- lexical-binding: t; -*-

;; Define custom variables for the `exwm-update-class-hook' for users to
;; configure which buffers names should NOT be modified.
(defvar exwm/ignore-wm-prefix "sun-awt-X11-"
  "Don't rename exwm buffers with this prefix.")
(defvar exwm/ignore-wm-name "gimp"
  "Don't rename exwm buffers with this name.")

;; Make sure `exwm' windows can be restored when switching workspaces.
(defun exwm--update-utf8-title-advice (oldfun id &optional force)
  "Only update the window title when the buffer is visible."
  (when (get-buffer-window (exwm--id->buffer id))
    (funcall oldfun id force)))

;; Confgure `exwm' the X window manager for emacs.
(use-package! exwm
  :config
  (setq exwm-workspace-number 10)
  ;(mapcar (lambda (i) (exwm-workspace-switch-create i) (number-sequence 0 9)))
  ;(exwm-workspace-switch-create 1)

  ;; Configure global key bindings.
  (setq exwm-input-global-keys
        `(([?\s-r] . exwm-reset)
          ([?\s-w] . exwm-workspace-switch)
          ([?\s-q] . kill-this-buffer)
          ([?\s-f] . exwm-layout-toggle-fullscreen)
          ([?\s-c] . exwm-input-toggle-keyboard)
          ([?\s-s] . (lambda () (interactive) (start-process-shell-command "screenshot" nil "maim -s -u | xclip -selection clipboard -t image/png -i")))
          ([?\s-d] . (lambda (command)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command command nil command)))
          ,@(mapcar (lambda (i)
                     `(,(kbd (format "C-s-%d" i)) .
                       (lambda ()
                         (interactive)
                         (exwm-workspace-move-window ,i))))
                   (number-sequence 0 9))
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))

  (setq exwm-layout-show-all-buffers t)
  (setq exwm-workspace-show-all-buffers t)

  ;; Configure the default buffer behaviour. All buffers created in `exwm-mode'
  ;; are named "*EXWM*". Change it in `exwm-update-class-hook' and `exwm-update-title-hook'
  ;; which are run when a new X window class name or title is available.
  (add-hook 'exwm-update-class-hook
            (lambda ()
              (unless (or (string-prefix-p exwm/ignore-wm-prefix exwm-instance-name)
                          (string= exwm/ignore-wm-name exwm-instance-name))
                (exwm-workspace-rename-buffer exwm-class-name))))
  (add-hook 'exwm-update-title-hook
            (lambda ()
              (when (or (not exwm-instance-name)
                        (string-prefix-p exwm/ignore-wm-prefix exwm-instance-name)
                        (string= exwm/ignore-wm-name exwm-instance-name))
                (exwm-workspace-rename-buffer exwm-title))))

  ;; Show `exwm' buffers in buffer switching prompts.
  (add-hook 'exwm-mode-hook #'doom-mark-buffer-as-real-h)

  ;; Restore window configurations involving exwm buffers by only changing names
  ;; of visible buffers.
  (advice-add #'exwm--update-utf8-title :around #'exwm--update-utf8-title-advice)

  (defun exwm-rename-buffer ()
    (interactive)
    (exwm-workspace-rename-buffer
     (concat exwm-class-name " :: "
             (if (<= (length exwm-title) 50) exwm-title
               (concat (substring exwm-title 0 49) "...")))))

  ;; Add these hooks in a suitable place (e.g., as done in exwm-config-default)
  (add-hook 'exwm-update-class-hook 'exwm-rename-buffer)
  (add-hook 'exwm-update-title-hook 'exwm-rename-buffer)

  (require 'exwm-systemtray)
  (exwm-systemtray-enable))

;; Use the `ido' configuration for a few configuration fixes that alter
;; 'C-x b' workplace switching behaviour. This also effects the functionality
;; of 'SPC .' file searching in doom regardless of the users `ido' configuration.
(use-package! exwm-config
  :after exwm
  :config
  (exwm-config--fix/ido-buffer-window-other-frame))

;; Configure `exwm-randr' to support multi-monitor setups as well as
;; hot-plugging HDMI outputs. Read more at:
;; https://github.com/ch11ng/exwm/wiki#randr-multi-screen
(use-package! exwm-randr
  :after exwm
  :config
  (setq exwm-randr-workspace-monitor-plist '(1 "DP-2" 2 "eDP-1"))
  (setq exwm-workspace-warp-cursor t)
  (setq mouse-autoselect-window t
        focus-follows-mouse t)
  ;; (add-hook 'exwm-randr-screen-change-hook
  ;;           (lambda ()
  ;;             (let ((xrandr-output-regexp "\n\\([^ ]+\\) connected ")
  ;;                   default-output)
  ;;               (with-temp-buffer
  ;;                 (call-process "xrandr" nil t nil)
  ;;                 (goto-char (point-min))
  ;;                 (re-search-forward xrandr-output-regexp nil 'noerror)
  ;;                 (setq default-output (match-string 1))
  ;;                 (forward-line)
  ;;                 (if (not (re-search-forward xrandr-output-regexp nil 'noerror))
  ;;                     (call-process
  ;;                      "xrandr" nil nil nil
  ;;                      "--output" default-output
  ;;                      "--auto")
  ;;                   (call-process
  ;;                    "xrandr" nil nil nil
  ;;                    "--output" (match-string 1) "--primary" "--auto"
  ;;                    "--output" default-output "--off"
  ;;       	     )
  ;;                   (setq exwm-randr-workspace-monitor-plist
  ;;                         (list 0 (match-string 1))))))))
  (exwm-randr-enable))

;; Configure the rudamentary status bar.
(when (featurep! +status)
  (setq display-time-default-load-average nil)
  (display-time-mode +1)
  (display-battery-mode +1))

;; Configure `exwm-firefox-*'.
(when (featurep! +firefox)
  (use-package! exwm-firefox-core
    :after exwm
    :config
    ;; Add the <ESC> key to the exwm input keys for firefox buffers.
    (dolist (k `(escape))
      (cl-pushnew k exwm-input-prefix-keys)))

  ;; Configure further depending if the user has evil mode enabled.
  (when (featurep! :editor evil)
    (use-package! exwm-firefox-evil
      :after exwm
      :config
      ;; Add the firefox wm class name.
      (dolist (k `("firefox"))
        (cl-pushnew k exwm-firefox-evil-firefox-class-name))
      ;; Add the firefox buffer hook
      (add-hook 'exwm-manage-finish-hook
                'exwm-firefox-evil-activate-if-firefox))))
