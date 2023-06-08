;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "kalashnikov66p"
      user-mail-address "kalashnikov66@proton.me")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
(setq doom-font (font-spec :family "JetBrains Mono" :size 13 :weight 'semi-light))

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(after! solidity-mode
  (setq solidity-solc-path "/opt/solidity/solc/solc"
        solidity-solium-path "/usr/bin/solium"))

(after! org-roam
  (setq org-roam-directory "~/org/roam/"
        org-roam-capture-templates
        '(("d" "Default" plain
           "%?"
           :if-new (file+head "${slug}.org" "#+title: ${title}\n#+date: %<%Y-%m-%d>\n* ${title}\n%?")
           :unarrowed t)))

  (org-roam-db-autosync-mode t))

(after! citar
  (setq citar-bibliography '("~/org/bib/mylib.bib")))

(after! bibtex-completion
  (setq bibtex-completion-notes-path "~/org/roam/"
        bibtex-completion-bibliography '("~/org/bib/mylib.bib")
        bibtex-completion-pdf-field "file"
        bibtex-completion-notes-template-multiple-files
        (concat
         "#+title: ${title}\n"
         "#+roam_key: cite:${=key=}\n"
         "#+roam_tags: ${keywords}\n"
         "* TODO Notes\n"
         ":PROPERTIES:\n"
         ":Custom_ID: ${=key=}\n"
         ":NOTER_DOCUMENT: ${file}\n"
         ":AUTHOR: ${author-abbrev}\n"
         ":JOURNAL: ${journaltitle}\n"
         ":DATE: ${date}\n"
         ":YEAR: ${year}\n"
         ":DOI: ${doi}\n"
         ":URL: ${url}\n"
         ":END:\n\n")))

(after! tex
  (setq reftex-default-bibliography "~/bib/mylib.bib"))

(use-package! org-ref
  :config
  (setq org-ref-completion-library 'org-ref-ivy-cite
        org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex
        org-ref-notes-directory "~/org/roam/"
        org-ref-notes-function 'orb-edit-notes
        org-ref-note-title-format
        (concat
         "* TODO %y - %t\n"
         "  :PROPERTIES:\n"
         "  :Custom_ID: %k\n"
         "  :NOTER_DOCUMENT: %F\n"
         "  :ROAM_KEY: cite:%k\n"
         "  :AUTHOR: %9a\n"
         "  :JOURNAL: %j\n"
         "  :YEAR: %y\n"
         "  :VOLUME: %v\n"
         "  :PAGES: %p\n"
         "  :DOI: %D\n"
         "  :URL: %U\n"
         "  :END:\n\n")))

(use-package! org-roam-bibtex
  :after org-roam
  :hook (org-roam-mode . org-roam-bibtex-mode)
  :config
  (setq org-roam-bibtex-preformat-keywords
        '("=key=" "title" "file" "author-or-editor" "keywords")
        orb-process-file-keyword t
        orb-process-file-field t
        orb-attached-file-extensions '("pdf"))
  (setq orb-templates
        '(("r" "ref" plain (function org-roam-capture--get-point)
           ""
           :file-name "${slug}"
           :head (concat
                  "#+title: ${=key=}: ${title}\n"
                  "#+roam_key: ${ref}\n"
                  "#+roam_tags:\n\n"
                  "- keywords :: ${keywords}\n\n"
                  "* ${title}\n"
                  "  :PROPERTIES:\n"
                  "  :Custom_ID: ${=key=}\n"
                  "  :URL: ${url}\n"
                  "  :AUTHOR: ${author-or-editor}\n"
                  "  :NOTER_DOCUMENT: ${file}\n"
                  "  :NOTER_PAGE: \n"
                  "  :END:\n\n")
           :unnarrowed t))))

(use-package! org-noter
  :after (:any org pdf-view org-roam-bibtex)
  :config
  (setq org-noter-notes-window-location 'other-frame
        org-noter-always-create-frame nil
        org-noter-hide-other nil
        org-noter-notes-search-path '("~/org/roam/")))

(use-package! elcord
  :init (elcord-mode))

(use-package! treemacs
  :bind ("M-0" . treemacs-select-window))
