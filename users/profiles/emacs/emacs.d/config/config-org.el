(use-package org
  :init
  (setq fill-column 80)
  :hook 
  ((org-mode . refill-mode)
   (org-mode . (lambda () (org-superstar-mode 1)))
   (org-mode . prettify-symbols-mode)))


(provide 'config-org)
