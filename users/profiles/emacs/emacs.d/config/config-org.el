(use-package org
  :init
    (setq fill-column 80)
    (require 'org-protocol)
  :hook 
  ((org-mode . refill-mode)
   (org-mode . (lambda () (org-superstar-mode 1)))
   (org-mode . prettify-symbols-mode)))

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory (file-truename "~/roam/"))
  (org-roam-graph-executable "dot")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

(provide 'config-org)
