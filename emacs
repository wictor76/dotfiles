;; believe me, you don't need menubar(execpt OSX), toolbar nor scrollbar
(and (fboundp 'menu-bar-mode)
     (not (eq system-type 'darwin))
     (menu-bar-mode -1))
(dolist (mode '(tool-bar-mode scroll-bar-mode))
  (when (fboundp mode) (funcall mode -1)))


(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; autosave & backup
(defvar my-autosave-dir
  (expand-file-name "autosaves" user-emacs-directory))

(make-directory my-autosave-dir t)

(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))

(defun make-auto-save-file-name ()
  (concat my-autosave-dir
          (if buffer-file-name
              (concat "#" (file-name-nondirectory buffer-file-name) "#")
            (expand-file-name
             (concat "#%" (buffer-name) "#")))))

(defvar backup-dir (expand-file-name "autosaves" user-emacs-directory))
(setq backup-directory-alist (list (cons "." backup-dir)))

;; delete whitespace before save
(add-hook 'before-save-hook 'delete-trailing-whitespace)



(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; monokai theme
(use-package monokai-theme
  :ensure monokai-theme
  :config
  (progn (load-theme 'monokai t)))

;; utf-8
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

(setq current-language-environment "UTF-8")
(setq default-input-method "rfc1345")

(prefer-coding-system 'utf-8)

;; Title
(setq frame-title-format
  '("Emacs - " (buffer-file-name "%f"
    (dired-directory dired-directory "%b"))))

(use-package spaceline-config
  :ensure spaceline
  :config (progn
            (setq spaceline-workspace-numbers-unicode nil)
            (spaceline-spacemacs-theme)

            (set-face-attribute 'powerline-active1 nil :background "grey22" :foreground "white smoke")
            (set-face-attribute 'powerline-active2 nil :background "grey40" :foreground "gainsboro")
            (set-face-attribute 'powerline-inactive1 nil :background "grey55" :foreground "white smoke")
            (set-face-attribute 'powerline-inactive2 nil :background "grey65" :foreground "gainsboro")
            (powerline-reset)
            ))

;;(require 'evil)
;;(evil-mode t)

(set-face-attribute 'default nil :height 60) ; The value is in 1/10pt, so 100 will give you 10pt, etc. 
;;(when window-system (set-frame-size (selected-frame) 160 60))


(setq inhibit-startup-message t)
(setq-default fill-column 80)
(global-linum-mode t)
(column-number-mode)
(show-paren-mode t)
(which-function-mode 1)
(fset 'yes-or-no-p 'y-or-n-p)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(setq-default tab-stop-list (number-sequence 4 200 4))
(setq-default c-default-style "linux")
(setq-default c-basic-offset 4)
(c-set-offset 'comment-intro 0)


(define-prefix-command 'f2-global-map)
(bind-key "<f2>" #'f2-global-map)

(defun my-set-menu-key (char func)
  (bind-key (concat "s-" char) func)
  (bind-key char func f2-global-map))

 ;; ========== Line by line scrolling ==========

;; This makes the buffer scroll by only a single line when the up or
;; down cursor keys push the cursor (tool-bar-mode) outside the
;; buffer. The standard emacs behaviour is to reposition the cursor in
;; the center of the screen, but this can make the scrolling confusing

;;(setq scroll-step 1)
(setq redisplay-dont-pause t
  scroll-margin 3
  scroll-step 1
  scroll-conservatively 10000
  scroll-preserve-screen-position 1)

;;(setq scroll-margin 3
;;scroll-conservatively 1000
;;scroll-up-aggressively 0.01
;;scroll-down-aggressively 0.01)

;; Page down/up move the point, not the screen.
;; In practice, this means that they can move the
;; point to the beginning or end of the buffer.
(defun sfp-page-down ()
  (interactive)
  (setq this-command 'next-line)
  (next-line
   (- (window-text-height)
      next-screen-context-lines)))

(defun sfp-page-up ()
  (interactive)
  (setq this-command 'previous-line)
  (previous-line
   (- (window-text-height)
      next-screen-context-lines)))

(global-set-key [next] 'sfp-page-down)
(global-set-key [prior] 'sfp-page-up)

;; highlight nested parentheses in different colours
(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
)



(use-package projectile
  :ensure t
  :commands (projectile-global-mode projectile-ignored-projects projectile-compile-project)
  :init (progn
     (projectile-global-mode)
     (global-set-key (kbd "<f5>") 'projectile-compile-project))
  :config (progn
     (setq projectile-completion-system 'helm)
     (setq projectile-switch-project-action 'helm-projectile)
     ))

(global-set-key (kbd "<f6>") 'next-error)


(use-package eyebrowse
  :ensure t
  :diminish eyebrowse-mode
  :init (setq eyebrowse-keymap-prefix (kbd "C-c C-\\"))
  :config (progn
            (setq eyebrowse-wrap-around t)
            (eyebrowse-mode t)

            (defun my-eyebrowse-new-window-config ()
              (interactive)
              (let ((done nil))
                (dotimes (i 10)
                  ;; start at 1 run till 0
                  (let ((j (mod (+ i 1) 10)))
                    (when (and (not done)
                               (not (eyebrowse--window-config-present-p j)))
                      (eyebrowse-switch-to-window-config j)
                      (eyebrowse-rename-window-config j)
                      (setq done t)
                      ))
                  )))

            (require 'latex-preview-pane)
            (defun my-close-latex-preview-pane-before-eyebrowse-switch ()
              ;; latex-preview-pane uses window-parameters which are not preserved by eyebrowse, so
              ;; we close the preview pane before switching, it will be regenerated when we edit the
              ;; TeX file.
              (when (lpp/window-containing-preview)
                (delete-window (lpp/window-containing-preview))))

            (add-to-list 'eyebrowse-pre-window-switch-hook
                         #'my-close-latex-preview-pane-before-eyebrowse-switch)

            (my-set-menu-key "["  #'my-eyebrowse-new-window-config)
            (my-set-menu-key ";"  #'eyebrowse-prev-window-config)
            (my-set-menu-key "'"  #'eyebrowse-next-window-config)
            (my-set-menu-key "]"  #'eyebrowse-close-window-config)
            (my-set-menu-key "\\" #'eyebrowse-rename-window-config)))


;;(defcustom helm-baloo-file-limit 100
;;  "Limit number of entries returned by baloo to this number."
;;  :group 'helm-baloo
;;  :type '(integer :tag "Limit"))


;;(defun baloo-search (pattern)
;;  (start-process "baloosearch" nil "baloosearch" (format "-l %d " helm-baloo-file-limit) pattern))

;;(defun helm-baloo-search ()
;;  (baloo-search helm-pattern))

;;(defun helm-baloo-transform (cs)
;;  (let '(helm-baloo-clean-up-regexp (rx (or
;;                                         control
;;                                         (seq "[0;31m" (+ (not (any "["))) "[0;0m")
;;                                         "[0;32m"
;;                                         "[0;0m")))
;;    (mapcar (function (lambda (c)
;;                        (replace-regexp-in-string
;;                         (rx (seq bol (+ space))) ""
;;                         (replace-regexp-in-string helm-baloo-clean-up-regexp "" c))))
;;            cs)))

;;(defvar helm-source-baloo
;;  (helm-build-async-source "Baloo"
;;    :candidates-process #'helm-baloo-search
;;    :candidate-transformer #'helm-baloo-transform
;;    :action '(("Open" . (lambda (x) (find-file x)
;;                          )))))

;;(defun helm-baloo ()
;;  (interactive)
;;  (helm :sources helm-source-baloo
;;        :buffer "*helm baloo*"))

(defun my-helm-omni (&rest arg)
  ;; just in case someone decides to pass an argument, helm-omni won't fail.
  (interactive)
  (unless helm-source-buffers-list
    (setq helm-source-buffers-list
          (helm-make-source "Buffers" 'helm-source-buffers)))
  (helm-other-buffer
   (append

    (if (projectile-project-p)
        '(helm-source-projectile-buffers-list
          helm-source-buffers-list)
      '(helm-source-buffers-list)) ;; list of all open buffers

    `(((name . "Virtual Workspace")
       (candidates . ,(--map (cons  (eyebrowse-format-slot it) (car it))
                             (eyebrowse--get 'window-configs)))
       (action . (lambda (candidate)
                   (eyebrowse-switch-to-window-config candidate))
               )))

    (if (projectile-project-p)
        '(helm-source-projectile-recentf-list
          helm-source-recentf)
      '(helm-source-recentf)) ;; all recent files

    ;; always make some common files easily accessible
    '(((name . "Common Files")
       (candidates . my-common-file-targets)
       (action . (("Open" . (lambda (x) (find-file (eval x))))))))

    (if (projectile-project-p)
        '(helm-source-projectile-files-list
          helm-source-files-in-current-dir)
      '(helm-source-files-in-current-dir)) ;; files in current directory

    '(helm-source-locate               ;; file anywhere
      ;;helm-source-baloo                ;; baloo search
      helm-source-bookmarks            ;; bookmarks too
      helm-source-buffer-not-found     ;; ask to create a buffer otherwise
      )

    ;; adding helm-source-imenu-anywhere does some weird pre-filtering
    '(((name . "imenu-anywere")
       (candidates . helm-imenu-anywhere-candidates)
       (action .
               #[(elm)
                 "\301\302�\"\207"
                 [elm imenu-anywhere--goto-function ""]
                 3])))
    ) "*Helm all the things*"))

(use-package helm
  :ensure helm
  :diminish helm-mode
  :bind (("M-x"     . helm-M-x)
         ("C-x C-b" . my-helm-omni)
         ("C-x C-f" . helm-find-files)
         ("C-h <SPC>" . helm-all-mark-rings))
  :config (progn
         (require 'helm-config)
         (bind-key "C-c h" #'helm-command-prefix)
            (unbind-key "C-x c")

            (setq helm-adaptive-mode t
                  helm-apropos-fuzzy-match t
                  helm-bookmark-show-location t
                  helm-buffer-max-length 48
                  helm-buffers-fuzzy-matching t
                  helm-completion-in-region-fuzzy-match t
                  helm-display-header-line t
                  helm-ff-skip-boring-files t
                  helm-lisp-fuzzy-completion t
                  helm-imenu-fuzzy-match t
                  helm-input-idle-delay 0.01
                  helm-mode-fuzzy-match t
                  helm-org-headings-fontify t
                  helm-recentf-fuzzy-match t
                  helm-split-window-in-side-p t
                  helm-truncate-lines nil)

            (when (executable-find "curl")
              (setq helm-google-suggest-use-curl-p t))

            (helm-mode t)

            ;; manipulating these lists must happen after helm-mode was called
            (add-to-list 'helm-boring-buffer-regexp-list "\\*CEDET Global\\*")

            (delete "\\.bbl$" helm-boring-file-regexp-list)
            (add-to-list 'helm-boring-file-regexp-list "\\.nav" t)
            (add-to-list 'helm-boring-file-regexp-list "\\.out" t)
            (add-to-list 'helm-boring-file-regexp-list "\\.snm" t)

            ;; rebind tab to do persistent action
            (bind-key "<tab>" 'helm-execute-persistent-action helm-map)
            ;; make TAB works in terminal
            (bind-key "C-i"   'helm-execute-persistent-action helm-map)
            ;; list actions using C-z
            (bind-key "C-z"   'helm-select-action             helm-map)
            )
  )


(use-package helm-swoop
  :ensure t
  :bind (("C-c C-SPC" . helm-swoop)
         ("C-c o" . helm-multi-swoop-all)
         ("C-s"   . helm-swoop)
         ("C-r"   . helm-resume)))

(use-package ag
  :ensure t)

(use-package helm-ag
  :ensure t
  :config (setq helm-ag-base-command "ag --nocolor --nogroup --ignore-case"
                helm-ag-command-option "--all-text"
                helm-ag-insert-at-point 'symbol
                helm-ag-fuzzy-match t
                helm-ag-use-grep-ignore-list t
                helm-ag-use-agignore t))


(use-package helm-projectile
  :ensure t)

;(use-package helm-ring
;  :bind (("M-y"     . helm-show-kill-ring)))


(use-package semantic
  :init (progn
          (use-package semantic/ia)
          (use-package semantic/bovine/gcc)

          (add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
          (add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
          (add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)
          ;;(add-to-list 'semantic-default-submodes 'global-semantic-decoration-mode)
          (add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)
          (add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
          (add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode)
          (semanticdb-enable-gnu-global-databases 'c-mode t)
          (semanticdb-enable-gnu-global-databases 'c++-mode t)
          (setq semanticdb-default-save-directory (expand-file-name "semantic" user-emacs-directory))

          (semantic-mode 1)
          (global-ede-mode t)
          (ede-enable-generic-projects)

          (defun my-inhibit-semantic-p ()
            (not (member major-mode '(c-mode c++-mode))))

          (add-to-list 'semantic-inhibit-functions #'my-inhibit-semantic-p)))

;; Grey out #if 0
(defun my-c-mode-font-lock-if0 (limit)
  (save-restriction
    (widen)
    (save-excursion
      (goto-char (point-min))
      (let ((depth 0) str start start-depth)
        (while (re-search-forward "^\\s-*#\\s-*\\(if\\|else\\|endif\\)" limit 'move)
          (setq str (match-string 1))
          (if (string= str "if")
              (progn
                (setq depth (1+ depth))
                (when (and (null start) (looking-at "\\s-+0"))
                  (setq start (match-end 0)
                        start-depth depth)))
            (when (and start (= depth start-depth))
              (c-put-font-lock-face start (match-beginning 0) 'font-lock-comment-face)
              (setq start nil))
            (when (string= str "endif")
              (setq depth (1- depth)))))
        (when (and start (> depth 0))
          (c-put-font-lock-face start (point) 'font-lock-comment-face)))))
  nil)

;;
(defun my-c-mode-common-hook ()
  (font-lock-add-keywords  nil
                           '((my-c-mode-font-lock-if0 (0 font-lock-comment-face prepend))) 'add-to-end))


(defun my-beginning-of-line-dwim ()
  "Toggles between moving point to the first non-whitespace character, and
  the start of the line."
  (interactive)
  (let ((start-position (point)))
    ;; Move to the first non-whitespace character.
    (back-to-indentation)

    ;; If we haven't moved position, go to start of the line.
    (when (= (point) start-position)
      (move-beginning-of-line nil))))


(bind-key "C-a" #'my-beginning-of-line-dwim)
(bind-key "<home>"  #'my-beginning-of-line-dwim lisp-mode-map)


(use-package cc-mode
  :config (progn
            (add-hook 'c-mode-common-hook #'my-c-mode-common-hook)

            (bind-key "M-?"   #'semantic-analyze-proto-impl-toggle c-mode-base-map)
            (bind-key "M-."   #'semantic-ia-fast-jump c-mode-base-map)
            (bind-key "C-M-." #'semantic-complete-jump c-mode-base-map)
            (bind-key "M-r"   #'semantic-symref-symbol c-mode-base-map)
            (bind-key "M-,"   #'pop-global-mark c-mode-base-map)
            (bind-key "<home>"  #'my-beginning-of-line-dwim c-mode-map)

            (add-to-list 'auto-mode-alist '("\\.inl\\'" . c++-mode))
            ;; No, really. I want `#preprocessor' stuff in column zero.
            (setq c-electric-pound-behavior '(alignleft))
            ))

(dolist (major-mode '(c-mode c++-mode))
  (font-lock-add-keywords major-mode
                          `((,(concat
                               "\\<[_a-zA-Z][_a-zA-Z0-9]*\\>"       ; Object identifier
                               "\\s *"                              ; Optional white space
                               "\\(?:\\.\\|->\\)"                   ; Member access
                               "\\s *"                              ; Optional white space
                               "\\<\\([_a-zA-Z][_a-zA-Z0-9]*\\)\\>" ; Member identifier
                               "\\s *"                              ; Optional white space
                               "(")                                 ; Paren for method invocation
                             1 'font-lock-function-name-face t))))


(use-package company-anaconda
  :ensure t)

(use-package company-math
  :ensure t)

(use-package company-auctex
  :ensure t)

(use-package company
  :ensure t
  :bind (("C-<return>" . company-complete)
         ("M-/"        . company-dabbrev))

  :config (progn
            (setq company-tooltip-limit 20 ; bigger popup window
                  company-idle-delay 0.3   ; disable delay before autocompletion popup shows
                  company-echo-delay 0     ; remove blinking
                  ;;company-show-numbers t   ; show numbers for easy selection
                  company-selection-wrap-around t
                  company-dabbrev-ignore-case t
                  company-dabbrev-ignore-invisible t
                  company-dabbrev-other-buffers t
                  company-dabbrev-downcase nil
                  company-minimum-prefix-length 2
                  company-global-modes '(not sage-shell:sage-mode
                                             sage-shell-mode
                                             ein:notebook-multilang-mode
                                             ein:notebook-python-mode)
                  company-lighter-base "")

            (global-company-mode 1)

            (add-to-list 'company-backends #'company-c-headers)
            (add-to-list 'company-backends #'company-anaconda)

            (bind-key "C-n"   #'company-select-next company-active-map)
            (bind-key "C-p"   #'company-select-previous company-active-map)
            (bind-key "<tab>" #'company-complete company-active-map)
            (bind-key "M-?"   #'company-show-doc-buffer company-active-map)
            (bind-key "M-."   #'company-show-location company-active-map)
            (bind-key "M-/"   #'company-complete-common company-active-map)))

(use-package company-c-headers
  :ensure t
  :config (progn
            (defun my-ede-object-system-include-path ()
              "Return the system include path for the current buffer."
              (when ede-object
                (ede-system-include-path ede-object)))

            (setq company-c-headers-path-system #'my-ede-object-system-include-path)
            ))

(use-package company-quickhelp
  :ensure t
  :init (company-quickhelp-mode 1))

(use-package flycheck-pos-tip
  :ensure t)

(use-package flycheck
  :ensure t
  :commands global-flycheck-mode
  :init (global-flycheck-mode)
  :config (progn
            (setq flycheck-check-syntax-automatically '(save mode-enabled))
            (setq flycheck-standard-error-navigation nil)
            ;; flycheck errors on a tooltip (doesnt work on console)
            (when (display-graphic-p (selected-frame))
              (eval-after-load 'flycheck
                '(custom-set-variables
                  '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages)))
              )))

(use-package helm-flycheck              ; Helm frontend for Flycheck errors
  :ensure t
  :bind (("C-c e h" . helm-flycheck)))

(use-package ws-butler
  :ensure t
  :commands ws-butler-mode
  :init (progn
          (add-hook 'c-mode-common-hook 'ws-butler-mode)
          (add-hook 'python-mode-hook 'ws-butler-mode)
          (add-hook 'cython-mode-hook 'ws-butler-mode)))


(use-package magit
  :ensure t)
(global-set-key (kbd "<f7>") 'magit-status)


(use-package git-timemachine
  :ensure t)

(use-package undo-tree
  :ensure t
  :init
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)
    ))

; for Python
(use-package highlight-indentation
   :ensure t)


(use-package indent                     ; Built-in indentation
  :bind (("C-c x i" . indent-region)))

(define-key global-map (kbd "RET") 'newline-and-indent)

(use-package indent-guide
  :ensure t
  :config
  (add-hook 'prog-mode-hook (lambda () (indent-guide-mode)))
)

;;It's very difficult to remember all the shortcuts available in emacs. The =guide-key= plugin pops up a list of available
;;suggestions after a little while.

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :init
  (setq which-key-idle-delay 0.5)
  (which-key-mode)
)


(defun my-whitespace-mode-local ()
  "Enable `whitespace-mode' after local variables where set up."
  (add-hook 'hack-local-variables-hook #'whitespace-mode nil 'local))

(use-package whitespace                 ; Highlight bad whitespace
  :bind (("C-c t w" . whitespace-mode))
  :init (dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
          (add-hook hook #'my-whitespace-mode-local))
  :config
  ;; Highlight tabs, empty lines at beg/end, trailing whitespaces and overlong
  ;; portions of lines via faces.  Also indicate tabs via characters
  (setq whitespace-style '(tabs face indentation space-after-tab space-before-tab
     tab-mark empty trailing lines-tail)
        whitespace-line-column nil)     ; Use `fill-column' for overlong lines
  (set-face-background 'whitespace-tab nil)
  (set-face-background 'whitespace-space nil)
  (set-face-foreground 'whitespace-space "darkgray")
  ;;(setq whitespace-display-mappings
        ;; all numbers are Unicode codepoint in decimal. ⁖ (insert-char 182 1)
  ;;      '(
          ;;    (space-mark 32 [183] [46]) ; 32 SPACE 「 」, 183 MIDDLE DOT 「·」, 46 FULL STOP 「.」
  ;;        (newline-mark 10 [182 10]) ; 10 LINE FEED
          ;;    (tab-mark 9 [9655 9] [92 9]) ; 9 TAB, 9655 WHITE RIGHT-POINTING TRIANGLE 「▷」
   ;;       ))
  :diminish (whitespace-mode . " ⓦ"))


;(use-package hl-line                    ; Highlight the current line
;  :init (global-hl-line-mode 1))
;(set-face-attribute 'whitespace-space nil :background nil :foreground "darkgray")

(defun my-fixme-highlight ()
  (font-lock-add-keywords nil
                          '(("\\<\\(FIXME\\|BUG\\|TODO\\|HACK\\)" 1
                             font-lock-warning-face t))))

(add-hook 'prog-mode-hook #'my-fixme-highlight)
(add-hook 'python-mode-hook #'my-fixme-highlight)

;; force semantic parsing
(defvar my-c-files-regex ".*\\.\\(c\\|cpp\\|h\\|hpp\\)"
  "A regular expression to match any c/c++ related files under a directory")

(defun my-semantic-parse-dir (root regex)
  "This function is an attempt of mine to force semantic to
     parse all source files under a root directory. Arguments:
     -- root: The full path to the root directory
     -- regex: A regular expression against which to match all files in the directory"
  (let (
        ;;make sure that root has a trailing slash and is a dir
        (root (file-name-as-directory root))
        (files (directory-files root t ))
        )
    ;; remove current dir and parent dir from list
    (setq files (delete (format "%s." root) files))
    (setq files (delete (format "%s.." root) files))
    (while files
      (setq file (pop files))
      (if (not(file-accessible-directory-p file))
          ;;if it's a file that matches the regex we seek
          (progn (when (string-match-p regex file)
                   (save-excursion
                     (semanticdb-file-table-object file))
                   ))
        ;;else if it's a directory
        (my-semantic-parse-dir file regex)
        )
      )
    )
  )

(defun my-semantic-parse-current-dir (regex)
  "Parses all files under the current directory matching regex"
  (my-semantic-parse-dir (file-name-directory(buffer-file-name)) regex))

(defun my-parse-curdir-c ()
  "Parses all the c/c++ related files under the current directory
     and inputs their data into semantic"
  (interactive)
  (my-semantic-parse-current-dir my-c-files-regex))

(defun my-parse-dir-c (dir)
  "Prompts the user for a directory and parses all c/c++ related files
     under the directory"
  (interactive (list (read-directory-name "Provide the directory to search in:")))
  (my-semantic-parse-dir (expand-file-name dir) my-c-files-regex))


(defvar my-popup-windows '("\\`\\*helm flycheck\\*\\'"
                             "\\`\\*Flycheck errors\\*\\'"
                             "\\`\\*helm projectile\\*\\'"
                             "\\`\\*Helm all the things\\*\\'"
                             "\\`\\*Helm Find Files\\*\\'"
                             "\\`\\*Help\\*\\'"
                             "\\`\\*anaconda-doc\\*\\'"
                             "\\`\\*Google Translate\\*\\'"
                             "\\` \\*LanguageTool Errors\\* \\'"))

(dolist (name my-popup-windows)
  (add-to-list 'display-buffer-alist
               `(,name
                 (display-buffer-reuse-window
                  display-buffer-in-side-window)
                 (reusable-frames . visible)
                 (side            . bottom)
                 ;; height only applies when golden-ratio-mode is off
                 (window-height   . 0.3))))

(defun my-quit-bottom-side-windows ()
  "Quit side windows of the current frame."
  (interactive)
  (dolist (window (window-at-side-list))
    (quit-window nil window)))

(bind-key "C-§" #'my-quit-bottom-side-windows)



(use-package latex-preview-pane
  :diminish latex-preview-pane-mode
  :ensure t
  :config (progn
            (setq latex-preview-pane-multifile-mode (quote auctex))))

;; ORG
(setq org-directory "~/org/")
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c b") 'org-iswitchb)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c o")
                (lambda () (interactive) (find-file "~/org/urgent.org")))
;;(setq org-default-notes-file "~/org/notes.org")

;;(setq org-refile-targets '((org-agenda-files . (:maxlevel . 6))))

(setq org-log-done nil)
(setq org-log-into-drawer t)
(setq org-todo-keywords '((sequence "TODO(t)" "|" "STALLED(s)" "DONE(d)")))
(setq org-reverse-note-order t)
(setq org-refile-use-outline-path 'file)
(setq org-refile-allow-creating-parent-nodes 'confirm)
(setq org-refile-targets '(("~/org/tasks.org" . (:maxlevel . 10))
                           ("~/org/urgent.org" . (:maxlevel . 2))
                           ("~/org/schedule.org" . (:maxlevel . 2))))
(setq org-blank-before-new-entry nil)

(setq org-agenda-custom-commands
    (quote
     (("r" "Daily Review"
       ((agenda "" nil)
        (tags-todo "URGENT" nil)
        (tags-todo "+TODO=\"TODO\"+PRIORITY<>\"\"+@HOME" nil)
        (tags-todo "+TODO=\"TODO\"+PRIORITY<>\"\"+@COMPUTER" nil)
        (tags-todo "+TODO=\"TODO\"+PRIORITY<>\"\"+@BUY" nil)
        (tags-todo "+TODO=\"TODO\"+PRIORITY<>\"\"+@TRIP" nil)
        (tags-todo "+TODO=\"TODO\"+PRIORITY<>\"\"+@MEETING" nil)
        (tags-todo "+TODO=\"TODO\"+PRIORITY<>\"\"-@HOME-@COMPUTER-@BUY-@TRIP-@MEETING-URGENT" nil)
        (tags-todo "TODO=\"STALLED\"" nil))
       nil
       ("~/tmp/daily-agenda.html"))
      ("w" "Weekly Review"
       ((tags "PROJECT" nil)
        (tags "BACKGROUNDPROJECT" nil)
        (tags "FUTUREPROJECT" nil)
        (tags "GOAL" nil))
       ((org-tags-exclude-from-inheritance (quote ("PROJECT" "FUTUREPROJECT" "BACKGROUNDPROJECT" "GOAL"))))
       ("~/tmp/weekly-agenda.html")))))

(setq org-agenda-files
    (quote ("~/org/schedule.org"
            "~/org/tasks.org"
            "~/org/urgent.org")))
(setq org-agenda-ndays 7)
(setq org-agenda-show-all-dates t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-sorting-strategy
      (quote ((agenda habit-down time-up priority-down category-keep)
              (todo category-down priority-down)
              (tags priority-down category-keep)
              (search category-keep))))
(setq org-agenda-start-on-weekday nil)
(setq org-capture-templates
      (quote (("t" "Task" entry (file "~/org/urgent.org") "* TODO %^{Task} CREATED: %U %?")
              ("r" "Referenced Task" entry (file "~/org/urgent.org") "* TODO %^{Task} CREATED: %U %? %a")
              ("l" "Log entry" entry (file+datetree "~/org/schedule.org") "* %^{Summary} %?")
              ("p" "Post/Predated log entry" entry (file+datetree+prompt "~/org/schedule.org") "* %^{Summary} %?")
              ("s" "Schedule entry" entry (file+datetree+prompt "~/org/schedule.org") "* %^T %?"))))
(setq org-default-notes-file "~/org/urgent.org")
(setq org-tags-column -100)
;;(setq org-tags-exclude-from-inheritance (quote ("GOAL" "FUTUREPROJECT" "PROJECT" "BACKGROUNDPROJECT")))



(use-package ob

  :config (progn
            ;; load more languages for org-babel
            (org-babel-do-load-languages
             'org-babel-load-languages
             '(
               (calc . t)
               (python . t)
               (sh . t)
               (ditaa . nil)
               (clojure . nil)
               (plantuml . nil)))

            (setq org-confirm-babel-evaluate nil)

            ))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)
