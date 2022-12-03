;; Straight Bootstrap
(defvar bootstrap-version)
(setq straight-repository-branch "develop")
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(setq straight-use-package-by-default 't)
(straight-use-package 'use-package)

;; Theme
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-flatwhite t))

;; Evil Bindings
(use-package evil
  :init
  (setq evil-undo-system 'undo-redo
        evil-want-C-u-scroll 't
        evil-want-keybinding nil
        evil-want-integration 't)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

;; Completion
;; Minibufer
(use-package vertico
  :config
  (vertico-mode))

(use-package orderless
  :config
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; Tools
(use-package magit
  :commands (magit))

(use-package vterm
  :commands (vterm vterm-other-window))

;; UI
(use-package flyspell
  :config
  (setq ispell-program-name "enchant-2"))

(use-package visual-fill-column
  :hook (visual-line-mode)
  :config
  (visual-fill-column-mode))

(use-package adaptive-wrap
  :hook (visual-line-mode . adaptive-wrap-prefix-mode))

;; File Types
(use-package nix-mode
  :mode ("\\.nix\\'" "\\.nix.in\\'"))

(use-package cdlatex
  :hook (org-mode . org-cdlatex-mode))

(use-package web-mode
  :mode ("\\.html\\'")
  :config
  (setq-default web-mode-attr-indent-offset 2
                web-mode-css-indent-offset 2
                web-mode-code-indent-offset 2
                web-mode-markup-indent-offset 2
                web-mode-sql-indent-offset 2
                visual-line-mode 1))

(use-package emmet-mode
  :hook (web-mode)
  :config
  (emmet-mode))

(use-package skewer-mode
  :hook (web-mode . skewer-html-mode))

(use-package yuck-mode
  :mode ("\\.yuck\\'"))


;; Disable Annoying Startup Stuff
(setq tab-bar-show nil
      inhibit-startup-message t
      inhibit-startup-screen t
      inhibit-startup-echo-area-message t)

(setq tab-width 2)
