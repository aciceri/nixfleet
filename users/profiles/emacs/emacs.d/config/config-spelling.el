(use-package ispell
  :bind
  (("C-c s c" . ispell-complete-word)
   ("C-c s d" . switch-dictionary-it-en))
  :hook
  ((org-mode . flyspell-mode)
   (prog-mode . flyspell-prog-mode)
   )
  :custom
  ((ispell-program-name "hunspell")
   (ispell-dictionary "it_IT"))
  :config
  (defun switch-dictionary-it-en ()
    (interactive)
    (let* ((dict ispell-current-dictionary)
           (new (if (string= dict "it_IT") "en_US"
                  "it_IT")))
      (ispell-change-dictionary new)
      (message "Switched dictionary from %s to %s" dict new))))

(use-package writegood-mode
  :bind
  (("C-c s g" . writegood-grade-level)
   ("C-c s r" . writegood-reading-ease)
   ("C-c s w" . writegood-mode)))
  
  

(provide 'config-spelling)
