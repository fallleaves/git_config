(menu-bar-mode -1)
(tool-bar-mode -1)
(toggle-scroll-bar -1)

;; automatically open window horizonlly or vertically
;;(setq split-width-threshold 0)
;;(setq split-height-threshold nil)
(defun display-new-buffer (buffer force-other-window)
  (or (get-buffer-window buffer)
    (if (one-window-p)
      (let ((new-win
            (if (> (window-width) 100)
            (split-window-horizontally)
            (split-window-vertically))))
        (set-window-buffer new-win buffer)
        new-win)
      (let ((new-win (get-lru-window)))
        (set-window-buffer new-win buffer)
        new-win))))
(setq display-buffer-function 'display-new-buffer)

(defun window-toggle-split-direction ()
  (interactive)
  (require 'windmove)
  (let ((done))
    (dolist (dirs '((right . down) (down . right)))
      (unless done
        (let* ((win (selected-window))
               (nextdir (car dirs))
               (neighbour-dir (cdr dirs))
               (next-win (windmove-find-other-window nextdir win))
               (neighbour1 (windmove-find-other-window neighbour-dir win))
               (neighbour2 (if next-win (with-selected-window next-win
                                          (windmove-find-other-window neighbour-dir next-win)))))
          (setq done (and (eq neighbour1 neighbour2)
                          (not (eq (minibuffer-window) next-win))))
          (if done
              (let* ((other-buf (window-buffer next-win)))
                (delete-window next-win)
                (if (eq nextdir 'right)
                    (split-window-vertically)
                  (split-window-horizontally))
                (set-window-buffer (windmove-find-other-window neighbour-dir) other-buf))))))))
(global-set-key (kbd "C-2") 'window-toggle-split-direction)

(setq gc-cons-threshold 100000000)
(setq inhibit-startup-message t)

;; set c++-mode default for .c and .h
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.c\\'" . c++-mode))

;; misc
(defalias 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "C-1") 'delete-other-windows)
(global-set-key (kbd "C-0") 'delete-window)
(global-linum-mode 1)
(setq compile-command "make -k -j4 ")
(setq display-buffer-alist '(("\\`\\*e?shell" display-buffer-pop-up-window)))
(global-set-key (kbd "C-c t") 'shell)
(add-hook 'window-setup-hook 'toggle-frame-fullscreen t)
(require 'recentf)
(recentf-mode 1)
(global-set-key (kbd "C-x f") 'recentf-open-files)

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
  (c-toggle-hungry-state 1))

(add-hook 'c++-mode-hook 'my-c++-mode-hook)

;; company-c-headers
(use-package company-c-headers
  :init
  (add-to-list 'company-backends 'company-c-headers))
  (add-to-list 'company-c-headers-path-system "/usr/include/c++/5/")

(provide 'setup-general)
