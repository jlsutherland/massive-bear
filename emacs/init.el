(setq user-full-name "Joseph L. Sutherland")
(setq user-mail-address "jls2316@columbia.edu")

;; environment
(setenv "PATH" (concat "/Users/joesutherland/.rvm/gems/ruby-2.1.3/bin:/Users/joesutherland/.rvm/gems/ruby-2.1.3@global/bin:/Users/joesutherland/.rvm/rubies/ruby-2.1.3/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/git/bin:/usr/texbin:/Users/joesutherland/.rvm/bin" (getenv "PATH")))
(require 'cl)

;; key bindings
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-c C-k") 'compile)
(global-set-key (kbd "C-x g") 'magit-status)

;; convert to y/n instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; highlight parentheses
(show-paren-mode t)

;; window
(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  )
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

;; echo text shorter time
(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell t)

;; highlight tabs
(setq-default highlight-tabs t)

;; show trailing whitespace
(setq-default show-trailing-whitespace t)

;; remove useless whitespace when saving file
(add-hook 'before-save-hook 'whitespace-cleanup)
(add-hook 'before-save-hook (lambda() (delete-trailing-whitespace)))

;; remove all backup files
(setq make-backup-files nil)
(setq backup-inhibited t)
(setq auto-save-default nil)

;; set locale to UTF-8
(set-language-environment 'utf-8)
(set-terminal-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Fontify the text in the buffer
(global-font-lock-mode t)

;; Selection highlighting
(transient-mark-mode t)

;; Display line number in the modeline
(line-number-mode t)

;; Display column number in the modeline
(column-number-mode t)

;; INSTALL PACKAGE MANAGEMENT
;; Require the library
(require 'package)
(package-initialize)

;; Add package repos
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")
			 ("melpa" . "http://melpa.org/packages/")))
(setq package-archive-enable-alist '(("melpa" deft magit)))


;; install use-package
(unless (package-installed-p 'use-package)
  (progn
    (package-refresh-contents)
    (package-install 'use-package)))

(require 'use-package)

(use-package autopair
  :ensure autopair
  :init (progn
	  (autopair-global-mode)
	  ))

(use-package ac-slime
  :ensure ac-slime
  :init (progn
	  ))

(use-package coffee-mode
  :ensure coffee-mode
  :init (progn
	  (defun coffee-custom ()
	    "coffee-mode-hook"
	    (make-local-variable 'tab-width)
	    (set 'tab-width 2))
	  (add-hook 'coffee-mode-hook 'coffee-custom)
	  ))

(use-package feature-mode
  :ensure feature-mode
  :init (progn
	  ))

(use-package gist
  :ensure gist
  :init (progn
	  ))

(use-package htmlize
  :ensure htmlize
  :init (progn
	  ))

(use-package markdown-mode
  :ensure markdown-mode
  :init (progn
	  (add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))
	  (add-to-list 'auto-mode-alist '("\\.mdown$" . markdown-mode))
	  (add-hook 'markdown-mode-hook
		    (lambda ()
		      (visual-line-mode t)
		      (writegood-mode t)
		      (flyspell-mode t)))
	  (setq markdown-command "pandoc --smart -f markdown -t html")
	  ;;(setq markdown-css-path (expand-file-name "markdown.css" abedra/vendor-dir))
	  ))

(use-package nodejs-repl
  :ensure nodejs-repl
  :init (progn
	  ))

(use-package solarized-theme
  :ensure solarized-theme
  :init (progn
	  ))

(use-package web-mode
  :ensure web-mode
  :init (progn
	  ))

(use-package rvm
  :ensure rvm
  :init (progn
	  (rvm-use-default)
	  ))

(use-package writegood-mode
  :ensure writegood-mode
  :init (progn
	  ))

(use-package auto-complete
  :ensure auto-complete
  :init (progn
	  (require 'auto-complete-config)
	  ;;(ac-config-default)
	  ))

(use-package buffer-move
  :ensure buffer-move
  :init (progn
	  ))

(use-package flycheck
  :ensure flycheck
  :init (progn
	  ))

(use-package highlight-symbol
  :ensure highlight-symbol
  :init (progn
	  ))

(use-package ido-hacks
  :ensure ido-hacks
  :init (progn
	  ))

(use-package ido-vertical-mode
  :ensure ido-vertical-mode
  :init (progn
	  ))

(use-package js3-mode
  :ensure js3-mode
  :init (progn
	  ))

(use-package magit
  :ensure magit
  :init (progn
	  ))

(use-package git-timemachine
  :ensure git-timemachine
  :init (progn
	  ))

(use-package multiple-cursors
  :ensure multiple-cursors
  :init (progn
	  ))

(use-package php-mode
  :ensure php-mode
  :init (progn
	  ))

(use-package rainbow-mode
  :ensure rainbow-mode
  :init (progn
	  ))

(use-package visual-regexp
  :ensure visual-regexp
  :init (progn
	  ))

(use-package dired+
  :ensure dired+
  :init (progn
	  ))

(use-package tidy
  :ensure tidy
  :init (progn
	  ))

(use-package web-mode
  :ensure web-mode
  :init (progn
	  ))

(use-package yaml-mode
  :ensure yaml-mode
  :init (progn
	  (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
	  (add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))
	  ))

(use-package scss-mode
  :ensure scss-mode
  :init (progn
	  (setq exec-path (cons (expand-file-name "~/.rvm/rubies/ruby-2.1.3/bin") exec-path))
	  (autoload 'scss-mode "scss-mode")
	  (add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))
	  ))

;; start-up options
(setq inhibit-splash-screen t
      initial-scratch-message nil
      initial-major-mode 'org-mode)

;; text marking
(delete-selection-mode t)
(transient-mark-mode t)
(setq x-select-enable-clipboard t)

;; display settings
(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

;; tabs
(setq tab-width 2
      indent-tabs-mode nil)

;; buffer cleanup
(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer."
  (interactive)
  (indent-buffer)
  (untabify-buffer)
  (delete-trailing-whitespace))

(defun cleanup-region (beg end)
  "Remove tmux artifacts from region."
  (interactive "r")
  (dolist (re '("\\\\│\·*\n" "\W*│\·*"))
    (replace-regexp re "" nil beg end)))

(global-set-key (kbd "C-x M-t") 'cleanup-region)
(global-set-key (kbd "C-c n") 'cleanup-buffer)

(setq-default show-trailing-whitespace t)

;; emacs spell checker
(setq flyspell-issue-welcome-flag nil)
(if (eq system-type 'darwin)
    (setq-default ispell-program-name "/usr/local/bin/aspell")
  (setq-default ispell-program-name "/usr/bin/aspell"))
(setq-default ispell-list-command "list")

;; some language hooks
(add-to-list 'auto-mode-alist '("\\.zsh$" . shell-script-mode))
(add-to-list 'auto-mode-alist '("\\.gitconfig$" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.hbs$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$" . web-mode))
(add-hook 'ruby-mode-hook
	  (lambda ()
	    (autopair-mode)))

(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile" . ruby-mode))

;; theming
(if window-system
    (load-theme 'solarized-dark t)
  (load-theme 'wombat t))

;; load font for my eyes
(set-default-font "Droid Sans Mono-12")

;; ido mode
(setq ido-enable-flex-matching t
      ido-use-virtual-buffers t
      ido-everywhere t)
(ido-mode 1)

;; from customizer
'(server-mode t)
'(uniquify-buffer-name-style (quote post-forward) nil (uniquify))
