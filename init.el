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
 '(package-selected-packages (quote (magit enh-ruby-mode solarized-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; why does this need to come after?
(load-theme 'solarized-dark)
