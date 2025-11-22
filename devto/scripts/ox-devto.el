;;; ox-devto.el --- Export Org files to dev.to Article Sync format -*- lexical-binding: t; -*-

;; Copyright (C) 2025 takeokunn
;; Author: takeokunn
;; Version: 1.0.0
;; Package-Requires: ((emacs "27.1") (ox-jekyll-md "0.0.1"))
;; Keywords: org, markdown, dev.to
;; URL: https://github.com/takeokunn/blog

;;; Commentary:

;; This package provides an Org export backend for dev.to's Article Sync format.
;; It exports Org files to a directory structure compatible with the
;; calvinmclean/article-sync GitHub Action:
;;
;;   articles/{slug}/
;;     ├── article.json  (metadata: title, tags, published, description)
;;     └── article.md    (content in GitHub Flavored Markdown)
;;
;; Usage:
;;   (require 'ox-devto)
;;   (export-org-devto-files)

;;; Code:

;;;; Requirements

(require 'ox-jekyll-md)
(require 'json)

;;;; Customization

(defgroup org-devto nil
  "Options for exporting Org files to dev.to Article Sync format."
  :group 'org-export
  :prefix "org-devto-")

(defcustom org-devto-default-title "Untitled"
  "Default title when TITLE keyword is not specified."
  :type 'string
  :group 'org-devto)

(defcustom org-devto-articles-directory "articles"
  "Base directory for Org source files."
  :type 'string
  :group 'org-devto)

(defcustom org-devto-output-directory "articles/"
  "Output directory for Article Sync format files."
  :type 'string
  :group 'org-devto)

(defcustom org-devto-timestamp-directory "./.org-timestamps"
  "Directory for Org publish timestamps."
  :type 'string
  :group 'org-devto)

;;;; Internal Functions

;;;;; Slug Generation

(defun org-devto--generate-slug (title)
  "Generate URL slug from TITLE.
Non-alphanumeric characters are replaced with hyphens.
Leading and trailing hyphens are removed."
  (let ((slug (downcase title)))
    (setq slug (replace-regexp-in-string "[^a-z0-9]+" "-" slug))
    (setq slug (replace-regexp-in-string "^-+\\|-+$" "" slug))
    slug))

;;;;; Keyword Extraction

(defun org-devto--get-keyword (keyword)
  "Extract value of KEYWORD from current buffer.
KEYWORD should be an Org keyword name without the `#+' prefix."
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward
           (format "^#\\+%s:[ \t]*\\(.+\\)$" keyword) nil t)
      (string-trim (match-string 1)))))

(defun org-devto--get-title ()
  "Get article title from current buffer."
  (or (org-devto--get-keyword "TITLE")
      org-devto-default-title))

(defun org-devto--parse-tags (tags-string)
  "Parse TAGS-STRING into a list of trimmed tag strings.
TAGS-STRING should be comma-separated."
  (if tags-string
      (mapcar #'string-trim (split-string tags-string ","))
    []))

;;;;; JSON Generation

(defun org-devto--build-json-data (title tags description devto-id devto-slug)
  "Build JSON data alist for article.json.
TITLE, TAGS, and DESCRIPTION are article metadata.
DEVTO-ID is the dev.to article ID from Org property.
DEVTO-SLUG is the dev.to article slug from Org property."
  `((title . ,title)
    (tags . ,(vconcat tags))
    ,@(when description `((description . ,description)))
    ,@(when devto-id `((id . ,(string-to-number devto-id))))
    ,@(when devto-slug `((slug . ,devto-slug)))))

(defun org-devto--write-article-json (slug pub-dir)
  "Generate article.json in PUB-DIR/SLUG directory.
Returns the article directory path."
  (let* ((title (org-devto--get-title))
         (tags (org-devto--parse-tags (org-devto--get-keyword "TAGS")))
         (description (org-devto--get-keyword "DESCRIPTION"))
         (devto-id (org-devto--get-keyword "DEVTO_ID"))
         (devto-slug (org-devto--get-keyword "DEVTO_SLUG"))
         (article-dir (expand-file-name slug pub-dir))
         (json-file (expand-file-name "article.json" article-dir))
         (json-data (org-devto--build-json-data
                     title tags description devto-id devto-slug)))
    (unless (file-directory-p article-dir)
      (make-directory article-dir t))
    (with-temp-file json-file
      (insert (json-encode json-data))
      (json-pretty-print-buffer))
    article-dir))

;;;; Export Backend

(defun org-devto--template (contents _info)
  "Return CONTENTS without front matter.
INFO is the export communication channel (unused)."
  contents)

(defun org-devto--src-block (src-block _contents info)
  "Transcode SRC-BLOCK to GitHub Flavored Markdown code block.
CONTENTS is nil.  INFO is the export communication channel."
  (let ((lang (org-element-property :language src-block))
        (code (org-export-format-code-default src-block info)))
    (format "```%s\n%s```\n" (or lang "") code)))

(org-export-define-derived-backend 'devto 'jekyll
  :options-alist
  '((:devto-tags "TAGS" nil nil t)
    (:description "DESCRIPTION" nil nil t))
  :translate-alist
  '((template . org-devto--template)
    (src-block . org-devto--src-block)))

;;;; Public Functions

(defun org-devto-publish-to-article-sync (plist filename pub-dir)
  "Publish FILENAME to Article Sync format in PUB-DIR.
PLIST is the project property list."
  (let* ((visiting (find-buffer-visiting filename))
         (work-buffer (or visiting (find-file-noselect filename))))
    (unwind-protect
        (with-current-buffer work-buffer
          (let* ((title (org-devto--get-title))
                 (slug (org-devto--generate-slug title))
                 (article-dir (org-devto--write-article-json slug pub-dir))
                 (md-file (expand-file-name "article.md" article-dir)))
            (org-export-to-file 'devto md-file nil nil nil nil plist)
            md-file))
      (unless visiting (kill-buffer work-buffer)))))

(defun export-org-devto-files ()
  "Export all Org files in articles directory to Article Sync format."
  (setq org-publish-timestamp-directory org-devto-timestamp-directory)
  (let ((org-publish-project-alist
         `(("devto"
            :recursive t
            :base-directory ,org-devto-articles-directory
            :base-extension "org"
            :publishing-directory ,org-devto-output-directory
            :publishing-function org-devto-publish-to-article-sync))))
    (org-publish-all t)))

(provide 'ox-devto)
;;; ox-devto.el ends here
