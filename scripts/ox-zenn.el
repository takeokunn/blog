(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-refresh-contents)
(package-initialize)
(package-install 'ox-zenn)

(require 'ox-zenn)

(defun export-org-zenn-articles-files ()
  "Exports Org files to Zenn markdown."
  (interactive)
  (let ((org-publish-project-alist `(("zenn"
                                      :base-directory "org/zenn/articles"
                                      :base-extension "org"
                                      :publishing-directory "zenn/articles"
                                      :publishing-function org-zenn-publish-to-markdown))))
    (org-publish-all t)))

(defun export-org-zenn-books-files ()
  "Exports Org files to Zenn markdown."
  (interactive)
  (let ((org-publish-project-alist `(("zenn"
                                      :recursive t
                                      :base-directory "org/zenn/books"
                                      :base-extension "org"
                                      :publishing-directory "zenn/books"
                                      :publishing-function org-zenn-publish-to-markdown))))
    (org-publish-all t)))

(defun export-org-zenn-files ()
  (export-org-zenn-articles-files)
  (export-org-zenn-books-files))
