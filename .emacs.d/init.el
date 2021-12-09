;;;; init.el -- init file for emacs

;; Set default frame size 132x60.
(add-to-list 'default-frame-alist '(width  . 132))
(add-to-list 'default-frame-alist '(height . 36))
;; Set default font using 'font-config' font name.
(add-to-list 'default-frame-alist
             '(font . "M+ 1mn-16"))
(setq initial-frame-alist default-frame-alist)

(set-language-environment "Japanese")
;(set-language-info "Japanese" 'input-method "macOS")
(global-set-key (kbd "C-j") 'toggle-input-method)
;; On macOS, emacs-mozc is unnessesary
;;(require 'mozc)  ; or (load-file "/path/to/mozc.el")
;;(setq default-input-method "japanese-mozc")

;; Macの日本語キーボードで\が打てない
;; このため、強制的に￥を\に修正する
(define-key global-map [?¥][?\\])

;; マウスサポートをオン
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (defun track-mouse (e))
  (setq mouse-sel-mode≈≈x t))

;; M-xで入力モードをAsciiに落としたい
;; GUIモードでのみ有効
(mac-auto-ascii-mode 1)

;; ハイパーキーのキーバインド
;; GUIモードでのみ有効
(global-set-key (kbd "H-a") 'mark-whole-buffer)
(global-set-key (kbd "H-v") 'yank)
(global-set-key (kbd "H-c") 'kill-ring-save)
(global-set-key (kbd "H-s") 'save-buffer)
(global-set-key (kbd "H-l") 'goto-line)
(global-set-key (kbd "H-w")
                 (lambda () (interactive) (delete-window)))
(global-set-key (kbd "H-z") 'undo)

;; テーマカラーを tango-dark に
(load-theme 'tango-dark t)

;; Put the emacs' custom section outside the 'init.el'.
(setq custom-file (locate-user-emacs-file "custom.el"))
;; When not exist 'custom.el', create it.
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
;; read custom-file
(load custom-file)

;; disable tool-bar
;;(tool-bar-mode -1)

;; set TAB width 4 and inhibit using TAB('^i') code.
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

;; When save a file, delete trailing SPACEs.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; 日付を挿入する関数
(defun insert-date (prefix)
  "Insert the current date in Japanese format. With prefix (C-u),
   use ISO format."
  (interactive "P")
  (let ((format (cond
                 ((not prefix) "%Y年%-m月%-d日(%a)")
                 ((equal prefix '(4)) "%Y-%m-%d %H:%M:%S %Z")))
                 ;((equal prefix '(16)) "%A, %d. %B %Y")))
        (system-time-locale "ja_JP"))
    (insert (format-time-string format))))
(global-set-key (kbd "C-c d") 'insert-date)

;;; パッケージ管理の初期化
;; add 'melpa' to package archives and initialize 'package'.
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("org" . "https://orgmode.org/elpa/") t)
(package-initialize)

;; refresh package list if needed
(when (not package-archive-contents)
  (package-refresh-contents))

;; use-package
;; to init 'use-package', these lines must precede the package initialization code.
(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
  (add-to-list 'load-path "~/.emacs.d/elpa")
  (require 'use-package))

(when (not (package-installed-p 'use-package))
  (package-install 'use-package))
(require 'use-package)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown")
        (setq markdown-fontify-code-blocks-natively t))

(use-package adoc-mode
  :ensure t
  :mode ("\\.adoc\\'" . adoc-mode))

(use-package yaml-mode
  :ensure t
  :mode (("\\.yml\\'" . yaml-mode)
         ("\\.yaml\\'" . yaml-mode)))

(use-package which-key
  :ensure t
  :config (which-key-mode))

;; emojify 🔥
;; use "M-x emojify-list-emojis" to list all emojis
(use-package emojify
  :ensure t
  :hook (alert-init . global-emoji-mode)
  :bind ("C-x e" . 'emojify-apropos-emoji))
  ;; :bind ("C-x e" . 'emojify-insert-emoji))
