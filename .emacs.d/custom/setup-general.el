(menu-bar-mode -1)
(tool-bar-mode -1)

(setq split-width-threshold 0)
(setq gc-cons-threshold 100000000)
(setq inhibit-startup-message t)

;; set c++-mode default for .c and .h
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.c\\'" . c++-mode))

;; misc
(defalias 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "C-1") 'delete-other-windows)

;; show unncessary whitespace that can mess up your diff
(add-hook 'prog-mode-hook
          (lambda () (interactive)
            (setq show-trailing-whitespace 1)))

;; use space to indent by default
(setq-default indent-tabs-mode nil)

;; set appearance of a tab that is represented by 2 spaces
(setq-default tab-width 2)

;; Compilation
(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (setq-local compilation-read-command nil)
                               (call-interactively 'compile)))

;; setup GDB
(setq
 ;; use gdb-many-windows by default
 gdb-many-windows t

 ;; Non-nil means display source file containing the main routine at startup
 gdb-show-main t
 )

;; sr-speedbar
(use-package sr-speedbar
  :init)
  (global-set-key (kbd "C-c b") 'sr-speedbar-toggle)

;; company
(use-package company
  :init
  (global-company-mode 1)
  (delete 'company-clang company-backends)
  (delete 'company-semantic company-backends)
  (add-hook 'after-init-hook 'global-company-mode))

;; cc-mode
(use-package cc-mode
  :init)
  (define-key c++-mode-map  [(tab)] 'company-complete)

;; style I want to use in c++ mode
(c-add-style "my-style"
             '("stroustrup"
               (c-basic-offset . 2)
               (c-offsets-alist . ((inline-open . 0)
                                   (brace-list-open . 0)
                                   (statement-case-open . +)))))

(defun my-c++-mode-hook ()
  (c-set-style "my-style")
  (auto-fill-mode)
  (c-toggle-auto-hungry-state 1))

(add-hook 'c++-mode-hook 'my-c++-mode-hook)

;; company-c-headers
(use-package company-c-headers
  :init
  (add-to-list 'company-backends 'company-c-headers))
  (add-to-list 'company-c-headers-path-system "/usr/include/c++/5/")

(provide 'setup-general)
