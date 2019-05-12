;; TODO: make gui / terminal guarded init behavior

;; startup
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(setq package-archive-priorities '(("melpa" . 10) ("gnu" . 0)))


(setq
 inhibit-startup-screen t)

;; backups
(setq
   backup-by-copying t
   backup-directory-alist
    '(("." . "~/.emacs.d/.backups"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

;; disable lock files (prefixed with '#' and '.')
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

;; save desktop
(setq desktop-path '("~/.emacs.d/.backups"))
(desktop-save-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(gnutls-trustfiles
   (quote
    ("/etc/ssl/certs/ca-certificates.crt" "/etc/pki/tls/certs/ca-bundle.crt" "/etc/ssl/ca-bundle.pem" "/usr/ssl/certs/ca-bundle.crt" "/usr/local/share/certs/ca-root-nss.crt" "/Users/klandergren/.emacs.d/cacert.pem")))
 '(package-selected-packages
   (quote
    (swift-mode web-mode markdown-mode yaml-mode magit enh-ruby-mode solarized-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; why does this need to come after?
(load-theme 'solarized-dark)

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
