(setq user-full-name "Joseph L. Sutherland")
(setq user-mail-address "jls2316@columbia.edu")

;; environment
(setenv "PATH" (concat "/Users/joesutherland/.rvm/gems/ruby-2.1.3/bin:/Users/joesutherland/.rvm/gems/ruby-2.1.3@global/bin:/Users/joesutherland/.rvm/rubies/ruby-2.1.3/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/git/bin:/usr/texbin:/Users/joesutherland/.rvm/bin" (getenv "PATH")))
(require 'cl)

;; frame size
(when window-system (set-frame-size (selected-frame) 100 56))

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

;; wrap
(global-visual-line-mode 1)

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
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("marmalade" . "http://marmalade-repo.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("elpy" . "http://jorgenschaefer.github.io/packages/")))
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

(use-package stan-snippets
  :ensure stan-snippets
  :init (progn
          ))

(use-package stan-mode
  :ensure stan-mode
  :init (progn
          ))

(use-package elpy
  :ensure elpy
  :init (progn
          (elpy-enable)
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
    ;;; MARKDOWN
          ;; whitespace
          (remove-hook 'before-save-hook 'delete-trailing-whitespace t)
          (remove-hook 'before-save-hook 'whitespace-cleanup t)
          (remove-hook 'before-save-hook (lambda() (delete-trailing-whitespace)) t)

    ;;; Text files
          (add-to-list 'auto-mode-alist '("\\.text$" . markdown-mode))
          (add-to-list 'auto-mode-alist '("\\.txt$" . markdown-mode))
          (add-hook 'markdown-mode-hook
                    (lambda ()
                      (visual-line-mode t)
                      (writegood-mode t)
                      (flyspell-mode t)))
          (setq markdown-command "pandoc --smart -f markdown -t html")
          ;;(setq markdown-css-path (expand-file-name "markdown.css" abedra/vendor-dir))
          ))

(use-package polymode
  :ensure polymode
  :init (progn
          (require 'poly-R) (require 'poly-markdown)
          (add-hook 'poymode-hook
                    (lambda ()
                      (visual-line-mode t)
                      (writegood-mode t)
                      (flyspell-mode t)))
          ;; MARKDOWN
          (add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))
          ;; R modes
          (add-to-list 'auto-mode-alist '("\\.Snw" . poly-noweb+r-mode))
          (add-to-list 'auto-mode-alist '("\\.Rnw" . poly-noweb+r-mode))
          (add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))
          ;; ESS polymode rmarkdown compile function
          (defun ess-rmarkdown ()
            "Compile R markdown (.Rmd). Should work for any output type."
            (interactive)
            ;; Check if attached R-session
            (condition-case nil
                (ess-get-process)
              (error
               (ess-switch-process)))
            (let* ((rmd-buf (current-buffer)))
              (save-excursion
                (let* ((sprocess (ess-get-process ess-current-process-name))
                       (sbuffer (process-buffer sprocess))
                       (buf-coding (symbol-name buffer-file-coding-system))
                       (R-cmd
                        (format "library(rmarkdown); rmarkdown::render(\"%s\")"
                                buffer-file-name)))
                  (message "Running rmarkdown on %s" buffer-file-name)
                  (ess-execute R-cmd 'buffer nil nil)
                  (switch-to-buffer rmd-buf)
                  (ess-show-buffer (buffer-name sbuffer) nil)))))
          (define-key polymode-mode-map "\M-ns" 'ess-rmarkdown)
          ))

(use-package nodejs-repl
  :ensure nodejs-repl
  :init (progn
          ))

(use-package neotree
  :ensure neotree
  :init (progn
          (global-set-key [f8] 'neotree-toggle)
          ))

(use-package solarized-theme
  :ensure solarized-theme
  :init (progn
          ))

(use-package web-mode
  :ensure web-mode
  :init (progn
          (require 'web-mode)
          (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))
          (add-to-list 'auto-mode-alist '("\\.blade\\.php\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.scss\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))

          (defun my-web-mode-hook ()
            "Hooks for Web mode."
            (setq web-mode-markup-indent-offset 2)
            (setq web-mode-markup-indent-offset 2)
            (setq web-mode-css-indent-offset 2)
            (setq web-mode-code-indent-offset 2)
            (setq web-mode-indent-style 2)
            (setq web-mode-enable-current-element-highlight t)
            (setq web-mode-enable-current-column-highlight t)
            (setq web-mode-enable-css-colorization t)
            (add-hook 'local-write-file-hooks
                      (lambda ()
                        (delete-trailing-whitespace)
                        nil))
            )
          (setq web-mode-ac-sources-alist
                '(("css" . (ac-source-css-property))
                  ("html" . (ac-source-words-in-buffer ac-source-abbrev))
                  ))
          (add-hook 'web-mode-hook  'my-web-mode-hook)
          ))

(use-package rvm
  :ensure rvm
  :init (progn
          (rvm-use-default)
          ))

(use-package writegood-mode
  :ensure writegood-mode
  :init (progn
          (global-set-key "\C-cg" 'writegood-mode)
          ))

(use-package auto-complete
  :ensure auto-complete
  :init (progn
          (require 'auto-complete-config)
          (ac-config-default)
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

(use-package multi-term
  :ensure multi-term
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
(setq-default tab-width 2
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
(setq user-full-name "Joseph L. Sutherland")
(setq user-mail-address "jls2316@columbia.edu")

;; environment
(setenv "PATH" (concat "/Users/joesutherland/.rvm/gems/ruby-2.1.3/bin:/Users/joesutherland/.rvm/gems/ruby-2.1.3@global/bin:/Users/joesutherland/.rvm/rubies/ruby-2.1.3/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/git/bin:/usr/texbin:/Users/joesutherland/.rvm/bin" (getenv "PATH")))
(require 'cl)

;; frame size
(when window-system (set-frame-size (selected-frame) 100 56))

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

;; wrap
(global-visual-line-mode 1)

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
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("marmalade" . "http://marmalade-repo.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
        ("elpy" . "http://jorgenschaefer.github.io/packages/")))
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

(use-package stan-snippets
  :ensure stan-snippets
  :init (progn
          ))

(use-package stan-mode
  :ensure stan-mode
  :init (progn
          ))

(use-package elpy
  :ensure elpy
  :init (progn
          (elpy-enable)
          ))

(use-package gist
  :ensure gist
  :init (progn
          ))

(use-package htmlize
  :ensure htmlize
  :init (progn
          ))

(use-package nodejs-repl
  :ensure nodejs-repl
  :init (progn
          ))

(use-package neotree
  :ensure neotree
  :init (progn
          (global-set-key [f8] 'neotree-toggle)
          ))

(use-package solarized-theme
  :ensure solarized-theme
  :init (progn
          ))

(use-package web-mode
  :ensure web-mode
  :init (progn
          (require 'web-mode)
          (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.php\\'" . php-mode))
          (add-to-list 'auto-mode-alist '("\\.blade\\.php\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.scss\\'" . web-mode))
          (add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))

          (defun my-web-mode-hook ()
            "Hooks for Web mode."
            (setq web-mode-markup-indent-offset 2)
            (setq web-mode-markup-indent-offset 2)
            (setq web-mode-css-indent-offset 2)
            (setq web-mode-code-indent-offset 2)
            (setq web-mode-indent-style 2)
            (setq web-mode-enable-current-element-highlight t)
            (setq web-mode-enable-current-column-highlight t)
            (setq web-mode-enable-css-colorization t)
            (add-hook 'local-write-file-hooks
                      (lambda ()
                        (delete-trailing-whitespace)
                        nil))
            )
          (setq web-mode-ac-sources-alist
                '(("css" . (ac-source-css-property))
                  ("html" . (ac-source-words-in-buffer ac-source-abbrev))
                  ))
          (add-hook 'web-mode-hook  'my-web-mode-hook)
          ))

(use-package yasnippet
  :ensure yasnippet
  :init (progn
          (setq yas-snippet-dirs
                '("~/.emacs.d/snippets"                 ;; personal snippets
                  ))
          ))

(use-package rvm
  :ensure rvm
  :init (progn
          (rvm-use-default)
          ))

(use-package writegood-mode
  :ensure writegood-mode
  :init (progn
          (global-set-key "\C-cg" 'writegood-mode)
          ))

(use-package auto-complete
  :ensure auto-complete
  :init (progn
          (require 'auto-complete-config)
          (ac-config-default)
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

(use-package multi-term
  :ensure multi-term
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
(setq-default tab-width 2
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
(eval-after-load "flyspell"
  '(progn
     (define-key flyspell-mouse-map [down-mouse-3] #'flyspell-correct-word)
     (define-key flyspell-mouse-map [mouse-3] #'undefined)))

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

;; AUCTeX
;; Customary Customization, p. 1 and 16 in the manual, and http://www.emacswiki.org/emacs/AUCTeX#toc2
(load "auctex.el" nil t t)
(setq TeX-parse-self t); Enable parse on load.
(setq TeX-auto-save t); Enable parse on save.
(setq-default TeX-master nil)

(setq TeX-PDF-mode t); PDF mode (rather than DVI-mode)

(add-hook 'TeX-mode-hook 'flyspell-mode)
(add-hook 'TeX-mode-hook 'visual-line-mode)
(add-hook 'TeX-mode-hook 'writegood-mode)
(add-hook 'emacs-lisp-mode-hook 'flyspell-prog-mode)
(setq ispell-dictionary "english")
(add-hook 'TeX-mode-hook
          (lambda () (TeX-fold-mode 1)))
(setq LaTeX-babel-hyphen nil)

;; " expands into csquotes macros (for this to work babel must be loaded after csquotes).
(setq LaTeX-csquotes-close-quote "}"
      LaTeX-csquotes-open-quote "\\enquote{")

;; LaTeX-math-mode http://www.gnu.org/s/auctex/manual/auctex/Mathematics.html
(add-hook 'TeX-mode-hook 'LaTeX-math-mode)

;;; RefTeX
;; Turn on RefTeX for AUCTeX http://www.gnu.org/s/auctex/manual/reftex/reftex_5.html
(add-hook 'TeX-mode-hook 'turn-on-reftex)

(eval-after-load 'reftex-vars; Is this construct really needed?
  '(progn
     (setq reftex-cite-prompt-optional-args t)
     (setq reftex-plug-into-AUCTeX t)
     ;; So that RefTeX also recognizes \addbibresource. Note that you
     ;; can't use $HOME in path for \addbibresource but that "~"
     ;; works.
     (setq reftex-bibliography-commands '("bibliography" "nobibliography" "addbibresource"))
                                        ;     (setq reftex-default-bibliography '("UNCOMMENT LINE AND INSERT PATH TO YOUR BIBLIOGRAPHY HERE")); So that RefTeX in Org-mode knows bibliography
     (setcdr (assoc 'caption reftex-default-context-regexps) "\\\\\\(rot\\|sub\\)?caption\\*?[[{]"); Recognize \subcaptions, e.g. reftex-citation
     (setq reftex-cite-format; Get ReTeX with biblatex, see http://tex.stackexchange.com/questions/31966/setting-up-reftex-with-biblatex-citation-commands/31992#31992
           '((?t . "\\textcite[]{%l}")
             (?a . "\\autocite[]{%l}")
             (?c . "\\cite[]{%l}")
             (?s . "\\smartcite[]{%l}")
             (?f . "\\footcite[]{%l}")
             (?n . "\\nocite{%l}")
             (?b . "\\blockcquote[]{%l}{}")))))

;; Fontification (remove unnecessary entries as you notice them) http://lists.gnu.org/archive/html/emacs-orgmode/2009-05/msg00236.html http://www.gnu.org/software/auctex/manual/auctex/Fontification-of-macros.html
(setq font-latex-match-reference-keywords
      '(
        ;; biblatex
        ("printbibliography" "[{")
        ("addbibresource" "[{")
        ;; Standard commands
        ;; ("cite" "[{")
        ("Cite" "[{")
        ("parencite" "[{")
        ("Parencite" "[{")
        ("footcite" "[{")
        ("footcitetext" "[{")
        ;; ;; Style-specific commands
        ("textcite" "[{")
        ("Textcite" "[{")
        ("smartcite" "[{")
        ("Smartcite" "[{")
        ("cite*" "[{")
        ("parencite*" "[{")
        ("supercite" "[{")
                                        ; Qualified citation lists
        ("cites" "[{")
        ("Cites" "[{")
        ("parencites" "[{")
        ("Parencites" "[{")
        ("footcites" "[{")
        ("footcitetexts" "[{")
        ("smartcites" "[{")
        ("Smartcites" "[{")
        ("textcites" "[{")
        ("Textcites" "[{")
        ("supercites" "[{")
        ;; Style-independent commands
        ("autocite" "[{")
        ("Autocite" "[{")
        ("autocite*" "[{")
        ("Autocite*" "[{")
        ("autocites" "[{")
        ("Autocites" "[{")
        ;; Text commands
        ("citeauthor" "[{")
        ("Citeauthor" "[{")
        ("citetitle" "[{")
        ("citetitle*" "[{")
        ("citeyear" "[{")
        ("citedate" "[{")
        ("citeurl" "[{")
        ;; Special commands
        ("fullcite" "[{")))

(setq font-latex-match-textual-keywords
      '(
        ;; biblatex brackets
        ("parentext" "{")
        ("brackettext" "{")
        ("hybridblockquote" "[{")
        ;; Auxiliary Commands
        ("textelp" "{")
        ("textelp*" "{")
        ("textins" "{")
        ("textins*" "{")
        ;; supcaption
        ("subcaption" "[{")))

(setq font-latex-match-variable-keywords
      '(
        ;; amsmath
        ("numberwithin" "{")
        ;; enumitem
        ("setlist" "[{")
        ("setlist*" "[{")
        ("newlist" "{")
        ("renewlist" "{")
        ("setlistdepth" "{")
        ("restartlist" "{")))

;; from customizer
'(server-mode t)
'(uniquify-buffer-name-style (quote post-forward) nil (uniquify))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(create-lockfiles nil)
 '(org-agenda-files
   (quote
    ("~/org/research.org" "~/org/school.org" "~/org/ideas.org"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; set path to same in bash shell
(defun set-exec-path-from-shell-PATH ()
  "Sets the exec-path to the same value used by the user shell"
  (let ((path-from-shell
         (replace-regexp-in-string
          "[[:space:]\n]*$" ""
          (shell-command-to-string "$SHELL -l -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

;; call function now
(set-exec-path-from-shell-PATH)

;; kill visible bell
(setq ring-bell-function 'ignore)

;; ESS mode config and load
(require 'ess-site)
(setq ess-ask-for-ess-directory nil)
(setq inferior-R-program-name "/usr/local/bin/R")
(setq ess-local-process-name "R")
(setq ansi-color-for-comint-mode 'filter)
(setq comint-scroll-to-bottom-on-input t)
(setq comint-scroll-to-bottom-on-output t)
(setq comint-move-point-for-output t)
(setq ess-eval-visibly-p nil)
(defun my-ess-post-run-hook ()
  (ess-execute-screen-options)
  (local-set-key "\C-cw" 'ess-execute-screen-options))
(add-hook 'ess-post-run-hook 'my-ess-post-run-hook)

;; org-mode
;; The following lines are always needed. Choose your own keys.
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-startup-indented t)
(setq org-log-done 'time)
(setq org-log-done 'note)
(setq org-directory "~/org")
(setq org-default-notes-file "~/org/notes.org")
(setq org-agenda-start-on-weekday 1)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (latex . t)
   (python . t)))
(setq org-confirm-babel-evaluate nil)
(add-hook 'org-babel-after-execute-hook 'org-display-inline-images)
(add-hook 'org-mode-hook 'org-display-inline-images)
(add-hook 'org-mode-hook
          (lambda ()
            (visual-line-mode t)
            (writegood-mode t)
            (flyspell-mode t)))
(setq org-agenda-files (list "~/org/school.org"
                             "~/org/ideas.org"
                             ))
(setq org-todo-keywords '("TODO" "IN-PROGRESS" "WAITING" "DONE"))
(setq org-tag-alist '(("@work" . ?w)
                      ("@home" . ?h)
                      ("reading" . ?r)
                      ("writing" . ?t)))

;;; org-mode time summary block
(defun org-dblock-write:rangereport (params)
  "Display day-by-day time reports."
  (let* ((ts (plist-get params :tstart))
         (te (plist-get params :tend))
         (start (time-to-seconds
                 (apply 'encode-time (org-parse-time-string ts))))
         (end (time-to-seconds
               (apply 'encode-time (org-parse-time-string te))))
         day-numbers)
    (setq params (plist-put params :tstart nil))
    (setq params (plist-put params :end nil))
    (while (<= start end)
      (save-excursion
        (insert "\n\n"
                (format-time-string (car org-time-stamp-formats)
                                    (seconds-to-time start))
                "----------------\n")
        (org-dblock-write:clocktable
         (plist-put
          (plist-put
           params
           :tstart
           (format-time-string (car org-time-stamp-formats)
                               (seconds-to-time start)))
          :tend
          (format-time-string (car org-time-stamp-formats)
                              (seconds-to-time end))))
        (setq start (+ 86400 start))))))

;; org mode outline block
(defun reading-notes ()
  "Insert standard reading notes template."
  (interactive)
  (insert "#+TITLE:\n#+AUTHOR: Joe Sutherland
#+EMAIL: joseph.sutherland@columbia.edu
#+LANGUAGE: en
#+OPTIONS: toc:nil num:nil ':t *:t -:t email:t

#+LaTeX_HEADER: \\usepackage[lf]{MinionPro}
#+LaTeX_HEADER: \\usepackage{microtype}
#+LaTeX_HEADER: \\usepackage[labelfont=bf]{caption}

* What is the research question?
* Why is that an important question?
* What is their argument?
* What is their answer?
* What is their evidence?
* What are their conclusions?
* Is the evidence for their answer convincing? Why?
* Is their answer correct? Might it be improved?"))
