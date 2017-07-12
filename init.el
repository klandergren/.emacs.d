;; TODO: make gui / terminal guarded init behavior

;; startup
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


(sleep-for 0 50)
;; Start fullscreen (cross-platf)
(add-hook 'window-setup-hook 'toggle-frame-fullscreen)

;;(add-to-list 'default-frame-alist '(fullscreen . maximized))

(toggle-scroll-bar -1)

;; control full screen
(global-set-key (kbd "s-F") 'toggle-frame-fullscreen)
