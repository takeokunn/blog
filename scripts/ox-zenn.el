(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-refresh-contents)
(package-initialize)
(package-install 'ox-zenn)

(require 'ox-zenn)

(defun export-org-zenn-files ()
  "Exports Org files to Zenn markdown."
  (interactive)
  (let ((org-publish-project-alist `(("zenn"
                                      :base-directory "org/zenn/"
                                      :base-extension "org"
                                      :publishing-directory "zenn/"
                                      :publishing-function org-zenn-publish-to-markdown))))
    (org-publish-all t)))
