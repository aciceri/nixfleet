;; -*- no-byte-compile: t; -*-
;;; os/exwm/packages.el

;; Here we require the `exwm' package.
(package! exwm :pin "e43bd78...")

;; Here we require the `exwm-firefox*' packages.
(when (featurep! +firefox)
  (if (featurep! :editor evil)
      (package! exwm-firefox-evil :pin "14643ee...")
    (package! exwm-firefox-core :pin "e2fe2a8ODO...")))
