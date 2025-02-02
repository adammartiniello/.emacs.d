;; Time-stamp: <2022-07-26 21:28:04 pi>
;; Author: Kaushal Modi

;; Global variables
;; https://www.reddit.com/r/emacs/comments/3kqt6e/2_easy_little_known_steps_to_speed_up_emacs_start/
(defvar modi/gc-cons-threshold--orig gc-cons-threshold)
(setq gc-cons-threshold (* 100 1024 1024)) ;100 MB before garbage collection

(defvar user-home-directory (file-name-as-directory (getenv "HOME")))
(setq user-emacs-directory (file-name-as-directory (expand-file-name ".emacs.d" user-home-directory)))

(defconst my-packages
  '(adaptive-wrap ; indented line wrapping
    ag wgrep wgrep-ag s ; ag > ack > grep
                                        ; wgrep+wgrep-ag allow editing files
                                        ; directly in ag buffer
    all all-ext ; edit ALL lines matching regex
    anzu   ; shows total search hits in mode line, > query-replace
    auto-complete fuzzy
    auto-highlight-symbol
    buffer-move
    diff-hl
    git-timemachine ; walk through git revisions
    ibuffer-projectile
    imenu-list
    swiper counsel
    key-chord ; map pairs of simultaneously pressed keys to commands
    magit ; for git management
    markdown-mode
    multiple-cursors
    region-bindings-mode ; complements really well with multiple-cursors
    smart-mode-line popup rich-minority
    use-package use-package-chords ; optimize package loading
    visual-regexp
    which-key ; > guide-key
    yafolding ; indentation detected code folding
    yaml-mode ; Useful for editing Octopress' _config.yml
    yasnippet

    ;; nlinum ; better performance than linum ; Sticking to frozen version 1.7 in my config
    ;; git-link ; get git links with line numbers and commit-hash/branch ; < fork
    ;; git-gutter git-gutter-fringe git-gutter+ git-gutter-fringe+ ; < diff-hl
    ;; helm helm-swoop ; < swiper
    ;; projectile ; Better than fiplr < fork
    )
  "A list of packages to ensure are installed at launch")

;; Basic requires
(require 'subr-x)                       ;For when-let*, if-let*, ..

(load (locate-user-emacs-file "general.el") nil :nomessage)
(load (locate-user-emacs-file "setup-packages.el") nil :nomessage)
;; (package-initialize) ; Do NOT delete this comment
;;   In emacs 25+, the `package-initialize' call is auto-added to the top of
;; init.el unless the user already has a commented or uncommented
;; `(package-initialize)' line present in their init.el.
;;   I call this function in setup-packages.el and so am keeping the
;; commented out version here so that package.el does not add it again.

(require 'use-package-chords)

;; Enable `modi-mode' unless `disable-pkg-modi-mode' is set to `t' in
;; `setup-var-overrides.el'.
(when (not (bound-and-true-p disable-pkg-modi-mode))
  (require 'modi-mode))

(require 'setup-region-bindings-mode)
(require 'setup-key-chord)
;; End of basic requires

;; Set up the looks of emacs
(require 'setup-mode-line)
(require 'setup-visual)

;; Set up packages
(require 'setup-abbrev)
(when (executable-find "ag")
  (require 'setup-ag))
(require 'setup-all)
(require 'setup-auto-complete)
(require 'setup-c)
(require 'setup-counsel)
(require 'setup-de-ansify)
(when (executable-find "tmux")
  (require 'setup-emamux))
(when (executable-find "git")
  (require 'setup-diff)
  (require 'setup-git-link)
  (require 'setup-git-timemachine)
  (require 'setup-magit))
(require 'setup-ibuffer)
(require 'setup-imenu-list)
(require 'setup-linum)
(require 'setup-multiple-cursors)
(with-eval-after-load 'setup-tags
  ;; Below causes `help-function-arglist' error on evaluating "(string-match-p "." nil)"
  ;; on emacs 25.1 or older.
  ;; http://debbugs.gnu.org/cgi/bugreport.cgi?bug=23949
  (require 'setup-projectile))
(when (executable-find "rg")
  (require 'setup-rg))
(require 'setup-which-func)
(require 'setup-which-key)
(require 'setup-yasnippet)

;; Languages
(require 'setup-markdown)
(when (executable-find "matlab")
  (require 'setup-matlab))
(when (executable-find "nim")
  (require 'setup-nim))
(require 'setup-python)
(require 'setup-shell)
(require 'setup-tcl)
(require 'setup-verilog)
(require 'setup-yaml-mode)

;; Blend of other setup
(require 'setup-editing)
(require 'setup-mouse) ; mouse scrolling
(require 'setup-navigation) ; mouse scrolling
(require 'setup-registers)
(require 'setup-search)

;; The `setup-misc' must be the last package to be required except for
;; `setup-desktop'.
(require 'setup-misc)

;; Delay desktop setup by a second.
;; - This speeds up emacs init, and
;; - Also (n)linum and other packages would already be loaded which the files
;;   being loaded from the saved desktop might need.
(use-package setup-desktop :defer 1)

(defun modi/font-check ()
  "Do font check, then remove self from `focus-in-hook'; need to run this just once."
  (require 'setup-font-check)
  (remove-hook 'focus-in-hook #'modi/font-check))
;; http://lists.gnu.org/archive/html/help-gnu-emacs/2016-05/msg00148.html
;; For non-daemon, regular emacs launches, the frame/fonts are loaded *before*
;; the emacs config is read.
;;
;; But when emacs is launched as a daemon (using emacsclient, the fonts are not
;; actually loaded until the point when the `after-make-frame-functions' hook is
;; run.
;;
;; But even at that point, the frame is not yet selected (for the daemon
;; case). Without a selected frame, the `find-font' will not work correctly!
;;
;; So we do the font check in `focus-in-hook' instead, by which time in the
;; emacs startup process, all of the below are true:
;;  - Fonts are loaded (in both daemon and non-daemon cases).
;;  - The frame is also selected, and so `find-font' calls work correctly.
(add-hook 'focus-in-hook #'modi/font-check)

(when (and (bound-and-true-p emacs-initialized)
           (featurep 'setup-visual))
  (funcall default-theme-fn)) ; defined in `setup-visual.el'

(setq emacs-initialized t)
