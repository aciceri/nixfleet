(use-package go-translate
  :config
  (defclass gts-insert-render (gts-render) ())

  (cl-defmethod gts-out ((_ gts-insert-render) task)
    (deactivate-mark)
    (insert (oref task result)))

  (setq gts-translate-list '(("it" "en")))
  (setq gts-default-translator
   (gts-translator
    :picker 
    (gts-prompt-picker)
    :engines 
    (gts-google-engine :parser (gts-google-summary-parser))
    :render 
    (gts-insert-render)
    ))
  (defun gts-pop-definition ()
    (interactive)
    (gts-translate (gts-translator
     :picker
     (gts-noprompt-picker :texter (gts-current-or-selection-texter) :single t)
     :engines 
     (gts-google-engine)
     :render 
     (gts-posframe-pop-render)
     )))
    
  :bind
  (("C-c t t" . gts-do-translate)
   ("C-c t p" . gts-pop-definition)))

(provide 'config-translate)
