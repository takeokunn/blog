(require 'ox-jekyll-md)

(setq org-publish-timestamp-directory "./.org-timestamps")

(defun org-devto--yaml-front-matter (info)
  "dev.to 用の YAML front matter を生成"
  (let ((title (org-export-data (plist-get info :title) info))
        (published (plist-get info :devto-published))
        (tags (plist-get info :devto-tags))
        (description (plist-get info :description)))
    (concat "---\n"
            (format "title: \"%s\"\n" title)
            (format "published: %s\n" (or published "false"))
            (when tags (format "tags: %s\n" tags))
            (when description (format "description: %s\n" description))
            "---\n\n")))

(defun org-devto-template (contents info)
  "dev.to 用のテンプレート関数"
  (concat (org-devto--yaml-front-matter info)
          contents))

(defun org-devto-src-block (src-block _contents info)
  "GFM 形式のコードブロックを生成（Jekyll の highlight 形式ではなく）"
  (let ((lang (org-element-property :language src-block))
        (code (org-export-format-code-default src-block info)))
    (format "```%s\n%s```\n" (or lang "") code)))

;; ox-jekyll-md を継承して devto バックエンドを定義
(org-export-define-derived-backend 'devto 'jekyll
  :options-alist
  '((:devto-published "PUBLISHED" nil "false" t)
    (:devto-tags "TAGS" nil nil t)
    (:description "DESCRIPTION" nil nil t))
  :translate-alist
  '((template . org-devto-template)
    (src-block . org-devto-src-block)))

(defun org-devto-export-to-md (&optional async subtreep visible-only)
  "現在のバッファを dev.to 用 markdown ファイルにエクスポート"
  (interactive)
  (let ((outfile (org-export-output-file-name ".md" subtreep)))
    (org-export-to-file 'devto outfile async subtreep visible-only)))

(defun org-devto-publish-to-md (plist filename pub-dir)
  "org ファイルを dev.to 用 markdown にパブリッシュ"
  (org-publish-org-to 'devto filename ".md" plist pub-dir))

(defun export-org-devto-files ()
  (let ((org-publish-project-alist `(("devto"
                                      :recursive t
                                      :base-directory "articles"
                                      :base-extension "org"
                                      :publishing-directory "public/"
                                      :publishing-function org-devto-publish-to-md))))
    (org-publish-all t)))
