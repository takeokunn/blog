(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-refresh-contents)
(package-initialize)
(package-install 'ox-hugo)

(require 'ox-hugo)

(defun export-org-files ()
  "Re-exports all Org-roam files to Hugo markdown."
  (interactive)
  (dolist (f (append (file-expand-wildcards "org/*.org")
                     (file-expand-wildcards "org/**/*.org")))
    (with-current-buffer (find-file f)
      (org-hugo-export-wim-to-md))))

;; (export-org-files)
