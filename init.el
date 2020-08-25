;; https://emacs.stackexchange.com/questions/5552/emacs-on-android-org-mode-error-wrong-type-argument-stringp-require-t
(defun load-history-filename-element (file-regexp)
  "Get the first elt of `load-history' whose car matches FILE-REGEXP.
        Return nil if there isn't one."
  (let* ((loads load-history)
         (load-elt (and loads (car loads))))
    (save-match-data
      (while (and loads
                  (or (null (car load-elt))
                      (not (and (stringp (car load-elt)) ; new condition
                                (string-match file-regexp (car load-elt))))))
        (setq loads (cdr loads)
              load-elt (and loads (car loads)))))
    load-elt))

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(setq package-archive-priorities '(("melpa" . 10) ("gnu" . 0)))

(package-initialize)

(setq inhibit-startup-screen t)

;; backups
(setq
   backup-by-copying t
   backup-directory-alist
    '(("." . "~/.emacs.d/.backups"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

;;; autosave
(defvar autosave-dir (expand-file-name "~/.emacs.d/.autosave/"))
(setq auto-save-list-file-prefix autosave-dir)
(setq auto-save-file-name-transforms `((".*" ,autosave-dir t)))

(setq create-lockfiles nil)

;; allows for full-screen open from spotlight when another application
;; is already full screen
(sleep-for 0 50)

;; Start fullscreen (cross-platf)
(add-hook 'window-setup-hook 'toggle-frame-fullscreen)

;;(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; control full screen
(global-set-key (kbd "s-F") 'toggle-frame-fullscreen)

;; use 80 if possible
(setq-default fill-column 79)

;; UI setup
(toggle-scroll-bar -1)
(add-hook 'prog-mode-hook #'linum-mode)

;; window movement
(global-set-key (kbd "M-s-<left>") 'windmove-left)
(global-set-key (kbd "M-s-<right>") 'windmove-right)
(global-set-key (kbd "M-s-<up>") 'windmove-up)
(global-set-key (kbd "M-s-<down>") 'windmove-down)

;; buffer movement
(global-set-key (kbd "s-<left>") 'previous-buffer)
(global-set-key (kbd "s-<right>") 'next-buffer)

;; save desktop
;; (setq desktop-path '("~/.emacs.d/.backups"))
;; (desktop-save-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(gnutls-trustfiles
   (quote
    ("/etc/ssl/certs/ca-certificates.crt" "/etc/pki/tls/certs/ca-bundle.crt" "/etc/ssl/ca-bundle.pem" "/usr/ssl/certs/ca-bundle.crt" "/usr/local/share/certs/ca-root-nss.crt" "/Users/klandergren/.emacs.d/cacert.pem")))
 '(package-selected-packages
   (quote
    (go-mode command-log-mode flx-ido flx projectile yasnippet swift-mode web-mode markdown-mode yaml-mode magit enh-ruby-mode solarized-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; why does this need to come after?
(load-theme 'solarized-dark t)

;; magit
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)


;; disable bell
(setq ring-bell-function 'ignore)

;; authoring
(global-set-key (kbd "M-_") (kbd "—")) ; em dash

;; curly quotes
(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'typopunct)
(add-hook 'web-mode-hook 'typopunct-mode)
(add-to-list 'typopunct-mode-exeptions-alist 
             '(web-mode . typopunct-point-in-xml-tag-p))

;; spell check
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)
(setq ispell-program-name "/usr/local/bin/ispell")
(setq ispell-local-dictionary "english")
(set-default 'ispell-skip-html t)

(add-hook 'yaml-mode-hook
	  '(lambda ()
	     (define-key yaml-mode-map "\C-m" 'newline-and-indent)))
(add-hook 'yaml-mode-hook
	  '(lambda ()
	     (define-key yaml-mode-map (kbd "<backtab>") 'yaml-electric-backspace)))
(add-hook 'yaml-mode-hook #'linum-mode)

;; web-mode for HTML and CSS. http://web-mode.org/
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.css?\\'" . web-mode))

;; web-mode customizations
(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-enable-auto-indentation nil) ;; prevents indent on yank, which screws up YAML
  (setq-default indent-tabs-mode nil)
)
(add-hook 'web-mode-hook 'my-web-mode-hook)
(setq web-mode-extra-snippets
      ;; nil is the templating engine web-mode expects. in this case normal operation.
      '((nil . (("section" . "<section>\n<h2>|</h2>\n</section>")
                ("section2" . "<section>\n<h2>|</h2>\n</section>")
                ("section3" . "<section>\n<h3>|</h3>\n</section>")
                ("section4" . "<section>\n<h4>|</h4>\n</section>")
                ("section5" . "<section>\n<h5>|</h5>\n</section>")
                ("section6" . "<section>\n<h6>|</h6>\n</section>")
                ("kbd-command" . "<kbd class=\"key\">⌘ Command</kbd>")
                ("kbd-control" . "<kbd class=\"key\">⌃ Control</kbd>")
                ("kbd-down-arrow" . "<kbd class=\"key\">↓</kbd>")
                ("kbd-enter" . "<kbd class=\"key\">↵ Enter</kbd>")
                ("kbd-esc" . "<kbd class=\"key\">⎋ Esc</kbd>")
                ("kbd-key" . "<kbd class=\"key\">|</kbd>")
                ("kbd-left-arrow" . "<kbd class=\"key\">←</kbd>")
                ("kbd-meta" . "<kbd class=\"key\">⌥ Option</kbd>")
                ("kbd-option" . "<kbd class=\"key\">⌥ Option</kbd>")
                ("kbd-return" . "<kbd class=\"key\">↵ Return</kbd>")
                ("kbd-right-arrow" . "<kbd class=\"key\">→</kbd>")
                ("kbd-shift" . "<kbd class=\"key\">⇧ Shift</kbd>")
                ("kbd-space" . "<kbd class=\"key\">SPACE</kbd>")
                ("kbd-super" . "<kbd class=\"key\">⌘ Command</kbd>")
                ("kbd-tab" . "<kbd class=\"key\">↹ Tab</kbd>")
                ("kbd-up-arrow" . "<kbd class=\"key\">↑</kbd>")
                ("list" . "<ul>\n<li>|</li>\n</ul>")
                ("2-cols" . "<tr>\n<td>|</td>\n<td></td>\n</tr>")
                ("3-cols" . "<tr>\n<td>|</td>\n<td></td>\n<td></td>\n</tr>")
                ("code" . "<pre><code>|</code></pre>")
                     ))))

;; jekyll specific
(defun toggle-between-web-mode-and-yaml-mode ()
  (interactive)
  (cond ((eq major-mode 'web-mode) (yaml-mode))
        ((eq major-mode 'yaml-mode) (web-mode))))
(global-set-key (kbd "C-c m") 'toggle-between-web-mode-and-yaml-mode)

;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)

(setq yas-prompt-functions '(
                             yas-ido-prompt
                             yas-x-prompt))

(setq yas-indent-line 'fixed)

;; flx-ido
(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

;; projectile for code project utilities
(projectile-mode +1)
(setq projectile-project-search-path '("~/Projects/"))
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "s-f") 'projectile-find-file)
(define-key projectile-mode-map (kbd "s-g") 'projectile-grep)

;; command-log-mode
(require 'command-log-mode)
(setq command-log-mode-window-size 80
      command-log-mode-is-global t)
(global-command-log-mode 1)
;; hack. creates *command-log* so commands are recorded
(clm/open-command-log-buffer)
(clm/close-command-log-buffer)

;; swift-mode
(setq swift-mode:basic-offset 2)

;; highlight the line of the cursor in the active buffer
(global-hl-line-mode 1)

;; go-mode
(add-to-list 'exec-path "~/go/bin/") ;; hack. PATH hard to get right
(setq gofmt-command "goimports")
(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt-before-save)
            (setq tab-width 2)))

;; dired configuration
(require 'ls-lisp)
(setq ls-lisp-use-insert-directory-program nil) ;; use emulated ls-lisp.el with dired
(setq ls-lisp-dirs-first t)
(put 'dired-find-alternate-file 'disabled nil)
