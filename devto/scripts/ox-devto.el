(require 'ox-jekyll-md)

(setq org-publish-timestamp-directory "./.org-timestamps")

(setq org-jekyll-md-layout nil)
(setq org-jekyll-md-include-yaml-front-matter t)

(defun export-org-devto-files ()
  (let ((org-publish-project-alist `(("devto"
                                      :recursive t
                                      :base-directory "articles"
                                      :base-extension "org"
                                      :publishing-directory "public/"
                                      :publishing-function org-jekyll-md-publish-to-md))))
    (org-publish-all t)))
