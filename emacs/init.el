;;; init.el --- .emacs

;; some settings are in .XResources

;; setup environment
(setq user-init-file (or load-file-name (buffer-file-name)))
(setq custom-file "~/dotfiles/emacs/custom.el")
(load custom-file :noerror)
(add-to-list 'load-path (concat "~/dotfiles/emacs/lisp/"))

(setq package-enable-at-startup nil) (package-initialize)

;; UI settings
(tool-bar-mode -1)
(scroll-bar-mode 1)
(menu-bar-mode 0)
(savehist-mode 1)
(set-default 'truncate-lines nil)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))
(setq inhibit-startup-message t)
;(setq scroll-step 1)
;(setq scroll-conservatively 1000)
;(setq mouse-wheel-follow-mouse t)
;(pixel-scroll-mode)
;(setq pixel-dead-time 0) ; Never go back to the old scrolling behaviour.
;(setq pixel-resolution-fine-flag t) ; Scroll by number of pixels instead of lines (t = frame-char-height pixels).
;(setq fast-but-imprecise-scrolling t)

(setq initial-scratch-message nil)
(setq cursor-type 'bar)
(setq blink-cursor-blinks -1)
(setq echo-keystrokes 0.1)
(blink-cursor-mode 0)
(xterm-mouse-mode 1)
(setq frame-title-format "%b")
(setq-default word-wrap t)
(setq enable-recursive-minibuffers t)
(show-paren-mode 1)
(setq show-paren-delay 0)
(add-hook 'help-mode-hook 'visual-line-mode)
(setq vc-follow-symlinks t)
(setq-default indent-tabs-mode nil)

;; package configuration
(setq minibuffer-depth-indicate-mode t)

;; package configuration
(require 'package)
(push '("melpa" . "http://melpa.org/packages/")
      package-archives)
(package-initialize)


;; install packages
(setq
 package-selected-packages
 '(
   ace-window
   adaptive-wrap
   aio
   async
   auctex
   avy
   cargo
   ccls
   company
   company-lsp
   company-glsl
   company-racer
   counsel
   counsel-projectile
   cyphejor
   dash
   diminish
   elscreen
   eglot
   evil
   evil-leader
   evil-paredit
   evil-smartparens
   evil-surround
   evil-terminal-cursor-changer
   eterm-256color
   exec-path-from-shell
   flx
   flycheck
   glsl-mode
   go-mode
   goto-chg
   ivy
   kurecolor
   let-alist
   lsp-mode
   lsp-haskell
   lua-mode
   magit
   org-autolist
   org-download
   org-present
   pkg-info
   popup
   projectile
   projectile-ripgrep
   racer
   rainbow-mode
   ripgrep
   rust-mode
   slime
   speed-type
   swiper
   unfill
   vterm
   window-purpose
   yaml-mode

   ;bubbleberry-theme
   ;dracula-theme
   ;eclipse-theme
   ;eink-theme
   ;eziam-theme
   ;github-modern-theme
   ;goose-theme
   ;hemera-theme
   ;hydandata-light-theme
   ;idea-darkula-theme
   ;kaolin-themes
   ;lavender-theme
   ;minimal-theme
   ;monotropic-theme
   ;noctilux-theme
   ;nofrils-acme-theme
   ;nyx-theme
   ;organic-green-theme
   ;plain-theme
   ;planet-theme
   ;poet-theme
   ;purp-theme
   ;railscasts-theme
   ;subatomic-theme
   ;sublime-themes
   ;tao-theme
   ))
(package-install-selected-packages)
(defun package--save-selected-packages (&rest opt) nil)


;; themes
; disable all themes before loading another
(defadvice load-theme (before theme-dont-propagate activate)
  (mapc #'disable-theme custom-enabled-themes))
(add-to-list 'custom-theme-load-path "~/dotfiles/emacs/themes/")
(setq tao-theme-use-sepia nil)
(load-theme 'white)

; hide some default and nonfunctional themes
(setq my-ignored-themes
      '(
	adwaita
	deeper-blue
	dichromacy
	hickey
	junio
	kaolin-aurora
	kaolin-breeze
	kaolin-galaxy
	kaolin-light
	kaolin-valley-dark
	kaolin-valley-light
	light-blue
	manoj-dark
	mccarthy
	misterioso
	odersky
	ritchie
	spolsky
	tango
	tango-dark
	tao
	tsdh-dark
	tsdh-light
	wheatgrass
	whiteboard
	wilson
	wombat
	))
(advice-add 'custom-available-themes :filter-return
	    (lambda (allthemes)
	      (cl-remove-if
	       (lambda (theme)
		 (member theme my-ignored-themes))
	       allthemes)))

;; dashboard
;(require 'dashboard)
;(dashboard-setup-startup-hook)
;(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))


;; ivy / swiper
(require 'ivy)
(require 'avy)
(require 'swiper)
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")
(setq avy-all-windows 'all-frames)
(defun swiper-at-point ()
  "Starts swiper with symbol at point pre-filled."
  (interactive)
  (swiper (selection-or-thing-at-point)))
(defun selection-or-thing-at-point ()
  (cond
   ((and transient-mark-mode
	 mark-active
	 (not (eq (mark) (point))))
    (let ((mark-saved (mark))
	  (point-saved (point)))
      (deactivate-mark)
      (buffer-substring-no-properties mark-saved point-saved)))
   (t (format "%s"
	      (or (thing-at-point 'symbol)
		  "")))))
(global-set-key (kbd "C-M-s") 'swiper-at-point)
(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "C-x b") 'counsel-switch-buffer)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "M-y") 'counsel-yank-pop)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-load-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(setq ivy-re-builders-alist
      '((t . ivy--regex-plus)))
(setq ivy-on-del-error-function #'ignore)
; this keybind is for ctrl+' but this escape code must be set explicitly in eg alacritty's config
(define-key ivy-minibuffer-map (kbd "M-[ 1 ; 5 '") 'ivy-avy)
(define-key ivy-minibuffer-map (kbd "M-y") 'counsel-yank-pop)
(define-key swiper-map (kbd "M-[ 1 ; 5 '") 'swiper-avy)


;; projectile
(setq projectile-completion-system 'ivy)
(setq projectile-require-project-root nil)
(setq projectile-mode-line-prefix " P")
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(counsel-projectile-mode)


;; evil configuration
(require 'evil)
(evil-select-search-module 'evil-search-module 'evil-search)
(evil-set-initial-state 'Custom-mode 'normal)
(evil-set-undo-system 'undo-redo)

(require 'evil-leader)
(evil-leader/set-leader "<SPC>")
(global-evil-leader-mode)
(evil-leader/set-key
  "x" 'counsel-M-x
  "f" 'counsel-find-file
  "b" 'counsel-switch-buffer
  "c" 'comment-or-uncomment-region
  "w" 'save-buffer
  "s" 'swiper
  "0" 'delete-window
  "1" 'delete-other-windows
  "2" 'split-window-below
  "3" 'split-window-right
  "4 b" 'counsel-switch-buffer-other-window
  "<SPC> c" 'evil-avy-goto-char-timer
  "<SPC> w" 'evil-avy-goto-word-or-subword-1
  "<SPC> l" 'evil-avy-goto-line
  "<SPC> s" 'avy-evil-search
  "<SPC> k" 'avy-kill-region
  "C-c" 'counsel-load-theme)

(defun avy-evil-search ()
  "Jump to one of the current evil search candidates."
  (interactive)
  (avy-with avy-isearch
    (let ((avy-background nil))
      (avy-process
       (avy--regex-candidates (car evil-ex-search-history)))
      (isearch-done))))

(evil-mode 1)

(require 'evil-surround)
(global-evil-surround-mode 1)

(require 'evil-smartparens)
(require 'evil-paredit)

;; (require 'evil-mc)
;; (evil-define-key 'visual evil-mc-key-map
;;   "A" #'evil-mc-make-cursor-in-visual-selection-end
;;   "I" #'evil-mc-make-cursor-in-visual-selection-beg)
;; (evil-define-key nil evil-ex-search-keymap
;;   "M-q" 'query-replace)
;; (global-evil-mc-mode 1)

(unless (display-graphic-p)
  (require 'evil-terminal-cursor-changer)

  (evil-terminal-cursor-changer-activate) ; or (etcc-on)
  )
(setq evil-motion-state-cursor 'box)  ; █
(setq evil-visual-state-cursor 'box)  ; █
(setq evil-normal-state-cursor 'box)  ; █
(setq evil-insert-state-cursor 'bar)  ; ⎸
(setq evil-emacs-state-cursor  'hbar) ; _


;; company-mode
(add-hook 'after-init-hook 'global-company-mode)


;; mu4e / eww
;(require 'smtpmail)
;(require 'mu4e)
;(setq mu4e-maildir (expand-file-name "~/.mail/gmail"))
;
;(setq mu4e-drafts-folder "/Drafts")
;(setq mu4e-sent-folder   "/Sent")
;(setq mu4e-trash-folder  "/Trash")
;
;(setq mu4e-get-mail-command "mbsync -c ~/.config/mbsyncrc gmail"
;      mu4e-update-interval 120
;      mu4e-headers-auto-update t)
;
;(add-to-list 'mu4e-view-actions
;  '("ViewInBrowser" . mu4e-action-view-in-browser) t)
;
;(setq mu4e-confirm-quit nil)
;(setq mu4e-view-show-images t)
;;(setq mu4e-view-prefer-html t)
;(setq mu4e-sent-messages-behavior 'delete)
;(add-hook 'mu4e-compose-mode-hook
;        (defun my-do-compose-stuff ()
;           "Settings for message composition."
;           (set-fill-column 72)
;           (flyspell-mode)))

; fix eww colours
;don't colourise anything
(setq shr-use-colors nil)
(advice-add #'shr-colorize-region :around (defun shr-no-colourise-region (&rest ignore)))


;; rust
(add-hook 'racer-mode-hook #'company-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'rust-mode-hook #'racer-mode)
(require 'rust-mode)
(define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
(setq company-tooltip-align-annotations t)
(add-hook 'rust-mode-hook 'cargo-minor-mode)


;; flycheck
(require 'flycheck)
(add-hook 'c-mode-hook #'(lambda () (setq flycheck-clang-language-standard "gnu99")))


;; lsp mode
(setq lsp-prefer-flymake t)


;; window management
(require 'window-purpose)
(purpose-mode)
(require 'ace-window)
(global-set-key (kbd "M-o") 'ace-window)


;; eterm
(require 'eterm-256color)
(add-hook 'term-mode-hook #'eterm-256color-mode)


;; magit
(setenv "GIT_ASKPASS" "git-gui--askpass")
(require 'exec-path-from-shell)
(defun get-ssh-agent ()
  (interactive)
  (exec-path-from-shell-copy-env "SSH_AGENT_PID")
  (exec-path-from-shell-copy-env "SSH_AUTH_SOCK"))


;; org-mode
(require 'org-download)
(setq org-startup-with-inline-images t)
(setq org-download-display-inline-images t)
(setq org-image-actual-width 400)
(setq org-indent-indentation-per-level 1)
(setq org-startup-truncated t)
(setq org-link-file-path-type 'relative)
(define-key org-mode-map (kbd "C-c C-r") nil)
(add-hook 'org-mode-hook
          (lambda ()
	    (define-key evil-normal-state-map (kbd "TAB") 'org-cycle)
            (local-set-key (kbd "\C-c TAB") 'org-toggle-inline-images)))
(add-hook 'org-mode-hook 'turn-on-auto-fill)

;; (defvar org-notes-file "~/notes/notes.org"
;;   "Path to OrgMode notes file.")
;; (defun org-notes-entry ()
;;   "Create a new diary entry for today or append to an existing one."
;;   (interactive)
;;   (switch-to-buffer (find-file org-notes-file))
;;   (widen)
;;   (beginning-of-buffer)
;;   (org-insert-heading)
;;   (let ((current-prefix-arg '(16)))
;;     (call-interactively 'org-time-stamp))
;;   (insert " ")
;;   (beginning-of-buffer)
;;   (org-show-entry)
;;   (org-narrow-to-subtree)
;;   (end-of-buffer))
;;(global-set-key "\C-cn" 'org-notes-entry)

;; (require 'org-roam)
;; (define-key org-roam-mode-map (kbd "C-c n l") #'org-roam)
;; (define-key org-roam-mode-map (kbd "C-c n f") #'org-roam-find-file)
;; (define-key org-roam-mode-map (kbd "C-c n j") #'org-roam-jump-to-index)
;; (define-key org-roam-mode-map (kbd "C-c n b") #'org-roam-switch-to-buffer)
;; (define-key org-roam-mode-map (kbd "C-c n g") #'org-roam-graph)
;; (define-key org-mode-map (kbd "C-c n i") #'org-roam-insert)
;; (org-roam-mode +1)
;; (require 'company-org-roam)
;; (push 'company-org-roam company-backends)
;; (setq org-roam-directory "/mnt/mp/docs/org/")
;; (setq org-roam-index-file "index.org")
;; (setq org-roam-completion-system 'ivy)
;; (setq org-roam-buffer-no-delete-other-windows 't)
;; (require 'org-roam-protocol)
;; (require 'org-roam-server)
;; (setq org-roam-server-host "127.0.0.1"
;;         org-roam-server-port 8097
;;         org-roam-server-export-inline-images t
;;         org-roam-server-authenticate nil
;;         org-roam-server-network-arrows t
;;         org-roam-server-network-label-truncate nil
;;         org-roam-server-network-label-truncate-length 60
;;         org-roam-server-network-label-wrap-length 20)
;; (org-roam-server-mode)

;; (require 'deft)
;; (setq deft-directory "/mnt/mp/docs/wiki/")
;; (global-set-key [f8] 'deft)


;; modeline
(require 'cyphejor)
(require 'diminish)
(setq
 cyphejor-rules
 '(:upcase
   ("bookmark"     "→")
   ("buffer"       "β")
   ("diff"         "Δ")
   ("dired"        "δ")
   ("emacs"        "ε")
   ("inferior"     "i" :prefix)
   ("interaction"  "i" :prefix)
   ("interactive"  "i" :prefix)
   ("lisp"         "λ" :postfix)
   ("menu"         "▤" :postfix)
   ("mode"         ""n)
   ("python"       "π")
   ("shell"        "sh" :postfix)
   ("text"         "ξ")))
(cyphejor-mode 1)

(eval-after-load "undo-tree"
  '(diminish 'undo-tree-mode))

(eval-after-load 'company
  '(diminish 'company-mode))

(eval-after-load 'eldoc
  '(diminish 'eldoc-mode))

(eval-after-load 'evil-mc
  '(diminish 'evil-mc-mode))

(eval-after-load 'evil-workman
  '(diminish 'evil-workman-mode))

(eval-after-load 'evil
  '(diminish 'evil-mode))

(diminish 'ivy-mode)


;; leetcode
(setq leetcode-prefer-language "rust")
(setq leetcode-prefer-sql "postgresql")


;; lisp/ configuration
(require 'evil-workman-mode)
;; (evil-workman-global-mode +1)

(defcustom my-evil-minor-modes
  '(evil-workman-mode)
  "Buffer-local minor modes to enable or disable with `evil-local-mode'."
  :type  '(repeat symbol)
  :group 'evil)
(defun my-evil-local-mode-hook ()
  "Enable or disable all of `my-evil-minor-modes' with `evil-local-mode'."
  (let ((state (if evil-local-mode 1 0)))
    (mapc (lambda (mode) (funcall mode state))
          my-evil-minor-modes)))

(add-hook 'evil-local-mode-hook 'my-evil-local-mode-hook)
(require 'evil-little-word)
(require 'evil-relative-linum)
(setq backup-directory-alist `(("." . "~/.cache/emacs/backup")))
(setq auto-save-default nil)
(defun xterm-title-update (title)
  (interactive "sTerminal name:")
                     (ignore-errors (send-string-to-terminal (concat "\033]2; " title "\007")))
                      )
(add-hook 'buffer-list-update-hook #'(lambda ()
				      (xterm-title-update (concat (buffer-name) " - emacs"))))



;; auctex
(setq TeX-engine 'luatex)



;; functions
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-scroll-amount '(4))

;;; init.el ends here
