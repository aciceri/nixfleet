(use-package org
  :init
    (setq fill-column 80)
    (require 'org-protocol)
  :custom
  (org-startup-folded 'fold)
  :hook 
  ((org-mode . auto-fill-mode) ;refill-mode breaks org headings 
   (org-mode . (lambda () (org-superstar-mode 1)))
   (org-mode . prettify-symbols-mode)))

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
  (org-roam-capture-templates
   '(
 ("i" "incremental" plain
         #'org-roam-capture--get-point
         "${body}\n%?" ;; this reads from
        ; "%i%?"
         :empty-lines-before 1
         :file-name "web/${slug}"
         :head "#+title: ${title}\n#+roam_key ${ref}\n#+CREATED: %U\n#+LAST_MODIFIED: %U\n\n"
         :unnarrowed t)
     ("r" "roam-ref" plain #'org-roam-capture--get-point "%i%?" :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}"))))  

  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (org-roam-db-autosync-mode)
  (require 'org-roam-protocol)

  
(provide 'config-org)
