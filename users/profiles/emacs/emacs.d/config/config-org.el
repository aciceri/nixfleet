(use-package org
  :init
    (setq fill-column 80)
    (require 'org-protocol)
  :custom
  (org-startup-folded 'fold)
  (org-startup-indented f)
  (org-agenda-files '("~/roam/" "~/orgzly~"))
  (org-ellipsis "⤵")
  (org-pretty-entities t)
  (org-hide-emphasis-markers t)
  (org-agenda-block-separator "")
  (org-fontify-whole-heading-line t)
  (org-fontify-done-headline t)
  (org-fontify-quote-and-verse-blocks t)
  (prettify-symbols-alist '(("#+BEGIN_SRC" . "λ")
                            ("#+END_SRC" . "λ")
                            ("#+begin_src" . "λ")
                            ("#+end_src" . "λ")))
  (org-babel-python-command "python3")
  (org-src-preserve-indentation t)
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)))
  :hook 
  ((org-mode . auto-fill-mode) ;refill-mode breaks org headings 
   ;; (org-mode . org-num-mode)
   ;; (org-mode . (lambda ()
   ;; 		 (dolist (face '((org-level-1 1.5)
   ;; 				 (org-level-2 1.4)
   ;; 				 (org-level-3 1.3)
   ;; 				 (org-level-4 1.2)
   ;; 				 (org-level-5 1.1)))
   ;;		   (set-face-attribute (car face) nil :weight 'semi-bold :height (cadr face)))))
   (org-mode . prettify-symbols-mode)))

(use-package org-fragtog
  :custom
  (org-format-latex-options (plist-put org-format-latex-options :scale 1.6))
  :hook
  ((org-mode . org-fragtog-mode)))

(use-package org-download
  :hook
  ((org-mode . (lambda () (setq-local org-download-image-dir "~/roam/images/")))))

(use-package org-superstar
  :custom
  (org-superstar-special-todo-items t)
  (org-superstar-headline-bullets-list '("\u200b"))
  :hook
  (('org-mode . (lambda () (org-superstar-mode 1)))))

(use-package org-download
  :hook
  ((org-mode . (lambda () (setq-local org-download-image-dir "~/roam/images/")))))

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory (file-truename "~/roam/"))
  (org-roam-graph-executable "dot")
  (org-roam-db-location (file-truename "roam/org-roam.db"))
  (org-roam-node-display-template "${title:72} ${tags:10} ${backlinkscount:6}")
  (org-roam-capture-templates
   '(("d" "default" plain "\n%?" :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}") :unnarrowed t)))
  :hook
  ((org-roam-mode . (lambda () (org-hide-properties))))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n I" . org-roam-node-insert-immediate)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (defun org-roam-node-insert-immediate (arg &rest args)
    (interactive "P")
    (let ((args (cons arg args))
          (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                    '(:immediate-finish t)))))
      (apply #'org-roam-node-insert args)))

  (defun org-hide-properties ()
    "Hide all org-mode headline property drawers in buffer. Could be slow if it has a lot of overlays."
    (interactive)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward
              "^ *:properties:\n\\( *:.+?:.*\n\\)+ *:end:\n" nil t)
	(let ((ov_this (make-overlay (match-beginning 0) (match-end 0))))
          (overlay-put ov_this 'display "")
          (overlay-put ov_this 'hidden-prop-drawer t))))
    (put 'org-toggle-properties-hide-state 'state 'hidden))
  
  (defun org-show-properties ()
    "Show all org-mode property drawers hidden by org-hide-properties."
    (interactive)
    (remove-overlays (point-min) (point-max) 'hidden-prop-drawer t)
    (put 'org-toggle-properties-hide-state 'state 'shown))
  
  (defun org-toggle-properties ()
    "Toggle visibility of property drawers."
    (interactive)
    (if (eq (get 'org-toggle-properties-hide-state 'state) 'hidden)
	(org-show-properties)
      (org-hide-properties)))

  (cl-defmethod org-roam-node-directories ((node org-roam-node))
    (if-let ((dirs (file-name-directory (file-relative-name (org-roam-node-file node) org-roam-directory))))
	(format "(%s)" (car (f-split dirs)))
      ""))
  
  (cl-defmethod org-roam-node-backlinkscount ((node org-roam-node))
    (let* ((count (caar (org-roam-db-query
			 [:select (funcall count source)
                                  :from links
                                  :where (= dest $s1)
                                  :and (= type "id")]
			 (org-roam-node-id node)))))
      (format "[%d]" count)))

  
  (org-roam-db-autosync-mode)
  (require 'org-roam-protocol))

(use-package org-roam-ui
  :after org-roam
  :config (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))
  
(provide 'config-org)
