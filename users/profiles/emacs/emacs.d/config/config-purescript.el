(use-package psc-ide
  :custom
  (psc-ide-rebuild-on-save t)
  
  :config
  ;; The following is stolen from the Spacemacs purescript layer 
  
  (defun purescript-purs-tidy-format-buffer ()
    "Format buffer with purs-tidy."
    (interactive)
    (if (executable-find "purs-tidy")
	(let*  ((extension (file-name-extension (or buffer-file-name "tmp.purs") t))
		(tmpfile (make-temp-file "~fmt-tmp" nil extension))
		(coding-system-for-read 'utf-8)
		(coding-system-for-write 'utf-8)
		(outputbuf (get-buffer-create "*~fmt-tmp.purs*")))
          (unwind-protect
              (progn
		(with-current-buffer outputbuf (erase-buffer))
		(write-region nil nil tmpfile)
		(if (zerop (apply #'call-process-region nil nil "purs-tidy" nil
                                  `(,outputbuf ,tmpfile) nil
                                  `("format")))
                    (let ((p (point)))
                      (save-excursion
			(with-current-buffer (current-buffer)
                          (replace-buffer-contents outputbuf)))
                      (goto-char p)
                      (message "formatted.")
                      (kill-buffer outputbuf))
                  (message "Formatting failed!")
                  (display-buffer outputbuf)))
            (delete-file tmpfile)))
      (error "purs-tidy not found")))

  :hook
  (purescript-mode . (lambda ()
		       (add-hook 'before-save-hook purescript-purs-tidy-format-buffer nil 'make-it-local)
		       (psc-ide-mode)
		       (company-mode)
		       (flycheck-mode)
		       (turn-on-purescript-indentation)
		       )))

(use-package psci)

(provide 'config-purescript)
