;; Time-stamp: <2022-07-26 21:28:04 pi>
;; Author: Kaushal Modi

;; Global variables
;; https://www.reddit.com/r/emacs/comments/3kqt6e/2_easy_little_known_steps_to_speed_up_emacs_start/
(defvar modi/gc-cons-threshold--orig gc-cons-threshold)
(setq gc-cons-threshold (* 100 1024 1024)) ;100 MB before garbage collection

(defvar user-home-directory (file-name-as-directory (getenv "HOME")))
(setq user-emacs-directory (file-name-as-directory (expand-file-name ".emacs.d" user-home-directory)))

(defconst my-packages
  '(ace-window
    adaptive-wrap ; indented line wrapping
    ag wgrep wgrep-ag s ; ag > ack > grep
                                        ; wgrep+wgrep-ag allow editing files
                                        ; directly in ag buffer
    all all-ext ; edit ALL lines matching regex
    anzu   ; shows total search hits in mode line, > query-replace
    ascii-art-to-unicode
    auto-complete fuzzy
    auto-highlight-symbol
    avy ; > ace-jump-mode
    beacon ; visual flash to show the cursor position
    buffer-move
    diff-hl
    dired-single dired-collapse
    drag-stuff
    easy-escape ; Make the \\ escape chars more pleasant looking in elisp regexps
    expand-region
    fill-column-indicator
    fold-this
    gist
    git-timemachine ; walk through git revisions
    ggtags ctags-update
    htmlize
    hungry-delete
    ibuffer-projectile
    imenu-list
    indent-guide
    isend-mode ; used in setup-perl.el
    swiper counsel
    key-chord ; map pairs of simultaneously pressed keys to commands
    magit ; for git management
    manage-minor-mode
    markdown-mode
    minibuffer-line
    multi-term
    multiple-cursors
    paradox ; package menu improvements
    page-break-lines ; Convert the ^L (form feed) chars to horizontal lines
    pomodoro
    rainbow-delimiters
    rainbow-mode
    region-bindings-mode ; complements really well with multiple-cursors
    shackle
    smart-compile
    smart-mark
    smart-mode-line popup rich-minority
    sunshine forecast ; weather
    sx
    tiny
    tldr                ;Concise "man pages"
    transpose-frame ; for the priceless `rotate-frame' and `transpose-frame'
    ;; undo-tree ; supercool undo visualization
    use-package use-package-chords ; optimize package loading
    visual-regexp
    ;; volatile-highlights
    webpaste   ; Paste code snippets to ptpb.pw (default), ix.io, etc.
    which-key ; > guide-key
    wrap-region ; wrap selection with punctuations, tags (org-mode, markdown-mode, ..)
    writegood-mode ; highlight passive voice, weasel words and duplicates
    yafolding ; indentation detected code folding
    yaml-mode ; Useful for editing Octopress' _config.yml
    yasnippet
    zop-to-char

    ;; Themes
    ;; zenburn-theme ; < fork
    ;; smyx-theme ; < fork
    ample-theme ; ample, ample-flat, ample-light
    darktooth-theme ; coffee
    leuven-theme ; awesome white background theme
    planet-theme ; dark blue
    tao-theme ; monochrome
    twilight-bright-theme
    twilight-anti-bright-theme
    ;; Crypt
    ;; nlinum ; better performance than linum ; Sticking to frozen version 1.7 in my config
    ;; bookmark+ ; able to bookmark desktop sessions
    ;; ox-twbs ; export to twitter bootstrap html < fork (supports org 9.0+)
    ;; ox-reveal ; used to export to HTML slides; < git clone
    ;; git-link ; get git links with line numbers and commit-hash/branch ; < fork
    ;; ido-vertical-mode flx-ido ido-ubiquitous ; < ivy, counsel
    ;; git-gutter git-gutter-fringe git-gutter+ git-gutter-fringe+ ; < diff-hl
    ;; popwin ; < shackle
    ;; helm helm-swoop ; < swiper
    ;; helm-gtags ; < ggtags
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

(eval-when-compile
  (require 'use-package)                ;Auto-requires `bind-key' too
  (setq use-package-always-ensure nil))
(require 'use-package-chords)

(use-package benchmark-init
  :demand t
  :load-path "elisp/manually-synced/benchmark-init-el"
  :config
  (progn
    ;; https://github.com/dholm/benchmark-init-el/issues/15#issuecomment-766010566
    (require 'benchmark-init-modes)     ;Explicitly required
    (add-hook 'after-init-hook #'benchmark-init/deactivate)))

;; Enable `modi-mode' unless `disable-pkg-modi-mode' is set to `t' in
;; `setup-var-overrides.el'.
(when (not (bound-and-true-p disable-pkg-modi-mode))
  (require 'modi-mode))
(require 'temp-mode)

(require 'setup-paradox)
(require 'setup-region-bindings-mode)
(require 'setup-key-chord)
(require 'setup-tags)
;; End of basic requires

;; Set up the looks of emacs
(require 'setup-mode-line)
(require 'setup-visual)
(require 'setup-shackle)

;; Set up packages
(require 'setup-abbrev)
(require 'setup-ace-window)
(when (executable-find "ag")
  (require 'setup-ag))
(require 'setup-all)
(require 'setup-artist)
(require 'setup-auto-complete)
;; Wed Jun 10 16:10:59 EDT 2020 - kmodi
;; Disabling beacon-mode to see if that solves minor performance glitches
;; (require 'setup-beacon)
(require 'setup-bookmarks)
(require 'setup-buffer-move)
(require 'setup-c)
(require 'setup-counsel)
(require 'setup-de-ansify)
(require 'setup-devdocs)
(require 'setup-dired)
(require 'setup-drag-stuff)
(when (executable-find "tmux")
  (require 'setup-emamux))
(require 'setup-expand-region)
;; Below will cause emacs to freeze on evaluating "(string-match-p "." nil)"
;; on emacs 25.1 or older.
;; http://debbugs.gnu.org/cgi/bugreport.cgi?bug=23949
(require 'setup-fci)
(require 'setup-fold)
(require 'setup-gist)
(when (executable-find "git")
  (require 'setup-diff)
  (require 'setup-git-link)
  (require 'setup-git-timemachine)
  (require 'setup-magit))
(require 'setup-header2)
(require 'setup-highlight)
(require 'setup-htmlize)
(require 'setup-hungry-delete)
(require 'setup-ibuffer)
(require 'setup-imenu-list)
(require 'setup-indent-guide)
(require 'setup-info)
(require 'setup-linum)
(require 'setup-manage-minor-mode)
(require 'setup-mastodon)
(require 'setup-multiple-cursors)
(require 'setup-news)
(require 'setup-outshine)
(when (executable-find "p4")
  (require 'setup-p4))
(require 'setup-page-break-lines)
(require 'setup-pcache)
(require 'setup-pomodoro)
(with-eval-after-load 'setup-tags
  ;; Below causes `help-function-arglist' error on evaluating "(string-match-p "." nil)"
  ;; on emacs 25.1 or older.
  ;; http://debbugs.gnu.org/cgi/bugreport.cgi?bug=23949
  (require 'setup-projectile))
(require 'setup-rainbow-delimiters)
(require 'setup-rainbow-mode)
(when (executable-find "rg")
  (require 'setup-rg))
(require 'setup-server)
(require 'setup-sx)
(require 'setup-term)
(require 'setup-tiny)
(require 'setup-tldr)
;; (require 'setup-undo-tree)
(require 'setup-webpaste)
(require 'setup-which-func)
(require 'setup-which-key)
(require 'setup-wrap-region)
(require 'setup-writegood)
(require 'setup-yasnippet)

;; Languages
(require 'setup-conf)
(require 'setup-elisp)
(when (executable-find "go")
  (require 'setup-go))
(require 'setup-latex)
(require 'setup-markdown)
(when (executable-find "matlab")
  (require 'setup-matlab))
(when (executable-find "nim")
  (require 'setup-nim))
(require 'setup-perl)
(require 'setup-python)
(require 'setup-shell)
(require 'setup-spice)
(when (executable-find "sml")
  (require 'setup-sml))
(require 'setup-tcl)
(require 'setup-verilog)
(require 'setup-yaml-mode)

(>=e "25.1"
    nil       ; Emacs 25.1 has `M-.' bound to `xref-find-definitions' by default
                                        ; which works better than elisp-slime-nav
  (require 'setup-elisp-slime-nav))

;; Blend of other setup
(require 'setup-backup)
(require 'setup-compile)
(require 'setup-editing)
(require 'setup-image)
(require 'setup-launcher)
(require 'setup-mouse)
(require 'setup-navigation)
(require 'setup-pdf)
(require 'setup-print)
(require 'setup-registers)
(require 'setup-search)
(when (or (executable-find "aspell")
          (executable-find "hunspell"))
  (require 'setup-spell))
(require 'setup-toggles)
(require 'setup-unicode)
(require 'setup-windows-buffers)

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

(when modi/gc-cons-threshold--orig
  (run-with-idle-timer 5 nil (lambda () (setq gc-cons-threshold modi/gc-cons-threshold--orig))))
