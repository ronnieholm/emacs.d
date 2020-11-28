(setq user-full-name "Ronnie Holm")
(setq user-mail-address "mail@bugfree.dk")
(setq calendar-latitude 55.58556)
(setq calendar-longitude 12.13139)
(setq calendar-location-name "Roskilde")
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)
(setq scroll-margin 1)              ;; do smooth scrolling
(setq scroll-conservatively 100000)
(setq scroll-up-aggressively 0.01)
(setq scroll-down-aggressively 0.01)
(setq ring-bell-function 'ignore)   ;; disable Emacs sound
(setq backup-inhibited t)
(setq delete-by-moving-to-trash t)  ;; delete moves to recycle bin
(setq-default fill-column 80)       ;; increase from default of 70.
(setq-default indent-tabs-mode nil) ;; spaces over tabs
(setq-default tab-width 4)
(setq-default compilation-scroll-output t)

;; don't show the toolbar and scrollbar
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; line numbering
(global-display-line-numbers-mode)
(setq display-line-numbers-type 'absolute)
  (dolist (mode '(term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; shortcut for typing in yes or no
(fset 'yes-or-no-p 'y-or-n-p)

;; change font
(defun rh/get-default-font ()
  (cond
   ((eq system-type 'windows-nt) "Consolas-10")
   ((eq system-type 'gnu/linux) "DejaVu Sans Mono-10")))

(add-to-list 'default-frame-alist `(font . ,(rh/get-default-font)))

(global-font-lock-mode t)
(blink-cursor-mode 0)
(column-number-mode t)
(size-indication-mode t)

(setq org-hide-leading-stars t
      org-add-levels-only t
      org-add-levels-only t
      org-clock-out-remove-zero-time-clocks t
      org-clock-into-drawer t) ;; clock time in :LOGBOOK: drawer

;; keep track of time across sessions
(setq org-clock-persist t)
(org-clock-persistence-insinuate)

;; resize windows
;; https://www.emacswiki.org/emacs/WindowResize
;;(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
;;(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
;;(global-set-key (kbd "S-C-<down>") 'shrink-window)
;;(global-set-key (kbd "S-C-<up>") 'enlarge-window)

;; move cursor between windows
;; https://www.emacswiki.org/emacs/WindMove
;; The default S-arrow keybinding is incompatible with org-mode
;;(when (fboundp 'windmove-default-keybindings)
;;  (windmove-default-keybindings 'S))
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

;; add paths recursively
(let ((default-directory "~/.emacs.d/site-lisp/"))
  (setq load-path
    (append
         (let ((load-path (copy-sequence load-path)))
           (append 
            (copy-sequence (normal-top-level-add-to-load-path '(".")))
            (normal-top-level-add-subdirs-to-load-path)))
         load-path)))

(package-initialize)
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package try)

(use-package helpful)

;; default is c-x w <number> but that's a lot of typing
;;(winum-set-keymap-prefix (kbd "½"))

(setq winum-keymap
    (let ((map (make-sparse-keymap)))
      (define-key map (kbd "<f5>") 'winum-select-window-1)
      (define-key map (kbd "<f6>") 'winum-select-window-2)
      (define-key map (kbd "<f7>") 'winum-select-window-3)
      (define-key map (kbd "<f8>") 'winum-select-window-4)
      map))

;; alternative to windmove
(use-package winum)

(winum-mode)

;; Sacha Chua: Emacs microhabit - Switching windows
;; https://www.youtube.com/watch?v=nKCKuRuvAOw
(use-package ace-window
  :bind ("C-x o" . ace-window))

(use-package which-key
  :config (which-key-mode))

;; better minibuffer completions. Use of ido and helm are mutually exclusive.
;;(ido-mode t)
;;(setq ido-everywhere t)
;;(setq ido-enable-flex-matching t)

(use-package helm
  :config (helm-mode 1))

;;(setq helm-split-window-in-side-p t
;;      helm-move-to-line-cycle-in-source t)
(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-c") 'helm-calcul-expression)
(global-set-key (kbd "C-s") 'helm-occur)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-h a") 'helm-apropos)

;; https://leanpub.com/markdown-mode/read
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . gfm-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init
  (setq markdown-command
        (concat "pandoc"
                " --from=markdown --to=html"
                " --standalone --mathjax --highlight-style=pygments")))

(use-package markdown-toc)

(use-package ox-twbs)

(use-package dashboard
  :config
    (dashboard-setup-startup-hook)
    (setq dashboard-items '((recents  . 10)))
    (setq dashboard-banner-logo-title
          (format "%s" (sunrise-sunset()))))

(use-package spaceline
  :config
  (require 'spaceline-config)
    (setq spaceline-buffer-encoding-abbrev-p nil)
    (setq spaceline-line-column-p t)
    (setq spaceline-line-p nil)
    (setq powerline-default-separator (quote arrow))
    (spaceline-spacemacs-theme))

(use-package magit
  :config
  (setq magit-push-always-verify nil)
  (setq git-commit-summary-max-length 50)
  :bind
  ("C-c m s" . magit-status)
  ("C-c m l" . magit-log))

(use-package git-gutter)

(use-package company
  :config
  (setq company-idle-delay 1)
  (setq company-minimum-prefix-length 3))

(global-company-mode)

(use-package company-lsp
  :config
  (push 'company-lsp company-backends)) 

(use-package projectile
  :config
  (projectile-mode)
  (setq projectile-enable-caching t)
  (setq projectile-indexing-method 'alien)
  (setq projectile-globally-ignored-file-suffixes
      '("#" "~" ".swp" ".o" ".so" ".exe" ".dll" ".elc" ".pyc" ".jar"))
  (setq projectile-globally-ignored-directories
      '(".git" "node_modules" "__pycache__" ".vs"))
  (setq projectile-globally-ignored-files '("TAGS" "tags" ".DS_Store"))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/git")
    (setq projectile-project-search-path '("~/git")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package helm-projectile)
(helm-projectile-on)

(use-package neotree
  :bind (("<f2>" . neotree-toggle))
  :config
  (setq neo-window-fixed-size nil))

(use-package csharp-mode)

(add-hook 'csharp-mode-hook
	      '(lambda()
	         (electric-pair-mode)
             (local-set-key (kbd "C-c b") 'recompile)
             (setq truncate-lines -1)))

(use-package fsharp-mode
  :defer t)

(require 'fsharp-mode)
(require 'eglot-fsharp)
(add-hook 'fsharp-mode-hook 'eglot-ensure)

(use-package paredit)

(add-hook 'emacs-lisp-mode-hook
          '(lambda()
             ;; show argument list and help for identifier under cursor
             (eldoc-mode 1)
             ;; edit lisp code on always valid AST
             ;;(paredit-mode)
             ))

(use-package go-mode)

(use-package rust-mode)

(use-package lsp-mode
;;  :hook (csharp-mode . lsp)  ;; omnisharp not working with Emacs
  :commands lsp)

;; https://github.com/magnars/multiple-cursors.el
(use-package multiple-cursors)

(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)

;; https://github.com/magnars/expand-region.el
(use-package expand-region
  :bind
  ("C-=" . er/expand-region)
  ("C--" . er/contract-region))

;; use M-up/M-down to move selection up and down
(use-package move-text)
(global-set-key (kbd "<M-up>") 'move-text-up)
(global-set-key (kbd "<M-down>") 'move-text-down)

;; https://github.com/abo-abo/avy
(use-package avy)

(global-set-key (kbd "C-;") 'avy-goto-char)
(global-set-key (kbd "C-:") 'avy-goto-char-2)

;; See https://www.youtube.com/watch?feature=youtu.be&v=xaZMwNELaJY&app=desktop at 27m00s

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t) ;; Instead of C-u for universal arguments, make C-u scroll up and C-d scroll down
  :config
  (evil-mode t)
  (define-key helm-map (kbd "C-j") 'helm-next-line)
  (define-key helm-map (kbd "C-k") 'helm-previous-line)
  (define-key helm-map (kbd "C-h") 'helm-next-source)
  (define-key helm-map (kbd "C-S-h") 'describe-key)
  (define-key helm-map (kbd "C-l") (kbd "RET"))
  (define-key helm-map [escape] 'helm-keyboard-quit)
  (define-key evil-normal-state-map   (kbd "C-g") #'evil-keyboard-quit)
  (define-key evil-motion-state-map   (kbd "C-g") #'evil-keyboard-quit)
  (define-key evil-insert-state-map   (kbd "C-g") #'evil-keyboard-quit)
  (define-key evil-window-map         (kbd "C-g") #'evil-keyboard-quit)
  (define-key evil-operator-state-map (kbd "C-g") #'evil-keyboard-quit)

  ;; Use visual line motions even outside of visual-line-mode buffer.
  ;; By default j and k in evil mode goes to the next line. With the
  ;; configuration below, in wrapped lines, j and k go the next
  ;; sentence instead.
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (dolist (keymap (list helm-find-files-map helm-read-file-map))
    (define-key keymap (kbd "C-l") 'helm-execute-persistent-action)
    (define-key keymap (kbd "C-h") 'helm-find-files-up-one-level)
    (define-key keymap (kbd "C-S-h") 'describe-key)))

(defun evil-keyboard-quit ()
  "Keyboard quit and force normal state."
  (interactive)
  (and evil-mode (evil-force-normal-state))
  (keyboard-quit))

;; Inspired by http://www.cachestocaches.com/2016/12/vim-within-emacs-anecdotal-guide
;; In evil-mode, type :e or :b
(define-key evil-ex-map "e" 'helm-find-files)
(define-key evil-ex-map "b " 'helm-mini)

(use-package evil-magit)

;; Start the commit window in insert mode
(add-hook 'with-editor-mode-hook 'evil-insert-state)

;; Add evil bindings to accept/cancel commit
(evil-define-key 'normal with-editor-mode-map
  (kbd "RET") 'with-editor-finish
  [escape] 'with-editor-cancel)

;; https://github.com/emacs-evil/evil-collection
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(defun rh/duplicate-line ()
  "Duplicate current line"
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (newline)
  (yank))

(global-set-key (kbd "C-,") 'rh/duplicate-line)

;(load-theme 'deeper-blue)

(use-package dracula-theme
  :config
  (load-theme 'dracula t))

(sunrise-sunset)
