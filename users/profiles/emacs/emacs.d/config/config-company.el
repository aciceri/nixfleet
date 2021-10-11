(use-package company
  :init
  (setq company-backends '(company-capf
                           company-keywords
                           company-semantic
                           company-files
                           company-etags
                           company-elisp
                           company-jedi
                           company-ispell
                           company-yasnippet)
	company-tooltip-limit 20
	company-show-numbers t
	company-idle-delay 0
	company-echo-delay 0)
  :bind
  (("C-c ." . company-complete)
   ("C-c C-." . company-complete)
   ("C-c s s" . company-yasnippet)
   :map company-active-map
   ("C-n" . company-select-next)
   ("C-p" . company-select-previous)
   ("C-d" . company-show-doc-buffer)
   ("M-." . company-show-location)))

(use-package helm-company
  :after (helm company)
  :bind (("C-c C-;" . helm-company))
  :commands (helm-company)
  :init
  (define-key company-mode-map (kbd "C-;") 'helm-company)
  (define-key company-active-map (kbd "C-;") 'helm-company))


(provide 'config-company)
