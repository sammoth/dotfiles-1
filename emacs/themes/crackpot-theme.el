;;; crackpot-theme.el --- Crackpot for Emacs.
;;; Commentary:
;;; originally from rainglow
;;; Code:

(defun create-crackpot-theme (variant theme-name &optional childtheme)
  (let* (
     (black              "#181726")
     (white              "#d2c9ef")
     (almost-white       "#908cd8")
     (almost-black       "#111111")
     (middle-dark-grey   "#474471")
     (middle-light-grey  "#dad8f2")
     (light-grey         "#e8e9eb")
     (dark-grey          "#222136")

     (red                "#ba0e2e")
     (middle-dark-pink   "#e61f44")
     (middle-light-pink  "#ef6461")
     (light-pink         "#f9bfbe")

     (dark-blue          "#b0a6f9")
     (middle-dark-blue   "#d0c6ff")
     (middle-light-blue  "#d8d4f2")
     (light-blue         "#e0e5ff")

     (dark-green         "#363456")
     (middle-dark-green  "#937f4a")
     (middle-light-green "#e3bf9a")
     (light-green        "#e4b363")

     (dark-tan           "#222136")
     (light-tan          "#e8e9eb")

     (bg          (if (eq variant 'light) white             black))
     (norm        (if (eq variant 'light) almost-black      almost-white))
     (comment     (if (eq variant 'light) middle-light-grey middle-dark-grey))
     (dimmed      (if (eq variant 'light) middle-dark-grey  middle-light-grey))
     (subtle      (if (eq variant 'light) light-grey        dark-grey))
     (faint       (if (eq variant 'light) almost-white      almost-black))
     (accent1     (if (eq variant 'light) middle-dark-blue  middle-light-blue))
     (accent2     (if (eq variant 'light) middle-dark-green middle-light-green))
     (accent3     (if (eq variant 'light) middle-dark-pink  light-green))
     (accent4     (if (eq variant 'light) dark-tan          light-tan))
     (norm-red    (if (eq variant 'light) middle-dark-pink  middle-light-pink))
     (inv-red     (if (eq variant 'light) middle-light-pink middle-dark-pink))
     (norm-green  (if (eq variant 'light) middle-dark-green middle-light-green))
     (norm-blue   (if (eq variant 'light) middle-dark-blue  middle-light-blue))
     (faint-red   (if (eq variant 'light) red               red))
     (faint-green (if (eq variant 'light) light-green       dark-green))
     (faint-blue  (if (eq variant 'light) light-blue        dark-blue))
     (faint-blue-inv  (if (eq variant 'light) dark-blue        light-blue))
     (pink        (if (eq variant 'light) middle-dark-pink  light-pink))
     (extra-white (if (eq variant 'light) dark-grey         light-grey)))

    (custom-theme-set-faces
     theme-name
     '(button ((t (:underline t))))

     `(cursor                       ((t (:background ,accent3 :foreground ,bg))))
     `(default                      ((t (:background ,bg      :foreground ,norm))))
     `(region                       ((t (:background ,norm-red :foreground ,extra-white))))
     `(highlight                    ((t (:background ,comment))))
     `(warning                      ((t (:foreground ,norm-red))))
     `(lazy-highlight               ((t (:background ,faint-green))))
     `(link                         ((t (:foreground "darkslateblue"))))
     `(show-paren-match             ((t (:foreground ,norm-red))))
     `(font-lock-constant-face      ((t (:foreground ,accent1))))
     `(font-lock-comment-face       ((t (:foreground ,comment))))
     `(font-lock-string-face        ((t (:foreground ,faint-blue-inv))))
     `(font-lock-keyword-face       ((t (:foreground ,accent3))))
     `(font-lock-type-face          ((t (:foreground ,accent1))))
     `(font-lock-builtin-face       ((t (:foreground ,accent3))))
     `(font-lock-function-name-face ((t (:foreground ,norm))))
     `(font-lock-variable-name-face ((t (:foreground ,accent2))))
     `(font-lock-preprocessor-face  ((t (:foreground ,accent2))))
     `(eterm-256color-black  ((t (:foreground "#222136" :background "#222136"))))
     `(eterm-256color-red  ((t (:foreground "#ba0e2e" :background "#ba0e2e"))))
     `(eterm-256color-green  ((t (:foreground "#e4b363" :background "#e4b363"))))
     `(eterm-256color-yellow  ((t (:foreground "#ef6461" :background "#ef6461"))))
     `(eterm-256color-blue  ((t (:foreground "#908cd8" :background "#908cd8"))))
     `(eterm-256color-magenta  ((t (:foreground "#e4b363" :background "#e4b363"))))
     `(eterm-256color-cyan  ((t (:foreground "#e8e9eb" :background "#e8e9eb"))))
     `(eterm-256color-white  ((t (:foreground "#e2ddf5" :background "#e2ddf5"))))
     `(eterm-256color-bright-black  ((t (:foreground "#363456" :background "#363456"))))
     `(eterm-256color-bright-red  ((t (:foreground "#e61f44" :background "#e61f44"))))
     `(eterm-256color-bright-green  ((t (:foreground "#f3ddba" :background "#f3ddba"))))
     `(eterm-256color-bright-yellow  ((t (:foreground "#f8bfbe" :background "#f8bfbe"))))
     `(eterm-256color-bright-blue  ((t (:foreground "#dad8f2" :background "#dad8f2"))))
     `(eterm-256color-bright-magenta  ((t (:foreground "#f3ddba" :background "#f3ddba"))))
     `(eterm-256color-bright-cyan  ((t (:foreground "#ffffff" :background "#ffffff"))))
     `(eterm-256color-bright-white  ((t (:foreground "#ffffff" :background "#ffffff"))))

     `(vertical-border              ((nil (:foreground ,subtle))))
     `(header-line                  ((t (:background "#000000"))))
     `(mode-line ((t (:background ,accent1 :foreground ,comment :box nil))))
     `(mode-line-inactive ((t (:background ,bg :foreground ,faint-blue :box nil)))))


    (custom-theme-set-variables
     theme-name
     ;; fill-column-indicator
     `(fci-rule-color ,subtle))

    ;; call chained theme function
    (when childtheme (funcall childtheme))))

;;;###autoload
;(when (and (boundp 'custom-theme-load-path) load-file-name)
;  (add-to-list 'custom-theme-load-path
;               (file-name-as-directory (file-name-directory load-file-name))))

(deftheme crackpot "Crackpot colour theme")
(create-crackpot-theme 'dark 'crackpot)
(provide-theme 'crackpot)

;; Local Variables:
;; no-byte-compile: t
;; End:
(provide 'crackpot-theme)
;;; crackpot-theme.el ends here
