;; List of installed packages:
;; 
;; php-mode
;; lsp-mode
;;   intelephense as php language server
;; lsp-ui
;; company
;; diff-hl
;; magit
;; mardown-mode
;;   pandoc as converter
;; which-key
;; ssh-deploy

;; Свой стартовый буфер ----------------
(setq initial-buffer-choice "~/.emacs.d/start.org")

;; minor mode для стартовой страницы
(define-minor-mode sv-start-mode
  "Minor mode for start page."
  :lighter " start"
  (setq-local org-link-elisp-confirm-function nil))

(provide 'sv-start-mode)

;; Отключение стандартного интерфейса
(menu-bar-mode -1)   ;; меню сверху
(tool-bar-mode -1)   ;; полоска инструментов сверху
(scroll-bar-mode -1) ;; полоска скролла файла

;; Сохранение и открытие последней сессии при запуске emacs
;(desktop-save-mode 1)

;; Отображение номеров строк и столбцов
(global-display-line-numbers-mode 1)
(setq column-number-mode t)

;; Сохранение и открытие последней сессии при запуске emacs
;(desktop-save-mode 1)

;; [личное] Расширение окна при старте на полный экран, по хорошему поведение должно задаваться оконным менеджером
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Подключение репозитория с модами(пакетами) - melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Автоматически генерируемый код при установке модов. НЕ изменять!
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(tango-dark))
 '(custom-safe-themes
   '("f5f80dd6588e59cfc3ce2f11568ff8296717a938edd448a947f9823a4e282b66" default))
 '(highlight-indent-guides-method 'character)
 '(org-agenda-files '("~/.emacs.d/start.org"))
 '(package-selected-packages
   '(highlight-indent-guides doom-themes diff-hl ssh-deploy company which-key markdown-preview-mode lsp-ui magit lsp-mode php-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Theme

(load-theme 'doom-monokai-pro)

;; Indetions (too slow)

; (add-hook 'php-mode-hook 'highlight-indent-guides-mode)
; (add-hook 'html-mode-hook 'highlight-indent-guides-mode)

;; org-mode ----------------------------
(require 'org)

;; magit -------------------------------

;; open magit status in same window as current buffer
;; (setq magit-status-buffer-switch-function 'switch-to-buffer)

;; highlight word/letter changes in hunk diffs
(setq magit-diff-refine-hunk t)

;; LSP-mode ----------------------------

;; Настройки производительности для lsp-mode
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1 mb

(require 'lsp-mode)

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-file-watch-ignored-directories "[/\\\\]\\.bitrix\\'"))

;; чтобы не отображалось предупреждение на больших проектах
(setq lsp-file-watch-threshold 100000)

;; Префикс для команд lsp-mode
(setq lsp-keymap-prefix "C-c l")

;; Запускать lsp сервер при открытии файла с php-mode 
(add-hook 'php-mode-hook 'lsp)
;(add-hook 'php-mode-hook #'lsp-deferred) ;; until the buffer is visible

;; Интеграция с which-key-mode
(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-php))
;; Розобраться как сделать: "enable which-key integration for all major modes by passing t as a parameter"

;; lsp-ui ------------------------------
(setq lsp-ui-doc-show-with-cursor t) ;; почему-то не работает из коробки
(setq lsp-ui-doc-delay 0.3)
(setq lsp-ui-doc-position 'bottom) ;; at-point | bottom | top
;; в вариантах "top" и "bottom" окно с доком не учитывает,
;; что может быть открыто несколько окон: отображается в углу фрейма

;; php-mode ----------------------------
(add-hook 'php-mode-hook 'php-enable-default-coding-style)
(add-hook 'php-mode-hook 'lsp)

;; which-key-mode ----------------------
(which-key-mode)

;; Dap-mode ---------------------------

;; Для дебага через xdebug в PHP проектах

;(require 'dap-php)
;(dap-php-setup)

;; Markdown-mode -----------------------
(setq markdown-command '("pandoc" "--from=markdown" "--to=html5"))

;; ssh-deploy --------------------------
(require 'ssh-deploy)
(ssh-deploy-add-after-save-hook)

;; diff-hl -----------------------------
(global-diff-hl-mode)
(diff-hl-flydiff-mode)
(add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)

