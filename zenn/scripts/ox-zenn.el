(require 'ox-zenn)

(setq org-publish-timestamp-directory "./.org-timestamps")

(defun export-org-zenn-articles-files ()
  "Exports Org files to Zenn markdown."
  (interactive)
  (let ((org-publish-project-alist `(("zenn"
                                      :base-directory "org/articles"
                                      :base-extension "org"
                                      :publishing-directory "public/articles"
                                      :publishing-function org-zenn-publish-to-markdown))))
    (org-publish-all t)))

(defun export-org-zenn-books-files ()
  "Exports Org files to Zenn markdown."
  (interactive)
  (let ((org-publish-project-alist `(("zenn"
                                      :recursive t
                                      :base-directory "org/books"
                                      :base-extension "org"
                                      :publishing-directory "public/books"
                                      :publishing-function org-zenn-publish-to-markdown))))
    (org-publish-all t)))

(defun export-org-zenn-files ()
  (export-org-zenn-articles-files)
  (export-org-zenn-books-files))
